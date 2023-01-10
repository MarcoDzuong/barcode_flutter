import 'dart:io';

import 'package:barcode_scan/screen/login/login.dart';
import 'package:barcode_scan/screen/update_doc_order/model.dart';
import 'package:barcode_scan/screen/update_doc_order/update_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateDocOrderPage extends StatefulWidget {
  const UpdateDocOrderPage(
      {super.key, required this.title, required this.barcode});

  final String title;
  final String barcode;

  @override
  State<StatefulWidget> createState() => _UpdateDocOrderPageState();
}

class _UpdateDocOrderPageState extends State<UpdateDocOrderPage> {
  String _imagePath = "";
  static String _barcode = "";

  @override
  void initState() {
    super.initState();
    _barcode = widget.barcode;
  }

  final ImagePicker _picker = ImagePicker();
  List<XFile>? _images;
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _countController = TextEditingController();
  UpdateProductController controller = UpdateProductController();

  Future<void> _onImageButtonPressed() async {
    final List<XFile> images = await _picker.pickMultiImage();
    setState(() {
      _images = images;
      _imagePath = images[0].path;
    });
  }

  Future<void> _onUpdateProduct() async {
    if (_images == null || _images!.isEmpty) {
      Fluttertoast.showToast(
          msg: "Hãy chọn ảnh!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0);
      return;
    }
    final UpdateRequest updateRequest = UpdateRequest(
        barcode: _barcode,
        note: _noteController.text,
        token: "13|iGMssmFaDY9xupqTHt0foVAFuU3XY0UpVJYM7fT0",
        images: _images,
        count: int.parse(_countController.text.toString()),
        weight: int.parse(_weightController.text.toString()),
        price: int.parse(_priceController.text.toString()));
    UpdateResponse? response = await controller.update(updateRequest);
    if (response.isSuccess) {
      Fluttertoast.showToast(
          msg: "Tạo thành công!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0);
      Navigator.pop(context);
    } else if (response.statusCode == 401) {
      var pres = await SharedPreferences.getInstance();
      await pres.remove('token');
      Fluttertoast.showToast(
          msg: "Token hết hạn. Hãy login lại!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0);
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginPage(title: "Barcode Scanner")),
          ModalRoute.withName("/Login"));
    } else {
      Fluttertoast.showToast(
          msg: "Barcode đã tồn tại!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Barcode : ${widget.barcode}"),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      TextButton(
                          onPressed: _onImageButtonPressed,
                          child: const Text(
                            "CHỌN ẢNH",
                            style: TextStyle(fontSize: 20),
                          )),
                      const SizedBox(
                        width: 80,
                      ),
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.file(
                            File(_imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _countController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Số kiện',
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _weightController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Số cân',
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _priceController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Giá cước',
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Ghi chú',
                    ),
                    minLines: 4,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: _onUpdateProduct,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    child: const Text(
                      'TẠO ĐƠN HÀNG',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
