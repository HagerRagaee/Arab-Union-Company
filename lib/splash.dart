import 'dart:async';
import 'package:flutter/material.dart';
import 'package:source_app/display_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DisplayPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 70, // Increase outer circle radius
              backgroundColor: Color(0xFFFFFFFF),
              child: CircleAvatar(
                radius: 50,
                child: Image(
                    image: AssetImage(
                        "images/logo.jpg")), // Decrease inner circle radius
              ),
            ),
            SizedBox(height: 20),
            Text(
              'CarsFlow',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
