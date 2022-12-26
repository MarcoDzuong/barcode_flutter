import 'package:barcode_scan/screen/update_doc_order/update_doc_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key, required this.title});

  final String title;

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  String _barcodeResult = "";
  final TextEditingController _barcodeTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _barcodeTextController.addListener(() {
      _barcodeResult = _barcodeTextController.text;
    });
  }

  Future<void> _submit() async {
     if(_barcodeResult.isNotEmpty){
       Navigator.push(
           context,
           MaterialPageRoute(
               builder: (context) =>
               const UpdateDocOrderPage(title: "Update Info")),
          );
     }
  }

  Future<void> _textChange(String text) async {
    setState(() {
      _barcodeResult = text;
    });
  }

  Future<void> _scanBarcode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", false, ScanMode.BARCODE);
    if (barcodeScanRes != "-1") {
      setState(() {
        _barcodeTextController.text = "";
        _barcodeResult = barcodeScanRes;
      });
    }
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
            const Text(
              'Dưới đây là thông tin barcode:',
            ),
            const SizedBox(height: 20),
            Text(
              'Barcode la : $_barcodeResult',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red),
            ),
            const SizedBox(height: 60),
            TextField(
              onChanged: (text) {
                _textChange(text);
              },
              controller: _barcodeTextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a barcode',
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
              child: const Text('Dùng Barcode Scanner'),
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: _barcodeResult.isEmpty? null : _submit,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // <-- Radius
                ),
              ),
              child: const Text('Xác nhận tạo đơn', style: TextStyle(fontSize: 20),),
            ),
          ],
        ),
      )
    );
  }
}
