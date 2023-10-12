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

  @override Widget build (BuildContext context) => itemRow(
    context, item, item.title, item.artist, iconFor(item.type), false, false,
    () => updateHear(context, item, (b) => b..started = dateFmt.format(DateTime.now())),
    () => updateHear(context, item, (b) => b..completed = dateFmt.format(DateTime.now())),
    () => updateHear(context, item, (b) => b..completed = null),
    (_) => EditHearItem(item: item), longPressMenuItems: {
      "Apple Music": () => launchQuery('music.apple.com', 'us/search', {'term': item.searchTerms}),
      "Metacritic": () => launchQuery('www.metacritic.com', 'search/${item.searchTerms}', null),
      "Google": () => googleSearch(item.searchTerms),
    });
}

IconData iconFor (HearType type) {
  switch (type) {
  case HearType.song: return Icons.audiotrack;
  case HearType.album: return Icons.album;
  case HearType.podcast: return Icons.podcasts;
  case HearType.other: return Icons.feed_outlined;
  }
}

class EditHearItem extends EditItem<Hear> {
  const EditHearItem ({super.key, required super.item});
  @override EditHearItemState createState () => EditHearItemState();
}

class EditHearItemState extends EditItemState<EditHearItem, Hear, HearType> {
  @override String main (Hear item) => item.title;
  @override Hear setMain (Hear item, String main) => item.rebuild((b) => b..title = main);
  @override bool hasAux () => true;
  @override String auxName () => 'Artist';
  @override String? aux (Hear item) => item.artist;
  @override Hear setAux (Hear item, String? aux) => item.rebuild((b) => b..title = aux);
  @override List<DropdownMenuEntry<HearType>> typeEntries () => HearType.values.map(
    (rr) => DropdownMenuEntry<HearType>(value: rr, label: rr.label)).toList();
  @override bool hasType () => true;
  @override HearType type (Hear item) => item.type;
  @override Hear setType (Hear item, HearType type) => item.rebuild((b) => b..type = type);
  @override Hear setTags (Hear item, List<String> tags) =>
    item.rebuild((b) => tags.isEmpty ? b.tags.clear() : b.tags.replace(tags));
  @override Hear setLink (Hear item, String? link) => item.rebuild((b) => b..link = link);
  @override Hear setRecommender (Hear item, String? recommender) =>
    item.rebuild((b) => b..recommender = recommender);
  @override Hear setRating (Hear item, Rating rating) => item.rebuild((b) => b..rating = rating);
  @override Hear setStarted (Hear item, String? started) =>
    item.rebuild((b) => b..started = started);
  @override Hear setCompleted (Hear item, String? completed) =>
    item.rebuild((b) => b..completed = completed);
  @override void update (Store store, Hear orig, Hear updated) => store.updateHear(orig, updated);
  @override void delete (Store store, Hear item) => store.deleteHear(item);
  @override void recreate (Store store, Hear item) => store.recreateHear(item);
}
