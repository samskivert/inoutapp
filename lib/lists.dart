import 'package:flutter/material.dart';
import 'model.dart';
import 'store.dart';

class ReadList extends StatefulWidget {
  const ReadList ({super.key, required this.store});

  final Store store;

  @override ReadListState createState () {
    return ReadListState();
  }
}

class ReadListState extends State<ReadList> {

  @override Widget build (BuildContext context) {
    return FutureBuilder<Iterable<Read>>(
      future: widget.store.readItems(),
      builder: (BuildContext context, AsyncSnapshot<Iterable<Read>> snapshot) {
        if (snapshot.hasError) return const Text("What is this? I can't even.");
        if (snapshot.connectionState != ConnectionState.done) return const Text("Loading...");

        var reading = snapshot.data!.where((ii) => ii.started != null).toList();
        reading.sort((a, b) => a.started!.compareTo(b.started!));
        var toRead = snapshot.data!.where((ii) => ii.started == null).toList();
        toRead.sort((a, b) => b.created.compareTo(a.created));

        return ListView.separated(
          separatorBuilder: (BuildContext context, int index) => const Divider(),
          itemCount: (reading.isNotEmpty ? 1 : 0) + reading.length + 1 + toRead.length,
          itemBuilder: (BuildContext context, int index) {
            if (reading.isNotEmpty) {
              if (index == 0) {
                return header('Reading');
              } else if (index-1 < reading.length) {
                return ReadItem(item: reading[index-1]);
              } else {
                index -= reading.length+1;
              }
            }
            return index == 0 ? header('To Read') : ReadItem(item: toRead[index-1]);
          },
        );
      },
    );
  }

  Widget header (String label) {
    return Row(children: <Widget>[
      const Icon(Icons.menu_book),
      const SizedBox(width: 5),
      Text(label, style: Theme.of(context).textTheme.titleMedium),
    ]);
  }
}

class ReadItem extends StatelessWidget {

  const ReadItem ({super.key, required this.item});
  final Read item;

  @override Widget build (BuildContext context) {
    var actionTip = item.started == null ? "Mark as started" : "Mark as completed";
    var actionIcon = item.started == null ? Icons.play_arrow : Icons.check_box_outline_blank;
    var items = <Widget>[
      IconButton(
        icon: Icon(actionIcon),
        tooltip: actionTip,
        onPressed: () {
        },
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(item.title),
          Text(item.author ?? "", style: Theme.of(context).textTheme.bodySmall),
        ]),
      const Spacer(),
    ];
    if (item.link != null) {
      items.add(IconButton(
        icon: const Icon(Icons.link),
        tooltip: item.link,
        onPressed: () {
        }
      ));
    }
    items.addAll([
      Icon(iconFor(item.type), color: Colors.grey),
      IconButton(
        icon: const Icon(Icons.edit),
        tooltip: "Edit",
        onPressed: () {
        },
      ),
    ]);
    return Row(children: items);
  }

  IconData iconFor (ReadType type) {
    switch (type) {
    case ReadType.article: return Icons.bookmark;
    case ReadType.book: return Icons.menu_book;
    case ReadType.paper: return Icons.feed_outlined;
    }
  }
}
