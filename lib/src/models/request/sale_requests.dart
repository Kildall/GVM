import 'package:gvm_flutter/src/models/models_library.dart';

class CreateSaleRequest {
  final int customerId;
  final int employeeId;
  final List<SaleProductItem> products;
  final String startDate;

  CreateSaleRequest({
    required this.customerId,
    required this.employeeId,
    required this.products,
    required this.startDate,
  });

  Map<String, dynamic> toJson() => {
        'customerId': customerId,
        'employeeId': employeeId,
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
  final SaleStatusEnum status;
  final int employeeId;
  final int customerId;
  final String startDate;

  UpdateSaleRequest({
    required this.saleId,
    required this.products,
    required this.status,
    required this.employeeId,
    required this.customerId,
    required this.startDate,
  });

  Map<String, dynamic> toJson() => {
        'saleId': saleId,
        'products': products.map((item) => item.toJson()).toList(),
        'status': status.name,
        'employeeId': employeeId,
        'customerId': customerId,
        'startDate': startDate,
      };
}
