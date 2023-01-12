import 'dart:io';

import 'package:flutter/cupertino.dart';

class ItemImage extends StatefulWidget {
  const ItemImage({super.key, required this.path});

  final String path;

  @override
  State<StatefulWidget> createState() => _ItemImageState();
}

class _ItemImageState extends State<ItemImage> {
  String _path = "";

  @override
  void initState() {
    _path = widget.path;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Image.file(File(_path), fit: BoxFit.cover),
    );
  }
}
