import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class UpdateDocOrderPage extends StatefulWidget {

  const UpdateDocOrderPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _UpdateDocOrderPageState();

}

class _UpdateDocOrderPageState extends State<UpdateDocOrderPage> {

  String _imagePath = "";

  final ImagePicker _picker = ImagePicker();

  Future<void> _onImageButtonPressed() async {
    final List<XFile> images = await _picker.pickMultiImage();
    Fluttertoast.showToast(
        msg: images.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 18.0
    );
    setState(() {
      _imagePath = images[0].path;
    });
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
                Row(
                  children: [
                    TextButton(
                        onPressed: _onImageButtonPressed,
                        child: const Text("CHỌN ẢNH" , style: TextStyle(fontSize: 20),)
                    ),
                    const SizedBox(width: 80,),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child:AspectRatio(
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
                  onChanged: (text) {
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Số kiện',
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  onChanged: (text) {
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Số cân',
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  onChanged: (text) {
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Giá cước',
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  onChanged: (text) {
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Ghi chú',
                  ),
                  minLines: 4,
                  maxLines: 5,
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                  child: const Text('TẠO ĐƠN HÀNG', style: TextStyle(fontSize: 20),),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

}