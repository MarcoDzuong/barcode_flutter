import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constant_app.dart';

class CreateOrderController {
  Future<bool> isExit({required String barcode}) async {
    var pres = await SharedPreferences.getInstance();
    String token =pres.getString("token")??"";
    var url = Uri.parse('${Constant.baseUrl}/api/products/checkqr/$barcode');
    try {
      var response = await http.get(url,headers: {
        "Authorization" : "Bearer $token"
      });
      final Map<String, dynamic> parsed = jsonDecode(response.body);
      bool data = parsed["data"];
      return data;
    } catch (e) {
      return false;
    }
  }
}
