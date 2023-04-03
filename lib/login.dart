import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            // decoration: const BoxDecoration(
            //   gradient: LinearGradient(
            //     begin: Alignment.topRight,
            //     end: Alignment.bottomLeft,
            //     colors: [Colors.blue, Colors.purple],
            //   ),
            // ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Educlip',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 60.0,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 48.0),
                LoginForm(),
                const Divider(),
                const SizedBox(height: 10.0),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistrationPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Sign up",
                      // style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late String _email, _password;
  String _errorMessage = '';
  bool _showPassword = false;

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              validator: (value) //{
                  =>
                  value!.isEmpty
                      ? 'Please enter your email or username'
                      : RegExp(r'^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$')
                                  .hasMatch(value) ||
                              RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)
                          ? null
                          : 'Please enter a valid email or username',
              onSaved: (value) => _email = value!,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Username or Email',
                contentPadding: const EdgeInsets.all(16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(width: 0.0, color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(width: 0.0, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            TextFormField(
              obscureText: !_showPassword,
              validator: (value) =>
                  value!.isEmpty ? 'Password can\'t be empty' : null,
              onSaved: (value) => _password = value!,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Password',
                contentPadding: const EdgeInsets.all(16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(width: 0.0, color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(width: 0.0, color: Colors.black),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            TextButton(
              onPressed: () => _submitForm(context),
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                // textStyle: const TextStyle(
                //   color: Colors.black,
                //   fontWeight: FontWeight.bold,
                // ),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                minimumSize: const Size.fromHeight(50.0),
              ),
              child: const Text('Log in'),
            ),
            const SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) async {
    String errorMessage;
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        setState(() {
          _errorMessage = '';
        });
        Navigator.of(context).pushReplacementNamed('/home');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          errorMessage = 'Invalid email';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Invalid password';
        } else if (e.code == "invalid-email") {
          errorMessage = 'Invalid username';
        } else {
          errorMessage = 'An error occurred. Please try again later.';
        }

        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     content: Text(
        //   errorMessage,
        //   style: TextStyle(color: Colors.red),
        // )));
        setState(() {
          _errorMessage = errorMessage;
        });
      }
    }
  }
}
