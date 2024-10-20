class CreateProductRequest {
  final String brand;
  final int measure;
  final String name;
  final double price;
  final int quantity;

  CreateProductRequest({
    required this.brand,
    required this.measure,
    required this.name,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        'brand': brand,
        'measure': measure,
        'name': name,
        'price': price,
        'quantity': quantity,
      };
}

class UpdateProductRequest {
  final int productId;
  final String brand;
  final int measure;
  final String name;
  final double price;
  final int quantity;

  UpdateProductRequest({
    required this.productId,
    required this.brand,
    required this.measure,
    required this.name,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'brand': brand,
        'measure': measure,
        'name': name,
        'price': price,
        'quantity': quantity,
      };
}
