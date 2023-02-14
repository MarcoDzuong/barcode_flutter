import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../cached/cached_manager.dart';
import '../constant_app.dart';
import 'model.dart';

class CreateOrderController {
  Future<CheckBarcodeRes?> isExit({required String barcode}) async {
    String token =await MyStorageImpl.getToken();
    var url = Uri.parse('${Constant.baseUrl}/api/products/checkqr/$barcode');
    try {
      var response = await http.get(url,headers: {
        "Authorization" : "Bearer $token"
      });
      final Map<String, dynamic> parsed = jsonDecode(response.body);
      CheckBarcodeRes res = CheckBarcodeRes(data:  parsed["data"], status: response.statusCode, message: parsed["message"]);
      return res;
    } catch (e) {
      CheckBarcodeRes res = CheckBarcodeRes(data:  false, status: 400, message: e.toString());
      return res;
    }
  }
}
