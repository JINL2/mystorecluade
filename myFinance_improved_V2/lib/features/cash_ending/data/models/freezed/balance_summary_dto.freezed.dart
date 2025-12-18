// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'balance_summary_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BalanceSummaryDto _$BalanceSummaryDtoFromJson(Map<String, dynamic> json) {
  return _BalanceSummaryDto.fromJson(json);
}

/// @nodoc
mixin _$BalanceSummaryDto {
  bool get success => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_id')
  String get locationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_name')
  String get locationName => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_type')
  String get locationType =>
      throw _privateConstructorUsedError; // Balance amounts
  @JsonKey(name: 'total_journal')
  double get totalJournal => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_real')
  double get totalReal => throw _privateConstructorUsedError;
  double get difference => throw _privateConstructorUsedError; // Status flags
  @JsonKey(name: 'is_balanced')
  bool get isBalanced => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_shortage')
  bool get hasShortage => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_surplus')
  bool get hasSurplus => throw _privateConstructorUsedError; // Currency info
  @JsonKey(name: 'currency_symbol')
  String get currencySymbol => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_code')
  String get currencyCode => throw _privateConstructorUsedError; // Metadata
  @JsonKey(name: 'last_updated')
  DateTime? get lastUpdated => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this BalanceSummaryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BalanceSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BalanceSummaryDtoCopyWith<BalanceSummaryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BalanceSummaryDtoCopyWith<$Res> {
  factory $BalanceSummaryDtoCopyWith(
          BalanceSummaryDto value, $Res Function(BalanceSummaryDto) then) =
      _$BalanceSummaryDtoCopyWithImpl<$Res, BalanceSummaryDto>;
  @useResult
  $Res call(
      {bool success,
      @JsonKey(name: 'location_id') String locationId,
      @JsonKey(name: 'location_name') String locationName,
      @JsonKey(name: 'location_type') String locationType,
      @JsonKey(name: 'total_journal') double totalJournal,
      @JsonKey(name: 'total_real') double totalReal,
      double difference,
      @JsonKey(name: 'is_balanced') bool isBalanced,
      @JsonKey(name: 'has_shortage') bool hasShortage,
      @JsonKey(name: 'has_surplus') bool hasSurplus,
      @JsonKey(name: 'currency_symbol') String currencySymbol,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'last_updated') DateTime? lastUpdated,
      String? error});
}

/// @nodoc
class _$BalanceSummaryDtoCopyWithImpl<$Res, $Val extends BalanceSummaryDto>
    implements $BalanceSummaryDtoCopyWith<$Res> {
  _$BalanceSummaryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BalanceSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? locationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? totalJournal = null,
    Object? totalReal = null,
    Object? difference = null,
    Object? isBalanced = null,
    Object? hasShortage = null,
    Object? hasSurplus = null,
    Object? currencySymbol = null,
    Object? currencyCode = null,
    Object? lastUpdated = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
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
      totalJournal: null == totalJournal
          ? _value.totalJournal
          : totalJournal // ignore: cast_nullable_to_non_nullable
              as double,
      totalReal: null == totalReal
          ? _value.totalReal
          : totalReal // ignore: cast_nullable_to_non_nullable
              as double,
      difference: null == difference
          ? _value.difference
          : difference // ignore: cast_nullable_to_non_nullable
              as double,
      isBalanced: null == isBalanced
          ? _value.isBalanced
          : isBalanced // ignore: cast_nullable_to_non_nullable
              as bool,
      hasShortage: null == hasShortage
          ? _value.hasShortage
          : hasShortage // ignore: cast_nullable_to_non_nullable
              as bool,
      hasSurplus: null == hasSurplus
          ? _value.hasSurplus
          : hasSurplus // ignore: cast_nullable_to_non_nullable
              as bool,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BalanceSummaryDtoImplCopyWith<$Res>
    implements $BalanceSummaryDtoCopyWith<$Res> {
  factory _$$BalanceSummaryDtoImplCopyWith(_$BalanceSummaryDtoImpl value,
          $Res Function(_$BalanceSummaryDtoImpl) then) =
      __$$BalanceSummaryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      @JsonKey(name: 'location_id') String locationId,
      @JsonKey(name: 'location_name') String locationName,
      @JsonKey(name: 'location_type') String locationType,
      @JsonKey(name: 'total_journal') double totalJournal,
      @JsonKey(name: 'total_real') double totalReal,
      double difference,
      @JsonKey(name: 'is_balanced') bool isBalanced,
      @JsonKey(name: 'has_shortage') bool hasShortage,
      @JsonKey(name: 'has_surplus') bool hasSurplus,
      @JsonKey(name: 'currency_symbol') String currencySymbol,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'last_updated') DateTime? lastUpdated,
      String? error});
}

/// @nodoc
class __$$BalanceSummaryDtoImplCopyWithImpl<$Res>
    extends _$BalanceSummaryDtoCopyWithImpl<$Res, _$BalanceSummaryDtoImpl>
    implements _$$BalanceSummaryDtoImplCopyWith<$Res> {
  __$$BalanceSummaryDtoImplCopyWithImpl(_$BalanceSummaryDtoImpl _value,
      $Res Function(_$BalanceSummaryDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BalanceSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? locationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? totalJournal = null,
    Object? totalReal = null,
    Object? difference = null,
    Object? isBalanced = null,
    Object? hasShortage = null,
    Object? hasSurplus = null,
    Object? currencySymbol = null,
    Object? currencyCode = null,
    Object? lastUpdated = freezed,
    Object? error = freezed,
  }) {
    return _then(_$BalanceSummaryDtoImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
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
      totalJournal: null == totalJournal
          ? _value.totalJournal
          : totalJournal // ignore: cast_nullable_to_non_nullable
              as double,
      totalReal: null == totalReal
          ? _value.totalReal
          : totalReal // ignore: cast_nullable_to_non_nullable
              as double,
      difference: null == difference
          ? _value.difference
          : difference // ignore: cast_nullable_to_non_nullable
              as double,
      isBalanced: null == isBalanced
          ? _value.isBalanced
          : isBalanced // ignore: cast_nullable_to_non_nullable
              as bool,
      hasShortage: null == hasShortage
          ? _value.hasShortage
          : hasShortage // ignore: cast_nullable_to_non_nullable
              as bool,
      hasSurplus: null == hasSurplus
          ? _value.hasSurplus
          : hasSurplus // ignore: cast_nullable_to_non_nullable
              as bool,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BalanceSummaryDtoImpl extends _BalanceSummaryDto {
  const _$BalanceSummaryDtoImpl(
      {required this.success,
      @JsonKey(name: 'location_id') required this.locationId,
      @JsonKey(name: 'location_name') required this.locationName,
      @JsonKey(name: 'location_type') required this.locationType,
      @JsonKey(name: 'total_journal') required this.totalJournal,
      @JsonKey(name: 'total_real') required this.totalReal,
      required this.difference,
      @JsonKey(name: 'is_balanced') required this.isBalanced,
      @JsonKey(name: 'has_shortage') required this.hasShortage,
      @JsonKey(name: 'has_surplus') required this.hasSurplus,
      @JsonKey(name: 'currency_symbol') required this.currencySymbol,
      @JsonKey(name: 'currency_code') required this.currencyCode,
      @JsonKey(name: 'last_updated') this.lastUpdated,
      this.error})
      : super._();

  factory _$BalanceSummaryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BalanceSummaryDtoImplFromJson(json);

  @override
  final bool success;
  @override
  @JsonKey(name: 'location_id')
  final String locationId;
  @override
  @JsonKey(name: 'location_name')
  final String locationName;
  @override
  @JsonKey(name: 'location_type')
  final String locationType;
// Balance amounts
  @override
  @JsonKey(name: 'total_journal')
  final double totalJournal;
  @override
  @JsonKey(name: 'total_real')
  final double totalReal;
  @override
  final double difference;
// Status flags
  @override
  @JsonKey(name: 'is_balanced')
  final bool isBalanced;
  @override
  @JsonKey(name: 'has_shortage')
  final bool hasShortage;
  @override
  @JsonKey(name: 'has_surplus')
  final bool hasSurplus;
// Currency info
  @override
  @JsonKey(name: 'currency_symbol')
  final String currencySymbol;
  @override
  @JsonKey(name: 'currency_code')
  final String currencyCode;
// Metadata
  @override
  @JsonKey(name: 'last_updated')
  final DateTime? lastUpdated;
  @override
  final String? error;

  @override
  String toString() {
    return 'BalanceSummaryDto(success: $success, locationId: $locationId, locationName: $locationName, locationType: $locationType, totalJournal: $totalJournal, totalReal: $totalReal, difference: $difference, isBalanced: $isBalanced, hasShortage: $hasShortage, hasSurplus: $hasSurplus, currencySymbol: $currencySymbol, currencyCode: $currencyCode, lastUpdated: $lastUpdated, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BalanceSummaryDtoImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.locationType, locationType) ||
                other.locationType == locationType) &&
            (identical(other.totalJournal, totalJournal) ||
                other.totalJournal == totalJournal) &&
            (identical(other.totalReal, totalReal) ||
                other.totalReal == totalReal) &&
            (identical(other.difference, difference) ||
                other.difference == difference) &&
            (identical(other.isBalanced, isBalanced) ||
                other.isBalanced == isBalanced) &&
            (identical(other.hasShortage, hasShortage) ||
                other.hasShortage == hasShortage) &&
            (identical(other.hasSurplus, hasSurplus) ||
                other.hasSurplus == hasSurplus) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      locationId,
      locationName,
      locationType,
      totalJournal,
      totalReal,
      difference,
      isBalanced,
      hasShortage,
      hasSurplus,
      currencySymbol,
      currencyCode,
      lastUpdated,
      error);

  /// Create a copy of BalanceSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BalanceSummaryDtoImplCopyWith<_$BalanceSummaryDtoImpl> get copyWith =>
      __$$BalanceSummaryDtoImplCopyWithImpl<_$BalanceSummaryDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BalanceSummaryDtoImplToJson(
      this,
    );
  }
}

abstract class _BalanceSummaryDto extends BalanceSummaryDto {
  const factory _BalanceSummaryDto(
      {required final bool success,
      @JsonKey(name: 'location_id') required final String locationId,
      @JsonKey(name: 'location_name') required final String locationName,
      @JsonKey(name: 'location_type') required final String locationType,
      @JsonKey(name: 'total_journal') required final double totalJournal,
      @JsonKey(name: 'total_real') required final double totalReal,
      required final double difference,
      @JsonKey(name: 'is_balanced') required final bool isBalanced,
      @JsonKey(name: 'has_shortage') required final bool hasShortage,
      @JsonKey(name: 'has_surplus') required final bool hasSurplus,
      @JsonKey(name: 'currency_symbol') required final String currencySymbol,
      @JsonKey(name: 'currency_code') required final String currencyCode,
      @JsonKey(name: 'last_updated') final DateTime? lastUpdated,
      final String? error}) = _$BalanceSummaryDtoImpl;
  const _BalanceSummaryDto._() : super._();

  factory _BalanceSummaryDto.fromJson(Map<String, dynamic> json) =
      _$BalanceSummaryDtoImpl.fromJson;

  @override
  bool get success;
  @override
  @JsonKey(name: 'location_id')
  String get locationId;
  @override
  @JsonKey(name: 'location_name')
  String get locationName;
  @override
  @JsonKey(name: 'location_type')
  String get locationType; // Balance amounts
  @override
  @JsonKey(name: 'total_journal')
  double get totalJournal;
  @override
  @JsonKey(name: 'total_real')
  double get totalReal;
  @override
  double get difference; // Status flags
  @override
  @JsonKey(name: 'is_balanced')
  bool get isBalanced;
  @override
  @JsonKey(name: 'has_shortage')
  bool get hasShortage;
  @override
  @JsonKey(name: 'has_surplus')
  bool get hasSurplus; // Currency info
  @override
  @JsonKey(name: 'currency_symbol')
  String get currencySymbol;
  @override
  @JsonKey(name: 'currency_code')
  String get currencyCode; // Metadata
  @override
  @JsonKey(name: 'last_updated')
  DateTime? get lastUpdated;
  @override
  String? get error;

  /// Create a copy of BalanceSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BalanceSummaryDtoImplCopyWith<_$BalanceSummaryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
