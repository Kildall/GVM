class CreateSupplierRequest {
  final String name;

  CreateSupplierRequest({required this.name});

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}

class UpdateSupplierRequest {
  final int supplierId;
  final String name;

  UpdateSupplierRequest({required this.supplierId, required this.name});

  Map<String, dynamic> toJson() => {
        'supplierId': supplierId,
        'name': name,
      };
}
