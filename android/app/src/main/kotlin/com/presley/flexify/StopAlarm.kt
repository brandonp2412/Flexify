package com.presley.flexify

import android.app.Activity
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.annotation.RequiresApi

class StopAlarm : Activity() {
    @RequiresApi(Build.VERSION_CODES.O_MR1)
    override fun onCreate(savedInstanceState: Bundle?) {
        Log.d("AlarmActivity", "Call to AlarmActivity")
        super.onCreate(savedInstanceState)
        val context = applicationContext
        context.stopService(Intent(context, TimerService::class.java))
        savedInstanceState.apply { setShowWhenLocked(true) }
        val intent = Intent(context, MainActivity::class.java)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        context.startActivity(intent)
    }
}
