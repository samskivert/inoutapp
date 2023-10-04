import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model.dart';
import 'store.dart';
import 'ui.dart';

class ToWatchPage extends StatefulWidget {
  const ToWatchPage({super.key});
  @override ToWatchPageState createState () => ToWatchPageState();
}

class ToWatchPageState extends ItemPageState<ToWatchPage, Watch> {
  @override ItemType itemType () => ItemType.watch;
  @override Stream<List<Entry<Watch>>> currentItems (Store store) => store.watchItems(5).map(
    (abc) => entries3('Watching', abc.$1, 'To See', abc.$2, 'Recently Seen', abc.$3));
  @override Stream<List<Entry<Watch>>> historyItems (Store store, String filter) =>
    store.watchHistory().map((iis) => annuate(iis, filter));
  @override String createPlaceholder () => 'Title - Director';
  @override String createItem (Store store, String text) => store.create(ItemType.watch, text);
  @override Widget mkItem (Watch item) => WatchItem(item: item);
}

void updateWatch (BuildContext ctx, Watch item, dynamic Function(WatchBuilder) updates) {
  Provider.of<Store>(ctx, listen: false).updateWatch(item, item.rebuild(updates));
}

class WatchItem extends StatelessWidget {
  WatchItem ({required this.item}) : super(key: Key(item.id!));
  final Watch item;

  @override Widget build (BuildContext context) => consumeRow(
    context, item, item.title, item.director, iconFor(item.type), item.abandoned,
    () => updateWatch(context, item, (b) => b..started = dateFmt.format(DateTime.now())),
    () => updateWatch(context, item, (b) => b..completed = dateFmt.format(DateTime.now())),
    () => updateWatch(context, item, (b) => b..completed = null),
    (_) => EditWatchItem(item: item));
}

IconData iconFor (WatchType type) {
  switch (type) {
  case WatchType.show: return Icons.live_tv;
  case WatchType.film: return Icons.local_movies;
  case WatchType.video: return Icons.ondemand_video;
  case WatchType.other: return Icons.feed_outlined;
  }
}

class EditWatchItem extends StatefulWidget {
  const EditWatchItem ({super.key, required this.item});
  final Watch item;
  @override EditWatchItemState createState () => EditWatchItemState(item);
}

final typeEntries = WatchType.values.map(
  (rr) => DropdownMenuEntry<WatchType>(value: rr, label: rr.label)).toList();

class EditWatchItemState extends State<EditWatchItem> {
  final _formKey = GlobalKey<FormState>();
  Watch _item;

  EditWatchItemState (Watch item) : _item = item;

  @override Widget build (BuildContext ctx) => Scaffold(
    appBar: AppBar(
      title: const Text('Edit'),
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            textField(_item.title, 'Title', (text) {
              _item = _item.rebuild((b) => b..title = text);
            }),
            const SizedBox(height: 12),
            textField(_item.director ?? '', 'Director', (text) {
              _item = _item.rebuild((b) => b..director = beNull(text));
            }),
            const SizedBox(height: 24),
            Row(children: <Widget>[
              Expanded(child: DropdownMenu<WatchType>(
                initialSelection: _item.type,
                label: const Text('Type'),
                dropdownMenuEntries: typeEntries,
                onSelected: (WatchType? type) {
                  setState(() {
                    if (type is WatchType) _item = _item.rebuild((b) => b..type = type);
                  });
                },
              )),
              const SizedBox(width: 32),
              Expanded(child: textField2(_item.tags.join(' '), 'Tags', (text) => setState(() {
                _item = _item.rebuild((b) {
                  text.isEmpty ? b.tags.clear() : b.tags.replace(text.split(' '));
                });
              }))),
            ]),
            Row(children: <Widget>[
              Expanded(child: textField2(_item.link ?? '', 'Link', (text) => setState(() {
                _item = _item.rebuild((b) => b..link = beNull(text));
              }))),
              const SizedBox(width: 32),
              Expanded(child: textField2(_item.recommender ?? '', 'Recommender', (text) => setState(() {
                _item = _item.rebuild((b) => b..recommender = beNull(text));
              }))),
            ]),
            const SizedBox(height: 24),
            Row(children: <Widget>[
              Expanded(child: DropdownMenu<Rating>(
                initialSelection: _item.rating,
                label: const Text('Rating'),
                dropdownMenuEntries: ratingEntries,
                onSelected: (Rating? rating) {
                  setState(() {
                    if (rating is Rating) _item = _item.rebuild((b) => b..rating = rating);
                  });
                },
              )),
              Expanded(child: CheckboxListTile(
                title: const Text('Abandoned'),
                value: _item.abandoned,
                onChanged: (selected) {
                  setState(() {
                    if (selected is bool) _item = _item.rebuild((b) => b..abandoned = selected);
                  });
                },
              )),
            ]),
            const SizedBox(height: 12),
            Row(children: <Widget>[
              Expanded(child: textFieldDate(ctx, _item.started ?? '', 'Started', (date) => setState(() {
                _item = _item.rebuild((b) => b..started = date);
              }))),
              const SizedBox(width: 32),
              Expanded(child: textFieldDate(ctx, _item.completed ?? '', 'Completed', (date) => setState(() {
                _item = _item.rebuild((b) => b..completed = date);
              }))),
            ]),
            const SizedBox(height: 24),
            Text('Created: ${createdFmt.format(_item.created.toDate())}'),
            const SizedBox(height: 24),
            Row(children: <Widget>[
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Delete item',
                onPressed: () {
                  final store = Provider.of<Store>(ctx, listen: false);
                  store.deleteWatch(_item);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Deleted item: ${_item.title}'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () => store.recreateWatch(_item)
                    ),
                  ));
                },
              ),
              const Spacer(),
              OutlinedButton(child: const Text('Cancel'), onPressed: () => Navigator.pop(ctx)),
              const SizedBox(width: 32),
              FilledButton(child: const Text('Update'), onPressed: () {
                Provider.of<Store>(ctx, listen: false).updateWatch(widget.item, _item);
                Navigator.pop(ctx);
              }),
            ]),
          ]
        ),
      ),
    ),
  );
}
