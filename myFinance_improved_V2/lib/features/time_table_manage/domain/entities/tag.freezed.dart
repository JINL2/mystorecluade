// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tag.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Tag _$TagFromJson(Map<String, dynamic> json) {
  return _Tag.fromJson(json);
}

/// @nodoc
mixin _$Tag {
  /// Unique identifier for the tag
  @JsonKey(name: 'tag_id')
  String get tagId => throw _privateConstructorUsedError;

  /// ID of the card this tag is attached to
  @JsonKey(name: 'card_id')
  String get cardId => throw _privateConstructorUsedError;

  /// Type of tag (e.g., 'bonus', 'warning', 'info', 'late')
  @JsonKey(name: 'tag_type')
  String get tagType => throw _privateConstructorUsedError;

  /// Content/description of the tag
  @JsonKey(name: 'tag_content')
  String get tagContent => throw _privateConstructorUsedError;

  /// When the tag was created
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// User ID who created the tag
  @JsonKey(name: 'created_by')
  String get createdBy => throw _privateConstructorUsedError;

  /// Serializes this Tag to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Tag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TagCopyWith<Tag> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TagCopyWith<$Res> {
  factory $TagCopyWith(Tag value, $Res Function(Tag) then) =
      _$TagCopyWithImpl<$Res, Tag>;
  @useResult
  $Res call(
      {@JsonKey(name: 'tag_id') String tagId,
      @JsonKey(name: 'card_id') String cardId,
      @JsonKey(name: 'tag_type') String tagType,
      @JsonKey(name: 'tag_content') String tagContent,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'created_by') String createdBy});
}

/// @nodoc
class _$TagCopyWithImpl<$Res, $Val extends Tag> implements $TagCopyWith<$Res> {
  _$TagCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Tag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tagId = null,
    Object? cardId = null,
    Object? tagType = null,
    Object? tagContent = null,
    Object? createdAt = null,
    Object? createdBy = null,
  }) {
    return _then(_value.copyWith(
      tagId: null == tagId
          ? _value.tagId
          : tagId // ignore: cast_nullable_to_non_nullable
              as String,
      cardId: null == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
              as String,
      tagType: null == tagType
          ? _value.tagType
          : tagType // ignore: cast_nullable_to_non_nullable
              as String,
      tagContent: null == tagContent
          ? _value.tagContent
          : tagContent // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TagImplCopyWith<$Res> implements $TagCopyWith<$Res> {
  factory _$$TagImplCopyWith(_$TagImpl value, $Res Function(_$TagImpl) then) =
      __$$TagImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'tag_id') String tagId,
      @JsonKey(name: 'card_id') String cardId,
      @JsonKey(name: 'tag_type') String tagType,
      @JsonKey(name: 'tag_content') String tagContent,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'created_by') String createdBy});
}

/// @nodoc
class __$$TagImplCopyWithImpl<$Res> extends _$TagCopyWithImpl<$Res, _$TagImpl>
    implements _$$TagImplCopyWith<$Res> {
  __$$TagImplCopyWithImpl(_$TagImpl _value, $Res Function(_$TagImpl) _then)
      : super(_value, _then);

  /// Create a copy of Tag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tagId = null,
    Object? cardId = null,
    Object? tagType = null,
    Object? tagContent = null,
    Object? createdAt = null,
    Object? createdBy = null,
  }) {
    return _then(_$TagImpl(
      tagId: null == tagId
          ? _value.tagId
          : tagId // ignore: cast_nullable_to_non_nullable
              as String,
      cardId: null == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
              as String,
      tagType: null == tagType
          ? _value.tagType
          : tagType // ignore: cast_nullable_to_non_nullable
              as String,
      tagContent: null == tagContent
          ? _value.tagContent
          : tagContent // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TagImpl extends _Tag {
  const _$TagImpl(
      {@JsonKey(name: 'tag_id') required this.tagId,
      @JsonKey(name: 'card_id') required this.cardId,
      @JsonKey(name: 'tag_type') required this.tagType,
      @JsonKey(name: 'tag_content') required this.tagContent,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'created_by') required this.createdBy})
      : super._();

  factory _$TagImpl.fromJson(Map<String, dynamic> json) =>
      _$$TagImplFromJson(json);

  /// Unique identifier for the tag
  @override
  @JsonKey(name: 'tag_id')
  final String tagId;

  /// ID of the card this tag is attached to
  @override
  @JsonKey(name: 'card_id')
  final String cardId;

  /// Type of tag (e.g., 'bonus', 'warning', 'info', 'late')
  @override
  @JsonKey(name: 'tag_type')
  final String tagType;

  /// Content/description of the tag
  @override
  @JsonKey(name: 'tag_content')
  final String tagContent;

  /// When the tag was created
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// User ID who created the tag
  @override
  @JsonKey(name: 'created_by')
  final String createdBy;

  @override
  String toString() {
    return 'Tag(tagId: $tagId, cardId: $cardId, tagType: $tagType, tagContent: $tagContent, createdAt: $createdAt, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TagImpl &&
            (identical(other.tagId, tagId) || other.tagId == tagId) &&
            (identical(other.cardId, cardId) || other.cardId == cardId) &&
            (identical(other.tagType, tagType) || other.tagType == tagType) &&
            (identical(other.tagContent, tagContent) ||
                other.tagContent == tagContent) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, tagId, cardId, tagType, tagContent, createdAt, createdBy);

  /// Create a copy of Tag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TagImplCopyWith<_$TagImpl> get copyWith =>
      __$$TagImplCopyWithImpl<_$TagImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TagImplToJson(
      this,
    );
  }
}

abstract class _Tag extends Tag {
  const factory _Tag(
          {@JsonKey(name: 'tag_id') required final String tagId,
          @JsonKey(name: 'card_id') required final String cardId,
          @JsonKey(name: 'tag_type') required final String tagType,
          @JsonKey(name: 'tag_content') required final String tagContent,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'created_by') required final String createdBy}) =
      _$TagImpl;
  const _Tag._() : super._();

  factory _Tag.fromJson(Map<String, dynamic> json) = _$TagImpl.fromJson;

  /// Unique identifier for the tag
  @override
  @JsonKey(name: 'tag_id')
  String get tagId;

  /// ID of the card this tag is attached to
  @override
  @JsonKey(name: 'card_id')
  String get cardId;

  /// Type of tag (e.g., 'bonus', 'warning', 'info', 'late')
  @override
  @JsonKey(name: 'tag_type')
  String get tagType;

  /// Content/description of the tag
  @override
  @JsonKey(name: 'tag_content')
  String get tagContent;

  /// When the tag was created
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// User ID who created the tag
  @override
  @JsonKey(name: 'created_by')
  String get createdBy;

  /// Create a copy of Tag
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TagImplCopyWith<_$TagImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
