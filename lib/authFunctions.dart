import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

 signupUser (
    String email, String password, File selectedImage, String name, String about) async {
    try {

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
final storageRef=FirebaseStorage.instance.ref().child('users').child('${userCredential.user!.uid}.jpg');
await storageRef.putFile(selectedImage);
final image =await storageRef.getDownloadURL();
print('image url $image');
await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).
set
  (
 {
 'name' : name,
 'email': email,
 'image': image,
   'about': about,
   'id': userCredential.user!.uid,
 }
);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {

            print('Password Provided is too weak');
      } else if (e.code == 'email-already-in-use') {
       print('Email Provided already Exists');
      }
    } catch (e) {
     print(e.toString());
    }

  }
 signinUser (String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);


    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No user Found with this Email')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Password did not match')));
      }
    }
  }


