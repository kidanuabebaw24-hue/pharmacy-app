import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_app/features/orders/presentation/orders_controller.dart';
import 'package:pharmacy_app/features/orders/data/order_model.dart';
import 'package:pharmacy_app/features/orders/presentation/create_order_screen.dart'; // Fixed import path

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState = ref.watch(ordersControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: ordersState.when(
        data: (orders) => orders.isEmpty
            ? const Center(child: Text('No orders found'))
            : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return ListTile(
                    title: Text(order.orderNumber),
                    subtitle: Text('${DateFormat('yyyy-MM-dd HH:mm').format(order.orderDate)} - ${order.status}'),
                    trailing: Text('\$${order.totalAmount.toStringAsFixed(2)}'),
                    onTap: () {
                      _showOrderDetails(context, order);
                    },
                   onLongPress: () {
                      if (order.id != null) {
                         // Optional: confirmation dialog before delete
                         ref.read(ordersControllerProvider.notifier).deleteOrder(order.id!);
                      }
                   },
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateOrderScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showOrderDetails(BuildContext context, OrderModel order) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Order: ${order.orderNumber}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            ...order.items.map((item) => Text(
                  '${item.productName} (x${item.quantity}) - \$${(item.price * item.quantity).toStringAsFixed(2)}',
                )),
            const Divider(),
            Text('Total: \$${order.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
