import 'package:barcode_scan/screen/create_order/create_order_controller.dart';
import 'package:barcode_scan/screen/create_order/model.dart';
import 'package:barcode_scan/screen/update_doc_order/update_doc_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/login.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key, required this.title});

  final String title;

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  String _barcodeResult = "";
  final TextEditingController _barcodeTextController = TextEditingController();
  final CreateOrderController _createOrderController = CreateOrderController();

  @override
  void initState() {
    super.initState();
    _barcodeTextController.addListener(() {
      _barcodeResult = _barcodeTextController.text;
    });
  }

  Future<void> _submit() async {
    if (_barcodeResult.isNotEmpty) {
      CheckBarcodeRes? res =
          await _createOrderController.isExit(barcode: _barcodeResult);
      if (res == null) {
        Fluttertoast.showToast(
            msg: "网络错误!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 18.0);
        return;
      }

      if (res.status == 401) {
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
        return;
      }

      if (res.data == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UpdateDocOrderPage(
                    title: "更新信息",
                    barcode: _barcodeResult,
                  )),
        );
      } else {
        Fluttertoast.showToast(
            msg: "条形码已经存在!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 18.0);
      }
    }
  }

  Future<void> _textChange(String text) async {
    setState(() {
      _barcodeResult = text;
    });
  }

  Future<void> _scanBarcode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "取消", false, ScanMode.BARCODE);
    if (barcodeScanRes != "-1") {
      setState(() {
        _barcodeTextController.text = "";
        _barcodeResult = barcodeScanRes;
      });
    }
  }

  Future<void> _logOut() async {
    var pres = await SharedPreferences.getInstance();
    await pres.remove('token');
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const LoginPage(title: "登录")),
        ModalRoute.withName("/Login"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              ElevatedButton(
                  onPressed: _logOut,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                  child: Text("登出")),
              const SizedBox(height: 20),
              const Text(
                '下面是条形码信息:',
              ),
              const SizedBox(height: 20),
              Text(
                '条码 : $_barcodeResult',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.red),
              ),
              const SizedBox(height: 60),
              TextField(
                onChanged: (text) {
                  _textChange(text);
                },
                controller: _barcodeTextController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '输入条形码',
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _scanBarcode,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  ),
                ),
                child: const Text('使用条码扫描器'),
              ),
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: _barcodeResult.isEmpty ? null : _submit,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  ),
                ),
                child: const Text(
                  '订单创建确认',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ));
  }
}
