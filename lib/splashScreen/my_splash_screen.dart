import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../authScreens/auth_screen.dart';
import '../sellersScreens/home_screen.dart';

class MySplashScreen extends StatefulWidget {
  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  splashScreenTimer() {
    Timer(const Duration(seconds: 4), () async {
      //Seller is already logged-in
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
      } else {
        //Seller is NOT already logged-in
        Navigator.push(context, MaterialPageRoute(builder: (c) => AuthScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    splashScreenTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white54],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Image.asset(
                  "images/splash.png",
                  // Adjust the width and height properties to fit your image size
                  width: 200,
                  height: 200,
                ),
              ),
              Text(
                "Don't Waste Just It'sReuse",
                style: TextStyle(
                  fontSize: 30,
                  letterSpacing: 3,
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // Center the text
              )
            ],
          ),
        ),
      ),
    );
  }
}
