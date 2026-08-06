import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  final productNameController = TextEditingController();
  final categoryController = TextEditingController();
  final unitController = TextEditingController();
  final purchasePriceController = TextEditingController();
  final sellingPriceController = TextEditingController();
  final stockController = TextEditingController();
  final notesController = TextEditingController();

  @override
  void dispose() {
    productNameController.dispose();
    categoryController.dispose();
    unitController.dispose();
    purchasePriceController.dispose();
    sellingPriceController.dispose();
    stockController.dispose();
    notesController.dispose();
    super.dispose();
  }
  Future<void> saveProduct() async {
    if (productNameController.text.trim().isEmpty ||
        categoryController.text.trim().isEmpty ||
        unitController.text.trim().isEmpty ||
        purchasePriceController.text.trim().isEmpty ||
        sellingPriceController.text.trim().isEmpty ||
        stockController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all required fields"),
        ),
      );
      return;
    }
    await DatabaseHelper.instance.insertProduct({
      "productName": productNameController.text.trim(),
      "category": categoryController.text.trim(),
      "unit": unitController.text.trim(),
      "purchasePrice": double.parse(
        purchasePriceController.text.trim(),
      ),
      "sellingPrice": double.parse(
        sellingPriceController.text.trim(),
      ),
      "stock": int.parse(
        stockController.text.trim(),
      ),
      "notes": notesController.text.trim(),
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Product Saved Successfully"),
      ),
    );

    Navigator.pop(context, true);
  }
  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          TextField(
            controller: productNameController,
            decoration: inputDecoration(
              "Product Name",
              Icons.inventory,
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: categoryController,
            decoration: inputDecoration(
              "Category",
              Icons.category,
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: unitController,
            decoration: inputDecoration(
              "Unit (Litre, Kg, Packet)",
              Icons.straighten,
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: purchasePriceController,
            keyboardType: TextInputType.number,
            decoration: inputDecoration(
              "Purchase Price",
              Icons.shopping_cart,
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: sellingPriceController,
            keyboardType: TextInputType.number,
            decoration: inputDecoration(
              "Selling Price",
              Icons.currency_rupee,
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: stockController,
            keyboardType: TextInputType.number,
            decoration: inputDecoration(
              "Stock Quantity",
              Icons.inventory_2,
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: notesController,
            maxLines: 3,
            decoration: inputDecoration(
              "Notes",
              Icons.note,
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              onPressed: saveProduct,
              icon: const Icon(Icons.save),
              label: const Text(
                "SAVE PRODUCT",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}