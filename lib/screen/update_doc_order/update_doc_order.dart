import 'dart:io';

import 'package:barcode_scan/screen/login/login.dart';
import 'package:barcode_scan/screen/pick_image/pick_image.dart';
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
  bool isLoading = false;
  List<XFile>? _images;
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _countController = TextEditingController(text: "1");



  UpdateProductController controller = UpdateProductController();
  int _countImage = 0;
  Future<void> _onImageButtonPressed() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PickImagePage()),
    );
    if(result!=null){
      setState(() {
        _images = result;
        _imagePath = result[0].path;
        _countImage = result.length;
      });
    }
  }

  Future<void> _onUpdateProduct() async {
    if (_images == null || _images!.isEmpty ) {
      Fluttertoast.showToast(
          msg: "请选择一张照片!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0);
      return;
    }

    if (_countController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "要求输入包裹号!",
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
        count: (_countController.text.toString()),
        weight: (_weightController.text.toString()),
        price: (_priceController.text.toString()));

    setState(() {
      isLoading = true;
    });
    UpdateResponse? response = await controller.update(updateRequest);
    setState(() {
      isLoading = false;
    });

    if (response.isSuccess) {
      Fluttertoast.showToast(
          msg: "创造成功!",
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
          msg: "请重新登录!",
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
              builder: (context) => const LoginPage(title: "登录")),
          ModalRoute.withName("/Login"));
    } else {
      Fluttertoast.showToast(
          msg: "条形码已经存在!",
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
        body: isLoading ?  const Center( child:  CircularProgressIndicator(),) : SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("条码 : ${widget.barcode}"),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      TextButton(
                          onPressed: _onImageButtonPressed,
                          child: const Text(
                            "选择照片",
                            style: TextStyle(fontSize: 20),
                          )),
                      const SizedBox(
                        width: 80,
                      ),
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Image.file(
                                File(_imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                                "$_countImage",
                            style: const TextStyle(color: Colors.red,fontSize: 20),
                            )
                          ],
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
                      hintText: '包裹数量',
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _weightController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '重量',
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _priceController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '价格',
                    ),

                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '笔记',
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
                      '创建订单',
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
