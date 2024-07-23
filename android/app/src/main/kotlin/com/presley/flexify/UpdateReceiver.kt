package com.presley.flexify

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.database.sqlite.SQLiteDatabase
import android.util.Log
import java.io.File
import java.util.Calendar

class UpdateReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == "android.intent.action.MY_PACKAGE_REPLACED") {
            val parentDir = context.filesDir.parentFile
            val dbFolder = File(parentDir, "app_flutter").absolutePath
            Log.d("auto backup", "dbFolder=$dbFolder")
            val dbPath = File(dbFolder, "flexify.sqlite").absolutePath;
            val db = SQLiteDatabase.openDatabase(dbPath, null, 0)

            var backupPath: String? = null
            var automaticBackups = false
            val query = "SELECT backup_path, automatic_backups FROM settings"
            val cursor = db.rawQuery(query, null)

            if (cursor.moveToFirst()) {
                backupPath = cursor.getString(cursor.getColumnIndexOrThrow("backupPath"))
                automaticBackups = cursor.getInt(cursor.getColumnIndexOrThrow("automatic_backups")) == 1
            }
            cursor.close()
            db.close()

            if (!automaticBackups) return

            val backupIntent = Intent(context, BackupReceiver::class.java).apply {
                putExtra("dbPath", dbPath)
                putExtra("backupPath", backupPath)
                setPackage(context.packageName)
            }

            val pendingIntent = PendingIntent.getBroadcast(
                context, 0, backupIntent,
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
}

