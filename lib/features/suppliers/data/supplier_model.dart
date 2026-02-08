class Supplier {
  final String? id;
  final String name;
  final String? contactPhone;
  final String? email;
  final String? address;

  Supplier({
    this.id,
    required this.name,
    this.contactPhone,
    this.email,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contactPhone': contactPhone,
      'email': email,
      'address': address,
    };
  }

  factory Supplier.fromMap(Map<String, dynamic> map, String id) {
    return Supplier(
      id: id,
      name: map['name'] ?? '',
      contactPhone: map['contactPhone'],
      email: map['email'],
      address: map['address'],
    );
  }
}
