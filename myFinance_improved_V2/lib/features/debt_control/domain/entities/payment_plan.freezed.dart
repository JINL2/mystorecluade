// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PaymentPlan {
  String get id => throw _privateConstructorUsedError;
  String get debtId => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  double get installmentAmount => throw _privateConstructorUsedError;
  String get frequency => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  List<PaymentPlanInstallment> get installments =>
      throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Create a copy of PaymentPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentPlanCopyWith<PaymentPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentPlanCopyWith<$Res> {
  factory $PaymentPlanCopyWith(
          PaymentPlan value, $Res Function(PaymentPlan) then) =
      _$PaymentPlanCopyWithImpl<$Res, PaymentPlan>;
  @useResult
  $Res call(
      {String id,
      String debtId,
      double totalAmount,
      double installmentAmount,
      String frequency,
      DateTime startDate,
      DateTime endDate,
      String status,
      List<PaymentPlanInstallment> installments,
      DateTime? createdAt,
      String? notes});
}

/// @nodoc
class _$PaymentPlanCopyWithImpl<$Res, $Val extends PaymentPlan>
    implements $PaymentPlanCopyWith<$Res> {
  _$PaymentPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? debtId = null,
    Object? totalAmount = null,
    Object? installmentAmount = null,
    Object? frequency = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? status = null,
    Object? installments = null,
    Object? createdAt = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      debtId: null == debtId
          ? _value.debtId
          : debtId // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      installmentAmount: null == installmentAmount
          ? _value.installmentAmount
          : installmentAmount // ignore: cast_nullable_to_non_nullable
              as double,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      installments: null == installments
          ? _value.installments
          : installments // ignore: cast_nullable_to_non_nullable
              as List<PaymentPlanInstallment>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentPlanImplCopyWith<$Res>
    implements $PaymentPlanCopyWith<$Res> {
  factory _$$PaymentPlanImplCopyWith(
          _$PaymentPlanImpl value, $Res Function(_$PaymentPlanImpl) then) =
      __$$PaymentPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String debtId,
      double totalAmount,
      double installmentAmount,
      String frequency,
      DateTime startDate,
      DateTime endDate,
      String status,
      List<PaymentPlanInstallment> installments,
      DateTime? createdAt,
      String? notes});
}

/// @nodoc
class __$$PaymentPlanImplCopyWithImpl<$Res>
    extends _$PaymentPlanCopyWithImpl<$Res, _$PaymentPlanImpl>
    implements _$$PaymentPlanImplCopyWith<$Res> {
  __$$PaymentPlanImplCopyWithImpl(
      _$PaymentPlanImpl _value, $Res Function(_$PaymentPlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? debtId = null,
    Object? totalAmount = null,
    Object? installmentAmount = null,
    Object? frequency = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? status = null,
    Object? installments = null,
    Object? createdAt = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$PaymentPlanImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      debtId: null == debtId
          ? _value.debtId
          : debtId // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      installmentAmount: null == installmentAmount
          ? _value.installmentAmount
          : installmentAmount // ignore: cast_nullable_to_non_nullable
              as double,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      installments: null == installments
          ? _value._installments
          : installments // ignore: cast_nullable_to_non_nullable
              as List<PaymentPlanInstallment>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$PaymentPlanImpl extends _PaymentPlan {
  const _$PaymentPlanImpl(
      {required this.id,
      required this.debtId,
      required this.totalAmount,
      required this.installmentAmount,
      required this.frequency,
      required this.startDate,
      required this.endDate,
      required this.status,
      final List<PaymentPlanInstallment> installments = const [],
      this.createdAt,
      this.notes})
      : _installments = installments,
        super._();

  @override
  final String id;
  @override
  final String debtId;
  @override
  final double totalAmount;
  @override
  final double installmentAmount;
  @override
  final String frequency;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final String status;
  final List<PaymentPlanInstallment> _installments;
  @override
  @JsonKey()
  List<PaymentPlanInstallment> get installments {
    if (_installments is EqualUnmodifiableListView) return _installments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_installments);
  }

  @override
  final DateTime? createdAt;
  @override
  final String? notes;

  @override
  String toString() {
    return 'PaymentPlan(id: $id, debtId: $debtId, totalAmount: $totalAmount, installmentAmount: $installmentAmount, frequency: $frequency, startDate: $startDate, endDate: $endDate, status: $status, installments: $installments, createdAt: $createdAt, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentPlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.debtId, debtId) || other.debtId == debtId) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.installmentAmount, installmentAmount) ||
                other.installmentAmount == installmentAmount) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._installments, _installments) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      debtId,
      totalAmount,
      installmentAmount,
      frequency,
      startDate,
      endDate,
      status,
      const DeepCollectionEquality().hash(_installments),
      createdAt,
      notes);

  /// Create a copy of PaymentPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentPlanImplCopyWith<_$PaymentPlanImpl> get copyWith =>
      __$$PaymentPlanImplCopyWithImpl<_$PaymentPlanImpl>(this, _$identity);
}

abstract class _PaymentPlan extends PaymentPlan {
  const factory _PaymentPlan(
      {required final String id,
      required final String debtId,
      required final double totalAmount,
      required final double installmentAmount,
      required final String frequency,
      required final DateTime startDate,
      required final DateTime endDate,
      required final String status,
      final List<PaymentPlanInstallment> installments,
      final DateTime? createdAt,
      final String? notes}) = _$PaymentPlanImpl;
  const _PaymentPlan._() : super._();

  @override
  String get id;
  @override
  String get debtId;
  @override
  double get totalAmount;
  @override
  double get installmentAmount;
  @override
  String get frequency;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  String get status;
  @override
  List<PaymentPlanInstallment> get installments;
  @override
  DateTime? get createdAt;
  @override
  String? get notes;

  /// Create a copy of PaymentPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentPlanImplCopyWith<_$PaymentPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PaymentPlanInstallment {
  String get id => throw _privateConstructorUsedError;
  String get paymentPlanId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  double get paidAmount => throw _privateConstructorUsedError;
  DateTime? get paidDate => throw _privateConstructorUsedError;
  String? get paymentReference => throw _privateConstructorUsedError;

  /// Create a copy of PaymentPlanInstallment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentPlanInstallmentCopyWith<PaymentPlanInstallment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentPlanInstallmentCopyWith<$Res> {
  factory $PaymentPlanInstallmentCopyWith(PaymentPlanInstallment value,
          $Res Function(PaymentPlanInstallment) then) =
      _$PaymentPlanInstallmentCopyWithImpl<$Res, PaymentPlanInstallment>;
  @useResult
  $Res call(
      {String id,
      String paymentPlanId,
      double amount,
      DateTime dueDate,
      String status,
      double paidAmount,
      DateTime? paidDate,
      String? paymentReference});
}

/// @nodoc
class _$PaymentPlanInstallmentCopyWithImpl<$Res,
        $Val extends PaymentPlanInstallment>
    implements $PaymentPlanInstallmentCopyWith<$Res> {
  _$PaymentPlanInstallmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentPlanInstallment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? paymentPlanId = null,
    Object? amount = null,
    Object? dueDate = null,
    Object? status = null,
    Object? paidAmount = null,
    Object? paidDate = freezed,
    Object? paymentReference = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      paymentPlanId: null == paymentPlanId
          ? _value.paymentPlanId
          : paymentPlanId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      paidAmount: null == paidAmount
          ? _value.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paidDate: freezed == paidDate
          ? _value.paidDate
          : paidDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paymentReference: freezed == paymentReference
          ? _value.paymentReference
          : paymentReference // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentPlanInstallmentImplCopyWith<$Res>
    implements $PaymentPlanInstallmentCopyWith<$Res> {
  factory _$$PaymentPlanInstallmentImplCopyWith(
          _$PaymentPlanInstallmentImpl value,
          $Res Function(_$PaymentPlanInstallmentImpl) then) =
      __$$PaymentPlanInstallmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String paymentPlanId,
      double amount,
      DateTime dueDate,
      String status,
      double paidAmount,
      DateTime? paidDate,
      String? paymentReference});
}

/// @nodoc
class __$$PaymentPlanInstallmentImplCopyWithImpl<$Res>
    extends _$PaymentPlanInstallmentCopyWithImpl<$Res,
        _$PaymentPlanInstallmentImpl>
    implements _$$PaymentPlanInstallmentImplCopyWith<$Res> {
  __$$PaymentPlanInstallmentImplCopyWithImpl(
      _$PaymentPlanInstallmentImpl _value,
      $Res Function(_$PaymentPlanInstallmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentPlanInstallment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? paymentPlanId = null,
    Object? amount = null,
    Object? dueDate = null,
    Object? status = null,
    Object? paidAmount = null,
    Object? paidDate = freezed,
    Object? paymentReference = freezed,
  }) {
    return _then(_$PaymentPlanInstallmentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      paymentPlanId: null == paymentPlanId
          ? _value.paymentPlanId
          : paymentPlanId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      paidAmount: null == paidAmount
          ? _value.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paidDate: freezed == paidDate
          ? _value.paidDate
          : paidDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paymentReference: freezed == paymentReference
          ? _value.paymentReference
          : paymentReference // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$PaymentPlanInstallmentImpl extends _PaymentPlanInstallment {
  const _$PaymentPlanInstallmentImpl(
      {required this.id,
      required this.paymentPlanId,
      required this.amount,
      required this.dueDate,
      required this.status,
      this.paidAmount = 0.0,
      this.paidDate,
      this.paymentReference})
      : super._();

  @override
  final String id;
  @override
  final String paymentPlanId;
  @override
  final double amount;
  @override
  final DateTime dueDate;
  @override
  final String status;
  @override
  @JsonKey()
  final double paidAmount;
  @override
  final DateTime? paidDate;
  @override
  final String? paymentReference;

  @override
  String toString() {
    return 'PaymentPlanInstallment(id: $id, paymentPlanId: $paymentPlanId, amount: $amount, dueDate: $dueDate, status: $status, paidAmount: $paidAmount, paidDate: $paidDate, paymentReference: $paymentReference)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentPlanInstallmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.paymentPlanId, paymentPlanId) ||
                other.paymentPlanId == paymentPlanId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount) &&
            (identical(other.paidDate, paidDate) ||
                other.paidDate == paidDate) &&
            (identical(other.paymentReference, paymentReference) ||
                other.paymentReference == paymentReference));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, paymentPlanId, amount,
      dueDate, status, paidAmount, paidDate, paymentReference);

  /// Create a copy of PaymentPlanInstallment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentPlanInstallmentImplCopyWith<_$PaymentPlanInstallmentImpl>
      get copyWith => __$$PaymentPlanInstallmentImplCopyWithImpl<
          _$PaymentPlanInstallmentImpl>(this, _$identity);
}

abstract class _PaymentPlanInstallment extends PaymentPlanInstallment {
  const factory _PaymentPlanInstallment(
      {required final String id,
      required final String paymentPlanId,
      required final double amount,
      required final DateTime dueDate,
      required final String status,
      final double paidAmount,
      final DateTime? paidDate,
      final String? paymentReference}) = _$PaymentPlanInstallmentImpl;
  const _PaymentPlanInstallment._() : super._();

  @override
  String get id;
  @override
  String get paymentPlanId;
  @override
  double get amount;
  @override
  DateTime get dueDate;
  @override
  String get status;
  @override
  double get paidAmount;
  @override
  DateTime? get paidDate;
  @override
  String? get paymentReference;

  /// Create a copy of PaymentPlanInstallment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentPlanInstallmentImplCopyWith<_$PaymentPlanInstallmentImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DebtAnalytics {
  AgingAnalysis get currentAging => throw _privateConstructorUsedError;
  List<AgingTrendPoint> get agingTrend => throw _privateConstructorUsedError;
  double get collectionEfficiency => throw _privateConstructorUsedError;
  Map<String, double> get riskDistribution =>
      throw _privateConstructorUsedError;
  DateTime? get reportDate => throw _privateConstructorUsedError;

  /// Create a copy of DebtAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DebtAnalyticsCopyWith<DebtAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DebtAnalyticsCopyWith<$Res> {
  factory $DebtAnalyticsCopyWith(
          DebtAnalytics value, $Res Function(DebtAnalytics) then) =
      _$DebtAnalyticsCopyWithImpl<$Res, DebtAnalytics>;
  @useResult
  $Res call(
      {AgingAnalysis currentAging,
      List<AgingTrendPoint> agingTrend,
      double collectionEfficiency,
      Map<String, double> riskDistribution,
      DateTime? reportDate});

  $AgingAnalysisCopyWith<$Res> get currentAging;
}

/// @nodoc
class _$DebtAnalyticsCopyWithImpl<$Res, $Val extends DebtAnalytics>
    implements $DebtAnalyticsCopyWith<$Res> {
  _$DebtAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DebtAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentAging = null,
    Object? agingTrend = null,
    Object? collectionEfficiency = null,
    Object? riskDistribution = null,
    Object? reportDate = freezed,
  }) {
    return _then(_value.copyWith(
      currentAging: null == currentAging
          ? _value.currentAging
          : currentAging // ignore: cast_nullable_to_non_nullable
              as AgingAnalysis,
      agingTrend: null == agingTrend
          ? _value.agingTrend
          : agingTrend // ignore: cast_nullable_to_non_nullable
              as List<AgingTrendPoint>,
      collectionEfficiency: null == collectionEfficiency
          ? _value.collectionEfficiency
          : collectionEfficiency // ignore: cast_nullable_to_non_nullable
              as double,
      riskDistribution: null == riskDistribution
          ? _value.riskDistribution
          : riskDistribution // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      reportDate: freezed == reportDate
          ? _value.reportDate
          : reportDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of DebtAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AgingAnalysisCopyWith<$Res> get currentAging {
    return $AgingAnalysisCopyWith<$Res>(_value.currentAging, (value) {
      return _then(_value.copyWith(currentAging: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DebtAnalyticsImplCopyWith<$Res>
    implements $DebtAnalyticsCopyWith<$Res> {
  factory _$$DebtAnalyticsImplCopyWith(
          _$DebtAnalyticsImpl value, $Res Function(_$DebtAnalyticsImpl) then) =
      __$$DebtAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AgingAnalysis currentAging,
      List<AgingTrendPoint> agingTrend,
      double collectionEfficiency,
      Map<String, double> riskDistribution,
      DateTime? reportDate});

  @override
  $AgingAnalysisCopyWith<$Res> get currentAging;
}

/// @nodoc
class __$$DebtAnalyticsImplCopyWithImpl<$Res>
    extends _$DebtAnalyticsCopyWithImpl<$Res, _$DebtAnalyticsImpl>
    implements _$$DebtAnalyticsImplCopyWith<$Res> {
  __$$DebtAnalyticsImplCopyWithImpl(
      _$DebtAnalyticsImpl _value, $Res Function(_$DebtAnalyticsImpl) _then)
      : super(_value, _then);

  /// Create a copy of DebtAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentAging = null,
    Object? agingTrend = null,
    Object? collectionEfficiency = null,
    Object? riskDistribution = null,
    Object? reportDate = freezed,
  }) {
    return _then(_$DebtAnalyticsImpl(
      currentAging: null == currentAging
          ? _value.currentAging
          : currentAging // ignore: cast_nullable_to_non_nullable
              as AgingAnalysis,
      agingTrend: null == agingTrend
          ? _value._agingTrend
          : agingTrend // ignore: cast_nullable_to_non_nullable
              as List<AgingTrendPoint>,
      collectionEfficiency: null == collectionEfficiency
          ? _value.collectionEfficiency
          : collectionEfficiency // ignore: cast_nullable_to_non_nullable
              as double,
      riskDistribution: null == riskDistribution
          ? _value._riskDistribution
          : riskDistribution // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      reportDate: freezed == reportDate
          ? _value.reportDate
          : reportDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$DebtAnalyticsImpl implements _DebtAnalytics {
  const _$DebtAnalyticsImpl(
      {required this.currentAging,
      final List<AgingTrendPoint> agingTrend = const [],
      required this.collectionEfficiency,
      required final Map<String, double> riskDistribution,
      this.reportDate})
      : _agingTrend = agingTrend,
        _riskDistribution = riskDistribution;

  @override
  final AgingAnalysis currentAging;
  final List<AgingTrendPoint> _agingTrend;
  @override
  @JsonKey()
  List<AgingTrendPoint> get agingTrend {
    if (_agingTrend is EqualUnmodifiableListView) return _agingTrend;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_agingTrend);
  }

  @override
  final double collectionEfficiency;
  final Map<String, double> _riskDistribution;
  @override
  Map<String, double> get riskDistribution {
    if (_riskDistribution is EqualUnmodifiableMapView) return _riskDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_riskDistribution);
  }

  @override
  final DateTime? reportDate;

  @override
  String toString() {
    return 'DebtAnalytics(currentAging: $currentAging, agingTrend: $agingTrend, collectionEfficiency: $collectionEfficiency, riskDistribution: $riskDistribution, reportDate: $reportDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DebtAnalyticsImpl &&
            (identical(other.currentAging, currentAging) ||
                other.currentAging == currentAging) &&
            const DeepCollectionEquality()
                .equals(other._agingTrend, _agingTrend) &&
            (identical(other.collectionEfficiency, collectionEfficiency) ||
                other.collectionEfficiency == collectionEfficiency) &&
            const DeepCollectionEquality()
                .equals(other._riskDistribution, _riskDistribution) &&
            (identical(other.reportDate, reportDate) ||
                other.reportDate == reportDate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentAging,
      const DeepCollectionEquality().hash(_agingTrend),
      collectionEfficiency,
      const DeepCollectionEquality().hash(_riskDistribution),
      reportDate);

  /// Create a copy of DebtAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DebtAnalyticsImplCopyWith<_$DebtAnalyticsImpl> get copyWith =>
      __$$DebtAnalyticsImplCopyWithImpl<_$DebtAnalyticsImpl>(this, _$identity);
}

abstract class _DebtAnalytics implements DebtAnalytics {
  const factory _DebtAnalytics(
      {required final AgingAnalysis currentAging,
      final List<AgingTrendPoint> agingTrend,
      required final double collectionEfficiency,
      required final Map<String, double> riskDistribution,
      final DateTime? reportDate}) = _$DebtAnalyticsImpl;

  @override
  AgingAnalysis get currentAging;
  @override
  List<AgingTrendPoint> get agingTrend;
  @override
  double get collectionEfficiency;
  @override
  Map<String, double> get riskDistribution;
  @override
  DateTime? get reportDate;

  /// Create a copy of DebtAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DebtAnalyticsImplCopyWith<_$DebtAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
