// import 'package:flutter/foundation.dart';
// import 'package:ayurved_care/models/patient_model.dart';
// import 'package:ayurved_care/services/api_services.dart';

// class PatientProvider with ChangeNotifier {
//   List<PatientModel> _patientList = [];
//   bool _isFetchingPatients = false;
//   String _errorMessage = '';

//   // Getters
//   List<PatientModel> get patientList => _patientList;
//   bool get isFetchingPatients => _isFetchingPatients;
//   String get errorMessage => _errorMessage;

//   Future<bool> fetchPatientList({required String token}) async {
//     try {
//       _isFetchingPatients = true;
//       _errorMessage = '';
//       notifyListeners();

//       final result = await ApiServices.fetchPatientList(token: token);
//       if (result['success']) {
//         // Fix: Check if data has a 'patient' key or is directly a list
//         final data = result['data'];
//         if (data is Map && data.containsKey('patient')) {
//           _patientList = (data['patient'] as List)
//               .map((item) => PatientModel.fromJson(item))
//               .toList();
//         } else if (data is List) {
//           _patientList = data
//               .map((item) => PatientModel.fromJson(item))
//               .toList();
//         } else {
//           _patientList = [];
//         }

//         _errorMessage = '';
//         notifyListeners();
//         return true;
//       } else {
//         _errorMessage = result['message'];
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       _errorMessage = 'An unexpected error occurred: $e';
//       notifyListeners();
//       return false;
//     } finally {
//       _isFetchingPatients = false;
//       notifyListeners();
//     }
//   }


  
// }
import 'package:ayurved_care/models/patient_model.dart';
import 'package:ayurved_care/services/api_services.dart';
import 'package:flutter/material.dart';

class PatientProvider with ChangeNotifier {
  List<PatientModel> _patientList = [];
  List<Map<String, dynamic>> _rawPatientData = []; // Add this line
  bool _isFetchingPatients = false;
  String _errorMessage = '';

  List<PatientModel> get patientList => _patientList;
  bool get isFetchingPatients => _isFetchingPatients;
  String get errorMessage => _errorMessage;

  // Add this method
  Map<String, dynamic> getRawPatientData(int index) {
    if (index < _rawPatientData.length) {
      return _rawPatientData[index];
    }
    return {};
  }

  Future<bool> fetchPatientList({required String token}) async {
    try {
      _isFetchingPatients = true;
      _errorMessage = '';
      notifyListeners();
      
      final result = await ApiServices.fetchPatientList(token: token);
      if (result['success']) {
        final data = result['data'];
        if (data is Map && data.containsKey('patient')) {
          final patientList = data['patient'] as List;
          _rawPatientData = List<Map<String, dynamic>>.from(patientList); // Store raw data
          _patientList = patientList.map((item) => PatientModel.fromJson(item)).toList();
        } else if (data is List) {
          _rawPatientData = List<Map<String, dynamic>>.from(data); // Store raw data
          _patientList = data.map((item) => PatientModel.fromJson(item)).toList();
        } else {
          _patientList = [];
          _rawPatientData = [];
        }
        
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