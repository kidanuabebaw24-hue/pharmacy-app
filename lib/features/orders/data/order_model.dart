
class OrderModel {
  final String? id;
  final String orderNumber;
  final DateTime orderDate;
  final double totalAmount;
  final String status; // pending, completed, cancelled
  final List<OrderItem> items;

  OrderModel({
    this.id,
    required this.orderNumber,
    required this.orderDate,
    this.totalAmount = 0.0,
    this.status = 'pending',
    this.items = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'orderNumber': orderNumber,
      'orderDate': orderDate.toIso8601String(),
      'totalAmount': totalAmount,
      'status': status,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      orderNumber: map['orderNumber'] ?? '',
      orderDate: map['orderDate'] != null ? DateTime.parse(map['orderDate']) : DateTime.now(),
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] ?? 'pending',
      items: (map['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromMap(item))
              .toList() ?? [],
    );
  }
}

class OrderItem {
  final String productName;
  final String productBarcode;
  final int quantity;
  final double price;

  OrderItem({
    required this.productName,
    required this.productBarcode,
    this.quantity = 1,
    this.price = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'productBarcode': productBarcode,
      'quantity': quantity,
      'price': price,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productName: map['productName'] ?? '',
      productBarcode: map['productBarcode'] ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
