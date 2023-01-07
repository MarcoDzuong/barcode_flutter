import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constant_app.dart';
import 'model.dart';

class LoginController {

  Future<LoginResponse?> login({required String email , required String passWord}) async {
    var url = Uri.parse(
        '${Constant.baseUrl}/api/login?email=$email&password=$passWord');
    try {
      var response = await http.post(url);
      final Map<String, dynamic> parsed = jsonDecode(response.body);
      LoginResponse loginResponse = LoginResponse.fromJson(parsed);
      return loginResponse;
    } catch (e) {
      return null;
    }
  }
}
