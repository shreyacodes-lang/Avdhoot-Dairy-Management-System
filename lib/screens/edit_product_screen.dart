import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class EditProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const EditProductScreen({
    super.key,
    required this.product,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final productNameController = TextEditingController();
  final categoryController = TextEditingController();
  final unitController = TextEditingController();
  final purchasePriceController = TextEditingController();
  final sellingPriceController = TextEditingController();
  final stockController = TextEditingController();
  final notesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    productNameController.text =
        widget.product["productName"]?.toString() ?? "";

    categoryController.text =
        widget.product["category"]?.toString() ?? "";

    unitController.text =
        widget.product["unit"]?.toString() ?? "";

    purchasePriceController.text =
        widget.product["purchasePrice"]?.toString() ?? "";

    sellingPriceController.text =
        widget.product["sellingPrice"]?.toString() ?? "";

    stockController.text =
        widget.product["stock"]?.toString() ?? "";

    notesController.text =
        widget.product["notes"]?.toString() ?? "";
  }

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

  InputDecoration inputDecoration(
      String label,
      IconData icon,
      ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Future<void> updateProduct() async {
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

    await DatabaseHelper.instance.updateProduct(
      widget.product["id"],
      {
        "productName": productNameController.text.trim(),
        "category": categoryController.text.trim(),
        "unit": unitController.text.trim(),
        "purchasePrice":
        double.parse(purchasePriceController.text.trim()),
        "sellingPrice":
        double.parse(sellingPriceController.text.trim()),
        "stock":
        int.parse(stockController.text.trim()),
        "notes": notesController.text.trim(),
      },
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Product Updated Successfully"),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
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
              "Unit",
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
              onPressed: updateProduct,
              icon: const Icon(Icons.save),
              label: const Text(
                "UPDATE PRODUCT",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}