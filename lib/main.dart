import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'auth.dart';
import 'model.dart';
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
  // User? _user;
  Store? _store;

  @override
  void initState () {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        // _user = user;
        _store = user == null ? null : Store(user);
      });
    });
  }

  @override
  Widget build (BuildContext context) {
    const title = 'Input/Output';
    final store = _store;
    final home = store != null ? ListsPage(title: title, store: store) :
      const AuthPage(title: title);
    return MaterialApp(
      title: title,
      theme: ThemeData(primarySwatch: Colors.green),
      home: home,
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

class ListsPage extends StatefulWidget {
  const ListsPage ({super.key, required this.title, required this.store});

  final String title;
  final Store store;

  @override
  State<ListsPage> createState () => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  ItemType _page = ItemType.read;

  IconButton listIcon (ItemType page, IconData icon, String tooltip) {
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      onPressed: () {
        setState(() {
          _page = page;
        });
      }
    );
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          listIcon(ItemType.journal, Icons.calendar_month, "Journal"),
          listIcon(ItemType.read, Icons.menu_book, "To Read"),
          listIcon(ItemType.watch, Icons.local_movies, "To See"),
          listIcon(ItemType.hear, Icons.music_video, "To Hear"),
          listIcon(ItemType.play, Icons.videogame_asset, "To Play"),
          listIcon(ItemType.dine, Icons.local_dining, "To Dine"),
          listIcon(ItemType.build, Icons.build, "To Build"),
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
          // TODO: pick list based on _page
          child: ReadList(store: widget.store),
        ),
      ),
    );
  }
}
