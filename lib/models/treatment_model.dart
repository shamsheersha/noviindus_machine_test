import 'package:ayurved_care/models/branch_model.dart';

class TreatmentModel {
  final int id;
  final String name;
  final String duration;
  final String price;
  final bool isActive;
  final List<BranchModel> branches;
  final String? email;
  final String? gst;
  final String? createdAt;
  final String? updatedAt;

  TreatmentModel({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    required this.isActive,
    required this.branches,
    this.email,
    this.gst,
    this.createdAt,
    this.updatedAt,
  });

  factory TreatmentModel.fromJson(Map<String, dynamic> json) {
    return TreatmentModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      duration: json['duration'] ?? '',
      price: json['price']?.toString() ?? '0',
      isActive: json['is_active'] ?? false,
      branches: (json['branches'] as List<dynamic>? ?? [])
          .map((b) => BranchModel.fromJson(b))
          .toList(),
      email: json['email'],
      gst: json['gst'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
