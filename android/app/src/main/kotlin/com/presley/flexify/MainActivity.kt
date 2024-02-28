package com.presley.flexify

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
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
                    timer(args[0] as Int, args[1] as String)
                }

                "save" -> {
                    val args = call.arguments as ArrayList<*>
                    save(args[0] as String, args[1] as String)
                }

                "read" -> {
                    resultChannel = result
                    read()
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun timer(milliseconds: Int, description: String) {
        Log.d("MainActivity", "Queue $description for $milliseconds delay")
        val intent = Intent(context, TimerService::class.java)
        intent.putExtra("milliseconds", milliseconds)
        intent.putExtra("description", description)
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
        val intent = Intent(TimerService.STOP_BROADCAST)
        intent.putExtra("check", true);
        sendBroadcast(intent);
    }

    companion object {
        const val FLUTTER_CHANNEL = "com.presley.flexify/android"
        const val READ_REQUEST_CODE = 42
        const val WRITE_REQUEST_CODE = 43
    }
}
