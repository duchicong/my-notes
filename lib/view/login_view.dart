import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        appBar: AppBar(title: const Text('Login')),
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
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email, password: password);
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/notes', (route) => false);
                } on FirebaseAuthException catch (error) {
                  if (error.code == 'user-not-found') {
                    devtools.log('ERROR: User not found');
                  } else if (error.code == 'wrong-password') {
                    devtools.log('ERROR: Wrong password');
                  } else {
                    devtools.log('SOMETHING ELSE HAPPENED ${error.code}');
                  }
                }
              },
              child: const Text('Login'),
            ),
            TextButton(
                onPressed: () => {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/register', (route) => false)
                    },
                child: const Text('Not registered yet? Register here!'))
          ],
        ));
  }
}
