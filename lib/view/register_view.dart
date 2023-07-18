import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: Column(
          children: [
            TextField(
              controller: _email,
              decoration:
                  const InputDecoration(hintText: 'Enter your email here'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _password,
              decoration:
                  const InputDecoration(hintText: 'Enter your password here'),
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  final userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password);

                  print(userCredential);
                } on FirebaseAuthException catch (error) {
                  if (error.code == 'invalid-email') {
                    print('ERROR: The email address is badly formatted.');
                  } else if (error.code == 'weak-password') {
                    print('ERROR: Weak password');
                  } else if (error.code == 'email-already-in-use') {
                    print('ERROR: Email already in use');
                  } else {
                    print('ERROR: Something else happended ${error.code}');
                  }
                }
              },
              child: const Text('Register'),
            ),
            TextButton(
                onPressed: () => {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/login', (route) => false)
                    },
                child: const Text('Already registered? Login here!'))
          ],
        ));
  }
}
