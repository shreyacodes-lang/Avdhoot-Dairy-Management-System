import 'package:flutter/material.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  String? selectedCustomer;
  String? selectedProduct;

  final quantityController = TextEditingController();
  final rateController = TextEditingController();

  double totalAmount = 0;

  final List<String> customers = [
    "Hotel Taj",
    "Hotel Blue Star",
    "Shree Restaurant",
  ];

  final List<String> products = [
    "Cow Milk",
    "Buffalo Milk",
    "Curd",
    "Paneer",
  ];

  @override
  void dispose() {
    quantityController.dispose();
    rateController.dispose();
    super.dispose();
  }

  void calculateTotal() {
    final quantity = double.tryParse(quantityController.text) ?? 0;
    final rate = double.tryParse(rateController.text) ?? 0;

    setState(() {
      totalAmount = quantity * rate;
    });
  }

  void generateBill() {
    if (selectedCustomer == null ||
        selectedProduct == null ||
        quantityController.text.trim().isEmpty ||
        rateController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    calculateTotal();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Bill Generated Successfully"),
      ),
    );
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

          DropdownButtonFormField<String>(
            initialValue: selectedCustomer,
            decoration: inputDecoration(
              "Select Customer",
              Icons.person,
            ),
            items: customers.map((customer) {
              return DropdownMenuItem(
                value: customer,
                child: Text(customer),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCustomer = value;
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

          DropdownButtonFormField<String>(
            initialValue: selectedProduct,
            decoration: inputDecoration(
              "Select Product",
              Icons.local_drink,
            ),
            items: products.map((product) {
              return DropdownMenuItem(
                value: product,
                child: Text(product),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedProduct = value;
              });
            },
          ),

          const SizedBox(height: 15),

          TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            onChanged: (_) => calculateTotal(),
            decoration: inputDecoration(
              "Quantity",
              Icons.scale,
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: rateController,
            keyboardType: TextInputType.number,
            onChanged: (_) => calculateTotal(),
            decoration: inputDecoration(
              "Rate (₹)",
              Icons.currency_rupee,
            ),
          ),

          const SizedBox(height: 25),

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
              icon: const Icon(Icons.receipt_long),
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