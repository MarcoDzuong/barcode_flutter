import 'dart:io';

import 'package:flutter/material.dart';

class ItemImage extends StatefulWidget {
  const ItemImage({
    super.key,
    required this.path,
    required this.onDeleteClick,
  });

  final String path;

  final Function onDeleteClick;

  @override
  State<StatefulWidget> createState() => _ItemImageState();
}

class _ItemImageState extends State<ItemImage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Row(
        children: [
          Container(
            color: Colors.brown,
            margin: const EdgeInsets.all(16),
            child: SizedBox(
              width: 100,
              height: 100,
              child: Image.file(File(widget.path), fit: BoxFit.cover),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              widget.onDeleteClick();
            },
          )
        ],
      ),
    );
  }
}
