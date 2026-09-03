class Bill {
  int? id;
  String customerName;
  String billDate;
  double totalAmount;

  Bill({
    this.id,
    required this.customerName,
    required this.billDate,
    required this.totalAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "customerName": customerName,
      "billDate": billDate,
      "totalAmount": totalAmount,
    };
  }

  factory Bill.fromMap(Map<String, dynamic> map) {
    return Bill(
      id: map["id"],
      customerName: map["customerName"],
      billDate: map["billDate"],
      totalAmount: map["totalAmount"],
    );
  }
}