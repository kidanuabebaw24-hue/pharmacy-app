import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'order_model.dart';

part 'order_repository.g.dart';

@riverpod
OrderRepository orderRepository(OrderRepositoryRef ref) {
  return OrderRepository(FirebaseFirestore.instance);
}

class OrderRepository {
  final FirebaseFirestore _firestore;

  OrderRepository(this._firestore);

  CollectionReference<OrderModel> _getCollection() {
    return _firestore.collection('orders').withConverter<OrderModel>(
          fromFirestore: (snapshot, _) => OrderModel.fromMap(snapshot.data()!, snapshot.id),
          toFirestore: (order, _) => order.toMap(),
        );
  }

  Future<List<OrderModel>> getAllOrders() async {
    final snapshot = await _getCollection().orderBy('orderDate', descending: true).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Stream<List<OrderModel>> watchAllOrders() {
    return _getCollection().orderBy('orderDate', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> createOrder(OrderModel order) async {
    await _getCollection().add(order);
  }

  Future<void> updateOrderStatus(String id, String status) async {
    await _getCollection().doc(id).update({'status': status});
  }
  
  Future<void> deleteOrder(String id) async {
    await _getCollection().doc(id).delete();
  }
}
