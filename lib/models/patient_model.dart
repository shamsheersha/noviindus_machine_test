class PatientModel {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String dateAndTime;
  final String branch;
  final String excecutive;
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
    required this.excecutive,
    required this.payment,
    required this.totalAmount,
    required this.discountAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    required this.treatments,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    // Debug: Print all available keys
    print('Available keys in patient JSON: ${json.keys.toList()}');
    print('date_nd_time value: ${json['date_nd_time']}');
    print('created_at value: ${json['created_at']}');
    
    // Extract branch name from branch object
    String branchName = '';
    if (json['branch'] != null) {
      if (json['branch'] is Map) {
        branchName = json['branch']['name'] ?? '';
      } else if (json['branch'] is String) {
        branchName = json['branch'];
      }
    }

    // Extract treatment names from patientdetails_set
    List<String> treatmentNames = [];
    if (json['patientdetails_set'] != null && json['patientdetails_set'] is List) {
      treatmentNames = (json['patientdetails_set'] as List)
          .map((detail) => detail['treatment_name']?.toString() ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
    }

    return PatientModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      dateAndTime: json['date_nd_time']?.toString() ?? json['created_at']?.toString() ?? '',
      branch: branchName,
      excecutive: json['user'] ?? '', // API uses 'user' field
      payment: json['payment'] ?? '',
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      discountAmount: double.tryParse(json['discount_amount'].toString()) ?? 0.0,
      advanceAmount: double.tryParse(json['advance_amount'].toString()) ?? 0.0,
      balanceAmount: double.tryParse(json['balance_amount'].toString()) ?? 0.0,
      treatments: treatmentNames,
    );
  }
}
