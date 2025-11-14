package com.nduko.chupachap

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.yourapp.maps"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "setApiKey" -> {
                    // The API key is now handled through AndroidManifest.xml and strings.xml
                    // Just return success since we don't need to do anything here
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}