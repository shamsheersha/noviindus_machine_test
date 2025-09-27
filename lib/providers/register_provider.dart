import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:ayurved_care/services/api_services.dart';

class RegisterProvider with ChangeNotifier {
  bool _isRegistering = false;
  String _errorMessage = '';
  String _successMessage = '';

  bool get isRegistering => _isRegistering;
  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;

  Future<bool> registerPatient({
    required String token,
    required String name,
    required String excecutive,
    required String payment,
    required String phone,
    required String address,
    required double totalAmount,
    required double discountAmount,
    required double advanceAmount,
    required double balanceAmount,
    required String dateNdTime,
    required String branch,
    required List<String> maleTreatmentIds,
    required List<String> femaleTreatmentIds,
    required List<String> treatmentIds,
  }) async {
    try {
      _isRegistering = true;
      _errorMessage = '';
      _successMessage = '';
      notifyListeners();

      final result = await ApiServices.registerPatient(
        token: token,
        name: name,
        excecutive: excecutive,
        payment: payment,
        phone: phone,
        address: address,
        totalAmount: totalAmount,
        discountAmount: discountAmount,
        advanceAmount: advanceAmount,
        balanceAmount: balanceAmount,
        dateNdTime: dateNdTime,
        branch: branch,
        maleTreatmentIds: maleTreatmentIds,
        femaleTreatmentIds: femaleTreatmentIds,
        treatmentIds: treatmentIds,
      );
    log('Registration response: ${result['data']}'); // Log the response
    log('fffffffffFull registration response: $result'); // Log the full response

      if (result['success']) {
        _successMessage = result['message'];
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
      _isRegistering = false;
      notifyListeners();
    }
  }
}
