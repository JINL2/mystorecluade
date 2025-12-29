// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pnl_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PnlSummary {
// Current period amounts
  double get revenue => throw _privateConstructorUsedError;
  double get cogs => throw _privateConstructorUsedError;
  double get grossProfit => throw _privateConstructorUsedError;
  double get operatingExpense => throw _privateConstructorUsedError;
  double get operatingIncome => throw _privateConstructorUsedError;
  double get nonOperatingExpense => throw _privateConstructorUsedError;
  double get netIncome => throw _privateConstructorUsedError; // Margins (%)
  double get grossMargin => throw _privateConstructorUsedError;
  double get operatingMargin => throw _privateConstructorUsedError;
  double get netMargin =>
      throw _privateConstructorUsedError; // Previous period (nullable)
  double? get prevRevenue => throw _privateConstructorUsedError;
  double? get prevNetIncome =>
      throw _privateConstructorUsedError; // Change percentages (nullable)
  double? get revenueChangePct => throw _privateConstructorUsedError;
  double? get netIncomeChangePct => throw _privateConstructorUsedError;

  /// Create a copy of PnlSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PnlSummaryCopyWith<PnlSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PnlSummaryCopyWith<$Res> {
  factory $PnlSummaryCopyWith(
          PnlSummary value, $Res Function(PnlSummary) then) =
      _$PnlSummaryCopyWithImpl<$Res, PnlSummary>;
  @useResult
  $Res call(
      {double revenue,
      double cogs,
      double grossProfit,
      double operatingExpense,
      double operatingIncome,
      double nonOperatingExpense,
      double netIncome,
      double grossMargin,
      double operatingMargin,
      double netMargin,
      double? prevRevenue,
      double? prevNetIncome,
      double? revenueChangePct,
      double? netIncomeChangePct});
}

/// @nodoc
class _$PnlSummaryCopyWithImpl<$Res, $Val extends PnlSummary>
    implements $PnlSummaryCopyWith<$Res> {
  _$PnlSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PnlSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? revenue = null,
    Object? cogs = null,
    Object? grossProfit = null,
    Object? operatingExpense = null,
    Object? operatingIncome = null,
    Object? nonOperatingExpense = null,
    Object? netIncome = null,
    Object? grossMargin = null,
    Object? operatingMargin = null,
    Object? netMargin = null,
    Object? prevRevenue = freezed,
    Object? prevNetIncome = freezed,
    Object? revenueChangePct = freezed,
    Object? netIncomeChangePct = freezed,
  }) {
    return _then(_value.copyWith(
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as double,
      cogs: null == cogs
          ? _value.cogs
          : cogs // ignore: cast_nullable_to_non_nullable
              as double,
      grossProfit: null == grossProfit
          ? _value.grossProfit
          : grossProfit // ignore: cast_nullable_to_non_nullable
              as double,
      operatingExpense: null == operatingExpense
          ? _value.operatingExpense
          : operatingExpense // ignore: cast_nullable_to_non_nullable
              as double,
      operatingIncome: null == operatingIncome
          ? _value.operatingIncome
          : operatingIncome // ignore: cast_nullable_to_non_nullable
              as double,
      nonOperatingExpense: null == nonOperatingExpense
          ? _value.nonOperatingExpense
          : nonOperatingExpense // ignore: cast_nullable_to_non_nullable
              as double,
      netIncome: null == netIncome
          ? _value.netIncome
          : netIncome // ignore: cast_nullable_to_non_nullable
              as double,
      grossMargin: null == grossMargin
          ? _value.grossMargin
          : grossMargin // ignore: cast_nullable_to_non_nullable
              as double,
      operatingMargin: null == operatingMargin
          ? _value.operatingMargin
          : operatingMargin // ignore: cast_nullable_to_non_nullable
              as double,
      netMargin: null == netMargin
          ? _value.netMargin
          : netMargin // ignore: cast_nullable_to_non_nullable
              as double,
      prevRevenue: freezed == prevRevenue
          ? _value.prevRevenue
          : prevRevenue // ignore: cast_nullable_to_non_nullable
              as double?,
      prevNetIncome: freezed == prevNetIncome
          ? _value.prevNetIncome
          : prevNetIncome // ignore: cast_nullable_to_non_nullable
              as double?,
      revenueChangePct: freezed == revenueChangePct
          ? _value.revenueChangePct
          : revenueChangePct // ignore: cast_nullable_to_non_nullable
              as double?,
      netIncomeChangePct: freezed == netIncomeChangePct
          ? _value.netIncomeChangePct
          : netIncomeChangePct // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PnlSummaryImplCopyWith<$Res>
    implements $PnlSummaryCopyWith<$Res> {
  factory _$$PnlSummaryImplCopyWith(
          _$PnlSummaryImpl value, $Res Function(_$PnlSummaryImpl) then) =
      __$$PnlSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double revenue,
      double cogs,
      double grossProfit,
      double operatingExpense,
      double operatingIncome,
      double nonOperatingExpense,
      double netIncome,
      double grossMargin,
      double operatingMargin,
      double netMargin,
      double? prevRevenue,
      double? prevNetIncome,
      double? revenueChangePct,
      double? netIncomeChangePct});
}

/// @nodoc
class __$$PnlSummaryImplCopyWithImpl<$Res>
    extends _$PnlSummaryCopyWithImpl<$Res, _$PnlSummaryImpl>
    implements _$$PnlSummaryImplCopyWith<$Res> {
  __$$PnlSummaryImplCopyWithImpl(
      _$PnlSummaryImpl _value, $Res Function(_$PnlSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of PnlSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? revenue = null,
    Object? cogs = null,
    Object? grossProfit = null,
    Object? operatingExpense = null,
    Object? operatingIncome = null,
    Object? nonOperatingExpense = null,
    Object? netIncome = null,
    Object? grossMargin = null,
    Object? operatingMargin = null,
    Object? netMargin = null,
    Object? prevRevenue = freezed,
    Object? prevNetIncome = freezed,
    Object? revenueChangePct = freezed,
    Object? netIncomeChangePct = freezed,
  }) {
    return _then(_$PnlSummaryImpl(
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as double,
      cogs: null == cogs
          ? _value.cogs
          : cogs // ignore: cast_nullable_to_non_nullable
              as double,
      grossProfit: null == grossProfit
          ? _value.grossProfit
          : grossProfit // ignore: cast_nullable_to_non_nullable
              as double,
      operatingExpense: null == operatingExpense
          ? _value.operatingExpense
          : operatingExpense // ignore: cast_nullable_to_non_nullable
              as double,
      operatingIncome: null == operatingIncome
          ? _value.operatingIncome
          : operatingIncome // ignore: cast_nullable_to_non_nullable
              as double,
      nonOperatingExpense: null == nonOperatingExpense
          ? _value.nonOperatingExpense
          : nonOperatingExpense // ignore: cast_nullable_to_non_nullable
              as double,
      netIncome: null == netIncome
          ? _value.netIncome
          : netIncome // ignore: cast_nullable_to_non_nullable
              as double,
      grossMargin: null == grossMargin
          ? _value.grossMargin
          : grossMargin // ignore: cast_nullable_to_non_nullable
              as double,
      operatingMargin: null == operatingMargin
          ? _value.operatingMargin
          : operatingMargin // ignore: cast_nullable_to_non_nullable
              as double,
      netMargin: null == netMargin
          ? _value.netMargin
          : netMargin // ignore: cast_nullable_to_non_nullable
              as double,
      prevRevenue: freezed == prevRevenue
          ? _value.prevRevenue
          : prevRevenue // ignore: cast_nullable_to_non_nullable
              as double?,
      prevNetIncome: freezed == prevNetIncome
          ? _value.prevNetIncome
          : prevNetIncome // ignore: cast_nullable_to_non_nullable
              as double?,
      revenueChangePct: freezed == revenueChangePct
          ? _value.revenueChangePct
          : revenueChangePct // ignore: cast_nullable_to_non_nullable
              as double?,
      netIncomeChangePct: freezed == netIncomeChangePct
          ? _value.netIncomeChangePct
          : netIncomeChangePct // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

class _$PnlSummaryImpl extends _PnlSummary {
  const _$PnlSummaryImpl(
      {this.revenue = 0,
      this.cogs = 0,
      this.grossProfit = 0,
      this.operatingExpense = 0,
      this.operatingIncome = 0,
      this.nonOperatingExpense = 0,
      this.netIncome = 0,
      this.grossMargin = 0,
      this.operatingMargin = 0,
      this.netMargin = 0,
      this.prevRevenue,
      this.prevNetIncome,
      this.revenueChangePct,
      this.netIncomeChangePct})
      : super._();

// Current period amounts
  @override
  @JsonKey()
  final double revenue;
  @override
  @JsonKey()
  final double cogs;
  @override
  @JsonKey()
  final double grossProfit;
  @override
  @JsonKey()
  final double operatingExpense;
  @override
  @JsonKey()
  final double operatingIncome;
  @override
  @JsonKey()
  final double nonOperatingExpense;
  @override
  @JsonKey()
  final double netIncome;
// Margins (%)
  @override
  @JsonKey()
  final double grossMargin;
  @override
  @JsonKey()
  final double operatingMargin;
  @override
  @JsonKey()
  final double netMargin;
// Previous period (nullable)
  @override
  final double? prevRevenue;
  @override
  final double? prevNetIncome;
// Change percentages (nullable)
  @override
  final double? revenueChangePct;
  @override
  final double? netIncomeChangePct;

  @override
  String toString() {
    return 'PnlSummary(revenue: $revenue, cogs: $cogs, grossProfit: $grossProfit, operatingExpense: $operatingExpense, operatingIncome: $operatingIncome, nonOperatingExpense: $nonOperatingExpense, netIncome: $netIncome, grossMargin: $grossMargin, operatingMargin: $operatingMargin, netMargin: $netMargin, prevRevenue: $prevRevenue, prevNetIncome: $prevNetIncome, revenueChangePct: $revenueChangePct, netIncomeChangePct: $netIncomeChangePct)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PnlSummaryImpl &&
            (identical(other.revenue, revenue) || other.revenue == revenue) &&
            (identical(other.cogs, cogs) || other.cogs == cogs) &&
            (identical(other.grossProfit, grossProfit) ||
                other.grossProfit == grossProfit) &&
            (identical(other.operatingExpense, operatingExpense) ||
                other.operatingExpense == operatingExpense) &&
            (identical(other.operatingIncome, operatingIncome) ||
                other.operatingIncome == operatingIncome) &&
            (identical(other.nonOperatingExpense, nonOperatingExpense) ||
                other.nonOperatingExpense == nonOperatingExpense) &&
            (identical(other.netIncome, netIncome) ||
                other.netIncome == netIncome) &&
            (identical(other.grossMargin, grossMargin) ||
                other.grossMargin == grossMargin) &&
            (identical(other.operatingMargin, operatingMargin) ||
                other.operatingMargin == operatingMargin) &&
            (identical(other.netMargin, netMargin) ||
                other.netMargin == netMargin) &&
            (identical(other.prevRevenue, prevRevenue) ||
                other.prevRevenue == prevRevenue) &&
            (identical(other.prevNetIncome, prevNetIncome) ||
                other.prevNetIncome == prevNetIncome) &&
            (identical(other.revenueChangePct, revenueChangePct) ||
                other.revenueChangePct == revenueChangePct) &&
            (identical(other.netIncomeChangePct, netIncomeChangePct) ||
                other.netIncomeChangePct == netIncomeChangePct));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      revenue,
      cogs,
      grossProfit,
      operatingExpense,
      operatingIncome,
      nonOperatingExpense,
      netIncome,
      grossMargin,
      operatingMargin,
      netMargin,
      prevRevenue,
      prevNetIncome,
      revenueChangePct,
      netIncomeChangePct);

  /// Create a copy of PnlSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PnlSummaryImplCopyWith<_$PnlSummaryImpl> get copyWith =>
      __$$PnlSummaryImplCopyWithImpl<_$PnlSummaryImpl>(this, _$identity);
}

abstract class _PnlSummary extends PnlSummary {
  const factory _PnlSummary(
      {final double revenue,
      final double cogs,
      final double grossProfit,
      final double operatingExpense,
      final double operatingIncome,
      final double nonOperatingExpense,
      final double netIncome,
      final double grossMargin,
      final double operatingMargin,
      final double netMargin,
      final double? prevRevenue,
      final double? prevNetIncome,
      final double? revenueChangePct,
      final double? netIncomeChangePct}) = _$PnlSummaryImpl;
  const _PnlSummary._() : super._();

// Current period amounts
  @override
  double get revenue;
  @override
  double get cogs;
  @override
  double get grossProfit;
  @override
  double get operatingExpense;
  @override
  double get operatingIncome;
  @override
  double get nonOperatingExpense;
  @override
  double get netIncome; // Margins (%)
  @override
  double get grossMargin;
  @override
  double get operatingMargin;
  @override
  double get netMargin; // Previous period (nullable)
  @override
  double? get prevRevenue;
  @override
  double? get prevNetIncome; // Change percentages (nullable)
  @override
  double? get revenueChangePct;
  @override
  double? get netIncomeChangePct;

  /// Create a copy of PnlSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PnlSummaryImplCopyWith<_$PnlSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PnlDetailRow {
  String get section => throw _privateConstructorUsedError;
  int get sectionOrder => throw _privateConstructorUsedError;
  String get accountCode => throw _privateConstructorUsedError;
  String get accountName => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;

  /// Create a copy of PnlDetailRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PnlDetailRowCopyWith<PnlDetailRow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PnlDetailRowCopyWith<$Res> {
  factory $PnlDetailRowCopyWith(
          PnlDetailRow value, $Res Function(PnlDetailRow) then) =
      _$PnlDetailRowCopyWithImpl<$Res, PnlDetailRow>;
  @useResult
  $Res call(
      {String section,
      int sectionOrder,
      String accountCode,
      String accountName,
      double amount});
}

/// @nodoc
class _$PnlDetailRowCopyWithImpl<$Res, $Val extends PnlDetailRow>
    implements $PnlDetailRowCopyWith<$Res> {
  _$PnlDetailRowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PnlDetailRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? section = null,
    Object? sectionOrder = null,
    Object? accountCode = null,
    Object? accountName = null,
    Object? amount = null,
  }) {
    return _then(_value.copyWith(
      section: null == section
          ? _value.section
          : section // ignore: cast_nullable_to_non_nullable
              as String,
      sectionOrder: null == sectionOrder
          ? _value.sectionOrder
          : sectionOrder // ignore: cast_nullable_to_non_nullable
              as int,
      accountCode: null == accountCode
          ? _value.accountCode
          : accountCode // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PnlDetailRowImplCopyWith<$Res>
    implements $PnlDetailRowCopyWith<$Res> {
  factory _$$PnlDetailRowImplCopyWith(
          _$PnlDetailRowImpl value, $Res Function(_$PnlDetailRowImpl) then) =
      __$$PnlDetailRowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String section,
      int sectionOrder,
      String accountCode,
      String accountName,
      double amount});
}

/// @nodoc
class __$$PnlDetailRowImplCopyWithImpl<$Res>
    extends _$PnlDetailRowCopyWithImpl<$Res, _$PnlDetailRowImpl>
    implements _$$PnlDetailRowImplCopyWith<$Res> {
  __$$PnlDetailRowImplCopyWithImpl(
      _$PnlDetailRowImpl _value, $Res Function(_$PnlDetailRowImpl) _then)
      : super(_value, _then);

  /// Create a copy of PnlDetailRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? section = null,
    Object? sectionOrder = null,
    Object? accountCode = null,
    Object? accountName = null,
    Object? amount = null,
  }) {
    return _then(_$PnlDetailRowImpl(
      section: null == section
          ? _value.section
          : section // ignore: cast_nullable_to_non_nullable
              as String,
      sectionOrder: null == sectionOrder
          ? _value.sectionOrder
          : sectionOrder // ignore: cast_nullable_to_non_nullable
              as int,
      accountCode: null == accountCode
          ? _value.accountCode
          : accountCode // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$PnlDetailRowImpl implements _PnlDetailRow {
  const _$PnlDetailRowImpl(
      {this.section = '',
      this.sectionOrder = 0,
      this.accountCode = '',
      this.accountName = '',
      this.amount = 0});

  @override
  @JsonKey()
  final String section;
  @override
  @JsonKey()
  final int sectionOrder;
  @override
  @JsonKey()
  final String accountCode;
  @override
  @JsonKey()
  final String accountName;
  @override
  @JsonKey()
  final double amount;

  @override
  String toString() {
    return 'PnlDetailRow(section: $section, sectionOrder: $sectionOrder, accountCode: $accountCode, accountName: $accountName, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PnlDetailRowImpl &&
            (identical(other.section, section) || other.section == section) &&
            (identical(other.sectionOrder, sectionOrder) ||
                other.sectionOrder == sectionOrder) &&
            (identical(other.accountCode, accountCode) ||
                other.accountCode == accountCode) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, section, sectionOrder, accountCode, accountName, amount);

  /// Create a copy of PnlDetailRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PnlDetailRowImplCopyWith<_$PnlDetailRowImpl> get copyWith =>
      __$$PnlDetailRowImplCopyWithImpl<_$PnlDetailRowImpl>(this, _$identity);
}

abstract class _PnlDetailRow implements PnlDetailRow {
  const factory _PnlDetailRow(
      {final String section,
      final int sectionOrder,
      final String accountCode,
      final String accountName,
      final double amount}) = _$PnlDetailRowImpl;

  @override
  String get section;
  @override
  int get sectionOrder;
  @override
  String get accountCode;
  @override
  String get accountName;
  @override
  double get amount;

  /// Create a copy of PnlDetailRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PnlDetailRowImplCopyWith<_$PnlDetailRowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
