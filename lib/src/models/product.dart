class Product {
  final int id;
  final String name;
  final int quantity;
  final double measure;
  final String brand;
  final double price;
  final bool enabled;

  Product({
    required this.id,
    required this.name,
    this.quantity = 0,
    required this.measure,
    required this.brand,
    required this.price,
    this.enabled = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      measure: json['measure'],
      brand: json['brand'],
      price: json['price'],
      enabled: json['enabled'],
    );
  }
}
