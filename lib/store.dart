import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:built_value/serializer.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model.dart';

class Store {
  final User user;

  Store(this.user);

  // Generic

  String create (ItemType type, String text) {
    var didx = text.indexOf('-');
    var (main, aux) = didx > 0 ?
      (text.substring(0, didx).trim(), text.substring(didx+1).trim()) :
      (text.trim(), null);
    switch (type) {
    case ItemType.read: createRead(main, aux);
    case ItemType.watch: createWatch(main, aux);
    case ItemType.hear: createHear(main, aux);
    case ItemType.play: createPlay(main, aux);
    case ItemType.dine: createDine(main, aux);
    case ItemType.build: createBuild(main);
    default: throw Exception('Unhandled creation type: $type');
    }
    return main;
  }

  // Read

  Stream<(List<Read> active, List<Read> unread, List<Read> recent)> readItems (int recent) =>
    _items('read', _decodeRead, recent);
  Stream<Iterable<Read>> readHistory () =>
    _collection('read').where('completed', isNull: false).snapshots().map(_decodeRead);

  Future<void> createRead (String title, String? author) => recreateRead(Read(
    (b) => b..title = title
            ..author = author
            ..created = Timestamp.now()));
  Future<void> recreateRead (Read item) => _recreate('read', Read.serializer, item);
  Future<void> updateRead (Read orig, Read updated) =>
    _collection('read').doc(orig.id).update(_itemDelta(Read.serializer, orig, updated));
  Future<void> deleteRead (Read item) => _collection('read').doc(item.id).delete();

  Iterable<Read> _decodeRead (QuerySnapshot<Map<String, dynamic>> snap) {
    return snap.docs.map((dd) {
      var item = serializers.deserializeWith<Read>(Read.serializer, dd.data());
      return item?.rebuild((bb) => bb..id = dd.id);
    }).whereType<Read>();
  }

  // Watch

  Stream<(List<Watch> active, List<Watch> unwatch, List<Watch> recent)> watchItems (int recent) =>
    _items('watch', _decodeWatch, recent);
  Stream<Iterable<Watch>> watchHistory () =>
    _collection('watch').where('completed', isNull: false).snapshots().map(_decodeWatch);

  Future<void> createWatch (String title, String? director) => recreateWatch(Watch(
    (b) => b..title = title
            ..director = director
            ..created = Timestamp.now()));
  Future<void> recreateWatch (Watch item) => _recreate('watch', Watch.serializer, item);
  Future<void> updateWatch (Watch orig, Watch updated) =>
    _collection('watch').doc(orig.id).update(_itemDelta(Watch.serializer, orig, updated));
  Future<void> deleteWatch (Watch item) => _collection('watch').doc(item.id).delete();

  Iterable<Watch> _decodeWatch (QuerySnapshot<Map<String, dynamic>> snap) {
    return snap.docs.map((dd) {
      var item = serializers.deserializeWith<Watch>(Watch.serializer, dd.data());
      return item?.rebuild((bb) => bb..id = dd.id);
    }).whereType<Watch>();
  }

  // Hear

  Stream<(List<Hear> active, List<Hear> unhear, List<Hear> recent)> hearItems (int recent) =>
    _items('hear', _decodeHear, recent);
  Stream<Iterable<Hear>> hearHistory () =>
    _collection('hear').where('completed', isNull: false).snapshots().map(_decodeHear);

  Future<void> createHear (String title, String? artist) => recreateHear(Hear(
    (b) => b..title = title
            ..artist = artist
            ..created = Timestamp.now()));
  Future<void> recreateHear (Hear item) => _recreate('hear', Hear.serializer, item);
  Future<void> updateHear (Hear orig, Hear updated) =>
    _collection('hear').doc(orig.id).update(_itemDelta(Hear.serializer, orig, updated));
  Future<void> deleteHear (Hear item) => _collection('hear').doc(item.id).delete();

  Iterable<Hear> _decodeHear (QuerySnapshot<Map<String, dynamic>> snap) {
    return snap.docs.map((dd) {
      var item = serializers.deserializeWith<Hear>(Hear.serializer, dd.data());
      return item?.rebuild((bb) => bb..id = dd.id);
    }).whereType<Hear>();
  }

  // Play

  Stream<(List<Play> active, List<Play> unplay, List<Play> recent)> playItems (int recent) =>
    _items('play', _decodePlay, recent);
  Stream<Iterable<Play>> playHistory () =>
    _collection('play').where('completed', isNull: false).snapshots().map(_decodePlay);

  Future<void> createPlay (String title, String? platform) => recreatePlay(Play(
    (b) => b..title = title
            ..platform = (platform ?? 'pc').toLowerCase()
            ..created = Timestamp.now()));
  Future<void> recreatePlay (Play item) => _recreate('play', Play.serializer, item);
  Future<void> updatePlay (Play orig, Play updated) =>
    _collection('play').doc(orig.id).update(_itemDelta(Play.serializer, orig, updated));
  Future<void> deletePlay (Play item) => _collection('play').doc(item.id).delete();

  Iterable<Play> _decodePlay (QuerySnapshot<Map<String, dynamic>> snap) {
    return snap.docs.map((dd) {
      var item = serializers.deserializeWith<Play>(Play.serializer, dd.data());
      return item?.rebuild((bb) => bb..id = dd.id);
    }).whereType<Play>();
  }

  // Dine

  Stream<(List<Dine> active, List<Dine> undine, List<Dine> recent)> dineItems (int recent) =>
    _items('dine', _decodeDine, recent);
  Stream<Iterable<Dine>> dineHistory () =>
    _collection('dine').where('completed', isNull: false).snapshots().map(_decodeDine);

  Future<void> createDine (String name, String? location) => recreateDine(Dine(
    (b) => b..name = name
            ..location = location ?? ''
            ..created = Timestamp.now()));
  Future<void> recreateDine (Dine item) => _recreate('dine', Dine.serializer, item);
  Future<void> updateDine (Dine orig, Dine updated) =>
    _collection('dine').doc(orig.id).update(_itemDelta(Dine.serializer, orig, updated));
  Future<void> deleteDine (Dine item) => _collection('dine').doc(item.id).delete();

  Iterable<Dine> _decodeDine (QuerySnapshot<Map<String, dynamic>> snap) {
    return snap.docs.map((dd) {
      var item = serializers.deserializeWith<Dine>(Dine.serializer, dd.data());
      return item?.rebuild((bb) => bb..id = dd.id);
    }).whereType<Dine>();
  }

  // Build

  Stream<(List<Build> active, List<Build> unbuild, List<Build> recent)> buildItems (int recent) =>
    _items('build', _decodeBuild, recent);
  Stream<Iterable<Build>> buildHistory () =>
    _collection('build').where('completed', isNull: false).snapshots().map(_decodeBuild);

  Future<void> createBuild (String text) => recreateBuild(Build(
    (b) => b..text = text
            ..created = Timestamp.now()));
  Future<void> recreateBuild (Build item) => _recreate('build', Build.serializer, item);
  Future<void> updateBuild (Build orig, Build updated) =>
    _collection('build').doc(orig.id).update(_itemDelta(Build.serializer, orig, updated));
  Future<void> deleteBuild (Build item) => _collection('build').doc(item.id).delete();

  Iterable<Build> _decodeBuild (QuerySnapshot<Map<String, dynamic>> snap) {
    return snap.docs.map((dd) {
      var item = serializers.deserializeWith<Build>(Build.serializer, dd.data());
      return item?.rebuild((bb) => bb..id = dd.id);
    }).whereType<Build>();
  }

  // Generic bits

  CollectionReference<Map<String, dynamic>> _collection (String name) {
    return FirebaseFirestore.instance.collection('users').doc(user.uid).collection(name);
  }

  Stream<(List<I> active, List<I> pending, List<I> recent)> _items<I extends Item> (
    String collection, Iterable<I> Function(QuerySnapshot<Map<String, dynamic>> snap) decode,
    int recentCount
  ) {
    var incomplete = _collection(collection).where('completed', isNull: true).snapshots().map((snap) {
      var items = decode(snap);
      var active = items.where((ii) => ii.started != null).toList();
      active.sort((a, b) => a.started!.compareTo(b.started!));
      var pending = items.where((ii) => ii.started == null).toList();
      pending.sort((a, b) => b.created.compareTo(a.created));
      return (active, pending);
    });
    var recents = _collection(collection).where('completed', isGreaterThan: '1900-01-01').
      orderBy('completed', descending: true).limit(recentCount).snapshots().map((snap) {
        var rr = decode(snap);
        var recent = rr.toList();
        recent.sort((a, b) => b.completed!.compareTo(a.completed!));
        return recent;
      });
    return Rx.combineLatest2(incomplete, recents, (aa, rr) => (aa.$1, aa.$2, rr));
  }

  Future<void> _recreate<I extends Item> (String collection, Serializer<I> szer, I item) {
    var data = serializers.serializeWith<I>(szer, item) as Map<String, dynamic>;
    if (!data.containsKey('completed')) data['completed'] = null; // needed for index shenanigans
    return _collection(collection).doc().set(data);
  }

  Map<String, dynamic> _itemDelta<I> (Serializer<I> szer, I orig, I updated) => _delta(
    serializers.serializeWith<I>(szer, orig) as Map<String, dynamic>,
    serializers.serializeWith<I>(szer, updated) as Map<String, dynamic>);

  Map<String, dynamic> _delta (Map<String, dynamic> orig, Map<String, dynamic> updated) {
    var deepEq = const DeepCollectionEquality().equals;
    var delta = <String, dynamic>{};
    for (var key in orig.keys) {
      if (updated.containsKey(key)) continue;
      // special hackery because 'completed' fields need to be null, not missing
      if (key == 'completed') { delta[key] = null; }
      else { delta[key] = FieldValue.delete(); }
    }
    for (var entry in updated.entries) {
      var ovalue = orig[entry.key];
      var nvalue = entry.value;
      if (!deepEq(ovalue, nvalue)) delta[entry.key] = nvalue;
    }
    return delta;
  }
}
