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

  @override Widget build (BuildContext context) => itemRow(
    context, item, item.title, item.director, iconFor(item.type), item.abandoned, false,
    () => updateWatch(context, item, (b) => b..started = dateFmt.format(DateTime.now())),
    () => updateWatch(context, item, (b) => b..completed = dateFmt.format(DateTime.now())),
    () => updateWatch(context, item, (b) => b..completed = null),
    (_) => EditWatchItem(item: item), longPressMenuItems: {
      "Metacritic": () => launchQuery('www.metacritic.com', 'search/${item.searchTerms}', null),
      "IMDB": () => launchQuery('www.imdb.com', 'find', {'q': item.searchTerms}),
      "Google": () => googleSearch(item.searchTerms),
    });
}

IconData iconFor (WatchType type) {
  switch (type) {
  case WatchType.show: return Icons.live_tv;
  case WatchType.film: return Icons.local_movies;
  case WatchType.video: return Icons.ondemand_video;
  case WatchType.other: return Icons.feed_outlined;
  }
}

class EditWatchItem extends EditItem<Watch> {
  const EditWatchItem ({super.key, required super.item});
  @override EditWatchItemState createState () => EditWatchItemState();
}

class EditWatchItemState extends EditItemState<EditWatchItem, Watch, WatchType> {
  @override String main (Watch item) => item.title;
  @override Watch setMain (Watch item, String main) => item.rebuild((b) => b..title = main);
  @override bool hasAux () => true;
  @override String auxName () => 'Director';
  @override String? aux (Watch item) => item.director;
  @override Watch setAux (Watch item, String? aux) => item.rebuild((b) => b..title = aux);
  @override List<DropdownMenuEntry<WatchType>> typeEntries () => WatchType.values.map(
    (rr) => DropdownMenuEntry<WatchType>(value: rr, label: rr.label)).toList();
  @override bool hasType () => true;
  @override WatchType type (Watch item) => item.type;
  @override Watch setType (Watch item, WatchType type) => item.rebuild((b) => b..type = type);
  @override Watch setTags (Watch item, List<String> tags) =>
    item.rebuild((b) => tags.isEmpty ? b.tags.clear() : b.tags.replace(tags));
  @override Watch setLink (Watch item, String? link) => item.rebuild((b) => b..link = link);
  @override Watch setRecommender (Watch item, String? recommender) =>
    item.rebuild((b) => b..recommender = recommender);
  @override Watch setRating (Watch item, Rating rating) => item.rebuild((b) => b..rating = rating);
  @override bool hasAbandoned () => true;
  @override bool abandoned (Watch item) => item.abandoned;
  @override Watch setAbandoned (Watch item, bool abandoned) =>
    item.rebuild((b) => b..abandoned = abandoned);
  @override Watch setStarted (Watch item, String? started) =>
    item.rebuild((b) => b..started = started);
  @override Watch setCompleted (Watch item, String? completed) =>
    item.rebuild((b) => b..completed = completed);
  @override void update (Store store, Watch orig, Watch updated) => store.updateWatch(orig, updated);
  @override void delete (Store store, Watch item) => store.deleteWatch(item);
  @override void recreate (Store store, Watch item) => store.recreateWatch(item);
}
