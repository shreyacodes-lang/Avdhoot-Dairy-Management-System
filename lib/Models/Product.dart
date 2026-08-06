class Product {
  int? id;
  String productName;
  String category;
  String unit;
  double purchasePrice;
  double sellingPrice;
  int stock;
  String notes;

  Product({
    this.id,
    required this.productName,
    required this.category,
    required this.unit,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.stock,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'category': category,
      'unit': unit,
      'purchasePrice': purchasePrice,
      'sellingPrice': sellingPrice,
      'stock': stock,
      'notes': notes,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      productName: map['productName'],
      category: map['category'],
      unit: map['unit'],
      purchasePrice: map['purchasePrice'].toDouble(),
      sellingPrice: map['sellingPrice'].toDouble(),
      stock: map['stock'],
      notes: map['notes'],
    );
  }
}