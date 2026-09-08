package com.presley.flexify

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.database.sqlite.SQLiteDatabase
import android.util.Log
import java.io.File
import java.util.Calendar

fun scheduleBackups(context: Context) {
    val backupIntent =
        Intent(context, BackupReceiver::class.java).apply { setPackage(context.packageName) }
    val pendingIntent = PendingIntent.getBroadcast(
        context,
        0,
        backupIntent,
        PendingIntent.FLAG_IMMUTABLE
    )
    val calendar = Calendar.getInstance().apply {
        set(Calendar.HOUR_OF_DAY, 2)
        set(Calendar.MINUTE, 0)
        set(Calendar.SECOND, 0)
        if (timeInMillis < System.currentTimeMillis()) add(Calendar.DAY_OF_YEAR, 1)
    }
    val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
    alarmManager.setInexactRepeating(
        AlarmManager.RTC_WAKEUP,
        calendar.timeInMillis,
        AlarmManager.INTERVAL_DAY,
        pendingIntent
    )
}

fun openDb(context: Context): SQLiteDatabase? {
    val parentDir = context.filesDir.parentFile ?: return null
    val dbFile = File(File(parentDir, "app_flutter"), "flexify.sqlite")
    if (!dbFile.exists()) return null
    return try {
        SQLiteDatabase.openDatabase(dbFile.absolutePath, null, 0)
    } catch (error: Exception) {
        Log.e("utils@openDb", error.toString())
        null
    }
}

fun getSettings(context: Context): Pair<Boolean, String?> {
    val db = openDb(context) ?: return Pair(false, null)
    return try {
        db.rawQuery("SELECT backup_path, automatic_backups FROM settings", null).use { cursor ->
            if (!cursor.moveToFirst()) return Pair(false, null)
            val backupPath = cursor.getString(cursor.getColumnIndexOrThrow("backup_path"))
            val automaticBackups =
                cursor.getInt(cursor.getColumnIndexOrThrow("automatic_backups")) == 1
            Pair(automaticBackups, backupPath)
        }
    } catch (error: Exception) {
        Log.e("utils@getSettings", error.toString())
        Pair(false, null)
    } finally {
        db.close()
    }
}

fun setAutomaticBackups(context: Context, enabled: Boolean) {
    val db = openDb(context) ?: return
    try {
        db.execSQL(
            "UPDATE settings SET automatic_backups = ?",
            arrayOf(if (enabled) 1 else 0)
        )
    } catch (error: Exception) {
        Log.e("utils@setAutomaticBackups", error.toString())
    } finally {
        db.close()
    }
}
