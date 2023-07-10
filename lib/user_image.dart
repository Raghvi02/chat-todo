import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class UserImage extends StatefulWidget {
  UserImage(this.onPickImage,{super.key});
  void Function(File PickedImage) onPickImage;

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  File? imageFile;

  Future<void> captureImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
      widget.onPickImage(imageFile!);
    }
  }





  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
        ),
        TextButton.icon(
          onPressed: captureImage,
          icon: const Icon(Icons.camera_alt),
          label: const Text('Capture Image'),
        ),

      ],
    );
  }
}

