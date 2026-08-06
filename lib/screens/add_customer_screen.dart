import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final customerNameController = TextEditingController();
  final businessNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final notesController = TextEditingController();

  @override
  void dispose() {
    customerNameController.dispose();
    businessNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> saveCustomer() async {
    print("SAVE BUTTON CLICKED");

    if (customerNameController.text.trim().isEmpty ||
        businessNameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all required fields"),
        ),
      );
      return;
    }

    try {
      await DatabaseHelper.instance.insertCustomer({
        "customerName": customerNameController.text.trim(),
        "businessName": businessNameController.text.trim(),
        "phone": phoneController.text.trim(),
        "address": addressController.text.trim(),
        "notes": notesController.text.trim(),
      });

      print("CUSTOMER SAVED");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Customer Saved Successfully"),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      print("DATABASE ERROR : $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error : $e"),
        ),
      );
    }
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
        title: const Text("Add Customer"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: customerNameController,
              decoration:
              inputDecoration("Customer Name", Icons.person),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: businessNameController,
              decoration:
              inputDecoration("Hotel / Shop Name", Icons.store),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration:
              inputDecoration("Mobile Number", Icons.phone),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: addressController,
              maxLines: 3,
              decoration:
              inputDecoration("Address", Icons.location_on),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: notesController,
              maxLines: 2,
              decoration:
              inputDecoration("Notes (Optional)", Icons.note),
            ),
            const SizedBox(height: 25),

            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  saveCustomer();
                },
                icon: const Icon(Icons.save),
                label: const Text(
                  "SAVE CUSTOMER",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}