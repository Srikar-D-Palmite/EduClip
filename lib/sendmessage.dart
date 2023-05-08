import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'register.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  late User _user;
  late Timer _timer;

  @override
  void initState() {
    _user = auth.currentUser!;
    _user.sendEmailVerification();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text("An email has been sent to your email please verify."),
    ));
  }

  Future<void> checkEmailVerified() async {
    _user = auth.currentUser!;
    await _user.reload();
    if (_user.emailVerified) {
      _timer.cancel();
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }
}
