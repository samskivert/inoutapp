import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'auth.dart';
import 'store.dart';
import 'lists.dart';

void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: is there a better time to do this?
  var task = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await task;
  runApp(const InOutApp());
}

class InOutApp extends StatefulWidget {
  const InOutApp({super.key});

  @override
  State<InOutApp> createState () => InOutAppState();
}

class InOutAppState extends State<InOutApp> {
  User? _user;

  @override void initState () {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  @override Widget build (BuildContext context) {
    const title = 'Input/Output';
    final user = _user;
    final home = user == null ? const AuthPage(title: title) : const ListsPage(title: title);
    final theme = ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          border: UnderlineInputBorder(),
          labelStyle: TextStyle(height: 0.5),
        ),
        dropdownMenuTheme: const DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(
            border: UnderlineInputBorder(),
          )
        ),
      );
    final app = MaterialApp(title: title, theme: theme, home: home);
    return user == null ? app : Provider(
      create: (_) => Store(user),
      child: app,
    );
  }
}

class AuthPage extends StatelessWidget {
  const AuthPage ({super.key, required this.title});

  final String title;

  @override Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: AuthForm(),
        ),
      ),
    );
  }
}
