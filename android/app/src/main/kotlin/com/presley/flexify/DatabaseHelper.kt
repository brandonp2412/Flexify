package com.presley.flexify

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper

class DatabaseHelper(context: Context, dbPath: String) : SQLiteOpenHelper(context, dbPath, null, DATABASE_VERSION) {

    companion object {
        private const val DATABASE_VERSION = 26
    }

    override fun onCreate(db: SQLiteDatabase?) {
        // Do nothing.
    }

    override fun onUpgrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {
        // Do nothing.
    }

    override fun onDowngrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {
        // Do nothing.
    }
}
