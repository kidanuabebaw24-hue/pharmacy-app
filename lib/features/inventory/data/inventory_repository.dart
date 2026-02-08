import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'product_model.dart';

part 'inventory_repository.g.dart';

@riverpod
InventoryRepository inventoryRepository(InventoryRepositoryRef ref) {
  return InventoryRepository(FirebaseFirestore.instance);
}

class InventoryRepository {
  final FirebaseFirestore _firestore;

  InventoryRepository(this._firestore);

  CollectionReference<Product> _getProductsCollection() {
    return _firestore.collection('products').withConverter<Product>(
          fromFirestore: (snapshot, _) => Product.fromMap(snapshot.data()!, snapshot.id),
          toFirestore: (product, _) => product.toMap(),
        );
  }

  Future<List<Product>> getAllProducts() async {
    final snapshot = await _getProductsCollection().get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<Product?> getProductByBarcode(String barcode) async {
    final snapshot = await _getProductsCollection()
        .where('barcode', isEqualTo: barcode)
        .limit(1)
        .get();
        
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data();
  }

  Future<void> addProduct(Product product) async {
    // Check if product with barcode exists
    final existing = await getProductByBarcode(product.barcode);
    if (existing != null) {
      throw Exception('Product with this barcode already exists');
    }
    
    await _getProductsCollection().add(product);
  }

  Future<void> updateProduct(Product product) async {
    if (product.id == null) return;
    await _getProductsCollection().doc(product.id).set(product);
  }

  Future<void> deleteProduct(String id) async {
    await _getProductsCollection().doc(id).delete();
  }
  
  Stream<List<Product>> watchAllProducts() {
    return _getProductsCollection().snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}
