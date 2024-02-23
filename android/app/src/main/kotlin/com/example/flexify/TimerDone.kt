package com.example.flexify

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.View
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.NotificationManagerCompat

class TimerDone : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_timer_done)
        Log.d("TimerDone", "Rendered.")
    }

    @RequiresApi(Build.VERSION_CODES.O)
    @Suppress("UNUSED_PARAMETER")
    fun stop(view: View) {
        Log.d("TimerDone", "Stopping...")
        applicationContext.stopService(Intent(applicationContext, TimerService::class.java))
        val manager = NotificationManagerCompat.from(this)
        manager.cancel(TimerService.ONGOING_ID)
        val intent = Intent(applicationContext, MainActivity::class.java)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        applicationContext.startActivity(intent)
    }
}
