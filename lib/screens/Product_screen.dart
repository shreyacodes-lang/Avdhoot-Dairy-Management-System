import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final data = await DatabaseHelper.instance.getProducts();

    setState(() {
      products = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        backgroundColor: Colors.blue,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProductScreen(),
            ),
          );

          if (result == true) {
            loadProducts();
          }
        },
        child: const Icon(Icons.add),
      ),

      body: products.isEmpty
          ? const Center(
        child: Text(
          "No Products Found",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProductScreen(
                      product: product,
                    ),
                  ),
                );

                if (result == true) {
                  await loadProducts();
                }
              },
              leading: const CircleAvatar(
                child: Icon(Icons.inventory),
              ),

              title: Text(
                product["productName"].toString(),
              ),

              subtitle: Text(
                "${product["category"]} • ₹${product["sellingPrice"]}/${product["unit"]}\n"
                    "Stock : ${product["stock"]}",
              ),

              isThreeLine: true,

              trailing: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Delete Product"),
                      content: const Text(
                        "Are you sure you want to delete this product?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await DatabaseHelper.instance.deleteProduct(
                      product["id"],
                    );

                    await loadProducts();

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Product Deleted Successfully",
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}