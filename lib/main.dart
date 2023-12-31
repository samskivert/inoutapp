import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'auth.dart';
import 'model.dart';
import 'store.dart';
import 'ui.dart';
import 'toread.dart';
import 'towatch.dart';
import 'tohear.dart';
import 'toplay.dart';
import 'todine.dart';
import 'tobuild.dart';

void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: is there a better time to do this?
  var task = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await task;
  runApp(ChangeNotifierProvider(
    create: (ctx) => InOutModel(),
    child: const InOutApp()
  ));
}

class InOutApp extends StatefulWidget {
  const InOutApp({super.key});

  @override
  State<InOutApp> createState () => InOutAppState();
}

class TempPage extends StatelessWidget {
  final String what;
  const TempPage({super.key, required this.what});
  @override Widget build (BuildContext context) => Scaffold(
    appBar: appBar(context),
    body: Center(child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(what)
    )),
  );
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
    final user = _user;
    final page = Provider.of<InOutModel>(context);
    final home = user == null ? signInScreen() : switch (page.page) {
      ItemType.journal => const TempPage(what: "Journal"),
      ItemType.read  => const ToReadPage(),
      ItemType.watch => const ToWatchPage(),
      ItemType.hear  => const ToHearPage(),
      ItemType.play  => const ToPlayPage(),
      ItemType.dine  => const ToDinePage(),
      ItemType.build => const ToBuildPage(),
    };
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
