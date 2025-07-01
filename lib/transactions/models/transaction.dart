class Transaction {
  final String id;
  final double amount;
  final String status; // 'success', 'failed', 'pending'
  final DateTime timestamp;
  final String? paymentMethod;
  final String? errorMessage;

  Transaction({
    required this.id,
    required this.amount,
    required this.status,
    required this.timestamp,
    this.paymentMethod,
    this.errorMessage,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      amount: json['amount'] as double,
      status: json['status'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      paymentMethod: json['paymentMethod'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'status': status,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'paymentMethod': paymentMethod,
      'errorMessage': errorMessage,
    };
  }
}
