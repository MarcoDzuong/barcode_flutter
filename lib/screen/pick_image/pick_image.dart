import 'package:barcode_scan/screen/pick_image/item_image.dart';
import 'package:flutter/material.dart';

class PickImagePage extends StatefulWidget {
  const PickImagePage({super.key});

  @override
  State<StatefulWidget> createState() => _PickImagePageState();
}

class _PickImagePageState extends State<PickImagePage> {

  final List<String> _imageList =  List.empty();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _imageList.length,
        itemBuilder: (context, position) {
          return  ItemImage(path: _imageList[position]);
        },
      ),
    );
  }

}
