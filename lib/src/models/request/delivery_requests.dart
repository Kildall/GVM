import 'package:gvm_flutter/src/models/business_status_enum.dart';
import 'package:gvm_flutter/src/models/driver_status_enum.dart';

class CreateDeliveryRequest {
  final int saleId;
  final int deliveryPersonId;
  final int addressId;
  final String startDate;

  CreateDeliveryRequest({
    required this.saleId,
    required this.deliveryPersonId,
    required this.addressId,
    required this.startDate,
  });

  Map<String, dynamic> toJson() => {
        'saleId': saleId,
        'deliveryPersonId': deliveryPersonId,
        'addressId': addressId,
        'startDate': startDate,
      };
}

class UpdateDeliveryRequest {
  final int deliveryId;
  final int employeeId;
  final int addressId;
  final String status;
  final BusinessStatusEnum businessStatus;
  final DriverStatusEnum driverStatus;
  final DateTime startDate;

  UpdateDeliveryRequest({
    required this.deliveryId,
    required this.employeeId,
    required this.addressId,
    required this.status,
    required this.businessStatus,
    required this.driverStatus,
    required this.startDate,
  });

  Map<String, dynamic> toJson() => {
        'deliveryId': deliveryId,
        'employeeId': employeeId,
        'addressId': addressId,
        'status': status,
        'startDate': startDate.toIso8601String(),
        'businessStatus': businessStatus.name,
        'driverStatus': driverStatus.name,
      };
}
