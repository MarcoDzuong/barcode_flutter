import 'package:barcode_scan/screen/pick_image/item_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImagePage extends StatefulWidget {
  const PickImagePage({super.key});

  @override
  State<StatefulWidget> createState() => _PickImagePageState();
}

class _PickImagePageState extends State<PickImagePage> {
  final ImagePicker _picker = ImagePicker();

  List<XFile> _images = List.empty();

  _pickImage() async {
    final List<XFile> newImages = await _picker.pickMultiImage();
    setState(() {
      _images = [..._images, ...newImages];
    });
  }

  _captureImage() async {
    var newImage = await _picker.pickImage(source: ImageSource.camera);
    if (newImage != null) {
      setState(() {
        _images = [..._images, newImage];
      });
    }
  }

  _delete(XFile image) {
    var newList = _images.where((item) {
      return item.path != image.path;
    }).toList();
    setState(() {
      _images = newList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: _images.isEmpty ? Center(
                child: Text("Empty, pick or capture image to add more"),
              ) : ListView.builder(
                itemCount: _images.length,
                itemBuilder: (context, position) {
                  return ItemImage(
                    path: _images[position].path,
                    onDeleteClick: () {
                      _delete(_images[position]);
                    },
                  );
                },
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: _pickImage,
                  child: const Text("Pick image"),
                ),
                TextButton(
                  onPressed: _captureImage,
                  child: const Text("Capture image"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
