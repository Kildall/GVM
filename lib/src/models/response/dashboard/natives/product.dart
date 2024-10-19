class Product {
  final String name;
  final int quantity;
  final double price;

  Product({required this.name, required this.quantity, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['product']['name'],
      quantity: json['quantity'],
      price: json['product']['price'].toDouble(),
    );
  }

  double get totalPrice => quantity * price;
}
