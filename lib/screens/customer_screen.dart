import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'add_customer_screen.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<Map<String, dynamic>> customers = [];
  List<Map<String, dynamic>> filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    final data = await DatabaseHelper.instance.getCustomers();

    setState(() {
      customers = data;
      filteredCustomers = data;
    });
  }

  void searchCustomer(String value) {
    setState(() {
      filteredCustomers = customers.where((customer) {
        final name =
        customer["customerName"].toString().toLowerCase();
        final business =
        customer["businessName"].toString().toLowerCase();

        return name.contains(value.toLowerCase()) ||
            business.contains(value.toLowerCase());
      }).toList();
    });
  }

  Future<void> deleteCustomer(int id) async {
    await DatabaseHelper.instance.deleteCustomer(id);
    loadCustomers();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Customer Deleted"),
      ),
    );
  }

  Future<void> openAddCustomer() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddCustomerScreen(),
      ),
    );

    if (result == true) {
      loadCustomers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customers"),
        backgroundColor: Colors.blue,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: openAddCustomer,
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: searchCustomer,
              decoration: InputDecoration(
                hintText: "Search Customer...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Expanded(
            child: filteredCustomers.isEmpty
                ? const Center(
              child: Text(
                "No Customers Found",
              ),
            )
                : ListView.builder(
              itemCount:
              filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer =
                filteredCustomers[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(
                      customer["customerName"],
                    ),
                    subtitle: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer["businessName"],
                        ),
                        Text(
                          customer["phone"],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        deleteCustomer(
                          customer["id"],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}