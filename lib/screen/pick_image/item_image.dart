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

  Widget createErrorImage(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return Text("data");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Image.file(
              File(
                _path,
              ),
              fit: BoxFit.cover,
              errorBuilder: createErrorImage),
        ),
      ],
    );
  }
}
