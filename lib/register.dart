import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'authentication.dart';
// import 'login.dart';
import 'login.dart';
import 'sendmessage.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  late String _email, _password, _firstName, _lastName, _username;
  bool _showPassword = false;
  String _errorMessage = '';

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create an Account',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? 'Email can\'t be empty' : null,
                  onSaved: (value) => _email = value!,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Email',
                    contentPadding: const EdgeInsets.all(16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(width: 0.0, color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(width: 0.0, color: Colors.black),
                    ),
                  ),
                ),

                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (value) => value!.isEmpty
                            ? 'First Name can\'t be empty'
                            : null,
                        onSaved: (value) => {
                          _firstName = value!,
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'First Name',
                          contentPadding: const EdgeInsets.all(16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                width: 0.0, color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                width: 0.0, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0, width: 15.0),
                    Expanded(
                      child: TextFormField(
                        validator: (value) =>
                            value!.isEmpty ? 'Last Name can\'t be empty' : null,
                        onSaved: (value) => {
                          _lastName = value!,
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Last Name',
                          contentPadding: const EdgeInsets.all(16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                width: 0.0, color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                width: 0.0, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? 'Username can\'t be empty' : null,
                  onSaved: (value) => _username = value!,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Username',
                    contentPadding: const EdgeInsets.all(16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(width: 0.0, color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(width: 0.0, color: Colors.black),
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
                      borderSide:
                          const BorderSide(width: 0.0, color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(width: 0.0, color: Colors.black),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_showPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
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
                // TextFormField(
                //   obscureText: !_showPassword,
                //   // not working
                //   validator: (value) => value!.isEmpty ? 'Password can\'t be empty' : value!=_password ? 'Passwords do not match' : null,
                //   onSaved: (value) => _password = value!,
                //   decoration: InputDecoration(
                //     filled: true,
                //     fillColor: Colors.white,
                //     hintText: 'Confirm Password',
                //     contentPadding: const EdgeInsets.all(16.0),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(8.0),
                //       borderSide:
                //           const BorderSide(width: 0.0, color: Colors.black),
                //     ),
                //     enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(8.0),
                //       borderSide:
                //           const BorderSide(width: 0.0, color: Colors.black),
                //     ),
                //     suffixIcon: IconButton(
                //         icon: Icon(_showPassword
                //             ? Icons.visibility
                //             : Icons.visibility_off),
                //         onPressed: _togglePasswordVisibility,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 15.0),
                TextButton(
                  onPressed: () => _submitForm(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 84, 180, 211),
                    // textStyle: const TextStyle(
                    //   color: Colors.black,
                    //   fontWeight: FontWeight.bold,
                    // ),
                    //primary: Colors.white,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    minimumSize: const Size.fromHeight(50.0),
                  ),
                  child: const Text('Sign up'),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    // existing form fields
                    SizedBox(height: 15.0),
                    GoogleSignUpButton(),
                    // existing buttons
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) async {
    String errorMessage;
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      // Check if the username already exists in Firestore
      final usernameSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: _username)
          .get();

      if (usernameSnapshot.docs.isNotEmpty) {
        errorMessage = 'Username already exists';
        setState(() {
          _errorMessage = errorMessage;
        });
        return;
      }

      final emailSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: _email)
          .get();

      if (emailSnapshot.docs.isNotEmpty) {
        errorMessage = 'Email already exists';
        setState(() {
          _errorMessage = errorMessage;
        });
        return;
      }

      try {
        // Create a new user in Firebase Authentication
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        // Add the new user to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'userId': FieldValue.increment(1),
          'email': _email,
          'firstName': _firstName,
          'lastName': _lastName,
          'username': _username,
          'createdAt': DateTime.now(),
          'followers': 0,
          'following': 0,
        });
        setState(() {
          _errorMessage = '';
        });
        Navigator.of(context).pushReplacementNamed('/verify');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          errorMessage = 'Email already in use';
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

class GoogleSignUpButton extends StatefulWidget {
  const GoogleSignUpButton({super.key});

  @override
  _GoogleSignUpButtonState createState() => _GoogleSignUpButtonState();
}

class _GoogleSignUpButtonState extends State<GoogleSignUpButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? const CircularProgressIndicator(
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

                int? user =
                    await Authentication.signUpWithGoogle(context: context);

                if (user == 0) {
                  Navigator.of(context).pushReplacementNamed("/home");
                } else {
                  // TODO: Display Error
                }
                // FirebaseFirestore.instance
                //     .collection('users')
                //     .doc(FirebaseAuth.instance.currentUser!.uid)
                //     .set({
                //   'email': FirebaseAuth.instance.currentUser!.email,
                //   'firstName': "Srikar",
                //   'lastName': "Tadeparti",
                //   'username': "glintingcarp",
                // });
                // // TODO: Add a method call to the Google Sign-In authentication

                // setState(() {
                //   _isSigningIn = false;
                // });
                // User? user1 = FirebaseAuth.instance.currentUser;

                // if (user1 != null) {
                //   Navigator.of(context).pushReplacementNamed('/home');
                // }
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
                        'Sign up with Google',
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
