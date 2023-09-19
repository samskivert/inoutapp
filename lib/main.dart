import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'auth.dart';

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
  Widget build (BuildContext context) {
    var title = 'Input/Output';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: _user == null ? AuthPage(title: title) : ListsPage(title: title),
    );
  }
}

class AuthPage extends StatelessWidget {
  const AuthPage ({super.key, required this.title});

  final String title;

  @override
  Widget build (BuildContext context) {
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

class ListsPage extends StatefulWidget {
  const ListsPage ({super.key, required this.title});

  final String title;

  @override
  State<ListsPage> createState () => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  int _counter = 0;

  void _incrementCounter () async {
    setState(() {
      _counter++;
    });
  }

  IconButton listIcon (IconData icon, String tooltip) {
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      onPressed: () {
        // TODO: set the selected tab state
      }
    );
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          listIcon(Icons.calendar_month, "Journal"),
          listIcon(Icons.menu_book, "To Read"),
          listIcon(Icons.local_movies, "To See"),
          listIcon(Icons.music_video, "To Hear"),
          listIcon(Icons.videogame_asset, "To Play"),
          listIcon(Icons.local_dining, "To Dine"),
          listIcon(Icons.build, "To Build"),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              // TODO: could this throw an exception?
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
