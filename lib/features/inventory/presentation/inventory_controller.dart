import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pharmacy_app/features/inventory/data/product_model.dart';
import 'package:pharmacy_app/features/inventory/data/inventory_repository.dart';

part 'inventory_controller.g.dart';

@riverpod
class InventoryController extends _$InventoryController {
  @override
  Stream<List<Product>> build() {
    final repository = ref.watch(inventoryRepositoryProvider);
    return repository.watchAllProducts();
  }

  Future<void> addProduct(String name, String barcode, double price, int quantity) async {
    final repository = ref.read(inventoryRepositoryProvider);
    final product = Product(
      name: name,
      barcode: barcode,
      price: price,
      stockQuantity: quantity,
      lastUpdated: DateTime.now(),
    );
      
    // state = const AsyncLoading(); // Stream provider handles loading automatically if we return the stream in build
    // However, for actions, we might want to handle side effects.
    // Since build returns a Stream, we don't manually set state to data usually, 
    // the stream update will trigger a rebuild. 
    // But we can set loading state during the operation if we want.
    
    await AsyncValue.guard(() async {
      await repository.addProduct(product);
    });
  }
  
  Future<void> deleteProduct(String id) async {
    final repository = ref.read(inventoryRepositoryProvider);
    await AsyncValue.guard(() async {
      await repository.deleteProduct(id);
    });
  }
}
