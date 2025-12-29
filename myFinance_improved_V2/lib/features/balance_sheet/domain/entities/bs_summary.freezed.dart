// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bs_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BsSummary {
// Current amounts
  double get totalAssets => throw _privateConstructorUsedError;
  double get currentAssets => throw _privateConstructorUsedError;
  double get nonCurrentAssets => throw _privateConstructorUsedError;
  double get totalLiabilities => throw _privateConstructorUsedError;
  double get currentLiabilities => throw _privateConstructorUsedError;
  double get nonCurrentLiabilities => throw _privateConstructorUsedError;
  double get totalEquity =>
      throw _privateConstructorUsedError; // Balance check (should be 0 if balanced)
  double get balanceCheck =>
      throw _privateConstructorUsedError; // Previous period (nullable)
  double? get prevTotalAssets => throw _privateConstructorUsedError;
  double? get prevTotalEquity =>
      throw _privateConstructorUsedError; // Change percentages (nullable)
  double? get assetsChangePct => throw _privateConstructorUsedError;
  double? get equityChangePct => throw _privateConstructorUsedError;

  /// Create a copy of BsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BsSummaryCopyWith<BsSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BsSummaryCopyWith<$Res> {
  factory $BsSummaryCopyWith(BsSummary value, $Res Function(BsSummary) then) =
      _$BsSummaryCopyWithImpl<$Res, BsSummary>;
  @useResult
  $Res call(
      {double totalAssets,
      double currentAssets,
      double nonCurrentAssets,
      double totalLiabilities,
      double currentLiabilities,
      double nonCurrentLiabilities,
      double totalEquity,
      double balanceCheck,
      double? prevTotalAssets,
      double? prevTotalEquity,
      double? assetsChangePct,
      double? equityChangePct});
}

/// @nodoc
class _$BsSummaryCopyWithImpl<$Res, $Val extends BsSummary>
    implements $BsSummaryCopyWith<$Res> {
  _$BsSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BsSummary
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
abstract class _$$BsSummaryImplCopyWith<$Res>
    implements $BsSummaryCopyWith<$Res> {
  factory _$$BsSummaryImplCopyWith(
          _$BsSummaryImpl value, $Res Function(_$BsSummaryImpl) then) =
      __$$BsSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double totalAssets,
      double currentAssets,
      double nonCurrentAssets,
      double totalLiabilities,
      double currentLiabilities,
      double nonCurrentLiabilities,
      double totalEquity,
      double balanceCheck,
      double? prevTotalAssets,
      double? prevTotalEquity,
      double? assetsChangePct,
      double? equityChangePct});
}

/// @nodoc
class __$$BsSummaryImplCopyWithImpl<$Res>
    extends _$BsSummaryCopyWithImpl<$Res, _$BsSummaryImpl>
    implements _$$BsSummaryImplCopyWith<$Res> {
  __$$BsSummaryImplCopyWithImpl(
      _$BsSummaryImpl _value, $Res Function(_$BsSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of BsSummary
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
    return _then(_$BsSummaryImpl(
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

class _$BsSummaryImpl extends _BsSummary {
  const _$BsSummaryImpl(
      {this.totalAssets = 0,
      this.currentAssets = 0,
      this.nonCurrentAssets = 0,
      this.totalLiabilities = 0,
      this.currentLiabilities = 0,
      this.nonCurrentLiabilities = 0,
      this.totalEquity = 0,
      this.balanceCheck = 0,
      this.prevTotalAssets,
      this.prevTotalEquity,
      this.assetsChangePct,
      this.equityChangePct})
      : super._();

// Current amounts
  @override
  @JsonKey()
  final double totalAssets;
  @override
  @JsonKey()
  final double currentAssets;
  @override
  @JsonKey()
  final double nonCurrentAssets;
  @override
  @JsonKey()
  final double totalLiabilities;
  @override
  @JsonKey()
  final double currentLiabilities;
  @override
  @JsonKey()
  final double nonCurrentLiabilities;
  @override
  @JsonKey()
  final double totalEquity;
// Balance check (should be 0 if balanced)
  @override
  @JsonKey()
  final double balanceCheck;
// Previous period (nullable)
  @override
  final double? prevTotalAssets;
  @override
  final double? prevTotalEquity;
// Change percentages (nullable)
  @override
  final double? assetsChangePct;
  @override
  final double? equityChangePct;

  @override
  String toString() {
    return 'BsSummary(totalAssets: $totalAssets, currentAssets: $currentAssets, nonCurrentAssets: $nonCurrentAssets, totalLiabilities: $totalLiabilities, currentLiabilities: $currentLiabilities, nonCurrentLiabilities: $nonCurrentLiabilities, totalEquity: $totalEquity, balanceCheck: $balanceCheck, prevTotalAssets: $prevTotalAssets, prevTotalEquity: $prevTotalEquity, assetsChangePct: $assetsChangePct, equityChangePct: $equityChangePct)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BsSummaryImpl &&
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

  /// Create a copy of BsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BsSummaryImplCopyWith<_$BsSummaryImpl> get copyWith =>
      __$$BsSummaryImplCopyWithImpl<_$BsSummaryImpl>(this, _$identity);
}

abstract class _BsSummary extends BsSummary {
  const factory _BsSummary(
      {final double totalAssets,
      final double currentAssets,
      final double nonCurrentAssets,
      final double totalLiabilities,
      final double currentLiabilities,
      final double nonCurrentLiabilities,
      final double totalEquity,
      final double balanceCheck,
      final double? prevTotalAssets,
      final double? prevTotalEquity,
      final double? assetsChangePct,
      final double? equityChangePct}) = _$BsSummaryImpl;
  const _BsSummary._() : super._();

// Current amounts
  @override
  double get totalAssets;
  @override
  double get currentAssets;
  @override
  double get nonCurrentAssets;
  @override
  double get totalLiabilities;
  @override
  double get currentLiabilities;
  @override
  double get nonCurrentLiabilities;
  @override
  double get totalEquity; // Balance check (should be 0 if balanced)
  @override
  double get balanceCheck; // Previous period (nullable)
  @override
  double? get prevTotalAssets;
  @override
  double? get prevTotalEquity; // Change percentages (nullable)
  @override
  double? get assetsChangePct;
  @override
  double? get equityChangePct;

  /// Create a copy of BsSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BsSummaryImplCopyWith<_$BsSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BsDetailRow {
  String get section => throw _privateConstructorUsedError;
  int get sectionOrder => throw _privateConstructorUsedError;
  String get accountCode => throw _privateConstructorUsedError;
  String get accountName => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;

  /// Create a copy of BsDetailRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BsDetailRowCopyWith<BsDetailRow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BsDetailRowCopyWith<$Res> {
  factory $BsDetailRowCopyWith(
          BsDetailRow value, $Res Function(BsDetailRow) then) =
      _$BsDetailRowCopyWithImpl<$Res, BsDetailRow>;
  @useResult
  $Res call(
      {String section,
      int sectionOrder,
      String accountCode,
      String accountName,
      double balance});
}

/// @nodoc
class _$BsDetailRowCopyWithImpl<$Res, $Val extends BsDetailRow>
    implements $BsDetailRowCopyWith<$Res> {
  _$BsDetailRowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BsDetailRow
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
abstract class _$$BsDetailRowImplCopyWith<$Res>
    implements $BsDetailRowCopyWith<$Res> {
  factory _$$BsDetailRowImplCopyWith(
          _$BsDetailRowImpl value, $Res Function(_$BsDetailRowImpl) then) =
      __$$BsDetailRowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String section,
      int sectionOrder,
      String accountCode,
      String accountName,
      double balance});
}

/// @nodoc
class __$$BsDetailRowImplCopyWithImpl<$Res>
    extends _$BsDetailRowCopyWithImpl<$Res, _$BsDetailRowImpl>
    implements _$$BsDetailRowImplCopyWith<$Res> {
  __$$BsDetailRowImplCopyWithImpl(
      _$BsDetailRowImpl _value, $Res Function(_$BsDetailRowImpl) _then)
      : super(_value, _then);

  /// Create a copy of BsDetailRow
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
    return _then(_$BsDetailRowImpl(
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

class _$BsDetailRowImpl implements _BsDetailRow {
  const _$BsDetailRowImpl(
      {this.section = '',
      this.sectionOrder = 0,
      this.accountCode = '',
      this.accountName = '',
      this.balance = 0});

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
  final double balance;

  @override
  String toString() {
    return 'BsDetailRow(section: $section, sectionOrder: $sectionOrder, accountCode: $accountCode, accountName: $accountName, balance: $balance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BsDetailRowImpl &&
            (identical(other.section, section) || other.section == section) &&
            (identical(other.sectionOrder, sectionOrder) ||
                other.sectionOrder == sectionOrder) &&
            (identical(other.accountCode, accountCode) ||
                other.accountCode == accountCode) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.balance, balance) || other.balance == balance));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, section, sectionOrder, accountCode, accountName, balance);

  /// Create a copy of BsDetailRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BsDetailRowImplCopyWith<_$BsDetailRowImpl> get copyWith =>
      __$$BsDetailRowImplCopyWithImpl<_$BsDetailRowImpl>(this, _$identity);
}

abstract class _BsDetailRow implements BsDetailRow {
  const factory _BsDetailRow(
      {final String section,
      final int sectionOrder,
      final String accountCode,
      final String accountName,
      final double balance}) = _$BsDetailRowImpl;

  @override
  String get section;
  @override
  int get sectionOrder;
  @override
  String get accountCode;
  @override
  String get accountName;
  @override
  double get balance;

  /// Create a copy of BsDetailRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BsDetailRowImplCopyWith<_$BsDetailRowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
