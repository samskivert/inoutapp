import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model.dart';
import 'store.dart';
import 'ui.dart';

const playTypeLabels = {
  'pc': 'PC',
  'mobile': 'Mobile',
  'table': 'Table',
  'switch': 'Switch',
  'ps5': 'PS5',
  'ps4': 'PS4',
  'xbox': 'XBOX',
  '3ds': '3DS',
  'vita': 'PS Vita',
  'wiiu': 'Wii U',
  'ps3': 'PS3',
  'wii': 'Wii',
  'ps2': 'PS2',
  'dcast': 'Dreamcast',
  'cube': 'GameCube',
  'gba': 'GBA',
  'gbc': 'GBC',
  'n64': 'N64',
  'ps1': 'PS1',
};

class ToPlayPage extends StatefulWidget {
  const ToPlayPage({super.key});
  @override ToPlayPageState createState () => ToPlayPageState();
}

class ToPlayPageState extends ItemPageState<ToPlayPage, Play> {
  @override ItemType itemType () => ItemType.play;
  @override Stream<List<Entry<Play>>> currentItems (Store store) => store.playItems(5).map(
    (abc) => entries3('Playing', abc.$1, 'To Play', abc.$2, 'Recently Played', abc.$3));
  @override Stream<List<Entry<Play>>> historyItems (Store store, String filter) =>
    store.playHistory().map((iis) => annuate(iis, filter));
  @override String createPlaceholder () => 'Title';
  @override String createItem (Store store, String text) => store.create(ItemType.play, text);
  @override Widget mkItem (Play item) => PlayItem(item: item);
}

void updatePlay (BuildContext ctx, Play item, dynamic Function(PlayBuilder) updates) {
  Provider.of<Store>(ctx, listen: false).updatePlay(item, item.rebuild(updates));
}

class PlayItem extends StatelessWidget {
  PlayItem ({required this.item}) : super(key: Key(item.id!));
  final Play item;

  @override Widget build (BuildContext context) => itemRow(
    context, item, item.title, playTypeLabels[item.platform], null, false, item.credits,
    () => updatePlay(context, item, (b) => b..started = dateFmt.format(DateTime.now())),
    () => updatePlay(context, item, (b) => b..completed = dateFmt.format(DateTime.now())),
    () => updatePlay(context, item, (b) => b..completed = null),
    (_) => EditPlayItem(item: item), longPressMenuItems: {
      "Metacritic": () => launchQuery('www.metacritic.com', 'search/${item.searchTerms}', null),
      "Google": () => googleSearch(item.searchTerms),
    });
}

class EditPlayItem extends EditItem<Play> {
  const EditPlayItem ({super.key, required super.item});
  @override EditPlayItemState createState () => EditPlayItemState();
}

final playTypeEntries = playTypeLabels.entries.map(
  (ee) => DropdownMenuEntry(value: ee.key, label: ee.value)).toList();

class EditPlayItemState extends EditItemState<EditPlayItem, Play, String> {
  @override String main (Play item) => item.title;
  @override Play setMain (Play item, String main) => item.rebuild((b) => b..title = main);
  @override List<DropdownMenuEntry<String>> typeEntries () => playTypeEntries;
  @override bool hasType () => true;
  @override String type (Play item) => item.platform;
  @override Play setType (Play item, String type) => item.rebuild((b) => b..platform = type);
  @override Play setTags (Play item, List<String> tags) =>
    item.rebuild((b) => tags.isEmpty ? b.tags.clear() : b.tags.replace(tags));
  @override Play setLink (Play item, String? link) => item.rebuild((b) => b..link = link);
  @override Play setRecommender (Play item, String? recommender) =>
    item.rebuild((b) => b..recommender = recommender);
  @override Play setRating (Play item, Rating rating) => item.rebuild((b) => b..rating = rating);
  @override bool hasFinished () => true;
  @override bool finished (Play item) => item.credits;
  @override Play setFinished (Play item, bool finished) =>
    item.rebuild((b) => b..credits = finished);
  @override Play setStarted (Play item, String? started) =>
    item.rebuild((b) => b..started = started);
  @override Play setCompleted (Play item, String? completed) =>
    item.rebuild((b) => b..completed = completed);
  @override void update (Store store, Play orig, Play updated) => store.updatePlay(orig, updated);
  @override void delete (Store store, Play item) => store.deletePlay(item);
  @override void recreate (Store store, Play item) => store.recreatePlay(item);
}
