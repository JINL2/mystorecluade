// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'counter_party_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CounterPartyData {
  List<CounterParty> get counterParties => throw _privateConstructorUsedError;
  CounterPartyStats get stats => throw _privateConstructorUsedError;
  DateTime get fetchedAt => throw _privateConstructorUsedError;

  /// Create a copy of CounterPartyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CounterPartyDataCopyWith<CounterPartyData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CounterPartyDataCopyWith<$Res> {
  factory $CounterPartyDataCopyWith(
          CounterPartyData value, $Res Function(CounterPartyData) then) =
      _$CounterPartyDataCopyWithImpl<$Res, CounterPartyData>;
  @useResult
  $Res call(
      {List<CounterParty> counterParties,
      CounterPartyStats stats,
      DateTime fetchedAt});

  $CounterPartyStatsCopyWith<$Res> get stats;
}

/// @nodoc
class _$CounterPartyDataCopyWithImpl<$Res, $Val extends CounterPartyData>
    implements $CounterPartyDataCopyWith<$Res> {
  _$CounterPartyDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CounterPartyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterParties = null,
    Object? stats = null,
    Object? fetchedAt = null,
  }) {
    return _then(_value.copyWith(
      counterParties: null == counterParties
          ? _value.counterParties
          : counterParties // ignore: cast_nullable_to_non_nullable
              as List<CounterParty>,
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as CounterPartyStats,
      fetchedAt: null == fetchedAt
          ? _value.fetchedAt
          : fetchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of CounterPartyData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CounterPartyStatsCopyWith<$Res> get stats {
    return $CounterPartyStatsCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CounterPartyDataImplCopyWith<$Res>
    implements $CounterPartyDataCopyWith<$Res> {
  factory _$$CounterPartyDataImplCopyWith(_$CounterPartyDataImpl value,
          $Res Function(_$CounterPartyDataImpl) then) =
      __$$CounterPartyDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<CounterParty> counterParties,
      CounterPartyStats stats,
      DateTime fetchedAt});

  @override
  $CounterPartyStatsCopyWith<$Res> get stats;
}

/// @nodoc
class __$$CounterPartyDataImplCopyWithImpl<$Res>
    extends _$CounterPartyDataCopyWithImpl<$Res, _$CounterPartyDataImpl>
    implements _$$CounterPartyDataImplCopyWith<$Res> {
  __$$CounterPartyDataImplCopyWithImpl(_$CounterPartyDataImpl _value,
      $Res Function(_$CounterPartyDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of CounterPartyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterParties = null,
    Object? stats = null,
    Object? fetchedAt = null,
  }) {
    return _then(_$CounterPartyDataImpl(
      counterParties: null == counterParties
          ? _value._counterParties
          : counterParties // ignore: cast_nullable_to_non_nullable
              as List<CounterParty>,
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as CounterPartyStats,
      fetchedAt: null == fetchedAt
          ? _value.fetchedAt
          : fetchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$CounterPartyDataImpl extends _CounterPartyData {
  const _$CounterPartyDataImpl(
      {required final List<CounterParty> counterParties,
      required this.stats,
      required this.fetchedAt})
      : _counterParties = counterParties,
        super._();

  final List<CounterParty> _counterParties;
  @override
  List<CounterParty> get counterParties {
    if (_counterParties is EqualUnmodifiableListView) return _counterParties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_counterParties);
  }

  @override
  final CounterPartyStats stats;
  @override
  final DateTime fetchedAt;

  @override
  String toString() {
    return 'CounterPartyData(counterParties: $counterParties, stats: $stats, fetchedAt: $fetchedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CounterPartyDataImpl &&
            const DeepCollectionEquality()
                .equals(other._counterParties, _counterParties) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.fetchedAt, fetchedAt) ||
                other.fetchedAt == fetchedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_counterParties), stats, fetchedAt);

  /// Create a copy of CounterPartyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CounterPartyDataImplCopyWith<_$CounterPartyDataImpl> get copyWith =>
      __$$CounterPartyDataImplCopyWithImpl<_$CounterPartyDataImpl>(
          this, _$identity);
}

abstract class _CounterPartyData extends CounterPartyData {
  const factory _CounterPartyData(
      {required final List<CounterParty> counterParties,
      required final CounterPartyStats stats,
      required final DateTime fetchedAt}) = _$CounterPartyDataImpl;
  const _CounterPartyData._() : super._();

  @override
  List<CounterParty> get counterParties;
  @override
  CounterPartyStats get stats;
  @override
  DateTime get fetchedAt;

  /// Create a copy of CounterPartyData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CounterPartyDataImplCopyWith<_$CounterPartyDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
