package com.presley.flexify

import android.annotation.SuppressLint
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.ServiceConnection
import android.content.SharedPreferences
import android.net.Uri
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import androidx.documentfile.provider.DocumentFile
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

@RequiresApi(Build.VERSION_CODES.O)
class MainActivity : FlutterActivity() {
    private var channel: MethodChannel? = null
    private var timerBound = false
    private var timerService: TimerService? = null
    private var savedPath: String? = null

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

    @SuppressLint("WrongConstant")
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
                    val alarmSound = call.argument<String>("alarmSound")
                    val vibrate = call.argument<Boolean>("vibrate")
                    timer(restMs, title!!, timestamp!!, alarmSound!!, vibrate!!)
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
                        intent.setPackage(applicationContext.packageName)
                        sendBroadcast(intent)
                    } else {
                        val timestamp = call.argument<Long>("timestamp")
                        val alarmSound = call.argument<String>("alarmSound")
                        val vibrate = call.argument<Boolean>("vibrate")
                        timer(1000 * 60, "Rest timer", timestamp!!, alarmSound!!, vibrate!!)
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

    private fun timer(
        durationMs: Int,
        description: String,
        timeStamp: Long,
        alarmSound: String,
        vibrate: Boolean
    ) {
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
        intent.putExtra("alarmSound", alarmSound)
        intent.putExtra("vibrate", vibrate)
        context.startForegroundService(intent)
    }

    private fun pick(path: String) {
        Log.d("MainActivity.pick", "dbPath=$path")
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
            val contentResolver = applicationContext.contentResolver
            val takeFlags: Int = Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
            contentResolver.takePersistableUriPermission(uri, takeFlags)

            if (requestCode == WRITE_REQUEST_CODE) {
                sharedPrefs.edit().apply {
                    putString("flutter.backupPath", uri.toString())
                    commit()
                }
                save()
            }
        }
    }

    private fun save() {
        val dbPath = sharedPrefs.getString("flutter.dbPath", null)
        val backupPath = sharedPrefs.getString("flutter.backupPath", null)
        val backupUri = Uri.parse(backupPath)
        Log.d("MainActivity.save", "dbPath=$dbPath,backupUri=$backupUri")

        val dbFile = File(dbPath!!)
        val dir = DocumentFile.fromTreeUri(context, backupUri)
        var file = dir?.findFile("flexify.sqlite")
        if (file == null) file = dir?.createFile("application/x-sqlite3", "flexify.sqlite")
        val outputStream = context.contentResolver.openOutputStream(file!!.uri)

        dbFile.inputStream().use { input ->
            outputStream?.use { output ->
                input.copyTo(output)
            }
        }
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
        const val FLUTTER_CHANNEL = "com.presley.flexify/android"
        const val WRITE_REQUEST_CODE = 43
        const val TICK_BROADCAST = "tick-event"
    }
}
