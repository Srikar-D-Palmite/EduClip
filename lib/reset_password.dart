import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'register.dart';
import "login.dart";

class ResetScreenPage extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreenPage> {
  late String _email;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final String senderName = "Educlip";
    final String senderEmail = "noreply@educlip.com";
    final String subjectLine = "Reset Password Request";
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: ("Enter your email"),
              ),
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                child: Text("Send Request"),
                onPressed: () {
                  auth.sendPasswordResetEmail(email: _email);
                  Navigator.of(context).pushReplacementNamed('/login');
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
