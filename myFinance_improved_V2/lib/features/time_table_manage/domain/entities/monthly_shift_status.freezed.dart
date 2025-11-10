// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_shift_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MonthlyShiftStatus _$MonthlyShiftStatusFromJson(Map<String, dynamic> json) {
  return _MonthlyShiftStatus.fromJson(json);
}

/// @nodoc
mixin _$MonthlyShiftStatus {
  /// Month in yyyy-MM format
  String get month => throw _privateConstructorUsedError;
  @JsonKey(name: 'daily_shifts', defaultValue: <DailyShiftData>[])
  List<DailyShiftData> get dailyShifts => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: <String, dynamic>{})
  Map<String, dynamic> get statistics => throw _privateConstructorUsedError;

  /// Serializes this MonthlyShiftStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyShiftStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyShiftStatusCopyWith<MonthlyShiftStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyShiftStatusCopyWith<$Res> {
  factory $MonthlyShiftStatusCopyWith(
          MonthlyShiftStatus value, $Res Function(MonthlyShiftStatus) then) =
      _$MonthlyShiftStatusCopyWithImpl<$Res, MonthlyShiftStatus>;
  @useResult
  $Res call(
      {String month,
      @JsonKey(name: 'daily_shifts', defaultValue: <DailyShiftData>[])
      List<DailyShiftData> dailyShifts,
      @JsonKey(defaultValue: <String, dynamic>{})
      Map<String, dynamic> statistics});
}

/// @nodoc
class _$MonthlyShiftStatusCopyWithImpl<$Res, $Val extends MonthlyShiftStatus>
    implements $MonthlyShiftStatusCopyWith<$Res> {
  _$MonthlyShiftStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyShiftStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? dailyShifts = null,
    Object? statistics = null,
  }) {
    return _then(_value.copyWith(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      dailyShifts: null == dailyShifts
          ? _value.dailyShifts
          : dailyShifts // ignore: cast_nullable_to_non_nullable
              as List<DailyShiftData>,
      statistics: null == statistics
          ? _value.statistics
          : statistics // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyShiftStatusImplCopyWith<$Res>
    implements $MonthlyShiftStatusCopyWith<$Res> {
  factory _$$MonthlyShiftStatusImplCopyWith(_$MonthlyShiftStatusImpl value,
          $Res Function(_$MonthlyShiftStatusImpl) then) =
      __$$MonthlyShiftStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String month,
      @JsonKey(name: 'daily_shifts', defaultValue: <DailyShiftData>[])
      List<DailyShiftData> dailyShifts,
      @JsonKey(defaultValue: <String, dynamic>{})
      Map<String, dynamic> statistics});
}

/// @nodoc
class __$$MonthlyShiftStatusImplCopyWithImpl<$Res>
    extends _$MonthlyShiftStatusCopyWithImpl<$Res, _$MonthlyShiftStatusImpl>
    implements _$$MonthlyShiftStatusImplCopyWith<$Res> {
  __$$MonthlyShiftStatusImplCopyWithImpl(_$MonthlyShiftStatusImpl _value,
      $Res Function(_$MonthlyShiftStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyShiftStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? dailyShifts = null,
    Object? statistics = null,
  }) {
    return _then(_$MonthlyShiftStatusImpl(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      dailyShifts: null == dailyShifts
          ? _value._dailyShifts
          : dailyShifts // ignore: cast_nullable_to_non_nullable
              as List<DailyShiftData>,
      statistics: null == statistics
          ? _value._statistics
          : statistics // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlyShiftStatusImpl extends _MonthlyShiftStatus {
  const _$MonthlyShiftStatusImpl(
      {required this.month,
      @JsonKey(name: 'daily_shifts', defaultValue: <DailyShiftData>[])
      required final List<DailyShiftData> dailyShifts,
      @JsonKey(defaultValue: <String, dynamic>{})
      required final Map<String, dynamic> statistics})
      : _dailyShifts = dailyShifts,
        _statistics = statistics,
        super._();

  factory _$MonthlyShiftStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlyShiftStatusImplFromJson(json);

  /// Month in yyyy-MM format
  @override
  final String month;
  final List<DailyShiftData> _dailyShifts;
  @override
  @JsonKey(name: 'daily_shifts', defaultValue: <DailyShiftData>[])
  List<DailyShiftData> get dailyShifts {
    if (_dailyShifts is EqualUnmodifiableListView) return _dailyShifts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyShifts);
  }

  final Map<String, dynamic> _statistics;
  @override
  @JsonKey(defaultValue: <String, dynamic>{})
  Map<String, dynamic> get statistics {
    if (_statistics is EqualUnmodifiableMapView) return _statistics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_statistics);
  }

  @override
  String toString() {
    return 'MonthlyShiftStatus(month: $month, dailyShifts: $dailyShifts, statistics: $statistics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyShiftStatusImpl &&
            (identical(other.month, month) || other.month == month) &&
            const DeepCollectionEquality()
                .equals(other._dailyShifts, _dailyShifts) &&
            const DeepCollectionEquality()
                .equals(other._statistics, _statistics));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      month,
      const DeepCollectionEquality().hash(_dailyShifts),
      const DeepCollectionEquality().hash(_statistics));

  /// Create a copy of MonthlyShiftStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyShiftStatusImplCopyWith<_$MonthlyShiftStatusImpl> get copyWith =>
      __$$MonthlyShiftStatusImplCopyWithImpl<_$MonthlyShiftStatusImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlyShiftStatusImplToJson(
      this,
    );
  }
}

abstract class _MonthlyShiftStatus extends MonthlyShiftStatus {
  const factory _MonthlyShiftStatus(
          {required final String month,
          @JsonKey(name: 'daily_shifts', defaultValue: <DailyShiftData>[])
          required final List<DailyShiftData> dailyShifts,
          @JsonKey(defaultValue: <String, dynamic>{})
          required final Map<String, dynamic> statistics}) =
      _$MonthlyShiftStatusImpl;
  const _MonthlyShiftStatus._() : super._();

  factory _MonthlyShiftStatus.fromJson(Map<String, dynamic> json) =
      _$MonthlyShiftStatusImpl.fromJson;

  /// Month in yyyy-MM format
  @override
  String get month;
  @override
  @JsonKey(name: 'daily_shifts', defaultValue: <DailyShiftData>[])
  List<DailyShiftData> get dailyShifts;
  @override
  @JsonKey(defaultValue: <String, dynamic>{})
  Map<String, dynamic> get statistics;

  /// Create a copy of MonthlyShiftStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyShiftStatusImplCopyWith<_$MonthlyShiftStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
