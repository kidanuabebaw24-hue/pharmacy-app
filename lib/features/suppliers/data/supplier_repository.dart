import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'supplier_model.dart';

part 'supplier_repository.g.dart';

@riverpod
SupplierRepository supplierRepository(SupplierRepositoryRef ref) {
  return SupplierRepository(FirebaseFirestore.instance);
}

class SupplierRepository {
  final FirebaseFirestore _firestore;

  SupplierRepository(this._firestore);

  CollectionReference<Supplier> _getCollection() {
    return _firestore.collection('suppliers').withConverter<Supplier>(
          fromFirestore: (snapshot, _) => Supplier.fromMap(snapshot.data()!, snapshot.id),
          toFirestore: (supplier, _) => supplier.toMap(),
        );
  }

  Future<List<Supplier>> getAllSuppliers() async {
    final snapshot = await _getCollection().get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Stream<List<Supplier>> watchAllSuppliers() {
    return _getCollection().snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> addSupplier(Supplier supplier) async {
    await _getCollection().add(supplier);
  }

  Future<void> updateSupplier(Supplier supplier) async {
    if (supplier.id == null) return;
    await _getCollection().doc(supplier.id).set(supplier);
  }

  Future<void> deleteSupplier(String id) async {
    await _getCollection().doc(id).delete();
  }
}
