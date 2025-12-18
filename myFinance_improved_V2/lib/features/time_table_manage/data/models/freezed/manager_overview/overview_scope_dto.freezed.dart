// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overview_scope_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OverviewScopeDto _$OverviewScopeDtoFromJson(Map<String, dynamic> json) {
  return _OverviewScopeDto.fromJson(json);
}

/// @nodoc
mixin _$OverviewScopeDto {
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String get companyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_stores')
  int get totalStores => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_range')
  DateRangeDto get dateRange => throw _privateConstructorUsedError;

  /// Serializes this OverviewScopeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OverviewScopeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OverviewScopeDtoCopyWith<OverviewScopeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OverviewScopeDtoCopyWith<$Res> {
  factory $OverviewScopeDtoCopyWith(
          OverviewScopeDto value, $Res Function(OverviewScopeDto) then) =
      _$OverviewScopeDtoCopyWithImpl<$Res, OverviewScopeDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'company_name') String companyName,
      @JsonKey(name: 'total_stores') int totalStores,
      @JsonKey(name: 'date_range') DateRangeDto dateRange});

  $DateRangeDtoCopyWith<$Res> get dateRange;
}

/// @nodoc
class _$OverviewScopeDtoCopyWithImpl<$Res, $Val extends OverviewScopeDto>
    implements $OverviewScopeDtoCopyWith<$Res> {
  _$OverviewScopeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OverviewScopeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyId = null,
    Object? companyName = null,
    Object? totalStores = null,
    Object? dateRange = null,
  }) {
    return _then(_value.copyWith(
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      totalStores: null == totalStores
          ? _value.totalStores
          : totalStores // ignore: cast_nullable_to_non_nullable
              as int,
      dateRange: null == dateRange
          ? _value.dateRange
          : dateRange // ignore: cast_nullable_to_non_nullable
              as DateRangeDto,
    ) as $Val);
  }

  /// Create a copy of OverviewScopeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DateRangeDtoCopyWith<$Res> get dateRange {
    return $DateRangeDtoCopyWith<$Res>(_value.dateRange, (value) {
      return _then(_value.copyWith(dateRange: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OverviewScopeDtoImplCopyWith<$Res>
    implements $OverviewScopeDtoCopyWith<$Res> {
  factory _$$OverviewScopeDtoImplCopyWith(_$OverviewScopeDtoImpl value,
          $Res Function(_$OverviewScopeDtoImpl) then) =
      __$$OverviewScopeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'company_name') String companyName,
      @JsonKey(name: 'total_stores') int totalStores,
      @JsonKey(name: 'date_range') DateRangeDto dateRange});

  @override
  $DateRangeDtoCopyWith<$Res> get dateRange;
}

/// @nodoc
class __$$OverviewScopeDtoImplCopyWithImpl<$Res>
    extends _$OverviewScopeDtoCopyWithImpl<$Res, _$OverviewScopeDtoImpl>
    implements _$$OverviewScopeDtoImplCopyWith<$Res> {
  __$$OverviewScopeDtoImplCopyWithImpl(_$OverviewScopeDtoImpl _value,
      $Res Function(_$OverviewScopeDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of OverviewScopeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyId = null,
    Object? companyName = null,
    Object? totalStores = null,
    Object? dateRange = null,
  }) {
    return _then(_$OverviewScopeDtoImpl(
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      totalStores: null == totalStores
          ? _value.totalStores
          : totalStores // ignore: cast_nullable_to_non_nullable
              as int,
      dateRange: null == dateRange
          ? _value.dateRange
          : dateRange // ignore: cast_nullable_to_non_nullable
              as DateRangeDto,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OverviewScopeDtoImpl implements _OverviewScopeDto {
  const _$OverviewScopeDtoImpl(
      {@JsonKey(name: 'company_id') this.companyId = '',
      @JsonKey(name: 'company_name') this.companyName = '',
      @JsonKey(name: 'total_stores') this.totalStores = 0,
      @JsonKey(name: 'date_range') required this.dateRange});

  factory _$OverviewScopeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OverviewScopeDtoImplFromJson(json);

  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'company_name')
  final String companyName;
  @override
  @JsonKey(name: 'total_stores')
  final int totalStores;
  @override
  @JsonKey(name: 'date_range')
  final DateRangeDto dateRange;

  @override
  String toString() {
    return 'OverviewScopeDto(companyId: $companyId, companyName: $companyName, totalStores: $totalStores, dateRange: $dateRange)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OverviewScopeDtoImpl &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.totalStores, totalStores) ||
                other.totalStores == totalStores) &&
            (identical(other.dateRange, dateRange) ||
                other.dateRange == dateRange));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, companyId, companyName, totalStores, dateRange);

  /// Create a copy of OverviewScopeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OverviewScopeDtoImplCopyWith<_$OverviewScopeDtoImpl> get copyWith =>
      __$$OverviewScopeDtoImplCopyWithImpl<_$OverviewScopeDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OverviewScopeDtoImplToJson(
      this,
    );
  }
}

abstract class _OverviewScopeDto implements OverviewScopeDto {
  const factory _OverviewScopeDto(
          {@JsonKey(name: 'company_id') final String companyId,
          @JsonKey(name: 'company_name') final String companyName,
          @JsonKey(name: 'total_stores') final int totalStores,
          @JsonKey(name: 'date_range') required final DateRangeDto dateRange}) =
      _$OverviewScopeDtoImpl;

  factory _OverviewScopeDto.fromJson(Map<String, dynamic> json) =
      _$OverviewScopeDtoImpl.fromJson;

  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'company_name')
  String get companyName;
  @override
  @JsonKey(name: 'total_stores')
  int get totalStores;
  @override
  @JsonKey(name: 'date_range')
  DateRangeDto get dateRange;

  /// Create a copy of OverviewScopeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OverviewScopeDtoImplCopyWith<_$OverviewScopeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
