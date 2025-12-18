// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cpa_audit_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CpaAuditData _$CpaAuditDataFromJson(Map<String, dynamic> json) {
  return _CpaAuditData.fromJson(json);
}

/// @nodoc
mixin _$CpaAuditData {
  DateTime get targetDate => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  List<StoreEmployeeSummary> get employeesByStore =>
      throw _privateConstructorUsedError;
  List<TransactionEntry> get highValueTransactions =>
      throw _privateConstructorUsedError;
  List<TransactionEntry> get missingDescriptions =>
      throw _privateConstructorUsedError;

  /// Serializes this CpaAuditData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CpaAuditData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CpaAuditDataCopyWith<CpaAuditData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CpaAuditDataCopyWith<$Res> {
  factory $CpaAuditDataCopyWith(
          CpaAuditData value, $Res Function(CpaAuditData) then) =
      _$CpaAuditDataCopyWithImpl<$Res, CpaAuditData>;
  @useResult
  $Res call(
      {DateTime targetDate,
      DateTime startDate,
      DateTime endDate,
      List<StoreEmployeeSummary> employeesByStore,
      List<TransactionEntry> highValueTransactions,
      List<TransactionEntry> missingDescriptions});
}

/// @nodoc
class _$CpaAuditDataCopyWithImpl<$Res, $Val extends CpaAuditData>
    implements $CpaAuditDataCopyWith<$Res> {
  _$CpaAuditDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CpaAuditData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetDate = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? employeesByStore = null,
    Object? highValueTransactions = null,
    Object? missingDescriptions = null,
  }) {
    return _then(_value.copyWith(
      targetDate: null == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      employeesByStore: null == employeesByStore
          ? _value.employeesByStore
          : employeesByStore // ignore: cast_nullable_to_non_nullable
              as List<StoreEmployeeSummary>,
      highValueTransactions: null == highValueTransactions
          ? _value.highValueTransactions
          : highValueTransactions // ignore: cast_nullable_to_non_nullable
              as List<TransactionEntry>,
      missingDescriptions: null == missingDescriptions
          ? _value.missingDescriptions
          : missingDescriptions // ignore: cast_nullable_to_non_nullable
              as List<TransactionEntry>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CpaAuditDataImplCopyWith<$Res>
    implements $CpaAuditDataCopyWith<$Res> {
  factory _$$CpaAuditDataImplCopyWith(
          _$CpaAuditDataImpl value, $Res Function(_$CpaAuditDataImpl) then) =
      __$$CpaAuditDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime targetDate,
      DateTime startDate,
      DateTime endDate,
      List<StoreEmployeeSummary> employeesByStore,
      List<TransactionEntry> highValueTransactions,
      List<TransactionEntry> missingDescriptions});
}

/// @nodoc
class __$$CpaAuditDataImplCopyWithImpl<$Res>
    extends _$CpaAuditDataCopyWithImpl<$Res, _$CpaAuditDataImpl>
    implements _$$CpaAuditDataImplCopyWith<$Res> {
  __$$CpaAuditDataImplCopyWithImpl(
      _$CpaAuditDataImpl _value, $Res Function(_$CpaAuditDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of CpaAuditData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetDate = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? employeesByStore = null,
    Object? highValueTransactions = null,
    Object? missingDescriptions = null,
  }) {
    return _then(_$CpaAuditDataImpl(
      targetDate: null == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      employeesByStore: null == employeesByStore
          ? _value._employeesByStore
          : employeesByStore // ignore: cast_nullable_to_non_nullable
              as List<StoreEmployeeSummary>,
      highValueTransactions: null == highValueTransactions
          ? _value._highValueTransactions
          : highValueTransactions // ignore: cast_nullable_to_non_nullable
              as List<TransactionEntry>,
      missingDescriptions: null == missingDescriptions
          ? _value._missingDescriptions
          : missingDescriptions // ignore: cast_nullable_to_non_nullable
              as List<TransactionEntry>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CpaAuditDataImpl extends _CpaAuditData {
  const _$CpaAuditDataImpl(
      {required this.targetDate,
      required this.startDate,
      required this.endDate,
      required final List<StoreEmployeeSummary> employeesByStore,
      required final List<TransactionEntry> highValueTransactions,
      required final List<TransactionEntry> missingDescriptions})
      : _employeesByStore = employeesByStore,
        _highValueTransactions = highValueTransactions,
        _missingDescriptions = missingDescriptions,
        super._();

  factory _$CpaAuditDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CpaAuditDataImplFromJson(json);

  @override
  final DateTime targetDate;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  final List<StoreEmployeeSummary> _employeesByStore;
  @override
  List<StoreEmployeeSummary> get employeesByStore {
    if (_employeesByStore is EqualUnmodifiableListView)
      return _employeesByStore;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_employeesByStore);
  }

  final List<TransactionEntry> _highValueTransactions;
  @override
  List<TransactionEntry> get highValueTransactions {
    if (_highValueTransactions is EqualUnmodifiableListView)
      return _highValueTransactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_highValueTransactions);
  }

  final List<TransactionEntry> _missingDescriptions;
  @override
  List<TransactionEntry> get missingDescriptions {
    if (_missingDescriptions is EqualUnmodifiableListView)
      return _missingDescriptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_missingDescriptions);
  }

  @override
  String toString() {
    return 'CpaAuditData(targetDate: $targetDate, startDate: $startDate, endDate: $endDate, employeesByStore: $employeesByStore, highValueTransactions: $highValueTransactions, missingDescriptions: $missingDescriptions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CpaAuditDataImpl &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality()
                .equals(other._employeesByStore, _employeesByStore) &&
            const DeepCollectionEquality()
                .equals(other._highValueTransactions, _highValueTransactions) &&
            const DeepCollectionEquality()
                .equals(other._missingDescriptions, _missingDescriptions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      targetDate,
      startDate,
      endDate,
      const DeepCollectionEquality().hash(_employeesByStore),
      const DeepCollectionEquality().hash(_highValueTransactions),
      const DeepCollectionEquality().hash(_missingDescriptions));

  /// Create a copy of CpaAuditData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CpaAuditDataImplCopyWith<_$CpaAuditDataImpl> get copyWith =>
      __$$CpaAuditDataImplCopyWithImpl<_$CpaAuditDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CpaAuditDataImplToJson(
      this,
    );
  }
}

abstract class _CpaAuditData extends CpaAuditData {
  const factory _CpaAuditData(
          {required final DateTime targetDate,
          required final DateTime startDate,
          required final DateTime endDate,
          required final List<StoreEmployeeSummary> employeesByStore,
          required final List<TransactionEntry> highValueTransactions,
          required final List<TransactionEntry> missingDescriptions}) =
      _$CpaAuditDataImpl;
  const _CpaAuditData._() : super._();

  factory _CpaAuditData.fromJson(Map<String, dynamic> json) =
      _$CpaAuditDataImpl.fromJson;

  @override
  DateTime get targetDate;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  List<StoreEmployeeSummary> get employeesByStore;
  @override
  List<TransactionEntry> get highValueTransactions;
  @override
  List<TransactionEntry> get missingDescriptions;

  /// Create a copy of CpaAuditData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CpaAuditDataImplCopyWith<_$CpaAuditDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
