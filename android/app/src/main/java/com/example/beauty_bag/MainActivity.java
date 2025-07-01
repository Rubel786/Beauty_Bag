// android/app/src/main/java/com/example/beauty_bag/MainActivity.java
package com.example.beauty_bag; // Replace with your actual package name

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import androidx.annotation.NonNull; // Import for @NonNull annotation

public class MainActivity extends FlutterActivity {
    // Channel name for communication from main Flutter app to native (to launch module)
    private static final String LAUNCH_CHANNEL = "com.example.beauty_bag/payment_launcher"; // Use your main app's package name
    private MethodChannel launchMethodChannel;

    // Channel name for communication from native to main Flutter app (to send results)
    private static final String RESULT_CHANNEL = "com.example.beauty_bag/payment_result"; // Use your main app's package name
    private MethodChannel resultEventChannel;

    private BroadcastReceiver paymentStatusReceiver;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        // 1. Setup MethodChannel to listen for calls from main Flutter app (to launch module)
        launchMethodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), LAUNCH_CHANNEL);
        launchMethodChannel.setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("launchPaymentModule")) {
                        Double amount = call.argument("amount");
                        if (amount != null) {
                            MyPaymentActivity.start(this, amount); // Launch the activity hosting the Flutter module
                            result.success("Payment module launch initiated.");
                        } else {
                            result.error("INVALID_ARGUMENT", "Amount not provided for payment module.", null);
                        }
                    } else {
                        result.notImplemented();
                    }
                }
        );

        // 2. Setup MethodChannel to send payment results back to main Flutter app's Dart side
        resultEventChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), RESULT_CHANNEL);

        // 3. Register a BroadcastReceiver to get status updates from MyPaymentActivity
        paymentStatusReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                if (intent != null && intent.getAction() != null && intent.getAction().equals("com.example.beauty_bag.PAYMENT_STATUS_UPDATE")) { // Use your main app's package name
                    String status = intent.getStringExtra("status");
                    Double amount = intent.getDoubleExtra("amount", 0.0);
                    String transactionId = intent.getStringExtra("transactionId");
                    String error = intent.getStringExtra("error");
                    String paymentMethod = intent.getStringExtra("paymentMethod"); // Get payment method
                    long timestamp = intent.getLongExtra("timestamp", 0);

                    // Invoke method on the main Flutter app's Dart side
                    resultEventChannel.invokeMethod(
                            "onPaymentResult",
                            new java.util.HashMap<String, Object>() {{
                                put("status", status);
                                put("amount", amount);
                                put("transactionId", transactionId);
                                put("error", error);
                                put("paymentMethod", paymentMethod); // Pass payment method
                                put("timestamp", timestamp);
                            }}
                    );
                }
            }
        };
        IntentFilter filter = new IntentFilter("com.example.beauty_bag.PAYMENT_STATUS_UPDATE"); // Use your main app's package name
        registerReceiver(paymentStatusReceiver, filter);
    }

    @Override
    public void cleanUpFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        // Unregister the receiver when the activity is destroyed to prevent leaks
        unregisterReceiver(paymentStatusReceiver);
        super.cleanUpFlutterEngine(flutterEngine);
    }
}
