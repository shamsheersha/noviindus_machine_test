import 'package:flutter/foundation.dart';
import 'package:ayurved_care/models/patient_model.dart';
import 'package:ayurved_care/services/api_services.dart';

class PatientProvider with ChangeNotifier {
  List<PatientModel> _patientList = [];
  bool _isFetchingPatients = false;
  String _errorMessage = '';

  // Getters
  List<PatientModel> get patientList => _patientList;
  bool get isFetchingPatients => _isFetchingPatients;
  String get errorMessage => _errorMessage;

  Future<bool> fetchPatientList({required String token}) async {
    try {
      _isFetchingPatients = true;
      _errorMessage = '';
      notifyListeners();
      final result = await ApiServices.fetchPatientList(token: token);
      if (result['success']) {
        _patientList = (result['data'] as List).map((item) => PatientModel.fromJson(item)).toList();
        _errorMessage = '';
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      notifyListeners();
      return false;
    } finally {
      _isFetchingPatients = false;
      notifyListeners();
    }
  }
}
