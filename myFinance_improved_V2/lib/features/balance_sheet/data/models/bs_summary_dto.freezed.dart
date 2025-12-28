// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bs_summary_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BsSummaryModel _$BsSummaryModelFromJson(Map<String, dynamic> json) {
  return _BsSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$BsSummaryModel {
// Current amounts
  @JsonKey(name: 'total_assets')
  double get totalAssets => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_assets')
  double get currentAssets => throw _privateConstructorUsedError;
  @JsonKey(name: 'non_current_assets')
  double get nonCurrentAssets => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_liabilities')
  double get totalLiabilities => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_liabilities')
  double get currentLiabilities => throw _privateConstructorUsedError;
  @JsonKey(name: 'non_current_liabilities')
  double get nonCurrentLiabilities => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_equity')
  double get totalEquity =>
      throw _privateConstructorUsedError; // Balance check (should be 0 if balanced)
  @JsonKey(name: 'balance_check')
  double get balanceCheck =>
      throw _privateConstructorUsedError; // Previous period (nullable)
  @JsonKey(name: 'prev_total_assets')
  double? get prevTotalAssets => throw _privateConstructorUsedError;
  @JsonKey(name: 'prev_total_equity')
  double? get prevTotalEquity =>
      throw _privateConstructorUsedError; // Change percentages (nullable)
  @JsonKey(name: 'assets_change_pct')
  double? get assetsChangePct => throw _privateConstructorUsedError;
  @JsonKey(name: 'equity_change_pct')
  double? get equityChangePct => throw _privateConstructorUsedError;

  /// Serializes this BsSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BsSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BsSummaryModelCopyWith<BsSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BsSummaryModelCopyWith<$Res> {
  factory $BsSummaryModelCopyWith(
          BsSummaryModel value, $Res Function(BsSummaryModel) then) =
      _$BsSummaryModelCopyWithImpl<$Res, BsSummaryModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_assets') double totalAssets,
      @JsonKey(name: 'current_assets') double currentAssets,
      @JsonKey(name: 'non_current_assets') double nonCurrentAssets,
      @JsonKey(name: 'total_liabilities') double totalLiabilities,
      @JsonKey(name: 'current_liabilities') double currentLiabilities,
      @JsonKey(name: 'non_current_liabilities') double nonCurrentLiabilities,
      @JsonKey(name: 'total_equity') double totalEquity,
      @JsonKey(name: 'balance_check') double balanceCheck,
      @JsonKey(name: 'prev_total_assets') double? prevTotalAssets,
      @JsonKey(name: 'prev_total_equity') double? prevTotalEquity,
      @JsonKey(name: 'assets_change_pct') double? assetsChangePct,
      @JsonKey(name: 'equity_change_pct') double? equityChangePct});
}

/// @nodoc
class _$BsSummaryModelCopyWithImpl<$Res, $Val extends BsSummaryModel>
    implements $BsSummaryModelCopyWith<$Res> {
  _$BsSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BsSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAssets = null,
    Object? currentAssets = null,
    Object? nonCurrentAssets = null,
    Object? totalLiabilities = null,
    Object? currentLiabilities = null,
    Object? nonCurrentLiabilities = null,
    Object? totalEquity = null,
    Object? balanceCheck = null,
    Object? prevTotalAssets = freezed,
    Object? prevTotalEquity = freezed,
    Object? assetsChangePct = freezed,
    Object? equityChangePct = freezed,
  }) {
    return _then(_value.copyWith(
      totalAssets: null == totalAssets
          ? _value.totalAssets
          : totalAssets // ignore: cast_nullable_to_non_nullable
              as double,
      currentAssets: null == currentAssets
          ? _value.currentAssets
          : currentAssets // ignore: cast_nullable_to_non_nullable
              as double,
      nonCurrentAssets: null == nonCurrentAssets
          ? _value.nonCurrentAssets
          : nonCurrentAssets // ignore: cast_nullable_to_non_nullable
              as double,
      totalLiabilities: null == totalLiabilities
          ? _value.totalLiabilities
          : totalLiabilities // ignore: cast_nullable_to_non_nullable
              as double,
      currentLiabilities: null == currentLiabilities
          ? _value.currentLiabilities
          : currentLiabilities // ignore: cast_nullable_to_non_nullable
              as double,
      nonCurrentLiabilities: null == nonCurrentLiabilities
          ? _value.nonCurrentLiabilities
          : nonCurrentLiabilities // ignore: cast_nullable_to_non_nullable
              as double,
      totalEquity: null == totalEquity
          ? _value.totalEquity
          : totalEquity // ignore: cast_nullable_to_non_nullable
              as double,
      balanceCheck: null == balanceCheck
          ? _value.balanceCheck
          : balanceCheck // ignore: cast_nullable_to_non_nullable
              as double,
      prevTotalAssets: freezed == prevTotalAssets
          ? _value.prevTotalAssets
          : prevTotalAssets // ignore: cast_nullable_to_non_nullable
              as double?,
      prevTotalEquity: freezed == prevTotalEquity
          ? _value.prevTotalEquity
          : prevTotalEquity // ignore: cast_nullable_to_non_nullable
              as double?,
      assetsChangePct: freezed == assetsChangePct
          ? _value.assetsChangePct
          : assetsChangePct // ignore: cast_nullable_to_non_nullable
              as double?,
      equityChangePct: freezed == equityChangePct
          ? _value.equityChangePct
          : equityChangePct // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BsSummaryModelImplCopyWith<$Res>
    implements $BsSummaryModelCopyWith<$Res> {
  factory _$$BsSummaryModelImplCopyWith(_$BsSummaryModelImpl value,
          $Res Function(_$BsSummaryModelImpl) then) =
      __$$BsSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_assets') double totalAssets,
      @JsonKey(name: 'current_assets') double currentAssets,
      @JsonKey(name: 'non_current_assets') double nonCurrentAssets,
      @JsonKey(name: 'total_liabilities') double totalLiabilities,
      @JsonKey(name: 'current_liabilities') double currentLiabilities,
      @JsonKey(name: 'non_current_liabilities') double nonCurrentLiabilities,
      @JsonKey(name: 'total_equity') double totalEquity,
      @JsonKey(name: 'balance_check') double balanceCheck,
      @JsonKey(name: 'prev_total_assets') double? prevTotalAssets,
      @JsonKey(name: 'prev_total_equity') double? prevTotalEquity,
      @JsonKey(name: 'assets_change_pct') double? assetsChangePct,
      @JsonKey(name: 'equity_change_pct') double? equityChangePct});
}

/// @nodoc
class __$$BsSummaryModelImplCopyWithImpl<$Res>
    extends _$BsSummaryModelCopyWithImpl<$Res, _$BsSummaryModelImpl>
    implements _$$BsSummaryModelImplCopyWith<$Res> {
  __$$BsSummaryModelImplCopyWithImpl(
      _$BsSummaryModelImpl _value, $Res Function(_$BsSummaryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BsSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAssets = null,
    Object? currentAssets = null,
    Object? nonCurrentAssets = null,
    Object? totalLiabilities = null,
    Object? currentLiabilities = null,
    Object? nonCurrentLiabilities = null,
    Object? totalEquity = null,
    Object? balanceCheck = null,
    Object? prevTotalAssets = freezed,
    Object? prevTotalEquity = freezed,
    Object? assetsChangePct = freezed,
    Object? equityChangePct = freezed,
  }) {
    return _then(_$BsSummaryModelImpl(
      totalAssets: null == totalAssets
          ? _value.totalAssets
          : totalAssets // ignore: cast_nullable_to_non_nullable
              as double,
      currentAssets: null == currentAssets
          ? _value.currentAssets
          : currentAssets // ignore: cast_nullable_to_non_nullable
              as double,
      nonCurrentAssets: null == nonCurrentAssets
          ? _value.nonCurrentAssets
          : nonCurrentAssets // ignore: cast_nullable_to_non_nullable
              as double,
      totalLiabilities: null == totalLiabilities
          ? _value.totalLiabilities
          : totalLiabilities // ignore: cast_nullable_to_non_nullable
              as double,
      currentLiabilities: null == currentLiabilities
          ? _value.currentLiabilities
          : currentLiabilities // ignore: cast_nullable_to_non_nullable
              as double,
      nonCurrentLiabilities: null == nonCurrentLiabilities
          ? _value.nonCurrentLiabilities
          : nonCurrentLiabilities // ignore: cast_nullable_to_non_nullable
              as double,
      totalEquity: null == totalEquity
          ? _value.totalEquity
          : totalEquity // ignore: cast_nullable_to_non_nullable
              as double,
      balanceCheck: null == balanceCheck
          ? _value.balanceCheck
          : balanceCheck // ignore: cast_nullable_to_non_nullable
              as double,
      prevTotalAssets: freezed == prevTotalAssets
          ? _value.prevTotalAssets
          : prevTotalAssets // ignore: cast_nullable_to_non_nullable
              as double?,
      prevTotalEquity: freezed == prevTotalEquity
          ? _value.prevTotalEquity
          : prevTotalEquity // ignore: cast_nullable_to_non_nullable
              as double?,
      assetsChangePct: freezed == assetsChangePct
          ? _value.assetsChangePct
          : assetsChangePct // ignore: cast_nullable_to_non_nullable
              as double?,
      equityChangePct: freezed == equityChangePct
          ? _value.equityChangePct
          : equityChangePct // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BsSummaryModelImpl extends _BsSummaryModel {
  const _$BsSummaryModelImpl(
      {@JsonKey(name: 'total_assets') this.totalAssets = 0,
      @JsonKey(name: 'current_assets') this.currentAssets = 0,
      @JsonKey(name: 'non_current_assets') this.nonCurrentAssets = 0,
      @JsonKey(name: 'total_liabilities') this.totalLiabilities = 0,
      @JsonKey(name: 'current_liabilities') this.currentLiabilities = 0,
      @JsonKey(name: 'non_current_liabilities') this.nonCurrentLiabilities = 0,
      @JsonKey(name: 'total_equity') this.totalEquity = 0,
      @JsonKey(name: 'balance_check') this.balanceCheck = 0,
      @JsonKey(name: 'prev_total_assets') this.prevTotalAssets,
      @JsonKey(name: 'prev_total_equity') this.prevTotalEquity,
      @JsonKey(name: 'assets_change_pct') this.assetsChangePct,
      @JsonKey(name: 'equity_change_pct') this.equityChangePct})
      : super._();

  factory _$BsSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BsSummaryModelImplFromJson(json);

// Current amounts
  @override
  @JsonKey(name: 'total_assets')
  final double totalAssets;
  @override
  @JsonKey(name: 'current_assets')
  final double currentAssets;
  @override
  @JsonKey(name: 'non_current_assets')
  final double nonCurrentAssets;
  @override
  @JsonKey(name: 'total_liabilities')
  final double totalLiabilities;
  @override
  @JsonKey(name: 'current_liabilities')
  final double currentLiabilities;
  @override
  @JsonKey(name: 'non_current_liabilities')
  final double nonCurrentLiabilities;
  @override
  @JsonKey(name: 'total_equity')
  final double totalEquity;
// Balance check (should be 0 if balanced)
  @override
  @JsonKey(name: 'balance_check')
  final double balanceCheck;
// Previous period (nullable)
  @override
  @JsonKey(name: 'prev_total_assets')
  final double? prevTotalAssets;
  @override
  @JsonKey(name: 'prev_total_equity')
  final double? prevTotalEquity;
// Change percentages (nullable)
  @override
  @JsonKey(name: 'assets_change_pct')
  final double? assetsChangePct;
  @override
  @JsonKey(name: 'equity_change_pct')
  final double? equityChangePct;

  @override
  String toString() {
    return 'BsSummaryModel(totalAssets: $totalAssets, currentAssets: $currentAssets, nonCurrentAssets: $nonCurrentAssets, totalLiabilities: $totalLiabilities, currentLiabilities: $currentLiabilities, nonCurrentLiabilities: $nonCurrentLiabilities, totalEquity: $totalEquity, balanceCheck: $balanceCheck, prevTotalAssets: $prevTotalAssets, prevTotalEquity: $prevTotalEquity, assetsChangePct: $assetsChangePct, equityChangePct: $equityChangePct)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BsSummaryModelImpl &&
            (identical(other.totalAssets, totalAssets) ||
                other.totalAssets == totalAssets) &&
            (identical(other.currentAssets, currentAssets) ||
                other.currentAssets == currentAssets) &&
            (identical(other.nonCurrentAssets, nonCurrentAssets) ||
                other.nonCurrentAssets == nonCurrentAssets) &&
            (identical(other.totalLiabilities, totalLiabilities) ||
                other.totalLiabilities == totalLiabilities) &&
            (identical(other.currentLiabilities, currentLiabilities) ||
                other.currentLiabilities == currentLiabilities) &&
            (identical(other.nonCurrentLiabilities, nonCurrentLiabilities) ||
                other.nonCurrentLiabilities == nonCurrentLiabilities) &&
            (identical(other.totalEquity, totalEquity) ||
                other.totalEquity == totalEquity) &&
            (identical(other.balanceCheck, balanceCheck) ||
                other.balanceCheck == balanceCheck) &&
            (identical(other.prevTotalAssets, prevTotalAssets) ||
                other.prevTotalAssets == prevTotalAssets) &&
            (identical(other.prevTotalEquity, prevTotalEquity) ||
                other.prevTotalEquity == prevTotalEquity) &&
            (identical(other.assetsChangePct, assetsChangePct) ||
                other.assetsChangePct == assetsChangePct) &&
            (identical(other.equityChangePct, equityChangePct) ||
                other.equityChangePct == equityChangePct));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalAssets,
      currentAssets,
      nonCurrentAssets,
      totalLiabilities,
      currentLiabilities,
      nonCurrentLiabilities,
      totalEquity,
      balanceCheck,
      prevTotalAssets,
      prevTotalEquity,
      assetsChangePct,
      equityChangePct);

  /// Create a copy of BsSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BsSummaryModelImplCopyWith<_$BsSummaryModelImpl> get copyWith =>
      __$$BsSummaryModelImplCopyWithImpl<_$BsSummaryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BsSummaryModelImplToJson(
      this,
    );
  }
}

abstract class _BsSummaryModel extends BsSummaryModel {
  const factory _BsSummaryModel(
          {@JsonKey(name: 'total_assets') final double totalAssets,
          @JsonKey(name: 'current_assets') final double currentAssets,
          @JsonKey(name: 'non_current_assets') final double nonCurrentAssets,
          @JsonKey(name: 'total_liabilities') final double totalLiabilities,
          @JsonKey(name: 'current_liabilities') final double currentLiabilities,
          @JsonKey(name: 'non_current_liabilities')
          final double nonCurrentLiabilities,
          @JsonKey(name: 'total_equity') final double totalEquity,
          @JsonKey(name: 'balance_check') final double balanceCheck,
          @JsonKey(name: 'prev_total_assets') final double? prevTotalAssets,
          @JsonKey(name: 'prev_total_equity') final double? prevTotalEquity,
          @JsonKey(name: 'assets_change_pct') final double? assetsChangePct,
          @JsonKey(name: 'equity_change_pct') final double? equityChangePct}) =
      _$BsSummaryModelImpl;
  const _BsSummaryModel._() : super._();

  factory _BsSummaryModel.fromJson(Map<String, dynamic> json) =
      _$BsSummaryModelImpl.fromJson;

// Current amounts
  @override
  @JsonKey(name: 'total_assets')
  double get totalAssets;
  @override
  @JsonKey(name: 'current_assets')
  double get currentAssets;
  @override
  @JsonKey(name: 'non_current_assets')
  double get nonCurrentAssets;
  @override
  @JsonKey(name: 'total_liabilities')
  double get totalLiabilities;
  @override
  @JsonKey(name: 'current_liabilities')
  double get currentLiabilities;
  @override
  @JsonKey(name: 'non_current_liabilities')
  double get nonCurrentLiabilities;
  @override
  @JsonKey(name: 'total_equity')
  double get totalEquity; // Balance check (should be 0 if balanced)
  @override
  @JsonKey(name: 'balance_check')
  double get balanceCheck; // Previous period (nullable)
  @override
  @JsonKey(name: 'prev_total_assets')
  double? get prevTotalAssets;
  @override
  @JsonKey(name: 'prev_total_equity')
  double? get prevTotalEquity; // Change percentages (nullable)
  @override
  @JsonKey(name: 'assets_change_pct')
  double? get assetsChangePct;
  @override
  @JsonKey(name: 'equity_change_pct')
  double? get equityChangePct;

  /// Create a copy of BsSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BsSummaryModelImplCopyWith<_$BsSummaryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BsDetailRowModel _$BsDetailRowModelFromJson(Map<String, dynamic> json) {
  return _BsDetailRowModel.fromJson(json);
}

/// @nodoc
mixin _$BsDetailRowModel {
  String get section => throw _privateConstructorUsedError;
  @JsonKey(name: 'section_order')
  int get sectionOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_code')
  String get accountCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_name')
  String get accountName => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;

  /// Serializes this BsDetailRowModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BsDetailRowModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BsDetailRowModelCopyWith<BsDetailRowModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BsDetailRowModelCopyWith<$Res> {
  factory $BsDetailRowModelCopyWith(
          BsDetailRowModel value, $Res Function(BsDetailRowModel) then) =
      _$BsDetailRowModelCopyWithImpl<$Res, BsDetailRowModel>;
  @useResult
  $Res call(
      {String section,
      @JsonKey(name: 'section_order') int sectionOrder,
      @JsonKey(name: 'account_code') String accountCode,
      @JsonKey(name: 'account_name') String accountName,
      double balance});
}

/// @nodoc
class _$BsDetailRowModelCopyWithImpl<$Res, $Val extends BsDetailRowModel>
    implements $BsDetailRowModelCopyWith<$Res> {
  _$BsDetailRowModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BsDetailRowModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? section = null,
    Object? sectionOrder = null,
    Object? accountCode = null,
    Object? accountName = null,
    Object? balance = null,
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
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BsDetailRowModelImplCopyWith<$Res>
    implements $BsDetailRowModelCopyWith<$Res> {
  factory _$$BsDetailRowModelImplCopyWith(_$BsDetailRowModelImpl value,
          $Res Function(_$BsDetailRowModelImpl) then) =
      __$$BsDetailRowModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String section,
      @JsonKey(name: 'section_order') int sectionOrder,
      @JsonKey(name: 'account_code') String accountCode,
      @JsonKey(name: 'account_name') String accountName,
      double balance});
}

/// @nodoc
class __$$BsDetailRowModelImplCopyWithImpl<$Res>
    extends _$BsDetailRowModelCopyWithImpl<$Res, _$BsDetailRowModelImpl>
    implements _$$BsDetailRowModelImplCopyWith<$Res> {
  __$$BsDetailRowModelImplCopyWithImpl(_$BsDetailRowModelImpl _value,
      $Res Function(_$BsDetailRowModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BsDetailRowModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? section = null,
    Object? sectionOrder = null,
    Object? accountCode = null,
    Object? accountName = null,
    Object? balance = null,
  }) {
    return _then(_$BsDetailRowModelImpl(
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
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BsDetailRowModelImpl implements _BsDetailRowModel {
  const _$BsDetailRowModelImpl(
      {this.section = '',
      @JsonKey(name: 'section_order') this.sectionOrder = 0,
      @JsonKey(name: 'account_code') this.accountCode = '',
      @JsonKey(name: 'account_name') this.accountName = '',
      this.balance = 0});

  factory _$BsDetailRowModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BsDetailRowModelImplFromJson(json);

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
  final double balance;

  @override
  String toString() {
    return 'BsDetailRowModel(section: $section, sectionOrder: $sectionOrder, accountCode: $accountCode, accountName: $accountName, balance: $balance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BsDetailRowModelImpl &&
            (identical(other.section, section) || other.section == section) &&
            (identical(other.sectionOrder, sectionOrder) ||
                other.sectionOrder == sectionOrder) &&
            (identical(other.accountCode, accountCode) ||
                other.accountCode == accountCode) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.balance, balance) || other.balance == balance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, section, sectionOrder, accountCode, accountName, balance);

  /// Create a copy of BsDetailRowModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BsDetailRowModelImplCopyWith<_$BsDetailRowModelImpl> get copyWith =>
      __$$BsDetailRowModelImplCopyWithImpl<_$BsDetailRowModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BsDetailRowModelImplToJson(
      this,
    );
  }
}

abstract class _BsDetailRowModel implements BsDetailRowModel {
  const factory _BsDetailRowModel(
      {final String section,
      @JsonKey(name: 'section_order') final int sectionOrder,
      @JsonKey(name: 'account_code') final String accountCode,
      @JsonKey(name: 'account_name') final String accountName,
      final double balance}) = _$BsDetailRowModelImpl;

  factory _BsDetailRowModel.fromJson(Map<String, dynamic> json) =
      _$BsDetailRowModelImpl.fromJson;

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
  double get balance;

  /// Create a copy of BsDetailRowModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BsDetailRowModelImplCopyWith<_$BsDetailRowModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
