import 'package:image_picker/image_picker.dart';

class UpdateResponse {
  bool isSuccess;
  int statusCode;
  String message;

  UpdateResponse( { this.statusCode =0 ,required this.isSuccess, required this.message});
}

class UpdateRequest {

  String barcode;
  String token;
  List<XFile>? images;
  String note;
  String price;
  String count;
  String weight;

  UpdateRequest(
      {required this.barcode, required this.note,
        required this.token, required this.images,
        required this.price, required this.weight, required this.count
      });
}
