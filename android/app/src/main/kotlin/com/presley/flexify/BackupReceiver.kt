package com.presley.flexify

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.documentfile.provider.DocumentFile
import java.io.File
import java.time.LocalDate
import java.time.format.DateTimeFormatter

class BackupReceiver : BroadcastReceiver() {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun onReceive(context: Context?, intent: Intent?) {
        Log.d("BackupReceiver", "onReceive")
        if (context == null) return

        val dbPath = intent!!.extras!!.getString("dbPath")
        val backupPath = intent.extras!!.getString("backupPath")
        Log.d("BackupReceiver", "dbPath=$dbPath,backupPath=$backupPath")
        val backupUri = Uri.parse(backupPath)

        val channelId = "backup_channel"
        var notificationBuilder = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(R.drawable.baseline_arrow_downward_24)
            .setAutoCancel(true)

        val notificationManager = NotificationManagerCompat.from(context)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Backup channel",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            channel.description = "Automatic backups of the database"
            notificationManager.createNotificationChannel(channel)
        }

        if (ActivityCompat.checkSelfPermission(
                context,
                Manifest.permission.POST_NOTIFICATIONS
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            return
        }

        val dir = DocumentFile.fromTreeUri(context, backupUri)
        val currentDate = LocalDate.now() // Get today's date
        val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd") // Define the pattern
        val yyyyMMdd = formatter.format(currentDate)
        val fileName = "flexify-${yyyyMMdd}.sqlite"
        val file = dir!!.createFile("application/x-sqlite3", fileName)!!
        Log.d("BackupReceiver", "file.uri=${file.uri}")
        notificationBuilder = notificationBuilder.setContentText(file.name)

        val openIntent = Intent().apply {
            action = Intent.ACTION_GET_CONTENT
            setDataAndType(dir.uri, "*/*")
        }
        val pendingOpen =
            PendingIntent.getActivity(context, 0, openIntent, PendingIntent.FLAG_IMMUTABLE)
        notificationBuilder = notificationBuilder.setContentIntent(pendingOpen)

        val shareIntent = Intent().apply {
            action = Intent.ACTION_SEND
            putExtra(Intent.EXTRA_STREAM, file.uri)
            type = "application/x-sqlite3"
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }
        val pendingShare =
            PendingIntent.getActivity(context, 0, shareIntent, PendingIntent.FLAG_IMMUTABLE)
        notificationBuilder =
            notificationBuilder.addAction(R.drawable.ic_baseline_stop_24, "Share", pendingShare)

        val outputStream = context.contentResolver.openOutputStream(file.uri)
        val dbFile = File(dbPath!!)
        dbFile.inputStream().use { input ->
            outputStream?.use { output ->
                input.copyTo(output)
                notificationBuilder = notificationBuilder.setContentTitle("Finished")
                notificationManager.notify(2, notificationBuilder.build())
            }
        }
    }
}