package com.presley.flexify

import android.Manifest
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.database.sqlite.SQLiteDatabase
import android.os.Build
import androidx.test.core.app.ApplicationProvider
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.rule.GrantPermissionRule
import androidx.test.rule.ServiceTestRule
import java.io.File
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class TimerServiceTest {
    @get:Rule
    val serviceRule = ServiceTestRule()

    @get:Rule
    val permissionRule: GrantPermissionRule =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            GrantPermissionRule.grant(Manifest.permission.POST_NOTIFICATIONS)
        } else {
            GrantPermissionRule.grant()
        }

    private val context: Context
        get() = ApplicationProvider.getApplicationContext()

    // TimerService.playSound() reads settings.enable_sound straight from the
    // Flutter-managed sqlite file. This instrumented test never boots the
    // Flutter engine, so that file wouldn't otherwise exist and playSound()
    // would crash with an NPE before the code under test even runs.
    @Before
    fun seedFlexifySettingsDb() {
        val dbFolder = File(context.filesDir.parentFile, "app_flutter")
        dbFolder.mkdirs()
        val dbFile = File(dbFolder, "flexify.sqlite")
        SQLiteDatabase.openOrCreateDatabase(dbFile, null).use { db ->
            db.execSQL("CREATE TABLE IF NOT EXISTS settings (enable_sound INTEGER)")
            db.execSQL("DELETE FROM settings")
            db.execSQL("INSERT INTO settings (enable_sound) VALUES (0)")
        }
    }

    private fun startAndBindTimer(description: String): TimerService {
        val startIntent = Intent(context, TimerService::class.java).apply {
            putExtra("description", description)
            putExtra("milliseconds", 60_000)
        }
        serviceRule.startService(startIntent)

        val binder = serviceRule.bindService(Intent(context, TimerService::class.java))
        return (binder as TimerService.LocalBinder).getService()
    }

    private fun expireActiveTimer() {
        context.startService(
            Intent(context, TimerService::class.java).apply {
                action = TimerService.TIMER_EXPIRED
            },
        )
        Thread.sleep(200)
    }

    private fun activeNotificationDeleteIntent(notificationId: Int): PendingIntent =
        context.getSystemService(NotificationManager::class.java)
            .activeNotifications
            .first { it.id == notificationId }
            .notification
            .deleteIntent

    // #312: dismissing the finished notification of a previous exercise used to
    // fire the same broadcast action as the current exercise's own stop button,
    // so it also stopped whichever timer was currently running.
    //
    // The delete intent is captured before starting Exercise B, because a
    // later, unrelated fix (c377863f) now has startTimer() proactively cancel
    // the finished notification the moment a new timer starts, closing most of
    // the original repro window. The captured PendingIntent is still valid to
    // fire after that cancellation, so this reproduces the narrow race that
    // remains: whatever action the notification was built with is still what
    // matters if it (or a queued dismissal of it) fires late.
    @Test
    fun dismissingFinishedNotificationDoesNotStopActiveTimer() {
        startAndBindTimer("Exercise A")
        expireActiveTimer()
        val finishedDeleteIntent = activeNotificationDeleteIntent(TimerService.FINISHED_ID)

        val service = startAndBindTimer("Exercise B")
        assertTrue(service.flexifyTimer.isRunning())

        finishedDeleteIntent.send()
        Thread.sleep(200)

        assertTrue(
            "Dismissing a previous exercise's finished notification must not stop " +
                "the timer that is currently running",
            service.flexifyTimer.isRunning(),
        )
    }

    @Test
    fun dismissingOwnNotificationStopsActiveTimer() {
        val service = startAndBindTimer("Exercise A")
        assertTrue(service.flexifyTimer.isRunning())

        activeNotificationDeleteIntent(TimerService.ONGOING_ID).send()
        Thread.sleep(200)

        assertFalse(service.flexifyTimer.isRunning())
    }
}
