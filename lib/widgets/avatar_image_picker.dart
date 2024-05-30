import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarImagePicker extends StatefulWidget {
  const AvatarImagePicker({
    super.key,
    required this.onPickImage,
  });

  final void Function(File pickedImage) onPickImage;

  @override
  State<StatefulWidget> createState() {
    return _AvatarImagePickerState();
  }
}

class _AvatarImagePickerState extends State<AvatarImagePicker> {
  File? _pickedImageFile;

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
      _pickedImageFile = File(pickedImage!.path);
    });

    widget.onPickImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAvatar(
          radius: 40,
          foregroundImage: _pickedImageFile != null
              ? FileImage(_pickedImageFile!)
              : const AssetImage("assets/avatar.png"),
        ),
        Column(
          children: [
            TextButton.icon(
              onPressed: () {
                _takePicture("camera");
              },
              icon: const Icon(Icons.camera),
              label: Text(
                "Take picture",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                _takePicture("gallery");
              },
              icon: const Icon(Icons.image),
              label: Text(
                "Choose picture",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                // TODO
              },
              icon: const Icon(Icons.color_lens),
              label: Text(
                "Choose avatar",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
