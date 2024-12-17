import 'package:gvm_flutter/src/models/models_library.dart';

class SaleDeliveryItem {
  final int employeeId;
  final int addressId;
  final String startDate;

  SaleDeliveryItem({
    required this.employeeId,
    required this.addressId,
    required this.startDate,
  });

  Map<String, dynamic> toJson() => {
        'employeeId': employeeId,
        'addressId': addressId,
        'startDate': startDate,
      };
}

class CreateSaleRequest {
  final int customerId;
  final int employeeId;
  final List<SaleProductItem> products;
  final String startDate;
  final List<SaleDeliveryItem> deliveries;

  CreateSaleRequest({
    required this.customerId,
    required this.employeeId,
    required this.products,
    required this.startDate,
    required this.deliveries,
  });

  Map<String, dynamic> toJson() => {
        'customerId': customerId,
        'employeeId': employeeId,
        'products': products.map((item) => item.toJson()).toList(),
        'startDate': startDate,
        'deliveries': deliveries.map((item) => item.toJson()).toList(),
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
