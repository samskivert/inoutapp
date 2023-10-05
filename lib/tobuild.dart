import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model.dart';
import 'store.dart';
import 'ui.dart';

class ToBuildPage extends StatefulWidget {
  const ToBuildPage({super.key});
  @override ToBuildPageState createState () => ToBuildPageState();
}

class ToBuildPageState extends ItemPageState<ToBuildPage, Build> {
  @override ItemType itemType () => ItemType.build;
  @override Stream<List<Entry<Build>>> currentItems (Store store) => store.buildItems(5).map(
    (abc) => entries3('Building', abc.$1, 'To Build', abc.$2, 'Recently Built', abc.$3));
  @override Stream<List<Entry<Build>>> historyItems (Store store, String filter) =>
    store.buildHistory().map((iis) => annuate(iis, filter));
  @override String createPlaceholder () => 'Name';
  @override String createItem (Store store, String text) => store.create(ItemType.build, text);
  @override Widget mkItem (Build item) => BuildItem(item: item);
}

void updateBuild (BuildContext ctx, Build item, dynamic Function(BuildBuilder) updates) {
  Provider.of<Store>(ctx, listen: false).updateBuild(item, item.rebuild(updates));
}

class BuildItem extends StatelessWidget {
  BuildItem ({required this.item}) : super(key: Key(item.id!));
  final Build item;

  @override Widget build (BuildContext context) => itemRow(
    context, item, item.text, null, null, false, false,
    () => updateBuild(context, item, (b) => b..started = dateFmt.format(DateTime.now())),
    () => updateBuild(context, item, (b) => b..completed = dateFmt.format(DateTime.now())),
    () => updateBuild(context, item, (b) => b..completed = null),
    (_) => EditBuildItem(item: item));
}

class EditBuildItem extends EditItem<Build> {
  const EditBuildItem ({super.key, required super.item});
  @override EditBuildItemState createState () => EditBuildItemState();
}

class EditBuildItemState extends EditItemState<EditBuildItem, Build, String> {
  @override String mainName () => 'Name';
  @override String main (Build item) => item.text;
  @override Build setMain (Build item, String main) => item.rebuild((b) => b..text = main);
  @override Build setTags (Build item, List<String> tags) =>
    item.rebuild((b) => tags.isEmpty ? b.tags.clear() : b.tags.replace(tags));
  @override Build setLink (Build item, String? link) => item.rebuild((b) => b..link = link);
  @override Build setStarted (Build item, String? started) =>
    item.rebuild((b) => b..started = started);
  @override Build setCompleted (Build item, String? completed) =>
    item.rebuild((b) => b..completed = completed);
  @override void update (Store store, Build orig, Build updated) => store.updateBuild(orig, updated);
  @override void delete (Store store, Build item) => store.deleteBuild(item);
  @override void recreate (Store store, Build item) => store.recreateBuild(item);
}
