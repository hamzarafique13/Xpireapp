// ignore_for_file: no_logic_in_create_state,file_names

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:Xpiree/Modules/Auth/UI/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login())));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).primaryColor,
      //   centerTitle: true,
      //   elevation: 0.0,
      // ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/s.png',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
