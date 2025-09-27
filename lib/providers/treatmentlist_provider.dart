import 'package:flutter/foundation.dart';
import 'package:ayurved_care/models/treatment_model.dart';
import 'package:ayurved_care/services/api_services.dart';

class TreatmentProvider with ChangeNotifier {
  List<TreatmentModel> _treatmentList = [];
  bool _isFetchingTreatments = false;
  String _errorMessage = '';

  // Getters
  List<TreatmentModel> get treatmentList => _treatmentList;
  bool get isFetchingTreatments => _isFetchingTreatments;
  String get errorMessage => _errorMessage;

  Future<bool> fetchTreatmentList({required String token}) async {
    try {
      _isFetchingTreatments = true;
      _errorMessage = '';
      notifyListeners();

      _treatmentList = await ApiServices.fetchTreatmentList(token: token);

      _errorMessage = '';
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      notifyListeners();
      return false;
    } finally {
      _isFetchingTreatments = false;
      notifyListeners();
    }
  }
}
