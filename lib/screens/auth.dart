import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../authFunctions.dart';
import '../user_image.dart';
class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final form = GlobalKey<FormState>();
  var isLogin = false;
  var enteredEmail= '';
  var enteredPassword='';
   File? selectedImage;
  var enteredUserName='';
  var isAuthenticating = false;
  var enteredAbout='';
    void OnSave(){
    final isValid = form.currentState!.validate();
    if(!isLogin && selectedImage==null) return;
    if(isValid){
      form.currentState!.save();
      isLogin
          ? signinUser(enteredEmail, enteredPassword, context)
          : signupUser(
          enteredEmail, enteredPassword, selectedImage! , enteredUserName, enteredAbout);
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome To We Chat'),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body:SingleChildScrollView(
        child:  Column(
          children: [

            Container(
              margin: EdgeInsets.only(
                  top: 30,
                  left: 20,
                  right: 20,
                  bottom: 20
              ),
              width: 500,
              child: Image.asset('assets/5625.jpg'),
            ),
            Card(
              margin: EdgeInsets.all(20),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: form,
                  child: Column(
                    children: [
                      if(!isLogin) UserImage((pickedImage){
                        setState(() {
                          print(pickedImage);
                          selectedImage= pickedImage!;
                        });
                      }),

                      TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Email'
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value){
                          print(value);
                          if(value==null || value.trim().isEmpty || !value.contains('@')){
                            return 'Please Enter A Valid Email';
                          }else{
                            return null;
                          }
                        },
                        onSaved: (value){
                          enteredEmail= value!;

                        },
                      ),
                      if(!isLogin)
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'UserName'
                          ),
                          validator: (value){
    if(value==null || value.trim().length<4){
    return 'Please Enter A Username Of Length Greater Than 4';
    }else{
    return null;
    }
    },

                          onSaved: (value){
                            enteredUserName=value!;
                          },
                        ),
                      if(!isLogin)
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: 'About'
                          ),

                          validator: (value){
                            print(value);
                            if(value==null || value.trim().isEmpty ){
                              return 'Please Enter A Valid About';
                            }else{
                              return null;
                            }
                          },
                          onSaved: (value){
                            enteredAbout= value!;

                          },
                        ),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Password'
                        ),
                        obscureText: true,
                        validator: (value){

                          if(value==null || value.trim().length<6){
                            return 'Please Enter A Password Of Length Greater Than 6';
                          }else{
                            return null;
                          }
                        },
                        onSaved: (value){

                          enteredPassword= value!;
                        },
                      ),
                      SizedBox(height: 20,),



                       ElevatedButton(onPressed: OnSave, child: Text(isLogin
                            ? 'Login'
                            : 'Sign up')),

                        TextButton(onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        }
                            , child: Text(isLogin
                                ? 'Create an account '
                                : 'I already have an acoount'))
                      ],
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
