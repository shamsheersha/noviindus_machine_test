import 'package:flutter/foundation.dart';
import 'package:ayurved_care/models/branch_model.dart';
import 'package:ayurved_care/services/api_services.dart';

class BranchProvider with ChangeNotifier {
  List<BranchModel> _branchList = [];
  bool _isFetchingBranches = false;
  String _errorMessage = '';

  // Getters
  List<BranchModel> get branchList => _branchList;
  bool get isFetchingBranches => _isFetchingBranches;
  String get errorMessage => _errorMessage;

  Future<bool> fetchBranchList({required String token}) async {
    try {
      _isFetchingBranches = true;
      _errorMessage = '';
      notifyListeners();

      _branchList = await ApiServices.fetchBranchList(token: token);

      _errorMessage = '';
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      notifyListeners();
      return false;
    } finally {
      _isFetchingBranches = false;
      notifyListeners();
    }
  }
}
