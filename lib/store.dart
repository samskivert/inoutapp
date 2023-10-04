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
    default: break; // TODO
    };
    return main;
  }

  // Read

  Stream<Iterable<Read>> readActive () {
    return _collection('read').where('completed', isNull: true).snapshots().map(_decodeRead);
  }

  Stream<Iterable<Read>> readRecent (int count) {
    return _collection('read').where('completed', isGreaterThan: '1900-01-01').
      orderBy('completed', descending: true).limit(count).snapshots().map(_decodeRead);
  }

  Stream<(List<Read> active, List<Read> unread, List<Read> recent)> readItems (int recentCount) {
    var actives = readActive().map((aa) {
      var reading = aa.where((ii) => ii.started != null).toList();
      reading.sort((a, b) => a.started!.compareTo(b.started!));
      var toRead = aa.where((ii) => ii.started == null).toList();
      toRead.sort((a, b) => b.created.compareTo(a.created));
      return (reading, toRead);
    });
    var recents = readRecent(recentCount).map((rr) {
      var recents = rr.toList();
      recents.sort((a, b) => b.completed!.compareTo(a.completed!));
      return recents;
    });
    return Rx.combineLatest2(actives, recents, (aa, rr) => (aa.$1, aa.$2, rr));
  }

  Stream<Iterable<Read>> readHistory () {
    return _collection('read').where('completed', isNull: false).snapshots().map(_decodeRead);
  }

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

  Stream<Iterable<Watch>> watchActive () {
    return _collection('watch').where('completed', isNull: true).snapshots().map(_decodeWatch);
  }

  Stream<Iterable<Watch>> watchRecent (int count) {
    return _collection('watch').where('completed', isGreaterThan: '1900-01-01').
      orderBy('completed', descending: true).limit(count).snapshots().map(_decodeWatch);
  }

  Stream<(List<Watch> active, List<Watch> unwatch, List<Watch> recent)> watchItems (int recentCount) {
    var actives = watchActive().map((aa) {
      var watching = aa.where((ii) => ii.started != null).toList();
      watching.sort((a, b) => a.started!.compareTo(b.started!));
      var toWatch = aa.where((ii) => ii.started == null).toList();
      toWatch.sort((a, b) => b.created.compareTo(a.created));
      return (watching, toWatch);
    });
    var recents = watchRecent(recentCount).map((rr) {
      var recents = rr.toList();
      recents.sort((a, b) => b.completed!.compareTo(a.completed!));
      return recents;
    });
    return Rx.combineLatest2(actives, recents, (aa, rr) => (aa.$1, aa.$2, rr));
  }

  Stream<Iterable<Watch>> watchHistory () {
    return _collection('watch').where('completed', isNull: false).snapshots().map(_decodeWatch);
  }

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

  Stream<Iterable<Hear>> hearActive () {
    return _collection('hear').where('completed', isNull: true).snapshots().map(_decodeHear);
  }

  Stream<Iterable<Hear>> hearRecent (int count) {
    return _collection('hear').where('completed', isGreaterThan: '1900-01-01').
      orderBy('completed', descending: true).limit(count).snapshots().map(_decodeHear);
  }

  Stream<(List<Hear> active, List<Hear> unhear, List<Hear> recent)> hearItems (int recentCount) {
    var actives = hearActive().map((aa) {
      var hearing = aa.where((ii) => ii.started != null).toList();
      hearing.sort((a, b) => a.started!.compareTo(b.started!));
      var toHear = aa.where((ii) => ii.started == null).toList();
      toHear.sort((a, b) => b.created.compareTo(a.created));
      return (hearing, toHear);
    });
    var recents = hearRecent(recentCount).map((rr) {
      var recents = rr.toList();
      recents.sort((a, b) => b.completed!.compareTo(a.completed!));
      return recents;
    });
    return Rx.combineLatest2(actives, recents, (aa, rr) => (aa.$1, aa.$2, rr));
  }

  Stream<Iterable<Hear>> hearHistory () {
    return _collection('hear').where('completed', isNull: false).snapshots().map(_decodeHear);
  }

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

  // Misc bits

  CollectionReference<Map<String, dynamic>> _collection (String name) {
    return FirebaseFirestore.instance.collection('users').doc(user.uid).collection(name);
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
