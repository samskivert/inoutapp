import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'model.dart';
import 'store.dart';
import 'ui.dart';

enum ReadMode { current, history }
class ReadModeModel extends ChangeNotifier {
  ReadMode _mode = ReadMode.current;

  ReadMode get mode => _mode;
  set mode (ReadMode mode) {
    _mode = mode;
    notifyListeners();
  }
}

class ToReadPage extends StatefulWidget {
  const ToReadPage({super.key});
  @override ToReadPageState createState () => ToReadPageState();
}

class ToReadPageState extends State<ToReadPage> {
  bool _historyMode = false;
  String _filter = '';
  final _filterCtrl = TextEditingController();

  @override void dispose () {
    _filterCtrl.dispose();
    super.dispose();
  }

  @override Widget build (BuildContext context) {
    var store = Provider.of<Store>(context);
    var items = _historyMode ? store.readHistory().map((iis) => annuate(iis, _filter)) :
      store.readItems(5).map(
        (abc) => entries3('Reading', abc.$1, 'To Read', abc.$2, 'Recently Read', abc.$3));
    _filterCtrl.text = _filter; // this is ridiculous
    var footer = _historyMode ?
      Row(children: <Widget>[
        OutlinedButton(child: const Text('History'), onPressed: () {
          setState(() {
            _historyMode = false;
          });
        }),
        const SizedBox(width: 12),
        Expanded(child: TextFormField(
          controller: _filterCtrl,
          decoration: const InputDecoration(hintText: 'Filter'),
          onFieldSubmitted: (text) => setState(() {
            _filter = text;
          }),
        )),
      ]) :
      Row(children: <Widget>[
        OutlinedButton(child: const Text('Current'), onPressed: () {
          setState(() {
            _historyMode = true;
          });
        }),
        const SizedBox(width: 12),
        ...itemFooter(context, 'Title - Author', createItem),
      ]);
    return ChangeNotifierProvider(
      create: (ctx) => ReadModeModel(),
      child: Scaffold(
        appBar: appBar(context),
        body: Center(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: itemList<Read>(items, (ii) => ReadItem(item: ii))
        )),
        bottomNavigationBar: BottomAppBar(
          height: 60, child: footer),
      )
    );
  }
}

String createItem (BuildContext ctx, String text) {
  var didx = text.indexOf('-');
  var (title, author) = didx > 0 ?
    (text.substring(0, didx).trim(), text.substring(didx+1).trim()) :
    (text.trim(), null);
  Provider.of<Store>(ctx, listen: false).create(title, author);
  return title;
}

void updateRead (BuildContext ctx, Read item, dynamic Function(ReadBuilder) updates) {
  Provider.of<Store>(ctx, listen: false).update(item, item.rebuild(updates));
}

class ReadItem extends StatelessWidget {
  ReadItem ({required this.item}) : super(key: Key(item.id));
  final Read item;

  @override Widget build (BuildContext context) {
    var (actionTip, actionIcon, action) =
      item.started == null ? ('Mark as started', Icons.play_arrow, () {
        updateRead(context, item, (b) => b..started = dateFmt.format(DateTime.now()));
      }) :
      item.completed == null ? ('Mark as completed', Icons.check_box_outline_blank, () {
        updateRead(context, item, (b) => b..completed = dateFmt.format(DateTime.now()));
      }) :
      ('Revert to uncompleted', Icons.check_box, () {
        updateRead(context, item, (b) => b..completed = null);
      });
    var items = <Widget>[
      IconButton(icon: Icon(actionIcon), tooltip: actionTip, onPressed: action),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(item.title),
          Text(item.author ?? '', style: Theme.of(context).textTheme.bodySmall?.merge(
            TextStyle(color: Colors.grey[600]))),
        ]),
      const Spacer(),
      if (item.rating != Rating.none) Text(
        '${item.rating.emoji} ', style: Theme.of(context).textTheme.titleLarge),
      if (item.link != null) IconButton(
        icon: const Icon(Icons.link),
        tooltip: item.link,
        onPressed: () async {
          if (!await launchUrl(Uri.parse(item.link!))) {
            print('Failed to launch: ${item.link}');
          }
        }
      ),
      IconButton(
        icon: const Icon(Icons.edit),
        tooltip: 'Edit',
        onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => EditReadItem(item: item))),
      ),
      Icon(iconFor(item.type), color: Colors.grey[600]),
    ];
    return Row(children: items);
  }
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

class EditReadItemState extends State<EditReadItem> {
  final _formKey = GlobalKey<FormState>();
  Read _item;

  EditReadItemState (Read item) : _item = item;

  @override Widget build (BuildContext ctx) {
    final typeEntries = <DropdownMenuEntry<ReadType>>[];
    for (final ReadType type in ReadType.values) {
      typeEntries.add(DropdownMenuEntry<ReadType>(value: type, label: type.label));
    }

    final ratingEntries = <DropdownMenuEntry<Rating>>[];
    for (final Rating rating in Rating.values) {
      ratingEntries.add(DropdownMenuEntry<Rating>(
        value: rating, label: rating.emoji + rating.label));
    }

    return Scaffold(
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
                    store.delete(_item);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Deleted item: ${_item.title}'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () => store.recreate(_item)
                      ),
                    ));
                  },
                ),
                const Spacer(),
                OutlinedButton(child: const Text('Cancel'), onPressed: () => Navigator.pop(ctx)),
                const SizedBox(width: 32),
                FilledButton(child: const Text('Update'), onPressed: () {
                  Provider.of<Store>(ctx, listen: false).update(widget.item, _item);
                  Navigator.pop(ctx);
                }),
              ]),
            ]
          ),
        ),
      ),
    );
  }
}
