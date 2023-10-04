import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'model.dart';
import 'store.dart';

const title = 'Input/Output';

class InOutModel extends ChangeNotifier {
  ItemType _page = ItemType.read;

  ItemType get page => _page;
  set page (ItemType page) {
    _page = page;
    notifyListeners();
  }
}

IconData iconFor (ItemType type) => switch (type) {
  ItemType.journal => Icons.calendar_month,
  ItemType.read => Icons.menu_book,
  ItemType.watch => Icons.local_movies,
  ItemType.hear => Icons.volume_up,
  ItemType.play => Icons.videogame_asset,
  ItemType.dine => Icons.local_dining,
  ItemType.build => Icons.build,
};

AppBar appBar (BuildContext ctx) {
  IconButton listIcon (ItemType page) {
    return IconButton(
      icon: Icon(iconFor(page)),
      tooltip: page.label,
      onPressed: () => Provider.of<InOutModel>(ctx, listen: false).page = page,
    );
  }
  return AppBar(
    title: const Text(title),
    actions: <Widget>[
      ...ItemType.values.map(listIcon),
      IconButton(
        icon: const Icon(Icons.logout),
        tooltip: 'Logout',
        onPressed: () async {
          // TODO: could this throw an exception?
          await FirebaseAuth.instance.signOut();
        },
      ),
    ]
  );
}

Widget header (BuildContext ctx, ItemType type, String label) => Row(children: <Widget>[
  Icon(iconFor(type)),
  const SizedBox(width: 5),
  Text(label, style: Theme.of(ctx).textTheme.titleMedium),
]);

sealed class Entry<I extends Item> {}
class HeaderEntry<I extends Item> extends Entry<I> {
  final String header;
  HeaderEntry(this.header);
}
class ItemEntry<I extends Item> extends Entry<I> {
  final I item;
  ItemEntry(this.item);
}

enum PageMode { current, history }
class PageModeModel extends ChangeNotifier {
  PageMode _mode = PageMode.current;

  PageMode get mode => _mode;
  set mode (PageMode mode) {
    _mode = mode;
    notifyListeners();
  }
}

abstract class ItemPageState<W extends StatefulWidget, I extends Item> extends State<W> {
  bool _historyMode = false;
  String _filter = '';
  final _filterCtrl = TextEditingController();

  @override void dispose () {
    _filterCtrl.dispose();
    super.dispose();
  }

  ItemType itemType ();
  Stream<List<Entry<I>>> currentItems (Store store);
  Stream<List<Entry<I>>> historyItems (Store store, String filter);
  String createPlaceholder ();
  String createItem (Store store, String text);
  Widget mkItem (I item);

  @override Widget build (BuildContext context) {
    var store = Provider.of<Store>(context);
    var items = _historyMode ? historyItems(store, _filter) : currentItems(store);
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
        ...itemFooter(context, createPlaceholder(), createItem),
      ]);
    return ChangeNotifierProvider(
      create: (ctx) => PageModeModel(),
      child: Scaffold(
        appBar: appBar(context),
        body: Center(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: itemList<I>(items, itemType(), mkItem)
        )),
        bottomNavigationBar: BottomAppBar(height: 60, child: footer),
      )
    );
  }
}

List<Entry<I>> entries<I extends Item> (String header, Iterable<I> items) =>
  [HeaderEntry<I>(header), ...items.map((ii) => ItemEntry<I>(ii))];

List<Entry<I>> entries2<I extends Item> (String header1, Iterable<I> items1,
                                         String header2, Iterable<I> items2) =>
  [if (items1.isNotEmpty) HeaderEntry<I>(header1), ...items1.map((ii) => ItemEntry<I>(ii)),
   if (items2.isNotEmpty) HeaderEntry<I>(header2), ...items2.map((ii) => ItemEntry<I>(ii))];

List<Entry<I>> entries3<I extends Item> (String header1, Iterable<I> items1,
                                         String header2, Iterable<I> items2,
                                         String header3, Iterable<I> items3) =>
  [if (items1.isNotEmpty) HeaderEntry<I>(header1), ...items1.map((ii) => ItemEntry<I>(ii)),
   if (items2.isNotEmpty) HeaderEntry<I>(header2), ...items2.map((ii) => ItemEntry<I>(ii)),
   if (items3.isNotEmpty) HeaderEntry<I>(header3), ...items3.map((ii) => ItemEntry<I>(ii))];

List<Entry<I>> annuate<I extends Item> (Iterable<I> items, String filter) {
  var f = makeFilter(filter);
  var sorted = items.where((ii) => ii.filter(f)).toList();
  sorted.sort((aa, bb) => bb.completed!.compareTo(aa.completed!));
  var annuated = sorted.map<Entry<I>>((ii) => ItemEntry<I>(ii)).toList();
  var year = '';
  for (var ii = 0; ii < annuated.length; ii += 1) {
    var itemYear = (annuated[ii] as ItemEntry<I>).item.completed!.substring(0, 4);
    if (year != itemYear) {
      annuated.insert(ii, HeaderEntry<I>(itemYear));
      ii += 1;
      year = itemYear;
    }
  }
  return annuated;
}

Widget itemList<I extends Item> (
  Stream<List<Entry<I>>> stream, ItemType type, Widget Function(I) mkItem
) {
  return StreamBuilder<List<Entry<I>>>(
    stream: stream,
    builder: (BuildContext ctx, AsyncSnapshot<List<Entry<I>>> items) {
      if (items.hasError) items.requireData;
      if (!items.hasData) return const Text('Loading...'); // TODO: spinner
      var entries = items.requireData;
      return ListView.separated(
        separatorBuilder: (BuildContext ctx, int index) => const Divider(),
        itemCount: entries.length,
        itemBuilder: (BuildContext ctx, int index) => switch (entries[index]) {
          HeaderEntry<I> hh => header(ctx, type, hh.header),
          ItemEntry<I> ii => mkItem(ii.item)
        },
      );
    },
  );
}

List<Widget> itemFooter (
  BuildContext ctx, String hint, String Function(Store, String) onCreate
) {
  final controller = TextEditingController();
  void createItem (String text) {
    if (text.isEmpty) return;
    var created = onCreate(Provider.of<Store>(ctx, listen: false), text);
    controller.text = '';
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Created item: $created')));
  }
  return <Widget>[
    Expanded(child: TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hint),
      onFieldSubmitted: createItem,
    )),
    const SizedBox(width: 12),
    IconButton(icon: const Icon(Icons.add), onPressed: () => createItem(controller.text)),
  ];
}

Widget consumeRow (
  BuildContext ctx, Consume item, String title, String? subtitle, IconData? icon, bool abandoned,
  void Function() onStart, void Function() onComplete, void Function() onUncomplete,
  Widget Function(BuildContext) onEdit
) {
  var (actionTip, actionIcon, action) =
    item.completed != null ? ('Revert to uncompleted', Icons.check_box, onUncomplete) :
    item.startable() ? ('Mark as started', Icons.play_arrow, onStart) :
    ('Mark as completed', Icons.check_box_outline_blank, onComplete);
  var emoji = abandoned ? '😴' : item.rating != Rating.none ? item.rating.emoji : null;
  var items = <Widget>[
    IconButton(icon: Icon(actionIcon), tooltip: actionTip, onPressed: action),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title),
        Text(subtitle ?? '', style: Theme.of(ctx).textTheme.bodySmall?.merge(
          TextStyle(color: Colors.grey[600]))),
      ]),
    const Spacer(),
    if (emoji != null) Text(emoji, style: Theme.of(ctx).textTheme.titleLarge),
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
      onPressed: () => Navigator.push(ctx, MaterialPageRoute(builder: onEdit)),
    ),
    if (icon != null) Icon(icon, color: Colors.grey[600]),
  ];
  return Row(children: items);
}

final ratingEntries = Rating.values.map(
  (rr) => DropdownMenuEntry<Rating>(value: rr, label: rr.emoji + rr.label)).toList();

var dateFmt = DateFormat("yyyy-MM-dd");
var createdFmt = DateFormat.yMMMd().add_jm();

String? nonNull (String? txt, String msg) { return txt == null || txt.isEmpty ? msg : null; }
String? beNull (String txt) => txt.isEmpty ? null : txt;

TextFormField textField (String value, String label, Function(String) onChanged) {
  return TextFormField(
    initialValue: value,
    decoration: InputDecoration(labelText: label),
    onChanged: onChanged,
  );
}

TextFormField textField2 (String value, String label, Function(String) onChanged) {
  return TextFormField(
    initialValue: value,
    decoration: InputDecoration(hintText: label),
    onChanged: onChanged,
  );
}

Widget textFieldDate (BuildContext ctx, String? value, String label, Function(String?) onChanged) {
  var controller = TextEditingController();
  controller.text = value ?? '';
  var date = value is String && value.isNotEmpty ? dateFmt.parse(value) : DateTime.now();
  return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: <Widget>[
      Expanded(child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        readOnly: true,
        onTap: () async {
          var pickedDate = await showDatePicker(
            context: ctx, initialDate: date,
            firstDate: DateTime(1990),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          );
          if (pickedDate != null) {
            onChanged(dateFmt.format(pickedDate));
          }
        },
      )),
      if (controller.text.isNotEmpty) IconButton(
        icon: const Icon(Icons.clear),
        tooltip: 'Clear date',
        onPressed: () => onChanged(null)
      )
    ]);
}

abstract class EditConsume<I extends Consume> extends StatefulWidget {
  const EditConsume ({super.key, required this.item});
  final I item;
}

abstract class EditConsumeState<
  W extends EditConsume<I>, I extends Consume, T extends Enum
> extends State<W> {
  final _formKey = GlobalKey<FormState>();
  late I _item;

  @override initState () {
    super.initState();
    _item = widget.item;
  }

  String main (I item);
  I setMain (I item, String main);
  String? aux (I item);
  I setAux (I item, String? aux);
  List<DropdownMenuEntry<T>> typeEntries ();
  T type (I item);
  I setType (I item, T type);
  I setTags (I item, List<String> tags);
  I setLink (I item, String? link);
  I setRecommender (I item, String? recommender);
  I setRating (I item, Rating rating);
  I setStarted (I item, String? started);
  I setCompleted (I item, String? completed);
  void update (Store store, I orig, I updated);
  void delete (Store store, I item);
  void recreate (Store store, I item);

  bool hasAbandoned () => false;
  bool abandoned (I item) => false;
  I setAbandoned (I item, bool abandoned) => item;

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
            textField(main(_item), 'Title', (text) {
              _item = setMain(_item, text);
            }),
            const SizedBox(height: 12),
            textField(aux(_item) ?? '', 'Director', (text) {
              _item = setAux(_item, beNull(text));
            }),
            const SizedBox(height: 24),
            Row(children: <Widget>[
              Expanded(child: DropdownMenu<T>(
                initialSelection: type(_item),
                label: const Text('Type'),
                dropdownMenuEntries: typeEntries(),
                onSelected: (T? type) {
                  setState(() {
                    if (type is T) _item = setType(_item, type);
                  });
                },
              )),
              const SizedBox(width: 32),
              Expanded(child: textField2(_item.tags.join(' '), 'Tags', (text) => setState(() {
                _item = setTags(_item, text.isEmpty ? <String>[] : text.split(' '));
              }))),
            ]),
            Row(children: <Widget>[
              Expanded(child: textField2(_item.link ?? '', 'Link', (text) => setState(() {
                _item = setLink(_item, beNull(text));
              }))),
              const SizedBox(width: 32),
              Expanded(child: textField2(_item.recommender ?? '', 'Recommender', (text) => setState(() {
                _item = setRecommender(_item, beNull(text));
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
                    if (rating is Rating) _item = setRating(_item, rating);
                  });
                },
              )),
              if (hasAbandoned()) Expanded(child: CheckboxListTile(
                title: const Text('Abandoned'),
                value: abandoned(_item),
                onChanged: (selected) {
                  setState(() {
                    if (selected is bool) _item = setAbandoned(_item, selected);
                  });
                },
              )),
            ]),
            const SizedBox(height: 12),
            Row(children: <Widget>[
              Expanded(child: textFieldDate(ctx, _item.started ?? '', 'Started', (date) => setState(() {
                _item = setStarted(_item, date);
              }))),
              const SizedBox(width: 32),
              Expanded(child: textFieldDate(ctx, _item.completed ?? '', 'Completed', (date) => setState(() {
                _item = setCompleted(_item, date);
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
                  delete(store, _item);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Deleted item: ${main(_item)}'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () => recreate(store, _item)
                    ),
                  ));
                },
              ),
              const Spacer(),
              OutlinedButton(child: const Text('Cancel'), onPressed: () => Navigator.pop(ctx)),
              const SizedBox(width: 32),
              FilledButton(child: const Text('Update'), onPressed: () {
                update(Provider.of<Store>(ctx, listen: false), widget.item, _item);
                Navigator.pop(ctx);
              }),
            ]),
          ]
        ),
      ),
    ),
  );
}
