package com.presley.flexify

import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

@RequiresApi(Build.VERSION_CODES.O)
class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, FLUTTER_CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "timer") {
                val args = call.arguments as ArrayList<*>
                timer(args[0] as Int, args[1] as String)
            } else {
                result.notImplemented()
            }
        }
    }

    fun timer(milliseconds: Int, description: String) {
        Log.d("MainActivity", "Queue $description for $milliseconds delay")
        val intent = Intent(context, TimerService::class.java)
        intent.putExtra("milliseconds", milliseconds)
        intent.putExtra("description", description)
        context.startForegroundService(intent)
    }

    override fun onResume() {
        super.onResume()
        val intent = Intent(TimerService.STOP_BROADCAST)
        intent.putExtra("check", true);
        sendBroadcast(intent);
    }

    companion object {
        const val FLUTTER_CHANNEL = "com.presley.flexify/android"
    }
}
