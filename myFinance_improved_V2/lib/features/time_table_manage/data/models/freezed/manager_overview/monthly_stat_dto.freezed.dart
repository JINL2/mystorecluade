// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_stat_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MonthlyStatDto _$MonthlyStatDtoFromJson(Map<String, dynamic> json) {
  return _MonthlyStatDto.fromJson(json);
}

/// @nodoc
mixin _$MonthlyStatDto {
  @JsonKey(name: 'month')
  String get month => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_requests')
  int get totalRequests => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_approved')
  int get totalApproved => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pending')
  int get totalPending => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_problems')
  int get totalProblems => throw _privateConstructorUsedError;

  /// Serializes this MonthlyStatDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyStatDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyStatDtoCopyWith<MonthlyStatDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyStatDtoCopyWith<$Res> {
  factory $MonthlyStatDtoCopyWith(
          MonthlyStatDto value, $Res Function(MonthlyStatDto) then) =
      _$MonthlyStatDtoCopyWithImpl<$Res, MonthlyStatDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'month') String month,
      @JsonKey(name: 'total_requests') int totalRequests,
      @JsonKey(name: 'total_approved') int totalApproved,
      @JsonKey(name: 'total_pending') int totalPending,
      @JsonKey(name: 'total_problems') int totalProblems});
}

/// @nodoc
class _$MonthlyStatDtoCopyWithImpl<$Res, $Val extends MonthlyStatDto>
    implements $MonthlyStatDtoCopyWith<$Res> {
  _$MonthlyStatDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyStatDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? totalRequests = null,
    Object? totalApproved = null,
    Object? totalPending = null,
    Object? totalProblems = null,
  }) {
    return _then(_value.copyWith(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      totalRequests: null == totalRequests
          ? _value.totalRequests
          : totalRequests // ignore: cast_nullable_to_non_nullable
              as int,
      totalApproved: null == totalApproved
          ? _value.totalApproved
          : totalApproved // ignore: cast_nullable_to_non_nullable
              as int,
      totalPending: null == totalPending
          ? _value.totalPending
          : totalPending // ignore: cast_nullable_to_non_nullable
              as int,
      totalProblems: null == totalProblems
          ? _value.totalProblems
          : totalProblems // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyStatDtoImplCopyWith<$Res>
    implements $MonthlyStatDtoCopyWith<$Res> {
  factory _$$MonthlyStatDtoImplCopyWith(_$MonthlyStatDtoImpl value,
          $Res Function(_$MonthlyStatDtoImpl) then) =
      __$$MonthlyStatDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'month') String month,
      @JsonKey(name: 'total_requests') int totalRequests,
      @JsonKey(name: 'total_approved') int totalApproved,
      @JsonKey(name: 'total_pending') int totalPending,
      @JsonKey(name: 'total_problems') int totalProblems});
}

/// @nodoc
class __$$MonthlyStatDtoImplCopyWithImpl<$Res>
    extends _$MonthlyStatDtoCopyWithImpl<$Res, _$MonthlyStatDtoImpl>
    implements _$$MonthlyStatDtoImplCopyWith<$Res> {
  __$$MonthlyStatDtoImplCopyWithImpl(
      _$MonthlyStatDtoImpl _value, $Res Function(_$MonthlyStatDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyStatDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? totalRequests = null,
    Object? totalApproved = null,
    Object? totalPending = null,
    Object? totalProblems = null,
  }) {
    return _then(_$MonthlyStatDtoImpl(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      totalRequests: null == totalRequests
          ? _value.totalRequests
          : totalRequests // ignore: cast_nullable_to_non_nullable
              as int,
      totalApproved: null == totalApproved
          ? _value.totalApproved
          : totalApproved // ignore: cast_nullable_to_non_nullable
              as int,
      totalPending: null == totalPending
          ? _value.totalPending
          : totalPending // ignore: cast_nullable_to_non_nullable
              as int,
      totalProblems: null == totalProblems
          ? _value.totalProblems
          : totalProblems // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlyStatDtoImpl implements _MonthlyStatDto {
  const _$MonthlyStatDtoImpl(
      {@JsonKey(name: 'month') this.month = '',
      @JsonKey(name: 'total_requests') this.totalRequests = 0,
      @JsonKey(name: 'total_approved') this.totalApproved = 0,
      @JsonKey(name: 'total_pending') this.totalPending = 0,
      @JsonKey(name: 'total_problems') this.totalProblems = 0});

  factory _$MonthlyStatDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlyStatDtoImplFromJson(json);

  @override
  @JsonKey(name: 'month')
  final String month;
  @override
  @JsonKey(name: 'total_requests')
  final int totalRequests;
  @override
  @JsonKey(name: 'total_approved')
  final int totalApproved;
  @override
  @JsonKey(name: 'total_pending')
  final int totalPending;
  @override
  @JsonKey(name: 'total_problems')
  final int totalProblems;

  @override
  String toString() {
    return 'MonthlyStatDto(month: $month, totalRequests: $totalRequests, totalApproved: $totalApproved, totalPending: $totalPending, totalProblems: $totalProblems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyStatDtoImpl &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.totalRequests, totalRequests) ||
                other.totalRequests == totalRequests) &&
            (identical(other.totalApproved, totalApproved) ||
                other.totalApproved == totalApproved) &&
            (identical(other.totalPending, totalPending) ||
                other.totalPending == totalPending) &&
            (identical(other.totalProblems, totalProblems) ||
                other.totalProblems == totalProblems));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, month, totalRequests,
      totalApproved, totalPending, totalProblems);

  /// Create a copy of MonthlyStatDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyStatDtoImplCopyWith<_$MonthlyStatDtoImpl> get copyWith =>
      __$$MonthlyStatDtoImplCopyWithImpl<_$MonthlyStatDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlyStatDtoImplToJson(
      this,
    );
  }
}

abstract class _MonthlyStatDto implements MonthlyStatDto {
  const factory _MonthlyStatDto(
          {@JsonKey(name: 'month') final String month,
          @JsonKey(name: 'total_requests') final int totalRequests,
          @JsonKey(name: 'total_approved') final int totalApproved,
          @JsonKey(name: 'total_pending') final int totalPending,
          @JsonKey(name: 'total_problems') final int totalProblems}) =
      _$MonthlyStatDtoImpl;

  factory _MonthlyStatDto.fromJson(Map<String, dynamic> json) =
      _$MonthlyStatDtoImpl.fromJson;

  @override
  @JsonKey(name: 'month')
  String get month;
  @override
  @JsonKey(name: 'total_requests')
  int get totalRequests;
  @override
  @JsonKey(name: 'total_approved')
  int get totalApproved;
  @override
  @JsonKey(name: 'total_pending')
  int get totalPending;
  @override
  @JsonKey(name: 'total_problems')
  int get totalProblems;

  /// Create a copy of MonthlyStatDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyStatDtoImplCopyWith<_$MonthlyStatDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
