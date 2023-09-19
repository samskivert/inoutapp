import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// Future<UserCredential> signInWithGoogle() async {
//   var googleUser = await GoogleSignIn().signIn();
//   var googleAuth = await googleUser?.authentication;
//   return await FirebaseAuth.instance.signInWithCredential(GoogleAuthProvider.credential(
//     accessToken: googleAuth?.accessToken,
//     idToken: googleAuth?.idToken,
//   ));
// }

class AuthForm extends StatefulWidget {
  const AuthForm ({super.key});

  @override AuthFormState createState () {
    return AuthFormState();
  }
}

class AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  String _status = "";
  bool _authing = false;

  @override Widget build (BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(hintText: 'Email address'),
            onChanged: (text) { _email = text; },
            validator: (value) { return nonNull(value, 'Please enter your email address.'); },
          ),
          TextFormField(
            decoration: const InputDecoration(hintText: 'Password'),
            obscureText: true,
            onChanged: (text) { _password = text; },
            validator: (value) { return nonNull(value, 'Please enter your password.'); },
          ),
          Text(_status),
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

  String? nonNull (String? txt, String msg) { return txt == null || txt.isEmpty ? msg : null; }

  void login () async {
    setState(() {
      _authing = true;
      _status = "Logging in...";
    });
    var status = "";
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password
      );
    } on FirebaseAuthException catch (e) {
      status = (e.code == 'user-not-found' ? 'No user found for that email.' :
                e.code == 'wrong-password' ? 'That password is not correct.' :
                'Error: ${e.code}');
    }
    setState(() {
      _authing = false;
      _status = status;
    });
  }
}
