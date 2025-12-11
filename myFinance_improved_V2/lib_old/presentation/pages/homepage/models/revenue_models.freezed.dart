// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'revenue_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RevenueData _$RevenueDataFromJson(Map<String, dynamic> json) {
  return _RevenueData.fromJson(json);
}

/// @nodoc
mixin _$RevenueData {
  double get amount => throw _privateConstructorUsedError;
  String get currencySymbol => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;
  double get comparisonAmount => throw _privateConstructorUsedError;
  String get comparisonPeriod => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Serializes this RevenueData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RevenueData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RevenueDataCopyWith<RevenueData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RevenueDataCopyWith<$Res> {
  factory $RevenueDataCopyWith(
          RevenueData value, $Res Function(RevenueData) then) =
      _$RevenueDataCopyWithImpl<$Res, RevenueData>;
  @useResult
  $Res call(
      {double amount,
      String currencySymbol,
      String period,
      double comparisonAmount,
      String comparisonPeriod,
      DateTime? lastUpdated,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class _$RevenueDataCopyWithImpl<$Res, $Val extends RevenueData>
    implements $RevenueDataCopyWith<$Res> {
  _$RevenueDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RevenueData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? currencySymbol = null,
    Object? period = null,
    Object? comparisonAmount = null,
    Object? comparisonPeriod = null,
    Object? lastUpdated = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      comparisonAmount: null == comparisonAmount
          ? _value.comparisonAmount
          : comparisonAmount // ignore: cast_nullable_to_non_nullable
              as double,
      comparisonPeriod: null == comparisonPeriod
          ? _value.comparisonPeriod
          : comparisonPeriod // ignore: cast_nullable_to_non_nullable
              as String,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RevenueDataImplCopyWith<$Res>
    implements $RevenueDataCopyWith<$Res> {
  factory _$$RevenueDataImplCopyWith(
          _$RevenueDataImpl value, $Res Function(_$RevenueDataImpl) then) =
      __$$RevenueDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double amount,
      String currencySymbol,
      String period,
      double comparisonAmount,
      String comparisonPeriod,
      DateTime? lastUpdated,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class __$$RevenueDataImplCopyWithImpl<$Res>
    extends _$RevenueDataCopyWithImpl<$Res, _$RevenueDataImpl>
    implements _$$RevenueDataImplCopyWith<$Res> {
  __$$RevenueDataImplCopyWithImpl(
      _$RevenueDataImpl _value, $Res Function(_$RevenueDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of RevenueData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? currencySymbol = null,
    Object? period = null,
    Object? comparisonAmount = null,
    Object? comparisonPeriod = null,
    Object? lastUpdated = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$RevenueDataImpl(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      comparisonAmount: null == comparisonAmount
          ? _value.comparisonAmount
          : comparisonAmount // ignore: cast_nullable_to_non_nullable
              as double,
      comparisonPeriod: null == comparisonPeriod
          ? _value.comparisonPeriod
          : comparisonPeriod // ignore: cast_nullable_to_non_nullable
              as String,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RevenueDataImpl implements _RevenueData {
  const _$RevenueDataImpl(
      {this.amount = 0.0,
      this.currencySymbol = 'USD',
      this.period = 'Today',
      this.comparisonAmount = 0.0,
      this.comparisonPeriod = '',
      this.lastUpdated,
      this.isLoading = false,
      this.errorMessage});

  factory _$RevenueDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$RevenueDataImplFromJson(json);

  @override
  @JsonKey()
  final double amount;
  @override
  @JsonKey()
  final String currencySymbol;
  @override
  @JsonKey()
  final String period;
  @override
  @JsonKey()
  final double comparisonAmount;
  @override
  @JsonKey()
  final String comparisonPeriod;
  @override
  final DateTime? lastUpdated;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'RevenueData(amount: $amount, currencySymbol: $currencySymbol, period: $period, comparisonAmount: $comparisonAmount, comparisonPeriod: $comparisonPeriod, lastUpdated: $lastUpdated, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RevenueDataImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.comparisonAmount, comparisonAmount) ||
                other.comparisonAmount == comparisonAmount) &&
            (identical(other.comparisonPeriod, comparisonPeriod) ||
                other.comparisonPeriod == comparisonPeriod) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, amount, currencySymbol, period,
      comparisonAmount, comparisonPeriod, lastUpdated, isLoading, errorMessage);

  /// Create a copy of RevenueData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RevenueDataImplCopyWith<_$RevenueDataImpl> get copyWith =>
      __$$RevenueDataImplCopyWithImpl<_$RevenueDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RevenueDataImplToJson(
      this,
    );
  }
}

abstract class _RevenueData implements RevenueData {
  const factory _RevenueData(
      {final double amount,
      final String currencySymbol,
      final String period,
      final double comparisonAmount,
      final String comparisonPeriod,
      final DateTime? lastUpdated,
      final bool isLoading,
      final String? errorMessage}) = _$RevenueDataImpl;

  factory _RevenueData.fromJson(Map<String, dynamic> json) =
      _$RevenueDataImpl.fromJson;

  @override
  double get amount;
  @override
  String get currencySymbol;
  @override
  String get period;
  @override
  double get comparisonAmount;
  @override
  String get comparisonPeriod;
  @override
  DateTime? get lastUpdated;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;

  /// Create a copy of RevenueData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RevenueDataImplCopyWith<_$RevenueDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RevenueResponse _$RevenueResponseFromJson(Map<String, dynamic> json) {
  return _RevenueResponse.fromJson(json);
}

/// @nodoc
mixin _$RevenueResponse {
  double get amount => throw _privateConstructorUsedError;
  String get currencySymbol => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;
  double? get comparisonAmount => throw _privateConstructorUsedError;
  String? get comparisonPeriod => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;
  String? get storeId => throw _privateConstructorUsedError;
  String? get companyId => throw _privateConstructorUsedError;

  /// Serializes this RevenueResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RevenueResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RevenueResponseCopyWith<RevenueResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RevenueResponseCopyWith<$Res> {
  factory $RevenueResponseCopyWith(
          RevenueResponse value, $Res Function(RevenueResponse) then) =
      _$RevenueResponseCopyWithImpl<$Res, RevenueResponse>;
  @useResult
  $Res call(
      {double amount,
      String currencySymbol,
      String period,
      double? comparisonAmount,
      String? comparisonPeriod,
      DateTime? lastUpdated,
      String? storeId,
      String? companyId});
}

/// @nodoc
class _$RevenueResponseCopyWithImpl<$Res, $Val extends RevenueResponse>
    implements $RevenueResponseCopyWith<$Res> {
  _$RevenueResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RevenueResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? currencySymbol = null,
    Object? period = null,
    Object? comparisonAmount = freezed,
    Object? comparisonPeriod = freezed,
    Object? lastUpdated = freezed,
    Object? storeId = freezed,
    Object? companyId = freezed,
  }) {
    return _then(_value.copyWith(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      comparisonAmount: freezed == comparisonAmount
          ? _value.comparisonAmount
          : comparisonAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      comparisonPeriod: freezed == comparisonPeriod
          ? _value.comparisonPeriod
          : comparisonPeriod // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RevenueResponseImplCopyWith<$Res>
    implements $RevenueResponseCopyWith<$Res> {
  factory _$$RevenueResponseImplCopyWith(_$RevenueResponseImpl value,
          $Res Function(_$RevenueResponseImpl) then) =
      __$$RevenueResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double amount,
      String currencySymbol,
      String period,
      double? comparisonAmount,
      String? comparisonPeriod,
      DateTime? lastUpdated,
      String? storeId,
      String? companyId});
}

/// @nodoc
class __$$RevenueResponseImplCopyWithImpl<$Res>
    extends _$RevenueResponseCopyWithImpl<$Res, _$RevenueResponseImpl>
    implements _$$RevenueResponseImplCopyWith<$Res> {
  __$$RevenueResponseImplCopyWithImpl(
      _$RevenueResponseImpl _value, $Res Function(_$RevenueResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of RevenueResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? currencySymbol = null,
    Object? period = null,
    Object? comparisonAmount = freezed,
    Object? comparisonPeriod = freezed,
    Object? lastUpdated = freezed,
    Object? storeId = freezed,
    Object? companyId = freezed,
  }) {
    return _then(_$RevenueResponseImpl(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      comparisonAmount: freezed == comparisonAmount
          ? _value.comparisonAmount
          : comparisonAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      comparisonPeriod: freezed == comparisonPeriod
          ? _value.comparisonPeriod
          : comparisonPeriod // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$RevenueResponseImpl implements _RevenueResponse {
  const _$RevenueResponseImpl(
      {required this.amount,
      required this.currencySymbol,
      required this.period,
      this.comparisonAmount,
      this.comparisonPeriod,
      this.lastUpdated,
      this.storeId,
      this.companyId});

  factory _$RevenueResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RevenueResponseImplFromJson(json);

  @override
  final double amount;
  @override
  final String currencySymbol;
  @override
  final String period;
  @override
  final double? comparisonAmount;
  @override
  final String? comparisonPeriod;
  @override
  final DateTime? lastUpdated;
  @override
  final String? storeId;
  @override
  final String? companyId;

  @override
  String toString() {
    return 'RevenueResponse(amount: $amount, currencySymbol: $currencySymbol, period: $period, comparisonAmount: $comparisonAmount, comparisonPeriod: $comparisonPeriod, lastUpdated: $lastUpdated, storeId: $storeId, companyId: $companyId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RevenueResponseImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.comparisonAmount, comparisonAmount) ||
                other.comparisonAmount == comparisonAmount) &&
            (identical(other.comparisonPeriod, comparisonPeriod) ||
                other.comparisonPeriod == comparisonPeriod) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, amount, currencySymbol, period,
      comparisonAmount, comparisonPeriod, lastUpdated, storeId, companyId);

  /// Create a copy of RevenueResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RevenueResponseImplCopyWith<_$RevenueResponseImpl> get copyWith =>
      __$$RevenueResponseImplCopyWithImpl<_$RevenueResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RevenueResponseImplToJson(
      this,
    );
  }
}

abstract class _RevenueResponse implements RevenueResponse {
  const factory _RevenueResponse(
      {required final double amount,
      required final String currencySymbol,
      required final String period,
      final double? comparisonAmount,
      final String? comparisonPeriod,
      final DateTime? lastUpdated,
      final String? storeId,
      final String? companyId}) = _$RevenueResponseImpl;

  factory _RevenueResponse.fromJson(Map<String, dynamic> json) =
      _$RevenueResponseImpl.fromJson;

  @override
  double get amount;
  @override
  String get currencySymbol;
  @override
  String get period;
  @override
  double? get comparisonAmount;
  @override
  String? get comparisonPeriod;
  @override
  DateTime? get lastUpdated;
  @override
  String? get storeId;
  @override
  String? get companyId;

  /// Create a copy of RevenueResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RevenueResponseImplCopyWith<_$RevenueResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RevenueCategoryBreakdown _$RevenueCategoryBreakdownFromJson(
    Map<String, dynamic> json) {
  return _RevenueCategoryBreakdown.fromJson(json);
}

/// @nodoc
mixin _$RevenueCategoryBreakdown {
  String get category => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;
  String get iconName => throw _privateConstructorUsedError;
  String get colorHex => throw _privateConstructorUsedError;

  /// Serializes this RevenueCategoryBreakdown to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RevenueCategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RevenueCategoryBreakdownCopyWith<RevenueCategoryBreakdown> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RevenueCategoryBreakdownCopyWith<$Res> {
  factory $RevenueCategoryBreakdownCopyWith(RevenueCategoryBreakdown value,
          $Res Function(RevenueCategoryBreakdown) then) =
      _$RevenueCategoryBreakdownCopyWithImpl<$Res, RevenueCategoryBreakdown>;
  @useResult
  $Res call(
      {String category,
      double amount,
      double percentage,
      String iconName,
      String colorHex});
}

/// @nodoc
class _$RevenueCategoryBreakdownCopyWithImpl<$Res,
        $Val extends RevenueCategoryBreakdown>
    implements $RevenueCategoryBreakdownCopyWith<$Res> {
  _$RevenueCategoryBreakdownCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RevenueCategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? amount = null,
    Object? percentage = null,
    Object? iconName = null,
    Object? colorHex = null,
  }) {
    return _then(_value.copyWith(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      iconName: null == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String,
      colorHex: null == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RevenueCategoryBreakdownImplCopyWith<$Res>
    implements $RevenueCategoryBreakdownCopyWith<$Res> {
  factory _$$RevenueCategoryBreakdownImplCopyWith(
          _$RevenueCategoryBreakdownImpl value,
          $Res Function(_$RevenueCategoryBreakdownImpl) then) =
      __$$RevenueCategoryBreakdownImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String category,
      double amount,
      double percentage,
      String iconName,
      String colorHex});
}

/// @nodoc
class __$$RevenueCategoryBreakdownImplCopyWithImpl<$Res>
    extends _$RevenueCategoryBreakdownCopyWithImpl<$Res,
        _$RevenueCategoryBreakdownImpl>
    implements _$$RevenueCategoryBreakdownImplCopyWith<$Res> {
  __$$RevenueCategoryBreakdownImplCopyWithImpl(
      _$RevenueCategoryBreakdownImpl _value,
      $Res Function(_$RevenueCategoryBreakdownImpl) _then)
      : super(_value, _then);

  /// Create a copy of RevenueCategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? amount = null,
    Object? percentage = null,
    Object? iconName = null,
    Object? colorHex = null,
  }) {
    return _then(_$RevenueCategoryBreakdownImpl(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      iconName: null == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String,
      colorHex: null == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RevenueCategoryBreakdownImpl implements _RevenueCategoryBreakdown {
  const _$RevenueCategoryBreakdownImpl(
      {required this.category,
      required this.amount,
      required this.percentage,
      this.iconName = '',
      this.colorHex = '#000000'});

  factory _$RevenueCategoryBreakdownImpl.fromJson(Map<String, dynamic> json) =>
      _$$RevenueCategoryBreakdownImplFromJson(json);

  @override
  final String category;
  @override
  final double amount;
  @override
  final double percentage;
  @override
  @JsonKey()
  final String iconName;
  @override
  @JsonKey()
  final String colorHex;

  @override
  String toString() {
    return 'RevenueCategoryBreakdown(category: $category, amount: $amount, percentage: $percentage, iconName: $iconName, colorHex: $colorHex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RevenueCategoryBreakdownImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, category, amount, percentage, iconName, colorHex);

  /// Create a copy of RevenueCategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RevenueCategoryBreakdownImplCopyWith<_$RevenueCategoryBreakdownImpl>
      get copyWith => __$$RevenueCategoryBreakdownImplCopyWithImpl<
          _$RevenueCategoryBreakdownImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RevenueCategoryBreakdownImplToJson(
      this,
    );
  }
}

abstract class _RevenueCategoryBreakdown implements RevenueCategoryBreakdown {
  const factory _RevenueCategoryBreakdown(
      {required final String category,
      required final double amount,
      required final double percentage,
      final String iconName,
      final String colorHex}) = _$RevenueCategoryBreakdownImpl;

  factory _RevenueCategoryBreakdown.fromJson(Map<String, dynamic> json) =
      _$RevenueCategoryBreakdownImpl.fromJson;

  @override
  String get category;
  @override
  double get amount;
  @override
  double get percentage;
  @override
  String get iconName;
  @override
  String get colorHex;

  /// Create a copy of RevenueCategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RevenueCategoryBreakdownImplCopyWith<_$RevenueCategoryBreakdownImpl>
      get copyWith => throw _privateConstructorUsedError;
}

DailyRevenueSummary _$DailyRevenueSummaryFromJson(Map<String, dynamic> json) {
  return _DailyRevenueSummary.fromJson(json);
}

/// @nodoc
mixin _$DailyRevenueSummary {
  DateTime get date => throw _privateConstructorUsedError;
  double get grossRevenue => throw _privateConstructorUsedError;
  double get netRevenue => throw _privateConstructorUsedError;
  double get expenses => throw _privateConstructorUsedError;
  int get transactionCount => throw _privateConstructorUsedError;
  String get currencySymbol => throw _privateConstructorUsedError;
  List<RevenueCategoryBreakdown> get categoryBreakdown =>
      throw _privateConstructorUsedError;

  /// Serializes this DailyRevenueSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyRevenueSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyRevenueSummaryCopyWith<DailyRevenueSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyRevenueSummaryCopyWith<$Res> {
  factory $DailyRevenueSummaryCopyWith(
          DailyRevenueSummary value, $Res Function(DailyRevenueSummary) then) =
      _$DailyRevenueSummaryCopyWithImpl<$Res, DailyRevenueSummary>;
  @useResult
  $Res call(
      {DateTime date,
      double grossRevenue,
      double netRevenue,
      double expenses,
      int transactionCount,
      String currencySymbol,
      List<RevenueCategoryBreakdown> categoryBreakdown});
}

/// @nodoc
class _$DailyRevenueSummaryCopyWithImpl<$Res, $Val extends DailyRevenueSummary>
    implements $DailyRevenueSummaryCopyWith<$Res> {
  _$DailyRevenueSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyRevenueSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? grossRevenue = null,
    Object? netRevenue = null,
    Object? expenses = null,
    Object? transactionCount = null,
    Object? currencySymbol = null,
    Object? categoryBreakdown = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      grossRevenue: null == grossRevenue
          ? _value.grossRevenue
          : grossRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      netRevenue: null == netRevenue
          ? _value.netRevenue
          : netRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      expenses: null == expenses
          ? _value.expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as double,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      categoryBreakdown: null == categoryBreakdown
          ? _value.categoryBreakdown
          : categoryBreakdown // ignore: cast_nullable_to_non_nullable
              as List<RevenueCategoryBreakdown>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyRevenueSummaryImplCopyWith<$Res>
    implements $DailyRevenueSummaryCopyWith<$Res> {
  factory _$$DailyRevenueSummaryImplCopyWith(_$DailyRevenueSummaryImpl value,
          $Res Function(_$DailyRevenueSummaryImpl) then) =
      __$$DailyRevenueSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      double grossRevenue,
      double netRevenue,
      double expenses,
      int transactionCount,
      String currencySymbol,
      List<RevenueCategoryBreakdown> categoryBreakdown});
}

/// @nodoc
class __$$DailyRevenueSummaryImplCopyWithImpl<$Res>
    extends _$DailyRevenueSummaryCopyWithImpl<$Res, _$DailyRevenueSummaryImpl>
    implements _$$DailyRevenueSummaryImplCopyWith<$Res> {
  __$$DailyRevenueSummaryImplCopyWithImpl(_$DailyRevenueSummaryImpl _value,
      $Res Function(_$DailyRevenueSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyRevenueSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? grossRevenue = null,
    Object? netRevenue = null,
    Object? expenses = null,
    Object? transactionCount = null,
    Object? currencySymbol = null,
    Object? categoryBreakdown = null,
  }) {
    return _then(_$DailyRevenueSummaryImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      grossRevenue: null == grossRevenue
          ? _value.grossRevenue
          : grossRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      netRevenue: null == netRevenue
          ? _value.netRevenue
          : netRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      expenses: null == expenses
          ? _value.expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as double,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      categoryBreakdown: null == categoryBreakdown
          ? _value._categoryBreakdown
          : categoryBreakdown // ignore: cast_nullable_to_non_nullable
              as List<RevenueCategoryBreakdown>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyRevenueSummaryImpl implements _DailyRevenueSummary {
  const _$DailyRevenueSummaryImpl(
      {required this.date,
      required this.grossRevenue,
      required this.netRevenue,
      required this.expenses,
      required this.transactionCount,
      required this.currencySymbol,
      final List<RevenueCategoryBreakdown> categoryBreakdown = const []})
      : _categoryBreakdown = categoryBreakdown;

  factory _$DailyRevenueSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyRevenueSummaryImplFromJson(json);

  @override
  final DateTime date;
  @override
  final double grossRevenue;
  @override
  final double netRevenue;
  @override
  final double expenses;
  @override
  final int transactionCount;
  @override
  final String currencySymbol;
  final List<RevenueCategoryBreakdown> _categoryBreakdown;
  @override
  @JsonKey()
  List<RevenueCategoryBreakdown> get categoryBreakdown {
    if (_categoryBreakdown is EqualUnmodifiableListView)
      return _categoryBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryBreakdown);
  }

  @override
  String toString() {
    return 'DailyRevenueSummary(date: $date, grossRevenue: $grossRevenue, netRevenue: $netRevenue, expenses: $expenses, transactionCount: $transactionCount, currencySymbol: $currencySymbol, categoryBreakdown: $categoryBreakdown)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyRevenueSummaryImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.grossRevenue, grossRevenue) ||
                other.grossRevenue == grossRevenue) &&
            (identical(other.netRevenue, netRevenue) ||
                other.netRevenue == netRevenue) &&
            (identical(other.expenses, expenses) ||
                other.expenses == expenses) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
            const DeepCollectionEquality()
                .equals(other._categoryBreakdown, _categoryBreakdown));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      date,
      grossRevenue,
      netRevenue,
      expenses,
      transactionCount,
      currencySymbol,
      const DeepCollectionEquality().hash(_categoryBreakdown));

  /// Create a copy of DailyRevenueSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyRevenueSummaryImplCopyWith<_$DailyRevenueSummaryImpl> get copyWith =>
      __$$DailyRevenueSummaryImplCopyWithImpl<_$DailyRevenueSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyRevenueSummaryImplToJson(
      this,
    );
  }
}

abstract class _DailyRevenueSummary implements DailyRevenueSummary {
  const factory _DailyRevenueSummary(
          {required final DateTime date,
          required final double grossRevenue,
          required final double netRevenue,
          required final double expenses,
          required final int transactionCount,
          required final String currencySymbol,
          final List<RevenueCategoryBreakdown> categoryBreakdown}) =
      _$DailyRevenueSummaryImpl;

  factory _DailyRevenueSummary.fromJson(Map<String, dynamic> json) =
      _$DailyRevenueSummaryImpl.fromJson;

  @override
  DateTime get date;
  @override
  double get grossRevenue;
  @override
  double get netRevenue;
  @override
  double get expenses;
  @override
  int get transactionCount;
  @override
  String get currencySymbol;
  @override
  List<RevenueCategoryBreakdown> get categoryBreakdown;

  /// Create a copy of DailyRevenueSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyRevenueSummaryImplCopyWith<_$DailyRevenueSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
