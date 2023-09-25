import 'package:test/test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inoutapp/model.dart';

void main() {
  group('Model', () {
    test('runs', () {
      final b1 = Build((b) => b
        ..created = Timestamp.fromMillisecondsSinceEpoch(123)
        ..link = 'http://foo.bar'
        ..tags.addAll(['a', 'b'])
        ..text = 'Build a thing');

      final b1a = Build((b) => b
        ..created = Timestamp.fromMillisecondsSinceEpoch(123)
        ..link = 'http://foo.bar'
        ..tags.addAll(['a', 'b'])
        ..text = 'Build a thing');

      final b2 = Build((b) => b
        ..created = Timestamp.fromMillisecondsSinceEpoch(123)
        ..link = 'http://foo.bar'
        ..tags.addAll(['a', 'c'])
        ..text = 'Build a thing');

      // dart List does not implement structural equality... yay
      assert(b1.toString() == b1a.toString());
      assert(b1.toString() != b2.toString());

      final r1 = Read((r) => r
        ..created = Timestamp.fromMillisecondsSinceEpoch(123)
        ..tags.addAll(['science', 'evolution'])
        ..title = 'The Origin of Species');

      print(serializers.serialize(r1));
    });
  });
}
