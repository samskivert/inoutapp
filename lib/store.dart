import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:built_value/serializer.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model.dart';

class Store {
  final User user;

  Store(this.user);

  Stream<Iterable<Read>> readActive () {
    return _collection('read').where('completed', isNull: true).snapshots().map(_decode);
  }

  Stream<Iterable<Read>> readRecent (int count) {
    return _collection('read').where('completed', isGreaterThan: '1900-01-01').
      orderBy('completed', descending: true).limit(count).snapshots().map(_decode);
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

  Future<void> update (Read orig, Read updated) =>
    _collection('read').doc(orig.id).update(_itemDelta(Read.serializer, orig, updated));

  CollectionReference<Map<String, dynamic>> _collection (String name) {
    return FirebaseFirestore.instance.collection('users').doc(user.uid).collection(name);
  }

  Iterable<Read> _decode (QuerySnapshot<Map<String, dynamic>> snap) {
    return snap.docs.map((dd) {
      var item = serializers.deserializeWith<Read>(Read.serializer, dd.data());
      item?.id = dd.id;
      return item;
    }).whereType<Read>();
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
