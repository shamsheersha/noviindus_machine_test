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
      
      // Debug logging
      log('Fetching patient list with token: ${token.substring(0, 10)}...');
      log('Request URL: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'Patient list fetched successfully',
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Unauthorized: Token may be expired or invalid',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch patient list: ${response.reasonPhrase}',
        };
      }
    } catch (e) {
      log('Error fetching patient list: $e');
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
      final url = Uri.parse('${baseUrl}PatientUpdate');
      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['name'] = name;
      request.fields['excecutive'] = excecutive;
      request.fields['payment'] = payment;
      request.fields['phone'] = phone;
      request.fields['address'] = address;
      request.fields['total_amount'] = totalAmount.round().toString();
      request.fields['discount_amount'] = discountAmount.round().toString();
      request.fields['advance_amount'] = advanceAmount.round().toString();
      request.fields['balance_amount'] = balanceAmount.round().toString();
      request.fields['date_nd_time'] = dateNdTime;
      request.fields['id'] = '';
      request.fields['male'] = maleTreatmentIds.join(',');
      request.fields['female'] = femaleTreatmentIds.join(',');
      request.fields['branch'] = branch;
      request.fields['treatments'] = treatmentIds.join(',');

      log('Patient Registration Data: ${request.fields}');

      final streamedResponse = await request.send();
      
      final response = await http.Response.fromStream(streamedResponse);
      log(response.body);
      if (response.statusCode == 200) {
        log('Patient Registration Response: ${response.body}');
        final data = json.decode(response.body);

        log('Response data keys: ${data.keys}');
        log('Response status/success: ${data['status']} / ${data['success']}');

        // Check if registration was actually successful
        if(data['status'] == true || data['success'] == true){
          return {
            'success': true,
            'data': data,
            'message': 'Patient registered successfully',
          };
        } else {
          return {
            'success': false,
            'message': 'Registration failed: ${data['message'] ?? 'Unknown error'}',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Failed to register patient: ${response.body}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> fetchPatientDetails({
  required String token,
  required String patientId,
}) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/patient/$patientId/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return {
        'success': true,
        'data': data,
        'message': 'Patient details fetched successfully',
      };
    } else {
      return {
        'success': false,
        'data': null,
        'message': 'Failed to fetch patient details',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'data': null,
      'message': 'Network error: $e',
    };
  }
}
}
