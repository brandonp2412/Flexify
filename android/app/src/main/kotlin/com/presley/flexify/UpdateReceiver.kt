package com.presley.flexify

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class UpdateReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == "android.intent.action.MY_PACKAGE_REPLACED") {
            val (automaticBackups, backupPath) = getSettings(context)
            if (!automaticBackups) return
            scheduleBackups(context, backupPath!!)
        }
    }
}

