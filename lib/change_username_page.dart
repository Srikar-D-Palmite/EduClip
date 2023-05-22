import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangeUsernamePage extends StatefulWidget {
  const ChangeUsernamePage({Key? key}) : super(key: key);
  @override
  _ChangeUsernamePageState createState() => _ChangeUsernamePageState();
}

class _ChangeUsernamePageState extends State<ChangeUsernamePage> {
  String _newUsername = '';
  String _newName = '';
  String _errorMessage = '';
  bool _isLoading =false;
  final _formKey = GlobalKey<FormState>();

  void _saveChanges(BuildContext context) {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      setState(() {
         _isLoading = true;
      });
           _updateUserInformation();
         setState(() {
         _isLoading = false;
       });
      Navigator.pop(context, _newUsername);
    }
  }

  Future<void> _updateUserInformation() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;

        // Check if the new username already exists in Firestore
        final usernameSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: _newUsername)
            .get();
        if (usernameSnapshot.docs.isNotEmpty) {
          setState(() {
            _errorMessage = 'Username already exists';
          });
          return; // Exit the function if there's an error
        }

        // Update the user's username and name in Firestore
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'username': _newUsername,
          'Name': _newName,
        });

        setState(() {
          _errorMessage = '';
        });
        Navigator.of(context).pop(); // Return to the previous page
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Username and Name',
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black)),
        iconTheme: IconThemeData(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Change Username:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _newUsername = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Enter new username',
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a new username';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Change Name:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _newName = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Enter new name',
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a new name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
               key: const Key('saveChangesButton'),
              onPressed: () => _saveChanges(context),
              style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.black, // Background color
                ),
              child: const Text('Save Changes'),
              
            ),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}