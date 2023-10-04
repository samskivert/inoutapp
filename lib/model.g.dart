// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (new Serializers().toBuilder()
      ..add(Build.serializer)
      ..add(Hear.serializer)
      ..add(Play.serializer)
      ..add(Read.serializer)
      ..add(Watch.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>()))
    .build();
Serializer<Read> _$readSerializer = new _$ReadSerializer();
Serializer<Watch> _$watchSerializer = new _$WatchSerializer();
Serializer<Hear> _$hearSerializer = new _$HearSerializer();
Serializer<Play> _$playSerializer = new _$PlaySerializer();
Serializer<Build> _$buildSerializer = new _$BuildSerializer();

class _$ReadSerializer implements StructuredSerializer<Read> {
  @override
  final Iterable<Type> types = const [Read, _$Read];
  @override
  final String wireName = 'Read';

  @override
  Iterable<Object?> serialize(Serializers serializers, Read object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'type',
      serializers.serialize(object.type,
          specifiedType: const FullType(ReadType)),
      'abandoned',
      serializers.serialize(object.abandoned,
          specifiedType: const FullType(bool)),
      'created',
      serializers.serialize(object.created,
          specifiedType: const FullType(Timestamp)),
      'tags',
      serializers.serialize(object.tags,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'rating',
      serializers.serialize(object.rating,
          specifiedType: const FullType(Rating)),
    ];
    Object? value;
    value = object.author;
    if (value != null) {
      result
        ..add('author')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.link;
    if (value != null) {
      result
        ..add('link')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.started;
    if (value != null) {
      result
        ..add('started')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.completed;
    if (value != null) {
      result
        ..add('completed')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.recommender;
    if (value != null) {
      result
        ..add('recommender')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Read deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ReadBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'author':
          result.author = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(ReadType))! as ReadType;
          break;
        case 'abandoned':
          result.abandoned = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'created':
          result.created = serializers.deserialize(value,
              specifiedType: const FullType(Timestamp))! as Timestamp;
          break;
        case 'tags':
          result.tags.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'link':
          result.link = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'started':
          result.started = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'completed':
          result.completed = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'rating':
          result.rating = serializers.deserialize(value,
              specifiedType: const FullType(Rating))! as Rating;
          break;
        case 'recommender':
          result.recommender = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$WatchSerializer implements StructuredSerializer<Watch> {
  @override
  final Iterable<Type> types = const [Watch, _$Watch];
  @override
  final String wireName = 'Watch';

  @override
  Iterable<Object?> serialize(Serializers serializers, Watch object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'type',
      serializers.serialize(object.type,
          specifiedType: const FullType(WatchType)),
      'abandoned',
      serializers.serialize(object.abandoned,
          specifiedType: const FullType(bool)),
      'created',
      serializers.serialize(object.created,
          specifiedType: const FullType(Timestamp)),
      'tags',
      serializers.serialize(object.tags,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'rating',
      serializers.serialize(object.rating,
          specifiedType: const FullType(Rating)),
    ];
    Object? value;
    value = object.director;
    if (value != null) {
      result
        ..add('director')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.link;
    if (value != null) {
      result
        ..add('link')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.started;
    if (value != null) {
      result
        ..add('started')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.completed;
    if (value != null) {
      result
        ..add('completed')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.recommender;
    if (value != null) {
      result
        ..add('recommender')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Watch deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new WatchBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'director':
          result.director = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(WatchType))! as WatchType;
          break;
        case 'abandoned':
          result.abandoned = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'created':
          result.created = serializers.deserialize(value,
              specifiedType: const FullType(Timestamp))! as Timestamp;
          break;
        case 'tags':
          result.tags.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'link':
          result.link = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'started':
          result.started = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'completed':
          result.completed = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'rating':
          result.rating = serializers.deserialize(value,
              specifiedType: const FullType(Rating))! as Rating;
          break;
        case 'recommender':
          result.recommender = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$HearSerializer implements StructuredSerializer<Hear> {
  @override
  final Iterable<Type> types = const [Hear, _$Hear];
  @override
  final String wireName = 'Hear';

  @override
  Iterable<Object?> serialize(Serializers serializers, Hear object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'type',
      serializers.serialize(object.type,
          specifiedType: const FullType(HearType)),
      'created',
      serializers.serialize(object.created,
          specifiedType: const FullType(Timestamp)),
      'tags',
      serializers.serialize(object.tags,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'rating',
      serializers.serialize(object.rating,
          specifiedType: const FullType(Rating)),
    ];
    Object? value;
    value = object.artist;
    if (value != null) {
      result
        ..add('artist')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.link;
    if (value != null) {
      result
        ..add('link')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.started;
    if (value != null) {
      result
        ..add('started')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.completed;
    if (value != null) {
      result
        ..add('completed')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.recommender;
    if (value != null) {
      result
        ..add('recommender')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Hear deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new HearBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'artist':
          result.artist = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(HearType))! as HearType;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'created':
          result.created = serializers.deserialize(value,
              specifiedType: const FullType(Timestamp))! as Timestamp;
          break;
        case 'tags':
          result.tags.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'link':
          result.link = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'started':
          result.started = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'completed':
          result.completed = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'rating':
          result.rating = serializers.deserialize(value,
              specifiedType: const FullType(Rating))! as Rating;
          break;
        case 'recommender':
          result.recommender = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$PlaySerializer implements StructuredSerializer<Play> {
  @override
  final Iterable<Type> types = const [Play, _$Play];
  @override
  final String wireName = 'Play';

  @override
  Iterable<Object?> serialize(Serializers serializers, Play object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'platform',
      serializers.serialize(object.platform,
          specifiedType: const FullType(String)),
      'credits',
      serializers.serialize(object.credits,
          specifiedType: const FullType(bool)),
      'created',
      serializers.serialize(object.created,
          specifiedType: const FullType(Timestamp)),
      'tags',
      serializers.serialize(object.tags,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'rating',
      serializers.serialize(object.rating,
          specifiedType: const FullType(Rating)),
    ];
    Object? value;
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.link;
    if (value != null) {
      result
        ..add('link')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.started;
    if (value != null) {
      result
        ..add('started')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.completed;
    if (value != null) {
      result
        ..add('completed')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.recommender;
    if (value != null) {
      result
        ..add('recommender')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Play deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PlayBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'platform':
          result.platform = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'credits':
          result.credits = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'created':
          result.created = serializers.deserialize(value,
              specifiedType: const FullType(Timestamp))! as Timestamp;
          break;
        case 'tags':
          result.tags.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'link':
          result.link = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'started':
          result.started = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'completed':
          result.completed = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'rating':
          result.rating = serializers.deserialize(value,
              specifiedType: const FullType(Rating))! as Rating;
          break;
        case 'recommender':
          result.recommender = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$BuildSerializer implements StructuredSerializer<Build> {
  @override
  final Iterable<Type> types = const [Build, _$Build];
  @override
  final String wireName = 'Build';

  @override
  Iterable<Object?> serialize(Serializers serializers, Build object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'text',
      serializers.serialize(object.text, specifiedType: const FullType(String)),
      'created',
      serializers.serialize(object.created,
          specifiedType: const FullType(Timestamp)),
      'tags',
      serializers.serialize(object.tags,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];
    Object? value;
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.link;
    if (value != null) {
      result
        ..add('link')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.started;
    if (value != null) {
      result
        ..add('started')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.completed;
    if (value != null) {
      result
        ..add('completed')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Build deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuildBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'text':
          result.text = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'created':
          result.created = serializers.deserialize(value,
              specifiedType: const FullType(Timestamp))! as Timestamp;
          break;
        case 'tags':
          result.tags.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'link':
          result.link = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'started':
          result.started = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'completed':
          result.completed = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$Read extends Read {
  @override
  final String title;
  @override
  final String? author;
  @override
  final ReadType type;
  @override
  final bool abandoned;
  @override
  final String? id;
  @override
  final Timestamp created;
  @override
  final BuiltList<String> tags;
  @override
  final String? link;
  @override
  final String? started;
  @override
  final String? completed;
  @override
  final Rating rating;
  @override
  final String? recommender;

  factory _$Read([void Function(ReadBuilder)? updates]) =>
      (new ReadBuilder()..update(updates)).build() as _$Read;

  _$Read._(
      {required this.title,
      this.author,
      required this.type,
      required this.abandoned,
      this.id,
      required this.created,
      required this.tags,
      this.link,
      this.started,
      this.completed,
      required this.rating,
      this.recommender})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(title, r'Read', 'title');
    BuiltValueNullFieldError.checkNotNull(type, r'Read', 'type');
    BuiltValueNullFieldError.checkNotNull(abandoned, r'Read', 'abandoned');
    BuiltValueNullFieldError.checkNotNull(created, r'Read', 'created');
    BuiltValueNullFieldError.checkNotNull(tags, r'Read', 'tags');
    BuiltValueNullFieldError.checkNotNull(rating, r'Read', 'rating');
  }

  @override
  Read rebuild(void Function(ReadBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  _$ReadBuilder toBuilder() => new _$ReadBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Read &&
        title == other.title &&
        author == other.author &&
        type == other.type &&
        abandoned == other.abandoned &&
        id == other.id &&
        created == other.created &&
        tags == other.tags &&
        link == other.link &&
        started == other.started &&
        completed == other.completed &&
        rating == other.rating &&
        recommender == other.recommender;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, author.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, abandoned.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, created.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jc(_$hash, link.hashCode);
    _$hash = $jc(_$hash, started.hashCode);
    _$hash = $jc(_$hash, completed.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, recommender.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Read')
          ..add('title', title)
          ..add('author', author)
          ..add('type', type)
          ..add('abandoned', abandoned)
          ..add('id', id)
          ..add('created', created)
          ..add('tags', tags)
          ..add('link', link)
          ..add('started', started)
          ..add('completed', completed)
          ..add('rating', rating)
          ..add('recommender', recommender))
        .toString();
  }
}

class _$ReadBuilder extends ReadBuilder {
  _$Read? _$v;

  @override
  String? get title {
    _$this;
    return super.title;
  }

  @override
  set title(String? title) {
    _$this;
    super.title = title;
  }

  @override
  String? get author {
    _$this;
    return super.author;
  }

  @override
  set author(String? author) {
    _$this;
    super.author = author;
  }

  @override
  ReadType get type {
    _$this;
    return super.type;
  }

  @override
  set type(ReadType type) {
    _$this;
    super.type = type;
  }

  @override
  bool get abandoned {
    _$this;
    return super.abandoned;
  }

  @override
  set abandoned(bool abandoned) {
    _$this;
    super.abandoned = abandoned;
  }

  @override
  String? get id {
    _$this;
    return super.id;
  }

  @override
  set id(String? id) {
    _$this;
    super.id = id;
  }

  @override
  Timestamp? get created {
    _$this;
    return super.created;
  }

  @override
  set created(Timestamp? created) {
    _$this;
    super.created = created;
  }

  @override
  ListBuilder<String> get tags {
    _$this;
    return super.tags;
  }

  @override
  set tags(ListBuilder<String> tags) {
    _$this;
    super.tags = tags;
  }

  @override
  String? get link {
    _$this;
    return super.link;
  }

  @override
  set link(String? link) {
    _$this;
    super.link = link;
  }

  @override
  String? get started {
    _$this;
    return super.started;
  }

  @override
  set started(String? started) {
    _$this;
    super.started = started;
  }

  @override
  String? get completed {
    _$this;
    return super.completed;
  }

  @override
  set completed(String? completed) {
    _$this;
    super.completed = completed;
  }

  @override
  Rating get rating {
    _$this;
    return super.rating;
  }

  @override
  set rating(Rating rating) {
    _$this;
    super.rating = rating;
  }

  @override
  String? get recommender {
    _$this;
    return super.recommender;
  }

  @override
  set recommender(String? recommender) {
    _$this;
    super.recommender = recommender;
  }

  _$ReadBuilder() : super._();

  ReadBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      super.title = $v.title;
      super.author = $v.author;
      super.type = $v.type;
      super.abandoned = $v.abandoned;
      super.id = $v.id;
      super.created = $v.created;
      super.tags = $v.tags.toBuilder();
      super.link = $v.link;
      super.started = $v.started;
      super.completed = $v.completed;
      super.rating = $v.rating;
      super.recommender = $v.recommender;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Read other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Read;
  }

  @override
  void update(void Function(ReadBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Read build() => _build();

  _$Read _build() {
    _$Read _$result;
    try {
      _$result = _$v ??
          new _$Read._(
              title: BuiltValueNullFieldError.checkNotNull(
                  title, r'Read', 'title'),
              author: author,
              type:
                  BuiltValueNullFieldError.checkNotNull(type, r'Read', 'type'),
              abandoned: BuiltValueNullFieldError.checkNotNull(
                  abandoned, r'Read', 'abandoned'),
              id: id,
              created: BuiltValueNullFieldError.checkNotNull(
                  created, r'Read', 'created'),
              tags: tags.build(),
              link: link,
              started: started,
              completed: completed,
              rating: BuiltValueNullFieldError.checkNotNull(
                  rating, r'Read', 'rating'),
              recommender: recommender);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tags';
        tags.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'Read', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Watch extends Watch {
  @override
  final String title;
  @override
  final String? director;
  @override
  final WatchType type;
  @override
  final bool abandoned;
  @override
  final String? id;
  @override
  final Timestamp created;
  @override
  final BuiltList<String> tags;
  @override
  final String? link;
  @override
  final String? started;
  @override
  final String? completed;
  @override
  final Rating rating;
  @override
  final String? recommender;

  factory _$Watch([void Function(WatchBuilder)? updates]) =>
      (new WatchBuilder()..update(updates)).build() as _$Watch;

  _$Watch._(
      {required this.title,
      this.director,
      required this.type,
      required this.abandoned,
      this.id,
      required this.created,
      required this.tags,
      this.link,
      this.started,
      this.completed,
      required this.rating,
      this.recommender})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(title, r'Watch', 'title');
    BuiltValueNullFieldError.checkNotNull(type, r'Watch', 'type');
    BuiltValueNullFieldError.checkNotNull(abandoned, r'Watch', 'abandoned');
    BuiltValueNullFieldError.checkNotNull(created, r'Watch', 'created');
    BuiltValueNullFieldError.checkNotNull(tags, r'Watch', 'tags');
    BuiltValueNullFieldError.checkNotNull(rating, r'Watch', 'rating');
  }

  @override
  Watch rebuild(void Function(WatchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  _$WatchBuilder toBuilder() => new _$WatchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Watch &&
        title == other.title &&
        director == other.director &&
        type == other.type &&
        abandoned == other.abandoned &&
        id == other.id &&
        created == other.created &&
        tags == other.tags &&
        link == other.link &&
        started == other.started &&
        completed == other.completed &&
        rating == other.rating &&
        recommender == other.recommender;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, director.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, abandoned.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, created.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jc(_$hash, link.hashCode);
    _$hash = $jc(_$hash, started.hashCode);
    _$hash = $jc(_$hash, completed.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, recommender.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Watch')
          ..add('title', title)
          ..add('director', director)
          ..add('type', type)
          ..add('abandoned', abandoned)
          ..add('id', id)
          ..add('created', created)
          ..add('tags', tags)
          ..add('link', link)
          ..add('started', started)
          ..add('completed', completed)
          ..add('rating', rating)
          ..add('recommender', recommender))
        .toString();
  }
}

class _$WatchBuilder extends WatchBuilder {
  _$Watch? _$v;

  @override
  String? get title {
    _$this;
    return super.title;
  }

  @override
  set title(String? title) {
    _$this;
    super.title = title;
  }

  @override
  String? get director {
    _$this;
    return super.director;
  }

  @override
  set director(String? director) {
    _$this;
    super.director = director;
  }

  @override
  WatchType get type {
    _$this;
    return super.type;
  }

  @override
  set type(WatchType type) {
    _$this;
    super.type = type;
  }

  @override
  bool get abandoned {
    _$this;
    return super.abandoned;
  }

  @override
  set abandoned(bool abandoned) {
    _$this;
    super.abandoned = abandoned;
  }

  @override
  String? get id {
    _$this;
    return super.id;
  }

  @override
  set id(String? id) {
    _$this;
    super.id = id;
  }

  @override
  Timestamp? get created {
    _$this;
    return super.created;
  }

  @override
  set created(Timestamp? created) {
    _$this;
    super.created = created;
  }

  @override
  ListBuilder<String> get tags {
    _$this;
    return super.tags;
  }

  @override
  set tags(ListBuilder<String> tags) {
    _$this;
    super.tags = tags;
  }

  @override
  String? get link {
    _$this;
    return super.link;
  }

  @override
  set link(String? link) {
    _$this;
    super.link = link;
  }

  @override
  String? get started {
    _$this;
    return super.started;
  }

  @override
  set started(String? started) {
    _$this;
    super.started = started;
  }

  @override
  String? get completed {
    _$this;
    return super.completed;
  }

  @override
  set completed(String? completed) {
    _$this;
    super.completed = completed;
  }

  @override
  Rating get rating {
    _$this;
    return super.rating;
  }

  @override
  set rating(Rating rating) {
    _$this;
    super.rating = rating;
  }

  @override
  String? get recommender {
    _$this;
    return super.recommender;
  }

  @override
  set recommender(String? recommender) {
    _$this;
    super.recommender = recommender;
  }

  _$WatchBuilder() : super._();

  WatchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      super.title = $v.title;
      super.director = $v.director;
      super.type = $v.type;
      super.abandoned = $v.abandoned;
      super.id = $v.id;
      super.created = $v.created;
      super.tags = $v.tags.toBuilder();
      super.link = $v.link;
      super.started = $v.started;
      super.completed = $v.completed;
      super.rating = $v.rating;
      super.recommender = $v.recommender;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Watch other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Watch;
  }

  @override
  void update(void Function(WatchBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Watch build() => _build();

  _$Watch _build() {
    _$Watch _$result;
    try {
      _$result = _$v ??
          new _$Watch._(
              title: BuiltValueNullFieldError.checkNotNull(
                  title, r'Watch', 'title'),
              director: director,
              type:
                  BuiltValueNullFieldError.checkNotNull(type, r'Watch', 'type'),
              abandoned: BuiltValueNullFieldError.checkNotNull(
                  abandoned, r'Watch', 'abandoned'),
              id: id,
              created: BuiltValueNullFieldError.checkNotNull(
                  created, r'Watch', 'created'),
              tags: tags.build(),
              link: link,
              started: started,
              completed: completed,
              rating: BuiltValueNullFieldError.checkNotNull(
                  rating, r'Watch', 'rating'),
              recommender: recommender);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tags';
        tags.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'Watch', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Hear extends Hear {
  @override
  final String title;
  @override
  final String? artist;
  @override
  final HearType type;
  @override
  final String? id;
  @override
  final Timestamp created;
  @override
  final BuiltList<String> tags;
  @override
  final String? link;
  @override
  final String? started;
  @override
  final String? completed;
  @override
  final Rating rating;
  @override
  final String? recommender;

  factory _$Hear([void Function(HearBuilder)? updates]) =>
      (new HearBuilder()..update(updates)).build() as _$Hear;

  _$Hear._(
      {required this.title,
      this.artist,
      required this.type,
      this.id,
      required this.created,
      required this.tags,
      this.link,
      this.started,
      this.completed,
      required this.rating,
      this.recommender})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(title, r'Hear', 'title');
    BuiltValueNullFieldError.checkNotNull(type, r'Hear', 'type');
    BuiltValueNullFieldError.checkNotNull(created, r'Hear', 'created');
    BuiltValueNullFieldError.checkNotNull(tags, r'Hear', 'tags');
    BuiltValueNullFieldError.checkNotNull(rating, r'Hear', 'rating');
  }

  @override
  Hear rebuild(void Function(HearBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  _$HearBuilder toBuilder() => new _$HearBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Hear &&
        title == other.title &&
        artist == other.artist &&
        type == other.type &&
        id == other.id &&
        created == other.created &&
        tags == other.tags &&
        link == other.link &&
        started == other.started &&
        completed == other.completed &&
        rating == other.rating &&
        recommender == other.recommender;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, artist.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, created.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jc(_$hash, link.hashCode);
    _$hash = $jc(_$hash, started.hashCode);
    _$hash = $jc(_$hash, completed.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, recommender.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Hear')
          ..add('title', title)
          ..add('artist', artist)
          ..add('type', type)
          ..add('id', id)
          ..add('created', created)
          ..add('tags', tags)
          ..add('link', link)
          ..add('started', started)
          ..add('completed', completed)
          ..add('rating', rating)
          ..add('recommender', recommender))
        .toString();
  }
}

class _$HearBuilder extends HearBuilder {
  _$Hear? _$v;

  @override
  String? get title {
    _$this;
    return super.title;
  }

  @override
  set title(String? title) {
    _$this;
    super.title = title;
  }

  @override
  String? get artist {
    _$this;
    return super.artist;
  }

  @override
  set artist(String? artist) {
    _$this;
    super.artist = artist;
  }

  @override
  HearType get type {
    _$this;
    return super.type;
  }

  @override
  set type(HearType type) {
    _$this;
    super.type = type;
  }

  @override
  String? get id {
    _$this;
    return super.id;
  }

  @override
  set id(String? id) {
    _$this;
    super.id = id;
  }

  @override
  Timestamp? get created {
    _$this;
    return super.created;
  }

  @override
  set created(Timestamp? created) {
    _$this;
    super.created = created;
  }

  @override
  ListBuilder<String> get tags {
    _$this;
    return super.tags;
  }

  @override
  set tags(ListBuilder<String> tags) {
    _$this;
    super.tags = tags;
  }

  @override
  String? get link {
    _$this;
    return super.link;
  }

  @override
  set link(String? link) {
    _$this;
    super.link = link;
  }

  @override
  String? get started {
    _$this;
    return super.started;
  }

  @override
  set started(String? started) {
    _$this;
    super.started = started;
  }

  @override
  String? get completed {
    _$this;
    return super.completed;
  }

  @override
  set completed(String? completed) {
    _$this;
    super.completed = completed;
  }

  @override
  Rating get rating {
    _$this;
    return super.rating;
  }

  @override
  set rating(Rating rating) {
    _$this;
    super.rating = rating;
  }

  @override
  String? get recommender {
    _$this;
    return super.recommender;
  }

  @override
  set recommender(String? recommender) {
    _$this;
    super.recommender = recommender;
  }

  _$HearBuilder() : super._();

  HearBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      super.title = $v.title;
      super.artist = $v.artist;
      super.type = $v.type;
      super.id = $v.id;
      super.created = $v.created;
      super.tags = $v.tags.toBuilder();
      super.link = $v.link;
      super.started = $v.started;
      super.completed = $v.completed;
      super.rating = $v.rating;
      super.recommender = $v.recommender;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Hear other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Hear;
  }

  @override
  void update(void Function(HearBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Hear build() => _build();

  _$Hear _build() {
    _$Hear _$result;
    try {
      _$result = _$v ??
          new _$Hear._(
              title: BuiltValueNullFieldError.checkNotNull(
                  title, r'Hear', 'title'),
              artist: artist,
              type:
                  BuiltValueNullFieldError.checkNotNull(type, r'Hear', 'type'),
              id: id,
              created: BuiltValueNullFieldError.checkNotNull(
                  created, r'Hear', 'created'),
              tags: tags.build(),
              link: link,
              started: started,
              completed: completed,
              rating: BuiltValueNullFieldError.checkNotNull(
                  rating, r'Hear', 'rating'),
              recommender: recommender);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tags';
        tags.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'Hear', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Play extends Play {
  @override
  final String title;
  @override
  final String platform;
  @override
  final bool credits;
  @override
  final String? id;
  @override
  final Timestamp created;
  @override
  final BuiltList<String> tags;
  @override
  final String? link;
  @override
  final String? started;
  @override
  final String? completed;
  @override
  final Rating rating;
  @override
  final String? recommender;

  factory _$Play([void Function(PlayBuilder)? updates]) =>
      (new PlayBuilder()..update(updates)).build() as _$Play;

  _$Play._(
      {required this.title,
      required this.platform,
      required this.credits,
      this.id,
      required this.created,
      required this.tags,
      this.link,
      this.started,
      this.completed,
      required this.rating,
      this.recommender})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(title, r'Play', 'title');
    BuiltValueNullFieldError.checkNotNull(platform, r'Play', 'platform');
    BuiltValueNullFieldError.checkNotNull(credits, r'Play', 'credits');
    BuiltValueNullFieldError.checkNotNull(created, r'Play', 'created');
    BuiltValueNullFieldError.checkNotNull(tags, r'Play', 'tags');
    BuiltValueNullFieldError.checkNotNull(rating, r'Play', 'rating');
  }

  @override
  Play rebuild(void Function(PlayBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  _$PlayBuilder toBuilder() => new _$PlayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Play &&
        title == other.title &&
        platform == other.platform &&
        credits == other.credits &&
        id == other.id &&
        created == other.created &&
        tags == other.tags &&
        link == other.link &&
        started == other.started &&
        completed == other.completed &&
        rating == other.rating &&
        recommender == other.recommender;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, platform.hashCode);
    _$hash = $jc(_$hash, credits.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, created.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jc(_$hash, link.hashCode);
    _$hash = $jc(_$hash, started.hashCode);
    _$hash = $jc(_$hash, completed.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, recommender.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Play')
          ..add('title', title)
          ..add('platform', platform)
          ..add('credits', credits)
          ..add('id', id)
          ..add('created', created)
          ..add('tags', tags)
          ..add('link', link)
          ..add('started', started)
          ..add('completed', completed)
          ..add('rating', rating)
          ..add('recommender', recommender))
        .toString();
  }
}

class _$PlayBuilder extends PlayBuilder {
  _$Play? _$v;

  @override
  String? get title {
    _$this;
    return super.title;
  }

  @override
  set title(String? title) {
    _$this;
    super.title = title;
  }

  @override
  String get platform {
    _$this;
    return super.platform;
  }

  @override
  set platform(String platform) {
    _$this;
    super.platform = platform;
  }

  @override
  bool get credits {
    _$this;
    return super.credits;
  }

  @override
  set credits(bool credits) {
    _$this;
    super.credits = credits;
  }

  @override
  String? get id {
    _$this;
    return super.id;
  }

  @override
  set id(String? id) {
    _$this;
    super.id = id;
  }

  @override
  Timestamp? get created {
    _$this;
    return super.created;
  }

  @override
  set created(Timestamp? created) {
    _$this;
    super.created = created;
  }

  @override
  ListBuilder<String> get tags {
    _$this;
    return super.tags;
  }

  @override
  set tags(ListBuilder<String> tags) {
    _$this;
    super.tags = tags;
  }

  @override
  String? get link {
    _$this;
    return super.link;
  }

  @override
  set link(String? link) {
    _$this;
    super.link = link;
  }

  @override
  String? get started {
    _$this;
    return super.started;
  }

  @override
  set started(String? started) {
    _$this;
    super.started = started;
  }

  @override
  String? get completed {
    _$this;
    return super.completed;
  }

  @override
  set completed(String? completed) {
    _$this;
    super.completed = completed;
  }

  @override
  Rating get rating {
    _$this;
    return super.rating;
  }

  @override
  set rating(Rating rating) {
    _$this;
    super.rating = rating;
  }

  @override
  String? get recommender {
    _$this;
    return super.recommender;
  }

  @override
  set recommender(String? recommender) {
    _$this;
    super.recommender = recommender;
  }

  _$PlayBuilder() : super._();

  PlayBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      super.title = $v.title;
      super.platform = $v.platform;
      super.credits = $v.credits;
      super.id = $v.id;
      super.created = $v.created;
      super.tags = $v.tags.toBuilder();
      super.link = $v.link;
      super.started = $v.started;
      super.completed = $v.completed;
      super.rating = $v.rating;
      super.recommender = $v.recommender;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Play other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Play;
  }

  @override
  void update(void Function(PlayBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Play build() => _build();

  _$Play _build() {
    _$Play _$result;
    try {
      _$result = _$v ??
          new _$Play._(
              title: BuiltValueNullFieldError.checkNotNull(
                  title, r'Play', 'title'),
              platform: BuiltValueNullFieldError.checkNotNull(
                  platform, r'Play', 'platform'),
              credits: BuiltValueNullFieldError.checkNotNull(
                  credits, r'Play', 'credits'),
              id: id,
              created: BuiltValueNullFieldError.checkNotNull(
                  created, r'Play', 'created'),
              tags: tags.build(),
              link: link,
              started: started,
              completed: completed,
              rating: BuiltValueNullFieldError.checkNotNull(
                  rating, r'Play', 'rating'),
              recommender: recommender);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tags';
        tags.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'Play', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Build extends Build {
  @override
  final String text;
  @override
  final String? id;
  @override
  final Timestamp created;
  @override
  final BuiltList<String> tags;
  @override
  final String? link;
  @override
  final String? started;
  @override
  final String? completed;

  factory _$Build([void Function(BuildBuilder)? updates]) =>
      (new BuildBuilder()..update(updates))._build();

  _$Build._(
      {required this.text,
      this.id,
      required this.created,
      required this.tags,
      this.link,
      this.started,
      this.completed})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(text, r'Build', 'text');
    BuiltValueNullFieldError.checkNotNull(created, r'Build', 'created');
    BuiltValueNullFieldError.checkNotNull(tags, r'Build', 'tags');
  }

  @override
  Build rebuild(void Function(BuildBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuildBuilder toBuilder() => new BuildBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Build &&
        text == other.text &&
        id == other.id &&
        created == other.created &&
        tags == other.tags &&
        link == other.link &&
        started == other.started &&
        completed == other.completed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, created.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jc(_$hash, link.hashCode);
    _$hash = $jc(_$hash, started.hashCode);
    _$hash = $jc(_$hash, completed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Build')
          ..add('text', text)
          ..add('id', id)
          ..add('created', created)
          ..add('tags', tags)
          ..add('link', link)
          ..add('started', started)
          ..add('completed', completed))
        .toString();
  }
}

class BuildBuilder implements Builder<Build, BuildBuilder> {
  _$Build? _$v;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  Timestamp? _created;
  Timestamp? get created => _$this._created;
  set created(Timestamp? created) => _$this._created = created;

  ListBuilder<String>? _tags;
  ListBuilder<String> get tags => _$this._tags ??= new ListBuilder<String>();
  set tags(ListBuilder<String>? tags) => _$this._tags = tags;

  String? _link;
  String? get link => _$this._link;
  set link(String? link) => _$this._link = link;

  String? _started;
  String? get started => _$this._started;
  set started(String? started) => _$this._started = started;

  String? _completed;
  String? get completed => _$this._completed;
  set completed(String? completed) => _$this._completed = completed;

  BuildBuilder();

  BuildBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _text = $v.text;
      _id = $v.id;
      _created = $v.created;
      _tags = $v.tags.toBuilder();
      _link = $v.link;
      _started = $v.started;
      _completed = $v.completed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Build other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Build;
  }

  @override
  void update(void Function(BuildBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Build build() => _build();

  _$Build _build() {
    _$Build _$result;
    try {
      _$result = _$v ??
          new _$Build._(
              text:
                  BuiltValueNullFieldError.checkNotNull(text, r'Build', 'text'),
              id: id,
              created: BuiltValueNullFieldError.checkNotNull(
                  created, r'Build', 'created'),
              tags: tags.build(),
              link: link,
              started: started,
              completed: completed);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tags';
        tags.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'Build', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
