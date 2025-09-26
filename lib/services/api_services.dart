import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiServices {
  static const String baseUrl = "https://flutter-amr.noviindus.in/api/";

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  })async{
    try {
      final url = Uri.parse('${baseUrl}Login');

      final request = http.MultipartRequest('POST', url);
      request.fields['username'] = username;
      request.fields['password'] = password;

      log(request.fields.toString());
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if(response.statusCode == 200){
        log(response.body);
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'Login successful',
        };
      }else {
        return {
          'success': false,
          'message': 'Login failed: ${response.reasonPhrase}',
        };
      }
    }catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }
}