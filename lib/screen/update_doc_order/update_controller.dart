import 'dart:convert';
import 'dart:io';
import 'package:barcode_scan/cached/cached_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;
import '../constant_app.dart';
import 'model.dart';
import 'package:http/http.dart' as http;

class UpdateProductController {
  getFileSize(String filepath) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return 0.toDouble();
    return (bytes / 1024 / 1024).toDouble();
  }

  Future<UpdateResponse> update(UpdateRequest request) async {
    String token = await MyStorageImpl.getToken();
    var url = Uri.parse('${Constant.baseUrl}/api/products');
    try {
      var requestHttp = http.MultipartRequest("POST", url);
      requestHttp.headers["Accept"] = "application/json";
      requestHttp.headers["Authorization"] = "Bearer $token";
      requestHttp.fields["qr"] = request.barcode;
      requestHttp.fields["note"] = request.note;
      requestHttp.fields["price"] = request.price;
      requestHttp.fields["weight"] = request.weight;
      requestHttp.fields["count"] = request.count;
      request.images?.forEach((element) async {
        int sizeInBytes = File(element.path).lengthSync();
        double fileSize = sizeInBytes / (1024 * 1024);
        if (fileSize > 1) {
          var byte = File(element.path).readAsBytesSync();
          img.Image imageTemp = img.decodeImage(byte)!;
          img.Image resizedImg =
              img.copyResize(imageTemp, width: 1024, height: 1024);
          requestHttp.files.add(http.MultipartFile.fromBytes(
              'images[]', img.encodeJpg(resizedImg),
              filename: 'resized_image.jpg'));
        } else {
          requestHttp.files
              .add(await http.MultipartFile.fromPath('images[]', element.path));
        }
      });
      var response = await requestHttp.send();
      var responseMap = await http.Response.fromStream(response);
      final responseData = jsonDecode(responseMap.body);
      late UpdateResponse result;
      if (response.statusCode == 201) {
        result = UpdateResponse(isSuccess: true, message: "Thành công!");
      } else if (response.statusCode == 401) {
        result = UpdateResponse(
            isSuccess: false,
            message: responseData["message"].toString() +
                responseData["errors"].toString(),
            statusCode: 401);
      } else {
        result = UpdateResponse(
            isSuccess: false,
            message: responseData["message"].toString() +
                responseData["errors"].toString());
      }
      return result;
    } catch (e) {
      return UpdateResponse(isSuccess: false, message: e.toString());
    }
  }
}
