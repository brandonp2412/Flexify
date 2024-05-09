package com.presley.flexify

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.documentfile.provider.DocumentFile
import java.io.File

class BackupReceiver : BroadcastReceiver() {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun onReceive(context: Context?, intent: Intent?) {
        if (context == null) return

        val dbPath = MainActivity.sharedPrefs.getString("flutter.dbPath", null)
        val backupPath = MainActivity.sharedPrefs.getString("flutter.backupPath", null)
        val backupUri = Uri.parse(backupPath)
        Log.d("BackupReceiver", "dbPath=$dbPath,backupUri=$backupUri")

        val dbFile = File(dbPath!!)
        val dir = DocumentFile.fromTreeUri(context, backupUri)
        var file = dir?.findFile("flexify.sqlite")
        if (file == null) file = dir?.createFile("application/x-sqlite3", "flexify.sqlite")
        val outputStream = context.contentResolver.openOutputStream(file!!.uri)

        dbFile.inputStream().use { input ->
            outputStream?.use { output ->
                input.copyTo(output)
            }
        }
    }
}