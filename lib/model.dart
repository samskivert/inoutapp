import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'model.g.dart';

enum ItemType { journal, read, watch, hear, play, dine, build }

abstract class Item {
  Timestamp get created;
  BuiltList<String> get tags;
  String? get link;
  String? get completed;
}

enum Rating { none, bad, meh, ok, good, great }

abstract class Consume extends Item {
  Rating get rating;
  String? get recommender;
}

enum ReadType { article, book, paper }

abstract class Read implements Item, Consume, Built<Read, ReadBuilder> {
  static Serializer<Read> get serializer => _$readSerializer;

  String get title;
  String? get author;
  ReadType get type;
  String? get started;
  bool get abandoned;

  factory Read([void Function(ReadBuilder) updates]) = _$Read;
  Read._();
}

abstract class Build implements Item, Built<Build, BuildBuilder> {
  static Serializer<Build> get serializer => _$buildSerializer;

  String get text;

  factory Build([void Function(BuildBuilder) updates]) = _$Build;
  Build._();
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
