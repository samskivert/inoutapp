import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';
import 'auth.dart';

Future<UserCredential> signInWithGoogle() async {
  var googleUser = await GoogleSignIn().signIn();
  var googleAuth = await googleUser?.authentication;
  return await FirebaseAuth.instance.signInWithCredential(GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  ));
}

void main() async {
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
  State<InOutApp> createState() => InOutAppState();
}

class InOutAppState extends State<InOutApp> {
  User? _user;

  @override
  void initState () {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var title = 'Input/Output - ${(_user?.displayName ?? '<not logged in>')}';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() async {
    // setState(() {
    //   _counter++;
    // });
    await signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const AuthForm(),
              const Text(
                'You have pressed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
