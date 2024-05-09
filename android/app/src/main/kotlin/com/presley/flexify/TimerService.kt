package com.presley.flexify

import android.Manifest
import android.annotation.SuppressLint
import android.app.*
import android.content.ActivityNotFoundException
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE
import android.media.MediaPlayer
import android.net.Uri
import android.os.*
import android.util.Log
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat

@RequiresApi(Build.VERSION_CODES.O)
class TimerService : Service() {
    private lateinit var timerHandler: Handler
    private var timerRunnable: Runnable? = null
    private var mediaPlayer: MediaPlayer? = null
    private var vibrator: Vibrator? = null
    private val binder = LocalBinder()
    private var currentDescription = ""
    private var alarmSound: String? = null
    private var shouldVibrate = true
    var mainActivityVisible = true
    var flexifyTimer: FlexifyTimer = FlexifyTimer.emptyTimer()


    override fun onBind(intent: Intent): IBinder? {
        return binder
    }

    inner class LocalBinder : Binder() {
        fun getService(): TimerService = this@TimerService
    }

    private val stopReceiver =
        object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                Log.d("TimerService", "Received stop broadcast intent")
                flexifyTimer.stop(applicationContext)
                flexifyTimer.expire()

                timerRunnable?.let { timerHandler.removeCallbacks(it) }
                mediaPlayer?.stop()
                vibrator?.cancel()

                if (intent != null && intent.action == STOP_BROADCAST_INTERNAL) updateAppUI()
                val notificationManager = NotificationManagerCompat.from(this@TimerService)
                notificationManager.cancel(ONGOING_ID)
                stopForeground(STOP_FOREGROUND_REMOVE)
                stopSelf()
            }
        }

    private val addReceiver =
        object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                Log.d("TimerService", "Received add broadcast intent")
                mediaPlayer?.stop()
                vibrator?.cancel()

                val timeStamp = intent?.getLongExtra("timeStamp", 0)
                if (flexifyTimer.isExpired()) return startTimer(
                    FlexifyTimer.ONE_MINUTE_MILLI,
                    timeStamp ?: 0
                )

                flexifyTimer.increaseDuration(applicationContext, FlexifyTimer.ONE_MINUTE_MILLI)
                updateNotification(flexifyTimer.getRemainingSeconds())

                if (intent != null && intent.action == ADD_BROADCAST_INTERNAL) updateAppUI()
            }
        }

    @SuppressLint("UnspecifiedRegisterReceiverFlag")
    override fun onCreate() {
        super.onCreate()
        timerHandler = Handler(Looper.getMainLooper())
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            applicationContext.registerReceiver(
                stopReceiver, IntentFilter().apply {
                    addAction(STOP_BROADCAST)
                    addAction(STOP_BROADCAST_INTERNAL)
                },
                Context.RECEIVER_NOT_EXPORTED
            )
            applicationContext.registerReceiver(
                addReceiver, IntentFilter().apply {
                    addAction(ADD_BROADCAST)
                    addAction(ADD_BROADCAST_INTERNAL)
                },
                Context.RECEIVER_NOT_EXPORTED
            )
        } else {
            applicationContext.registerReceiver(stopReceiver, IntentFilter().apply {
                addAction(STOP_BROADCAST)
                addAction(STOP_BROADCAST_INTERNAL)
            })
            applicationContext.registerReceiver(addReceiver, IntentFilter().apply {
                addAction(ADD_BROADCAST)
                addAction(ADD_BROADCAST_INTERNAL)
            })
        }
    }

    private fun updateAppUI() {
        sendBroadcast(Intent(MainActivity.TICK_BROADCAST))
    }

    private fun onTimerExpired() {
        Log.d("TimerService", "onTimerExpired duration=${flexifyTimer.getDurationSeconds()}")
        flexifyTimer.expire()
        vibrate()
        playSound()
        notifyFinished()
        updateAppUI()
    }

    fun updateTimerNotificationRefreshRate() {
        timerRunnable?.let {
            timerHandler.removeCallbacks(it)
            timerHandler.postDelayed(it, getDelay(SystemClock.elapsedRealtime()))
        }
    }

    private fun getDelay(startTime: Long): Long {
        if (mainActivityVisible) return 20

        val delay = flexifyTimer.getRemainingMillis() % 1000
        return if (SystemClock.elapsedRealtime() - startTime + delay > 980) 20 else delay
    }

    private fun startTimer(msDuration: Long, timeStamp: Long) {
        timerRunnable?.let { timerHandler.removeCallbacks(it) }

        flexifyTimer.stop(applicationContext)
        flexifyTimer = FlexifyTimer(msDuration)
        flexifyTimer.start(
            applicationContext,
            if (timeStamp > 0) System.currentTimeMillis() - timeStamp else 0,
        )

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            startForeground(
                ONGOING_ID,
                getProgress(flexifyTimer.getRemainingSeconds()).build(),
                FOREGROUND_SERVICE_TYPE_SPECIAL_USE
            )
        } else {
            startForeground(ONGOING_ID, getProgress(flexifyTimer.getRemainingSeconds()).build())
        }

        battery()
        Log.d("TimerService", "onTimerStart seconds=${flexifyTimer.getDurationSeconds()}")

        timerRunnable = object : Runnable {
            override fun run() {
                val startTime = SystemClock.elapsedRealtime()
                if (flexifyTimer.isExpired()) return
                if (flexifyTimer.hasSecondsUpdated()) updateNotification(flexifyTimer.getRemainingSeconds())
                timerHandler.postDelayed(this, getDelay(startTime))
            }
        }
        timerHandler.postDelayed(timerRunnable!!, getDelay(SystemClock.elapsedRealtime()))

        if (timeStamp == 0.toLong()) updateAppUI()
    }

    private fun onTimerStart(intent: Intent?) {
        currentDescription = intent?.getStringExtra("description").toString()
        alarmSound = intent?.getStringExtra("alarmSound")
        shouldVibrate = intent?.getBooleanExtra("vibrate", true) ?: true
        startTimer(
            (intent?.getIntExtra("milliseconds", 0) ?: 0).toLong(),
            intent?.getLongExtra("timeStamp", 0) ?: 0
        )
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent != null && intent.action == TIMER_EXPIRED) onTimerExpired()
        else onTimerStart(intent);
        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        timerHandler.removeCallbacks(timerRunnable!!)
        applicationContext.unregisterReceiver(stopReceiver)
        applicationContext.unregisterReceiver(addReceiver)
        mediaPlayer?.stop()
        mediaPlayer?.release()
        vibrator?.cancel()
    }

    @SuppressLint("BatteryLife")
    fun battery() {
        val powerManager =
            applicationContext.getSystemService(Context.POWER_SERVICE) as PowerManager
        val ignoring =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M)
                powerManager.isIgnoringBatteryOptimizations(
                    applicationContext.packageName
                )
            else true
        if (ignoring) return
        val intent = Intent(android.provider.Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS)
        intent.data = Uri.parse("package:" + applicationContext.packageName)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        try {
            applicationContext.startActivity(intent)
        } catch (e: ActivityNotFoundException) {
            Toast.makeText(
                applicationContext,
                "Requests to ignore battery optimizations are disabled on your device.",
                Toast.LENGTH_LONG
            ).show()
        }
    }

    private fun playSound() {
        mediaPlayer = if (alarmSound != null)
            MediaPlayer().apply {
                setDataSource(applicationContext, Uri.parse(alarmSound))
                prepare()
                start()
                setOnCompletionListener { vibrator?.cancel() }
            }
        else {
            MediaPlayer.create(applicationContext, R.raw.argon).apply {
                start()
                setOnCompletionListener { vibrator?.cancel() }
            }
        }
    }

    private fun getProgress(timeLeftInSeconds: Int): NotificationCompat.Builder {
        val channelId = "timer_channel"
        val contentIntent = Intent(this, MainActivity::class.java)
        val contentPending = PendingIntent.getActivity(
            this,
            0,
            contentIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val stopBroadcast = Intent(STOP_BROADCAST_INTERNAL)
        stopBroadcast.setPackage(applicationContext.packageName)
        val stopPending =
            PendingIntent.getBroadcast(
                applicationContext,
                0,
                stopBroadcast,
                PendingIntent.FLAG_IMMUTABLE
            )
        val addBroadcast =
            Intent(ADD_BROADCAST_INTERNAL).apply {
                setPackage(applicationContext.packageName)
            }
        val addPending =
            PendingIntent.getBroadcast(
                applicationContext,
                0,
                addBroadcast,
                PendingIntent.FLAG_MUTABLE
            )

        val notificationBuilder = NotificationCompat.Builder(this, channelId)
            .setContentTitle(currentDescription)
            .setContentText(formatTime(timeLeftInSeconds))
            .setSmallIcon(R.drawable.baseline_timer_24)
            .setProgress(flexifyTimer.getDurationSeconds(), timeLeftInSeconds, false)
            .setContentIntent(contentPending)
            .setCategory(NotificationCompat.CATEGORY_PROGRESS)
            .setAutoCancel(false)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setOngoing(true)
            .setDeleteIntent(stopPending)
            .addAction(R.drawable.ic_baseline_stop_24, "Stop", stopPending)
            .addAction(R.drawable.ic_baseline_stop_24, "Add 1 min", addPending)

        val notificationManager = NotificationManagerCompat.from(this)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Timer Channel",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            channel.setSound(null, null)
            channel.setBypassDnd(true)
            channel.enableVibration(false)
            channel.description = "Ongoing progress of rest timers."
            channel.lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            notificationManager.createNotificationChannel(channel)
        }

        return notificationBuilder
    }

    private fun vibrate() {
        if (!shouldVibrate) return;
        val pattern =
            longArrayOf(0, 1000, 1000, 1000, 1000, 1000)
        vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val vibratorManager =
                getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
            vibratorManager.defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            getSystemService(VIBRATOR_SERVICE) as Vibrator
        }
        vibrator!!.vibrate(VibrationEffect.createWaveform(pattern, 2))
    }

    private fun notifyFinished() {
        val channelId = "finished_channel"
        val notificationManager = NotificationManagerCompat.from(this)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel =
                NotificationChannel(
                    channelId,
                    "Timer Finished Channel",
                    NotificationManager.IMPORTANCE_HIGH
                )
            channel.setSound(null, null)
            channel.setBypassDnd(true)
            channel.enableVibration(false)
            channel.description = "Plays an alarm when a rest timer completes."
            channel.lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            notificationManager.createNotificationChannel(channel)
        }

        val contentIntent = Intent(this, MainActivity::class.java)
        val contentPending = PendingIntent.getActivity(
            this,
            0,
            contentIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val stopBroadcast = Intent(STOP_BROADCAST_INTERNAL)
        stopBroadcast.setPackage(applicationContext.packageName)
        val pendingStop =
            PendingIntent.getBroadcast(
                applicationContext,
                0,
                stopBroadcast,
                PendingIntent.FLAG_IMMUTABLE
            )
        val addBroadcast =
            Intent(ADD_BROADCAST_INTERNAL).apply { setPackage(applicationContext.packageName) }
        val addPending =
            PendingIntent.getBroadcast(
                applicationContext,
                0,
                addBroadcast,
                PendingIntent.FLAG_MUTABLE
            )

        val builder = NotificationCompat.Builder(this, channelId)
            .setContentTitle("Timer finished")
            .setContentText(currentDescription)
            .setSmallIcon(R.drawable.baseline_timer_24)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setContentIntent(contentPending)
            .setAutoCancel(true)
            .setDeleteIntent(pendingStop)
            .addAction(R.drawable.ic_baseline_stop_24, "Add 1 min", addPending)

        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.POST_NOTIFICATIONS
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            return
        }
        notificationManager.notify(FINISHED_ID, builder.build())
    }

    private fun updateNotification(seconds: Int) {
        val notificationManager = NotificationManagerCompat.from(this)
        val notification = getProgress(seconds)
        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.POST_NOTIFICATIONS
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            return
        }
        notificationManager.notify(ONGOING_ID, notification.build())
    }

    private fun formatTime(timeInSeconds: Int): String {
        val minutes = timeInSeconds / 60
        val seconds = timeInSeconds % 60
        return String.format("%02d:%02d", minutes, seconds)
    }

    companion object {
        const val STOP_BROADCAST = "stop-timer-event"
        const val STOP_BROADCAST_INTERNAL = "stop-timer-event-internal"
        const val ADD_BROADCAST = "add-timer-event"
        const val ADD_BROADCAST_INTERNAL = "add-timer-event-internal"
        const val TIMER_EXPIRED = "timer-expired-event"
        const val ONGOING_ID = 1
        const val FINISHED_ID = 1
    }
}

