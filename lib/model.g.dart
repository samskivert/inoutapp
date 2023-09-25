// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (new Serializers().toBuilder()
      ..add(Build.serializer)
      ..add(Read.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>()))
    .build();
Serializer<Read> _$readSerializer = new _$ReadSerializer();
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
    value = object.started;
    if (value != null) {
      result
        ..add('started')
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
        case 'started':
          result.started = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'abandoned':
          result.abandoned = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
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
    value = object.link;
    if (value != null) {
      result
        ..add('link')
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
  final String? started;
  @override
  final bool abandoned;
  @override
  final Timestamp created;
  @override
  final BuiltList<String> tags;
  @override
  final String? link;
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
      this.started,
      required this.abandoned,
      required this.created,
      required this.tags,
      this.link,
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
        started == other.started &&
        abandoned == other.abandoned &&
        created == other.created &&
        tags == other.tags &&
        link == other.link &&
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
    _$hash = $jc(_$hash, started.hashCode);
    _$hash = $jc(_$hash, abandoned.hashCode);
    _$hash = $jc(_$hash, created.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jc(_$hash, link.hashCode);
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
          ..add('started', started)
          ..add('abandoned', abandoned)
          ..add('created', created)
          ..add('tags', tags)
          ..add('link', link)
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
      super.started = $v.started;
      super.abandoned = $v.abandoned;
      super.created = $v.created;
      super.tags = $v.tags.toBuilder();
      super.link = $v.link;
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
              started: started,
              abandoned: BuiltValueNullFieldError.checkNotNull(
                  abandoned, r'Read', 'abandoned'),
              created: BuiltValueNullFieldError.checkNotNull(
                  created, r'Read', 'created'),
              tags: tags.build(),
              link: link,
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

class _$Build extends Build {
  @override
  final String text;
  @override
  final Timestamp created;
  @override
  final BuiltList<String> tags;
  @override
  final String? link;
  @override
  final String? completed;

  factory _$Build([void Function(BuildBuilder)? updates]) =>
      (new BuildBuilder()..update(updates))._build();

  _$Build._(
      {required this.text,
      required this.created,
      required this.tags,
      this.link,
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
        created == other.created &&
        tags == other.tags &&
        link == other.link &&
        completed == other.completed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, created.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jc(_$hash, link.hashCode);
    _$hash = $jc(_$hash, completed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Build')
          ..add('text', text)
          ..add('created', created)
          ..add('tags', tags)
          ..add('link', link)
          ..add('completed', completed))
        .toString();
  }
}

class BuildBuilder implements Builder<Build, BuildBuilder> {
  _$Build? _$v;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  Timestamp? _created;
  Timestamp? get created => _$this._created;
  set created(Timestamp? created) => _$this._created = created;

  ListBuilder<String>? _tags;
  ListBuilder<String> get tags => _$this._tags ??= new ListBuilder<String>();
  set tags(ListBuilder<String>? tags) => _$this._tags = tags;

  String? _link;
  String? get link => _$this._link;
  set link(String? link) => _$this._link = link;

  String? _completed;
  String? get completed => _$this._completed;
  set completed(String? completed) => _$this._completed = completed;

  BuildBuilder();

  BuildBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _text = $v.text;
      _created = $v.created;
      _tags = $v.tags.toBuilder();
      _link = $v.link;
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
              created: BuiltValueNullFieldError.checkNotNull(
                  created, r'Build', 'created'),
              tags: tags.build(),
              link: link,
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
