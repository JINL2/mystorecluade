// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pnl_summary_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PnlSummaryModel _$PnlSummaryModelFromJson(Map<String, dynamic> json) {
  return _PnlSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$PnlSummaryModel {
// Current period amounts
  double get revenue => throw _privateConstructorUsedError;
  double get cogs => throw _privateConstructorUsedError;
  @JsonKey(name: 'gross_profit')
  double get grossProfit => throw _privateConstructorUsedError;
  @JsonKey(name: 'operating_expense')
  double get operatingExpense => throw _privateConstructorUsedError;
  @JsonKey(name: 'operating_income')
  double get operatingIncome => throw _privateConstructorUsedError;
  @JsonKey(name: 'non_operating_expense')
  double get nonOperatingExpense => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_income')
  double get netIncome => throw _privateConstructorUsedError; // Margins (%)
  @JsonKey(name: 'gross_margin')
  double get grossMargin => throw _privateConstructorUsedError;
  @JsonKey(name: 'operating_margin')
  double get operatingMargin => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_margin')
  double get netMargin =>
      throw _privateConstructorUsedError; // Previous period (nullable)
  @JsonKey(name: 'prev_revenue')
  double? get prevRevenue => throw _privateConstructorUsedError;
  @JsonKey(name: 'prev_net_income')
  double? get prevNetIncome =>
      throw _privateConstructorUsedError; // Change percentages (nullable)
  @JsonKey(name: 'revenue_change_pct')
  double? get revenueChangePct => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_income_change_pct')
  double? get netIncomeChangePct => throw _privateConstructorUsedError;

  /// Serializes this PnlSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PnlSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PnlSummaryModelCopyWith<PnlSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PnlSummaryModelCopyWith<$Res> {
  factory $PnlSummaryModelCopyWith(
          PnlSummaryModel value, $Res Function(PnlSummaryModel) then) =
      _$PnlSummaryModelCopyWithImpl<$Res, PnlSummaryModel>;
  @useResult
  $Res call(
      {double revenue,
      double cogs,
      @JsonKey(name: 'gross_profit') double grossProfit,
      @JsonKey(name: 'operating_expense') double operatingExpense,
      @JsonKey(name: 'operating_income') double operatingIncome,
      @JsonKey(name: 'non_operating_expense') double nonOperatingExpense,
      @JsonKey(name: 'net_income') double netIncome,
      @JsonKey(name: 'gross_margin') double grossMargin,
      @JsonKey(name: 'operating_margin') double operatingMargin,
      @JsonKey(name: 'net_margin') double netMargin,
      @JsonKey(name: 'prev_revenue') double? prevRevenue,
      @JsonKey(name: 'prev_net_income') double? prevNetIncome,
      @JsonKey(name: 'revenue_change_pct') double? revenueChangePct,
      @JsonKey(name: 'net_income_change_pct') double? netIncomeChangePct});
}

/// @nodoc
class _$PnlSummaryModelCopyWithImpl<$Res, $Val extends PnlSummaryModel>
    implements $PnlSummaryModelCopyWith<$Res> {
  _$PnlSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PnlSummaryModel
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
abstract class _$$PnlSummaryModelImplCopyWith<$Res>
    implements $PnlSummaryModelCopyWith<$Res> {
  factory _$$PnlSummaryModelImplCopyWith(_$PnlSummaryModelImpl value,
          $Res Function(_$PnlSummaryModelImpl) then) =
      __$$PnlSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double revenue,
      double cogs,
      @JsonKey(name: 'gross_profit') double grossProfit,
      @JsonKey(name: 'operating_expense') double operatingExpense,
      @JsonKey(name: 'operating_income') double operatingIncome,
      @JsonKey(name: 'non_operating_expense') double nonOperatingExpense,
      @JsonKey(name: 'net_income') double netIncome,
      @JsonKey(name: 'gross_margin') double grossMargin,
      @JsonKey(name: 'operating_margin') double operatingMargin,
      @JsonKey(name: 'net_margin') double netMargin,
      @JsonKey(name: 'prev_revenue') double? prevRevenue,
      @JsonKey(name: 'prev_net_income') double? prevNetIncome,
      @JsonKey(name: 'revenue_change_pct') double? revenueChangePct,
      @JsonKey(name: 'net_income_change_pct') double? netIncomeChangePct});
}

/// @nodoc
class __$$PnlSummaryModelImplCopyWithImpl<$Res>
    extends _$PnlSummaryModelCopyWithImpl<$Res, _$PnlSummaryModelImpl>
    implements _$$PnlSummaryModelImplCopyWith<$Res> {
  __$$PnlSummaryModelImplCopyWithImpl(
      _$PnlSummaryModelImpl _value, $Res Function(_$PnlSummaryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PnlSummaryModel
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
    return _then(_$PnlSummaryModelImpl(
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
@JsonSerializable()
class _$PnlSummaryModelImpl implements _PnlSummaryModel {
  const _$PnlSummaryModelImpl(
      {this.revenue = 0,
      this.cogs = 0,
      @JsonKey(name: 'gross_profit') this.grossProfit = 0,
      @JsonKey(name: 'operating_expense') this.operatingExpense = 0,
      @JsonKey(name: 'operating_income') this.operatingIncome = 0,
      @JsonKey(name: 'non_operating_expense') this.nonOperatingExpense = 0,
      @JsonKey(name: 'net_income') this.netIncome = 0,
      @JsonKey(name: 'gross_margin') this.grossMargin = 0,
      @JsonKey(name: 'operating_margin') this.operatingMargin = 0,
      @JsonKey(name: 'net_margin') this.netMargin = 0,
      @JsonKey(name: 'prev_revenue') this.prevRevenue,
      @JsonKey(name: 'prev_net_income') this.prevNetIncome,
      @JsonKey(name: 'revenue_change_pct') this.revenueChangePct,
      @JsonKey(name: 'net_income_change_pct') this.netIncomeChangePct});

  factory _$PnlSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PnlSummaryModelImplFromJson(json);

// Current period amounts
  @override
  @JsonKey()
  final double revenue;
  @override
  @JsonKey()
  final double cogs;
  @override
  @JsonKey(name: 'gross_profit')
  final double grossProfit;
  @override
  @JsonKey(name: 'operating_expense')
  final double operatingExpense;
  @override
  @JsonKey(name: 'operating_income')
  final double operatingIncome;
  @override
  @JsonKey(name: 'non_operating_expense')
  final double nonOperatingExpense;
  @override
  @JsonKey(name: 'net_income')
  final double netIncome;
// Margins (%)
  @override
  @JsonKey(name: 'gross_margin')
  final double grossMargin;
  @override
  @JsonKey(name: 'operating_margin')
  final double operatingMargin;
  @override
  @JsonKey(name: 'net_margin')
  final double netMargin;
// Previous period (nullable)
  @override
  @JsonKey(name: 'prev_revenue')
  final double? prevRevenue;
  @override
  @JsonKey(name: 'prev_net_income')
  final double? prevNetIncome;
// Change percentages (nullable)
  @override
  @JsonKey(name: 'revenue_change_pct')
  final double? revenueChangePct;
  @override
  @JsonKey(name: 'net_income_change_pct')
  final double? netIncomeChangePct;

  @override
  String toString() {
    return 'PnlSummaryModel(revenue: $revenue, cogs: $cogs, grossProfit: $grossProfit, operatingExpense: $operatingExpense, operatingIncome: $operatingIncome, nonOperatingExpense: $nonOperatingExpense, netIncome: $netIncome, grossMargin: $grossMargin, operatingMargin: $operatingMargin, netMargin: $netMargin, prevRevenue: $prevRevenue, prevNetIncome: $prevNetIncome, revenueChangePct: $revenueChangePct, netIncomeChangePct: $netIncomeChangePct)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PnlSummaryModelImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of PnlSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PnlSummaryModelImplCopyWith<_$PnlSummaryModelImpl> get copyWith =>
      __$$PnlSummaryModelImplCopyWithImpl<_$PnlSummaryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PnlSummaryModelImplToJson(
      this,
    );
  }
}

abstract class _PnlSummaryModel implements PnlSummaryModel {
  const factory _PnlSummaryModel(
      {final double revenue,
      final double cogs,
      @JsonKey(name: 'gross_profit') final double grossProfit,
      @JsonKey(name: 'operating_expense') final double operatingExpense,
      @JsonKey(name: 'operating_income') final double operatingIncome,
      @JsonKey(name: 'non_operating_expense') final double nonOperatingExpense,
      @JsonKey(name: 'net_income') final double netIncome,
      @JsonKey(name: 'gross_margin') final double grossMargin,
      @JsonKey(name: 'operating_margin') final double operatingMargin,
      @JsonKey(name: 'net_margin') final double netMargin,
      @JsonKey(name: 'prev_revenue') final double? prevRevenue,
      @JsonKey(name: 'prev_net_income') final double? prevNetIncome,
      @JsonKey(name: 'revenue_change_pct') final double? revenueChangePct,
      @JsonKey(name: 'net_income_change_pct')
      final double? netIncomeChangePct}) = _$PnlSummaryModelImpl;

  factory _PnlSummaryModel.fromJson(Map<String, dynamic> json) =
      _$PnlSummaryModelImpl.fromJson;

// Current period amounts
  @override
  double get revenue;
  @override
  double get cogs;
  @override
  @JsonKey(name: 'gross_profit')
  double get grossProfit;
  @override
  @JsonKey(name: 'operating_expense')
  double get operatingExpense;
  @override
  @JsonKey(name: 'operating_income')
  double get operatingIncome;
  @override
  @JsonKey(name: 'non_operating_expense')
  double get nonOperatingExpense;
  @override
  @JsonKey(name: 'net_income')
  double get netIncome; // Margins (%)
  @override
  @JsonKey(name: 'gross_margin')
  double get grossMargin;
  @override
  @JsonKey(name: 'operating_margin')
  double get operatingMargin;
  @override
  @JsonKey(name: 'net_margin')
  double get netMargin; // Previous period (nullable)
  @override
  @JsonKey(name: 'prev_revenue')
  double? get prevRevenue;
  @override
  @JsonKey(name: 'prev_net_income')
  double? get prevNetIncome; // Change percentages (nullable)
  @override
  @JsonKey(name: 'revenue_change_pct')
  double? get revenueChangePct;
  @override
  @JsonKey(name: 'net_income_change_pct')
  double? get netIncomeChangePct;

  /// Create a copy of PnlSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PnlSummaryModelImplCopyWith<_$PnlSummaryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PnlDetailRowModel _$PnlDetailRowModelFromJson(Map<String, dynamic> json) {
  return _PnlDetailRowModel.fromJson(json);
}

/// @nodoc
mixin _$PnlDetailRowModel {
  String get section => throw _privateConstructorUsedError;
  @JsonKey(name: 'section_order')
  int get sectionOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_code')
  String get accountCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_name')
  String get accountName => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;

  /// Serializes this PnlDetailRowModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PnlDetailRowModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PnlDetailRowModelCopyWith<PnlDetailRowModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PnlDetailRowModelCopyWith<$Res> {
  factory $PnlDetailRowModelCopyWith(
          PnlDetailRowModel value, $Res Function(PnlDetailRowModel) then) =
      _$PnlDetailRowModelCopyWithImpl<$Res, PnlDetailRowModel>;
  @useResult
  $Res call(
      {String section,
      @JsonKey(name: 'section_order') int sectionOrder,
      @JsonKey(name: 'account_code') String accountCode,
      @JsonKey(name: 'account_name') String accountName,
      double amount});
}

/// @nodoc
class _$PnlDetailRowModelCopyWithImpl<$Res, $Val extends PnlDetailRowModel>
    implements $PnlDetailRowModelCopyWith<$Res> {
  _$PnlDetailRowModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PnlDetailRowModel
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
abstract class _$$PnlDetailRowModelImplCopyWith<$Res>
    implements $PnlDetailRowModelCopyWith<$Res> {
  factory _$$PnlDetailRowModelImplCopyWith(_$PnlDetailRowModelImpl value,
          $Res Function(_$PnlDetailRowModelImpl) then) =
      __$$PnlDetailRowModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String section,
      @JsonKey(name: 'section_order') int sectionOrder,
      @JsonKey(name: 'account_code') String accountCode,
      @JsonKey(name: 'account_name') String accountName,
      double amount});
}

/// @nodoc
class __$$PnlDetailRowModelImplCopyWithImpl<$Res>
    extends _$PnlDetailRowModelCopyWithImpl<$Res, _$PnlDetailRowModelImpl>
    implements _$$PnlDetailRowModelImplCopyWith<$Res> {
  __$$PnlDetailRowModelImplCopyWithImpl(_$PnlDetailRowModelImpl _value,
      $Res Function(_$PnlDetailRowModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PnlDetailRowModel
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
    return _then(_$PnlDetailRowModelImpl(
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
@JsonSerializable()
class _$PnlDetailRowModelImpl implements _PnlDetailRowModel {
  const _$PnlDetailRowModelImpl(
      {this.section = '',
      @JsonKey(name: 'section_order') this.sectionOrder = 0,
      @JsonKey(name: 'account_code') this.accountCode = '',
      @JsonKey(name: 'account_name') this.accountName = '',
      this.amount = 0});

  factory _$PnlDetailRowModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PnlDetailRowModelImplFromJson(json);

  @override
  @JsonKey()
  final String section;
  @override
  @JsonKey(name: 'section_order')
  final int sectionOrder;
  @override
  @JsonKey(name: 'account_code')
  final String accountCode;
  @override
  @JsonKey(name: 'account_name')
  final String accountName;
  @override
  @JsonKey()
  final double amount;

  @override
  String toString() {
    return 'PnlDetailRowModel(section: $section, sectionOrder: $sectionOrder, accountCode: $accountCode, accountName: $accountName, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PnlDetailRowModelImpl &&
            (identical(other.section, section) || other.section == section) &&
            (identical(other.sectionOrder, sectionOrder) ||
                other.sectionOrder == sectionOrder) &&
            (identical(other.accountCode, accountCode) ||
                other.accountCode == accountCode) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, section, sectionOrder, accountCode, accountName, amount);

  /// Create a copy of PnlDetailRowModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PnlDetailRowModelImplCopyWith<_$PnlDetailRowModelImpl> get copyWith =>
      __$$PnlDetailRowModelImplCopyWithImpl<_$PnlDetailRowModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PnlDetailRowModelImplToJson(
      this,
    );
  }
}

abstract class _PnlDetailRowModel implements PnlDetailRowModel {
  const factory _PnlDetailRowModel(
      {final String section,
      @JsonKey(name: 'section_order') final int sectionOrder,
      @JsonKey(name: 'account_code') final String accountCode,
      @JsonKey(name: 'account_name') final String accountName,
      final double amount}) = _$PnlDetailRowModelImpl;

  factory _PnlDetailRowModel.fromJson(Map<String, dynamic> json) =
      _$PnlDetailRowModelImpl.fromJson;

  @override
  String get section;
  @override
  @JsonKey(name: 'section_order')
  int get sectionOrder;
  @override
  @JsonKey(name: 'account_code')
  String get accountCode;
  @override
  @JsonKey(name: 'account_name')
  String get accountName;
  @override
  double get amount;

  /// Create a copy of PnlDetailRowModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PnlDetailRowModelImplCopyWith<_$PnlDetailRowModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DailyPnlModel {
  DateTime get date => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;
  double get cogs => throw _privateConstructorUsedError;
  double get opex => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_income')
  double get netIncome => throw _privateConstructorUsedError;

  /// Create a copy of DailyPnlModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyPnlModelCopyWith<DailyPnlModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyPnlModelCopyWith<$Res> {
  factory $DailyPnlModelCopyWith(
          DailyPnlModel value, $Res Function(DailyPnlModel) then) =
      _$DailyPnlModelCopyWithImpl<$Res, DailyPnlModel>;
  @useResult
  $Res call(
      {DateTime date,
      double revenue,
      double cogs,
      double opex,
      @JsonKey(name: 'net_income') double netIncome});
}

/// @nodoc
class _$DailyPnlModelCopyWithImpl<$Res, $Val extends DailyPnlModel>
    implements $DailyPnlModelCopyWith<$Res> {
  _$DailyPnlModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyPnlModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? revenue = null,
    Object? cogs = null,
    Object? opex = null,
    Object? netIncome = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as double,
      cogs: null == cogs
          ? _value.cogs
          : cogs // ignore: cast_nullable_to_non_nullable
              as double,
      opex: null == opex
          ? _value.opex
          : opex // ignore: cast_nullable_to_non_nullable
              as double,
      netIncome: null == netIncome
          ? _value.netIncome
          : netIncome // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyPnlModelImplCopyWith<$Res>
    implements $DailyPnlModelCopyWith<$Res> {
  factory _$$DailyPnlModelImplCopyWith(
          _$DailyPnlModelImpl value, $Res Function(_$DailyPnlModelImpl) then) =
      __$$DailyPnlModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      double revenue,
      double cogs,
      double opex,
      @JsonKey(name: 'net_income') double netIncome});
}

/// @nodoc
class __$$DailyPnlModelImplCopyWithImpl<$Res>
    extends _$DailyPnlModelCopyWithImpl<$Res, _$DailyPnlModelImpl>
    implements _$$DailyPnlModelImplCopyWith<$Res> {
  __$$DailyPnlModelImplCopyWithImpl(
      _$DailyPnlModelImpl _value, $Res Function(_$DailyPnlModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyPnlModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? revenue = null,
    Object? cogs = null,
    Object? opex = null,
    Object? netIncome = null,
  }) {
    return _then(_$DailyPnlModelImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as double,
      cogs: null == cogs
          ? _value.cogs
          : cogs // ignore: cast_nullable_to_non_nullable
              as double,
      opex: null == opex
          ? _value.opex
          : opex // ignore: cast_nullable_to_non_nullable
              as double,
      netIncome: null == netIncome
          ? _value.netIncome
          : netIncome // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$DailyPnlModelImpl implements _DailyPnlModel {
  const _$DailyPnlModelImpl(
      {required this.date,
      this.revenue = 0,
      this.cogs = 0,
      this.opex = 0,
      @JsonKey(name: 'net_income') this.netIncome = 0});

  @override
  final DateTime date;
  @override
  @JsonKey()
  final double revenue;
  @override
  @JsonKey()
  final double cogs;
  @override
  @JsonKey()
  final double opex;
  @override
  @JsonKey(name: 'net_income')
  final double netIncome;

  @override
  String toString() {
    return 'DailyPnlModel(date: $date, revenue: $revenue, cogs: $cogs, opex: $opex, netIncome: $netIncome)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyPnlModelImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.revenue, revenue) || other.revenue == revenue) &&
            (identical(other.cogs, cogs) || other.cogs == cogs) &&
            (identical(other.opex, opex) || other.opex == opex) &&
            (identical(other.netIncome, netIncome) ||
                other.netIncome == netIncome));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, date, revenue, cogs, opex, netIncome);

  /// Create a copy of DailyPnlModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyPnlModelImplCopyWith<_$DailyPnlModelImpl> get copyWith =>
      __$$DailyPnlModelImplCopyWithImpl<_$DailyPnlModelImpl>(this, _$identity);
}

abstract class _DailyPnlModel implements DailyPnlModel {
  const factory _DailyPnlModel(
          {required final DateTime date,
          final double revenue,
          final double cogs,
          final double opex,
          @JsonKey(name: 'net_income') final double netIncome}) =
      _$DailyPnlModelImpl;

  @override
  DateTime get date;
  @override
  double get revenue;
  @override
  double get cogs;
  @override
  double get opex;
  @override
  @JsonKey(name: 'net_income')
  double get netIncome;

  /// Create a copy of DailyPnlModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyPnlModelImplCopyWith<_$DailyPnlModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
