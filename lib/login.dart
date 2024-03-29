import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'register.dart';
import 'authentication.dart';
import 'reset_password.dart';

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
              const LoginForm(),
              const Divider(),
              const SizedBox(height: 10.0),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegistrationPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Sign up",
                    // style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResetScreenPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Forgot Password ?",
                    // style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
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
  late String _email, _password, _username, _val;
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
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                minimumSize: const Size.fromHeight(50.0),
              ),
              child: const Text('Log in'),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // existing form fields
                const SizedBox(height: 15.0),
                GoogleSignInButton(),
                // existing buttons
              ],
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
      final isEmail = _email.contains('@');
      try {
        UserCredential userCredential;

        if (isEmail) {
          // User provided an email address
          userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password);
        } else {
          // User provided a username
          final _username = _email;
          final firestoreInstance = FirebaseFirestore.instance;
          final querySnapshot = await firestoreInstance
              .collection('users')
              .where('username', isEqualTo: _username)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            // User was found by username
            final emaill = querySnapshot.docs.first['email'];
            userCredential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: emaill, password: _password);
          } else {
            // User was not found by username
            throw FirebaseAuthException(
              code: 'user-not-found',
              message: 'Invalid email or username',
            );
          }
        }
        setState(() {
          _errorMessage = '';
        });
        Navigator.of(context).pushReplacementNamed('/home');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          errorMessage = 'Invalid email or username';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Invalid password';
        } else if (e.code == "invalid-email") {
          errorMessage = 'Invalid email or username';
        } else {
          errorMessage = 'An error occurred. Please try again later.';
        }

        setState(() {
          _errorMessage = errorMessage;
        });
      }
    }
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FutureBuilder(
            future: Authentication.initializeFirebase(context: context),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error initializing Firebase');
              } else if (snapshot.connectionState == ConnectionState.done) {
                return GoogleSignInButton();
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });

                // User? user =
                num err =
                    await Authentication.signInWithGoogle(context: context);

                // TODO: Add a method call to the Google Sign-In authentication

                setState(() {
                  _isSigningIn = false;
                });

                if (err == -1) {
                  return;
                  // TODO: Display error message
                }

                User? user1 = FirebaseAuth.instance.currentUser;

                if (user1 != null) {
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
