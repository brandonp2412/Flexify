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
        val dbPath = intent?.getStringExtra("dbPath")
        val backupUri = Uri.parse(intent?.getStringExtra("backupPath"))
        Log.d("BackupReceiver", "dbPath=$dbPath,backupUri=$backupUri")
        val sharedPreferences =
            context!!.getSharedPreferences(MainActivity.SHARED_PREFERENCES, Context.MODE_PRIVATE);
        val edit = sharedPreferences.edit()
        edit.putString("backupDirectory", backupUri.toString())
        edit.apply()

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