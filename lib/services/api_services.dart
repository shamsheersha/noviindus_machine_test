import 'dart:convert';
import 'dart:developer';
import 'package:ayurved_care/models/branch_model.dart';
import 'package:ayurved_care/models/treatment_model.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static const String baseUrl = "https://flutter-amr.noviindus.in/api/";

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final url = Uri.parse('${baseUrl}Login');

      final request = http.MultipartRequest('POST', url);
      request.fields['username'] = username;
      request.fields['password'] = password;

      log(request.fields.toString());
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        log(response.body);
        final data = json.decode(response.body);
        return {'success': true, 'data': data, 'message': 'Login successful'};
      } else {
        return {
          'success': false,
          'message': 'Login failed: ${response.reasonPhrase}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> fetchPatientList({
    required String token,
  }) async {
    try {
      final url = Uri.parse('${baseUrl}PatientList');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'Patient list fetched successfully',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch patient list: ${response.reasonPhrase}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  static Future<List<BranchModel>> fetchBranchList({
    required String token,
  }) async {
    try {
      final url = Uri.parse('${baseUrl}BranchList');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          final List branches = data['branches'];
          return branches.map((b) => BranchModel.fromJson(b)).toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch branch list');
        }
      } else {
        throw Exception(
          'Failed to fetch branch list: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      log('BranchList Error: $e');
      rethrow;
    }
  }

  static Future<List<TreatmentModel>> fetchTreatmentList({
    required String token,
  }) async {
    try {
      final url = Uri.parse('${baseUrl}TreatmentList');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          final List treatments = data['treatments'];
          return treatments.map((t) => TreatmentModel.fromJson(t)).toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch treatment list');
        }
      } else {
        throw Exception(
          'Failed to fetch treatment list: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      log('TreatmentList Error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> registerPatient({
    required String token,
    required String name,
    required String executive,
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
      final url = Uri.parse('${baseUrl}PatientUpdate');
      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['name'] = name;
      request.fields['executive'] = executive;
      request.fields['payment'] = payment;
      request.fields['phone'] = phone;
      request.fields['address'] = address;
      request.fields['total_amount'] = totalAmount.toString();
      request.fields['discount_amount'] = discountAmount.toString();
      request.fields['advance_amount'] = advanceAmount.toString();
      request.fields['balance_amount'] = balanceAmount.toString();
      request.fields['date_nd_time'] = dateNdTime;
      request.fields['id'] = ''; 
      request.fields['male'] = maleTreatmentIds.join(',');
      request.fields['female'] = femaleTreatmentIds.join(',');
      request.fields['branch'] = branch;
      request.fields['treatments'] = treatmentIds.join(',');

      log('Patient Registration Data: ${request.fields}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        log('Patient Registration Response: ${response.body}');
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'Patient registered successfully',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to register patient: ${response.reasonPhrase}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }
}
