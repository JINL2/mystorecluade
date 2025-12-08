// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EmployeeSummary _$EmployeeSummaryFromJson(Map<String, dynamic> json) {
  return _EmployeeSummary.fromJson(json);
}

/// @nodoc
mixin _$EmployeeSummary {
  String get employeeName => throw _privateConstructorUsedError;
  int get transactionCount => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  List<TransactionEntry> get transactions => throw _privateConstructorUsedError;

  /// Serializes this EmployeeSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeSummaryCopyWith<EmployeeSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeSummaryCopyWith<$Res> {
  factory $EmployeeSummaryCopyWith(
          EmployeeSummary value, $Res Function(EmployeeSummary) then) =
      _$EmployeeSummaryCopyWithImpl<$Res, EmployeeSummary>;
  @useResult
  $Res call(
      {String employeeName,
      int transactionCount,
      double totalAmount,
      List<TransactionEntry> transactions});
}

/// @nodoc
class _$EmployeeSummaryCopyWithImpl<$Res, $Val extends EmployeeSummary>
    implements $EmployeeSummaryCopyWith<$Res> {
  _$EmployeeSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeName = null,
    Object? transactionCount = null,
    Object? totalAmount = null,
    Object? transactions = null,
  }) {
    return _then(_value.copyWith(
      employeeName: null == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      transactions: null == transactions
          ? _value.transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<TransactionEntry>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmployeeSummaryImplCopyWith<$Res>
    implements $EmployeeSummaryCopyWith<$Res> {
  factory _$$EmployeeSummaryImplCopyWith(_$EmployeeSummaryImpl value,
          $Res Function(_$EmployeeSummaryImpl) then) =
      __$$EmployeeSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String employeeName,
      int transactionCount,
      double totalAmount,
      List<TransactionEntry> transactions});
}

/// @nodoc
class __$$EmployeeSummaryImplCopyWithImpl<$Res>
    extends _$EmployeeSummaryCopyWithImpl<$Res, _$EmployeeSummaryImpl>
    implements _$$EmployeeSummaryImplCopyWith<$Res> {
  __$$EmployeeSummaryImplCopyWithImpl(
      _$EmployeeSummaryImpl _value, $Res Function(_$EmployeeSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of EmployeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeName = null,
    Object? transactionCount = null,
    Object? totalAmount = null,
    Object? transactions = null,
  }) {
    return _then(_$EmployeeSummaryImpl(
      employeeName: null == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      transactions: null == transactions
          ? _value._transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<TransactionEntry>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeSummaryImpl extends _EmployeeSummary {
  const _$EmployeeSummaryImpl(
      {required this.employeeName,
      required this.transactionCount,
      required this.totalAmount,
      required final List<TransactionEntry> transactions})
      : _transactions = transactions,
        super._();

  factory _$EmployeeSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeSummaryImplFromJson(json);

  @override
  final String employeeName;
  @override
  final int transactionCount;
  @override
  final double totalAmount;
  final List<TransactionEntry> _transactions;
  @override
  List<TransactionEntry> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  @override
  String toString() {
    return 'EmployeeSummary(employeeName: $employeeName, transactionCount: $transactionCount, totalAmount: $totalAmount, transactions: $transactions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeSummaryImpl &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            const DeepCollectionEquality()
                .equals(other._transactions, _transactions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, employeeName, transactionCount,
      totalAmount, const DeepCollectionEquality().hash(_transactions));

  /// Create a copy of EmployeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeSummaryImplCopyWith<_$EmployeeSummaryImpl> get copyWith =>
      __$$EmployeeSummaryImplCopyWithImpl<_$EmployeeSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeSummaryImplToJson(
      this,
    );
  }
}

abstract class _EmployeeSummary extends EmployeeSummary {
  const factory _EmployeeSummary(
          {required final String employeeName,
          required final int transactionCount,
          required final double totalAmount,
          required final List<TransactionEntry> transactions}) =
      _$EmployeeSummaryImpl;
  const _EmployeeSummary._() : super._();

  factory _EmployeeSummary.fromJson(Map<String, dynamic> json) =
      _$EmployeeSummaryImpl.fromJson;

  @override
  String get employeeName;
  @override
  int get transactionCount;
  @override
  double get totalAmount;
  @override
  List<TransactionEntry> get transactions;

  /// Create a copy of EmployeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeSummaryImplCopyWith<_$EmployeeSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoreEmployeeSummary _$StoreEmployeeSummaryFromJson(Map<String, dynamic> json) {
  return _StoreEmployeeSummary.fromJson(json);
}

/// @nodoc
mixin _$StoreEmployeeSummary {
  String get storeId => throw _privateConstructorUsedError;
  String get storeName => throw _privateConstructorUsedError;
  double get storeTotal => throw _privateConstructorUsedError;
  List<EmployeeSummary> get employees => throw _privateConstructorUsedError;

  /// Serializes this StoreEmployeeSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoreEmployeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreEmployeeSummaryCopyWith<StoreEmployeeSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreEmployeeSummaryCopyWith<$Res> {
  factory $StoreEmployeeSummaryCopyWith(StoreEmployeeSummary value,
          $Res Function(StoreEmployeeSummary) then) =
      _$StoreEmployeeSummaryCopyWithImpl<$Res, StoreEmployeeSummary>;
  @useResult
  $Res call(
      {String storeId,
      String storeName,
      double storeTotal,
      List<EmployeeSummary> employees});
}

/// @nodoc
class _$StoreEmployeeSummaryCopyWithImpl<$Res,
        $Val extends StoreEmployeeSummary>
    implements $StoreEmployeeSummaryCopyWith<$Res> {
  _$StoreEmployeeSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreEmployeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? storeName = null,
    Object? storeTotal = null,
    Object? employees = null,
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
      storeTotal: null == storeTotal
          ? _value.storeTotal
          : storeTotal // ignore: cast_nullable_to_non_nullable
              as double,
      employees: null == employees
          ? _value.employees
          : employees // ignore: cast_nullable_to_non_nullable
              as List<EmployeeSummary>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoreEmployeeSummaryImplCopyWith<$Res>
    implements $StoreEmployeeSummaryCopyWith<$Res> {
  factory _$$StoreEmployeeSummaryImplCopyWith(_$StoreEmployeeSummaryImpl value,
          $Res Function(_$StoreEmployeeSummaryImpl) then) =
      __$$StoreEmployeeSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String storeId,
      String storeName,
      double storeTotal,
      List<EmployeeSummary> employees});
}

/// @nodoc
class __$$StoreEmployeeSummaryImplCopyWithImpl<$Res>
    extends _$StoreEmployeeSummaryCopyWithImpl<$Res, _$StoreEmployeeSummaryImpl>
    implements _$$StoreEmployeeSummaryImplCopyWith<$Res> {
  __$$StoreEmployeeSummaryImplCopyWithImpl(_$StoreEmployeeSummaryImpl _value,
      $Res Function(_$StoreEmployeeSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoreEmployeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? storeName = null,
    Object? storeTotal = null,
    Object? employees = null,
  }) {
    return _then(_$StoreEmployeeSummaryImpl(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      storeTotal: null == storeTotal
          ? _value.storeTotal
          : storeTotal // ignore: cast_nullable_to_non_nullable
              as double,
      employees: null == employees
          ? _value._employees
          : employees // ignore: cast_nullable_to_non_nullable
              as List<EmployeeSummary>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreEmployeeSummaryImpl extends _StoreEmployeeSummary {
  const _$StoreEmployeeSummaryImpl(
      {required this.storeId,
      required this.storeName,
      required this.storeTotal,
      required final List<EmployeeSummary> employees})
      : _employees = employees,
        super._();

  factory _$StoreEmployeeSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreEmployeeSummaryImplFromJson(json);

  @override
  final String storeId;
  @override
  final String storeName;
  @override
  final double storeTotal;
  final List<EmployeeSummary> _employees;
  @override
  List<EmployeeSummary> get employees {
    if (_employees is EqualUnmodifiableListView) return _employees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_employees);
  }

  @override
  String toString() {
    return 'StoreEmployeeSummary(storeId: $storeId, storeName: $storeName, storeTotal: $storeTotal, employees: $employees)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreEmployeeSummaryImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.storeTotal, storeTotal) ||
                other.storeTotal == storeTotal) &&
            const DeepCollectionEquality()
                .equals(other._employees, _employees));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, storeId, storeName, storeTotal,
      const DeepCollectionEquality().hash(_employees));

  /// Create a copy of StoreEmployeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreEmployeeSummaryImplCopyWith<_$StoreEmployeeSummaryImpl>
      get copyWith =>
          __$$StoreEmployeeSummaryImplCopyWithImpl<_$StoreEmployeeSummaryImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreEmployeeSummaryImplToJson(
      this,
    );
  }
}

abstract class _StoreEmployeeSummary extends StoreEmployeeSummary {
  const factory _StoreEmployeeSummary(
          {required final String storeId,
          required final String storeName,
          required final double storeTotal,
          required final List<EmployeeSummary> employees}) =
      _$StoreEmployeeSummaryImpl;
  const _StoreEmployeeSummary._() : super._();

  factory _StoreEmployeeSummary.fromJson(Map<String, dynamic> json) =
      _$StoreEmployeeSummaryImpl.fromJson;

  @override
  String get storeId;
  @override
  String get storeName;
  @override
  double get storeTotal;
  @override
  List<EmployeeSummary> get employees;

  /// Create a copy of StoreEmployeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreEmployeeSummaryImplCopyWith<_$StoreEmployeeSummaryImpl>
      get copyWith => throw _privateConstructorUsedError;
}
