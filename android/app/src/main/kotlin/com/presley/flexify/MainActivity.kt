package com.presley.flexify

import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.ServiceConnection
import android.content.SharedPreferences
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

@RequiresApi(Build.VERSION_CODES.O)
class MainActivity : FlutterActivity() {
    private var channel: MethodChannel? = null
    private var timerBound = false
    private var timerService: TimerService? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        sharedPrefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
    }

    private val timerConnection = object : ServiceConnection {
        override fun onServiceConnected(className: ComponentName, service: IBinder) {
            val binder = service as TimerService.LocalBinder
            timerService = binder.getService()
            timerBound = true
        }

        override fun onServiceDisconnected(arg0: ComponentName) {
            timerBound = false
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            FLUTTER_CHANNEL
        )
        channel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "timer" -> {
                    val title = call.argument<String>("title")
                    val timestamp = call.argument<Long>("timestamp")
                    val threeMinutesThirtySeconds = 210000
                    val restMs = call.argument<Int>("restMs") ?: threeMinutesThirtySeconds
                    timer(restMs, title!!, timestamp!!)
                }

                "add" -> {
                    if (timerService?.flexifyTimer?.isRunning() == true) {
                        val intent = Intent(TimerService.ADD_BROADCAST)
                        intent.setPackage(applicationContext.packageName)
                        sendBroadcast(intent)
                    } else {
                        val timestamp = call.argument<Long>("timestamp")
                        timer(1000 * 60, "Rest timer", timestamp!!)
                    }
                }

                "stop" -> {
                    Log.d("MainActivity", "Request to stop")
                    val intent = Intent(TimerService.STOP_BROADCAST)
                    intent.setPackage(applicationContext.packageName)
                    sendBroadcast(intent)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }

        ContextCompat.registerReceiver(
            applicationContext,
            tickReceiver, IntentFilter(TICK_BROADCAST),
            ContextCompat.RECEIVER_NOT_EXPORTED
        )
    }

    private val tickReceiver =
        object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                channel?.invokeMethod(
                    "tick",
                    timerService?.flexifyTimer?.generateMethodChannelPayload()
                )
            }
        }

    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        timerService?.apply {
            mainActivityVisible = hasFocus
            updateTimerNotificationRefreshRate()
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        applicationContext.unregisterReceiver(tickReceiver)
    }

    private fun timer(durationMs: Int, description: String, timeStamp: Long) {
        Log.d("MainActivity", "Queue $description for $durationMs delay")
        val intent = Intent(context, TimerService::class.java).also { intent ->
            bindService(
                intent,
                timerConnection,
                Context.BIND_AUTO_CREATE
            )
        }
        intent.putExtra("milliseconds", durationMs)
        intent.putExtra("description", description)
        intent.putExtra("timeStamp", timeStamp)
        val alarmSound = sharedPrefs.getString("flutter.alarmSound", null)
        intent.putExtra("alarmSound", alarmSound)
        val vibrate = sharedPrefs.getBoolean("flutter.vibrate", true)
        intent.putExtra("vibrate", vibrate)
        context.startForegroundService(intent)
    }

    override fun onResume() {
        super.onResume()
        if (timerService?.flexifyTimer?.isRunning() != true) {
            val intent = Intent(TimerService.STOP_BROADCAST)
            intent.setPackage(applicationContext.packageName)
            sendBroadcast(intent)
        }
    }

    companion object {
        lateinit var sharedPrefs: SharedPreferences
        const val FLUTTER_CHANNEL = "com.presley.flexify/timer"
        const val TICK_BROADCAST = "tick-event"
    }
}
