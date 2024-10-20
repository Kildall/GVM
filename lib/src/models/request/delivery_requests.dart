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
  final int deliveryPersonId;
  final int addressId;
  final String status;

  UpdateDeliveryRequest({
    required this.deliveryId,
    required this.deliveryPersonId,
    required this.addressId,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'deliveryId': deliveryId,
        'deliveryPersonId': deliveryPersonId,
        'addressId': addressId,
        'status': status,
      };
}
