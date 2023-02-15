import 'package:barcode_scan/cached/cached_manager.dart';
import 'package:barcode_scan/screen/create_order/create_order_controller.dart';
import 'package:barcode_scan/screen/create_order/model.dart';
import 'package:barcode_scan/screen/update_doc_order/update_doc_order.dart';
import 'package:barcode_scan/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _barcodeTextController.addListener(() {
      _barcodeResult = _barcodeTextController.text;
    });
  }

  _submit() async {
    if (_barcodeResult.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      CheckBarcodeRes? res =
          await _createOrderController.isExit(barcode: _barcodeResult);
      setState(() {
        isLoading = false;
      });
      if (res == null || res.status == 400) {
        ToastUtil.showError("网络错误!");
        return;
      }

      if (res.status == 401) {
        MyStorageImpl.removeToken();
        ToastUtil.showError("请重新登录!");
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const LoginPage(title: "登录")),
            ModalRoute.withName("/Login"));
        return;
      }

      if (res.status == 200 && res.data == true) {
        ToastUtil.showSuccess("更新信息");
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UpdateDocOrderPage(
                    title: "更新信息",
                    barcode: _barcodeResult,
                  )),
        );
      } else {
        ToastUtil.showError("条形码已经存在!");
      }
    }
  }

  _textChange(String text) async {
    setState(() {
      _barcodeResult = text;
    });
  }

  _scanBarcode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "取消", false, ScanMode.BARCODE);
    if (barcodeScanRes != "-1") {
      setState(() {
        _barcodeTextController.text = "";
        _barcodeResult = barcodeScanRes;
      });
    }
  }

  _logOut() async {
    MyStorageImpl.removeToken();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage(title: "登录")),
        ModalRoute.withName("/Login"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        resizeToAvoidBottomInset: false,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: _logOut,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                        child: const Text("退出登录")),
                    const SizedBox(height: 20),
                    const Text(
                      '条码信息',
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '运单号码 : $_barcodeResult',
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
                      child: const Text('扫描件'),
                    ),
                    const SizedBox(height: 100),
                    ElevatedButton(
                      onPressed:
                          _barcodeResult.isEmpty ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      ),
                      child: const Text(
                        '确认创建',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
