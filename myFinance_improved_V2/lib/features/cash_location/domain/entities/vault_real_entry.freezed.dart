// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vault_real_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VaultRealEntry _$VaultRealEntryFromJson(Map<String, dynamic> json) {
  return _VaultRealEntry.fromJson(json);
}

/// @nodoc
mixin _$VaultRealEntry {
  String get createdAt => throw _privateConstructorUsedError;
  String get recordDate => throw _privateConstructorUsedError;
  String get locationId => throw _privateConstructorUsedError;
  String get locationName => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  List<CurrencySummary> get currencySummary =>
      throw _privateConstructorUsedError;

  /// Serializes this VaultRealEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VaultRealEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VaultRealEntryCopyWith<VaultRealEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VaultRealEntryCopyWith<$Res> {
  factory $VaultRealEntryCopyWith(
          VaultRealEntry value, $Res Function(VaultRealEntry) then) =
      _$VaultRealEntryCopyWithImpl<$Res, VaultRealEntry>;
  @useResult
  $Res call(
      {String createdAt,
      String recordDate,
      String locationId,
      String locationName,
      double totalAmount,
      List<CurrencySummary> currencySummary});
}

/// @nodoc
class _$VaultRealEntryCopyWithImpl<$Res, $Val extends VaultRealEntry>
    implements $VaultRealEntryCopyWith<$Res> {
  _$VaultRealEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VaultRealEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? recordDate = null,
    Object? locationId = null,
    Object? locationName = null,
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
abstract class _$$VaultRealEntryImplCopyWith<$Res>
    implements $VaultRealEntryCopyWith<$Res> {
  factory _$$VaultRealEntryImplCopyWith(_$VaultRealEntryImpl value,
          $Res Function(_$VaultRealEntryImpl) then) =
      __$$VaultRealEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String createdAt,
      String recordDate,
      String locationId,
      String locationName,
      double totalAmount,
      List<CurrencySummary> currencySummary});
}

/// @nodoc
class __$$VaultRealEntryImplCopyWithImpl<$Res>
    extends _$VaultRealEntryCopyWithImpl<$Res, _$VaultRealEntryImpl>
    implements _$$VaultRealEntryImplCopyWith<$Res> {
  __$$VaultRealEntryImplCopyWithImpl(
      _$VaultRealEntryImpl _value, $Res Function(_$VaultRealEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of VaultRealEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? recordDate = null,
    Object? locationId = null,
    Object? locationName = null,
    Object? totalAmount = null,
    Object? currencySummary = null,
  }) {
    return _then(_$VaultRealEntryImpl(
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
class _$VaultRealEntryImpl extends _VaultRealEntry {
  const _$VaultRealEntryImpl(
      {required this.createdAt,
      required this.recordDate,
      required this.locationId,
      required this.locationName,
      required this.totalAmount,
      required final List<CurrencySummary> currencySummary})
      : _currencySummary = currencySummary,
        super._();

  factory _$VaultRealEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$VaultRealEntryImplFromJson(json);

  @override
  final String createdAt;
  @override
  final String recordDate;
  @override
  final String locationId;
  @override
  final String locationName;
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
    return 'VaultRealEntry(createdAt: $createdAt, recordDate: $recordDate, locationId: $locationId, locationName: $locationName, totalAmount: $totalAmount, currencySummary: $currencySummary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VaultRealEntryImpl &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.recordDate, recordDate) ||
                other.recordDate == recordDate) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
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
      totalAmount,
      const DeepCollectionEquality().hash(_currencySummary));

  /// Create a copy of VaultRealEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VaultRealEntryImplCopyWith<_$VaultRealEntryImpl> get copyWith =>
      __$$VaultRealEntryImplCopyWithImpl<_$VaultRealEntryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VaultRealEntryImplToJson(
      this,
    );
  }
}

abstract class _VaultRealEntry extends VaultRealEntry {
  const factory _VaultRealEntry(
          {required final String createdAt,
          required final String recordDate,
          required final String locationId,
          required final String locationName,
          required final double totalAmount,
          required final List<CurrencySummary> currencySummary}) =
      _$VaultRealEntryImpl;
  const _VaultRealEntry._() : super._();

  factory _VaultRealEntry.fromJson(Map<String, dynamic> json) =
      _$VaultRealEntryImpl.fromJson;

  @override
  String get createdAt;
  @override
  String get recordDate;
  @override
  String get locationId;
  @override
  String get locationName;
  @override
  double get totalAmount;
  @override
  List<CurrencySummary> get currencySummary;

  /// Create a copy of VaultRealEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VaultRealEntryImplCopyWith<_$VaultRealEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
