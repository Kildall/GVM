import 'package:gvm_flutter/src/models/customer.dart';
import 'package:gvm_flutter/src/models/delivery.dart';
import 'package:gvm_flutter/src/models/exceptions/model_parse_exception.dart';
import 'package:gvm_flutter/src/models/model_base.dart';
import 'package:gvm_flutter/src/models/product.dart';
import 'package:gvm_flutter/src/models/sale.dart';

class ProductStats {
  final Product? product;
  final int? totalQuantitySold;
  final double? totalRevenue;

  ProductStats({
    this.product,
    required this.totalQuantitySold,
    required this.totalRevenue,
  });

  factory ProductStats.fromJson(Map<String, dynamic> json) {
    return ProductStats(
      product:
          json['product'] != null ? Product.fromJson(json['product']) : null,
      totalQuantitySold: json['totalQuantitySold'],
      totalRevenue: json['totalRevenue']?.toDouble(),
    );
  }
}

class CustomerStats {
  final Customer? customer;
  final int? totalOrders;
  final double? totalSpent;

  CustomerStats({
    required this.customer,
    required this.totalOrders,
    required this.totalSpent,
  });

  factory CustomerStats.fromJson(Map<String, dynamic> json) {
    return CustomerStats(
      customer: Customer.fromJson(json['customer']),
      totalOrders: json['totalOrders'],
      totalSpent: json['totalSpent'].toDouble(),
    );
  }
}

class DashboardStats {
  final double? totalSalesAmount;
  final int? totalActiveSales;
  final int? totalActiveDeliveries;
  final int? totalProducts;
  final int? totalCustomers;
  final int? lowStockProducts;
  final List<ProductStats>? topSellingProducts;
  final List<CustomerStats>? mostActiveCustomers;

  DashboardStats({
    required this.totalSalesAmount,
    required this.totalActiveSales,
    required this.totalActiveDeliveries,
    required this.totalProducts,
    required this.totalCustomers,
    required this.lowStockProducts,
    required this.topSellingProducts,
    required this.mostActiveCustomers,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalSalesAmount: json['totalSalesAmount']?.toDouble(),
      totalActiveSales: json['totalActiveSales'],
      totalActiveDeliveries: json['totalActiveDeliveries'],
      totalProducts: json['totalProducts'],
      totalCustomers: json['totalCustomers'],
      lowStockProducts: json['lowStockProducts'],
      topSellingProducts: (json['topSellingProducts'] as List?)
          ?.map((p) => ProductStats.fromJson(p))
          .toList(),
      mostActiveCustomers: (json['mostActiveCustomers'] as List?)
          ?.map((c) => CustomerStats.fromJson(c))
          .toList(),
    );
  }
}

class DashboardResponse {
  final DashboardStats stats;
  final List<Sale> sales;
  final List<Delivery> deliveries;
  final List<Product> products;
  final List<Customer> customers;

  DashboardResponse({
    required this.stats,
    required this.sales,
    required this.deliveries,
    required this.products,
    required this.customers,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    try {
      return DashboardResponse(
        stats: DashboardStats.fromJson(json['stats']),
        sales: createModels<Sale>(json['sales'], Sale.fromJson),
        deliveries:
            createModels<Delivery>(json['deliveries'], Delivery.fromJson),
        products: createModels<Product>(json['products'], Product.fromJson),
        customers: createModels<Customer>(json['customers'], Customer.fromJson),
      );
    } catch (e) {
      throw ModelParseException('DashboardResponse', e.toString(), json, e);
    }
  }
}
