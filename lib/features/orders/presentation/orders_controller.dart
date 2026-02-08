import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pharmacy_app/features/orders/data/order_model.dart';
import 'package:pharmacy_app/features/orders/data/order_repository.dart';

part 'orders_controller.g.dart';

@riverpod
class OrdersController extends _$OrdersController {
  @override
  Stream<List<OrderModel>> build() {
    final repository = ref.watch(orderRepositoryProvider);
    return repository.watchAllOrders();
  }

  Future<void> createOrder(OrderModel order) async {
    final repository = ref.read(orderRepositoryProvider);
    await AsyncValue.guard(() async {
      await repository.createOrder(order);
    });
  }
  
  Future<void> deleteOrder(String id) async {
    final repository = ref.read(orderRepositoryProvider);
    await AsyncValue.guard(() async {
      await repository.deleteOrder(id);
    });
  }
}
