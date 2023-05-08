import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'authentication.dart';
// import 'login.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  late String _email, _password, _firstName, _lastName, _username;
  bool _showPassword = false;

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
                TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? 'Name can\'t be empty' : null,
                  onSaved: (value) => {
                    _firstName = value!.split(' ')[0],
                    _lastName = value.split(' ')[1],
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Full Name',
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
                // const SizedBox(height: 15.0),
                TextButton(
                  onPressed: () => _submitForm(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 84, 180, 211),
                    // textStyle: const TextStyle(
                    //   color: Colors.black,
                    //   fontWeight: FontWeight.bold,
                    // ),
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    minimumSize: const Size.fromHeight(50.0),
                  ),
                  child: const Text('Sign up'),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      try {
        // register account
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        // write user data in database
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'email': _email,
          'firstName': _firstName,
          'lastName': _lastName,
          'username': _username,
        });
        // sign in
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        //.onError((e, _) => print("Error writing document: $e"));
        Navigator.of(context).pushReplacementNamed('/home');
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
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

                User? user =
                    await Authentication.signInWithGoogle(context: context);

                FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .set({
                  'email': FirebaseAuth.instance.currentUser!.email,
                  'firstName': "Srikar",
                  'lastName': "Tadeparti",
                  'username': "glintingcarp",
                });
                // TODO: Add a method call to the Google Sign-In authentication

                setState(() {
                  _isSigningIn = false;
                });
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
                    Image(
                      image: AssetImage("assets/google_logo.png"),
                      height: 35.0,
                    ),
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
