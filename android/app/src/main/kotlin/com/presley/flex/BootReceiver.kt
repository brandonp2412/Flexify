package com.presley.flex

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (
            intent.action != Intent.ACTION_BOOT_COMPLETED &&
            intent.action != Intent.ACTION_MY_PACKAGE_REPLACED
        ) return

        val (automaticBackups, backupPath) = getSettings(context)
        if (!automaticBackups || backupPath == null) return
        scheduleBackups(context)
    }
}

