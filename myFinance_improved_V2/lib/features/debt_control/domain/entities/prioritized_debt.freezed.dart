// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prioritized_debt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PrioritizedDebt {
  String get id => throw _privateConstructorUsedError;
  String get counterpartyId => throw _privateConstructorUsedError;
  String get counterpartyName => throw _privateConstructorUsedError;
  String get counterpartyType => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  int get daysOverdue => throw _privateConstructorUsedError;
  String get riskCategory => throw _privateConstructorUsedError;
  double get priorityScore => throw _privateConstructorUsedError;
  DateTime? get lastContactDate => throw _privateConstructorUsedError;
  String? get lastContactType => throw _privateConstructorUsedError;
  String? get paymentStatus => throw _privateConstructorUsedError;
  List<String> get suggestedActions => throw _privateConstructorUsedError;
  bool get hasPaymentPlan => throw _privateConstructorUsedError;
  bool get isDisputed => throw _privateConstructorUsedError;
  int get transactionCount => throw _privateConstructorUsedError;
  String? get linkedCompanyName => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Create a copy of PrioritizedDebt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrioritizedDebtCopyWith<PrioritizedDebt> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrioritizedDebtCopyWith<$Res> {
  factory $PrioritizedDebtCopyWith(
          PrioritizedDebt value, $Res Function(PrioritizedDebt) then) =
      _$PrioritizedDebtCopyWithImpl<$Res, PrioritizedDebt>;
  @useResult
  $Res call(
      {String id,
      String counterpartyId,
      String counterpartyName,
      String counterpartyType,
      double amount,
      String currency,
      DateTime dueDate,
      int daysOverdue,
      String riskCategory,
      double priorityScore,
      DateTime? lastContactDate,
      String? lastContactType,
      String? paymentStatus,
      List<String> suggestedActions,
      bool hasPaymentPlan,
      bool isDisputed,
      int transactionCount,
      String? linkedCompanyName,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$PrioritizedDebtCopyWithImpl<$Res, $Val extends PrioritizedDebt>
    implements $PrioritizedDebtCopyWith<$Res> {
  _$PrioritizedDebtCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrioritizedDebt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? counterpartyId = null,
    Object? counterpartyName = null,
    Object? counterpartyType = null,
    Object? amount = null,
    Object? currency = null,
    Object? dueDate = null,
    Object? daysOverdue = null,
    Object? riskCategory = null,
    Object? priorityScore = null,
    Object? lastContactDate = freezed,
    Object? lastContactType = freezed,
    Object? paymentStatus = freezed,
    Object? suggestedActions = null,
    Object? hasPaymentPlan = null,
    Object? isDisputed = null,
    Object? transactionCount = null,
    Object? linkedCompanyName = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyId: null == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyName: null == counterpartyName
          ? _value.counterpartyName
          : counterpartyName // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyType: null == counterpartyType
          ? _value.counterpartyType
          : counterpartyType // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      daysOverdue: null == daysOverdue
          ? _value.daysOverdue
          : daysOverdue // ignore: cast_nullable_to_non_nullable
              as int,
      riskCategory: null == riskCategory
          ? _value.riskCategory
          : riskCategory // ignore: cast_nullable_to_non_nullable
              as String,
      priorityScore: null == priorityScore
          ? _value.priorityScore
          : priorityScore // ignore: cast_nullable_to_non_nullable
              as double,
      lastContactDate: freezed == lastContactDate
          ? _value.lastContactDate
          : lastContactDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastContactType: freezed == lastContactType
          ? _value.lastContactType
          : lastContactType // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatus: freezed == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      suggestedActions: null == suggestedActions
          ? _value.suggestedActions
          : suggestedActions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hasPaymentPlan: null == hasPaymentPlan
          ? _value.hasPaymentPlan
          : hasPaymentPlan // ignore: cast_nullable_to_non_nullable
              as bool,
      isDisputed: null == isDisputed
          ? _value.isDisputed
          : isDisputed // ignore: cast_nullable_to_non_nullable
              as bool,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      linkedCompanyName: freezed == linkedCompanyName
          ? _value.linkedCompanyName
          : linkedCompanyName // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrioritizedDebtImplCopyWith<$Res>
    implements $PrioritizedDebtCopyWith<$Res> {
  factory _$$PrioritizedDebtImplCopyWith(_$PrioritizedDebtImpl value,
          $Res Function(_$PrioritizedDebtImpl) then) =
      __$$PrioritizedDebtImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String counterpartyId,
      String counterpartyName,
      String counterpartyType,
      double amount,
      String currency,
      DateTime dueDate,
      int daysOverdue,
      String riskCategory,
      double priorityScore,
      DateTime? lastContactDate,
      String? lastContactType,
      String? paymentStatus,
      List<String> suggestedActions,
      bool hasPaymentPlan,
      bool isDisputed,
      int transactionCount,
      String? linkedCompanyName,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$PrioritizedDebtImplCopyWithImpl<$Res>
    extends _$PrioritizedDebtCopyWithImpl<$Res, _$PrioritizedDebtImpl>
    implements _$$PrioritizedDebtImplCopyWith<$Res> {
  __$$PrioritizedDebtImplCopyWithImpl(
      _$PrioritizedDebtImpl _value, $Res Function(_$PrioritizedDebtImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrioritizedDebt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? counterpartyId = null,
    Object? counterpartyName = null,
    Object? counterpartyType = null,
    Object? amount = null,
    Object? currency = null,
    Object? dueDate = null,
    Object? daysOverdue = null,
    Object? riskCategory = null,
    Object? priorityScore = null,
    Object? lastContactDate = freezed,
    Object? lastContactType = freezed,
    Object? paymentStatus = freezed,
    Object? suggestedActions = null,
    Object? hasPaymentPlan = null,
    Object? isDisputed = null,
    Object? transactionCount = null,
    Object? linkedCompanyName = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$PrioritizedDebtImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyId: null == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyName: null == counterpartyName
          ? _value.counterpartyName
          : counterpartyName // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyType: null == counterpartyType
          ? _value.counterpartyType
          : counterpartyType // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      daysOverdue: null == daysOverdue
          ? _value.daysOverdue
          : daysOverdue // ignore: cast_nullable_to_non_nullable
              as int,
      riskCategory: null == riskCategory
          ? _value.riskCategory
          : riskCategory // ignore: cast_nullable_to_non_nullable
              as String,
      priorityScore: null == priorityScore
          ? _value.priorityScore
          : priorityScore // ignore: cast_nullable_to_non_nullable
              as double,
      lastContactDate: freezed == lastContactDate
          ? _value.lastContactDate
          : lastContactDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastContactType: freezed == lastContactType
          ? _value.lastContactType
          : lastContactType // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatus: freezed == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      suggestedActions: null == suggestedActions
          ? _value._suggestedActions
          : suggestedActions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hasPaymentPlan: null == hasPaymentPlan
          ? _value.hasPaymentPlan
          : hasPaymentPlan // ignore: cast_nullable_to_non_nullable
              as bool,
      isDisputed: null == isDisputed
          ? _value.isDisputed
          : isDisputed // ignore: cast_nullable_to_non_nullable
              as bool,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      linkedCompanyName: freezed == linkedCompanyName
          ? _value.linkedCompanyName
          : linkedCompanyName // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$PrioritizedDebtImpl extends _PrioritizedDebt {
  const _$PrioritizedDebtImpl(
      {required this.id,
      required this.counterpartyId,
      required this.counterpartyName,
      required this.counterpartyType,
      required this.amount,
      required this.currency,
      required this.dueDate,
      required this.daysOverdue,
      required this.riskCategory,
      required this.priorityScore,
      this.lastContactDate,
      this.lastContactType,
      this.paymentStatus,
      final List<String> suggestedActions = const [],
      this.hasPaymentPlan = false,
      this.isDisputed = false,
      this.transactionCount = 0,
      this.linkedCompanyName,
      final Map<String, dynamic>? metadata})
      : _suggestedActions = suggestedActions,
        _metadata = metadata,
        super._();

  @override
  final String id;
  @override
  final String counterpartyId;
  @override
  final String counterpartyName;
  @override
  final String counterpartyType;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final DateTime dueDate;
  @override
  final int daysOverdue;
  @override
  final String riskCategory;
  @override
  final double priorityScore;
  @override
  final DateTime? lastContactDate;
  @override
  final String? lastContactType;
  @override
  final String? paymentStatus;
  final List<String> _suggestedActions;
  @override
  @JsonKey()
  List<String> get suggestedActions {
    if (_suggestedActions is EqualUnmodifiableListView)
      return _suggestedActions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestedActions);
  }

  @override
  @JsonKey()
  final bool hasPaymentPlan;
  @override
  @JsonKey()
  final bool isDisputed;
  @override
  @JsonKey()
  final int transactionCount;
  @override
  final String? linkedCompanyName;
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
    return 'PrioritizedDebt(id: $id, counterpartyId: $counterpartyId, counterpartyName: $counterpartyName, counterpartyType: $counterpartyType, amount: $amount, currency: $currency, dueDate: $dueDate, daysOverdue: $daysOverdue, riskCategory: $riskCategory, priorityScore: $priorityScore, lastContactDate: $lastContactDate, lastContactType: $lastContactType, paymentStatus: $paymentStatus, suggestedActions: $suggestedActions, hasPaymentPlan: $hasPaymentPlan, isDisputed: $isDisputed, transactionCount: $transactionCount, linkedCompanyName: $linkedCompanyName, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrioritizedDebtImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.counterpartyId, counterpartyId) ||
                other.counterpartyId == counterpartyId) &&
            (identical(other.counterpartyName, counterpartyName) ||
                other.counterpartyName == counterpartyName) &&
            (identical(other.counterpartyType, counterpartyType) ||
                other.counterpartyType == counterpartyType) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.daysOverdue, daysOverdue) ||
                other.daysOverdue == daysOverdue) &&
            (identical(other.riskCategory, riskCategory) ||
                other.riskCategory == riskCategory) &&
            (identical(other.priorityScore, priorityScore) ||
                other.priorityScore == priorityScore) &&
            (identical(other.lastContactDate, lastContactDate) ||
                other.lastContactDate == lastContactDate) &&
            (identical(other.lastContactType, lastContactType) ||
                other.lastContactType == lastContactType) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            const DeepCollectionEquality()
                .equals(other._suggestedActions, _suggestedActions) &&
            (identical(other.hasPaymentPlan, hasPaymentPlan) ||
                other.hasPaymentPlan == hasPaymentPlan) &&
            (identical(other.isDisputed, isDisputed) ||
                other.isDisputed == isDisputed) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            (identical(other.linkedCompanyName, linkedCompanyName) ||
                other.linkedCompanyName == linkedCompanyName) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        counterpartyId,
        counterpartyName,
        counterpartyType,
        amount,
        currency,
        dueDate,
        daysOverdue,
        riskCategory,
        priorityScore,
        lastContactDate,
        lastContactType,
        paymentStatus,
        const DeepCollectionEquality().hash(_suggestedActions),
        hasPaymentPlan,
        isDisputed,
        transactionCount,
        linkedCompanyName,
        const DeepCollectionEquality().hash(_metadata)
      ]);

  /// Create a copy of PrioritizedDebt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrioritizedDebtImplCopyWith<_$PrioritizedDebtImpl> get copyWith =>
      __$$PrioritizedDebtImplCopyWithImpl<_$PrioritizedDebtImpl>(
          this, _$identity);
}

abstract class _PrioritizedDebt extends PrioritizedDebt {
  const factory _PrioritizedDebt(
      {required final String id,
      required final String counterpartyId,
      required final String counterpartyName,
      required final String counterpartyType,
      required final double amount,
      required final String currency,
      required final DateTime dueDate,
      required final int daysOverdue,
      required final String riskCategory,
      required final double priorityScore,
      final DateTime? lastContactDate,
      final String? lastContactType,
      final String? paymentStatus,
      final List<String> suggestedActions,
      final bool hasPaymentPlan,
      final bool isDisputed,
      final int transactionCount,
      final String? linkedCompanyName,
      final Map<String, dynamic>? metadata}) = _$PrioritizedDebtImpl;
  const _PrioritizedDebt._() : super._();

  @override
  String get id;
  @override
  String get counterpartyId;
  @override
  String get counterpartyName;
  @override
  String get counterpartyType;
  @override
  double get amount;
  @override
  String get currency;
  @override
  DateTime get dueDate;
  @override
  int get daysOverdue;
  @override
  String get riskCategory;
  @override
  double get priorityScore;
  @override
  DateTime? get lastContactDate;
  @override
  String? get lastContactType;
  @override
  String? get paymentStatus;
  @override
  List<String> get suggestedActions;
  @override
  bool get hasPaymentPlan;
  @override
  bool get isDisputed;
  @override
  int get transactionCount;
  @override
  String? get linkedCompanyName;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of PrioritizedDebt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrioritizedDebtImplCopyWith<_$PrioritizedDebtImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
