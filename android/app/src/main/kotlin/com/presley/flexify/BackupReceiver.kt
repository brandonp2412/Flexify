package com.presley.flexify

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.database.sqlite.SQLiteDatabase
import android.net.Uri
import android.os.Build
import android.util.Log
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.documentfile.provider.DocumentFile
import java.io.BufferedInputStream
import java.io.BufferedOutputStream
import java.io.File
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.util.zip.ZipEntry
import java.util.zip.ZipOutputStream

class BackupReceiver : BroadcastReceiver() {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun onReceive(context: Context?, intent: Intent?) {
        Log.d("BackupReceiver", "onReceive")
        if (context == null) return

        try {
            val (enabled, backupPath) = getSettings(context)
            if (!enabled) return

            if (backupPath == null) {
                failBackup(context, "Backup path not set")
                return
            }

            val backupUri = Uri.parse(backupPath)
            val channelId = "backup_channel"
            var notificationBuilder = NotificationCompat.Builder(context, channelId)
                .setSmallIcon(R.drawable.baseline_arrow_downward_24)
                .setAutoCancel(true)

            val notificationManager = NotificationManagerCompat.from(context)
            val channel = NotificationChannel(
                channelId,
                "Backup channel",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            channel.description = "Automatic backups of Flexify data and images"
            notificationManager.createNotificationChannel(channel)

            if (ActivityCompat.checkSelfPermission(
                    context,
                    Manifest.permission.POST_NOTIFICATIONS
                ) != PackageManager.PERMISSION_GRANTED
            ) return

            val dir = DocumentFile.fromTreeUri(context, backupUri)
            if (dir == null) {
                failBackup(context, "Could not access backup directory")
                return
            }

            val yyyyMMdd = DateTimeFormatter.ofPattern("yyyy-MM-dd").format(LocalDate.now())
            val fileName = "flexify-$yyyyMMdd.zip"
            val file = dir.createFile("application/zip", fileName)
            if (file == null) {
                failBackup(context, "Could not create backup file")
                return
            }

            notificationBuilder = notificationBuilder.setContentText(file.name)

            val openIntent = Intent().apply {
                action = Intent.ACTION_GET_CONTENT
                setDataAndType(dir.uri, "*/*")
            }
            val pendingOpen = PendingIntent.getActivity(
                context,
                0,
                openIntent,
                PendingIntent.FLAG_IMMUTABLE
            )
            notificationBuilder = notificationBuilder.setContentIntent(pendingOpen)

            val shareIntent = Intent().apply {
                action = Intent.ACTION_SEND
                putExtra(Intent.EXTRA_STREAM, file.uri)
                type = "application/zip"
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }
            val pendingShare = PendingIntent.getActivity(
                context,
                0,
                shareIntent,
                PendingIntent.FLAG_IMMUTABLE
            )
            notificationBuilder = notificationBuilder.addAction(
                R.drawable.baseline_arrow_downward_24,
                "Share",
                pendingShare
            )

            val parentDir = context.filesDir.parentFile
            if (parentDir == null) {
                failBackup(context, "Could not access application files directory")
                return
            }
            val dbFile = File(File(parentDir, "app_flutter"), "flexify.sqlite")
            if (!dbFile.exists()) {
                failBackup(context, "Database file not found")
                return
            }

            val outputStream = context.contentResolver.openOutputStream(file.uri)
            if (outputStream == null) {
                failBackup(context, "Could not open output stream")
                return
            }

            val temporaryDatabase = File.createTempFile(
                "flexify-backup-",
                ".sqlite",
                context.cacheDir
            )
            try {
                val images = createPortableDatabaseCopy(dbFile, temporaryDatabase)
                outputStream.use { output ->
                    ZipOutputStream(BufferedOutputStream(output)).use { zip ->
                        addFileToZip(zip, temporaryDatabase, "flexify.sqlite")
                        images.forEach { (image, archivePath) ->
                            if (image.exists()) addFileToZip(zip, image, archivePath)
                        }
                    }
                }
                notificationBuilder = notificationBuilder.setContentTitle("Backed up data and images")
                notificationManager.notify(2, notificationBuilder.build())
            } finally {
                temporaryDatabase.delete()
            }
        } catch (error: Exception) {
            Log.e("BackupReceiver", "Error during backup: ${error.message}", error)
            failBackup(context, error.message ?: "Unknown backup error")
        }
    }

    private fun failBackup(context: Context, message: String) {
        setAutomaticBackups(context, false)
        Toast.makeText(
            context,
            "Backup failed: $message. Automatic backups disabled.",
            Toast.LENGTH_LONG
        ).show()
    }

    private fun createPortableDatabaseCopy(
        sourceFile: File,
        destinationFile: File
    ): Map<File, String> {
        destinationFile.delete()
        val sourceDatabase = SQLiteDatabase.openDatabase(
            sourceFile.absolutePath,
            null,
            SQLiteDatabase.OPEN_READWRITE
        )
        try {
            sourceDatabase.rawQuery("PRAGMA wal_checkpoint(FULL)", null).use { cursor ->
                if (cursor.moveToFirst() && cursor.getInt(0) != 0) {
                    throw IllegalStateException("Database is busy")
                }
            }
        } finally {
            sourceDatabase.close()
        }
        sourceFile.copyTo(destinationFile, overwrite = true)

        val images = linkedMapOf<File, String>()
        val relativePaths = linkedMapOf<String, String>()
        val database = SQLiteDatabase.openDatabase(
            destinationFile.absolutePath,
            null,
            SQLiteDatabase.OPEN_READWRITE
        )
        try {
            val imageColumns = listOf(Pair("gym_sets", "image"))
            imageColumns.forEach { (table, column) ->
                if (!hasColumn(database, table, column)) return@forEach
                val storedPaths = mutableListOf<String>()
                database.rawQuery(
                    "SELECT DISTINCT \"$column\" FROM \"$table\" " +
                        "WHERE \"$column\" IS NOT NULL AND \"$column\" != ''",
                    null
                ).use { cursor ->
                    while (cursor.moveToNext()) storedPaths.add(cursor.getString(0))
                }
                storedPaths.forEach { originalPath ->
                    val archivePath = relativePaths.getOrPut(originalPath) {
                        "images/${relativePaths.size}_${File(originalPath).name}"
                    }
                    val image = File(originalPath)
                    if (image.exists()) images[image] = archivePath
                    database.execSQL(
                        "UPDATE \"$table\" SET \"$column\" = ? WHERE \"$column\" = ?",
                        arrayOf(archivePath, originalPath)
                    )
                }
            }
        } finally {
            database.close()
        }
        return images
    }

    private fun hasColumn(database: SQLiteDatabase, table: String, column: String): Boolean {
        database.rawQuery(
            "SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = ?",
            arrayOf(table)
        ).use { if (!it.moveToFirst()) return false }
        database.rawQuery("PRAGMA table_info(\"$table\")", null).use { cursor ->
            val nameIndex = cursor.getColumnIndexOrThrow("name")
            while (cursor.moveToNext()) {
                if (cursor.getString(nameIndex) == column) return true
            }
        }
        return false
    }

    private fun addFileToZip(zip: ZipOutputStream, file: File, archivePath: String) {
        zip.putNextEntry(ZipEntry(archivePath))
        BufferedInputStream(file.inputStream()).use { input -> input.copyTo(zip) }
        zip.closeEntry()
    }
}
