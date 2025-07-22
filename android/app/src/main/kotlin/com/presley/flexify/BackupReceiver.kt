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

class BackupReceiver : BroadcastReceiver() {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun onReceive(context: Context?, intent: Intent?) {
        Log.d("BackupReceiver", "onReceive")
        if (context == null) return

        val (enabled, backupPath) = getSettings(context)
        if (!enabled || backupPath == null) return

        val backupUri = Uri.parse(backupPath)
        val dir = DocumentFile.fromTreeUri(context, backupUri)
        if (dir == null) return

        val fileName = "flexify.sqlite"

        // Delete existing backup if it exists
        dir.findFile(fileName)?.delete()

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
        ) return

        val file = dir.createFile("application/x-sqlite3", fileName)
        if (file == null) {
            Log.e("BackupReceiver", "Failed to create backup file")
            return
        }

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

        try {
            val outputStream = context.contentResolver.openOutputStream(file.uri)
            if (outputStream == null) {
                Log.e("BackupReceiver", "Failed to open output stream")
                return
            }

            val parentDir = context.filesDir.parentFile
            if (parentDir == null) {
                Log.e("BackupReceiver", "Failed to get parent directory")
                return
            }

            val dbFolder = File(parentDir, "app_flutter").absolutePath
            val dbFile = File(dbFolder, fileName)

            if (!dbFile.exists()) {
                Log.e("BackupReceiver", "Database file does not exist: ${dbFile.absolutePath}")
                return
            }

            dbFile.inputStream().use { input ->
                outputStream.use { output ->
                    input.copyTo(output)
                    notificationBuilder = notificationBuilder.setContentTitle("Backed up database")
                    notificationManager.notify(2, notificationBuilder.build())
                }
            }
        } catch (e: Exception) {
            Log.e("BackupReceiver", "Error during backup: ${e.message}", e)
        }
    }
}