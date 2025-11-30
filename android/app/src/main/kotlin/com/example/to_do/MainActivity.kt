package com.example.to_do

import android.content.Context
import android.media.AudioManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "com.todo.app/audio"
    private var previousRingerMode: Int = AudioManager.RINGER_MODE_NORMAL

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "setRingerMode") {
                val mute = call.argument<Boolean>("mute") ?: false
                val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager

                try {
                    if (mute) {
                        // Save current mode before muting
                        previousRingerMode = audioManager.ringerMode
                        // Set to silent mode
                        audioManager.ringerMode = AudioManager.RINGER_MODE_SILENT
                    } else {
                        // Restore previous mode
                        audioManager.ringerMode = previousRingerMode
                    }
                    result.success(true)
                } catch (e: Exception) {
                    result.error("AUDIO_ERROR", "Failed to change ringer mode: ${e.message}", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
