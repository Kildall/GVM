class Purchase {
  final int id;
  final int employeeId;
  final int supplierId;
  final DateTime date;
  final double amount;
  final String description;

  Purchase({
    required this.id,
    required this.employeeId,
    required this.supplierId,
    required this.date,
    required this.amount,
    required this.description,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: json['id'],
      employeeId: json['employeeId'],
      supplierId: json['supplierId'],
      date: DateTime.parse(json['date']),
      amount: json['amount'],
      description: json['description'],
    );
  }
}
