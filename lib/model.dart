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

enum ItemType {
  journal('Journal'),
  read('To Read'),
  watch('To Watch'),
  hear('To Listen'),
  play('To Play'),
  dine('To Eat'),
  build('To Build');

  const ItemType (this.label);
  final String label;
}

abstract class Item {
  String? get id;
  Timestamp get created;
  BuiltList<String> get tags;
  String? get link;
  String? get started;
  String? get completed;

  bool isProtracted ();
  bool startable ();
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

enum ReadType {
  article('Article'),
  book('Book'),
  paper('Paper');

  const ReadType (this.label);
  final String label;
}

abstract class Read implements Item, Consume, Built<Read, ReadBuilder> {
  static Serializer<Read> get serializer => _$readSerializer;

  String get title;
  String? get author;
  ReadType get type;
  bool get abandoned;

  @override bool isProtracted () => true;
  @override bool startable () => started == null;
  @override bool filter (Filter filter) =>
    filter(title) || filter(author) || filter(recommender) || filter(link) || tags.any(filter);

  factory Read([void Function(ReadBuilder) updates]) = _$Read;
  Read._();
}

enum WatchType {
  show('Show'),
  film('Film'),
  video('Video'),
  other('Other');

  const WatchType (this.label);
  final String label;
}

abstract class Watch implements Item, Consume, Built<Watch, WatchBuilder> {
  static Serializer<Watch> get serializer => _$watchSerializer;

  String get title;
  String? get director;
  WatchType get type;
  bool get abandoned;

  @override bool isProtracted () => type == WatchType.show || type == WatchType.video;
  @override bool startable () => started == null && isProtracted();
  @override bool filter (Filter filter) =>
    filter(title) || filter(director) || filter(recommender) || filter(link) || tags.any(filter);

  factory Watch([void Function(WatchBuilder) updates]) = _$Watch;
  Watch._();
}

enum HearType {
  song('Song'),
  album('Album'),
  podcast('Podcast'),
  other('Other');

  const HearType (this.label);
  final String label;
}

abstract class Hear implements Item, Consume, Built<Hear, HearBuilder> {
  static Serializer<Hear> get serializer => _$hearSerializer;

  String get title;
  String? get artist;
  HearType get type;

  @override bool isProtracted () => type == HearType.podcast;
  @override bool startable () => started == null && isProtracted();
  @override bool filter (Filter filter) =>
    filter(title) || filter(artist) || filter(recommender) || filter(link) || tags.any(filter);

  factory Hear([void Function(HearBuilder) updates]) = _$Hear;
  Hear._();
}

abstract class Play implements Item, Consume, Built<Play, PlayBuilder> {
  static Serializer<Play> get serializer => _$playSerializer;

  String get title;
  String get platform;
  bool get credits;

  @override bool isProtracted () => true;
  @override bool startable () => started == null;
  @override bool filter (Filter filter) =>
    filter(title) || filter(platform) || filter(recommender) || filter(link) || tags.any(filter);

  factory Play([void Function(PlayBuilder) updates]) = _$Play;
  Play._();
}

abstract class Dine implements Item, Consume, Built<Dine, DineBuilder> {
  static Serializer<Dine> get serializer => _$dineSerializer;

  String get name;
  String? get location;

  @override bool isProtracted () => false;
  @override bool startable () => false;
  @override bool filter (Filter filter) =>
    filter(name) || filter(location) || filter(recommender) || filter(link) || tags.any(filter);

  factory Dine([void Function(DineBuilder) updates]) = _$Dine;
  Dine._();
}

abstract class Build implements Item, Built<Build, BuildBuilder> {
  static Serializer<Build> get serializer => _$buildSerializer;

  String get text;

  factory Build([void Function(BuildBuilder) updates]) = _$Build;
  Build._();

  @override bool isProtracted () => true;
  @override bool startable () => false; // TODO
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

  String? id;
  String? title;
  String? author;
  ReadType type = ReadType.book;
  String? started;
  bool abandoned = false;

  factory ReadBuilder() = _$ReadBuilder;
  ReadBuilder._();
}

abstract class WatchBuilder implements Builder<Watch, WatchBuilder> {
  Timestamp? created;
  ListBuilder<String> tags = ListBuilder<String>();
  String? link;
  String? completed;

  Rating rating = Rating.none;
  String? recommender;

  String? id;
  String? title;
  String? director;
  WatchType type = WatchType.film;
  String? started;
  bool abandoned = false;

  factory WatchBuilder() = _$WatchBuilder;
  WatchBuilder._();
}

abstract class HearBuilder implements Builder<Hear, HearBuilder> {
  Timestamp? created;
  ListBuilder<String> tags = ListBuilder<String>();
  String? link;
  String? completed;

  Rating rating = Rating.none;
  String? recommender;

  String? id;
  String? title;
  String? artist;
  HearType type = HearType.podcast;
  String? started;

  factory HearBuilder() = _$HearBuilder;
  HearBuilder._();
}

abstract class PlayBuilder implements Builder<Play, PlayBuilder> {
  Timestamp? created;
  ListBuilder<String> tags = ListBuilder<String>();
  String? link;
  String? completed;

  Rating rating = Rating.none;
  String? recommender;

  String? id;
  String? title;
  String platform = "pc";
  String? started;
  bool credits = false;

  factory PlayBuilder() = _$PlayBuilder;
  PlayBuilder._();
}

abstract class DineBuilder implements Builder<Dine, DineBuilder> {
  Timestamp? created;
  ListBuilder<String> tags = ListBuilder<String>();
  String? link;
  String? completed;

  Rating rating = Rating.none;
  String? recommender;

  String? id;
  String? name;
  String? location;
  String? started;

  factory DineBuilder() = _$DineBuilder;
  DineBuilder._();
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
                   {FullType specifiedType = FullType.unspecified}) => value.name;
  @override
  ReadType deserialize(Serializers serializers, Object serialized,
                       {FullType specifiedType = FullType.unspecified}) =>
    ReadType.values.byName(serialized as String);
}

class WatchTypeSerializer implements PrimitiveSerializer<WatchType> {
  final bool structured = false;
  @override final Iterable<Type> types = BuiltList<Type>([WatchType]);
  @override final String wireName = 'WatchType';
  @override
  Object serialize(Serializers serializers, WatchType value,
                   {FullType specifiedType = FullType.unspecified}) => value.name;
  @override
  WatchType deserialize(Serializers serializers, Object serialized,
                       {FullType specifiedType = FullType.unspecified}) =>
    WatchType.values.byName(serialized as String);
}

class HearTypeSerializer implements PrimitiveSerializer<HearType> {
  final bool structured = false;
  @override final Iterable<Type> types = BuiltList<Type>([HearType]);
  @override final String wireName = 'HearType';
  @override
  Object serialize(Serializers serializers, HearType value,
                   {FullType specifiedType = FullType.unspecified}) => value.name;
  @override
  HearType deserialize(Serializers serializers, Object serialized,
                       {FullType specifiedType = FullType.unspecified}) =>
    HearType.values.byName(serialized as String);
}

@SerializersFor([
  Read,
  Watch,
  Hear,
  Play,
  Dine,
  Build,
])
final Serializers serializers = (_$serializers.toBuilder()
  ..add(TimestampSerializer())
  ..add(RatingSerializer())
  ..add(ReadTypeSerializer())
  ..add(WatchTypeSerializer())
  ..add(HearTypeSerializer())
  ..addPlugin(StandardJsonPlugin())).build();
