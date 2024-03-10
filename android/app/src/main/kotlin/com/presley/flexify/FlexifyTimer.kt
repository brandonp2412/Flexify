package com.presley.flexify

import android.app.AlarmManager
import android.app.AlarmManager.ACTION_SCHEDULE_EXACT_ALARM_PERMISSION_STATE_CHANGED
import android.app.AlarmManager.ELAPSED_REALTIME_WAKEUP
import android.app.PendingIntent
import android.content.ActivityNotFoundException
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.Uri
import android.os.Build
import android.os.SystemClock
import android.provider.Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM
import android.widget.Toast
import androidx.annotation.RequiresApi

@RequiresApi(Build.VERSION_CODES.O)
class FlexifyTimer(private var msTimerDuration: Long) {

    enum class State {
        Running,
        Paused,
        Expired
    }

    fun start(context: Context, elapsedTime: Long = 0) {
        if (state != State.Paused) return
        endTime = SystemClock.elapsedRealtime() + msTimerDuration - elapsedTime
        registerPendingIntent(context)
        state = State.Running
    }

    fun stop(context: Context) {
        if (state != State.Running) return
        msTimerDuration = endTime - SystemClock.elapsedRealtime()
        unregisterPendingIntent(context)
        state = State.Paused
    }

    fun expire() {
        state = State.Expired
        msTimerDuration = 0
        totalTimerDuration = 0
    }

    fun getRemainingSeconds(): Int {
        return (getRemainingMillis() / 1000).toInt()
    }

    fun increaseDuration(context: Context, milli: Long) {
        val wasRunning = isRunning()
        if (wasRunning) stop(context)
        msTimerDuration += milli
        totalTimerDuration += milli
        if (wasRunning) start(context)
    }

    fun isRunning(): Boolean {
        return state == State.Running
    }

    fun isExpired(): Boolean {
        return state == State.Expired
    }

    fun getDurationSeconds(): Int {
        return (totalTimerDuration / 1000).toInt()
    }

    fun getRemainingMillis(): Long {
        return if (state == State.Running) endTime - SystemClock.elapsedRealtime()
        else
            msTimerDuration
    }

    fun generateMethodChannelPayload(): LongArray {
        return longArrayOf(
            totalTimerDuration,
            totalTimerDuration - getRemainingMillis(),
            java.lang.System.currentTimeMillis(),
            state.ordinal.toLong()
        )
    }

    private fun requestPermission(context: Context): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return true
        val intent = Intent(ACTION_REQUEST_SCHEDULE_EXACT_ALARM)
        intent.data = Uri.parse("package:" + context.packageName)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        return try {
            val receiver = object : BroadcastReceiver() {
                override fun onReceive(context2: Context?, intent: Intent?) {
                    context.unregisterReceiver(this)
                    registerPendingIntent(context)
                }
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                context.registerReceiver(
                    receiver, IntentFilter(ACTION_SCHEDULE_EXACT_ALARM_PERMISSION_STATE_CHANGED),
                    Context.RECEIVER_NOT_EXPORTED
                )
            } else {
                context.registerReceiver(
                    receiver,
                    IntentFilter(ACTION_SCHEDULE_EXACT_ALARM_PERMISSION_STATE_CHANGED)
                )
            }

            context.startActivity(intent)
            false
        } catch (e: ActivityNotFoundException) {
            Toast.makeText(
                context,
                "Request for SCHEDULE_EXACT_ALARM rejected on your device",
                Toast.LENGTH_LONG
            ).show()
            false
        }
    }

    private fun incorrectPermissions(context: Context, alarmManager: AlarmManager): Boolean {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.S
                && !alarmManager.canScheduleExactAlarms()
                && !requestPermission(context)
    }

    private fun getAlarmManager(context: Context): AlarmManager {
        return context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
    }

    private fun unregisterPendingIntent(context: Context) {
        val intent = Intent(context, TimerService::class.java)
            .setAction(TimerService.TIMER_EXPIRED)
        val pendingIntent = PendingIntent.getService(
            context,
            0,
            intent,
            PendingIntent.FLAG_ONE_SHOT or PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE
        )
        val alarmManager = getAlarmManager(context)
        if (incorrectPermissions(context, alarmManager)) return

        alarmManager.cancel(pendingIntent)
        pendingIntent.cancel()
    }

    private fun registerPendingIntent(context: Context) {
        val intent = Intent(context, TimerService::class.java)
            .setAction(TimerService.TIMER_EXPIRED)
        val pendingIntent = PendingIntent.getService(
            context,
            0,
            intent,
            PendingIntent.FLAG_ONE_SHOT or PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val alarmManager = getAlarmManager(context)
        if (incorrectPermissions(context, alarmManager)) return

        alarmManager.setExactAndAllowWhileIdle(
            ELAPSED_REALTIME_WAKEUP,
            endTime,
            pendingIntent
        )
    }

    private var endTime: Long = 0
    private var state: State = State.Paused
    private var totalTimerDuration: Long = msTimerDuration


    companion object {
        fun emptyTimer(): FlexifyTimer {
            return FlexifyTimer(0)
        }

        const val ONE_MINUTE_MILLI: Long = 60000
    }
}