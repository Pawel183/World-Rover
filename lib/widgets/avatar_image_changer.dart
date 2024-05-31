import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarImageChanger extends StatefulWidget {
  const AvatarImageChanger({
    super.key,
    required this.userAvatarUrl,
    required this.setUserAvatar,
  });

  final String userAvatarUrl;
  final void Function() setUserAvatar;

  @override
  State<AvatarImageChanger> createState() => _AvatarImageChangerState();
}

class _AvatarImageChangerState extends State<AvatarImageChanger> {
  File? pickedImageFile;

  void takePicture(String option) async {
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
      pickedImageFile = File(pickedImage!.path);
    });
  }

  void applyChanges() async {
    if (pickedImageFile == null) return;

    final userUid = FirebaseAuth.instance.currentUser!.uid;
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("users_images")
        .child("avatars")
        .child("avatar_$userUid.jpg");

    await storageRef.putFile(pickedImageFile!);

    final imageUrl = await storageRef.getDownloadURL();

    await FirebaseFirestore.instance.collection('users').doc(userUid).update({
      'image_url': imageUrl,
    });

    widget.setUserAvatar();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var currentImage = NetworkImage(widget.userAvatarUrl);

    return Container(
      height: 400,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      width: double.infinity,
      child: Column(
        children: [
          CircleAvatar(
            foregroundImage: pickedImageFile == null
                ? currentImage
                : FileImage(pickedImageFile!),
            radius: 64,
          ),
          TextButton.icon(
            onPressed: () {
              takePicture("camera");
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
              takePicture("gallery");
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
          ElevatedButton(
            onPressed: applyChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: const Text("Apply changes"),
          ),
        ],
      ),
    );
  }
}
