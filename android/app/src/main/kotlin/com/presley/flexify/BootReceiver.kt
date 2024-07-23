package com.presley.flexify

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == "android.intent.action.BOOT_COMPLETED") {
            val (automaticBackups, backupPath) = getSettings(context)
            if (!automaticBackups) return
            scheduleBackups(context, backupPath!!)
        }
    }
}

