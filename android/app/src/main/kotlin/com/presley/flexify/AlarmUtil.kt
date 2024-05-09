package com.presley.flexify

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.util.Log
import java.util.Calendar

object AlarmUtil {
    fun setRepeatingAlarm(context: Context) {
        val alarmIntent = Intent(context, BackupReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            context, 0, alarmIntent,
            PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE
        )
        if (pendingIntent != null) return;

        val prefs =
            context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val automaticBackup =
            prefs.getBoolean("flutter.automaticBackup", false)
        Log.d("BootCompletedReceiver", "automaticBackup=$automaticBackup")
        if (!automaticBackup) return;

        val calendar: Calendar = Calendar.getInstance().apply {
            timeInMillis = System.currentTimeMillis()
            set(Calendar.HOUR_OF_DAY, 22)
        }
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

        alarmManager.setInexactRepeating(
            AlarmManager.RTC_WAKEUP,
            calendar.timeInMillis,
            AlarmManager.INTERVAL_DAY,
            PendingIntent.getBroadcast(
                context, 0, alarmIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
        )
    }
}
