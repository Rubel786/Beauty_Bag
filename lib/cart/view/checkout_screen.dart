// lib/cart/view/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../transactions/models/transaction.dart';
import '../../transactions/services/transaction_service.dart';
import '../../transactions/ui/transaction_list_screen.dart'; // For MethodChannel


class CheckoutScreen extends StatefulWidget {
  final double amount; // Add this property to receive the amount

  const CheckoutScreen({super.key, required this.amount}); // Update constructor

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // MethodChannel to launch the payment module (from main Flutter app to native Android)
  static const MethodChannel _launchPaymentChannel =
  MethodChannel('com.example.beauty_bag/payment_launcher'); // IMPORTANT: Match your MainActivity.kt

  // MethodChannel to receive payment results (from native Android back to main Flutter app)
  static const MethodChannel _paymentResultChannel =
  MethodChannel('com.example.beauty_bag/payment_result'); // IMPORTANT: Match your MainActivity.kt

  @override
  void initState() {
    super.initState();
    // Set up the MethodChannel handler to listen for payment results from native
    _paymentResultChannel.setMethodCallHandler(_handlePaymentResult);
  }

  Future<void> _handlePaymentResult(MethodCall call) async {
    if (call.method == 'onPaymentResult') {
      final status = call.arguments['status'] as String?;
      final amount = call.arguments['amount'] as double? ?? 0.0;
      final transactionId = call.arguments['transactionId'] as String? ?? 'N/A';
      final error = call.arguments['error'] as String?;
      final String? paymentMethod = call.arguments['paymentMethod'] as String?; // Get payment method
      final timestamp = call.arguments['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch;

      String message;
      Color snackBarColor;
      String transactionStatus;

      if (status == 'success') {
        message = 'Payment Successful! 🎉 Order confirmed.';
        snackBarColor = Colors.green;
        transactionStatus = 'success';
      } else if (status == 'failed') {
        message = 'Payment Failed: ${error ?? "Unknown error"} ❌';
        snackBarColor = Colors.red;
        transactionStatus = 'failed';
      } else if (status == 'pending_user_action') {
        message = 'Payment pending user action. Please complete the process.';
        snackBarColor = Colors.orange;
        transactionStatus = 'pending';
      } else {
        message = 'Payment status unknown.';
        snackBarColor = Colors.grey;
        transactionStatus = 'unknown';
      }

      // Add the transaction to our in-memory service
      TransactionService.addTransaction(
        Transaction(
          id: transactionId,
          amount: amount,
          status: transactionStatus,
          timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
          paymentMethod: paymentMethod, // Pass the received payment method
          errorMessage: error,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: snackBarColor,
        ),
      );

      // --- CRITICAL NAVIGATION CHANGE ---
      // Use pushReplacement to replace the current CheckoutScreen with TransactionListScreen
      // This ensures a clean navigation flow after the payment module closes.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TransactionListScreen()),
      );
      // --- END CRITICAL NAVIGATION CHANGE ---
    }
  }

  // This method will be called when the user wants to initiate payment
  Future<void> _launchPaymentModule() async {
    try {
      // Invoke a method on the native side to launch the payment module
      final String? result = await _launchPaymentChannel.invokeMethod(
        'launchPaymentModule',
        {'amount': widget.amount}, // Pass the dynamic amount from widget.amount
      );
      debugPrint('Launch payment module result: $result');
      // The actual payment result will be received via _handlePaymentResult callback
    } on PlatformException catch (e) {
      debugPrint("Failed to launch payment module: '${e.message}'.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching payment: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'View Transactions',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TransactionListScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your Total: \$${widget.amount.toStringAsFixed(2)}', // Display dynamic amount
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _launchPaymentModule,
                icon: const Icon(Icons.payment, size: 28),
                label: const Text(
                  'Proceed to Payment',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 8,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'This button will launch the simulated payment module.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
