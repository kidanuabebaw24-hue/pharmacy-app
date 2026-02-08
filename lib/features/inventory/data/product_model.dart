
class Product {
  String? id;
  late String barcode;
  late String name;
  String? description;
  double price = 0.0;
  int stockQuantity = 0;
  String? supplierId;
  DateTime? lastUpdated;

  Product({
    this.id,
    required this.barcode,
    required this.name,
    this.description,
    this.price = 0.0,
    this.stockQuantity = 0,
    this.supplierId,
    this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'barcode': barcode,
      'name': name,
      'description': description,
      'price': price,
      'stockQuantity': stockQuantity,
      'supplierId': supplierId,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      barcode: map['barcode'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      stockQuantity: (map['stockQuantity'] as num?)?.toInt() ?? 0,
      supplierId: map['supplierId'],
      lastUpdated: map['lastUpdated'] != null ? DateTime.parse(map['lastUpdated']) : null,
    );
  }
}
