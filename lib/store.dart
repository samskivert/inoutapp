import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model.dart';

class Store {
  final User user;

  Store(this.user);

  Future<Iterable<Read>> readItems () async {
    var snap = await collection('read').where('completed', isNull: true).get();
    return snap.docs.map((dd) => serializers.deserializeWith<Read>(Read.serializer, dd.data())).
      whereType<Read>();
  }

  CollectionReference<Map<String, dynamic>> collection (String name) {
    return FirebaseFirestore.instance.collection('users').doc(user.uid).collection(name);
  }

}
