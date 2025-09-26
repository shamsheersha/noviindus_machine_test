class PatientModel {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String dateAndTime;
  final String branch;
  final String executive;
  final String payment;
  final double totalAmount;
  final double discountAmount;
  final double advanceAmount;
  final double balanceAmount;
  final List<String> treatments;

  PatientModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.dateAndTime,
    required this.branch,
    required this.executive,
    required this.payment,
    required this.totalAmount,
    required this.discountAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    required this.treatments,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      dateAndTime: json['date_nd_time'] ?? '',
      branch: json['branch'] ?? '',
      executive: json['excecutive'] ?? '',
      payment: json['payment'] ?? '',
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      discountAmount: double.tryParse(json['discount_amount'].toString()) ?? 0.0,
      advanceAmount: double.tryParse(json['advance_amount'].toString()) ?? 0.0,
      balanceAmount: double.tryParse(json['balance_amount'].toString()) ?? 0.0,
      treatments: (json['treatments'] as String?)?.split(',') ?? [],
    );
  }
}
