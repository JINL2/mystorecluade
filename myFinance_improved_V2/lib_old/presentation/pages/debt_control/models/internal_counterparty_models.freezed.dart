// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'internal_counterparty_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InternalCounterpartyDetail _$InternalCounterpartyDetailFromJson(
    Map<String, dynamic> json) {
  return _InternalCounterpartyDetail.fromJson(json);
}

/// @nodoc
mixin _$InternalCounterpartyDetail {
  String get counterpartyId => throw _privateConstructorUsedError;
  String get counterpartyName => throw _privateConstructorUsedError;
  String get linkedCompanyId => throw _privateConstructorUsedError;
  String get linkedCompanyName =>
      throw _privateConstructorUsedError; // Our perspective
  double get ourTotalReceivable => throw _privateConstructorUsedError;
  double get ourTotalPayable => throw _privateConstructorUsedError;
  double get ourNetPosition =>
      throw _privateConstructorUsedError; // Their perspective (reciprocal)
  double get theirTotalReceivable => throw _privateConstructorUsedError;
  double get theirTotalPayable => throw _privateConstructorUsedError;
  double get theirNetPosition =>
      throw _privateConstructorUsedError; // Reconciliation status
  bool get isReconciled => throw _privateConstructorUsedError;
  double? get variance => throw _privateConstructorUsedError;
  DateTime? get lastReconciliationDate =>
      throw _privateConstructorUsedError; // Store-level breakdown
  List<StoreDebtPosition> get storeBreakdown =>
      throw _privateConstructorUsedError; // Metadata
  int get activeStoreCount => throw _privateConstructorUsedError;
  int get transactionCount => throw _privateConstructorUsedError;
  DateTime? get lastTransactionDate => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this InternalCounterpartyDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InternalCounterpartyDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InternalCounterpartyDetailCopyWith<InternalCounterpartyDetail>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InternalCounterpartyDetailCopyWith<$Res> {
  factory $InternalCounterpartyDetailCopyWith(InternalCounterpartyDetail value,
          $Res Function(InternalCounterpartyDetail) then) =
      _$InternalCounterpartyDetailCopyWithImpl<$Res,
          InternalCounterpartyDetail>;
  @useResult
  $Res call(
      {String counterpartyId,
      String counterpartyName,
      String linkedCompanyId,
      String linkedCompanyName,
      double ourTotalReceivable,
      double ourTotalPayable,
      double ourNetPosition,
      double theirTotalReceivable,
      double theirTotalPayable,
      double theirNetPosition,
      bool isReconciled,
      double? variance,
      DateTime? lastReconciliationDate,
      List<StoreDebtPosition> storeBreakdown,
      int activeStoreCount,
      int transactionCount,
      DateTime? lastTransactionDate,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$InternalCounterpartyDetailCopyWithImpl<$Res,
        $Val extends InternalCounterpartyDetail>
    implements $InternalCounterpartyDetailCopyWith<$Res> {
  _$InternalCounterpartyDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InternalCounterpartyDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterpartyId = null,
    Object? counterpartyName = null,
    Object? linkedCompanyId = null,
    Object? linkedCompanyName = null,
    Object? ourTotalReceivable = null,
    Object? ourTotalPayable = null,
    Object? ourNetPosition = null,
    Object? theirTotalReceivable = null,
    Object? theirTotalPayable = null,
    Object? theirNetPosition = null,
    Object? isReconciled = null,
    Object? variance = freezed,
    Object? lastReconciliationDate = freezed,
    Object? storeBreakdown = null,
    Object? activeStoreCount = null,
    Object? transactionCount = null,
    Object? lastTransactionDate = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      counterpartyId: null == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyName: null == counterpartyName
          ? _value.counterpartyName
          : counterpartyName // ignore: cast_nullable_to_non_nullable
              as String,
      linkedCompanyId: null == linkedCompanyId
          ? _value.linkedCompanyId
          : linkedCompanyId // ignore: cast_nullable_to_non_nullable
              as String,
      linkedCompanyName: null == linkedCompanyName
          ? _value.linkedCompanyName
          : linkedCompanyName // ignore: cast_nullable_to_non_nullable
              as String,
      ourTotalReceivable: null == ourTotalReceivable
          ? _value.ourTotalReceivable
          : ourTotalReceivable // ignore: cast_nullable_to_non_nullable
              as double,
      ourTotalPayable: null == ourTotalPayable
          ? _value.ourTotalPayable
          : ourTotalPayable // ignore: cast_nullable_to_non_nullable
              as double,
      ourNetPosition: null == ourNetPosition
          ? _value.ourNetPosition
          : ourNetPosition // ignore: cast_nullable_to_non_nullable
              as double,
      theirTotalReceivable: null == theirTotalReceivable
          ? _value.theirTotalReceivable
          : theirTotalReceivable // ignore: cast_nullable_to_non_nullable
              as double,
      theirTotalPayable: null == theirTotalPayable
          ? _value.theirTotalPayable
          : theirTotalPayable // ignore: cast_nullable_to_non_nullable
              as double,
      theirNetPosition: null == theirNetPosition
          ? _value.theirNetPosition
          : theirNetPosition // ignore: cast_nullable_to_non_nullable
              as double,
      isReconciled: null == isReconciled
          ? _value.isReconciled
          : isReconciled // ignore: cast_nullable_to_non_nullable
              as bool,
      variance: freezed == variance
          ? _value.variance
          : variance // ignore: cast_nullable_to_non_nullable
              as double?,
      lastReconciliationDate: freezed == lastReconciliationDate
          ? _value.lastReconciliationDate
          : lastReconciliationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      storeBreakdown: null == storeBreakdown
          ? _value.storeBreakdown
          : storeBreakdown // ignore: cast_nullable_to_non_nullable
              as List<StoreDebtPosition>,
      activeStoreCount: null == activeStoreCount
          ? _value.activeStoreCount
          : activeStoreCount // ignore: cast_nullable_to_non_nullable
              as int,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastTransactionDate: freezed == lastTransactionDate
          ? _value.lastTransactionDate
          : lastTransactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InternalCounterpartyDetailImplCopyWith<$Res>
    implements $InternalCounterpartyDetailCopyWith<$Res> {
  factory _$$InternalCounterpartyDetailImplCopyWith(
          _$InternalCounterpartyDetailImpl value,
          $Res Function(_$InternalCounterpartyDetailImpl) then) =
      __$$InternalCounterpartyDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String counterpartyId,
      String counterpartyName,
      String linkedCompanyId,
      String linkedCompanyName,
      double ourTotalReceivable,
      double ourTotalPayable,
      double ourNetPosition,
      double theirTotalReceivable,
      double theirTotalPayable,
      double theirNetPosition,
      bool isReconciled,
      double? variance,
      DateTime? lastReconciliationDate,
      List<StoreDebtPosition> storeBreakdown,
      int activeStoreCount,
      int transactionCount,
      DateTime? lastTransactionDate,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$InternalCounterpartyDetailImplCopyWithImpl<$Res>
    extends _$InternalCounterpartyDetailCopyWithImpl<$Res,
        _$InternalCounterpartyDetailImpl>
    implements _$$InternalCounterpartyDetailImplCopyWith<$Res> {
  __$$InternalCounterpartyDetailImplCopyWithImpl(
      _$InternalCounterpartyDetailImpl _value,
      $Res Function(_$InternalCounterpartyDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of InternalCounterpartyDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterpartyId = null,
    Object? counterpartyName = null,
    Object? linkedCompanyId = null,
    Object? linkedCompanyName = null,
    Object? ourTotalReceivable = null,
    Object? ourTotalPayable = null,
    Object? ourNetPosition = null,
    Object? theirTotalReceivable = null,
    Object? theirTotalPayable = null,
    Object? theirNetPosition = null,
    Object? isReconciled = null,
    Object? variance = freezed,
    Object? lastReconciliationDate = freezed,
    Object? storeBreakdown = null,
    Object? activeStoreCount = null,
    Object? transactionCount = null,
    Object? lastTransactionDate = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$InternalCounterpartyDetailImpl(
      counterpartyId: null == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyName: null == counterpartyName
          ? _value.counterpartyName
          : counterpartyName // ignore: cast_nullable_to_non_nullable
              as String,
      linkedCompanyId: null == linkedCompanyId
          ? _value.linkedCompanyId
          : linkedCompanyId // ignore: cast_nullable_to_non_nullable
              as String,
      linkedCompanyName: null == linkedCompanyName
          ? _value.linkedCompanyName
          : linkedCompanyName // ignore: cast_nullable_to_non_nullable
              as String,
      ourTotalReceivable: null == ourTotalReceivable
          ? _value.ourTotalReceivable
          : ourTotalReceivable // ignore: cast_nullable_to_non_nullable
              as double,
      ourTotalPayable: null == ourTotalPayable
          ? _value.ourTotalPayable
          : ourTotalPayable // ignore: cast_nullable_to_non_nullable
              as double,
      ourNetPosition: null == ourNetPosition
          ? _value.ourNetPosition
          : ourNetPosition // ignore: cast_nullable_to_non_nullable
              as double,
      theirTotalReceivable: null == theirTotalReceivable
          ? _value.theirTotalReceivable
          : theirTotalReceivable // ignore: cast_nullable_to_non_nullable
              as double,
      theirTotalPayable: null == theirTotalPayable
          ? _value.theirTotalPayable
          : theirTotalPayable // ignore: cast_nullable_to_non_nullable
              as double,
      theirNetPosition: null == theirNetPosition
          ? _value.theirNetPosition
          : theirNetPosition // ignore: cast_nullable_to_non_nullable
              as double,
      isReconciled: null == isReconciled
          ? _value.isReconciled
          : isReconciled // ignore: cast_nullable_to_non_nullable
              as bool,
      variance: freezed == variance
          ? _value.variance
          : variance // ignore: cast_nullable_to_non_nullable
              as double?,
      lastReconciliationDate: freezed == lastReconciliationDate
          ? _value.lastReconciliationDate
          : lastReconciliationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      storeBreakdown: null == storeBreakdown
          ? _value._storeBreakdown
          : storeBreakdown // ignore: cast_nullable_to_non_nullable
              as List<StoreDebtPosition>,
      activeStoreCount: null == activeStoreCount
          ? _value.activeStoreCount
          : activeStoreCount // ignore: cast_nullable_to_non_nullable
              as int,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastTransactionDate: freezed == lastTransactionDate
          ? _value.lastTransactionDate
          : lastTransactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InternalCounterpartyDetailImpl implements _InternalCounterpartyDetail {
  const _$InternalCounterpartyDetailImpl(
      {required this.counterpartyId,
      required this.counterpartyName,
      required this.linkedCompanyId,
      required this.linkedCompanyName,
      required this.ourTotalReceivable,
      required this.ourTotalPayable,
      required this.ourNetPosition,
      required this.theirTotalReceivable,
      required this.theirTotalPayable,
      required this.theirNetPosition,
      required this.isReconciled,
      this.variance,
      this.lastReconciliationDate,
      final List<StoreDebtPosition> storeBreakdown = const [],
      required this.activeStoreCount,
      required this.transactionCount,
      this.lastTransactionDate,
      final Map<String, dynamic>? metadata})
      : _storeBreakdown = storeBreakdown,
        _metadata = metadata;

  factory _$InternalCounterpartyDetailImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$InternalCounterpartyDetailImplFromJson(json);

  @override
  final String counterpartyId;
  @override
  final String counterpartyName;
  @override
  final String linkedCompanyId;
  @override
  final String linkedCompanyName;
// Our perspective
  @override
  final double ourTotalReceivable;
  @override
  final double ourTotalPayable;
  @override
  final double ourNetPosition;
// Their perspective (reciprocal)
  @override
  final double theirTotalReceivable;
  @override
  final double theirTotalPayable;
  @override
  final double theirNetPosition;
// Reconciliation status
  @override
  final bool isReconciled;
  @override
  final double? variance;
  @override
  final DateTime? lastReconciliationDate;
// Store-level breakdown
  final List<StoreDebtPosition> _storeBreakdown;
// Store-level breakdown
  @override
  @JsonKey()
  List<StoreDebtPosition> get storeBreakdown {
    if (_storeBreakdown is EqualUnmodifiableListView) return _storeBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_storeBreakdown);
  }

// Metadata
  @override
  final int activeStoreCount;
  @override
  final int transactionCount;
  @override
  final DateTime? lastTransactionDate;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'InternalCounterpartyDetail(counterpartyId: $counterpartyId, counterpartyName: $counterpartyName, linkedCompanyId: $linkedCompanyId, linkedCompanyName: $linkedCompanyName, ourTotalReceivable: $ourTotalReceivable, ourTotalPayable: $ourTotalPayable, ourNetPosition: $ourNetPosition, theirTotalReceivable: $theirTotalReceivable, theirTotalPayable: $theirTotalPayable, theirNetPosition: $theirNetPosition, isReconciled: $isReconciled, variance: $variance, lastReconciliationDate: $lastReconciliationDate, storeBreakdown: $storeBreakdown, activeStoreCount: $activeStoreCount, transactionCount: $transactionCount, lastTransactionDate: $lastTransactionDate, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InternalCounterpartyDetailImpl &&
            (identical(other.counterpartyId, counterpartyId) ||
                other.counterpartyId == counterpartyId) &&
            (identical(other.counterpartyName, counterpartyName) ||
                other.counterpartyName == counterpartyName) &&
            (identical(other.linkedCompanyId, linkedCompanyId) ||
                other.linkedCompanyId == linkedCompanyId) &&
            (identical(other.linkedCompanyName, linkedCompanyName) ||
                other.linkedCompanyName == linkedCompanyName) &&
            (identical(other.ourTotalReceivable, ourTotalReceivable) ||
                other.ourTotalReceivable == ourTotalReceivable) &&
            (identical(other.ourTotalPayable, ourTotalPayable) ||
                other.ourTotalPayable == ourTotalPayable) &&
            (identical(other.ourNetPosition, ourNetPosition) ||
                other.ourNetPosition == ourNetPosition) &&
            (identical(other.theirTotalReceivable, theirTotalReceivable) ||
                other.theirTotalReceivable == theirTotalReceivable) &&
            (identical(other.theirTotalPayable, theirTotalPayable) ||
                other.theirTotalPayable == theirTotalPayable) &&
            (identical(other.theirNetPosition, theirNetPosition) ||
                other.theirNetPosition == theirNetPosition) &&
            (identical(other.isReconciled, isReconciled) ||
                other.isReconciled == isReconciled) &&
            (identical(other.variance, variance) ||
                other.variance == variance) &&
            (identical(other.lastReconciliationDate, lastReconciliationDate) ||
                other.lastReconciliationDate == lastReconciliationDate) &&
            const DeepCollectionEquality()
                .equals(other._storeBreakdown, _storeBreakdown) &&
            (identical(other.activeStoreCount, activeStoreCount) ||
                other.activeStoreCount == activeStoreCount) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            (identical(other.lastTransactionDate, lastTransactionDate) ||
                other.lastTransactionDate == lastTransactionDate) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      counterpartyId,
      counterpartyName,
      linkedCompanyId,
      linkedCompanyName,
      ourTotalReceivable,
      ourTotalPayable,
      ourNetPosition,
      theirTotalReceivable,
      theirTotalPayable,
      theirNetPosition,
      isReconciled,
      variance,
      lastReconciliationDate,
      const DeepCollectionEquality().hash(_storeBreakdown),
      activeStoreCount,
      transactionCount,
      lastTransactionDate,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of InternalCounterpartyDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InternalCounterpartyDetailImplCopyWith<_$InternalCounterpartyDetailImpl>
      get copyWith => __$$InternalCounterpartyDetailImplCopyWithImpl<
          _$InternalCounterpartyDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InternalCounterpartyDetailImplToJson(
      this,
    );
  }
}

abstract class _InternalCounterpartyDetail
    implements InternalCounterpartyDetail {
  const factory _InternalCounterpartyDetail(
      {required final String counterpartyId,
      required final String counterpartyName,
      required final String linkedCompanyId,
      required final String linkedCompanyName,
      required final double ourTotalReceivable,
      required final double ourTotalPayable,
      required final double ourNetPosition,
      required final double theirTotalReceivable,
      required final double theirTotalPayable,
      required final double theirNetPosition,
      required final bool isReconciled,
      final double? variance,
      final DateTime? lastReconciliationDate,
      final List<StoreDebtPosition> storeBreakdown,
      required final int activeStoreCount,
      required final int transactionCount,
      final DateTime? lastTransactionDate,
      final Map<String, dynamic>? metadata}) = _$InternalCounterpartyDetailImpl;

  factory _InternalCounterpartyDetail.fromJson(Map<String, dynamic> json) =
      _$InternalCounterpartyDetailImpl.fromJson;

  @override
  String get counterpartyId;
  @override
  String get counterpartyName;
  @override
  String get linkedCompanyId;
  @override
  String get linkedCompanyName; // Our perspective
  @override
  double get ourTotalReceivable;
  @override
  double get ourTotalPayable;
  @override
  double get ourNetPosition; // Their perspective (reciprocal)
  @override
  double get theirTotalReceivable;
  @override
  double get theirTotalPayable;
  @override
  double get theirNetPosition; // Reconciliation status
  @override
  bool get isReconciled;
  @override
  double? get variance;
  @override
  DateTime? get lastReconciliationDate; // Store-level breakdown
  @override
  List<StoreDebtPosition> get storeBreakdown; // Metadata
  @override
  int get activeStoreCount;
  @override
  int get transactionCount;
  @override
  DateTime? get lastTransactionDate;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of InternalCounterpartyDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InternalCounterpartyDetailImplCopyWith<_$InternalCounterpartyDetailImpl>
      get copyWith => throw _privateConstructorUsedError;
}

StoreDebtPosition _$StoreDebtPositionFromJson(Map<String, dynamic> json) {
  return _StoreDebtPosition.fromJson(json);
}

/// @nodoc
mixin _$StoreDebtPosition {
  String get storeId => throw _privateConstructorUsedError;
  String get storeName => throw _privateConstructorUsedError;
  String get storeCode =>
      throw _privateConstructorUsedError; // Position from our perspective
  double get receivable => throw _privateConstructorUsedError;
  double get payable => throw _privateConstructorUsedError;
  double get netPosition =>
      throw _privateConstructorUsedError; // Transaction details
  int get transactionCount => throw _privateConstructorUsedError;
  DateTime? get lastTransactionDate =>
      throw _privateConstructorUsedError; // Trends
  double? get monthlyAverage => throw _privateConstructorUsedError;
  double? get trend => throw _privateConstructorUsedError; // percentage change
// Status
  bool get hasOverdue => throw _privateConstructorUsedError;
  bool get hasDispute => throw _privateConstructorUsedError;
  int? get daysOutstanding => throw _privateConstructorUsedError;

  /// Serializes this StoreDebtPosition to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoreDebtPosition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreDebtPositionCopyWith<StoreDebtPosition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreDebtPositionCopyWith<$Res> {
  factory $StoreDebtPositionCopyWith(
          StoreDebtPosition value, $Res Function(StoreDebtPosition) then) =
      _$StoreDebtPositionCopyWithImpl<$Res, StoreDebtPosition>;
  @useResult
  $Res call(
      {String storeId,
      String storeName,
      String storeCode,
      double receivable,
      double payable,
      double netPosition,
      int transactionCount,
      DateTime? lastTransactionDate,
      double? monthlyAverage,
      double? trend,
      bool hasOverdue,
      bool hasDispute,
      int? daysOutstanding});
}

/// @nodoc
class _$StoreDebtPositionCopyWithImpl<$Res, $Val extends StoreDebtPosition>
    implements $StoreDebtPositionCopyWith<$Res> {
  _$StoreDebtPositionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreDebtPosition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? storeName = null,
    Object? storeCode = null,
    Object? receivable = null,
    Object? payable = null,
    Object? netPosition = null,
    Object? transactionCount = null,
    Object? lastTransactionDate = freezed,
    Object? monthlyAverage = freezed,
    Object? trend = freezed,
    Object? hasOverdue = null,
    Object? hasDispute = null,
    Object? daysOutstanding = freezed,
  }) {
    return _then(_value.copyWith(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      storeCode: null == storeCode
          ? _value.storeCode
          : storeCode // ignore: cast_nullable_to_non_nullable
              as String,
      receivable: null == receivable
          ? _value.receivable
          : receivable // ignore: cast_nullable_to_non_nullable
              as double,
      payable: null == payable
          ? _value.payable
          : payable // ignore: cast_nullable_to_non_nullable
              as double,
      netPosition: null == netPosition
          ? _value.netPosition
          : netPosition // ignore: cast_nullable_to_non_nullable
              as double,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastTransactionDate: freezed == lastTransactionDate
          ? _value.lastTransactionDate
          : lastTransactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      monthlyAverage: freezed == monthlyAverage
          ? _value.monthlyAverage
          : monthlyAverage // ignore: cast_nullable_to_non_nullable
              as double?,
      trend: freezed == trend
          ? _value.trend
          : trend // ignore: cast_nullable_to_non_nullable
              as double?,
      hasOverdue: null == hasOverdue
          ? _value.hasOverdue
          : hasOverdue // ignore: cast_nullable_to_non_nullable
              as bool,
      hasDispute: null == hasDispute
          ? _value.hasDispute
          : hasDispute // ignore: cast_nullable_to_non_nullable
              as bool,
      daysOutstanding: freezed == daysOutstanding
          ? _value.daysOutstanding
          : daysOutstanding // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoreDebtPositionImplCopyWith<$Res>
    implements $StoreDebtPositionCopyWith<$Res> {
  factory _$$StoreDebtPositionImplCopyWith(_$StoreDebtPositionImpl value,
          $Res Function(_$StoreDebtPositionImpl) then) =
      __$$StoreDebtPositionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String storeId,
      String storeName,
      String storeCode,
      double receivable,
      double payable,
      double netPosition,
      int transactionCount,
      DateTime? lastTransactionDate,
      double? monthlyAverage,
      double? trend,
      bool hasOverdue,
      bool hasDispute,
      int? daysOutstanding});
}

/// @nodoc
class __$$StoreDebtPositionImplCopyWithImpl<$Res>
    extends _$StoreDebtPositionCopyWithImpl<$Res, _$StoreDebtPositionImpl>
    implements _$$StoreDebtPositionImplCopyWith<$Res> {
  __$$StoreDebtPositionImplCopyWithImpl(_$StoreDebtPositionImpl _value,
      $Res Function(_$StoreDebtPositionImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoreDebtPosition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? storeName = null,
    Object? storeCode = null,
    Object? receivable = null,
    Object? payable = null,
    Object? netPosition = null,
    Object? transactionCount = null,
    Object? lastTransactionDate = freezed,
    Object? monthlyAverage = freezed,
    Object? trend = freezed,
    Object? hasOverdue = null,
    Object? hasDispute = null,
    Object? daysOutstanding = freezed,
  }) {
    return _then(_$StoreDebtPositionImpl(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      storeCode: null == storeCode
          ? _value.storeCode
          : storeCode // ignore: cast_nullable_to_non_nullable
              as String,
      receivable: null == receivable
          ? _value.receivable
          : receivable // ignore: cast_nullable_to_non_nullable
              as double,
      payable: null == payable
          ? _value.payable
          : payable // ignore: cast_nullable_to_non_nullable
              as double,
      netPosition: null == netPosition
          ? _value.netPosition
          : netPosition // ignore: cast_nullable_to_non_nullable
              as double,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastTransactionDate: freezed == lastTransactionDate
          ? _value.lastTransactionDate
          : lastTransactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      monthlyAverage: freezed == monthlyAverage
          ? _value.monthlyAverage
          : monthlyAverage // ignore: cast_nullable_to_non_nullable
              as double?,
      trend: freezed == trend
          ? _value.trend
          : trend // ignore: cast_nullable_to_non_nullable
              as double?,
      hasOverdue: null == hasOverdue
          ? _value.hasOverdue
          : hasOverdue // ignore: cast_nullable_to_non_nullable
              as bool,
      hasDispute: null == hasDispute
          ? _value.hasDispute
          : hasDispute // ignore: cast_nullable_to_non_nullable
              as bool,
      daysOutstanding: freezed == daysOutstanding
          ? _value.daysOutstanding
          : daysOutstanding // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreDebtPositionImpl implements _StoreDebtPosition {
  const _$StoreDebtPositionImpl(
      {required this.storeId,
      required this.storeName,
      required this.storeCode,
      required this.receivable,
      required this.payable,
      required this.netPosition,
      required this.transactionCount,
      this.lastTransactionDate,
      this.monthlyAverage,
      this.trend,
      required this.hasOverdue,
      required this.hasDispute,
      this.daysOutstanding});

  factory _$StoreDebtPositionImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreDebtPositionImplFromJson(json);

  @override
  final String storeId;
  @override
  final String storeName;
  @override
  final String storeCode;
// Position from our perspective
  @override
  final double receivable;
  @override
  final double payable;
  @override
  final double netPosition;
// Transaction details
  @override
  final int transactionCount;
  @override
  final DateTime? lastTransactionDate;
// Trends
  @override
  final double? monthlyAverage;
  @override
  final double? trend;
// percentage change
// Status
  @override
  final bool hasOverdue;
  @override
  final bool hasDispute;
  @override
  final int? daysOutstanding;

  @override
  String toString() {
    return 'StoreDebtPosition(storeId: $storeId, storeName: $storeName, storeCode: $storeCode, receivable: $receivable, payable: $payable, netPosition: $netPosition, transactionCount: $transactionCount, lastTransactionDate: $lastTransactionDate, monthlyAverage: $monthlyAverage, trend: $trend, hasOverdue: $hasOverdue, hasDispute: $hasDispute, daysOutstanding: $daysOutstanding)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreDebtPositionImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.storeCode, storeCode) ||
                other.storeCode == storeCode) &&
            (identical(other.receivable, receivable) ||
                other.receivable == receivable) &&
            (identical(other.payable, payable) || other.payable == payable) &&
            (identical(other.netPosition, netPosition) ||
                other.netPosition == netPosition) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            (identical(other.lastTransactionDate, lastTransactionDate) ||
                other.lastTransactionDate == lastTransactionDate) &&
            (identical(other.monthlyAverage, monthlyAverage) ||
                other.monthlyAverage == monthlyAverage) &&
            (identical(other.trend, trend) || other.trend == trend) &&
            (identical(other.hasOverdue, hasOverdue) ||
                other.hasOverdue == hasOverdue) &&
            (identical(other.hasDispute, hasDispute) ||
                other.hasDispute == hasDispute) &&
            (identical(other.daysOutstanding, daysOutstanding) ||
                other.daysOutstanding == daysOutstanding));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      storeId,
      storeName,
      storeCode,
      receivable,
      payable,
      netPosition,
      transactionCount,
      lastTransactionDate,
      monthlyAverage,
      trend,
      hasOverdue,
      hasDispute,
      daysOutstanding);

  /// Create a copy of StoreDebtPosition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreDebtPositionImplCopyWith<_$StoreDebtPositionImpl> get copyWith =>
      __$$StoreDebtPositionImplCopyWithImpl<_$StoreDebtPositionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreDebtPositionImplToJson(
      this,
    );
  }
}

abstract class _StoreDebtPosition implements StoreDebtPosition {
  const factory _StoreDebtPosition(
      {required final String storeId,
      required final String storeName,
      required final String storeCode,
      required final double receivable,
      required final double payable,
      required final double netPosition,
      required final int transactionCount,
      final DateTime? lastTransactionDate,
      final double? monthlyAverage,
      final double? trend,
      required final bool hasOverdue,
      required final bool hasDispute,
      final int? daysOutstanding}) = _$StoreDebtPositionImpl;

  factory _StoreDebtPosition.fromJson(Map<String, dynamic> json) =
      _$StoreDebtPositionImpl.fromJson;

  @override
  String get storeId;
  @override
  String get storeName;
  @override
  String get storeCode; // Position from our perspective
  @override
  double get receivable;
  @override
  double get payable;
  @override
  double get netPosition; // Transaction details
  @override
  int get transactionCount;
  @override
  DateTime? get lastTransactionDate; // Trends
  @override
  double? get monthlyAverage;
  @override
  double? get trend; // percentage change
// Status
  @override
  bool get hasOverdue;
  @override
  bool get hasDispute;
  @override
  int? get daysOutstanding;

  /// Create a copy of StoreDebtPosition
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreDebtPositionImplCopyWith<_$StoreDebtPositionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PerspectiveDebtSummary _$PerspectiveDebtSummaryFromJson(
    Map<String, dynamic> json) {
  return _PerspectiveDebtSummary.fromJson(json);
}

/// @nodoc
mixin _$PerspectiveDebtSummary {
  String get perspectiveType =>
      throw _privateConstructorUsedError; // 'company', 'store', 'group'
  String get entityId => throw _privateConstructorUsedError;
  String get entityName =>
      throw _privateConstructorUsedError; // Aggregated positions
  double get totalReceivable => throw _privateConstructorUsedError;
  double get totalPayable => throw _privateConstructorUsedError;
  double get netPosition =>
      throw _privateConstructorUsedError; // Internal vs External breakdown
  double get internalReceivable => throw _privateConstructorUsedError;
  double get internalPayable => throw _privateConstructorUsedError;
  double get internalNetPosition => throw _privateConstructorUsedError;
  double get externalReceivable => throw _privateConstructorUsedError;
  double get externalPayable => throw _privateConstructorUsedError;
  double get externalNetPosition =>
      throw _privateConstructorUsedError; // Store aggregation (for company perspective)
  List<StoreAggregate> get storeAggregates =>
      throw _privateConstructorUsedError; // Metrics
  int get counterpartyCount => throw _privateConstructorUsedError;
  int get transactionCount => throw _privateConstructorUsedError;
  double get collectionRate => throw _privateConstructorUsedError;
  int get criticalCount => throw _privateConstructorUsedError;

  /// Serializes this PerspectiveDebtSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PerspectiveDebtSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PerspectiveDebtSummaryCopyWith<PerspectiveDebtSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PerspectiveDebtSummaryCopyWith<$Res> {
  factory $PerspectiveDebtSummaryCopyWith(PerspectiveDebtSummary value,
          $Res Function(PerspectiveDebtSummary) then) =
      _$PerspectiveDebtSummaryCopyWithImpl<$Res, PerspectiveDebtSummary>;
  @useResult
  $Res call(
      {String perspectiveType,
      String entityId,
      String entityName,
      double totalReceivable,
      double totalPayable,
      double netPosition,
      double internalReceivable,
      double internalPayable,
      double internalNetPosition,
      double externalReceivable,
      double externalPayable,
      double externalNetPosition,
      List<StoreAggregate> storeAggregates,
      int counterpartyCount,
      int transactionCount,
      double collectionRate,
      int criticalCount});
}

/// @nodoc
class _$PerspectiveDebtSummaryCopyWithImpl<$Res,
        $Val extends PerspectiveDebtSummary>
    implements $PerspectiveDebtSummaryCopyWith<$Res> {
  _$PerspectiveDebtSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PerspectiveDebtSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? perspectiveType = null,
    Object? entityId = null,
    Object? entityName = null,
    Object? totalReceivable = null,
    Object? totalPayable = null,
    Object? netPosition = null,
    Object? internalReceivable = null,
    Object? internalPayable = null,
    Object? internalNetPosition = null,
    Object? externalReceivable = null,
    Object? externalPayable = null,
    Object? externalNetPosition = null,
    Object? storeAggregates = null,
    Object? counterpartyCount = null,
    Object? transactionCount = null,
    Object? collectionRate = null,
    Object? criticalCount = null,
  }) {
    return _then(_value.copyWith(
      perspectiveType: null == perspectiveType
          ? _value.perspectiveType
          : perspectiveType // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      entityName: null == entityName
          ? _value.entityName
          : entityName // ignore: cast_nullable_to_non_nullable
              as String,
      totalReceivable: null == totalReceivable
          ? _value.totalReceivable
          : totalReceivable // ignore: cast_nullable_to_non_nullable
              as double,
      totalPayable: null == totalPayable
          ? _value.totalPayable
          : totalPayable // ignore: cast_nullable_to_non_nullable
              as double,
      netPosition: null == netPosition
          ? _value.netPosition
          : netPosition // ignore: cast_nullable_to_non_nullable
              as double,
      internalReceivable: null == internalReceivable
          ? _value.internalReceivable
          : internalReceivable // ignore: cast_nullable_to_non_nullable
              as double,
      internalPayable: null == internalPayable
          ? _value.internalPayable
          : internalPayable // ignore: cast_nullable_to_non_nullable
              as double,
      internalNetPosition: null == internalNetPosition
          ? _value.internalNetPosition
          : internalNetPosition // ignore: cast_nullable_to_non_nullable
              as double,
      externalReceivable: null == externalReceivable
          ? _value.externalReceivable
          : externalReceivable // ignore: cast_nullable_to_non_nullable
              as double,
      externalPayable: null == externalPayable
          ? _value.externalPayable
          : externalPayable // ignore: cast_nullable_to_non_nullable
              as double,
      externalNetPosition: null == externalNetPosition
          ? _value.externalNetPosition
          : externalNetPosition // ignore: cast_nullable_to_non_nullable
              as double,
      storeAggregates: null == storeAggregates
          ? _value.storeAggregates
          : storeAggregates // ignore: cast_nullable_to_non_nullable
              as List<StoreAggregate>,
      counterpartyCount: null == counterpartyCount
          ? _value.counterpartyCount
          : counterpartyCount // ignore: cast_nullable_to_non_nullable
              as int,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      collectionRate: null == collectionRate
          ? _value.collectionRate
          : collectionRate // ignore: cast_nullable_to_non_nullable
              as double,
      criticalCount: null == criticalCount
          ? _value.criticalCount
          : criticalCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PerspectiveDebtSummaryImplCopyWith<$Res>
    implements $PerspectiveDebtSummaryCopyWith<$Res> {
  factory _$$PerspectiveDebtSummaryImplCopyWith(
          _$PerspectiveDebtSummaryImpl value,
          $Res Function(_$PerspectiveDebtSummaryImpl) then) =
      __$$PerspectiveDebtSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String perspectiveType,
      String entityId,
      String entityName,
      double totalReceivable,
      double totalPayable,
      double netPosition,
      double internalReceivable,
      double internalPayable,
      double internalNetPosition,
      double externalReceivable,
      double externalPayable,
      double externalNetPosition,
      List<StoreAggregate> storeAggregates,
      int counterpartyCount,
      int transactionCount,
      double collectionRate,
      int criticalCount});
}

/// @nodoc
class __$$PerspectiveDebtSummaryImplCopyWithImpl<$Res>
    extends _$PerspectiveDebtSummaryCopyWithImpl<$Res,
        _$PerspectiveDebtSummaryImpl>
    implements _$$PerspectiveDebtSummaryImplCopyWith<$Res> {
  __$$PerspectiveDebtSummaryImplCopyWithImpl(
      _$PerspectiveDebtSummaryImpl _value,
      $Res Function(_$PerspectiveDebtSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of PerspectiveDebtSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? perspectiveType = null,
    Object? entityId = null,
    Object? entityName = null,
    Object? totalReceivable = null,
    Object? totalPayable = null,
    Object? netPosition = null,
    Object? internalReceivable = null,
    Object? internalPayable = null,
    Object? internalNetPosition = null,
    Object? externalReceivable = null,
    Object? externalPayable = null,
    Object? externalNetPosition = null,
    Object? storeAggregates = null,
    Object? counterpartyCount = null,
    Object? transactionCount = null,
    Object? collectionRate = null,
    Object? criticalCount = null,
  }) {
    return _then(_$PerspectiveDebtSummaryImpl(
      perspectiveType: null == perspectiveType
          ? _value.perspectiveType
          : perspectiveType // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      entityName: null == entityName
          ? _value.entityName
          : entityName // ignore: cast_nullable_to_non_nullable
              as String,
      totalReceivable: null == totalReceivable
          ? _value.totalReceivable
          : totalReceivable // ignore: cast_nullable_to_non_nullable
              as double,
      totalPayable: null == totalPayable
          ? _value.totalPayable
          : totalPayable // ignore: cast_nullable_to_non_nullable
              as double,
      netPosition: null == netPosition
          ? _value.netPosition
          : netPosition // ignore: cast_nullable_to_non_nullable
              as double,
      internalReceivable: null == internalReceivable
          ? _value.internalReceivable
          : internalReceivable // ignore: cast_nullable_to_non_nullable
              as double,
      internalPayable: null == internalPayable
          ? _value.internalPayable
          : internalPayable // ignore: cast_nullable_to_non_nullable
              as double,
      internalNetPosition: null == internalNetPosition
          ? _value.internalNetPosition
          : internalNetPosition // ignore: cast_nullable_to_non_nullable
              as double,
      externalReceivable: null == externalReceivable
          ? _value.externalReceivable
          : externalReceivable // ignore: cast_nullable_to_non_nullable
              as double,
      externalPayable: null == externalPayable
          ? _value.externalPayable
          : externalPayable // ignore: cast_nullable_to_non_nullable
              as double,
      externalNetPosition: null == externalNetPosition
          ? _value.externalNetPosition
          : externalNetPosition // ignore: cast_nullable_to_non_nullable
              as double,
      storeAggregates: null == storeAggregates
          ? _value._storeAggregates
          : storeAggregates // ignore: cast_nullable_to_non_nullable
              as List<StoreAggregate>,
      counterpartyCount: null == counterpartyCount
          ? _value.counterpartyCount
          : counterpartyCount // ignore: cast_nullable_to_non_nullable
              as int,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      collectionRate: null == collectionRate
          ? _value.collectionRate
          : collectionRate // ignore: cast_nullable_to_non_nullable
              as double,
      criticalCount: null == criticalCount
          ? _value.criticalCount
          : criticalCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PerspectiveDebtSummaryImpl implements _PerspectiveDebtSummary {
  const _$PerspectiveDebtSummaryImpl(
      {required this.perspectiveType,
      required this.entityId,
      required this.entityName,
      required this.totalReceivable,
      required this.totalPayable,
      required this.netPosition,
      required this.internalReceivable,
      required this.internalPayable,
      required this.internalNetPosition,
      required this.externalReceivable,
      required this.externalPayable,
      required this.externalNetPosition,
      final List<StoreAggregate> storeAggregates = const [],
      required this.counterpartyCount,
      required this.transactionCount,
      required this.collectionRate,
      required this.criticalCount})
      : _storeAggregates = storeAggregates;

  factory _$PerspectiveDebtSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$PerspectiveDebtSummaryImplFromJson(json);

  @override
  final String perspectiveType;
// 'company', 'store', 'group'
  @override
  final String entityId;
  @override
  final String entityName;
// Aggregated positions
  @override
  final double totalReceivable;
  @override
  final double totalPayable;
  @override
  final double netPosition;
// Internal vs External breakdown
  @override
  final double internalReceivable;
  @override
  final double internalPayable;
  @override
  final double internalNetPosition;
  @override
  final double externalReceivable;
  @override
  final double externalPayable;
  @override
  final double externalNetPosition;
// Store aggregation (for company perspective)
  final List<StoreAggregate> _storeAggregates;
// Store aggregation (for company perspective)
  @override
  @JsonKey()
  List<StoreAggregate> get storeAggregates {
    if (_storeAggregates is EqualUnmodifiableListView) return _storeAggregates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_storeAggregates);
  }

// Metrics
  @override
  final int counterpartyCount;
  @override
  final int transactionCount;
  @override
  final double collectionRate;
  @override
  final int criticalCount;

  @override
  String toString() {
    return 'PerspectiveDebtSummary(perspectiveType: $perspectiveType, entityId: $entityId, entityName: $entityName, totalReceivable: $totalReceivable, totalPayable: $totalPayable, netPosition: $netPosition, internalReceivable: $internalReceivable, internalPayable: $internalPayable, internalNetPosition: $internalNetPosition, externalReceivable: $externalReceivable, externalPayable: $externalPayable, externalNetPosition: $externalNetPosition, storeAggregates: $storeAggregates, counterpartyCount: $counterpartyCount, transactionCount: $transactionCount, collectionRate: $collectionRate, criticalCount: $criticalCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PerspectiveDebtSummaryImpl &&
            (identical(other.perspectiveType, perspectiveType) ||
                other.perspectiveType == perspectiveType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.entityName, entityName) ||
                other.entityName == entityName) &&
            (identical(other.totalReceivable, totalReceivable) ||
                other.totalReceivable == totalReceivable) &&
            (identical(other.totalPayable, totalPayable) ||
                other.totalPayable == totalPayable) &&
            (identical(other.netPosition, netPosition) ||
                other.netPosition == netPosition) &&
            (identical(other.internalReceivable, internalReceivable) ||
                other.internalReceivable == internalReceivable) &&
            (identical(other.internalPayable, internalPayable) ||
                other.internalPayable == internalPayable) &&
            (identical(other.internalNetPosition, internalNetPosition) ||
                other.internalNetPosition == internalNetPosition) &&
            (identical(other.externalReceivable, externalReceivable) ||
                other.externalReceivable == externalReceivable) &&
            (identical(other.externalPayable, externalPayable) ||
                other.externalPayable == externalPayable) &&
            (identical(other.externalNetPosition, externalNetPosition) ||
                other.externalNetPosition == externalNetPosition) &&
            const DeepCollectionEquality()
                .equals(other._storeAggregates, _storeAggregates) &&
            (identical(other.counterpartyCount, counterpartyCount) ||
                other.counterpartyCount == counterpartyCount) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            (identical(other.collectionRate, collectionRate) ||
                other.collectionRate == collectionRate) &&
            (identical(other.criticalCount, criticalCount) ||
                other.criticalCount == criticalCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      perspectiveType,
      entityId,
      entityName,
      totalReceivable,
      totalPayable,
      netPosition,
      internalReceivable,
      internalPayable,
      internalNetPosition,
      externalReceivable,
      externalPayable,
      externalNetPosition,
      const DeepCollectionEquality().hash(_storeAggregates),
      counterpartyCount,
      transactionCount,
      collectionRate,
      criticalCount);

  /// Create a copy of PerspectiveDebtSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PerspectiveDebtSummaryImplCopyWith<_$PerspectiveDebtSummaryImpl>
      get copyWith => __$$PerspectiveDebtSummaryImplCopyWithImpl<
          _$PerspectiveDebtSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PerspectiveDebtSummaryImplToJson(
      this,
    );
  }
}

abstract class _PerspectiveDebtSummary implements PerspectiveDebtSummary {
  const factory _PerspectiveDebtSummary(
      {required final String perspectiveType,
      required final String entityId,
      required final String entityName,
      required final double totalReceivable,
      required final double totalPayable,
      required final double netPosition,
      required final double internalReceivable,
      required final double internalPayable,
      required final double internalNetPosition,
      required final double externalReceivable,
      required final double externalPayable,
      required final double externalNetPosition,
      final List<StoreAggregate> storeAggregates,
      required final int counterpartyCount,
      required final int transactionCount,
      required final double collectionRate,
      required final int criticalCount}) = _$PerspectiveDebtSummaryImpl;

  factory _PerspectiveDebtSummary.fromJson(Map<String, dynamic> json) =
      _$PerspectiveDebtSummaryImpl.fromJson;

  @override
  String get perspectiveType; // 'company', 'store', 'group'
  @override
  String get entityId;
  @override
  String get entityName; // Aggregated positions
  @override
  double get totalReceivable;
  @override
  double get totalPayable;
  @override
  double get netPosition; // Internal vs External breakdown
  @override
  double get internalReceivable;
  @override
  double get internalPayable;
  @override
  double get internalNetPosition;
  @override
  double get externalReceivable;
  @override
  double get externalPayable;
  @override
  double get externalNetPosition; // Store aggregation (for company perspective)
  @override
  List<StoreAggregate> get storeAggregates; // Metrics
  @override
  int get counterpartyCount;
  @override
  int get transactionCount;
  @override
  double get collectionRate;
  @override
  int get criticalCount;

  /// Create a copy of PerspectiveDebtSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PerspectiveDebtSummaryImplCopyWith<_$PerspectiveDebtSummaryImpl>
      get copyWith => throw _privateConstructorUsedError;
}

StoreAggregate _$StoreAggregateFromJson(Map<String, dynamic> json) {
  return _StoreAggregate.fromJson(json);
}

/// @nodoc
mixin _$StoreAggregate {
  String get storeId => throw _privateConstructorUsedError;
  String get storeName => throw _privateConstructorUsedError;
  double get receivable => throw _privateConstructorUsedError;
  double get payable => throw _privateConstructorUsedError;
  double get netPosition => throw _privateConstructorUsedError;
  int get counterpartyCount => throw _privateConstructorUsedError;
  bool get isHeadquarters => throw _privateConstructorUsedError;

  /// Serializes this StoreAggregate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoreAggregate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreAggregateCopyWith<StoreAggregate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreAggregateCopyWith<$Res> {
  factory $StoreAggregateCopyWith(
          StoreAggregate value, $Res Function(StoreAggregate) then) =
      _$StoreAggregateCopyWithImpl<$Res, StoreAggregate>;
  @useResult
  $Res call(
      {String storeId,
      String storeName,
      double receivable,
      double payable,
      double netPosition,
      int counterpartyCount,
      bool isHeadquarters});
}

/// @nodoc
class _$StoreAggregateCopyWithImpl<$Res, $Val extends StoreAggregate>
    implements $StoreAggregateCopyWith<$Res> {
  _$StoreAggregateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreAggregate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? storeName = null,
    Object? receivable = null,
    Object? payable = null,
    Object? netPosition = null,
    Object? counterpartyCount = null,
    Object? isHeadquarters = null,
  }) {
    return _then(_value.copyWith(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      receivable: null == receivable
          ? _value.receivable
          : receivable // ignore: cast_nullable_to_non_nullable
              as double,
      payable: null == payable
          ? _value.payable
          : payable // ignore: cast_nullable_to_non_nullable
              as double,
      netPosition: null == netPosition
          ? _value.netPosition
          : netPosition // ignore: cast_nullable_to_non_nullable
              as double,
      counterpartyCount: null == counterpartyCount
          ? _value.counterpartyCount
          : counterpartyCount // ignore: cast_nullable_to_non_nullable
              as int,
      isHeadquarters: null == isHeadquarters
          ? _value.isHeadquarters
          : isHeadquarters // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoreAggregateImplCopyWith<$Res>
    implements $StoreAggregateCopyWith<$Res> {
  factory _$$StoreAggregateImplCopyWith(_$StoreAggregateImpl value,
          $Res Function(_$StoreAggregateImpl) then) =
      __$$StoreAggregateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String storeId,
      String storeName,
      double receivable,
      double payable,
      double netPosition,
      int counterpartyCount,
      bool isHeadquarters});
}

/// @nodoc
class __$$StoreAggregateImplCopyWithImpl<$Res>
    extends _$StoreAggregateCopyWithImpl<$Res, _$StoreAggregateImpl>
    implements _$$StoreAggregateImplCopyWith<$Res> {
  __$$StoreAggregateImplCopyWithImpl(
      _$StoreAggregateImpl _value, $Res Function(_$StoreAggregateImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoreAggregate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? storeName = null,
    Object? receivable = null,
    Object? payable = null,
    Object? netPosition = null,
    Object? counterpartyCount = null,
    Object? isHeadquarters = null,
  }) {
    return _then(_$StoreAggregateImpl(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      receivable: null == receivable
          ? _value.receivable
          : receivable // ignore: cast_nullable_to_non_nullable
              as double,
      payable: null == payable
          ? _value.payable
          : payable // ignore: cast_nullable_to_non_nullable
              as double,
      netPosition: null == netPosition
          ? _value.netPosition
          : netPosition // ignore: cast_nullable_to_non_nullable
              as double,
      counterpartyCount: null == counterpartyCount
          ? _value.counterpartyCount
          : counterpartyCount // ignore: cast_nullable_to_non_nullable
              as int,
      isHeadquarters: null == isHeadquarters
          ? _value.isHeadquarters
          : isHeadquarters // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreAggregateImpl implements _StoreAggregate {
  const _$StoreAggregateImpl(
      {required this.storeId,
      required this.storeName,
      required this.receivable,
      required this.payable,
      required this.netPosition,
      required this.counterpartyCount,
      required this.isHeadquarters});

  factory _$StoreAggregateImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreAggregateImplFromJson(json);

  @override
  final String storeId;
  @override
  final String storeName;
  @override
  final double receivable;
  @override
  final double payable;
  @override
  final double netPosition;
  @override
  final int counterpartyCount;
  @override
  final bool isHeadquarters;

  @override
  String toString() {
    return 'StoreAggregate(storeId: $storeId, storeName: $storeName, receivable: $receivable, payable: $payable, netPosition: $netPosition, counterpartyCount: $counterpartyCount, isHeadquarters: $isHeadquarters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreAggregateImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.receivable, receivable) ||
                other.receivable == receivable) &&
            (identical(other.payable, payable) || other.payable == payable) &&
            (identical(other.netPosition, netPosition) ||
                other.netPosition == netPosition) &&
            (identical(other.counterpartyCount, counterpartyCount) ||
                other.counterpartyCount == counterpartyCount) &&
            (identical(other.isHeadquarters, isHeadquarters) ||
                other.isHeadquarters == isHeadquarters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, storeId, storeName, receivable,
      payable, netPosition, counterpartyCount, isHeadquarters);

  /// Create a copy of StoreAggregate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreAggregateImplCopyWith<_$StoreAggregateImpl> get copyWith =>
      __$$StoreAggregateImplCopyWithImpl<_$StoreAggregateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreAggregateImplToJson(
      this,
    );
  }
}

abstract class _StoreAggregate implements StoreAggregate {
  const factory _StoreAggregate(
      {required final String storeId,
      required final String storeName,
      required final double receivable,
      required final double payable,
      required final double netPosition,
      required final int counterpartyCount,
      required final bool isHeadquarters}) = _$StoreAggregateImpl;

  factory _StoreAggregate.fromJson(Map<String, dynamic> json) =
      _$StoreAggregateImpl.fromJson;

  @override
  String get storeId;
  @override
  String get storeName;
  @override
  double get receivable;
  @override
  double get payable;
  @override
  double get netPosition;
  @override
  int get counterpartyCount;
  @override
  bool get isHeadquarters;

  /// Create a copy of StoreAggregate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreAggregateImplCopyWith<_$StoreAggregateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReconciliationStatus _$ReconciliationStatusFromJson(Map<String, dynamic> json) {
  return _ReconciliationStatus.fromJson(json);
}

/// @nodoc
mixin _$ReconciliationStatus {
  String get counterpartyId => throw _privateConstructorUsedError;
  bool get isReconciled => throw _privateConstructorUsedError;
  double get ourView => throw _privateConstructorUsedError;
  double get theirView => throw _privateConstructorUsedError;
  double get variance => throw _privateConstructorUsedError;
  double get variancePercentage => throw _privateConstructorUsedError;
  DateTime? get lastChecked => throw _privateConstructorUsedError;
  List<ReconciliationIssue> get issues => throw _privateConstructorUsedError;

  /// Serializes this ReconciliationStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReconciliationStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReconciliationStatusCopyWith<ReconciliationStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReconciliationStatusCopyWith<$Res> {
  factory $ReconciliationStatusCopyWith(ReconciliationStatus value,
          $Res Function(ReconciliationStatus) then) =
      _$ReconciliationStatusCopyWithImpl<$Res, ReconciliationStatus>;
  @useResult
  $Res call(
      {String counterpartyId,
      bool isReconciled,
      double ourView,
      double theirView,
      double variance,
      double variancePercentage,
      DateTime? lastChecked,
      List<ReconciliationIssue> issues});
}

/// @nodoc
class _$ReconciliationStatusCopyWithImpl<$Res,
        $Val extends ReconciliationStatus>
    implements $ReconciliationStatusCopyWith<$Res> {
  _$ReconciliationStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReconciliationStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterpartyId = null,
    Object? isReconciled = null,
    Object? ourView = null,
    Object? theirView = null,
    Object? variance = null,
    Object? variancePercentage = null,
    Object? lastChecked = freezed,
    Object? issues = null,
  }) {
    return _then(_value.copyWith(
      counterpartyId: null == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String,
      isReconciled: null == isReconciled
          ? _value.isReconciled
          : isReconciled // ignore: cast_nullable_to_non_nullable
              as bool,
      ourView: null == ourView
          ? _value.ourView
          : ourView // ignore: cast_nullable_to_non_nullable
              as double,
      theirView: null == theirView
          ? _value.theirView
          : theirView // ignore: cast_nullable_to_non_nullable
              as double,
      variance: null == variance
          ? _value.variance
          : variance // ignore: cast_nullable_to_non_nullable
              as double,
      variancePercentage: null == variancePercentage
          ? _value.variancePercentage
          : variancePercentage // ignore: cast_nullable_to_non_nullable
              as double,
      lastChecked: freezed == lastChecked
          ? _value.lastChecked
          : lastChecked // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      issues: null == issues
          ? _value.issues
          : issues // ignore: cast_nullable_to_non_nullable
              as List<ReconciliationIssue>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReconciliationStatusImplCopyWith<$Res>
    implements $ReconciliationStatusCopyWith<$Res> {
  factory _$$ReconciliationStatusImplCopyWith(_$ReconciliationStatusImpl value,
          $Res Function(_$ReconciliationStatusImpl) then) =
      __$$ReconciliationStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String counterpartyId,
      bool isReconciled,
      double ourView,
      double theirView,
      double variance,
      double variancePercentage,
      DateTime? lastChecked,
      List<ReconciliationIssue> issues});
}

/// @nodoc
class __$$ReconciliationStatusImplCopyWithImpl<$Res>
    extends _$ReconciliationStatusCopyWithImpl<$Res, _$ReconciliationStatusImpl>
    implements _$$ReconciliationStatusImplCopyWith<$Res> {
  __$$ReconciliationStatusImplCopyWithImpl(_$ReconciliationStatusImpl _value,
      $Res Function(_$ReconciliationStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReconciliationStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterpartyId = null,
    Object? isReconciled = null,
    Object? ourView = null,
    Object? theirView = null,
    Object? variance = null,
    Object? variancePercentage = null,
    Object? lastChecked = freezed,
    Object? issues = null,
  }) {
    return _then(_$ReconciliationStatusImpl(
      counterpartyId: null == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String,
      isReconciled: null == isReconciled
          ? _value.isReconciled
          : isReconciled // ignore: cast_nullable_to_non_nullable
              as bool,
      ourView: null == ourView
          ? _value.ourView
          : ourView // ignore: cast_nullable_to_non_nullable
              as double,
      theirView: null == theirView
          ? _value.theirView
          : theirView // ignore: cast_nullable_to_non_nullable
              as double,
      variance: null == variance
          ? _value.variance
          : variance // ignore: cast_nullable_to_non_nullable
              as double,
      variancePercentage: null == variancePercentage
          ? _value.variancePercentage
          : variancePercentage // ignore: cast_nullable_to_non_nullable
              as double,
      lastChecked: freezed == lastChecked
          ? _value.lastChecked
          : lastChecked // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      issues: null == issues
          ? _value._issues
          : issues // ignore: cast_nullable_to_non_nullable
              as List<ReconciliationIssue>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReconciliationStatusImpl implements _ReconciliationStatus {
  const _$ReconciliationStatusImpl(
      {required this.counterpartyId,
      required this.isReconciled,
      required this.ourView,
      required this.theirView,
      required this.variance,
      required this.variancePercentage,
      this.lastChecked,
      final List<ReconciliationIssue> issues = const []})
      : _issues = issues;

  factory _$ReconciliationStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReconciliationStatusImplFromJson(json);

  @override
  final String counterpartyId;
  @override
  final bool isReconciled;
  @override
  final double ourView;
  @override
  final double theirView;
  @override
  final double variance;
  @override
  final double variancePercentage;
  @override
  final DateTime? lastChecked;
  final List<ReconciliationIssue> _issues;
  @override
  @JsonKey()
  List<ReconciliationIssue> get issues {
    if (_issues is EqualUnmodifiableListView) return _issues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_issues);
  }

  @override
  String toString() {
    return 'ReconciliationStatus(counterpartyId: $counterpartyId, isReconciled: $isReconciled, ourView: $ourView, theirView: $theirView, variance: $variance, variancePercentage: $variancePercentage, lastChecked: $lastChecked, issues: $issues)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReconciliationStatusImpl &&
            (identical(other.counterpartyId, counterpartyId) ||
                other.counterpartyId == counterpartyId) &&
            (identical(other.isReconciled, isReconciled) ||
                other.isReconciled == isReconciled) &&
            (identical(other.ourView, ourView) || other.ourView == ourView) &&
            (identical(other.theirView, theirView) ||
                other.theirView == theirView) &&
            (identical(other.variance, variance) ||
                other.variance == variance) &&
            (identical(other.variancePercentage, variancePercentage) ||
                other.variancePercentage == variancePercentage) &&
            (identical(other.lastChecked, lastChecked) ||
                other.lastChecked == lastChecked) &&
            const DeepCollectionEquality().equals(other._issues, _issues));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      counterpartyId,
      isReconciled,
      ourView,
      theirView,
      variance,
      variancePercentage,
      lastChecked,
      const DeepCollectionEquality().hash(_issues));

  /// Create a copy of ReconciliationStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReconciliationStatusImplCopyWith<_$ReconciliationStatusImpl>
      get copyWith =>
          __$$ReconciliationStatusImplCopyWithImpl<_$ReconciliationStatusImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReconciliationStatusImplToJson(
      this,
    );
  }
}

abstract class _ReconciliationStatus implements ReconciliationStatus {
  const factory _ReconciliationStatus(
      {required final String counterpartyId,
      required final bool isReconciled,
      required final double ourView,
      required final double theirView,
      required final double variance,
      required final double variancePercentage,
      final DateTime? lastChecked,
      final List<ReconciliationIssue> issues}) = _$ReconciliationStatusImpl;

  factory _ReconciliationStatus.fromJson(Map<String, dynamic> json) =
      _$ReconciliationStatusImpl.fromJson;

  @override
  String get counterpartyId;
  @override
  bool get isReconciled;
  @override
  double get ourView;
  @override
  double get theirView;
  @override
  double get variance;
  @override
  double get variancePercentage;
  @override
  DateTime? get lastChecked;
  @override
  List<ReconciliationIssue> get issues;

  /// Create a copy of ReconciliationStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReconciliationStatusImplCopyWith<_$ReconciliationStatusImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ReconciliationIssue _$ReconciliationIssueFromJson(Map<String, dynamic> json) {
  return _ReconciliationIssue.fromJson(json);
}

/// @nodoc
mixin _$ReconciliationIssue {
  String get issueType =>
      throw _privateConstructorUsedError; // 'missing_transaction', 'amount_mismatch', 'date_mismatch'
  String get description => throw _privateConstructorUsedError;
  String get severity =>
      throw _privateConstructorUsedError; // 'critical', 'warning', 'info'
  String? get transactionRef => throw _privateConstructorUsedError;
  double? get amountDifference => throw _privateConstructorUsedError;
  Map<String, dynamic>? get details => throw _privateConstructorUsedError;

  /// Serializes this ReconciliationIssue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReconciliationIssue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReconciliationIssueCopyWith<ReconciliationIssue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReconciliationIssueCopyWith<$Res> {
  factory $ReconciliationIssueCopyWith(
          ReconciliationIssue value, $Res Function(ReconciliationIssue) then) =
      _$ReconciliationIssueCopyWithImpl<$Res, ReconciliationIssue>;
  @useResult
  $Res call(
      {String issueType,
      String description,
      String severity,
      String? transactionRef,
      double? amountDifference,
      Map<String, dynamic>? details});
}

/// @nodoc
class _$ReconciliationIssueCopyWithImpl<$Res, $Val extends ReconciliationIssue>
    implements $ReconciliationIssueCopyWith<$Res> {
  _$ReconciliationIssueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReconciliationIssue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? issueType = null,
    Object? description = null,
    Object? severity = null,
    Object? transactionRef = freezed,
    Object? amountDifference = freezed,
    Object? details = freezed,
  }) {
    return _then(_value.copyWith(
      issueType: null == issueType
          ? _value.issueType
          : issueType // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String,
      transactionRef: freezed == transactionRef
          ? _value.transactionRef
          : transactionRef // ignore: cast_nullable_to_non_nullable
              as String?,
      amountDifference: freezed == amountDifference
          ? _value.amountDifference
          : amountDifference // ignore: cast_nullable_to_non_nullable
              as double?,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReconciliationIssueImplCopyWith<$Res>
    implements $ReconciliationIssueCopyWith<$Res> {
  factory _$$ReconciliationIssueImplCopyWith(_$ReconciliationIssueImpl value,
          $Res Function(_$ReconciliationIssueImpl) then) =
      __$$ReconciliationIssueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String issueType,
      String description,
      String severity,
      String? transactionRef,
      double? amountDifference,
      Map<String, dynamic>? details});
}

/// @nodoc
class __$$ReconciliationIssueImplCopyWithImpl<$Res>
    extends _$ReconciliationIssueCopyWithImpl<$Res, _$ReconciliationIssueImpl>
    implements _$$ReconciliationIssueImplCopyWith<$Res> {
  __$$ReconciliationIssueImplCopyWithImpl(_$ReconciliationIssueImpl _value,
      $Res Function(_$ReconciliationIssueImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReconciliationIssue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? issueType = null,
    Object? description = null,
    Object? severity = null,
    Object? transactionRef = freezed,
    Object? amountDifference = freezed,
    Object? details = freezed,
  }) {
    return _then(_$ReconciliationIssueImpl(
      issueType: null == issueType
          ? _value.issueType
          : issueType // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String,
      transactionRef: freezed == transactionRef
          ? _value.transactionRef
          : transactionRef // ignore: cast_nullable_to_non_nullable
              as String?,
      amountDifference: freezed == amountDifference
          ? _value.amountDifference
          : amountDifference // ignore: cast_nullable_to_non_nullable
              as double?,
      details: freezed == details
          ? _value._details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReconciliationIssueImpl implements _ReconciliationIssue {
  const _$ReconciliationIssueImpl(
      {required this.issueType,
      required this.description,
      required this.severity,
      this.transactionRef,
      this.amountDifference,
      final Map<String, dynamic>? details})
      : _details = details;

  factory _$ReconciliationIssueImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReconciliationIssueImplFromJson(json);

  @override
  final String issueType;
// 'missing_transaction', 'amount_mismatch', 'date_mismatch'
  @override
  final String description;
  @override
  final String severity;
// 'critical', 'warning', 'info'
  @override
  final String? transactionRef;
  @override
  final double? amountDifference;
  final Map<String, dynamic>? _details;
  @override
  Map<String, dynamic>? get details {
    final value = _details;
    if (value == null) return null;
    if (_details is EqualUnmodifiableMapView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ReconciliationIssue(issueType: $issueType, description: $description, severity: $severity, transactionRef: $transactionRef, amountDifference: $amountDifference, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReconciliationIssueImpl &&
            (identical(other.issueType, issueType) ||
                other.issueType == issueType) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.transactionRef, transactionRef) ||
                other.transactionRef == transactionRef) &&
            (identical(other.amountDifference, amountDifference) ||
                other.amountDifference == amountDifference) &&
            const DeepCollectionEquality().equals(other._details, _details));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      issueType,
      description,
      severity,
      transactionRef,
      amountDifference,
      const DeepCollectionEquality().hash(_details));

  /// Create a copy of ReconciliationIssue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReconciliationIssueImplCopyWith<_$ReconciliationIssueImpl> get copyWith =>
      __$$ReconciliationIssueImplCopyWithImpl<_$ReconciliationIssueImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReconciliationIssueImplToJson(
      this,
    );
  }
}

abstract class _ReconciliationIssue implements ReconciliationIssue {
  const factory _ReconciliationIssue(
      {required final String issueType,
      required final String description,
      required final String severity,
      final String? transactionRef,
      final double? amountDifference,
      final Map<String, dynamic>? details}) = _$ReconciliationIssueImpl;

  factory _ReconciliationIssue.fromJson(Map<String, dynamic> json) =
      _$ReconciliationIssueImpl.fromJson;

  @override
  String
      get issueType; // 'missing_transaction', 'amount_mismatch', 'date_mismatch'
  @override
  String get description;
  @override
  String get severity; // 'critical', 'warning', 'info'
  @override
  String? get transactionRef;
  @override
  double? get amountDifference;
  @override
  Map<String, dynamic>? get details;

  /// Create a copy of ReconciliationIssue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReconciliationIssueImplCopyWith<_$ReconciliationIssueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
