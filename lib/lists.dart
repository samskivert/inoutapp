import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'model.dart';
import 'toread.dart';

class ListsPage extends StatefulWidget {
  const ListsPage ({super.key, required this.title});
  final String title;
  @override State<ListsPage> createState () => _ListsPageState();
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
    // TODO: pick based on _page
    const body = ReadList();
    const footer = BottomAppBar(height: 60, child: ReadFooter());
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
      body: const Center(child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: body
      )),
      bottomNavigationBar: footer,
    );
  }
}
