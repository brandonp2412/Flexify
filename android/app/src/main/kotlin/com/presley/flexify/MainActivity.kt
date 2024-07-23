package com.presley.flexify

import android.annotation.SuppressLint
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.ServiceConnection
import android.database.sqlite.SQLiteDatabase
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.Calendar

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
                    val title = call.argument<String>("title")!!
                    val timestamp = call.argument<Long>("timestamp")!!
                    val threeMinutesThirtySeconds = 210000
                    val restMs = call.argument<Int>("restMs") ?: threeMinutesThirtySeconds
                    val alarmSound = call.argument<String>("alarmSound")!!
                    val vibrate = call.argument<Boolean>("vibrate")!!
                    timer(restMs, title, timestamp, alarmSound, vibrate)
                }

                "pick" -> {
                    val dbPath = call.argument<String>("dbPath")!!
                    pick(dbPath)
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
        savedPath = path
        activity.startActivityForResult(intent, WRITE_REQUEST_CODE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        data?.data?.also { uri ->
            if (requestCode != WRITE_REQUEST_CODE) return

            val contentResolver = applicationContext.contentResolver
            val takeFlags: Int =
                Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
            contentResolver.takePersistableUriPermission(uri, takeFlags)
            Log.d("auto backup", "uri=$uri")

            val parentDir = filesDir.parentFile
            val dbFolder = File(parentDir, "app_flutter").absolutePath
            Log.d("auto backup", "dbFolder=$dbFolder")
            val dbPath = File(dbFolder, "flexify.sqlite").absolutePath;
            val db = SQLiteDatabase.openDatabase(dbPath, null, 0)

            val values = ContentValues().apply {
                put("backup_path", uri.path)
            }
            db.update("settings", values, null, null)
            db.close()

            val intent = Intent(context, BackupReceiver::class.java).apply {
                putExtra("dbPath", savedPath)
                putExtra("backupPath", uri.toString())
                setPackage(context.packageName)
            }
            sendBroadcast(intent)

            val pendingIntent = PendingIntent.getBroadcast(
                context, 0, intent,
                PendingIntent.FLAG_IMMUTABLE
            )

            val calendar: Calendar = Calendar.getInstance().apply {
                timeInMillis = System.currentTimeMillis()
                add(Calendar.MINUTE, 15)
            }

            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            alarmManager.setRepeating(
                AlarmManager.RTC_WAKEUP,
                calendar.timeInMillis,
                AlarmManager.INTERVAL_FIFTEEN_MINUTES,
                pendingIntent
            )
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
        const val FLUTTER_CHANNEL = "com.presley.flexify/android"
        const val WRITE_REQUEST_CODE = 43
        const val TICK_BROADCAST = "tick-event"
    }
}
