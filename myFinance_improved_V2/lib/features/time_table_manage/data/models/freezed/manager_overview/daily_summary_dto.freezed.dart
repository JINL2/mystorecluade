// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_summary_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DailySummaryDto _$DailySummaryDtoFromJson(Map<String, dynamic> json) {
  return _DailySummaryDto.fromJson(json);
}

/// @nodoc
mixin _$DailySummaryDto {
  @JsonKey(name: 'date')
  String get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_required')
  int get totalRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_approved')
  int get totalApproved => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pending')
  int get totalPending => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_problem')
  bool get hasProblem => throw _privateConstructorUsedError;
  @JsonKey(name: 'fill_rate')
  int get fillRate => throw _privateConstructorUsedError;

  /// Serializes this DailySummaryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailySummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailySummaryDtoCopyWith<DailySummaryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailySummaryDtoCopyWith<$Res> {
  factory $DailySummaryDtoCopyWith(
          DailySummaryDto value, $Res Function(DailySummaryDto) then) =
      _$DailySummaryDtoCopyWithImpl<$Res, DailySummaryDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'date') String date,
      @JsonKey(name: 'total_required') int totalRequired,
      @JsonKey(name: 'total_approved') int totalApproved,
      @JsonKey(name: 'total_pending') int totalPending,
      @JsonKey(name: 'has_problem') bool hasProblem,
      @JsonKey(name: 'fill_rate') int fillRate});
}

/// @nodoc
class _$DailySummaryDtoCopyWithImpl<$Res, $Val extends DailySummaryDto>
    implements $DailySummaryDtoCopyWith<$Res> {
  _$DailySummaryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailySummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? totalRequired = null,
    Object? totalApproved = null,
    Object? totalPending = null,
    Object? hasProblem = null,
    Object? fillRate = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      totalRequired: null == totalRequired
          ? _value.totalRequired
          : totalRequired // ignore: cast_nullable_to_non_nullable
              as int,
      totalApproved: null == totalApproved
          ? _value.totalApproved
          : totalApproved // ignore: cast_nullable_to_non_nullable
              as int,
      totalPending: null == totalPending
          ? _value.totalPending
          : totalPending // ignore: cast_nullable_to_non_nullable
              as int,
      hasProblem: null == hasProblem
          ? _value.hasProblem
          : hasProblem // ignore: cast_nullable_to_non_nullable
              as bool,
      fillRate: null == fillRate
          ? _value.fillRate
          : fillRate // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailySummaryDtoImplCopyWith<$Res>
    implements $DailySummaryDtoCopyWith<$Res> {
  factory _$$DailySummaryDtoImplCopyWith(_$DailySummaryDtoImpl value,
          $Res Function(_$DailySummaryDtoImpl) then) =
      __$$DailySummaryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'date') String date,
      @JsonKey(name: 'total_required') int totalRequired,
      @JsonKey(name: 'total_approved') int totalApproved,
      @JsonKey(name: 'total_pending') int totalPending,
      @JsonKey(name: 'has_problem') bool hasProblem,
      @JsonKey(name: 'fill_rate') int fillRate});
}

/// @nodoc
class __$$DailySummaryDtoImplCopyWithImpl<$Res>
    extends _$DailySummaryDtoCopyWithImpl<$Res, _$DailySummaryDtoImpl>
    implements _$$DailySummaryDtoImplCopyWith<$Res> {
  __$$DailySummaryDtoImplCopyWithImpl(
      _$DailySummaryDtoImpl _value, $Res Function(_$DailySummaryDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailySummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? totalRequired = null,
    Object? totalApproved = null,
    Object? totalPending = null,
    Object? hasProblem = null,
    Object? fillRate = null,
  }) {
    return _then(_$DailySummaryDtoImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      totalRequired: null == totalRequired
          ? _value.totalRequired
          : totalRequired // ignore: cast_nullable_to_non_nullable
              as int,
      totalApproved: null == totalApproved
          ? _value.totalApproved
          : totalApproved // ignore: cast_nullable_to_non_nullable
              as int,
      totalPending: null == totalPending
          ? _value.totalPending
          : totalPending // ignore: cast_nullable_to_non_nullable
              as int,
      hasProblem: null == hasProblem
          ? _value.hasProblem
          : hasProblem // ignore: cast_nullable_to_non_nullable
              as bool,
      fillRate: null == fillRate
          ? _value.fillRate
          : fillRate // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailySummaryDtoImpl implements _DailySummaryDto {
  const _$DailySummaryDtoImpl(
      {@JsonKey(name: 'date') this.date = '',
      @JsonKey(name: 'total_required') this.totalRequired = 0,
      @JsonKey(name: 'total_approved') this.totalApproved = 0,
      @JsonKey(name: 'total_pending') this.totalPending = 0,
      @JsonKey(name: 'has_problem') this.hasProblem = false,
      @JsonKey(name: 'fill_rate') this.fillRate = 0});

  factory _$DailySummaryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailySummaryDtoImplFromJson(json);

  @override
  @JsonKey(name: 'date')
  final String date;
  @override
  @JsonKey(name: 'total_required')
  final int totalRequired;
  @override
  @JsonKey(name: 'total_approved')
  final int totalApproved;
  @override
  @JsonKey(name: 'total_pending')
  final int totalPending;
  @override
  @JsonKey(name: 'has_problem')
  final bool hasProblem;
  @override
  @JsonKey(name: 'fill_rate')
  final int fillRate;

  @override
  String toString() {
    return 'DailySummaryDto(date: $date, totalRequired: $totalRequired, totalApproved: $totalApproved, totalPending: $totalPending, hasProblem: $hasProblem, fillRate: $fillRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailySummaryDtoImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.totalRequired, totalRequired) ||
                other.totalRequired == totalRequired) &&
            (identical(other.totalApproved, totalApproved) ||
                other.totalApproved == totalApproved) &&
            (identical(other.totalPending, totalPending) ||
                other.totalPending == totalPending) &&
            (identical(other.hasProblem, hasProblem) ||
                other.hasProblem == hasProblem) &&
            (identical(other.fillRate, fillRate) ||
                other.fillRate == fillRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, totalRequired,
      totalApproved, totalPending, hasProblem, fillRate);

  /// Create a copy of DailySummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailySummaryDtoImplCopyWith<_$DailySummaryDtoImpl> get copyWith =>
      __$$DailySummaryDtoImplCopyWithImpl<_$DailySummaryDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailySummaryDtoImplToJson(
      this,
    );
  }
}

abstract class _DailySummaryDto implements DailySummaryDto {
  const factory _DailySummaryDto(
      {@JsonKey(name: 'date') final String date,
      @JsonKey(name: 'total_required') final int totalRequired,
      @JsonKey(name: 'total_approved') final int totalApproved,
      @JsonKey(name: 'total_pending') final int totalPending,
      @JsonKey(name: 'has_problem') final bool hasProblem,
      @JsonKey(name: 'fill_rate') final int fillRate}) = _$DailySummaryDtoImpl;

  factory _DailySummaryDto.fromJson(Map<String, dynamic> json) =
      _$DailySummaryDtoImpl.fromJson;

  @override
  @JsonKey(name: 'date')
  String get date;
  @override
  @JsonKey(name: 'total_required')
  int get totalRequired;
  @override
  @JsonKey(name: 'total_approved')
  int get totalApproved;
  @override
  @JsonKey(name: 'total_pending')
  int get totalPending;
  @override
  @JsonKey(name: 'has_problem')
  bool get hasProblem;
  @override
  @JsonKey(name: 'fill_rate')
  int get fillRate;

  /// Create a copy of DailySummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailySummaryDtoImplCopyWith<_$DailySummaryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
