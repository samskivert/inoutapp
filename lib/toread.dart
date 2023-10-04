import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model.dart';
import 'store.dart';
import 'ui.dart';

class ToReadPage extends StatefulWidget {
  const ToReadPage({super.key});
  @override ToReadPageState createState () => ToReadPageState();
}

class ToReadPageState extends ItemPageState<ToReadPage, Read> {
  @override ItemType itemType () => ItemType.read;
  @override Stream<List<Entry<Read>>> currentItems (Store store) => store.readItems(5).map(
    (abc) => entries3('Reading', abc.$1, 'To Read', abc.$2, 'Recently Read', abc.$3));
  @override Stream<List<Entry<Read>>> historyItems (Store store, String filter) =>
    store.readHistory().map((iis) => annuate(iis, filter));
  @override String createPlaceholder () => 'Title - Author';
  @override String createItem (Store store, String text) => store.create(ItemType.read, text);
  @override Widget mkItem (Read item) => ReadItem(item: item);
}

void updateRead (BuildContext ctx, Read item, dynamic Function(ReadBuilder) updates) {
  Provider.of<Store>(ctx, listen: false).updateRead(item, item.rebuild(updates));
}

class ReadItem extends StatelessWidget {
  ReadItem ({required this.item}) : super(key: Key(item.id!));
  final Read item;

  @override Widget build (BuildContext context) => consumeRow(
    context, item, item.title, item.author, iconFor(item.type), item.abandoned,
    () => updateRead(context, item, (b) => b..started = dateFmt.format(DateTime.now())),
    () => updateRead(context, item, (b) => b..completed = dateFmt.format(DateTime.now())),
    () => updateRead(context, item, (b) => b..completed = null),
    (_) => EditReadItem(item: item));
}

IconData iconFor (ReadType type) {
  switch (type) {
  case ReadType.article: return Icons.bookmark;
  case ReadType.book: return Icons.menu_book;
  case ReadType.paper: return Icons.feed_outlined;
  }
}

class EditReadItem extends StatefulWidget {
  const EditReadItem ({super.key, required this.item});
  final Read item;
  @override EditReadItemState createState () => EditReadItemState(item);
}

final typeEntries = ReadType.values.map(
  (rr) => DropdownMenuEntry<ReadType>(value: rr, label: rr.label)).toList();

class EditReadItemState extends State<EditReadItem> {
  final _formKey = GlobalKey<FormState>();
  Read _item;

  EditReadItemState (Read item) : _item = item;

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
            textField(_item.author ?? '', 'Author', (text) {
              _item = _item.rebuild((b) => b..author = beNull(text));
            }),
            const SizedBox(height: 24),
            Row(children: <Widget>[
              Expanded(child: DropdownMenu<ReadType>(
                initialSelection: _item.type,
                label: const Text('Type'),
                dropdownMenuEntries: typeEntries,
                onSelected: (ReadType? type) {
                  setState(() {
                    if (type is ReadType) _item = _item.rebuild((b) => b..type = type);
                  });
                },
              )),
              const SizedBox(width: 32),
              Expanded(child: textField2(_item.tags.join(' '), 'Tags', (text) {
                _item = _item.rebuild((b) {
                  text.isEmpty ? b.tags.clear() : b.tags.replace(text.split(' '));
                });
              })),
            ]),
            Row(children: <Widget>[
              Expanded(child: textField2(_item.link ?? '', 'Link', (text) {
                _item = _item.rebuild((b) => b..link = beNull(text));
              })),
              const SizedBox(width: 32),
              Expanded(child: textField2(_item.recommender ?? '', 'Recommender', (text) {
                _item = _item.rebuild((b) => b..recommender = beNull(text));
              })),
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
              Expanded(child: textFieldDate(ctx, _item.started ?? '', 'Started', (date) {
                _item = _item.rebuild((b) => b..started = date);
              })),
              const SizedBox(width: 32),
              Expanded(child: textFieldDate(ctx, _item.completed ?? '', 'Completed', (date) {
                _item = _item.rebuild((b) => b..completed = date);
              })),
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
                  store.deleteRead(_item);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Deleted item: ${_item.title}'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () => store.recreateRead(_item)
                    ),
                  ));
                },
              ),
              const Spacer(),
              OutlinedButton(child: const Text('Cancel'), onPressed: () => Navigator.pop(ctx)),
              const SizedBox(width: 32),
              FilledButton(child: const Text('Update'), onPressed: () {
                Provider.of<Store>(ctx, listen: false).updateRead(widget.item, _item);
                Navigator.pop(ctx);
              }),
            ]),
          ]
        ),
      ),
    ),
  );
}
