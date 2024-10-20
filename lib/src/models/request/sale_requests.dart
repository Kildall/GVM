class CreateSaleRequest {
  final int customerId;
  final List<SaleProductItem> products;
  final String startDate;

  CreateSaleRequest({
    required this.customerId,
    required this.products,
    required this.startDate,
  });

  Map<String, dynamic> toJson() => {
        'customerId': customerId,
        'products': products.map((item) => item.toJson()).toList(),
        'startDate': startDate,
      };
}

class SaleProductItem {
  final int productId;
  final int quantity;

  SaleProductItem({required this.productId, required this.quantity});

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'quantity': quantity,
      };
}

class UpdateSaleRequest {
  final int saleId;
  final List<SaleProductItem> products;
  final String status;

  UpdateSaleRequest({
    required this.saleId,
    required this.products,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'saleId': saleId,
        'products': products.map((item) => item.toJson()).toList(),
        'status': status,
      };
}
