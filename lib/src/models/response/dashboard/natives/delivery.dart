import 'package:intl/intl.dart';

enum DeliveryStatus {
  PENDING_ASSIGNMENT,
  ASSIGNED,
  IN_PROGRESS,
  DELIVERED,
  CANCELED,
  DISPUTED
}

class Delivery {
  final int id;
  final int saleId;
  final String customerName;
  final String address;
  final DeliveryStatus status;
  final DateTime startDate;
  final String deliveryPerson;

  Delivery({
    required this.id,
    required this.saleId,
    required this.customerName,
    required this.address,
    required this.status,
    required this.startDate,
    required this.deliveryPerson,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['id'],
      saleId: json['saleId'],
      customerName: json['customer']['name'],
      address: json['address'],
      status: DeliveryStatus.values.firstWhere(
          (e) => e.toString() == 'DeliveryStatus.${json['status']}'),
      startDate: DateTime.parse(json['startDate']),
      deliveryPerson: json['deliveryPerson'],
    );
  }

  String get formattedDate => DateFormat('MMM d, y HH:mm').format(startDate);

  String get statusDisplay => status.toString().split('.').last;

  String get summary =>
      'Delivery #$id for Sale #$saleId: $customerName - $statusDisplay';

  bool get isActive =>
      status == DeliveryStatus.ASSIGNED || status == DeliveryStatus.IN_PROGRESS;
}
