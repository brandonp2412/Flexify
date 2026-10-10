package com.presley.flexify

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import androidx.test.core.app.ApplicationProvider
import androidx.test.ext.junit.runners.AndroidJUnit4
import java.io.File
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class StoragePathTest {
    private val context: Context
        get() = ApplicationProvider.getApplicationContext()

    private val support: File
        get() = File(context.filesDir, "flexify.sqlite")

    private val legacy: File
        get() = File(File(context.filesDir.parentFile, "app_flutter"), "flexify.sqlite")

    private val marker: File
        get() = File(context.filesDir, ".flexify-storage-migrated")

    @Before
    @After
    fun clearFixture() {
        for (database in listOf(support, legacy)) {
            database.delete()
            File("${database.path}-wal").delete()
            File("${database.path}-shm").delete()
            File("${database.path}-journal").delete()
        }
        marker.delete()
    }

    private fun seedSettings(file: File, enabled: Boolean, path: String) {
        file.parentFile!!.mkdirs()
        SQLiteDatabase.openOrCreateDatabase(file, null).use { database ->
            database.execSQL(
                "CREATE TABLE settings (automatic_backups INTEGER NOT NULL, backup_path TEXT)"
            )
            database.execSQL(
                "INSERT INTO settings VALUES (?, ?)",
                arrayOf(if (enabled) 1 else 0, path),
            )
        }
    }

    @Test
    fun freshInstallUsesSupport() {
        assertEquals(support, getDatabaseFile(context))
        assertFalse(support.exists())
    }

    @Test
    fun legacyDatabaseRemainsAvailableBeforeMigration() {
        seedSettings(legacy, true, "legacy")
        assertEquals(legacy, getDatabaseFile(context))
        assertEquals(Pair(true, "legacy"), getSettings(context))
    }

    @Test
    fun supportDatabaseTakesPrecedence() {
        seedSettings(legacy, false, "legacy")
        seedSettings(support, true, "support")
        assertEquals(support, getDatabaseFile(context))
        assertEquals(Pair(true, "support"), getSettings(context))
    }

    @Test
    fun deletionMarkerPreventsLegacyFallback() {
        seedSettings(legacy, true, "legacy")
        marker.writeText("")
        assertEquals(support, getDatabaseFile(context))
        assertEquals(Pair(false, null), getSettings(context))
        assertFalse(support.exists())
        assertTrue(legacy.exists())
    }

    @Test
    fun backupSettingsUpdatesOnlyTouchSupport() {
        seedSettings(legacy, false, "legacy")
        seedSettings(support, false, "support")
        setAutomaticBackups(context, true)
        assertEquals(Pair(true, "support"), getSettings(context))
        SQLiteDatabase.openDatabase(legacy.path, null, SQLiteDatabase.OPEN_READONLY).use { database ->
            database.rawQuery("SELECT automatic_backups FROM settings", null).use { rows ->
                assertTrue(rows.moveToFirst())
                assertEquals(0, rows.getInt(0))
            }
        }
    }
}
