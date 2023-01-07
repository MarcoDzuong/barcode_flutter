import 'package:shared_preferences/shared_preferences.dart';

import '../constant_app.dart';
import 'model.dart';
import 'package:http/http.dart' as http;

class UpdateProductController {
  Future<UpdateResponse> update(UpdateRequest request) async {
    var pres = await SharedPreferences.getInstance();
    String token =pres.getString("token")??"";
    var url = Uri.parse('${Constant.baseUrl}/api/products');
    try {
      var requestHttp = http.MultipartRequest("POST", url);
      requestHttp.headers["Accept"] = "application/json";
      requestHttp.headers["Authorization"] = "Bearer $token";
      requestHttp.fields["qr"] = request.barcode;
      requestHttp.fields["note"] = request.note;
      request.images?.forEach((element) async {
        requestHttp.files
            .add(await http.MultipartFile.fromPath('images[]', element.path));
      });

      var response = await requestHttp.send();

      late UpdateResponse result;
      if  (response.statusCode==201){
        result = UpdateResponse(isSuccess: true, message: "Thành công!");
      } else if(response.statusCode ==401){
        result =UpdateResponse(
            isSuccess: false, message: "Authen", statusCode: 401);
      }
      else{
        result =UpdateResponse(
                    isSuccess: false, message: "QR code đã tồn tại!");
      }
      return result;
    } catch (e) {
      return UpdateResponse(
          isSuccess: false, message: "Exeption");
    }
  }
}
