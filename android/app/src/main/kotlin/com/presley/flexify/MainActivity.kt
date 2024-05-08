package com.presley.flexify

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.ServiceConnection
import android.net.Uri
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.documentfile.provider.DocumentFile
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

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            FLUTTER_CHANNEL
        )
        channel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "timer" -> {
                    val args = call.arguments as ArrayList<*>
                    timer(args[0] as Int, args[1] as String, args[2] as Long)
                }

                "save" -> {
                    val args = call.arguments as ArrayList<*>
                    save(args[0] as String, args[1] as String)
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
                        val args = call.arguments as ArrayList<*>
                        timer(1000 * 60, "Rest timer", args[0] as Long)
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

    private fun timer(milliseconds: Int, description: String, timeStamp: Long) {
        Log.d("MainActivity", "Queue $description for $milliseconds delay")
        val intent = Intent(context, TimerService::class.java).also { intent ->
            bindService(
                intent,
                timerConnection,
                Context.BIND_AUTO_CREATE
            )
        }
        intent.putExtra("milliseconds", milliseconds)
        intent.putExtra("description", description)
        intent.putExtra("timeStamp", timeStamp)
        context.startForegroundService(intent)
    }

    private fun pick(path: String) {
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE)
        savedPath = path
        activity.startActivityForResult(intent, WRITE_REQUEST_CODE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        data?.data?.also { uri ->
            if (requestCode == WRITE_REQUEST_CODE) {
                val intent = Intent(context, BackupReceiver::class.java).apply {
                    putExtra("dbPath", savedPath)
                    putExtra("backupPath", uri.toString())
                }
                BackupReceiver().onReceive(context, intent)

                val pendingIntent = PendingIntent.getBroadcast(context, 0, intent,
                    PendingIntent.FLAG_IMMUTABLE)

                val calendar: Calendar = Calendar.getInstance().apply {
                    timeInMillis = System.currentTimeMillis()
                    set(Calendar.HOUR_OF_DAY, 14)
                }

                val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
                alarmManager.setInexactRepeating(
                    AlarmManager.RTC_WAKEUP,
                    calendar.timeInMillis,
                    AlarmManager.INTERVAL_DAY,
                    pendingIntent
                )
            }
        }
    }

    private fun save(filename: String, content: String) {
        val sharedPreferences =
            getSharedPreferences(SHARED_PREFERENCES, Context.MODE_PRIVATE);
        val backupDirectory = sharedPreferences.getString("backupDirectory", null) ?: return;
        val backupUri = Uri.parse(backupDirectory)
        val pickedDir = DocumentFile.fromTreeUri(context, backupUri)

        var file = pickedDir?.findFile(filename)
        if (file == null) file = pickedDir?.createFile("text/csv", filename)

        val fileUri = file?.uri
        if (fileUri != null) {
            val outputStream = context.contentResolver.openOutputStream(fileUri, "wa")
            outputStream?.write(content.toByteArray())
            outputStream?.close()
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
        const val FLUTTER_CHANNEL = "com.presley.flexify/android"
        const val SHARED_PREFERENCES = "flexify"
        const val WRITE_REQUEST_CODE = 43
        const val TICK_BROADCAST = "tick-event"
    }
}
