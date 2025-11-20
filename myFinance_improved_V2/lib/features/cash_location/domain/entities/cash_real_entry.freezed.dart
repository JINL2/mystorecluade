// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cash_real_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CashRealEntry _$CashRealEntryFromJson(Map<String, dynamic> json) {
  return _CashRealEntry.fromJson(json);
}

/// @nodoc
mixin _$CashRealEntry {
  String get createdAt => throw _privateConstructorUsedError;
  String get recordDate => throw _privateConstructorUsedError;
  String get locationId => throw _privateConstructorUsedError;
  String get locationName => throw _privateConstructorUsedError;
  String get locationType => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  List<CurrencySummary> get currencySummary =>
      throw _privateConstructorUsedError;

  /// Serializes this CashRealEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CashRealEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CashRealEntryCopyWith<CashRealEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CashRealEntryCopyWith<$Res> {
  factory $CashRealEntryCopyWith(
          CashRealEntry value, $Res Function(CashRealEntry) then) =
      _$CashRealEntryCopyWithImpl<$Res, CashRealEntry>;
  @useResult
  $Res call(
      {String createdAt,
      String recordDate,
      String locationId,
      String locationName,
      String locationType,
      double totalAmount,
      List<CurrencySummary> currencySummary});
}

/// @nodoc
class _$CashRealEntryCopyWithImpl<$Res, $Val extends CashRealEntry>
    implements $CashRealEntryCopyWith<$Res> {
  _$CashRealEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CashRealEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? recordDate = null,
    Object? locationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? totalAmount = null,
    Object? currencySummary = null,
  }) {
    return _then(_value.copyWith(
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      recordDate: null == recordDate
          ? _value.recordDate
          : recordDate // ignore: cast_nullable_to_non_nullable
              as String,
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currencySummary: null == currencySummary
          ? _value.currencySummary
          : currencySummary // ignore: cast_nullable_to_non_nullable
              as List<CurrencySummary>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CashRealEntryImplCopyWith<$Res>
    implements $CashRealEntryCopyWith<$Res> {
  factory _$$CashRealEntryImplCopyWith(
          _$CashRealEntryImpl value, $Res Function(_$CashRealEntryImpl) then) =
      __$$CashRealEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String createdAt,
      String recordDate,
      String locationId,
      String locationName,
      String locationType,
      double totalAmount,
      List<CurrencySummary> currencySummary});
}

/// @nodoc
class __$$CashRealEntryImplCopyWithImpl<$Res>
    extends _$CashRealEntryCopyWithImpl<$Res, _$CashRealEntryImpl>
    implements _$$CashRealEntryImplCopyWith<$Res> {
  __$$CashRealEntryImplCopyWithImpl(
      _$CashRealEntryImpl _value, $Res Function(_$CashRealEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of CashRealEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? recordDate = null,
    Object? locationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? totalAmount = null,
    Object? currencySummary = null,
  }) {
    return _then(_$CashRealEntryImpl(
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      recordDate: null == recordDate
          ? _value.recordDate
          : recordDate // ignore: cast_nullable_to_non_nullable
              as String,
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currencySummary: null == currencySummary
          ? _value._currencySummary
          : currencySummary // ignore: cast_nullable_to_non_nullable
              as List<CurrencySummary>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CashRealEntryImpl extends _CashRealEntry {
  const _$CashRealEntryImpl(
      {required this.createdAt,
      required this.recordDate,
      required this.locationId,
      required this.locationName,
      required this.locationType,
      required this.totalAmount,
      required final List<CurrencySummary> currencySummary})
      : _currencySummary = currencySummary,
        super._();

  factory _$CashRealEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CashRealEntryImplFromJson(json);

  @override
  final String createdAt;
  @override
  final String recordDate;
  @override
  final String locationId;
  @override
  final String locationName;
  @override
  final String locationType;
  @override
  final double totalAmount;
  final List<CurrencySummary> _currencySummary;
  @override
  List<CurrencySummary> get currencySummary {
    if (_currencySummary is EqualUnmodifiableListView) return _currencySummary;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currencySummary);
  }

  @override
  String toString() {
    return 'CashRealEntry(createdAt: $createdAt, recordDate: $recordDate, locationId: $locationId, locationName: $locationName, locationType: $locationType, totalAmount: $totalAmount, currencySummary: $currencySummary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashRealEntryImpl &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.recordDate, recordDate) ||
                other.recordDate == recordDate) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.locationType, locationType) ||
                other.locationType == locationType) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            const DeepCollectionEquality()
                .equals(other._currencySummary, _currencySummary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      createdAt,
      recordDate,
      locationId,
      locationName,
      locationType,
      totalAmount,
      const DeepCollectionEquality().hash(_currencySummary));

  /// Create a copy of CashRealEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CashRealEntryImplCopyWith<_$CashRealEntryImpl> get copyWith =>
      __$$CashRealEntryImplCopyWithImpl<_$CashRealEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CashRealEntryImplToJson(
      this,
    );
  }
}

abstract class _CashRealEntry extends CashRealEntry {
  const factory _CashRealEntry(
          {required final String createdAt,
          required final String recordDate,
          required final String locationId,
          required final String locationName,
          required final String locationType,
          required final double totalAmount,
          required final List<CurrencySummary> currencySummary}) =
      _$CashRealEntryImpl;
  const _CashRealEntry._() : super._();

  factory _CashRealEntry.fromJson(Map<String, dynamic> json) =
      _$CashRealEntryImpl.fromJson;

  @override
  String get createdAt;
  @override
  String get recordDate;
  @override
  String get locationId;
  @override
  String get locationName;
  @override
  String get locationType;
  @override
  double get totalAmount;
  @override
  List<CurrencySummary> get currencySummary;

  /// Create a copy of CashRealEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CashRealEntryImplCopyWith<_$CashRealEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
