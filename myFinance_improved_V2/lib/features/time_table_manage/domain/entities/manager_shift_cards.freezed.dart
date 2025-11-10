// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manager_shift_cards.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ManagerShiftCards _$ManagerShiftCardsFromJson(Map<String, dynamic> json) {
  return _ManagerShiftCards.fromJson(json);
}

/// @nodoc
mixin _$ManagerShiftCards {
  /// The store ID these cards belong to
  @JsonKey(name: 'store_id', defaultValue: '')
  String get storeId => throw _privateConstructorUsedError;

  /// Start date of the range (yyyy-MM-dd format)
  @JsonKey(name: 'start_date', defaultValue: '')
  String get startDate => throw _privateConstructorUsedError;

  /// End date of the range (yyyy-MM-dd format)
  @JsonKey(name: 'end_date', defaultValue: '')
  String get endDate => throw _privateConstructorUsedError;

  /// List of all shift cards in the date range
  @JsonKey(defaultValue: <ShiftCard>[])
  List<ShiftCard> get cards => throw _privateConstructorUsedError;

  /// Serializes this ManagerShiftCards to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ManagerShiftCards
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManagerShiftCardsCopyWith<ManagerShiftCards> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagerShiftCardsCopyWith<$Res> {
  factory $ManagerShiftCardsCopyWith(
          ManagerShiftCards value, $Res Function(ManagerShiftCards) then) =
      _$ManagerShiftCardsCopyWithImpl<$Res, ManagerShiftCards>;
  @useResult
  $Res call(
      {@JsonKey(name: 'store_id', defaultValue: '') String storeId,
      @JsonKey(name: 'start_date', defaultValue: '') String startDate,
      @JsonKey(name: 'end_date', defaultValue: '') String endDate,
      @JsonKey(defaultValue: <ShiftCard>[]) List<ShiftCard> cards});
}

/// @nodoc
class _$ManagerShiftCardsCopyWithImpl<$Res, $Val extends ManagerShiftCards>
    implements $ManagerShiftCardsCopyWith<$Res> {
  _$ManagerShiftCardsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManagerShiftCards
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? cards = null,
  }) {
    return _then(_value.copyWith(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      cards: null == cards
          ? _value.cards
          : cards // ignore: cast_nullable_to_non_nullable
              as List<ShiftCard>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManagerShiftCardsImplCopyWith<$Res>
    implements $ManagerShiftCardsCopyWith<$Res> {
  factory _$$ManagerShiftCardsImplCopyWith(_$ManagerShiftCardsImpl value,
          $Res Function(_$ManagerShiftCardsImpl) then) =
      __$$ManagerShiftCardsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'store_id', defaultValue: '') String storeId,
      @JsonKey(name: 'start_date', defaultValue: '') String startDate,
      @JsonKey(name: 'end_date', defaultValue: '') String endDate,
      @JsonKey(defaultValue: <ShiftCard>[]) List<ShiftCard> cards});
}

/// @nodoc
class __$$ManagerShiftCardsImplCopyWithImpl<$Res>
    extends _$ManagerShiftCardsCopyWithImpl<$Res, _$ManagerShiftCardsImpl>
    implements _$$ManagerShiftCardsImplCopyWith<$Res> {
  __$$ManagerShiftCardsImplCopyWithImpl(_$ManagerShiftCardsImpl _value,
      $Res Function(_$ManagerShiftCardsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ManagerShiftCards
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? cards = null,
  }) {
    return _then(_$ManagerShiftCardsImpl(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      cards: null == cards
          ? _value._cards
          : cards // ignore: cast_nullable_to_non_nullable
              as List<ShiftCard>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ManagerShiftCardsImpl extends _ManagerShiftCards {
  const _$ManagerShiftCardsImpl(
      {@JsonKey(name: 'store_id', defaultValue: '') required this.storeId,
      @JsonKey(name: 'start_date', defaultValue: '') required this.startDate,
      @JsonKey(name: 'end_date', defaultValue: '') required this.endDate,
      @JsonKey(defaultValue: <ShiftCard>[])
      required final List<ShiftCard> cards})
      : _cards = cards,
        super._();

  factory _$ManagerShiftCardsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ManagerShiftCardsImplFromJson(json);

  /// The store ID these cards belong to
  @override
  @JsonKey(name: 'store_id', defaultValue: '')
  final String storeId;

  /// Start date of the range (yyyy-MM-dd format)
  @override
  @JsonKey(name: 'start_date', defaultValue: '')
  final String startDate;

  /// End date of the range (yyyy-MM-dd format)
  @override
  @JsonKey(name: 'end_date', defaultValue: '')
  final String endDate;

  /// List of all shift cards in the date range
  final List<ShiftCard> _cards;

  /// List of all shift cards in the date range
  @override
  @JsonKey(defaultValue: <ShiftCard>[])
  List<ShiftCard> get cards {
    if (_cards is EqualUnmodifiableListView) return _cards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cards);
  }

  @override
  String toString() {
    return 'ManagerShiftCards(storeId: $storeId, startDate: $startDate, endDate: $endDate, cards: $cards)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManagerShiftCardsImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality().equals(other._cards, _cards));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, storeId, startDate, endDate,
      const DeepCollectionEquality().hash(_cards));

  /// Create a copy of ManagerShiftCards
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManagerShiftCardsImplCopyWith<_$ManagerShiftCardsImpl> get copyWith =>
      __$$ManagerShiftCardsImplCopyWithImpl<_$ManagerShiftCardsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ManagerShiftCardsImplToJson(
      this,
    );
  }
}

abstract class _ManagerShiftCards extends ManagerShiftCards {
  const factory _ManagerShiftCards(
      {@JsonKey(name: 'store_id', defaultValue: '')
      required final String storeId,
      @JsonKey(name: 'start_date', defaultValue: '')
      required final String startDate,
      @JsonKey(name: 'end_date', defaultValue: '')
      required final String endDate,
      @JsonKey(defaultValue: <ShiftCard>[])
      required final List<ShiftCard> cards}) = _$ManagerShiftCardsImpl;
  const _ManagerShiftCards._() : super._();

  factory _ManagerShiftCards.fromJson(Map<String, dynamic> json) =
      _$ManagerShiftCardsImpl.fromJson;

  /// The store ID these cards belong to
  @override
  @JsonKey(name: 'store_id', defaultValue: '')
  String get storeId;

  /// Start date of the range (yyyy-MM-dd format)
  @override
  @JsonKey(name: 'start_date', defaultValue: '')
  String get startDate;

  /// End date of the range (yyyy-MM-dd format)
  @override
  @JsonKey(name: 'end_date', defaultValue: '')
  String get endDate;

  /// List of all shift cards in the date range
  @override
  @JsonKey(defaultValue: <ShiftCard>[])
  List<ShiftCard> get cards;

  /// Create a copy of ManagerShiftCards
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManagerShiftCardsImplCopyWith<_$ManagerShiftCardsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
