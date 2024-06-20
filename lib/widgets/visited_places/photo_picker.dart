import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPicker extends StatefulWidget {
  const PhotoPicker({
    super.key,
    required this.image,
    required this.onPickImage,
  });

  final File? image;
  final void Function(File pickedImage) onPickImage;

  @override
  State<PhotoPicker> createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {
  void _takePicture(String option) async {
    XFile? pickedImage;

    if (option == 'camera') {
      pickedImage = await ImagePicker().pickImage(
          source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    } else if (option == 'gallery') {
      pickedImage = await ImagePicker().pickImage(
          source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);
    }

    if (pickedImage == null) {
      return;
    }

    setState(() {
      widget.onPickImage(File(pickedImage!.path));
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget imageContainerContent = const Center(
      child: Text('No image picked yet'),
    );

    if (widget.image != null) {
      imageContainerContent = Image.file(
        widget.image!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
              width: 1,
            ),
          ),
          child: imageContainerContent,
        ),
        Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                _takePicture('gallery');
              },
              icon: const Icon(Icons.image),
              label: const Text('Pick an image'),
              style: ElevatedButton.styleFrom(
                maximumSize: const Size(150, 150),
                alignment: Alignment.center,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                _takePicture('camera');
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take a photo'),
              style: ElevatedButton.styleFrom(
                maximumSize: const Size(150, 150),
                alignment: Alignment.center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
