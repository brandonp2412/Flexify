package com.presley.flexify

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.ServiceConnection
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import androidx.documentfile.provider.DocumentFile
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedReader
import java.io.InputStreamReader

@RequiresApi(Build.VERSION_CODES.O)
class MainActivity : FlutterActivity() {
    private var savedFilename: String? = null
    private var savedContent: String? = null
    private var channel: MethodChannel? = null
    private var resultChannel: MethodChannel.Result? = null
    private var timerBound = false
    private var timerService: TimerService? = null

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

                "read" -> {
                    resultChannel = result
                    read()
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

    private fun save(filename: String, content: String) {
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE)
        savedFilename = filename
        savedContent = content
        activity.startActivityForResult(intent, WRITE_REQUEST_CODE)
    }

    private fun read() {
        Log.d("MainActivity", "Request to read")
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "text/comma-separated-values"
        }
        startActivityForResult(intent, READ_REQUEST_CODE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        data?.data?.also { uri ->
            if (requestCode == READ_REQUEST_CODE) {
                val inputStream = contentResolver.openInputStream(uri)
                val reader = BufferedReader(InputStreamReader(inputStream))
                val csvData = reader.use {
                    it.readLine()
                    it.readText()
                }
                resultChannel?.success(csvData)
            } else if (requestCode == WRITE_REQUEST_CODE) {
                val pickedDir = DocumentFile.fromTreeUri(context, uri)
                val file = pickedDir?.createFile("text/csv", savedFilename!!)
                file?.uri?.also { fileUri ->
                    context.contentResolver.openOutputStream(fileUri)
                        ?.use { it.write(savedContent!!.toByteArray()) }
                    val fileIntent = Intent(Intent.ACTION_VIEW, fileUri)
                    fileIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                    context.grantUriPermission(
                        fileIntent.resolveActivity(context.packageManager)?.packageName ?: "",
                        fileUri,
                        Intent.FLAG_GRANT_READ_URI_PERMISSION
                    )
                    val contentIntent = PendingIntent.getActivity(
                        context,
                        0,
                        fileIntent,
                        PendingIntent.FLAG_IMMUTABLE
                    )
                    val notificationManager =
                        context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        val channel = NotificationChannel(
                            "downloads",
                            "Downloads",
                            NotificationManager.IMPORTANCE_HIGH
                        )
                        notificationManager.createNotificationChannel(channel)
                    }

                    val notification = NotificationCompat.Builder(context, "downloads")
                        .setContentTitle(uri.path?.split(":")?.get(1) + "/" + file.name)
                        .setContentText("Tap to open.")
                        .setSmallIcon(R.drawable.baseline_arrow_downward_24)
                        .setContentIntent(contentIntent)
                        .setAutoCancel(true)
                        .build()

                    notificationManager.notify(file.name.hashCode(), notification)
                }
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
        const val FLUTTER_CHANNEL = "com.presley.flexify/android"
        const val READ_REQUEST_CODE = 42
        const val WRITE_REQUEST_CODE = 43
        const val TICK_BROADCAST = "tick-event"
    }
}
