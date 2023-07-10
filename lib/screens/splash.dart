import 'dart:async';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/home.dart';

import 'auth.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(milliseconds: 1500),
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return home();
              } else {
                return Auth();
              }
            },
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child:
          Text('Made By Raghvi With Love ❣️',style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,),
            textAlign: TextAlign.center,
          ),
        )


    );
  }
}
