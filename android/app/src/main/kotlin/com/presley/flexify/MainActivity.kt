package com.presley.flexify

import android.Manifest
import android.annotation.SuppressLint
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.ServiceConnection
import android.content.pm.PackageManager
import android.database.sqlite.SQLiteDatabase
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsControllerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

@RequiresApi(Build.VERSION_CODES.O)
class MainActivity : FlutterActivity() {
    private var channel: MethodChannel? = null
    private var timerBound = false
    private var timerService: TimerService? = null
    private var pendingPickResult: MethodChannel.Result? = null

    private val timerConnection = object : ServiceConnection {
        override fun onServiceConnected(className: ComponentName, service: IBinder) {
            val binder = service as TimerService.LocalBinder
            timerService = binder.getService()
            timerBound = true
        }

        override fun onServiceDisconnected(arg0: ComponentName) {
            timerBound = false
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WindowCompat.setDecorFitsSystemWindows(window, false)
        val controller = WindowInsetsControllerCompat(window, window.decorView)
        controller.isAppearanceLightStatusBars = false // Set to true if your app's theme is light
        controller.isAppearanceLightNavigationBars = false // Set to true if your app's theme is light
        window.statusBarColor = android.graphics.Color.TRANSPARENT
        window.navigationBarColor = android.graphics.Color.TRANSPARENT

        resetPermissionPromptStateOnFreshInstall()

        val (automaticBackups, backupPath) = getSettings(context)
        if (automaticBackups && backupPath != null) scheduleBackups(context)
    }

    private fun resetPermissionPromptStateOnFreshInstall() {
        val marker = File(noBackupFilesDir, PERMISSION_INSTALL_MARKER)
        if (marker.exists()) return

        openDb(context)?.use { database ->
            val values = ContentValues().apply {
                put("notification_permission_requested", 0)
                put("explained_permissions", 0)
            }
            database.update("settings", values, null, null)
        }

        try {
            marker.createNewFile()
        } catch (error: Exception) {
            Log.e("MainActivity", "Failed to create permission install marker", error)
        }
    }

    @SuppressLint("WrongConstant")
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            FLUTTER_CHANNEL
        )
        channel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "timer" -> {
                    val title = call.argument<String>("title")!!
                    val timestamp = call.argument<Long>("timestamp")!!
                    val threeMinutesThirtySeconds = 210000
                    val restMs = call.argument<Int>("restMs") ?: threeMinutesThirtySeconds
                    val alarmSound = call.argument<String>("alarmSound")!!
                    val vibrate = call.argument<Boolean>("vibrate")!!
                    timer(restMs, title, timestamp, alarmSound, vibrate)
                }

                "pick" -> {
                    val dbPath = call.argument<String>("dbPath")!!
                    pendingPickResult = result
                    pick(dbPath)
                }

                "runBackupNow" -> {
                    if (!BuildConfig.DEBUG) {
                        result.notImplemented()
                        return@setMethodCallHandler
                    }
                    sendBroadcast(Intent(this, BackupReceiver::class.java))
                    result.success(null)
                }

                "getProgress" -> {
                    if (timerBound && timerService?.flexifyTimer?.isRunning() == true)
                        result.success(
                            intArrayOf(
                                timerService?.flexifyTimer!!.getRemainingSeconds(),
                                timerService?.flexifyTimer!!.getDurationSeconds()
                            )
                        )
                    else result.success(intArrayOf(0, 0))
                }

                "add" -> {
                    if (timerService?.flexifyTimer?.isRunning() == true) {
                        val intent = Intent(TimerService.ADD_BROADCAST)
                        intent.setPackage(applicationContext.packageName)
                        sendBroadcast(intent)
                    } else {
                        val timestamp = call.argument<Long>("timestamp")
                        val alarmSound = call.argument<String>("alarmSound")
                        val vibrate = call.argument<Boolean>("vibrate")
                        timer(1000 * 60, "Rest timer", timestamp!!, alarmSound!!, vibrate!!)
                    }
                }

                "stop" -> {
                    Log.d("MainActivity", "Request to stop")
                    val intent = Intent(TimerService.STOP_BROADCAST)
                    intent.setPackage(applicationContext.packageName)
                    sendBroadcast(intent)
                }

                "requestTimerPermissions" -> {
                    requestTimerPermissions()
                    result.success(true)
                }

                "previewVibration" -> {
                    previewVibration()
                    result.success(true)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }

        ContextCompat.registerReceiver(
            applicationContext,
            tickReceiver, IntentFilter(TICK_BROADCAST),
            ContextCompat.RECEIVER_NOT_EXPORTED
        )
    }

    private val tickReceiver =
        object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                channel?.invokeMethod(
                    "tick",
                    timerService?.flexifyTimer?.generateMethodChannelPayload()
                )
                if (intent.getBooleanExtra("justExpired", false)) {
                    channel?.invokeMethod("timerExpired", null)
                }
            }
        }

    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        timerService?.apply {
            mainActivityVisible = hasFocus
            updateTimerNotificationRefreshRate()
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        applicationContext.unregisterReceiver(tickReceiver)

        if (timerBound) {
            unbindService(timerConnection)
            timerBound = false
        }
    }

    private fun timer(
        durationMs: Int,
        description: String,
        timeStamp: Long,
        alarmSound: String,
        vibrate: Boolean
    ) {
        Log.d("MainActivity", "Queue $description for $durationMs delay")
        val intent = Intent(context, TimerService::class.java).also { intent ->
            bindService(
                intent,
                timerConnection,
                Context.BIND_AUTO_CREATE
            )
        }.apply {
            putExtra("milliseconds", durationMs)
            putExtra("description", description)
            putExtra("timeStamp", timeStamp)
            putExtra("alarmSound", alarmSound)
            putExtra("vibrate", vibrate)
        }

        context.startForegroundService(intent)
    }

    private fun pick(path: String) {
        Log.d("MainActivity.pick", "dbPath=$path")
        activity.startActivityForResult(Intent(Intent.ACTION_OPEN_DOCUMENT_TREE), WRITE_REQUEST_CODE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != WRITE_REQUEST_CODE) return

        data?.data?.also { uri ->
            val contentResolver = applicationContext.contentResolver
            val takeFlags =
                Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
            contentResolver.takePersistableUriPermission(uri, takeFlags)

            openDb(context)?.use { db ->
                val values = ContentValues().apply { put("backup_path", uri.toString()) }
                db.update("settings", values, null, null)
            }
            scheduleBackups(context)
        }

        pendingPickResult?.success(data?.data?.toString())
        pendingPickResult = null
    }

    override fun onResume() {
        super.onResume()
        if (timerService?.flexifyTimer?.isRunning() != true) {
            val intent = Intent(TimerService.STOP_BROADCAST)
            intent.setPackage(applicationContext.packageName)
            sendBroadcast(intent)
        }
    }

    private fun requestTimerPermissions() {
        val permissions = mutableListOf<String>()
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (ContextCompat.checkSelfPermission(
                    this,
                    Manifest.permission.POST_NOTIFICATIONS
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                permissions.add(Manifest.permission.POST_NOTIFICATIONS)
            }
        }
        
        if (permissions.isNotEmpty()) {
            ActivityCompat.requestPermissions(
                this,
                permissions.toTypedArray(),
                TIMER_PERMISSION_REQUEST_CODE
            )
        }
        
        if (timerBound && timerService != null) {
            timerService?.battery()
        } else {
            val intent = Intent(context, TimerService::class.java)
            bindService(intent, object : ServiceConnection {
                override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
                    val binder = service as TimerService.LocalBinder
                    binder.getService().battery()
                    unbindService(this)
                }
                
                override fun onServiceDisconnected(name: ComponentName?) {}
            }, Context.BIND_AUTO_CREATE)
        }
    }

    private fun previewVibration() {
        Log.d("MainActivity", "Preview vibration requested")
        
        val vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val vibratorManager = getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as android.os.VibratorManager
            vibratorManager.defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            getSystemService(VIBRATOR_SERVICE) as android.os.Vibrator
        }
        
        if (vibrator.hasVibrator()) {
            try {
                val pattern = longArrayOf(0, 500, 200, 300)
                vibrator.vibrate(android.os.VibrationEffect.createWaveform(pattern, -1))
                Log.d("MainActivity", "Preview vibration triggered successfully")
            } catch (e: Exception) {
                Log.e("MainActivity", "Failed to trigger preview vibration", e)
            }
        } else {
            Log.w("MainActivity", "Device does not support vibration")
        }
    }

    companion object {
        const val FLUTTER_CHANNEL = "com.presley.flexify/android"
        const val WRITE_REQUEST_CODE = 43
        const val TIMER_PERMISSION_REQUEST_CODE = 44
        const val TICK_BROADCAST = "tick-event"
        const val PERMISSION_INSTALL_MARKER = "permission-prompt-state-v1"
    }
}