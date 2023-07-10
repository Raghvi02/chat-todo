


import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/chat_user.dart';


class Profile extends StatefulWidget {
 Profile(this.user,{super.key});
final UserModel user;
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final nameController = TextEditingController();
  final aboutController = TextEditingController();
  String? selectedImagePath;

  @override
  Widget build(BuildContext context) {
    final List< UserModel> chatUsers=[];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        title: Text('Profile Screen', style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.primary
        )),

      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
                child:  Stack(
                  children: [
                    CircleAvatar(
                      radius: 80.0,
                      backgroundImage: selectedImagePath != null
                          ? FileImage(File(selectedImagePath! )) as ImageProvider<Object>?
                          : CachedNetworkImageProvider(widget.user.image),

                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child:
                    MaterialButton(onPressed: (){

                    bottomsheet();
                    },
                      child: Icon(Icons.edit),))
                  ],
                )
            ),
            SizedBox(height: 15,),
            Text(widget.user.email, style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface
            ),),
            SizedBox(height: 15,),
            TextFormField(
              controller: nameController,
              // initialValue:widget.user.name ,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                hintText: 'Happy Singh',
                label: Text('Name'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

            ),
            SizedBox(height: 15,),
            TextFormField(
              controller: aboutController!,
              // initialValue:widget.user.about ,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.info_outline),
                hintText: 'Feeling happy',
                label: Text('About'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

            ),
            SizedBox(height: 20,),
            ElevatedButton.icon(onPressed: (){
            String newName = nameController.text;
            String newAbout = aboutController.text;
    if (newName.isNotEmpty && newAbout.isNotEmpty) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.email)
        .update({'name': newName,
                  'about': newAbout})
        .then((value) {
    // Update successful
    print('Name updated successfully');
    })
        .catchError((error) {
    // Error occurred
    print('Failed to update name: $error');
    });
    }
    },
    style: ElevatedButton.styleFrom(
    shape: StadiumBorder(),
    ),
    icon: Icon(Icons.edit),
    label: Text('Update'),
    ),









          ],
        ),
      ),








      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          FirebaseAuth.instance.signOut();
        },
        icon: Icon(Icons.add_comment),
        label: Text('Logout'),

      ),
    );

  }
  void selectImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        selectedImagePath = pickedImage.path;
      });
      uploadImageAndUpdateProfile(selectedImagePath!);
      // Handle the selected image from the gallery
      // You can use the pickedImage.path to display or process the image further

    }
  }
  void captureImageFromCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        selectedImagePath = pickedImage.path ;
      });
      uploadImageAndUpdateProfile(selectedImagePath!);
      // Handle the captured image from the camera
      // You can use the pickedImage.path to display or process the image further'

    }
  }
  void bottomsheet(){
    showModalBottomSheet(
        context: context,

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),topRight: Radius.circular(20),

          ),

        ),
        builder: (BuildContext context){

      return ListView(

        children: [
          Text('Pick profile picture',textAlign: TextAlign.center, style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500
          ),),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: (){
                selectImageFromGallery();
              }, child: Image.asset('assets/old.jpg',
              height: 80,
              width: 80,) ),
              SizedBox(width: 20,),
              ElevatedButton(onPressed: (){
                captureImageFromCamera();
              }, child: Image.asset('assets/5625.jpg',
                height:100,
                width: 80,))
            ],
          )

        ],
      );
    });
  }
}

void uploadImageAndUpdateProfile(String imagePath) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('users')
          .child('${user.email}.jpg');

      final taskSnapshot = await storageRef.putFile(File(imagePath));
      final imageDownloadUrl = await taskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .update({'image': imageDownloadUrl});

      // Update successful
      print('Profile image updated successfully');

    } catch (error) {
      // Error occurred
      print('Failed to update profile image: $error');
    }
  }
}