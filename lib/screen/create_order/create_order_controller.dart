import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constant_app.dart';
import 'model.dart';

class CreateOrderController {
  Future<CheckBarcodeRes?> isExit({required String barcode}) async {
    var pres = await SharedPreferences.getInstance();
    String token =pres.getString("token")??"";
    var url = Uri.parse('${Constant.baseUrl}/api/products/checkqr/$barcode');
    try {
      var response = await http.get(url,headers: {
        "Authorization" : "Bearer $token"
      });
      final Map<String, dynamic> parsed = jsonDecode(response.body);
      CheckBarcodeRes res = CheckBarcodeRes(data:  parsed["data"], status: response.statusCode);
      return res;
    } catch (e) {
      return null;
    }
  }
}
