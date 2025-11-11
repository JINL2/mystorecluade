// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_cards_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StoreCardsDto _$StoreCardsDtoFromJson(Map<String, dynamic> json) {
  return _StoreCardsDto.fromJson(json);
}

/// @nodoc
mixin _$StoreCardsDto {
  @JsonKey(name: 'store_id')
  String? get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_name')
  String? get storeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'request_count')
  int get requestCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_count')
  int get approvedCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'problem_count')
  int get problemCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'cards')
  List<ShiftCardDto> get cards => throw _privateConstructorUsedError;

  /// Serializes this StoreCardsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoreCardsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreCardsDtoCopyWith<StoreCardsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreCardsDtoCopyWith<$Res> {
  factory $StoreCardsDtoCopyWith(
          StoreCardsDto value, $Res Function(StoreCardsDto) then) =
      _$StoreCardsDtoCopyWithImpl<$Res, StoreCardsDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'store_name') String? storeName,
      @JsonKey(name: 'request_count') int requestCount,
      @JsonKey(name: 'approved_count') int approvedCount,
      @JsonKey(name: 'problem_count') int problemCount,
      @JsonKey(name: 'cards') List<ShiftCardDto> cards});
}

/// @nodoc
class _$StoreCardsDtoCopyWithImpl<$Res, $Val extends StoreCardsDto>
    implements $StoreCardsDtoCopyWith<$Res> {
  _$StoreCardsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreCardsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = freezed,
    Object? storeName = freezed,
    Object? requestCount = null,
    Object? approvedCount = null,
    Object? problemCount = null,
    Object? cards = null,
  }) {
    return _then(_value.copyWith(
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      requestCount: null == requestCount
          ? _value.requestCount
          : requestCount // ignore: cast_nullable_to_non_nullable
              as int,
      approvedCount: null == approvedCount
          ? _value.approvedCount
          : approvedCount // ignore: cast_nullable_to_non_nullable
              as int,
      problemCount: null == problemCount
          ? _value.problemCount
          : problemCount // ignore: cast_nullable_to_non_nullable
              as int,
      cards: null == cards
          ? _value.cards
          : cards // ignore: cast_nullable_to_non_nullable
              as List<ShiftCardDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoreCardsDtoImplCopyWith<$Res>
    implements $StoreCardsDtoCopyWith<$Res> {
  factory _$$StoreCardsDtoImplCopyWith(
          _$StoreCardsDtoImpl value, $Res Function(_$StoreCardsDtoImpl) then) =
      __$$StoreCardsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'store_name') String? storeName,
      @JsonKey(name: 'request_count') int requestCount,
      @JsonKey(name: 'approved_count') int approvedCount,
      @JsonKey(name: 'problem_count') int problemCount,
      @JsonKey(name: 'cards') List<ShiftCardDto> cards});
}

/// @nodoc
class __$$StoreCardsDtoImplCopyWithImpl<$Res>
    extends _$StoreCardsDtoCopyWithImpl<$Res, _$StoreCardsDtoImpl>
    implements _$$StoreCardsDtoImplCopyWith<$Res> {
  __$$StoreCardsDtoImplCopyWithImpl(
      _$StoreCardsDtoImpl _value, $Res Function(_$StoreCardsDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoreCardsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = freezed,
    Object? storeName = freezed,
    Object? requestCount = null,
    Object? approvedCount = null,
    Object? problemCount = null,
    Object? cards = null,
  }) {
    return _then(_$StoreCardsDtoImpl(
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      requestCount: null == requestCount
          ? _value.requestCount
          : requestCount // ignore: cast_nullable_to_non_nullable
              as int,
      approvedCount: null == approvedCount
          ? _value.approvedCount
          : approvedCount // ignore: cast_nullable_to_non_nullable
              as int,
      problemCount: null == problemCount
          ? _value.problemCount
          : problemCount // ignore: cast_nullable_to_non_nullable
              as int,
      cards: null == cards
          ? _value._cards
          : cards // ignore: cast_nullable_to_non_nullable
              as List<ShiftCardDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreCardsDtoImpl implements _StoreCardsDto {
  const _$StoreCardsDtoImpl(
      {@JsonKey(name: 'store_id') this.storeId,
      @JsonKey(name: 'store_name') this.storeName,
      @JsonKey(name: 'request_count') this.requestCount = 0,
      @JsonKey(name: 'approved_count') this.approvedCount = 0,
      @JsonKey(name: 'problem_count') this.problemCount = 0,
      @JsonKey(name: 'cards') final List<ShiftCardDto> cards = const []})
      : _cards = cards;

  factory _$StoreCardsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreCardsDtoImplFromJson(json);

  @override
  @JsonKey(name: 'store_id')
  final String? storeId;
  @override
  @JsonKey(name: 'store_name')
  final String? storeName;
  @override
  @JsonKey(name: 'request_count')
  final int requestCount;
  @override
  @JsonKey(name: 'approved_count')
  final int approvedCount;
  @override
  @JsonKey(name: 'problem_count')
  final int problemCount;
  final List<ShiftCardDto> _cards;
  @override
  @JsonKey(name: 'cards')
  List<ShiftCardDto> get cards {
    if (_cards is EqualUnmodifiableListView) return _cards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cards);
  }

  @override
  String toString() {
    return 'StoreCardsDto(storeId: $storeId, storeName: $storeName, requestCount: $requestCount, approvedCount: $approvedCount, problemCount: $problemCount, cards: $cards)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreCardsDtoImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.requestCount, requestCount) ||
                other.requestCount == requestCount) &&
            (identical(other.approvedCount, approvedCount) ||
                other.approvedCount == approvedCount) &&
            (identical(other.problemCount, problemCount) ||
                other.problemCount == problemCount) &&
            const DeepCollectionEquality().equals(other._cards, _cards));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, storeId, storeName, requestCount,
      approvedCount, problemCount, const DeepCollectionEquality().hash(_cards));

  /// Create a copy of StoreCardsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreCardsDtoImplCopyWith<_$StoreCardsDtoImpl> get copyWith =>
      __$$StoreCardsDtoImplCopyWithImpl<_$StoreCardsDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreCardsDtoImplToJson(
      this,
    );
  }
}

abstract class _StoreCardsDto implements StoreCardsDto {
  const factory _StoreCardsDto(
          {@JsonKey(name: 'store_id') final String? storeId,
          @JsonKey(name: 'store_name') final String? storeName,
          @JsonKey(name: 'request_count') final int requestCount,
          @JsonKey(name: 'approved_count') final int approvedCount,
          @JsonKey(name: 'problem_count') final int problemCount,
          @JsonKey(name: 'cards') final List<ShiftCardDto> cards}) =
      _$StoreCardsDtoImpl;

  factory _StoreCardsDto.fromJson(Map<String, dynamic> json) =
      _$StoreCardsDtoImpl.fromJson;

  @override
  @JsonKey(name: 'store_id')
  String? get storeId;
  @override
  @JsonKey(name: 'store_name')
  String? get storeName;
  @override
  @JsonKey(name: 'request_count')
  int get requestCount;
  @override
  @JsonKey(name: 'approved_count')
  int get approvedCount;
  @override
  @JsonKey(name: 'problem_count')
  int get problemCount;
  @override
  @JsonKey(name: 'cards')
  List<ShiftCardDto> get cards;

  /// Create a copy of StoreCardsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreCardsDtoImplCopyWith<_$StoreCardsDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
