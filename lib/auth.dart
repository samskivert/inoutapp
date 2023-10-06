import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';

const googleClientId = '800961532828-v4aes2nm3frdv0d39afgf9u7cnm1l1ej.apps.googleusercontent.com';

Widget signInScreen () {
  final providers = <AuthProvider>[
    EmailAuthProvider(),
    GoogleProvider(clientId: googleClientId),
  ];
  return SignInScreen(
    providers: providers,
    actions: [
      AuthStateChangeAction<SignedIn>((context, state) {
        print('AuthStateChanged $state');
      }),
    ],
  );
}
