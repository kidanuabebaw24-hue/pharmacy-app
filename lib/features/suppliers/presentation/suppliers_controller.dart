import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pharmacy_app/features/suppliers/data/supplier_model.dart';
import 'package:pharmacy_app/features/suppliers/data/supplier_repository.dart';

part 'suppliers_controller.g.dart';

@riverpod
class SuppliersController extends _$SuppliersController {
  @override
  Stream<List<Supplier>> build() {
    final repository = ref.watch(supplierRepositoryProvider);
    return repository.watchAllSuppliers();
  }

  Future<void> addSupplier(String name, {String? phone, String? email, String? address}) async {
    final repository = ref.read(supplierRepositoryProvider);
    final supplier = Supplier(
      name: name,
      contactPhone: phone,
      email: email,
      address: address,
    );
    
    await AsyncValue.guard(() async {
      await repository.addSupplier(supplier);
    });
  }
  
  Future<void> deleteSupplier(String id) async {
    final repository = ref.read(supplierRepositoryProvider);
    await AsyncValue.guard(() async {
      await repository.deleteSupplier(id);
    });
  }
}
