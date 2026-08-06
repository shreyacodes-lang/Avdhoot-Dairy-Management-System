class Customer {
  int? id;
  String customerName;
  String businessName;
  String phone;
  String address;
  String notes;

  Customer({
    this.id,
    required this.customerName,
    required this.businessName,
    required this.phone,
    required this.address,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'businessName': businessName,
      'phone': phone,
      'address': address,
      'notes': notes,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      customerName: map['customerName'],
      businessName: map['businessName'],
      phone: map['phone'],
      address: map['address'],
      notes: map['notes'],
    );
  }
}