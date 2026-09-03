import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  List<Map<String, dynamic>> customers = [];
  List<Map<String, dynamic>> products = [];

  int? selectedCustomerId;
  int? selectedProductId;

  final quantityController = TextEditingController();

  double totalAmount = 0;

  @override
  void initState() {
    super.initState();
    loadCustomers();
    loadProducts();
  }

  Future<void> loadCustomers() async {
    final data = await DatabaseHelper.instance.getCustomers();

    if (!mounted) return;

    setState(() {
      customers = data;
    });
  }

  Future<void> loadProducts() async {
    final data = await DatabaseHelper.instance.getProducts();

    if (!mounted) return;

    setState(() {
      products = data;
    });
  }

  Map<String, dynamic>? get selectedProduct {
    if (selectedProductId == null) return null;

    try {
      return products.firstWhere(
            (product) => product["id"] == selectedProductId,
      );
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic>? get selectedCustomer {
    if (selectedCustomerId == null) return null;

    try {
      return customers.firstWhere(
            (customer) => customer["id"] == selectedCustomerId,
      );
    } catch (_) {
      return null;
    }
  }

  void calculateTotal() {
    final quantity =
        double.tryParse(quantityController.text.trim()) ?? 0;

    final rate =
        double.tryParse(
          selectedProduct?["sellingPrice"].toString() ?? "",
        ) ??
            0;

    setState(() {
      totalAmount = quantity * rate;
    });
  }

  Future<void> generateBill() async {
    if (selectedCustomer == null ||
        selectedProduct == null ||
        quantityController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select customer, product and quantity",
          ),
        ),
      );
      return;
    }

    final quantity =
    double.tryParse(quantityController.text.trim());

    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid quantity"),
        ),
      );
      return;
    }

    final rate =
        double.tryParse(
          selectedProduct!["sellingPrice"].toString(),
        ) ??
            0;

    final total = quantity * rate;

    await DatabaseHelper.instance.insertBill({
      "customerName":
      selectedCustomer!["customerName"].toString(),

      "productName":
      selectedProduct!["productName"].toString(),

      "quantity": quantity,

      "rate": rate,

      "billDate":
      DateTime.now().toIso8601String(),

      "totalAmount": total,
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Bill Generated Successfully",
        ),
      ),
    );

    setState(() {
      selectedCustomerId = null;
      selectedProductId = null;
      quantityController.clear();
      totalAmount = 0;
    });
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

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Bill"),
        backgroundColor: Colors.blue,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          const Text(
            "Customer Details",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          DropdownButtonFormField<int>(
            initialValue: selectedCustomerId,

            decoration: inputDecoration(
              "Select Customer",
              Icons.person,
            ),

            items: customers.map((customer) {
              return DropdownMenuItem<int>(
                value: customer["id"] as int,
                child: Text(
                  customer["customerName"].toString(),
                ),
              );
            }).toList(),

            onChanged: (value) {
              setState(() {
                selectedCustomerId = value;
              });
            },
          ),

          const SizedBox(height: 25),

          const Text(
            "Product Details",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          DropdownButtonFormField<int>(
            initialValue: selectedProductId,

            decoration: inputDecoration(
              "Select Product",
              Icons.local_drink,
            ),

            items: products.map((product) {
              return DropdownMenuItem<int>(
                value: product["id"] as int,
                child: Text(
                  product["productName"].toString(),
                ),
              );
            }).toList(),

            onChanged: (value) {
              setState(() {
                selectedProductId = value;
              });

              calculateTotal();
            },
          ),

          const SizedBox(height: 15),

          TextField(
            controller: quantityController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),

            onChanged: (_) {
              calculateTotal();
            },

            decoration: inputDecoration(
              "Quantity",
              Icons.scale,
            ),
          ),

          const SizedBox(height: 15),

          if (selectedProduct != null)
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

                  children: [
                    const Text(
                      "Rate",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      "₹${selectedProduct!["sellingPrice"]}/${selectedProduct!["unit"]}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 15),

          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    "Total Amount",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    "₹${totalAmount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            height: 55,

            child: ElevatedButton.icon(
              onPressed: generateBill,

              icon: const Icon(
                Icons.receipt_long,
              ),

              label: const Text(
                "GENERATE BILL",
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