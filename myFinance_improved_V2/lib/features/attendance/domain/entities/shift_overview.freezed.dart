// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_overview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StoreSalary {
  String get storeId => throw _privateConstructorUsedError;
  String get storeName => throw _privateConstructorUsedError;
  String get estimatedSalary => throw _privateConstructorUsedError;

  /// Create a copy of StoreSalary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreSalaryCopyWith<StoreSalary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreSalaryCopyWith<$Res> {
  factory $StoreSalaryCopyWith(
          StoreSalary value, $Res Function(StoreSalary) then) =
      _$StoreSalaryCopyWithImpl<$Res, StoreSalary>;
  @useResult
  $Res call({String storeId, String storeName, String estimatedSalary});
}

/// @nodoc
class _$StoreSalaryCopyWithImpl<$Res, $Val extends StoreSalary>
    implements $StoreSalaryCopyWith<$Res> {
  _$StoreSalaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreSalary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? storeName = null,
    Object? estimatedSalary = null,
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
      estimatedSalary: null == estimatedSalary
          ? _value.estimatedSalary
          : estimatedSalary // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoreSalaryImplCopyWith<$Res>
    implements $StoreSalaryCopyWith<$Res> {
  factory _$$StoreSalaryImplCopyWith(
          _$StoreSalaryImpl value, $Res Function(_$StoreSalaryImpl) then) =
      __$$StoreSalaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String storeId, String storeName, String estimatedSalary});
}

/// @nodoc
class __$$StoreSalaryImplCopyWithImpl<$Res>
    extends _$StoreSalaryCopyWithImpl<$Res, _$StoreSalaryImpl>
    implements _$$StoreSalaryImplCopyWith<$Res> {
  __$$StoreSalaryImplCopyWithImpl(
      _$StoreSalaryImpl _value, $Res Function(_$StoreSalaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoreSalary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? storeName = null,
    Object? estimatedSalary = null,
  }) {
    return _then(_$StoreSalaryImpl(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      estimatedSalary: null == estimatedSalary
          ? _value.estimatedSalary
          : estimatedSalary // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$StoreSalaryImpl implements _StoreSalary {
  const _$StoreSalaryImpl(
      {required this.storeId,
      required this.storeName,
      required this.estimatedSalary});

  @override
  final String storeId;
  @override
  final String storeName;
  @override
  final String estimatedSalary;

  @override
  String toString() {
    return 'StoreSalary(storeId: $storeId, storeName: $storeName, estimatedSalary: $estimatedSalary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreSalaryImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.estimatedSalary, estimatedSalary) ||
                other.estimatedSalary == estimatedSalary));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, storeId, storeName, estimatedSalary);

  /// Create a copy of StoreSalary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreSalaryImplCopyWith<_$StoreSalaryImpl> get copyWith =>
      __$$StoreSalaryImplCopyWithImpl<_$StoreSalaryImpl>(this, _$identity);
}

abstract class _StoreSalary implements StoreSalary {
  const factory _StoreSalary(
      {required final String storeId,
      required final String storeName,
      required final String estimatedSalary}) = _$StoreSalaryImpl;

  @override
  String get storeId;
  @override
  String get storeName;
  @override
  String get estimatedSalary;

  /// Create a copy of StoreSalary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreSalaryImplCopyWith<_$StoreSalaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ShiftOverview {
  String get requestMonth => throw _privateConstructorUsedError;
  int get actualWorkDays => throw _privateConstructorUsedError;
  double get actualWorkHours => throw _privateConstructorUsedError;
  String get estimatedSalary => throw _privateConstructorUsedError;
  String get currencySymbol => throw _privateConstructorUsedError;
  double get salaryAmount => throw _privateConstructorUsedError;
  String get salaryType => throw _privateConstructorUsedError;
  int get lateDeductionTotal => throw _privateConstructorUsedError;
  int get overtimeTotal => throw _privateConstructorUsedError;
  List<StoreSalary> get salaryStores => throw _privateConstructorUsedError;

  /// Create a copy of ShiftOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftOverviewCopyWith<ShiftOverview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftOverviewCopyWith<$Res> {
  factory $ShiftOverviewCopyWith(
          ShiftOverview value, $Res Function(ShiftOverview) then) =
      _$ShiftOverviewCopyWithImpl<$Res, ShiftOverview>;
  @useResult
  $Res call(
      {String requestMonth,
      int actualWorkDays,
      double actualWorkHours,
      String estimatedSalary,
      String currencySymbol,
      double salaryAmount,
      String salaryType,
      int lateDeductionTotal,
      int overtimeTotal,
      List<StoreSalary> salaryStores});
}

/// @nodoc
class _$ShiftOverviewCopyWithImpl<$Res, $Val extends ShiftOverview>
    implements $ShiftOverviewCopyWith<$Res> {
  _$ShiftOverviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestMonth = null,
    Object? actualWorkDays = null,
    Object? actualWorkHours = null,
    Object? estimatedSalary = null,
    Object? currencySymbol = null,
    Object? salaryAmount = null,
    Object? salaryType = null,
    Object? lateDeductionTotal = null,
    Object? overtimeTotal = null,
    Object? salaryStores = null,
  }) {
    return _then(_value.copyWith(
      requestMonth: null == requestMonth
          ? _value.requestMonth
          : requestMonth // ignore: cast_nullable_to_non_nullable
              as String,
      actualWorkDays: null == actualWorkDays
          ? _value.actualWorkDays
          : actualWorkDays // ignore: cast_nullable_to_non_nullable
              as int,
      actualWorkHours: null == actualWorkHours
          ? _value.actualWorkHours
          : actualWorkHours // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedSalary: null == estimatedSalary
          ? _value.estimatedSalary
          : estimatedSalary // ignore: cast_nullable_to_non_nullable
              as String,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      salaryAmount: null == salaryAmount
          ? _value.salaryAmount
          : salaryAmount // ignore: cast_nullable_to_non_nullable
              as double,
      salaryType: null == salaryType
          ? _value.salaryType
          : salaryType // ignore: cast_nullable_to_non_nullable
              as String,
      lateDeductionTotal: null == lateDeductionTotal
          ? _value.lateDeductionTotal
          : lateDeductionTotal // ignore: cast_nullable_to_non_nullable
              as int,
      overtimeTotal: null == overtimeTotal
          ? _value.overtimeTotal
          : overtimeTotal // ignore: cast_nullable_to_non_nullable
              as int,
      salaryStores: null == salaryStores
          ? _value.salaryStores
          : salaryStores // ignore: cast_nullable_to_non_nullable
              as List<StoreSalary>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShiftOverviewImplCopyWith<$Res>
    implements $ShiftOverviewCopyWith<$Res> {
  factory _$$ShiftOverviewImplCopyWith(
          _$ShiftOverviewImpl value, $Res Function(_$ShiftOverviewImpl) then) =
      __$$ShiftOverviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String requestMonth,
      int actualWorkDays,
      double actualWorkHours,
      String estimatedSalary,
      String currencySymbol,
      double salaryAmount,
      String salaryType,
      int lateDeductionTotal,
      int overtimeTotal,
      List<StoreSalary> salaryStores});
}

/// @nodoc
class __$$ShiftOverviewImplCopyWithImpl<$Res>
    extends _$ShiftOverviewCopyWithImpl<$Res, _$ShiftOverviewImpl>
    implements _$$ShiftOverviewImplCopyWith<$Res> {
  __$$ShiftOverviewImplCopyWithImpl(
      _$ShiftOverviewImpl _value, $Res Function(_$ShiftOverviewImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShiftOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestMonth = null,
    Object? actualWorkDays = null,
    Object? actualWorkHours = null,
    Object? estimatedSalary = null,
    Object? currencySymbol = null,
    Object? salaryAmount = null,
    Object? salaryType = null,
    Object? lateDeductionTotal = null,
    Object? overtimeTotal = null,
    Object? salaryStores = null,
  }) {
    return _then(_$ShiftOverviewImpl(
      requestMonth: null == requestMonth
          ? _value.requestMonth
          : requestMonth // ignore: cast_nullable_to_non_nullable
              as String,
      actualWorkDays: null == actualWorkDays
          ? _value.actualWorkDays
          : actualWorkDays // ignore: cast_nullable_to_non_nullable
              as int,
      actualWorkHours: null == actualWorkHours
          ? _value.actualWorkHours
          : actualWorkHours // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedSalary: null == estimatedSalary
          ? _value.estimatedSalary
          : estimatedSalary // ignore: cast_nullable_to_non_nullable
              as String,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      salaryAmount: null == salaryAmount
          ? _value.salaryAmount
          : salaryAmount // ignore: cast_nullable_to_non_nullable
              as double,
      salaryType: null == salaryType
          ? _value.salaryType
          : salaryType // ignore: cast_nullable_to_non_nullable
              as String,
      lateDeductionTotal: null == lateDeductionTotal
          ? _value.lateDeductionTotal
          : lateDeductionTotal // ignore: cast_nullable_to_non_nullable
              as int,
      overtimeTotal: null == overtimeTotal
          ? _value.overtimeTotal
          : overtimeTotal // ignore: cast_nullable_to_non_nullable
              as int,
      salaryStores: null == salaryStores
          ? _value._salaryStores
          : salaryStores // ignore: cast_nullable_to_non_nullable
              as List<StoreSalary>,
    ));
  }
}

/// @nodoc

class _$ShiftOverviewImpl extends _ShiftOverview {
  const _$ShiftOverviewImpl(
      {required this.requestMonth,
      required this.actualWorkDays,
      required this.actualWorkHours,
      required this.estimatedSalary,
      required this.currencySymbol,
      required this.salaryAmount,
      required this.salaryType,
      required this.lateDeductionTotal,
      required this.overtimeTotal,
      required final List<StoreSalary> salaryStores})
      : _salaryStores = salaryStores,
        super._();

  @override
  final String requestMonth;
  @override
  final int actualWorkDays;
  @override
  final double actualWorkHours;
  @override
  final String estimatedSalary;
  @override
  final String currencySymbol;
  @override
  final double salaryAmount;
  @override
  final String salaryType;
  @override
  final int lateDeductionTotal;
  @override
  final int overtimeTotal;
  final List<StoreSalary> _salaryStores;
  @override
  List<StoreSalary> get salaryStores {
    if (_salaryStores is EqualUnmodifiableListView) return _salaryStores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_salaryStores);
  }

  @override
  String toString() {
    return 'ShiftOverview(requestMonth: $requestMonth, actualWorkDays: $actualWorkDays, actualWorkHours: $actualWorkHours, estimatedSalary: $estimatedSalary, currencySymbol: $currencySymbol, salaryAmount: $salaryAmount, salaryType: $salaryType, lateDeductionTotal: $lateDeductionTotal, overtimeTotal: $overtimeTotal, salaryStores: $salaryStores)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftOverviewImpl &&
            (identical(other.requestMonth, requestMonth) ||
                other.requestMonth == requestMonth) &&
            (identical(other.actualWorkDays, actualWorkDays) ||
                other.actualWorkDays == actualWorkDays) &&
            (identical(other.actualWorkHours, actualWorkHours) ||
                other.actualWorkHours == actualWorkHours) &&
            (identical(other.estimatedSalary, estimatedSalary) ||
                other.estimatedSalary == estimatedSalary) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
            (identical(other.salaryAmount, salaryAmount) ||
                other.salaryAmount == salaryAmount) &&
            (identical(other.salaryType, salaryType) ||
                other.salaryType == salaryType) &&
            (identical(other.lateDeductionTotal, lateDeductionTotal) ||
                other.lateDeductionTotal == lateDeductionTotal) &&
            (identical(other.overtimeTotal, overtimeTotal) ||
                other.overtimeTotal == overtimeTotal) &&
            const DeepCollectionEquality()
                .equals(other._salaryStores, _salaryStores));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      requestMonth,
      actualWorkDays,
      actualWorkHours,
      estimatedSalary,
      currencySymbol,
      salaryAmount,
      salaryType,
      lateDeductionTotal,
      overtimeTotal,
      const DeepCollectionEquality().hash(_salaryStores));

  /// Create a copy of ShiftOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftOverviewImplCopyWith<_$ShiftOverviewImpl> get copyWith =>
      __$$ShiftOverviewImplCopyWithImpl<_$ShiftOverviewImpl>(this, _$identity);
}

abstract class _ShiftOverview extends ShiftOverview {
  const factory _ShiftOverview(
      {required final String requestMonth,
      required final int actualWorkDays,
      required final double actualWorkHours,
      required final String estimatedSalary,
      required final String currencySymbol,
      required final double salaryAmount,
      required final String salaryType,
      required final int lateDeductionTotal,
      required final int overtimeTotal,
      required final List<StoreSalary> salaryStores}) = _$ShiftOverviewImpl;
  const _ShiftOverview._() : super._();

  @override
  String get requestMonth;
  @override
  int get actualWorkDays;
  @override
  double get actualWorkHours;
  @override
  String get estimatedSalary;
  @override
  String get currencySymbol;
  @override
  double get salaryAmount;
  @override
  String get salaryType;
  @override
  int get lateDeductionTotal;
  @override
  int get overtimeTotal;
  @override
  List<StoreSalary> get salaryStores;

  /// Create a copy of ShiftOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftOverviewImplCopyWith<_$ShiftOverviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
