import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/features/suppliers/presentation/suppliers_controller.dart';
import 'package:pharmacy_app/features/suppliers/data/supplier_model.dart';

class SuppliersScreen extends ConsumerWidget {
  const SuppliersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suppliersState = ref.watch(suppliersControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Suppliers')),
      body: suppliersState.when(
        data: (suppliers) => suppliers.isEmpty
            ? const Center(child: Text('No suppliers found'))
            : ListView.builder(
                itemCount: suppliers.length,
                itemBuilder: (context, index) {
                  final supplier = suppliers[index];
                  return ListTile(
                    title: Text(supplier.name),
                    subtitle: Text('${supplier.contactPhone ?? "No phone"} | ${supplier.email ?? "No email"}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                         if (supplier.id != null) {
                            ref.read(suppliersControllerProvider.notifier).deleteSupplier(supplier.id!);
                         }
                      },
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSupplierDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddSupplierDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Supplier'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                ref.read(suppliersControllerProvider.notifier).addSupplier(
                      nameController.text,
                      phone: phoneController.text,
                      email: emailController.text,
                      address: addressController.text,
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
