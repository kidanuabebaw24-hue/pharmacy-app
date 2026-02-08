import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/features/inventory/data/inventory_repository.dart';
import 'package:pharmacy_app/features/inventory/data/product_model.dart';
import 'package:pharmacy_app/features/orders/data/order_model.dart';
import 'package:pharmacy_app/features/orders/presentation/orders_controller.dart';
import 'dart:math';

class CreateOrderScreen extends ConsumerStatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  ConsumerState<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends ConsumerState<CreateOrderScreen> {
  final List<OrderItem> _selectedItems = [];

  double get _totalAmount => _selectedItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  @override
  Widget build(BuildContext context) {
    // We fetch products directly from repository for simplicity, or we could use InventoryController
    final productsAsync = ref.watch(inventoryRepositoryProvider).watchAllProducts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Order'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _selectedItems.isEmpty ? null : _submitOrder,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: productsAsync,
              builder: (context, snapshot) {
                if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final products = snapshot.data!;
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text('\$${product.price.toStringAsFixed(2)} | Stock: ${product.stockQuantity}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () => _addToCart(product),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Cart (${_selectedItems.length} items)', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    itemCount: _selectedItems.length,
                    itemBuilder: (context, index) {
                      final item = _selectedItems[index];
                      return ListTile(
                        dense: true,
                        title: Text(item.productName),
                        subtitle: Text('x${item.quantity} - \$${(item.price * item.quantity).toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            setState(() {
                              _selectedItems.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Text('Total: \$${_totalAmount.toStringAsFixed(2)}', 
                     style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                     textAlign: TextAlign.end),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(Product product) {
    setState(() {
      // Check if already in cart
      final existingIndex = _selectedItems.indexWhere((item) => item.productBarcode == product.barcode);
      if (existingIndex >= 0) {
        // Update quantity
        final existing = _selectedItems[existingIndex];
        _selectedItems[existingIndex] = OrderItem(
          productName: existing.productName,
          productBarcode: existing.productBarcode,
          quantity: existing.quantity + 1,
          price: existing.price,
        );
      } else {
        // Add new
        _selectedItems.add(OrderItem(
          productName: product.name,
          productBarcode: product.barcode,
          quantity: 1,
          price: product.price,
        ));
      }
    });
  }

  void _submitOrder() {
    final order = OrderModel(
      orderNumber: 'ORD-${Random().nextInt(99999)}', // Simple random ID for demo
      orderDate: DateTime.now(),
      status: 'pending',
      items: _selectedItems,
      totalAmount: _totalAmount,
    );

    ref.read(ordersControllerProvider.notifier).createOrder(order);
    Navigator.pop(context);
  }
}
