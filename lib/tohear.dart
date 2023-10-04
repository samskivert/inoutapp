import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model.dart';
import 'store.dart';
import 'ui.dart';

class ToHearPage extends StatefulWidget {
  const ToHearPage({super.key});
  @override ToHearPageState createState () => ToHearPageState();
}

class ToHearPageState extends ItemPageState<ToHearPage, Hear> {
  @override ItemType itemType () => ItemType.hear;
  @override Stream<List<Entry<Hear>>> currentItems (Store store) => store.hearItems(5).map(
    (abc) => entries3('Listening', abc.$1, 'To Listen', abc.$2, 'Recently Heard', abc.$3));
  @override Stream<List<Entry<Hear>>> historyItems (Store store, String filter) =>
    store.hearHistory().map((iis) => annuate(iis, filter));
  @override String createPlaceholder () => 'Title - Artist/Host';
  @override String createItem (Store store, String text) => store.create(ItemType.hear, text);
  @override Widget mkItem (Hear item) => HearItem(item: item);
}

void updateHear (BuildContext ctx, Hear item, dynamic Function(HearBuilder) updates) {
  Provider.of<Store>(ctx, listen: false).updateHear(item, item.rebuild(updates));
}

class HearItem extends StatelessWidget {
  HearItem ({required this.item}) : super(key: Key(item.id!));
  final Hear item;

  @override Widget build (BuildContext context) => consumeRow(
    context, item, item.title, item.artist, iconFor(item.type), item.abandoned,
    () => updateHear(context, item, (b) => b..started = dateFmt.format(DateTime.now())),
    () => updateHear(context, item, (b) => b..completed = dateFmt.format(DateTime.now())),
    () => updateHear(context, item, (b) => b..completed = null),
    (_) => EditHearItem(item: item));
}

IconData iconFor (HearType type) {
  switch (type) {
  case HearType.song: return Icons.audiotrack;
  case HearType.album: return Icons.album;
  case HearType.podcast: return Icons.podcasts;
  case HearType.other: return Icons.feed_outlined;
  }
}

class EditHearItem extends StatefulWidget {
  const EditHearItem ({super.key, required this.item});
  final Hear item;
  @override EditHearItemState createState () => EditHearItemState(item);
}

final typeEntries = HearType.values.map(
  (rr) => DropdownMenuEntry<HearType>(value: rr, label: rr.label)).toList();

class EditHearItemState extends State<EditHearItem> {
  final _formKey = GlobalKey<FormState>();
  Hear _item;

  EditHearItemState (Hear item) : _item = item;

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
            textField(_item.artist ?? '', 'Artist/Host', (text) {
              _item = _item.rebuild((b) => b..artist = beNull(text));
            }),
            const SizedBox(height: 24),
            Row(children: <Widget>[
              Expanded(child: DropdownMenu<HearType>(
                initialSelection: _item.type,
                label: const Text('Type'),
                dropdownMenuEntries: typeEntries,
                onSelected: (HearType? type) {
                  setState(() {
                    if (type is HearType) _item = _item.rebuild((b) => b..type = type);
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
                  store.deleteHear(_item);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Deleted item: ${_item.title}'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () => store.recreateHear(_item)
                    ),
                  ));
                },
              ),
              const Spacer(),
              OutlinedButton(child: const Text('Cancel'), onPressed: () => Navigator.pop(ctx)),
              const SizedBox(width: 32),
              FilledButton(child: const Text('Update'), onPressed: () {
                Provider.of<Store>(ctx, listen: false).updateHear(widget.item, _item);
                Navigator.pop(ctx);
              }),
            ]),
          ]
        ),
      ),
    ),
  );
}
