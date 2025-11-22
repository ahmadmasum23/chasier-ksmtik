class StockModel {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final String location;
  final DateTime lastUpdated;

  StockModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.location,
    required this.lastUpdated,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      id: json['id'] ?? '',
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      quantity: json['quantity'] ?? 0,
      location: json['location'] ?? '',
      lastUpdated: DateTime.parse(json['last_updated'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'location': location,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}