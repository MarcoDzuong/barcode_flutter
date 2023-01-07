import 'package:image_picker/image_picker.dart';

class UpdateResponse {
  bool isSuccess;
  int statusCode;
  String message;

  UpdateResponse( { this.statusCode =0 ,required this.isSuccess, required this.message});
}

class UpdateRequest {

  String barcode;
  String note;
  String token;
  List<XFile>? images;

  UpdateRequest(
      {required this.barcode, required this.note, required this.token, required this.images});
}
