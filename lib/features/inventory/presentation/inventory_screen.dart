import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_app/features/inventory/presentation/inventory_controller.dart';
import 'package:pharmacy_app/features/inventory/data/product_model.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryState = ref.watch(inventoryControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: inventoryState.when(
        data: (products) => products.isEmpty
            ? const Center(child: Text('No products found'))
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('Barcode: ${product.barcode} | Stock: ${product.stockQuantity}'),
                    trailing: Text('\$${product.price.toStringAsFixed(2)}'),
                    onTap: () {
                      // Navigate to details or edit
                    },
                    onLongPress: () {
                      if (product.id != null) {
                        ref.read(inventoryControllerProvider.notifier).deleteProduct(product.id!);
                      }
                    },
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/inventory/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
