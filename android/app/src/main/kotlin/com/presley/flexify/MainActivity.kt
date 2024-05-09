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
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

@RequiresApi(Build.VERSION_CODES.O)
class MainActivity : FlutterActivity() {
    private var channel: MethodChannel? = null
    private var timerBound = false
    private var timerService: TimerService? = null
    private var savedPath: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        sharedPrefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        AlarmUtil.setRepeatingAlarm(context)
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
                    val duration = sharedPrefs.getLong("flutter.timerDuration", 0)
                    timer(duration.toInt(), title!!, timestamp!!)
                }

                "pick" -> {
                    val args = call.arguments as ArrayList<*>
                    pick(args[0] as String)
                }

                "getProgress" -> {
                    if (timerBound && timerService?.flexifyTimer?.isRunning() == true)
                        result.success(
                            intArrayOf(
                                timerService?.flexifyTimer!!.getRemainingSeconds(),
                                timerService?.flexifyTimer!!.getDurationSeconds()
                            )
                        )
                    else result.success(intArrayOf(0, 0))
                }

                "add" -> {
                    if (timerService?.flexifyTimer?.isRunning() == true) {
                        val intent = Intent(TimerService.ADD_BROADCAST)
                        sendBroadcast(intent)
                    } else {
                        val timestamp = call.argument<Long>("timestamp")
                        timer(1000 * 60, "Rest timer", timestamp!!)
                    }
                }

                "stop" -> {
                    val intent = Intent(TimerService.STOP_BROADCAST)
                    sendBroadcast(intent)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            applicationContext.registerReceiver(
                tickReceiver, IntentFilter(TICK_BROADCAST),
                RECEIVER_NOT_EXPORTED
            )
        } else {
            applicationContext.registerReceiver(tickReceiver, IntentFilter(TICK_BROADCAST))
        }
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

    private fun timer(duration: Int, description: String, timeStamp: Long) {
        Log.d("MainActivity", "Queue $description for $duration delay")
        val intent = Intent(context, TimerService::class.java).also { intent ->
            bindService(
                intent,
                timerConnection,
                Context.BIND_AUTO_CREATE
            )
        }
        intent.putExtra("milliseconds", duration)
        intent.putExtra("description", description)
        intent.putExtra("timeStamp", timeStamp)
        val alarmSound = sharedPrefs.getString("flutter.alarmSound", null)
        intent.putExtra("alarmSound", alarmSound)
        val vibrate = sharedPrefs.getBoolean("flutter.vibrate", true)
        intent.putExtra("vibrate", vibrate)
        context.startForegroundService(intent)
    }

    private fun pick(path: String) {
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE)
        sharedPrefs.edit().apply {
            putString("flutter.dbPath", path)
            commit()
        }

        savedPath = path
        activity.startActivityForResult(intent, WRITE_REQUEST_CODE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        data?.data?.also { uri ->
            if (requestCode == WRITE_REQUEST_CODE) {
                sharedPrefs.edit().apply {
                    putString("flutter.backupPath", uri.toString())
                    commit()
                }
                val intent = Intent(context, BackupReceiver::class.java)
                BackupReceiver().onReceive(context, intent)
                AlarmUtil.setRepeatingAlarm(context)
            }
        }
    }

    override fun onResume() {
        super.onResume()
        if (timerService?.flexifyTimer?.isRunning() != true) {
            val intent = Intent(TimerService.STOP_BROADCAST)
            sendBroadcast(intent);
        }
    }

    companion object {
        lateinit var sharedPrefs: SharedPreferences
        const val FLUTTER_CHANNEL = "com.presley.flexify/android"
        const val WRITE_REQUEST_CODE = 43
        const val TICK_BROADCAST = "tick-event"
    }
}
