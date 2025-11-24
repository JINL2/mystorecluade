// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'balance_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BalanceSummary {
  String get locationId => throw _privateConstructorUsedError;
  String get locationName => throw _privateConstructorUsedError;
  String get locationType =>
      throw _privateConstructorUsedError; // Balance amounts
  double get totalJournal => throw _privateConstructorUsedError;
  double get totalReal => throw _privateConstructorUsedError;
  double get difference => throw _privateConstructorUsedError; // Status flags
  bool get isBalanced => throw _privateConstructorUsedError;
  bool get hasShortage => throw _privateConstructorUsedError;
  bool get hasSurplus => throw _privateConstructorUsedError; // Currency info
  String get currencySymbol => throw _privateConstructorUsedError;
  String get currencyCode => throw _privateConstructorUsedError; // Metadata
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  /// Create a copy of BalanceSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BalanceSummaryCopyWith<BalanceSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BalanceSummaryCopyWith<$Res> {
  factory $BalanceSummaryCopyWith(
          BalanceSummary value, $Res Function(BalanceSummary) then) =
      _$BalanceSummaryCopyWithImpl<$Res, BalanceSummary>;
  @useResult
  $Res call(
      {String locationId,
      String locationName,
      String locationType,
      double totalJournal,
      double totalReal,
      double difference,
      bool isBalanced,
      bool hasShortage,
      bool hasSurplus,
      String currencySymbol,
      String currencyCode,
      DateTime? lastUpdated});
}

/// @nodoc
class _$BalanceSummaryCopyWithImpl<$Res, $Val extends BalanceSummary>
    implements $BalanceSummaryCopyWith<$Res> {
  _$BalanceSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BalanceSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
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
  }) {
    return _then(_value.copyWith(
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BalanceSummaryImplCopyWith<$Res>
    implements $BalanceSummaryCopyWith<$Res> {
  factory _$$BalanceSummaryImplCopyWith(_$BalanceSummaryImpl value,
          $Res Function(_$BalanceSummaryImpl) then) =
      __$$BalanceSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String locationId,
      String locationName,
      String locationType,
      double totalJournal,
      double totalReal,
      double difference,
      bool isBalanced,
      bool hasShortage,
      bool hasSurplus,
      String currencySymbol,
      String currencyCode,
      DateTime? lastUpdated});
}

/// @nodoc
class __$$BalanceSummaryImplCopyWithImpl<$Res>
    extends _$BalanceSummaryCopyWithImpl<$Res, _$BalanceSummaryImpl>
    implements _$$BalanceSummaryImplCopyWith<$Res> {
  __$$BalanceSummaryImplCopyWithImpl(
      _$BalanceSummaryImpl _value, $Res Function(_$BalanceSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of BalanceSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
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
  }) {
    return _then(_$BalanceSummaryImpl(
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
    ));
  }
}

/// @nodoc

class _$BalanceSummaryImpl extends _BalanceSummary {
  const _$BalanceSummaryImpl(
      {required this.locationId,
      required this.locationName,
      required this.locationType,
      required this.totalJournal,
      required this.totalReal,
      required this.difference,
      required this.isBalanced,
      required this.hasShortage,
      required this.hasSurplus,
      required this.currencySymbol,
      required this.currencyCode,
      this.lastUpdated})
      : super._();

  @override
  final String locationId;
  @override
  final String locationName;
  @override
  final String locationType;
// Balance amounts
  @override
  final double totalJournal;
  @override
  final double totalReal;
  @override
  final double difference;
// Status flags
  @override
  final bool isBalanced;
  @override
  final bool hasShortage;
  @override
  final bool hasSurplus;
// Currency info
  @override
  final String currencySymbol;
  @override
  final String currencyCode;
// Metadata
  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'BalanceSummary(locationId: $locationId, locationName: $locationName, locationType: $locationType, totalJournal: $totalJournal, totalReal: $totalReal, difference: $difference, isBalanced: $isBalanced, hasShortage: $hasShortage, hasSurplus: $hasSurplus, currencySymbol: $currencySymbol, currencyCode: $currencyCode, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BalanceSummaryImpl &&
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
                other.lastUpdated == lastUpdated));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
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
      lastUpdated);

  /// Create a copy of BalanceSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BalanceSummaryImplCopyWith<_$BalanceSummaryImpl> get copyWith =>
      __$$BalanceSummaryImplCopyWithImpl<_$BalanceSummaryImpl>(
          this, _$identity);
}

abstract class _BalanceSummary extends BalanceSummary {
  const factory _BalanceSummary(
      {required final String locationId,
      required final String locationName,
      required final String locationType,
      required final double totalJournal,
      required final double totalReal,
      required final double difference,
      required final bool isBalanced,
      required final bool hasShortage,
      required final bool hasSurplus,
      required final String currencySymbol,
      required final String currencyCode,
      final DateTime? lastUpdated}) = _$BalanceSummaryImpl;
  const _BalanceSummary._() : super._();

  @override
  String get locationId;
  @override
  String get locationName;
  @override
  String get locationType; // Balance amounts
  @override
  double get totalJournal;
  @override
  double get totalReal;
  @override
  double get difference; // Status flags
  @override
  bool get isBalanced;
  @override
  bool get hasShortage;
  @override
  bool get hasSurplus; // Currency info
  @override
  String get currencySymbol;
  @override
  String get currencyCode; // Metadata
  @override
  DateTime? get lastUpdated;

  /// Create a copy of BalanceSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BalanceSummaryImplCopyWith<_$BalanceSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
