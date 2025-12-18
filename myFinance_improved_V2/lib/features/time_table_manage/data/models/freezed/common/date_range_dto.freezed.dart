// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'date_range_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DateRangeDto _$DateRangeDtoFromJson(Map<String, dynamic> json) {
  return _DateRangeDto.fromJson(json);
}

/// @nodoc
mixin _$DateRangeDto {
  @JsonKey(name: 'start_date')
  String get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  String get endDate => throw _privateConstructorUsedError;

  /// Serializes this DateRangeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DateRangeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DateRangeDtoCopyWith<DateRangeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DateRangeDtoCopyWith<$Res> {
  factory $DateRangeDtoCopyWith(
          DateRangeDto value, $Res Function(DateRangeDto) then) =
      _$DateRangeDtoCopyWithImpl<$Res, DateRangeDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate});
}

/// @nodoc
class _$DateRangeDtoCopyWithImpl<$Res, $Val extends DateRangeDto>
    implements $DateRangeDtoCopyWith<$Res> {
  _$DateRangeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DateRangeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(_value.copyWith(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DateRangeDtoImplCopyWith<$Res>
    implements $DateRangeDtoCopyWith<$Res> {
  factory _$$DateRangeDtoImplCopyWith(
          _$DateRangeDtoImpl value, $Res Function(_$DateRangeDtoImpl) then) =
      __$$DateRangeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate});
}

/// @nodoc
class __$$DateRangeDtoImplCopyWithImpl<$Res>
    extends _$DateRangeDtoCopyWithImpl<$Res, _$DateRangeDtoImpl>
    implements _$$DateRangeDtoImplCopyWith<$Res> {
  __$$DateRangeDtoImplCopyWithImpl(
      _$DateRangeDtoImpl _value, $Res Function(_$DateRangeDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of DateRangeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(_$DateRangeDtoImpl(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DateRangeDtoImpl implements _DateRangeDto {
  const _$DateRangeDtoImpl(
      {@JsonKey(name: 'start_date') this.startDate = '',
      @JsonKey(name: 'end_date') this.endDate = ''});

  factory _$DateRangeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DateRangeDtoImplFromJson(json);

  @override
  @JsonKey(name: 'start_date')
  final String startDate;
  @override
  @JsonKey(name: 'end_date')
  final String endDate;

  @override
  String toString() {
    return 'DateRangeDto(startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DateRangeDtoImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, startDate, endDate);

  /// Create a copy of DateRangeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DateRangeDtoImplCopyWith<_$DateRangeDtoImpl> get copyWith =>
      __$$DateRangeDtoImplCopyWithImpl<_$DateRangeDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DateRangeDtoImplToJson(
      this,
    );
  }
}

abstract class _DateRangeDto implements DateRangeDto {
  const factory _DateRangeDto(
      {@JsonKey(name: 'start_date') final String startDate,
      @JsonKey(name: 'end_date') final String endDate}) = _$DateRangeDtoImpl;

  factory _DateRangeDto.fromJson(Map<String, dynamic> json) =
      _$DateRangeDtoImpl.fromJson;

  @override
  @JsonKey(name: 'start_date')
  String get startDate;
  @override
  @JsonKey(name: 'end_date')
  String get endDate;

  /// Create a copy of DateRangeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DateRangeDtoImplCopyWith<_$DateRangeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
