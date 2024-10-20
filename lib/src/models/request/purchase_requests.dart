class CreatePurchaseRequest {
  final int employeeId;
  final int supplierId;
  final String date;
  final double amount;
  final List<PurchaseProductItem> products;
  final String description;

  CreatePurchaseRequest({
    required this.employeeId,
    required this.supplierId,
    required this.date,
    required this.amount,
    required this.products,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'employeeId': employeeId,
        'supplierId': supplierId,
        'date': date,
        'amount': amount,
        'products': products.map((item) => item.toJson()).toList(),
        'description': description,
      };
}

class PurchaseProductItem {
  final int productId;
  final int quantity;

  PurchaseProductItem({required this.productId, required this.quantity});

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'quantity': quantity,
      };
}

class UpdatePurchaseRequest {
  final int purchaseId;
  final int employeeId;
  final int supplierId;
  final String date;
  final double amount;
  final List<PurchaseProductItem> products;
  final String description;

  UpdatePurchaseRequest({
    required this.purchaseId,
    required this.employeeId,
    required this.supplierId,
    required this.date,
    required this.amount,
    required this.products,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'purchaseId': purchaseId,
        'employeeId': employeeId,
        'supplierId': supplierId,
        'date': date,
        'amount': amount,
        'products': products.map((item) => item.toJson()).toList(),
        'description': description,
      };
}
