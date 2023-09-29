import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'model.dart';

const title = 'Input/Output';

class InOutModel extends ChangeNotifier {
  ItemType _page = ItemType.read;

  ItemType get page => _page;
  set page (ItemType page) {
    _page = page;
    notifyListeners();
  }
}

AppBar appBar (BuildContext ctx) {
  IconButton listIcon (ItemType page, IconData icon, String tooltip) {
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      onPressed: () => Provider.of<InOutModel>(ctx, listen: false).page = page,
    );
  }
  return AppBar(
    title: const Text(title),
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
    ]
  );
}

Widget header (BuildContext ctx, String label) => Row(children: <Widget>[
  const Icon(Icons.menu_book),
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

List<Entry<I>> entries<I extends Item> (String header, Iterable<I> items) =>
  [HeaderEntry<I>(header), ...items.map((ii) => ItemEntry<I>(ii))];

List<Entry<I>> entries2<I extends Item> (String header1, Iterable<I> items1,
                                         String header2, Iterable<I> items2) =>
  [HeaderEntry<I>(header1), ...items1.map((ii) => ItemEntry<I>(ii)),
   HeaderEntry<I>(header2), ...items2.map((ii) => ItemEntry<I>(ii))];

List<Entry<I>> entries3<I extends Item> (String header1, Iterable<I> items1,
                                         String header2, Iterable<I> items2,
                                         String header3, Iterable<I> items3) =>
  [HeaderEntry<I>(header1), ...items1.map((ii) => ItemEntry<I>(ii)),
   HeaderEntry<I>(header2), ...items2.map((ii) => ItemEntry<I>(ii)),
   HeaderEntry<I>(header3), ...items3.map((ii) => ItemEntry<I>(ii))];

List<Entry<I>> annuate<I extends Item> (Iterable<I> items, String filter) {
  print("annuating " + filter);
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

Widget itemList<I extends Item> (Stream<List<Entry<I>>> stream, Widget Function(I) mkItem) {
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
          HeaderEntry<I> hh => header(ctx, hh.header),
          ItemEntry<I> ii => mkItem(ii.item)
        },
      );
    },
  );
}

List<Widget> itemFooter (
  BuildContext ctx, String hint, String Function(BuildContext, String) onCreate
) {
  final controller = TextEditingController();
  void createItem (String text) {
    if (text.isEmpty) return;
    var created = onCreate(ctx, text);
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
