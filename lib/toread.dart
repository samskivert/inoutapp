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
    context, item, item.title, item.author, iconFor(item.type), item.abandoned, false,
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

class EditReadItem extends EditConsume<Read> {
  const EditReadItem ({super.key, required super.item});
  @override EditReadItemState createState () => EditReadItemState();
}

class EditReadItemState extends EditConsumeState<EditReadItem, Read, ReadType> {
  @override String main (Read item) => item.title;
  @override Read setMain (Read item, String main) => item.rebuild((b) => b..title = main);
  @override bool hasAux () => true;
  @override String auxName () => 'Author';
  @override String? aux (Read item) => item.author;
  @override Read setAux (Read item, String? aux) => item.rebuild((b) => b..title = aux);
  @override List<DropdownMenuEntry<ReadType>> typeEntries () => ReadType.values.map(
    (rr) => DropdownMenuEntry<ReadType>(value: rr, label: rr.label)).toList();
  @override bool hasType () => true;
  @override ReadType type (Read item) => item.type;
  @override Read setType (Read item, ReadType type) => item.rebuild((b) => b..type = type);
  @override Read setTags (Read item, List<String> tags) =>
    item.rebuild((b) => tags.isEmpty ? b.tags.clear() : b.tags.replace(tags));
  @override Read setLink (Read item, String? link) => item.rebuild((b) => b..link = link);
  @override Read setRecommender (Read item, String? recommender) =>
    item.rebuild((b) => b..recommender = recommender);
  @override Read setRating (Read item, Rating rating) => item.rebuild((b) => b..rating = rating);
  @override bool hasAbandoned () => true;
  @override bool abandoned (Read item) => item.abandoned;
  @override Read setAbandoned (Read item, bool abandoned) =>
    item.rebuild((b) => b..abandoned = abandoned);
  @override Read setStarted (Read item, String? started) =>
    item.rebuild((b) => b..started = started);
  @override Read setCompleted (Read item, String? completed) =>
    item.rebuild((b) => b..completed = completed);
  @override void update (Store store, Read orig, Read updated) => store.updateRead(orig, updated);
  @override void delete (Store store, Read item) => store.deleteRead(item);
  @override void recreate (Store store, Read item) => store.recreateRead(item);
}
