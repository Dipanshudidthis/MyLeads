package com.example.flutter_application_1

import android.content.Intent
import android.net.Uri
import android.os.PowerManager
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val batteryChannel = "leads_import/battery"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, batteryChannel)
            .setMethodCallHandler { call, result ->
                val powerManager = getSystemService(POWER_SERVICE) as PowerManager
                when (call.method) {
                    "isIgnoringBatteryOptimizations" ->
                        result.success(powerManager.isIgnoringBatteryOptimizations(packageName))
                    "requestIgnoreBatteryOptimizations" -> {
                        val intent = Intent(
                            Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS,
                            Uri.parse("package:$packageName"),
                        )
                        startActivity(intent)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
