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

  _exit(){
    Navigator.pop(context);
  }

  _done(){
    Navigator.pop(context,_images);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("选择图片"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _exit,
                  child: const Text("出口"),
                ),
                const SizedBox(width: 150),
                ElevatedButton(
                  onPressed: _done,
                  child: const Text("完毕"),
                ),
              ],
            ),
            Expanded(
              child: _images.isEmpty
                  ? const Center(
                      child: Text("选择或拍照以添加更多"),
                    )
                  : ListView.builder(
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
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text("选择图片"),
                ),
                const SizedBox(width: 100),
                ElevatedButton(
                  onPressed: _captureImage,
                  child: const Text("捕获图像"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
