import 'dart:async';
import 'package:collection/collection.dart';
import '../models/transaction.dart'; // For sorting


class TransactionService {
  // Using a static list for simplicity to simulate persistence across the app lifecycle
  static final List<Transaction> _transactions = [];

  // Add a stream to notify listeners when transactions change
  static final StreamController<List<Transaction>> _transactionsController =
  StreamController<List<Transaction>>.broadcast();

  static Stream<List<Transaction>> get transactionsStream => _transactionsController.stream;

  static void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    // Sort transactions by timestamp (most recent first)
    _transactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    _transactionsController.add(List.from(_transactions)); // Emit updated list
  }

  static List<Transaction> getTransactions() {
    return List.from(_transactions); // Return a copy to prevent external modification
  }

  // Clear all transactions (for testing/development)
  static void clearTransactions() {
    _transactions.clear();
    _transactionsController.add(List.from(_transactions));
  }
}
