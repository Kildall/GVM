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
  final int? employeeId;
  final int? addressId;
  final String? status;
  final BusinessStatusEnum? businessStatus;
  final DriverStatusEnum? driverStatus;
  final DateTime? startDate;

  UpdateDeliveryRequest({
    required this.deliveryId,
    this.employeeId,
    this.addressId,
    this.status,
    this.businessStatus,
    this.driverStatus,
    this.startDate,
  });

  Map<String, dynamic> toJson() => {
        'deliveryId': deliveryId,
        if (employeeId != null) 'employeeId': employeeId,
        if (addressId != null) 'addressId': addressId,
        if (status != null) 'status': status,
        if (startDate != null) 'startDate': startDate!.toIso8601String(),
        if (businessStatus != null) 'businessStatus': businessStatus!.name,
        if (driverStatus != null) 'driverStatus': driverStatus!.name,
      };
}
