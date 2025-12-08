// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reliability_score_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReliabilityScoreDto _$ReliabilityScoreDtoFromJson(Map<String, dynamic> json) {
  return _ReliabilityScoreDto.fromJson(json);
}

/// @nodoc
mixin _$ReliabilityScoreDto {
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'period_start')
  String? get periodStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'period_end')
  String? get periodEnd => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_summary')
  ShiftSummaryDto get shiftSummary => throw _privateConstructorUsedError;
  @JsonKey(name: 'understaffed_shifts')
  UnderstaffedShiftsDto get understaffedShifts =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'employees')
  List<EmployeeReliabilityDto> get employees =>
      throw _privateConstructorUsedError;

  /// Serializes this ReliabilityScoreDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReliabilityScoreDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReliabilityScoreDtoCopyWith<ReliabilityScoreDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReliabilityScoreDtoCopyWith<$Res> {
  factory $ReliabilityScoreDtoCopyWith(
          ReliabilityScoreDto value, $Res Function(ReliabilityScoreDto) then) =
      _$ReliabilityScoreDtoCopyWithImpl<$Res, ReliabilityScoreDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'period_start') String? periodStart,
      @JsonKey(name: 'period_end') String? periodEnd,
      @JsonKey(name: 'shift_summary') ShiftSummaryDto shiftSummary,
      @JsonKey(name: 'understaffed_shifts')
      UnderstaffedShiftsDto understaffedShifts,
      @JsonKey(name: 'employees') List<EmployeeReliabilityDto> employees});

  $ShiftSummaryDtoCopyWith<$Res> get shiftSummary;
  $UnderstaffedShiftsDtoCopyWith<$Res> get understaffedShifts;
}

/// @nodoc
class _$ReliabilityScoreDtoCopyWithImpl<$Res, $Val extends ReliabilityScoreDto>
    implements $ReliabilityScoreDtoCopyWith<$Res> {
  _$ReliabilityScoreDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReliabilityScoreDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyId = null,
    Object? periodStart = freezed,
    Object? periodEnd = freezed,
    Object? shiftSummary = null,
    Object? understaffedShifts = null,
    Object? employees = null,
  }) {
    return _then(_value.copyWith(
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      periodStart: freezed == periodStart
          ? _value.periodStart
          : periodStart // ignore: cast_nullable_to_non_nullable
              as String?,
      periodEnd: freezed == periodEnd
          ? _value.periodEnd
          : periodEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      shiftSummary: null == shiftSummary
          ? _value.shiftSummary
          : shiftSummary // ignore: cast_nullable_to_non_nullable
              as ShiftSummaryDto,
      understaffedShifts: null == understaffedShifts
          ? _value.understaffedShifts
          : understaffedShifts // ignore: cast_nullable_to_non_nullable
              as UnderstaffedShiftsDto,
      employees: null == employees
          ? _value.employees
          : employees // ignore: cast_nullable_to_non_nullable
              as List<EmployeeReliabilityDto>,
    ) as $Val);
  }

  /// Create a copy of ReliabilityScoreDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShiftSummaryDtoCopyWith<$Res> get shiftSummary {
    return $ShiftSummaryDtoCopyWith<$Res>(_value.shiftSummary, (value) {
      return _then(_value.copyWith(shiftSummary: value) as $Val);
    });
  }

  /// Create a copy of ReliabilityScoreDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UnderstaffedShiftsDtoCopyWith<$Res> get understaffedShifts {
    return $UnderstaffedShiftsDtoCopyWith<$Res>(_value.understaffedShifts,
        (value) {
      return _then(_value.copyWith(understaffedShifts: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReliabilityScoreDtoImplCopyWith<$Res>
    implements $ReliabilityScoreDtoCopyWith<$Res> {
  factory _$$ReliabilityScoreDtoImplCopyWith(_$ReliabilityScoreDtoImpl value,
          $Res Function(_$ReliabilityScoreDtoImpl) then) =
      __$$ReliabilityScoreDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'period_start') String? periodStart,
      @JsonKey(name: 'period_end') String? periodEnd,
      @JsonKey(name: 'shift_summary') ShiftSummaryDto shiftSummary,
      @JsonKey(name: 'understaffed_shifts')
      UnderstaffedShiftsDto understaffedShifts,
      @JsonKey(name: 'employees') List<EmployeeReliabilityDto> employees});

  @override
  $ShiftSummaryDtoCopyWith<$Res> get shiftSummary;
  @override
  $UnderstaffedShiftsDtoCopyWith<$Res> get understaffedShifts;
}

/// @nodoc
class __$$ReliabilityScoreDtoImplCopyWithImpl<$Res>
    extends _$ReliabilityScoreDtoCopyWithImpl<$Res, _$ReliabilityScoreDtoImpl>
    implements _$$ReliabilityScoreDtoImplCopyWith<$Res> {
  __$$ReliabilityScoreDtoImplCopyWithImpl(_$ReliabilityScoreDtoImpl _value,
      $Res Function(_$ReliabilityScoreDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReliabilityScoreDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyId = null,
    Object? periodStart = freezed,
    Object? periodEnd = freezed,
    Object? shiftSummary = null,
    Object? understaffedShifts = null,
    Object? employees = null,
  }) {
    return _then(_$ReliabilityScoreDtoImpl(
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      periodStart: freezed == periodStart
          ? _value.periodStart
          : periodStart // ignore: cast_nullable_to_non_nullable
              as String?,
      periodEnd: freezed == periodEnd
          ? _value.periodEnd
          : periodEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      shiftSummary: null == shiftSummary
          ? _value.shiftSummary
          : shiftSummary // ignore: cast_nullable_to_non_nullable
              as ShiftSummaryDto,
      understaffedShifts: null == understaffedShifts
          ? _value.understaffedShifts
          : understaffedShifts // ignore: cast_nullable_to_non_nullable
              as UnderstaffedShiftsDto,
      employees: null == employees
          ? _value._employees
          : employees // ignore: cast_nullable_to_non_nullable
              as List<EmployeeReliabilityDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReliabilityScoreDtoImpl implements _ReliabilityScoreDto {
  const _$ReliabilityScoreDtoImpl(
      {@JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'period_start') this.periodStart,
      @JsonKey(name: 'period_end') this.periodEnd,
      @JsonKey(name: 'shift_summary') required this.shiftSummary,
      @JsonKey(name: 'understaffed_shifts') required this.understaffedShifts,
      @JsonKey(name: 'employees')
      final List<EmployeeReliabilityDto> employees = const []})
      : _employees = employees;

  factory _$ReliabilityScoreDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReliabilityScoreDtoImplFromJson(json);

  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'period_start')
  final String? periodStart;
  @override
  @JsonKey(name: 'period_end')
  final String? periodEnd;
  @override
  @JsonKey(name: 'shift_summary')
  final ShiftSummaryDto shiftSummary;
  @override
  @JsonKey(name: 'understaffed_shifts')
  final UnderstaffedShiftsDto understaffedShifts;
  final List<EmployeeReliabilityDto> _employees;
  @override
  @JsonKey(name: 'employees')
  List<EmployeeReliabilityDto> get employees {
    if (_employees is EqualUnmodifiableListView) return _employees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_employees);
  }

  @override
  String toString() {
    return 'ReliabilityScoreDto(companyId: $companyId, periodStart: $periodStart, periodEnd: $periodEnd, shiftSummary: $shiftSummary, understaffedShifts: $understaffedShifts, employees: $employees)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReliabilityScoreDtoImpl &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.periodStart, periodStart) ||
                other.periodStart == periodStart) &&
            (identical(other.periodEnd, periodEnd) ||
                other.periodEnd == periodEnd) &&
            (identical(other.shiftSummary, shiftSummary) ||
                other.shiftSummary == shiftSummary) &&
            (identical(other.understaffedShifts, understaffedShifts) ||
                other.understaffedShifts == understaffedShifts) &&
            const DeepCollectionEquality()
                .equals(other._employees, _employees));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      companyId,
      periodStart,
      periodEnd,
      shiftSummary,
      understaffedShifts,
      const DeepCollectionEquality().hash(_employees));

  /// Create a copy of ReliabilityScoreDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReliabilityScoreDtoImplCopyWith<_$ReliabilityScoreDtoImpl> get copyWith =>
      __$$ReliabilityScoreDtoImplCopyWithImpl<_$ReliabilityScoreDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReliabilityScoreDtoImplToJson(
      this,
    );
  }
}

abstract class _ReliabilityScoreDto implements ReliabilityScoreDto {
  const factory _ReliabilityScoreDto(
          {@JsonKey(name: 'company_id') required final String companyId,
          @JsonKey(name: 'period_start') final String? periodStart,
          @JsonKey(name: 'period_end') final String? periodEnd,
          @JsonKey(name: 'shift_summary')
          required final ShiftSummaryDto shiftSummary,
          @JsonKey(name: 'understaffed_shifts')
          required final UnderstaffedShiftsDto understaffedShifts,
          @JsonKey(name: 'employees')
          final List<EmployeeReliabilityDto> employees}) =
      _$ReliabilityScoreDtoImpl;

  factory _ReliabilityScoreDto.fromJson(Map<String, dynamic> json) =
      _$ReliabilityScoreDtoImpl.fromJson;

  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'period_start')
  String? get periodStart;
  @override
  @JsonKey(name: 'period_end')
  String? get periodEnd;
  @override
  @JsonKey(name: 'shift_summary')
  ShiftSummaryDto get shiftSummary;
  @override
  @JsonKey(name: 'understaffed_shifts')
  UnderstaffedShiftsDto get understaffedShifts;
  @override
  @JsonKey(name: 'employees')
  List<EmployeeReliabilityDto> get employees;

  /// Create a copy of ReliabilityScoreDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReliabilityScoreDtoImplCopyWith<_$ReliabilityScoreDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ShiftSummaryDto _$ShiftSummaryDtoFromJson(Map<String, dynamic> json) {
  return _ShiftSummaryDto.fromJson(json);
}

/// @nodoc
mixin _$ShiftSummaryDto {
  @JsonKey(name: 'today')
  PeriodStatsDto get today => throw _privateConstructorUsedError;
  @JsonKey(name: 'yesterday')
  PeriodStatsDto get yesterday => throw _privateConstructorUsedError;
  @JsonKey(name: 'this_month')
  PeriodStatsDto get thisMonth => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_month')
  PeriodStatsDto get lastMonth => throw _privateConstructorUsedError;
  @JsonKey(name: 'two_months_ago')
  PeriodStatsDto get twoMonthsAgo => throw _privateConstructorUsedError;

  /// Serializes this ShiftSummaryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShiftSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftSummaryDtoCopyWith<ShiftSummaryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftSummaryDtoCopyWith<$Res> {
  factory $ShiftSummaryDtoCopyWith(
          ShiftSummaryDto value, $Res Function(ShiftSummaryDto) then) =
      _$ShiftSummaryDtoCopyWithImpl<$Res, ShiftSummaryDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'today') PeriodStatsDto today,
      @JsonKey(name: 'yesterday') PeriodStatsDto yesterday,
      @JsonKey(name: 'this_month') PeriodStatsDto thisMonth,
      @JsonKey(name: 'last_month') PeriodStatsDto lastMonth,
      @JsonKey(name: 'two_months_ago') PeriodStatsDto twoMonthsAgo});

  $PeriodStatsDtoCopyWith<$Res> get today;
  $PeriodStatsDtoCopyWith<$Res> get yesterday;
  $PeriodStatsDtoCopyWith<$Res> get thisMonth;
  $PeriodStatsDtoCopyWith<$Res> get lastMonth;
  $PeriodStatsDtoCopyWith<$Res> get twoMonthsAgo;
}

/// @nodoc
class _$ShiftSummaryDtoCopyWithImpl<$Res, $Val extends ShiftSummaryDto>
    implements $ShiftSummaryDtoCopyWith<$Res> {
  _$ShiftSummaryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? today = null,
    Object? yesterday = null,
    Object? thisMonth = null,
    Object? lastMonth = null,
    Object? twoMonthsAgo = null,
  }) {
    return _then(_value.copyWith(
      today: null == today
          ? _value.today
          : today // ignore: cast_nullable_to_non_nullable
              as PeriodStatsDto,
      yesterday: null == yesterday
          ? _value.yesterday
          : yesterday // ignore: cast_nullable_to_non_nullable
              as PeriodStatsDto,
      thisMonth: null == thisMonth
          ? _value.thisMonth
          : thisMonth // ignore: cast_nullable_to_non_nullable
              as PeriodStatsDto,
      lastMonth: null == lastMonth
          ? _value.lastMonth
          : lastMonth // ignore: cast_nullable_to_non_nullable
              as PeriodStatsDto,
      twoMonthsAgo: null == twoMonthsAgo
          ? _value.twoMonthsAgo
          : twoMonthsAgo // ignore: cast_nullable_to_non_nullable
              as PeriodStatsDto,
    ) as $Val);
  }

  /// Create a copy of ShiftSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PeriodStatsDtoCopyWith<$Res> get today {
    return $PeriodStatsDtoCopyWith<$Res>(_value.today, (value) {
      return _then(_value.copyWith(today: value) as $Val);
    });
  }

  /// Create a copy of ShiftSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PeriodStatsDtoCopyWith<$Res> get yesterday {
    return $PeriodStatsDtoCopyWith<$Res>(_value.yesterday, (value) {
      return _then(_value.copyWith(yesterday: value) as $Val);
    });
  }

  /// Create a copy of ShiftSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PeriodStatsDtoCopyWith<$Res> get thisMonth {
    return $PeriodStatsDtoCopyWith<$Res>(_value.thisMonth, (value) {
      return _then(_value.copyWith(thisMonth: value) as $Val);
    });
  }

  /// Create a copy of ShiftSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PeriodStatsDtoCopyWith<$Res> get lastMonth {
    return $PeriodStatsDtoCopyWith<$Res>(_value.lastMonth, (value) {
      return _then(_value.copyWith(lastMonth: value) as $Val);
    });
  }

  /// Create a copy of ShiftSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PeriodStatsDtoCopyWith<$Res> get twoMonthsAgo {
    return $PeriodStatsDtoCopyWith<$Res>(_value.twoMonthsAgo, (value) {
      return _then(_value.copyWith(twoMonthsAgo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ShiftSummaryDtoImplCopyWith<$Res>
    implements $ShiftSummaryDtoCopyWith<$Res> {
  factory _$$ShiftSummaryDtoImplCopyWith(_$ShiftSummaryDtoImpl value,
          $Res Function(_$ShiftSummaryDtoImpl) then) =
      __$$ShiftSummaryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'today') PeriodStatsDto today,
      @JsonKey(name: 'yesterday') PeriodStatsDto yesterday,
      @JsonKey(name: 'this_month') PeriodStatsDto thisMonth,
      @JsonKey(name: 'last_month') PeriodStatsDto lastMonth,
      @JsonKey(name: 'two_months_ago') PeriodStatsDto twoMonthsAgo});

  @override
  $PeriodStatsDtoCopyWith<$Res> get today;
  @override
  $PeriodStatsDtoCopyWith<$Res> get yesterday;
  @override
  $PeriodStatsDtoCopyWith<$Res> get thisMonth;
  @override
  $PeriodStatsDtoCopyWith<$Res> get lastMonth;
  @override
  $PeriodStatsDtoCopyWith<$Res> get twoMonthsAgo;
}

/// @nodoc
class __$$ShiftSummaryDtoImplCopyWithImpl<$Res>
    extends _$ShiftSummaryDtoCopyWithImpl<$Res, _$ShiftSummaryDtoImpl>
    implements _$$ShiftSummaryDtoImplCopyWith<$Res> {
  __$$ShiftSummaryDtoImplCopyWithImpl(
      _$ShiftSummaryDtoImpl _value, $Res Function(_$ShiftSummaryDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShiftSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? today = null,
    Object? yesterday = null,
    Object? thisMonth = null,
    Object? lastMonth = null,
    Object? twoMonthsAgo = null,
  }) {
    return _then(_$ShiftSummaryDtoImpl(
      today: null == today
          ? _value.today
          : today // ignore: cast_nullable_to_non_nullable
              as PeriodStatsDto,
      yesterday: null == yesterday
          ? _value.yesterday
          : yesterday // ignore: cast_nullable_to_non_nullable
              as PeriodStatsDto,
      thisMonth: null == thisMonth
          ? _value.thisMonth
          : thisMonth // ignore: cast_nullable_to_non_nullable
              as PeriodStatsDto,
      lastMonth: null == lastMonth
          ? _value.lastMonth
          : lastMonth // ignore: cast_nullable_to_non_nullable
              as PeriodStatsDto,
      twoMonthsAgo: null == twoMonthsAgo
          ? _value.twoMonthsAgo
          : twoMonthsAgo // ignore: cast_nullable_to_non_nullable
              as PeriodStatsDto,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShiftSummaryDtoImpl implements _ShiftSummaryDto {
  const _$ShiftSummaryDtoImpl(
      {@JsonKey(name: 'today') required this.today,
      @JsonKey(name: 'yesterday') required this.yesterday,
      @JsonKey(name: 'this_month') required this.thisMonth,
      @JsonKey(name: 'last_month') required this.lastMonth,
      @JsonKey(name: 'two_months_ago') required this.twoMonthsAgo});

  factory _$ShiftSummaryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftSummaryDtoImplFromJson(json);

  @override
  @JsonKey(name: 'today')
  final PeriodStatsDto today;
  @override
  @JsonKey(name: 'yesterday')
  final PeriodStatsDto yesterday;
  @override
  @JsonKey(name: 'this_month')
  final PeriodStatsDto thisMonth;
  @override
  @JsonKey(name: 'last_month')
  final PeriodStatsDto lastMonth;
  @override
  @JsonKey(name: 'two_months_ago')
  final PeriodStatsDto twoMonthsAgo;

  @override
  String toString() {
    return 'ShiftSummaryDto(today: $today, yesterday: $yesterday, thisMonth: $thisMonth, lastMonth: $lastMonth, twoMonthsAgo: $twoMonthsAgo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftSummaryDtoImpl &&
            (identical(other.today, today) || other.today == today) &&
            (identical(other.yesterday, yesterday) ||
                other.yesterday == yesterday) &&
            (identical(other.thisMonth, thisMonth) ||
                other.thisMonth == thisMonth) &&
            (identical(other.lastMonth, lastMonth) ||
                other.lastMonth == lastMonth) &&
            (identical(other.twoMonthsAgo, twoMonthsAgo) ||
                other.twoMonthsAgo == twoMonthsAgo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, today, yesterday, thisMonth, lastMonth, twoMonthsAgo);

  /// Create a copy of ShiftSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftSummaryDtoImplCopyWith<_$ShiftSummaryDtoImpl> get copyWith =>
      __$$ShiftSummaryDtoImplCopyWithImpl<_$ShiftSummaryDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShiftSummaryDtoImplToJson(
      this,
    );
  }
}

abstract class _ShiftSummaryDto implements ShiftSummaryDto {
  const factory _ShiftSummaryDto(
      {@JsonKey(name: 'today') required final PeriodStatsDto today,
      @JsonKey(name: 'yesterday') required final PeriodStatsDto yesterday,
      @JsonKey(name: 'this_month') required final PeriodStatsDto thisMonth,
      @JsonKey(name: 'last_month') required final PeriodStatsDto lastMonth,
      @JsonKey(name: 'two_months_ago')
      required final PeriodStatsDto twoMonthsAgo}) = _$ShiftSummaryDtoImpl;

  factory _ShiftSummaryDto.fromJson(Map<String, dynamic> json) =
      _$ShiftSummaryDtoImpl.fromJson;

  @override
  @JsonKey(name: 'today')
  PeriodStatsDto get today;
  @override
  @JsonKey(name: 'yesterday')
  PeriodStatsDto get yesterday;
  @override
  @JsonKey(name: 'this_month')
  PeriodStatsDto get thisMonth;
  @override
  @JsonKey(name: 'last_month')
  PeriodStatsDto get lastMonth;
  @override
  @JsonKey(name: 'two_months_ago')
  PeriodStatsDto get twoMonthsAgo;

  /// Create a copy of ShiftSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftSummaryDtoImplCopyWith<_$ShiftSummaryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PeriodStatsDto _$PeriodStatsDtoFromJson(Map<String, dynamic> json) {
  return _PeriodStatsDto.fromJson(json);
}

/// @nodoc
mixin _$PeriodStatsDto {
  @JsonKey(name: 'total_shifts')
  int get totalShifts => throw _privateConstructorUsedError;
  @JsonKey(name: 'late_count')
  int get lateCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'overtime_count')
  int get overtimeCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'overtime_amount_sum')
  num get overtimeAmountSum => throw _privateConstructorUsedError;
  @JsonKey(name: 'problem_count')
  int get problemCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'problem_solved_count')
  int get problemSolvedCount => throw _privateConstructorUsedError;

  /// Serializes this PeriodStatsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PeriodStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PeriodStatsDtoCopyWith<PeriodStatsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PeriodStatsDtoCopyWith<$Res> {
  factory $PeriodStatsDtoCopyWith(
          PeriodStatsDto value, $Res Function(PeriodStatsDto) then) =
      _$PeriodStatsDtoCopyWithImpl<$Res, PeriodStatsDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_shifts') int totalShifts,
      @JsonKey(name: 'late_count') int lateCount,
      @JsonKey(name: 'overtime_count') int overtimeCount,
      @JsonKey(name: 'overtime_amount_sum') num overtimeAmountSum,
      @JsonKey(name: 'problem_count') int problemCount,
      @JsonKey(name: 'problem_solved_count') int problemSolvedCount});
}

/// @nodoc
class _$PeriodStatsDtoCopyWithImpl<$Res, $Val extends PeriodStatsDto>
    implements $PeriodStatsDtoCopyWith<$Res> {
  _$PeriodStatsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PeriodStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalShifts = null,
    Object? lateCount = null,
    Object? overtimeCount = null,
    Object? overtimeAmountSum = null,
    Object? problemCount = null,
    Object? problemSolvedCount = null,
  }) {
    return _then(_value.copyWith(
      totalShifts: null == totalShifts
          ? _value.totalShifts
          : totalShifts // ignore: cast_nullable_to_non_nullable
              as int,
      lateCount: null == lateCount
          ? _value.lateCount
          : lateCount // ignore: cast_nullable_to_non_nullable
              as int,
      overtimeCount: null == overtimeCount
          ? _value.overtimeCount
          : overtimeCount // ignore: cast_nullable_to_non_nullable
              as int,
      overtimeAmountSum: null == overtimeAmountSum
          ? _value.overtimeAmountSum
          : overtimeAmountSum // ignore: cast_nullable_to_non_nullable
              as num,
      problemCount: null == problemCount
          ? _value.problemCount
          : problemCount // ignore: cast_nullable_to_non_nullable
              as int,
      problemSolvedCount: null == problemSolvedCount
          ? _value.problemSolvedCount
          : problemSolvedCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PeriodStatsDtoImplCopyWith<$Res>
    implements $PeriodStatsDtoCopyWith<$Res> {
  factory _$$PeriodStatsDtoImplCopyWith(_$PeriodStatsDtoImpl value,
          $Res Function(_$PeriodStatsDtoImpl) then) =
      __$$PeriodStatsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_shifts') int totalShifts,
      @JsonKey(name: 'late_count') int lateCount,
      @JsonKey(name: 'overtime_count') int overtimeCount,
      @JsonKey(name: 'overtime_amount_sum') num overtimeAmountSum,
      @JsonKey(name: 'problem_count') int problemCount,
      @JsonKey(name: 'problem_solved_count') int problemSolvedCount});
}

/// @nodoc
class __$$PeriodStatsDtoImplCopyWithImpl<$Res>
    extends _$PeriodStatsDtoCopyWithImpl<$Res, _$PeriodStatsDtoImpl>
    implements _$$PeriodStatsDtoImplCopyWith<$Res> {
  __$$PeriodStatsDtoImplCopyWithImpl(
      _$PeriodStatsDtoImpl _value, $Res Function(_$PeriodStatsDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PeriodStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalShifts = null,
    Object? lateCount = null,
    Object? overtimeCount = null,
    Object? overtimeAmountSum = null,
    Object? problemCount = null,
    Object? problemSolvedCount = null,
  }) {
    return _then(_$PeriodStatsDtoImpl(
      totalShifts: null == totalShifts
          ? _value.totalShifts
          : totalShifts // ignore: cast_nullable_to_non_nullable
              as int,
      lateCount: null == lateCount
          ? _value.lateCount
          : lateCount // ignore: cast_nullable_to_non_nullable
              as int,
      overtimeCount: null == overtimeCount
          ? _value.overtimeCount
          : overtimeCount // ignore: cast_nullable_to_non_nullable
              as int,
      overtimeAmountSum: null == overtimeAmountSum
          ? _value.overtimeAmountSum
          : overtimeAmountSum // ignore: cast_nullable_to_non_nullable
              as num,
      problemCount: null == problemCount
          ? _value.problemCount
          : problemCount // ignore: cast_nullable_to_non_nullable
              as int,
      problemSolvedCount: null == problemSolvedCount
          ? _value.problemSolvedCount
          : problemSolvedCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PeriodStatsDtoImpl implements _PeriodStatsDto {
  const _$PeriodStatsDtoImpl(
      {@JsonKey(name: 'total_shifts') this.totalShifts = 0,
      @JsonKey(name: 'late_count') this.lateCount = 0,
      @JsonKey(name: 'overtime_count') this.overtimeCount = 0,
      @JsonKey(name: 'overtime_amount_sum') this.overtimeAmountSum = 0,
      @JsonKey(name: 'problem_count') this.problemCount = 0,
      @JsonKey(name: 'problem_solved_count') this.problemSolvedCount = 0});

  factory _$PeriodStatsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PeriodStatsDtoImplFromJson(json);

  @override
  @JsonKey(name: 'total_shifts')
  final int totalShifts;
  @override
  @JsonKey(name: 'late_count')
  final int lateCount;
  @override
  @JsonKey(name: 'overtime_count')
  final int overtimeCount;
  @override
  @JsonKey(name: 'overtime_amount_sum')
  final num overtimeAmountSum;
  @override
  @JsonKey(name: 'problem_count')
  final int problemCount;
  @override
  @JsonKey(name: 'problem_solved_count')
  final int problemSolvedCount;

  @override
  String toString() {
    return 'PeriodStatsDto(totalShifts: $totalShifts, lateCount: $lateCount, overtimeCount: $overtimeCount, overtimeAmountSum: $overtimeAmountSum, problemCount: $problemCount, problemSolvedCount: $problemSolvedCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PeriodStatsDtoImpl &&
            (identical(other.totalShifts, totalShifts) ||
                other.totalShifts == totalShifts) &&
            (identical(other.lateCount, lateCount) ||
                other.lateCount == lateCount) &&
            (identical(other.overtimeCount, overtimeCount) ||
                other.overtimeCount == overtimeCount) &&
            (identical(other.overtimeAmountSum, overtimeAmountSum) ||
                other.overtimeAmountSum == overtimeAmountSum) &&
            (identical(other.problemCount, problemCount) ||
                other.problemCount == problemCount) &&
            (identical(other.problemSolvedCount, problemSolvedCount) ||
                other.problemSolvedCount == problemSolvedCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalShifts, lateCount,
      overtimeCount, overtimeAmountSum, problemCount, problemSolvedCount);

  /// Create a copy of PeriodStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PeriodStatsDtoImplCopyWith<_$PeriodStatsDtoImpl> get copyWith =>
      __$$PeriodStatsDtoImplCopyWithImpl<_$PeriodStatsDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PeriodStatsDtoImplToJson(
      this,
    );
  }
}

abstract class _PeriodStatsDto implements PeriodStatsDto {
  const factory _PeriodStatsDto(
      {@JsonKey(name: 'total_shifts') final int totalShifts,
      @JsonKey(name: 'late_count') final int lateCount,
      @JsonKey(name: 'overtime_count') final int overtimeCount,
      @JsonKey(name: 'overtime_amount_sum') final num overtimeAmountSum,
      @JsonKey(name: 'problem_count') final int problemCount,
      @JsonKey(name: 'problem_solved_count')
      final int problemSolvedCount}) = _$PeriodStatsDtoImpl;

  factory _PeriodStatsDto.fromJson(Map<String, dynamic> json) =
      _$PeriodStatsDtoImpl.fromJson;

  @override
  @JsonKey(name: 'total_shifts')
  int get totalShifts;
  @override
  @JsonKey(name: 'late_count')
  int get lateCount;
  @override
  @JsonKey(name: 'overtime_count')
  int get overtimeCount;
  @override
  @JsonKey(name: 'overtime_amount_sum')
  num get overtimeAmountSum;
  @override
  @JsonKey(name: 'problem_count')
  int get problemCount;
  @override
  @JsonKey(name: 'problem_solved_count')
  int get problemSolvedCount;

  /// Create a copy of PeriodStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PeriodStatsDtoImplCopyWith<_$PeriodStatsDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UnderstaffedShiftsDto _$UnderstaffedShiftsDtoFromJson(
    Map<String, dynamic> json) {
  return _UnderstaffedShiftsDto.fromJson(json);
}

/// @nodoc
mixin _$UnderstaffedShiftsDto {
  @JsonKey(name: 'today')
  int get today => throw _privateConstructorUsedError;
  @JsonKey(name: 'yesterday')
  int get yesterday => throw _privateConstructorUsedError;
  @JsonKey(name: 'this_month')
  int get thisMonth => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_month')
  int get lastMonth => throw _privateConstructorUsedError;
  @JsonKey(name: 'two_months_ago')
  int get twoMonthsAgo => throw _privateConstructorUsedError;

  /// Serializes this UnderstaffedShiftsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UnderstaffedShiftsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UnderstaffedShiftsDtoCopyWith<UnderstaffedShiftsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnderstaffedShiftsDtoCopyWith<$Res> {
  factory $UnderstaffedShiftsDtoCopyWith(UnderstaffedShiftsDto value,
          $Res Function(UnderstaffedShiftsDto) then) =
      _$UnderstaffedShiftsDtoCopyWithImpl<$Res, UnderstaffedShiftsDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'today') int today,
      @JsonKey(name: 'yesterday') int yesterday,
      @JsonKey(name: 'this_month') int thisMonth,
      @JsonKey(name: 'last_month') int lastMonth,
      @JsonKey(name: 'two_months_ago') int twoMonthsAgo});
}

/// @nodoc
class _$UnderstaffedShiftsDtoCopyWithImpl<$Res,
        $Val extends UnderstaffedShiftsDto>
    implements $UnderstaffedShiftsDtoCopyWith<$Res> {
  _$UnderstaffedShiftsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UnderstaffedShiftsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? today = null,
    Object? yesterday = null,
    Object? thisMonth = null,
    Object? lastMonth = null,
    Object? twoMonthsAgo = null,
  }) {
    return _then(_value.copyWith(
      today: null == today
          ? _value.today
          : today // ignore: cast_nullable_to_non_nullable
              as int,
      yesterday: null == yesterday
          ? _value.yesterday
          : yesterday // ignore: cast_nullable_to_non_nullable
              as int,
      thisMonth: null == thisMonth
          ? _value.thisMonth
          : thisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      lastMonth: null == lastMonth
          ? _value.lastMonth
          : lastMonth // ignore: cast_nullable_to_non_nullable
              as int,
      twoMonthsAgo: null == twoMonthsAgo
          ? _value.twoMonthsAgo
          : twoMonthsAgo // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UnderstaffedShiftsDtoImplCopyWith<$Res>
    implements $UnderstaffedShiftsDtoCopyWith<$Res> {
  factory _$$UnderstaffedShiftsDtoImplCopyWith(
          _$UnderstaffedShiftsDtoImpl value,
          $Res Function(_$UnderstaffedShiftsDtoImpl) then) =
      __$$UnderstaffedShiftsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'today') int today,
      @JsonKey(name: 'yesterday') int yesterday,
      @JsonKey(name: 'this_month') int thisMonth,
      @JsonKey(name: 'last_month') int lastMonth,
      @JsonKey(name: 'two_months_ago') int twoMonthsAgo});
}

/// @nodoc
class __$$UnderstaffedShiftsDtoImplCopyWithImpl<$Res>
    extends _$UnderstaffedShiftsDtoCopyWithImpl<$Res,
        _$UnderstaffedShiftsDtoImpl>
    implements _$$UnderstaffedShiftsDtoImplCopyWith<$Res> {
  __$$UnderstaffedShiftsDtoImplCopyWithImpl(_$UnderstaffedShiftsDtoImpl _value,
      $Res Function(_$UnderstaffedShiftsDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UnderstaffedShiftsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? today = null,
    Object? yesterday = null,
    Object? thisMonth = null,
    Object? lastMonth = null,
    Object? twoMonthsAgo = null,
  }) {
    return _then(_$UnderstaffedShiftsDtoImpl(
      today: null == today
          ? _value.today
          : today // ignore: cast_nullable_to_non_nullable
              as int,
      yesterday: null == yesterday
          ? _value.yesterday
          : yesterday // ignore: cast_nullable_to_non_nullable
              as int,
      thisMonth: null == thisMonth
          ? _value.thisMonth
          : thisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      lastMonth: null == lastMonth
          ? _value.lastMonth
          : lastMonth // ignore: cast_nullable_to_non_nullable
              as int,
      twoMonthsAgo: null == twoMonthsAgo
          ? _value.twoMonthsAgo
          : twoMonthsAgo // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UnderstaffedShiftsDtoImpl implements _UnderstaffedShiftsDto {
  const _$UnderstaffedShiftsDtoImpl(
      {@JsonKey(name: 'today') this.today = 0,
      @JsonKey(name: 'yesterday') this.yesterday = 0,
      @JsonKey(name: 'this_month') this.thisMonth = 0,
      @JsonKey(name: 'last_month') this.lastMonth = 0,
      @JsonKey(name: 'two_months_ago') this.twoMonthsAgo = 0});

  factory _$UnderstaffedShiftsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnderstaffedShiftsDtoImplFromJson(json);

  @override
  @JsonKey(name: 'today')
  final int today;
  @override
  @JsonKey(name: 'yesterday')
  final int yesterday;
  @override
  @JsonKey(name: 'this_month')
  final int thisMonth;
  @override
  @JsonKey(name: 'last_month')
  final int lastMonth;
  @override
  @JsonKey(name: 'two_months_ago')
  final int twoMonthsAgo;

  @override
  String toString() {
    return 'UnderstaffedShiftsDto(today: $today, yesterday: $yesterday, thisMonth: $thisMonth, lastMonth: $lastMonth, twoMonthsAgo: $twoMonthsAgo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnderstaffedShiftsDtoImpl &&
            (identical(other.today, today) || other.today == today) &&
            (identical(other.yesterday, yesterday) ||
                other.yesterday == yesterday) &&
            (identical(other.thisMonth, thisMonth) ||
                other.thisMonth == thisMonth) &&
            (identical(other.lastMonth, lastMonth) ||
                other.lastMonth == lastMonth) &&
            (identical(other.twoMonthsAgo, twoMonthsAgo) ||
                other.twoMonthsAgo == twoMonthsAgo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, today, yesterday, thisMonth, lastMonth, twoMonthsAgo);

  /// Create a copy of UnderstaffedShiftsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnderstaffedShiftsDtoImplCopyWith<_$UnderstaffedShiftsDtoImpl>
      get copyWith => __$$UnderstaffedShiftsDtoImplCopyWithImpl<
          _$UnderstaffedShiftsDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UnderstaffedShiftsDtoImplToJson(
      this,
    );
  }
}

abstract class _UnderstaffedShiftsDto implements UnderstaffedShiftsDto {
  const factory _UnderstaffedShiftsDto(
          {@JsonKey(name: 'today') final int today,
          @JsonKey(name: 'yesterday') final int yesterday,
          @JsonKey(name: 'this_month') final int thisMonth,
          @JsonKey(name: 'last_month') final int lastMonth,
          @JsonKey(name: 'two_months_ago') final int twoMonthsAgo}) =
      _$UnderstaffedShiftsDtoImpl;

  factory _UnderstaffedShiftsDto.fromJson(Map<String, dynamic> json) =
      _$UnderstaffedShiftsDtoImpl.fromJson;

  @override
  @JsonKey(name: 'today')
  int get today;
  @override
  @JsonKey(name: 'yesterday')
  int get yesterday;
  @override
  @JsonKey(name: 'this_month')
  int get thisMonth;
  @override
  @JsonKey(name: 'last_month')
  int get lastMonth;
  @override
  @JsonKey(name: 'two_months_ago')
  int get twoMonthsAgo;

  /// Create a copy of UnderstaffedShiftsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnderstaffedShiftsDtoImplCopyWith<_$UnderstaffedShiftsDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

EmployeeReliabilityDto _$EmployeeReliabilityDtoFromJson(
    Map<String, dynamic> json) {
  return _EmployeeReliabilityDto.fromJson(json);
}

/// @nodoc
mixin _$EmployeeReliabilityDto {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_name')
  String get userName => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_image')
  String? get profileImage => throw _privateConstructorUsedError;
  @JsonKey(name: 'role')
  String? get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_name')
  String? get storeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_applications')
  int get totalApplications => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_shifts')
  int get approvedShifts => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_shifts')
  int get completedShifts => throw _privateConstructorUsedError;
  @JsonKey(name: 'late_count')
  int get lateCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'late_rate')
  num get lateRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'on_time_rate')
  num get onTimeRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_late_minutes')
  num get avgLateMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_fill_rate_applied')
  num get avgFillRateApplied => throw _privateConstructorUsedError;
  @JsonKey(name: 'reliability')
  num get reliability => throw _privateConstructorUsedError;
  @JsonKey(name: 'final_score')
  num get finalScore =>
      throw _privateConstructorUsedError; // Score breakdown fields
  @JsonKey(name: 'applications_score')
  num get applicationsScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'late_rate_score')
  num get lateRateScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'late_minutes_score')
  num get lateMinutesScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'fill_rate_score')
  num get fillRateScore =>
      throw _privateConstructorUsedError; // Salary fields for payroll calculation
  @JsonKey(name: 'salary_amount')
  num get salaryAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'salary_type')
  String? get salaryType => throw _privateConstructorUsedError;

  /// Serializes this EmployeeReliabilityDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeReliabilityDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeReliabilityDtoCopyWith<EmployeeReliabilityDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeReliabilityDtoCopyWith<$Res> {
  factory $EmployeeReliabilityDtoCopyWith(EmployeeReliabilityDto value,
          $Res Function(EmployeeReliabilityDto) then) =
      _$EmployeeReliabilityDtoCopyWithImpl<$Res, EmployeeReliabilityDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'user_name') String userName,
      @JsonKey(name: 'profile_image') String? profileImage,
      @JsonKey(name: 'role') String? role,
      @JsonKey(name: 'store_name') String? storeName,
      @JsonKey(name: 'total_applications') int totalApplications,
      @JsonKey(name: 'approved_shifts') int approvedShifts,
      @JsonKey(name: 'completed_shifts') int completedShifts,
      @JsonKey(name: 'late_count') int lateCount,
      @JsonKey(name: 'late_rate') num lateRate,
      @JsonKey(name: 'on_time_rate') num onTimeRate,
      @JsonKey(name: 'avg_late_minutes') num avgLateMinutes,
      @JsonKey(name: 'avg_fill_rate_applied') num avgFillRateApplied,
      @JsonKey(name: 'reliability') num reliability,
      @JsonKey(name: 'final_score') num finalScore,
      @JsonKey(name: 'applications_score') num applicationsScore,
      @JsonKey(name: 'late_rate_score') num lateRateScore,
      @JsonKey(name: 'late_minutes_score') num lateMinutesScore,
      @JsonKey(name: 'fill_rate_score') num fillRateScore,
      @JsonKey(name: 'salary_amount') num salaryAmount,
      @JsonKey(name: 'salary_type') String? salaryType});
}

/// @nodoc
class _$EmployeeReliabilityDtoCopyWithImpl<$Res,
        $Val extends EmployeeReliabilityDto>
    implements $EmployeeReliabilityDtoCopyWith<$Res> {
  _$EmployeeReliabilityDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeReliabilityDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? profileImage = freezed,
    Object? role = freezed,
    Object? storeName = freezed,
    Object? totalApplications = null,
    Object? approvedShifts = null,
    Object? completedShifts = null,
    Object? lateCount = null,
    Object? lateRate = null,
    Object? onTimeRate = null,
    Object? avgLateMinutes = null,
    Object? avgFillRateApplied = null,
    Object? reliability = null,
    Object? finalScore = null,
    Object? applicationsScore = null,
    Object? lateRateScore = null,
    Object? lateMinutesScore = null,
    Object? fillRateScore = null,
    Object? salaryAmount = null,
    Object? salaryType = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      totalApplications: null == totalApplications
          ? _value.totalApplications
          : totalApplications // ignore: cast_nullable_to_non_nullable
              as int,
      approvedShifts: null == approvedShifts
          ? _value.approvedShifts
          : approvedShifts // ignore: cast_nullable_to_non_nullable
              as int,
      completedShifts: null == completedShifts
          ? _value.completedShifts
          : completedShifts // ignore: cast_nullable_to_non_nullable
              as int,
      lateCount: null == lateCount
          ? _value.lateCount
          : lateCount // ignore: cast_nullable_to_non_nullable
              as int,
      lateRate: null == lateRate
          ? _value.lateRate
          : lateRate // ignore: cast_nullable_to_non_nullable
              as num,
      onTimeRate: null == onTimeRate
          ? _value.onTimeRate
          : onTimeRate // ignore: cast_nullable_to_non_nullable
              as num,
      avgLateMinutes: null == avgLateMinutes
          ? _value.avgLateMinutes
          : avgLateMinutes // ignore: cast_nullable_to_non_nullable
              as num,
      avgFillRateApplied: null == avgFillRateApplied
          ? _value.avgFillRateApplied
          : avgFillRateApplied // ignore: cast_nullable_to_non_nullable
              as num,
      reliability: null == reliability
          ? _value.reliability
          : reliability // ignore: cast_nullable_to_non_nullable
              as num,
      finalScore: null == finalScore
          ? _value.finalScore
          : finalScore // ignore: cast_nullable_to_non_nullable
              as num,
      applicationsScore: null == applicationsScore
          ? _value.applicationsScore
          : applicationsScore // ignore: cast_nullable_to_non_nullable
              as num,
      lateRateScore: null == lateRateScore
          ? _value.lateRateScore
          : lateRateScore // ignore: cast_nullable_to_non_nullable
              as num,
      lateMinutesScore: null == lateMinutesScore
          ? _value.lateMinutesScore
          : lateMinutesScore // ignore: cast_nullable_to_non_nullable
              as num,
      fillRateScore: null == fillRateScore
          ? _value.fillRateScore
          : fillRateScore // ignore: cast_nullable_to_non_nullable
              as num,
      salaryAmount: null == salaryAmount
          ? _value.salaryAmount
          : salaryAmount // ignore: cast_nullable_to_non_nullable
              as num,
      salaryType: freezed == salaryType
          ? _value.salaryType
          : salaryType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmployeeReliabilityDtoImplCopyWith<$Res>
    implements $EmployeeReliabilityDtoCopyWith<$Res> {
  factory _$$EmployeeReliabilityDtoImplCopyWith(
          _$EmployeeReliabilityDtoImpl value,
          $Res Function(_$EmployeeReliabilityDtoImpl) then) =
      __$$EmployeeReliabilityDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'user_name') String userName,
      @JsonKey(name: 'profile_image') String? profileImage,
      @JsonKey(name: 'role') String? role,
      @JsonKey(name: 'store_name') String? storeName,
      @JsonKey(name: 'total_applications') int totalApplications,
      @JsonKey(name: 'approved_shifts') int approvedShifts,
      @JsonKey(name: 'completed_shifts') int completedShifts,
      @JsonKey(name: 'late_count') int lateCount,
      @JsonKey(name: 'late_rate') num lateRate,
      @JsonKey(name: 'on_time_rate') num onTimeRate,
      @JsonKey(name: 'avg_late_minutes') num avgLateMinutes,
      @JsonKey(name: 'avg_fill_rate_applied') num avgFillRateApplied,
      @JsonKey(name: 'reliability') num reliability,
      @JsonKey(name: 'final_score') num finalScore,
      @JsonKey(name: 'applications_score') num applicationsScore,
      @JsonKey(name: 'late_rate_score') num lateRateScore,
      @JsonKey(name: 'late_minutes_score') num lateMinutesScore,
      @JsonKey(name: 'fill_rate_score') num fillRateScore,
      @JsonKey(name: 'salary_amount') num salaryAmount,
      @JsonKey(name: 'salary_type') String? salaryType});
}

/// @nodoc
class __$$EmployeeReliabilityDtoImplCopyWithImpl<$Res>
    extends _$EmployeeReliabilityDtoCopyWithImpl<$Res,
        _$EmployeeReliabilityDtoImpl>
    implements _$$EmployeeReliabilityDtoImplCopyWith<$Res> {
  __$$EmployeeReliabilityDtoImplCopyWithImpl(
      _$EmployeeReliabilityDtoImpl _value,
      $Res Function(_$EmployeeReliabilityDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of EmployeeReliabilityDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? profileImage = freezed,
    Object? role = freezed,
    Object? storeName = freezed,
    Object? totalApplications = null,
    Object? approvedShifts = null,
    Object? completedShifts = null,
    Object? lateCount = null,
    Object? lateRate = null,
    Object? onTimeRate = null,
    Object? avgLateMinutes = null,
    Object? avgFillRateApplied = null,
    Object? reliability = null,
    Object? finalScore = null,
    Object? applicationsScore = null,
    Object? lateRateScore = null,
    Object? lateMinutesScore = null,
    Object? fillRateScore = null,
    Object? salaryAmount = null,
    Object? salaryType = freezed,
  }) {
    return _then(_$EmployeeReliabilityDtoImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      totalApplications: null == totalApplications
          ? _value.totalApplications
          : totalApplications // ignore: cast_nullable_to_non_nullable
              as int,
      approvedShifts: null == approvedShifts
          ? _value.approvedShifts
          : approvedShifts // ignore: cast_nullable_to_non_nullable
              as int,
      completedShifts: null == completedShifts
          ? _value.completedShifts
          : completedShifts // ignore: cast_nullable_to_non_nullable
              as int,
      lateCount: null == lateCount
          ? _value.lateCount
          : lateCount // ignore: cast_nullable_to_non_nullable
              as int,
      lateRate: null == lateRate
          ? _value.lateRate
          : lateRate // ignore: cast_nullable_to_non_nullable
              as num,
      onTimeRate: null == onTimeRate
          ? _value.onTimeRate
          : onTimeRate // ignore: cast_nullable_to_non_nullable
              as num,
      avgLateMinutes: null == avgLateMinutes
          ? _value.avgLateMinutes
          : avgLateMinutes // ignore: cast_nullable_to_non_nullable
              as num,
      avgFillRateApplied: null == avgFillRateApplied
          ? _value.avgFillRateApplied
          : avgFillRateApplied // ignore: cast_nullable_to_non_nullable
              as num,
      reliability: null == reliability
          ? _value.reliability
          : reliability // ignore: cast_nullable_to_non_nullable
              as num,
      finalScore: null == finalScore
          ? _value.finalScore
          : finalScore // ignore: cast_nullable_to_non_nullable
              as num,
      applicationsScore: null == applicationsScore
          ? _value.applicationsScore
          : applicationsScore // ignore: cast_nullable_to_non_nullable
              as num,
      lateRateScore: null == lateRateScore
          ? _value.lateRateScore
          : lateRateScore // ignore: cast_nullable_to_non_nullable
              as num,
      lateMinutesScore: null == lateMinutesScore
          ? _value.lateMinutesScore
          : lateMinutesScore // ignore: cast_nullable_to_non_nullable
              as num,
      fillRateScore: null == fillRateScore
          ? _value.fillRateScore
          : fillRateScore // ignore: cast_nullable_to_non_nullable
              as num,
      salaryAmount: null == salaryAmount
          ? _value.salaryAmount
          : salaryAmount // ignore: cast_nullable_to_non_nullable
              as num,
      salaryType: freezed == salaryType
          ? _value.salaryType
          : salaryType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeReliabilityDtoImpl implements _EmployeeReliabilityDto {
  const _$EmployeeReliabilityDtoImpl(
      {@JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'user_name') required this.userName,
      @JsonKey(name: 'profile_image') this.profileImage,
      @JsonKey(name: 'role') this.role,
      @JsonKey(name: 'store_name') this.storeName,
      @JsonKey(name: 'total_applications') this.totalApplications = 0,
      @JsonKey(name: 'approved_shifts') this.approvedShifts = 0,
      @JsonKey(name: 'completed_shifts') this.completedShifts = 0,
      @JsonKey(name: 'late_count') this.lateCount = 0,
      @JsonKey(name: 'late_rate') this.lateRate = 0,
      @JsonKey(name: 'on_time_rate') this.onTimeRate = 0,
      @JsonKey(name: 'avg_late_minutes') this.avgLateMinutes = 0,
      @JsonKey(name: 'avg_fill_rate_applied') this.avgFillRateApplied = 0,
      @JsonKey(name: 'reliability') this.reliability = 0,
      @JsonKey(name: 'final_score') this.finalScore = 0,
      @JsonKey(name: 'applications_score') this.applicationsScore = 0,
      @JsonKey(name: 'late_rate_score') this.lateRateScore = 0,
      @JsonKey(name: 'late_minutes_score') this.lateMinutesScore = 0,
      @JsonKey(name: 'fill_rate_score') this.fillRateScore = 0,
      @JsonKey(name: 'salary_amount') this.salaryAmount = 0,
      @JsonKey(name: 'salary_type') this.salaryType});

  factory _$EmployeeReliabilityDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeReliabilityDtoImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'user_name')
  final String userName;
  @override
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  @override
  @JsonKey(name: 'role')
  final String? role;
  @override
  @JsonKey(name: 'store_name')
  final String? storeName;
  @override
  @JsonKey(name: 'total_applications')
  final int totalApplications;
  @override
  @JsonKey(name: 'approved_shifts')
  final int approvedShifts;
  @override
  @JsonKey(name: 'completed_shifts')
  final int completedShifts;
  @override
  @JsonKey(name: 'late_count')
  final int lateCount;
  @override
  @JsonKey(name: 'late_rate')
  final num lateRate;
  @override
  @JsonKey(name: 'on_time_rate')
  final num onTimeRate;
  @override
  @JsonKey(name: 'avg_late_minutes')
  final num avgLateMinutes;
  @override
  @JsonKey(name: 'avg_fill_rate_applied')
  final num avgFillRateApplied;
  @override
  @JsonKey(name: 'reliability')
  final num reliability;
  @override
  @JsonKey(name: 'final_score')
  final num finalScore;
// Score breakdown fields
  @override
  @JsonKey(name: 'applications_score')
  final num applicationsScore;
  @override
  @JsonKey(name: 'late_rate_score')
  final num lateRateScore;
  @override
  @JsonKey(name: 'late_minutes_score')
  final num lateMinutesScore;
  @override
  @JsonKey(name: 'fill_rate_score')
  final num fillRateScore;
// Salary fields for payroll calculation
  @override
  @JsonKey(name: 'salary_amount')
  final num salaryAmount;
  @override
  @JsonKey(name: 'salary_type')
  final String? salaryType;

  @override
  String toString() {
    return 'EmployeeReliabilityDto(userId: $userId, userName: $userName, profileImage: $profileImage, role: $role, storeName: $storeName, totalApplications: $totalApplications, approvedShifts: $approvedShifts, completedShifts: $completedShifts, lateCount: $lateCount, lateRate: $lateRate, onTimeRate: $onTimeRate, avgLateMinutes: $avgLateMinutes, avgFillRateApplied: $avgFillRateApplied, reliability: $reliability, finalScore: $finalScore, applicationsScore: $applicationsScore, lateRateScore: $lateRateScore, lateMinutesScore: $lateMinutesScore, fillRateScore: $fillRateScore, salaryAmount: $salaryAmount, salaryType: $salaryType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeReliabilityDtoImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.totalApplications, totalApplications) ||
                other.totalApplications == totalApplications) &&
            (identical(other.approvedShifts, approvedShifts) ||
                other.approvedShifts == approvedShifts) &&
            (identical(other.completedShifts, completedShifts) ||
                other.completedShifts == completedShifts) &&
            (identical(other.lateCount, lateCount) ||
                other.lateCount == lateCount) &&
            (identical(other.lateRate, lateRate) ||
                other.lateRate == lateRate) &&
            (identical(other.onTimeRate, onTimeRate) ||
                other.onTimeRate == onTimeRate) &&
            (identical(other.avgLateMinutes, avgLateMinutes) ||
                other.avgLateMinutes == avgLateMinutes) &&
            (identical(other.avgFillRateApplied, avgFillRateApplied) ||
                other.avgFillRateApplied == avgFillRateApplied) &&
            (identical(other.reliability, reliability) ||
                other.reliability == reliability) &&
            (identical(other.finalScore, finalScore) ||
                other.finalScore == finalScore) &&
            (identical(other.applicationsScore, applicationsScore) ||
                other.applicationsScore == applicationsScore) &&
            (identical(other.lateRateScore, lateRateScore) ||
                other.lateRateScore == lateRateScore) &&
            (identical(other.lateMinutesScore, lateMinutesScore) ||
                other.lateMinutesScore == lateMinutesScore) &&
            (identical(other.fillRateScore, fillRateScore) ||
                other.fillRateScore == fillRateScore) &&
            (identical(other.salaryAmount, salaryAmount) ||
                other.salaryAmount == salaryAmount) &&
            (identical(other.salaryType, salaryType) ||
                other.salaryType == salaryType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        userId,
        userName,
        profileImage,
        role,
        storeName,
        totalApplications,
        approvedShifts,
        completedShifts,
        lateCount,
        lateRate,
        onTimeRate,
        avgLateMinutes,
        avgFillRateApplied,
        reliability,
        finalScore,
        applicationsScore,
        lateRateScore,
        lateMinutesScore,
        fillRateScore,
        salaryAmount,
        salaryType
      ]);

  /// Create a copy of EmployeeReliabilityDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeReliabilityDtoImplCopyWith<_$EmployeeReliabilityDtoImpl>
      get copyWith => __$$EmployeeReliabilityDtoImplCopyWithImpl<
          _$EmployeeReliabilityDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeReliabilityDtoImplToJson(
      this,
    );
  }
}

abstract class _EmployeeReliabilityDto implements EmployeeReliabilityDto {
  const factory _EmployeeReliabilityDto(
          {@JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'user_name') required final String userName,
          @JsonKey(name: 'profile_image') final String? profileImage,
          @JsonKey(name: 'role') final String? role,
          @JsonKey(name: 'store_name') final String? storeName,
          @JsonKey(name: 'total_applications') final int totalApplications,
          @JsonKey(name: 'approved_shifts') final int approvedShifts,
          @JsonKey(name: 'completed_shifts') final int completedShifts,
          @JsonKey(name: 'late_count') final int lateCount,
          @JsonKey(name: 'late_rate') final num lateRate,
          @JsonKey(name: 'on_time_rate') final num onTimeRate,
          @JsonKey(name: 'avg_late_minutes') final num avgLateMinutes,
          @JsonKey(name: 'avg_fill_rate_applied') final num avgFillRateApplied,
          @JsonKey(name: 'reliability') final num reliability,
          @JsonKey(name: 'final_score') final num finalScore,
          @JsonKey(name: 'applications_score') final num applicationsScore,
          @JsonKey(name: 'late_rate_score') final num lateRateScore,
          @JsonKey(name: 'late_minutes_score') final num lateMinutesScore,
          @JsonKey(name: 'fill_rate_score') final num fillRateScore,
          @JsonKey(name: 'salary_amount') final num salaryAmount,
          @JsonKey(name: 'salary_type') final String? salaryType}) =
      _$EmployeeReliabilityDtoImpl;

  factory _EmployeeReliabilityDto.fromJson(Map<String, dynamic> json) =
      _$EmployeeReliabilityDtoImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'user_name')
  String get userName;
  @override
  @JsonKey(name: 'profile_image')
  String? get profileImage;
  @override
  @JsonKey(name: 'role')
  String? get role;
  @override
  @JsonKey(name: 'store_name')
  String? get storeName;
  @override
  @JsonKey(name: 'total_applications')
  int get totalApplications;
  @override
  @JsonKey(name: 'approved_shifts')
  int get approvedShifts;
  @override
  @JsonKey(name: 'completed_shifts')
  int get completedShifts;
  @override
  @JsonKey(name: 'late_count')
  int get lateCount;
  @override
  @JsonKey(name: 'late_rate')
  num get lateRate;
  @override
  @JsonKey(name: 'on_time_rate')
  num get onTimeRate;
  @override
  @JsonKey(name: 'avg_late_minutes')
  num get avgLateMinutes;
  @override
  @JsonKey(name: 'avg_fill_rate_applied')
  num get avgFillRateApplied;
  @override
  @JsonKey(name: 'reliability')
  num get reliability;
  @override
  @JsonKey(name: 'final_score')
  num get finalScore; // Score breakdown fields
  @override
  @JsonKey(name: 'applications_score')
  num get applicationsScore;
  @override
  @JsonKey(name: 'late_rate_score')
  num get lateRateScore;
  @override
  @JsonKey(name: 'late_minutes_score')
  num get lateMinutesScore;
  @override
  @JsonKey(name: 'fill_rate_score')
  num get fillRateScore; // Salary fields for payroll calculation
  @override
  @JsonKey(name: 'salary_amount')
  num get salaryAmount;
  @override
  @JsonKey(name: 'salary_type')
  String? get salaryType;

  /// Create a copy of EmployeeReliabilityDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeReliabilityDtoImplCopyWith<_$EmployeeReliabilityDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
