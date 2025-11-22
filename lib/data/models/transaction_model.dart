class TransactionModel {
  final String id;
  final String customerId;
  final List<TransactionItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final DateTime timestamp;
  final String paymentMethod;
  final String status;

  TransactionModel({
    required this.id,
    required this.customerId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.timestamp,
    required this.paymentMethod,
    required this.status,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    List<TransactionItem> itemsList = [];
    if (json['items'] != null) {
      itemsList = (json['items'] as List)
          .map((item) => TransactionItem.fromJson(item))
          .toList();
    }

    return TransactionModel(
      id: json['id'] ?? '',
      customerId: json['customer_id'] ?? '',
      items: itemsList,
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      paymentMethod: json['payment_method'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'timestamp': timestamp.toIso8601String(),
      'payment_method': paymentMethod,
      'status': status,
    };
  }
}

class TransactionItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price;

  TransactionItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'price': price,
    };
  }
}