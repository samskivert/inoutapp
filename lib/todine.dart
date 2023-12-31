import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model.dart';
import 'store.dart';
import 'ui.dart';

class ToDinePage extends StatefulWidget {
  const ToDinePage({super.key});
  @override ToDinePageState createState () => ToDinePageState();
}

class ToDinePageState extends ItemPageState<ToDinePage, Dine> {
  @override ItemType itemType () => ItemType.dine;
  @override Stream<List<Entry<Dine>>> currentItems (Store store) => store.dineItems(5).map(
    (abc) => entries3('Dining', abc.$1, 'To Eat', abc.$2, 'Recently Eaten', abc.$3));
  @override Stream<List<Entry<Dine>>> historyItems (Store store, String filter) =>
    store.dineHistory().map((iis) => annuate(iis, filter));
  @override String createPlaceholder () => 'Name - Location/Cuisine';
  @override String createItem (Store store, String text) => store.create(ItemType.dine, text);
  @override Widget mkItem (Dine item) => DineItem(item: item);
}

void updateDine (BuildContext ctx, Dine item, dynamic Function(DineBuilder) updates) {
  Provider.of<Store>(ctx, listen: false).updateDine(item, item.rebuild(updates));
}

class DineItem extends StatelessWidget {
  DineItem ({required this.item}) : super(key: Key(item.id!));
  final Dine item;

  @override Widget build (BuildContext context) => itemRow(
    context, item, item.name, item.location, iconFor(item.type), false, false,
    () => updateDine(context, item, (b) => b..started = dateFmt.format(DateTime.now())),
    () => updateDine(context, item, (b) => b..completed = dateFmt.format(DateTime.now())),
    () => updateDine(context, item, (b) => b..completed = null),
    (_) => EditDineItem(item: item));
}

IconData iconFor (DineType type) {
  switch (type) {
  case DineType.restaurant: return Icons.food_bank_outlined;
  case DineType.recipe: return Icons.source_outlined;
  case DineType.other: return Icons.feed_outlined;
  }
}

class EditDineItem extends EditItem<Dine> {
  const EditDineItem ({super.key, required super.item});
  @override EditDineItemState createState () => EditDineItemState();
}

class EditDineItemState extends EditItemState<EditDineItem, Dine, DineType> {
  @override String mainName () => 'Name';
  @override String main (Dine item) => item.name;
  @override Dine setMain (Dine item, String main) => item.rebuild((b) => b..name = main);
  @override bool hasAux () => true;
  @override String auxName () => 'Location/Cuisine';
  @override String? aux (Dine item) => item.location;
  @override Dine setAux (Dine item, String? aux) => item.rebuild((b) => b..location = aux);
  @override List<DropdownMenuEntry<DineType>> typeEntries () => DineType.values.map(
    (rr) => DropdownMenuEntry<DineType>(value: rr, label: rr.label)).toList();
  @override bool hasType () => true;
  @override DineType type (Dine item) => item.type;
  @override Dine setType (Dine item, DineType type) => item.rebuild((b) => b..type = type);
  @override Dine setTags (Dine item, List<String> tags) =>
    item.rebuild((b) => tags.isEmpty ? b.tags.clear() : b.tags.replace(tags));
  @override Dine setLink (Dine item, String? link) => item.rebuild((b) => b..link = link);
  @override Dine setRecommender (Dine item, String? recommender) =>
    item.rebuild((b) => b..recommender = recommender);
  @override Dine setRating (Dine item, Rating rating) => item.rebuild((b) => b..rating = rating);
  @override Dine setStarted (Dine item, String? started) =>
    item.rebuild((b) => b..started = started);
  @override Dine setCompleted (Dine item, String? completed) =>
    item.rebuild((b) => b..completed = completed);
  @override void update (Store store, Dine orig, Dine updated) => store.updateDine(orig, updated);
  @override void delete (Store store, Dine item) => store.deleteDine(item);
  @override void recreate (Store store, Dine item) => store.recreateDine(item);
}
