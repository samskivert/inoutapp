import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override AuthFormState createState() {
    return AuthFormState();
  }
}

class AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  String _status = "";
  bool _authing = false;

  void login () async {
    setState(() {
      _authing = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _status = 'No user found for that email.';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          _status = 'That password is not correct.';
        });
      }
    }
    setState(() {
      _authing = false;
    });
  }

  @override Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Email address',
            ),
            onChanged: (text) {
              _email = text;
            },
            validator: (value) {
              return value == null || value.isEmpty ? 'Please enter your email address.' : null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
            obscureText: true,
            onChanged: (text) {
              _password = text;
            },
            validator: (value) {
              return value == null || value.isEmpty ? 'Please enter your password.' : null;
            },
          ),
          ElevatedButton(
            onPressed: _authing ? null : () {
              if (_formKey.currentState!.validate()) login();
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
