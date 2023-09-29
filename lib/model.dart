import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'model.g.dart';

typedef Filter = bool Function(String?);

Filter makeFilter (String seek) =>
  seek.isEmpty ? (text) => true :
  seek.toLowerCase() != seek ? (text) => text != null && text.contains(seek) :
  (text) => text != null && text.toLowerCase().contains(seek);

enum ItemType { journal, read, watch, hear, play, dine, build }

abstract class Item {
  Timestamp get created;
  BuiltList<String> get tags;
  String? get link;
  String? get completed;
  bool filter (Filter filter);
}

enum Rating {
  none('', 'None'),
  bad('🤮', 'Bad'),
  meh('😒', 'Meh'),
  ok('😐', 'OK'),
  good('🙂', 'Good'),
  great('😍', 'Great!');

  const Rating (this.emoji, this.label);
  final String label;
  final String emoji;
}

abstract class Consume extends Item {
  Rating get rating;
  String? get recommender;
}

// we can't include the material icon in here because importing material breaks dart_value, yay
enum ReadType {
  article('Article'),
  book('Book'),
  paper('Paper');

  const ReadType (this.label);
  final String label;
}

abstract class Read implements Item, Consume, Built<Read, ReadBuilder> {
  static Serializer<Read> get serializer => _$readSerializer;

  String id = '';
  String get title;
  String? get author;
  ReadType get type;
  String? get started;
  bool get abandoned;

  @override bool filter (Filter filter) =>
    filter(title) || filter(author) || filter(recommender) || filter(link) || tags.any(filter);

  factory Read([void Function(ReadBuilder) updates]) = _$Read;
  Read._();
}

abstract class Build implements Item, Built<Build, BuildBuilder> {
  static Serializer<Build> get serializer => _$buildSerializer;

  String get text;

  factory Build([void Function(BuildBuilder) updates]) = _$Build;
  Build._();

  @override bool filter (Filter filter) => filter(text);
}

// in order to provide a defaults value for enums we need this custom builder, yay!
abstract class ReadBuilder implements Builder<Read, ReadBuilder> {
  Timestamp? created;
  ListBuilder<String> tags = ListBuilder<String>();
  String? link;
  String? completed;

  Rating rating = Rating.none;
  String? recommender;

  String? title;
  String? author;
  ReadType type = ReadType.book;
  String? started;
  bool abandoned = false;

  factory ReadBuilder() = _$ReadBuilder;
  ReadBuilder._();
}

// manual serialization plumbing, yay!

class TimestampSerializer implements PrimitiveSerializer<Timestamp> {
  final bool structured = false;
  @override final Iterable<Type> types = BuiltList<Type>([Timestamp]);
  @override final String wireName = 'Timestamp';

  @override
  Object serialize(Serializers serializers, Timestamp timestamp,
                   {FullType specifiedType = FullType.unspecified}) {
    return timestamp;
  }

  @override
  Timestamp deserialize(Serializers serializers, Object serialized,
                        {FullType specifiedType = FullType.unspecified}) {
    return serialized as Timestamp;
  }
}

class RatingSerializer implements PrimitiveSerializer<Rating> {
  final bool structured = false;
  @override final Iterable<Type> types = BuiltList<Type>([Rating]);
  @override final String wireName = 'Rating';

  @override Object serialize (
    Serializers serializers, Rating value, {FullType specifiedType = FullType.unspecified}
  ) { return value.name; }

  @override Rating deserialize(
    Serializers serializers, Object serialized, {FullType specifiedType = FullType.unspecified}
  ) { return Rating.values.byName(serialized as String); }
}

class ReadTypeSerializer implements PrimitiveSerializer<ReadType> {
  final bool structured = false;
  @override final Iterable<Type> types = BuiltList<Type>([ReadType]);
  @override final String wireName = 'ReadType';

  @override
  Object serialize(Serializers serializers, ReadType value,
                   {FullType specifiedType = FullType.unspecified}) {
    return value.name;
  }

  @override
  ReadType deserialize(Serializers serializers, Object serialized,
                       {FullType specifiedType = FullType.unspecified}) {
    return ReadType.values.byName(serialized as String);
  }
}

@SerializersFor([
  Read,
  Build,
])
final Serializers serializers = (_$serializers.toBuilder()
  ..add(TimestampSerializer())
  ..add(RatingSerializer())
  ..add(ReadTypeSerializer())
  ..addPlugin(StandardJsonPlugin())).build();
