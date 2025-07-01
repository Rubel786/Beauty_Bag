// android/app/src/main/java/com/example/beauty_bag/MyPaymentActivity.java
package com.example.beauty_bag; // Replace with your actual package name

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.plugin.common.MethodChannel;
import androidx.annotation.NonNull; // Import for @NonNull annotation
import java.util.Collections; // For Collections.singletonList
import io.flutter.FlutterInjector; // Import FlutterInjector
import io.flutter.embedding.engine.loader.FlutterLoader; // Import FlutterLoader

public class MyPaymentActivity extends FlutterActivity {

    private static final String CHANNEL = "com.example.payment_module/payment_status"; // This is the channel from module to host activity
    private MethodChannel paymentStatusChannel;

    public static final String EXTRA_AMOUNT = "amount";

    // Name of the Flutter engine to cache/retrieve
    private static final String FLUTTER_ENGINE_ID = "my_payment_engine";

    public static void start(Context context, double amount) {
        // Pre-warm the FlutterEngine if not already running for faster startup
        if (!FlutterEngineCache.getInstance().contains(FLUTTER_ENGINE_ID)) {
            FlutterEngine flutterEngine = new FlutterEngine(context.getApplicationContext());

            // --- Explicitly initialize FlutterLoader before using it ---
            FlutterLoader flutterLoader = FlutterInjector.instance().flutterLoader();
            // Ensure FlutterLoader is initialized. This is crucial for findAppBundlePath() to work.
            if (!flutterLoader.initialized()) {
                flutterLoader.startInitialization(context.getApplicationContext());
                flutterLoader.ensureInitializationComplete(context.getApplicationContext(), null);
            }
            // --- End FlutterLoader initialization ---

            String appBundlePath = flutterLoader.findAppBundlePath();

            // Configure the Dart entrypoint with the bundle path and entrypoint function name
            flutterEngine.getDartExecutor().executeDartEntrypoint(
                    new DartExecutor.DartEntrypoint(
                            appBundlePath, // Provide the app bundle path here
                            "main" // The main() function in your module's lib/main.dart
                    ),
                    Collections.singletonList("/payment") // Initial route as a List<String>
            );
            FlutterEngineCache.getInstance().put(FLUTTER_ENGINE_ID, flutterEngine);
        }

        Intent intent = new Intent(context, MyPaymentActivity.class);
        // Pass arguments to the Flutter module via Intent extras.
        // FlutterActivity's default behavior will pick these up and pass them to the module's initial route.
        intent.putExtra(EXTRA_AMOUNT, amount);
        context.startActivity(intent);
    }

    @Override
    public FlutterEngine provideFlutterEngine(@NonNull Context context) {
        // Provide the cached FlutterEngine to this activity
        return FlutterEngineCache.getInstance().get(FLUTTER_ENGINE_ID);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        // Setup MethodChannel to receive status updates from Flutter module
        paymentStatusChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        paymentStatusChannel.setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("paymentComplete")) {
                        String status = call.argument("status");
                        Double amount = call.argument("amount");
                        String transactionId = call.argument("transactionId");
                        String error = call.argument("error");
                        String paymentMethod = call.argument("paymentMethod"); // Get payment method
                        long timestamp = System.currentTimeMillis();

                        // Send a broadcast to MainActivity (or any other part of your native app)
                        // This is how the main Flutter app (via its MainActivity) will get the result.
                        Intent paymentResultIntent = new Intent("com.example.beauty_bag.PAYMENT_STATUS_UPDATE"); // Use your main app's package name
                        paymentResultIntent.putExtra("status", status);
                        paymentResultIntent.putExtra("amount", amount);
                        paymentResultIntent.putExtra("transactionId", transactionId);
                        paymentResultIntent.putExtra("error", error);
                        paymentResultIntent.putExtra("paymentMethod", paymentMethod); // Pass payment method
                        paymentResultIntent.putExtra("timestamp", timestamp);
                        sendBroadcast(paymentResultIntent);

                        finish(); // Close MyPaymentActivity
                        result.success(null); // Acknowledge the call
                    } else {
                        result.notImplemented();
                    }
                }
        );
    }

    @Override
    public void cleanUpFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        // When this activity is destroyed, you can choose to remove the engine from cache
        // if you don't need it immediately again or want to free resources.
        // FlutterEngineCache.getInstance().remove(FLUTTER_ENGINE_ID);
        super.cleanUpFlutterEngine(flutterEngine);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // No need for FlutterMain.startInitialization or ensureInitializationComplete here.
        // FlutterActivity handles it.
    }
}
