// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'balance_sheet_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BalanceSheet _$BalanceSheetFromJson(Map<String, dynamic> json) {
  return _BalanceSheet.fromJson(json);
}

/// @nodoc
mixin _$BalanceSheet {
  String get id => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String get storeId => throw _privateConstructorUsedError;
  DateTime get periodDate => throw _privateConstructorUsedError;
  Assets get assets => throw _privateConstructorUsedError;
  Liabilities get liabilities => throw _privateConstructorUsedError;
  Equity get equity => throw _privateConstructorUsedError;
  double get totalAssets => throw _privateConstructorUsedError;
  double get totalLiabilities => throw _privateConstructorUsedError;
  double get totalEquity => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this BalanceSheet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BalanceSheet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BalanceSheetCopyWith<BalanceSheet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BalanceSheetCopyWith<$Res> {
  factory $BalanceSheetCopyWith(
          BalanceSheet value, $Res Function(BalanceSheet) then) =
      _$BalanceSheetCopyWithImpl<$Res, BalanceSheet>;
  @useResult
  $Res call(
      {String id,
      String companyId,
      String storeId,
      DateTime periodDate,
      Assets assets,
      Liabilities liabilities,
      Equity equity,
      double totalAssets,
      double totalLiabilities,
      double totalEquity,
      DateTime? createdAt,
      DateTime? updatedAt});

  $AssetsCopyWith<$Res> get assets;
  $LiabilitiesCopyWith<$Res> get liabilities;
  $EquityCopyWith<$Res> get equity;
}

/// @nodoc
class _$BalanceSheetCopyWithImpl<$Res, $Val extends BalanceSheet>
    implements $BalanceSheetCopyWith<$Res> {
  _$BalanceSheetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BalanceSheet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? storeId = null,
    Object? periodDate = null,
    Object? assets = null,
    Object? liabilities = null,
    Object? equity = null,
    Object? totalAssets = null,
    Object? totalLiabilities = null,
    Object? totalEquity = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      periodDate: null == periodDate
          ? _value.periodDate
          : periodDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      assets: null == assets
          ? _value.assets
          : assets // ignore: cast_nullable_to_non_nullable
              as Assets,
      liabilities: null == liabilities
          ? _value.liabilities
          : liabilities // ignore: cast_nullable_to_non_nullable
              as Liabilities,
      equity: null == equity
          ? _value.equity
          : equity // ignore: cast_nullable_to_non_nullable
              as Equity,
      totalAssets: null == totalAssets
          ? _value.totalAssets
          : totalAssets // ignore: cast_nullable_to_non_nullable
              as double,
      totalLiabilities: null == totalLiabilities
          ? _value.totalLiabilities
          : totalLiabilities // ignore: cast_nullable_to_non_nullable
              as double,
      totalEquity: null == totalEquity
          ? _value.totalEquity
          : totalEquity // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of BalanceSheet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AssetsCopyWith<$Res> get assets {
    return $AssetsCopyWith<$Res>(_value.assets, (value) {
      return _then(_value.copyWith(assets: value) as $Val);
    });
  }

  /// Create a copy of BalanceSheet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LiabilitiesCopyWith<$Res> get liabilities {
    return $LiabilitiesCopyWith<$Res>(_value.liabilities, (value) {
      return _then(_value.copyWith(liabilities: value) as $Val);
    });
  }

  /// Create a copy of BalanceSheet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EquityCopyWith<$Res> get equity {
    return $EquityCopyWith<$Res>(_value.equity, (value) {
      return _then(_value.copyWith(equity: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BalanceSheetImplCopyWith<$Res>
    implements $BalanceSheetCopyWith<$Res> {
  factory _$$BalanceSheetImplCopyWith(
          _$BalanceSheetImpl value, $Res Function(_$BalanceSheetImpl) then) =
      __$$BalanceSheetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String companyId,
      String storeId,
      DateTime periodDate,
      Assets assets,
      Liabilities liabilities,
      Equity equity,
      double totalAssets,
      double totalLiabilities,
      double totalEquity,
      DateTime? createdAt,
      DateTime? updatedAt});

  @override
  $AssetsCopyWith<$Res> get assets;
  @override
  $LiabilitiesCopyWith<$Res> get liabilities;
  @override
  $EquityCopyWith<$Res> get equity;
}

/// @nodoc
class __$$BalanceSheetImplCopyWithImpl<$Res>
    extends _$BalanceSheetCopyWithImpl<$Res, _$BalanceSheetImpl>
    implements _$$BalanceSheetImplCopyWith<$Res> {
  __$$BalanceSheetImplCopyWithImpl(
      _$BalanceSheetImpl _value, $Res Function(_$BalanceSheetImpl) _then)
      : super(_value, _then);

  /// Create a copy of BalanceSheet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? storeId = null,
    Object? periodDate = null,
    Object? assets = null,
    Object? liabilities = null,
    Object? equity = null,
    Object? totalAssets = null,
    Object? totalLiabilities = null,
    Object? totalEquity = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$BalanceSheetImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      periodDate: null == periodDate
          ? _value.periodDate
          : periodDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      assets: null == assets
          ? _value.assets
          : assets // ignore: cast_nullable_to_non_nullable
              as Assets,
      liabilities: null == liabilities
          ? _value.liabilities
          : liabilities // ignore: cast_nullable_to_non_nullable
              as Liabilities,
      equity: null == equity
          ? _value.equity
          : equity // ignore: cast_nullable_to_non_nullable
              as Equity,
      totalAssets: null == totalAssets
          ? _value.totalAssets
          : totalAssets // ignore: cast_nullable_to_non_nullable
              as double,
      totalLiabilities: null == totalLiabilities
          ? _value.totalLiabilities
          : totalLiabilities // ignore: cast_nullable_to_non_nullable
              as double,
      totalEquity: null == totalEquity
          ? _value.totalEquity
          : totalEquity // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BalanceSheetImpl implements _BalanceSheet {
  const _$BalanceSheetImpl(
      {required this.id,
      required this.companyId,
      required this.storeId,
      required this.periodDate,
      required this.assets,
      required this.liabilities,
      required this.equity,
      required this.totalAssets,
      required this.totalLiabilities,
      required this.totalEquity,
      this.createdAt,
      this.updatedAt});

  factory _$BalanceSheetImpl.fromJson(Map<String, dynamic> json) =>
      _$$BalanceSheetImplFromJson(json);

  @override
  final String id;
  @override
  final String companyId;
  @override
  final String storeId;
  @override
  final DateTime periodDate;
  @override
  final Assets assets;
  @override
  final Liabilities liabilities;
  @override
  final Equity equity;
  @override
  final double totalAssets;
  @override
  final double totalLiabilities;
  @override
  final double totalEquity;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'BalanceSheet(id: $id, companyId: $companyId, storeId: $storeId, periodDate: $periodDate, assets: $assets, liabilities: $liabilities, equity: $equity, totalAssets: $totalAssets, totalLiabilities: $totalLiabilities, totalEquity: $totalEquity, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BalanceSheetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.periodDate, periodDate) ||
                other.periodDate == periodDate) &&
            (identical(other.assets, assets) || other.assets == assets) &&
            (identical(other.liabilities, liabilities) ||
                other.liabilities == liabilities) &&
            (identical(other.equity, equity) || other.equity == equity) &&
            (identical(other.totalAssets, totalAssets) ||
                other.totalAssets == totalAssets) &&
            (identical(other.totalLiabilities, totalLiabilities) ||
                other.totalLiabilities == totalLiabilities) &&
            (identical(other.totalEquity, totalEquity) ||
                other.totalEquity == totalEquity) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      companyId,
      storeId,
      periodDate,
      assets,
      liabilities,
      equity,
      totalAssets,
      totalLiabilities,
      totalEquity,
      createdAt,
      updatedAt);

  /// Create a copy of BalanceSheet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BalanceSheetImplCopyWith<_$BalanceSheetImpl> get copyWith =>
      __$$BalanceSheetImplCopyWithImpl<_$BalanceSheetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BalanceSheetImplToJson(
      this,
    );
  }
}

abstract class _BalanceSheet implements BalanceSheet {
  const factory _BalanceSheet(
      {required final String id,
      required final String companyId,
      required final String storeId,
      required final DateTime periodDate,
      required final Assets assets,
      required final Liabilities liabilities,
      required final Equity equity,
      required final double totalAssets,
      required final double totalLiabilities,
      required final double totalEquity,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$BalanceSheetImpl;

  factory _BalanceSheet.fromJson(Map<String, dynamic> json) =
      _$BalanceSheetImpl.fromJson;

  @override
  String get id;
  @override
  String get companyId;
  @override
  String get storeId;
  @override
  DateTime get periodDate;
  @override
  Assets get assets;
  @override
  Liabilities get liabilities;
  @override
  Equity get equity;
  @override
  double get totalAssets;
  @override
  double get totalLiabilities;
  @override
  double get totalEquity;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of BalanceSheet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BalanceSheetImplCopyWith<_$BalanceSheetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Assets _$AssetsFromJson(Map<String, dynamic> json) {
  return _Assets.fromJson(json);
}

/// @nodoc
mixin _$Assets {
  CurrentAssets get currentAssets => throw _privateConstructorUsedError;
  NonCurrentAssets get nonCurrentAssets => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;

  /// Serializes this Assets to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Assets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AssetsCopyWith<Assets> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetsCopyWith<$Res> {
  factory $AssetsCopyWith(Assets value, $Res Function(Assets) then) =
      _$AssetsCopyWithImpl<$Res, Assets>;
  @useResult
  $Res call(
      {CurrentAssets currentAssets,
      NonCurrentAssets nonCurrentAssets,
      double total});

  $CurrentAssetsCopyWith<$Res> get currentAssets;
  $NonCurrentAssetsCopyWith<$Res> get nonCurrentAssets;
}

/// @nodoc
class _$AssetsCopyWithImpl<$Res, $Val extends Assets>
    implements $AssetsCopyWith<$Res> {
  _$AssetsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Assets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentAssets = null,
    Object? nonCurrentAssets = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      currentAssets: null == currentAssets
          ? _value.currentAssets
          : currentAssets // ignore: cast_nullable_to_non_nullable
              as CurrentAssets,
      nonCurrentAssets: null == nonCurrentAssets
          ? _value.nonCurrentAssets
          : nonCurrentAssets // ignore: cast_nullable_to_non_nullable
              as NonCurrentAssets,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of Assets
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CurrentAssetsCopyWith<$Res> get currentAssets {
    return $CurrentAssetsCopyWith<$Res>(_value.currentAssets, (value) {
      return _then(_value.copyWith(currentAssets: value) as $Val);
    });
  }

  /// Create a copy of Assets
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NonCurrentAssetsCopyWith<$Res> get nonCurrentAssets {
    return $NonCurrentAssetsCopyWith<$Res>(_value.nonCurrentAssets, (value) {
      return _then(_value.copyWith(nonCurrentAssets: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AssetsImplCopyWith<$Res> implements $AssetsCopyWith<$Res> {
  factory _$$AssetsImplCopyWith(
          _$AssetsImpl value, $Res Function(_$AssetsImpl) then) =
      __$$AssetsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {CurrentAssets currentAssets,
      NonCurrentAssets nonCurrentAssets,
      double total});

  @override
  $CurrentAssetsCopyWith<$Res> get currentAssets;
  @override
  $NonCurrentAssetsCopyWith<$Res> get nonCurrentAssets;
}

/// @nodoc
class __$$AssetsImplCopyWithImpl<$Res>
    extends _$AssetsCopyWithImpl<$Res, _$AssetsImpl>
    implements _$$AssetsImplCopyWith<$Res> {
  __$$AssetsImplCopyWithImpl(
      _$AssetsImpl _value, $Res Function(_$AssetsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Assets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentAssets = null,
    Object? nonCurrentAssets = null,
    Object? total = null,
  }) {
    return _then(_$AssetsImpl(
      currentAssets: null == currentAssets
          ? _value.currentAssets
          : currentAssets // ignore: cast_nullable_to_non_nullable
              as CurrentAssets,
      nonCurrentAssets: null == nonCurrentAssets
          ? _value.nonCurrentAssets
          : nonCurrentAssets // ignore: cast_nullable_to_non_nullable
              as NonCurrentAssets,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssetsImpl implements _Assets {
  const _$AssetsImpl(
      {required this.currentAssets,
      required this.nonCurrentAssets,
      required this.total});

  factory _$AssetsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssetsImplFromJson(json);

  @override
  final CurrentAssets currentAssets;
  @override
  final NonCurrentAssets nonCurrentAssets;
  @override
  final double total;

  @override
  String toString() {
    return 'Assets(currentAssets: $currentAssets, nonCurrentAssets: $nonCurrentAssets, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssetsImpl &&
            (identical(other.currentAssets, currentAssets) ||
                other.currentAssets == currentAssets) &&
            (identical(other.nonCurrentAssets, nonCurrentAssets) ||
                other.nonCurrentAssets == nonCurrentAssets) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, currentAssets, nonCurrentAssets, total);

  /// Create a copy of Assets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssetsImplCopyWith<_$AssetsImpl> get copyWith =>
      __$$AssetsImplCopyWithImpl<_$AssetsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssetsImplToJson(
      this,
    );
  }
}

abstract class _Assets implements Assets {
  const factory _Assets(
      {required final CurrentAssets currentAssets,
      required final NonCurrentAssets nonCurrentAssets,
      required final double total}) = _$AssetsImpl;

  factory _Assets.fromJson(Map<String, dynamic> json) = _$AssetsImpl.fromJson;

  @override
  CurrentAssets get currentAssets;
  @override
  NonCurrentAssets get nonCurrentAssets;
  @override
  double get total;

  /// Create a copy of Assets
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssetsImplCopyWith<_$AssetsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CurrentAssets _$CurrentAssetsFromJson(Map<String, dynamic> json) {
  return _CurrentAssets.fromJson(json);
}

/// @nodoc
mixin _$CurrentAssets {
  double get cash => throw _privateConstructorUsedError;
  double get accountsReceivable => throw _privateConstructorUsedError;
  double get inventory => throw _privateConstructorUsedError;
  double get prepaidExpenses => throw _privateConstructorUsedError;
  double get otherCurrentAssets => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;

  /// Serializes this CurrentAssets to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CurrentAssets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrentAssetsCopyWith<CurrentAssets> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrentAssetsCopyWith<$Res> {
  factory $CurrentAssetsCopyWith(
          CurrentAssets value, $Res Function(CurrentAssets) then) =
      _$CurrentAssetsCopyWithImpl<$Res, CurrentAssets>;
  @useResult
  $Res call(
      {double cash,
      double accountsReceivable,
      double inventory,
      double prepaidExpenses,
      double otherCurrentAssets,
      double total});
}

/// @nodoc
class _$CurrentAssetsCopyWithImpl<$Res, $Val extends CurrentAssets>
    implements $CurrentAssetsCopyWith<$Res> {
  _$CurrentAssetsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurrentAssets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cash = null,
    Object? accountsReceivable = null,
    Object? inventory = null,
    Object? prepaidExpenses = null,
    Object? otherCurrentAssets = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      cash: null == cash
          ? _value.cash
          : cash // ignore: cast_nullable_to_non_nullable
              as double,
      accountsReceivable: null == accountsReceivable
          ? _value.accountsReceivable
          : accountsReceivable // ignore: cast_nullable_to_non_nullable
              as double,
      inventory: null == inventory
          ? _value.inventory
          : inventory // ignore: cast_nullable_to_non_nullable
              as double,
      prepaidExpenses: null == prepaidExpenses
          ? _value.prepaidExpenses
          : prepaidExpenses // ignore: cast_nullable_to_non_nullable
              as double,
      otherCurrentAssets: null == otherCurrentAssets
          ? _value.otherCurrentAssets
          : otherCurrentAssets // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrentAssetsImplCopyWith<$Res>
    implements $CurrentAssetsCopyWith<$Res> {
  factory _$$CurrentAssetsImplCopyWith(
          _$CurrentAssetsImpl value, $Res Function(_$CurrentAssetsImpl) then) =
      __$$CurrentAssetsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double cash,
      double accountsReceivable,
      double inventory,
      double prepaidExpenses,
      double otherCurrentAssets,
      double total});
}

/// @nodoc
class __$$CurrentAssetsImplCopyWithImpl<$Res>
    extends _$CurrentAssetsCopyWithImpl<$Res, _$CurrentAssetsImpl>
    implements _$$CurrentAssetsImplCopyWith<$Res> {
  __$$CurrentAssetsImplCopyWithImpl(
      _$CurrentAssetsImpl _value, $Res Function(_$CurrentAssetsImpl) _then)
      : super(_value, _then);

  /// Create a copy of CurrentAssets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cash = null,
    Object? accountsReceivable = null,
    Object? inventory = null,
    Object? prepaidExpenses = null,
    Object? otherCurrentAssets = null,
    Object? total = null,
  }) {
    return _then(_$CurrentAssetsImpl(
      cash: null == cash
          ? _value.cash
          : cash // ignore: cast_nullable_to_non_nullable
              as double,
      accountsReceivable: null == accountsReceivable
          ? _value.accountsReceivable
          : accountsReceivable // ignore: cast_nullable_to_non_nullable
              as double,
      inventory: null == inventory
          ? _value.inventory
          : inventory // ignore: cast_nullable_to_non_nullable
              as double,
      prepaidExpenses: null == prepaidExpenses
          ? _value.prepaidExpenses
          : prepaidExpenses // ignore: cast_nullable_to_non_nullable
              as double,
      otherCurrentAssets: null == otherCurrentAssets
          ? _value.otherCurrentAssets
          : otherCurrentAssets // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrentAssetsImpl implements _CurrentAssets {
  const _$CurrentAssetsImpl(
      {required this.cash,
      required this.accountsReceivable,
      required this.inventory,
      required this.prepaidExpenses,
      required this.otherCurrentAssets,
      required this.total});

  factory _$CurrentAssetsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrentAssetsImplFromJson(json);

  @override
  final double cash;
  @override
  final double accountsReceivable;
  @override
  final double inventory;
  @override
  final double prepaidExpenses;
  @override
  final double otherCurrentAssets;
  @override
  final double total;

  @override
  String toString() {
    return 'CurrentAssets(cash: $cash, accountsReceivable: $accountsReceivable, inventory: $inventory, prepaidExpenses: $prepaidExpenses, otherCurrentAssets: $otherCurrentAssets, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrentAssetsImpl &&
            (identical(other.cash, cash) || other.cash == cash) &&
            (identical(other.accountsReceivable, accountsReceivable) ||
                other.accountsReceivable == accountsReceivable) &&
            (identical(other.inventory, inventory) ||
                other.inventory == inventory) &&
            (identical(other.prepaidExpenses, prepaidExpenses) ||
                other.prepaidExpenses == prepaidExpenses) &&
            (identical(other.otherCurrentAssets, otherCurrentAssets) ||
                other.otherCurrentAssets == otherCurrentAssets) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, cash, accountsReceivable,
      inventory, prepaidExpenses, otherCurrentAssets, total);

  /// Create a copy of CurrentAssets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrentAssetsImplCopyWith<_$CurrentAssetsImpl> get copyWith =>
      __$$CurrentAssetsImplCopyWithImpl<_$CurrentAssetsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrentAssetsImplToJson(
      this,
    );
  }
}

abstract class _CurrentAssets implements CurrentAssets {
  const factory _CurrentAssets(
      {required final double cash,
      required final double accountsReceivable,
      required final double inventory,
      required final double prepaidExpenses,
      required final double otherCurrentAssets,
      required final double total}) = _$CurrentAssetsImpl;

  factory _CurrentAssets.fromJson(Map<String, dynamic> json) =
      _$CurrentAssetsImpl.fromJson;

  @override
  double get cash;
  @override
  double get accountsReceivable;
  @override
  double get inventory;
  @override
  double get prepaidExpenses;
  @override
  double get otherCurrentAssets;
  @override
  double get total;

  /// Create a copy of CurrentAssets
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrentAssetsImplCopyWith<_$CurrentAssetsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NonCurrentAssets _$NonCurrentAssetsFromJson(Map<String, dynamic> json) {
  return _NonCurrentAssets.fromJson(json);
}

/// @nodoc
mixin _$NonCurrentAssets {
  double get propertyPlantEquipment => throw _privateConstructorUsedError;
  double get intangibleAssets => throw _privateConstructorUsedError;
  double get investments => throw _privateConstructorUsedError;
  double get otherNonCurrentAssets => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;

  /// Serializes this NonCurrentAssets to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NonCurrentAssets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NonCurrentAssetsCopyWith<NonCurrentAssets> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NonCurrentAssetsCopyWith<$Res> {
  factory $NonCurrentAssetsCopyWith(
          NonCurrentAssets value, $Res Function(NonCurrentAssets) then) =
      _$NonCurrentAssetsCopyWithImpl<$Res, NonCurrentAssets>;
  @useResult
  $Res call(
      {double propertyPlantEquipment,
      double intangibleAssets,
      double investments,
      double otherNonCurrentAssets,
      double total});
}

/// @nodoc
class _$NonCurrentAssetsCopyWithImpl<$Res, $Val extends NonCurrentAssets>
    implements $NonCurrentAssetsCopyWith<$Res> {
  _$NonCurrentAssetsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NonCurrentAssets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? propertyPlantEquipment = null,
    Object? intangibleAssets = null,
    Object? investments = null,
    Object? otherNonCurrentAssets = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      propertyPlantEquipment: null == propertyPlantEquipment
          ? _value.propertyPlantEquipment
          : propertyPlantEquipment // ignore: cast_nullable_to_non_nullable
              as double,
      intangibleAssets: null == intangibleAssets
          ? _value.intangibleAssets
          : intangibleAssets // ignore: cast_nullable_to_non_nullable
              as double,
      investments: null == investments
          ? _value.investments
          : investments // ignore: cast_nullable_to_non_nullable
              as double,
      otherNonCurrentAssets: null == otherNonCurrentAssets
          ? _value.otherNonCurrentAssets
          : otherNonCurrentAssets // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NonCurrentAssetsImplCopyWith<$Res>
    implements $NonCurrentAssetsCopyWith<$Res> {
  factory _$$NonCurrentAssetsImplCopyWith(_$NonCurrentAssetsImpl value,
          $Res Function(_$NonCurrentAssetsImpl) then) =
      __$$NonCurrentAssetsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double propertyPlantEquipment,
      double intangibleAssets,
      double investments,
      double otherNonCurrentAssets,
      double total});
}

/// @nodoc
class __$$NonCurrentAssetsImplCopyWithImpl<$Res>
    extends _$NonCurrentAssetsCopyWithImpl<$Res, _$NonCurrentAssetsImpl>
    implements _$$NonCurrentAssetsImplCopyWith<$Res> {
  __$$NonCurrentAssetsImplCopyWithImpl(_$NonCurrentAssetsImpl _value,
      $Res Function(_$NonCurrentAssetsImpl) _then)
      : super(_value, _then);

  /// Create a copy of NonCurrentAssets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? propertyPlantEquipment = null,
    Object? intangibleAssets = null,
    Object? investments = null,
    Object? otherNonCurrentAssets = null,
    Object? total = null,
  }) {
    return _then(_$NonCurrentAssetsImpl(
      propertyPlantEquipment: null == propertyPlantEquipment
          ? _value.propertyPlantEquipment
          : propertyPlantEquipment // ignore: cast_nullable_to_non_nullable
              as double,
      intangibleAssets: null == intangibleAssets
          ? _value.intangibleAssets
          : intangibleAssets // ignore: cast_nullable_to_non_nullable
              as double,
      investments: null == investments
          ? _value.investments
          : investments // ignore: cast_nullable_to_non_nullable
              as double,
      otherNonCurrentAssets: null == otherNonCurrentAssets
          ? _value.otherNonCurrentAssets
          : otherNonCurrentAssets // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NonCurrentAssetsImpl implements _NonCurrentAssets {
  const _$NonCurrentAssetsImpl(
      {required this.propertyPlantEquipment,
      required this.intangibleAssets,
      required this.investments,
      required this.otherNonCurrentAssets,
      required this.total});

  factory _$NonCurrentAssetsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NonCurrentAssetsImplFromJson(json);

  @override
  final double propertyPlantEquipment;
  @override
  final double intangibleAssets;
  @override
  final double investments;
  @override
  final double otherNonCurrentAssets;
  @override
  final double total;

  @override
  String toString() {
    return 'NonCurrentAssets(propertyPlantEquipment: $propertyPlantEquipment, intangibleAssets: $intangibleAssets, investments: $investments, otherNonCurrentAssets: $otherNonCurrentAssets, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NonCurrentAssetsImpl &&
            (identical(other.propertyPlantEquipment, propertyPlantEquipment) ||
                other.propertyPlantEquipment == propertyPlantEquipment) &&
            (identical(other.intangibleAssets, intangibleAssets) ||
                other.intangibleAssets == intangibleAssets) &&
            (identical(other.investments, investments) ||
                other.investments == investments) &&
            (identical(other.otherNonCurrentAssets, otherNonCurrentAssets) ||
                other.otherNonCurrentAssets == otherNonCurrentAssets) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, propertyPlantEquipment,
      intangibleAssets, investments, otherNonCurrentAssets, total);

  /// Create a copy of NonCurrentAssets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NonCurrentAssetsImplCopyWith<_$NonCurrentAssetsImpl> get copyWith =>
      __$$NonCurrentAssetsImplCopyWithImpl<_$NonCurrentAssetsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NonCurrentAssetsImplToJson(
      this,
    );
  }
}

abstract class _NonCurrentAssets implements NonCurrentAssets {
  const factory _NonCurrentAssets(
      {required final double propertyPlantEquipment,
      required final double intangibleAssets,
      required final double investments,
      required final double otherNonCurrentAssets,
      required final double total}) = _$NonCurrentAssetsImpl;

  factory _NonCurrentAssets.fromJson(Map<String, dynamic> json) =
      _$NonCurrentAssetsImpl.fromJson;

  @override
  double get propertyPlantEquipment;
  @override
  double get intangibleAssets;
  @override
  double get investments;
  @override
  double get otherNonCurrentAssets;
  @override
  double get total;

  /// Create a copy of NonCurrentAssets
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NonCurrentAssetsImplCopyWith<_$NonCurrentAssetsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Liabilities _$LiabilitiesFromJson(Map<String, dynamic> json) {
  return _Liabilities.fromJson(json);
}

/// @nodoc
mixin _$Liabilities {
  CurrentLiabilities get currentLiabilities =>
      throw _privateConstructorUsedError;
  NonCurrentLiabilities get nonCurrentLiabilities =>
      throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;

  /// Serializes this Liabilities to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Liabilities
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LiabilitiesCopyWith<Liabilities> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LiabilitiesCopyWith<$Res> {
  factory $LiabilitiesCopyWith(
          Liabilities value, $Res Function(Liabilities) then) =
      _$LiabilitiesCopyWithImpl<$Res, Liabilities>;
  @useResult
  $Res call(
      {CurrentLiabilities currentLiabilities,
      NonCurrentLiabilities nonCurrentLiabilities,
      double total});

  $CurrentLiabilitiesCopyWith<$Res> get currentLiabilities;
  $NonCurrentLiabilitiesCopyWith<$Res> get nonCurrentLiabilities;
}

/// @nodoc
class _$LiabilitiesCopyWithImpl<$Res, $Val extends Liabilities>
    implements $LiabilitiesCopyWith<$Res> {
  _$LiabilitiesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Liabilities
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentLiabilities = null,
    Object? nonCurrentLiabilities = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      currentLiabilities: null == currentLiabilities
          ? _value.currentLiabilities
          : currentLiabilities // ignore: cast_nullable_to_non_nullable
              as CurrentLiabilities,
      nonCurrentLiabilities: null == nonCurrentLiabilities
          ? _value.nonCurrentLiabilities
          : nonCurrentLiabilities // ignore: cast_nullable_to_non_nullable
              as NonCurrentLiabilities,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of Liabilities
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CurrentLiabilitiesCopyWith<$Res> get currentLiabilities {
    return $CurrentLiabilitiesCopyWith<$Res>(_value.currentLiabilities,
        (value) {
      return _then(_value.copyWith(currentLiabilities: value) as $Val);
    });
  }

  /// Create a copy of Liabilities
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NonCurrentLiabilitiesCopyWith<$Res> get nonCurrentLiabilities {
    return $NonCurrentLiabilitiesCopyWith<$Res>(_value.nonCurrentLiabilities,
        (value) {
      return _then(_value.copyWith(nonCurrentLiabilities: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LiabilitiesImplCopyWith<$Res>
    implements $LiabilitiesCopyWith<$Res> {
  factory _$$LiabilitiesImplCopyWith(
          _$LiabilitiesImpl value, $Res Function(_$LiabilitiesImpl) then) =
      __$$LiabilitiesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {CurrentLiabilities currentLiabilities,
      NonCurrentLiabilities nonCurrentLiabilities,
      double total});

  @override
  $CurrentLiabilitiesCopyWith<$Res> get currentLiabilities;
  @override
  $NonCurrentLiabilitiesCopyWith<$Res> get nonCurrentLiabilities;
}

/// @nodoc
class __$$LiabilitiesImplCopyWithImpl<$Res>
    extends _$LiabilitiesCopyWithImpl<$Res, _$LiabilitiesImpl>
    implements _$$LiabilitiesImplCopyWith<$Res> {
  __$$LiabilitiesImplCopyWithImpl(
      _$LiabilitiesImpl _value, $Res Function(_$LiabilitiesImpl) _then)
      : super(_value, _then);

  /// Create a copy of Liabilities
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentLiabilities = null,
    Object? nonCurrentLiabilities = null,
    Object? total = null,
  }) {
    return _then(_$LiabilitiesImpl(
      currentLiabilities: null == currentLiabilities
          ? _value.currentLiabilities
          : currentLiabilities // ignore: cast_nullable_to_non_nullable
              as CurrentLiabilities,
      nonCurrentLiabilities: null == nonCurrentLiabilities
          ? _value.nonCurrentLiabilities
          : nonCurrentLiabilities // ignore: cast_nullable_to_non_nullable
              as NonCurrentLiabilities,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LiabilitiesImpl implements _Liabilities {
  const _$LiabilitiesImpl(
      {required this.currentLiabilities,
      required this.nonCurrentLiabilities,
      required this.total});

  factory _$LiabilitiesImpl.fromJson(Map<String, dynamic> json) =>
      _$$LiabilitiesImplFromJson(json);

  @override
  final CurrentLiabilities currentLiabilities;
  @override
  final NonCurrentLiabilities nonCurrentLiabilities;
  @override
  final double total;

  @override
  String toString() {
    return 'Liabilities(currentLiabilities: $currentLiabilities, nonCurrentLiabilities: $nonCurrentLiabilities, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LiabilitiesImpl &&
            (identical(other.currentLiabilities, currentLiabilities) ||
                other.currentLiabilities == currentLiabilities) &&
            (identical(other.nonCurrentLiabilities, nonCurrentLiabilities) ||
                other.nonCurrentLiabilities == nonCurrentLiabilities) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, currentLiabilities, nonCurrentLiabilities, total);

  /// Create a copy of Liabilities
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LiabilitiesImplCopyWith<_$LiabilitiesImpl> get copyWith =>
      __$$LiabilitiesImplCopyWithImpl<_$LiabilitiesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LiabilitiesImplToJson(
      this,
    );
  }
}

abstract class _Liabilities implements Liabilities {
  const factory _Liabilities(
      {required final CurrentLiabilities currentLiabilities,
      required final NonCurrentLiabilities nonCurrentLiabilities,
      required final double total}) = _$LiabilitiesImpl;

  factory _Liabilities.fromJson(Map<String, dynamic> json) =
      _$LiabilitiesImpl.fromJson;

  @override
  CurrentLiabilities get currentLiabilities;
  @override
  NonCurrentLiabilities get nonCurrentLiabilities;
  @override
  double get total;

  /// Create a copy of Liabilities
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LiabilitiesImplCopyWith<_$LiabilitiesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CurrentLiabilities _$CurrentLiabilitiesFromJson(Map<String, dynamic> json) {
  return _CurrentLiabilities.fromJson(json);
}

/// @nodoc
mixin _$CurrentLiabilities {
  double get accountsPayable => throw _privateConstructorUsedError;
  double get shortTermDebt => throw _privateConstructorUsedError;
  double get accruedExpenses => throw _privateConstructorUsedError;
  double get currentPortionLongTermDebt => throw _privateConstructorUsedError;
  double get otherCurrentLiabilities => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;

  /// Serializes this CurrentLiabilities to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CurrentLiabilities
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrentLiabilitiesCopyWith<CurrentLiabilities> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrentLiabilitiesCopyWith<$Res> {
  factory $CurrentLiabilitiesCopyWith(
          CurrentLiabilities value, $Res Function(CurrentLiabilities) then) =
      _$CurrentLiabilitiesCopyWithImpl<$Res, CurrentLiabilities>;
  @useResult
  $Res call(
      {double accountsPayable,
      double shortTermDebt,
      double accruedExpenses,
      double currentPortionLongTermDebt,
      double otherCurrentLiabilities,
      double total});
}

/// @nodoc
class _$CurrentLiabilitiesCopyWithImpl<$Res, $Val extends CurrentLiabilities>
    implements $CurrentLiabilitiesCopyWith<$Res> {
  _$CurrentLiabilitiesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurrentLiabilities
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountsPayable = null,
    Object? shortTermDebt = null,
    Object? accruedExpenses = null,
    Object? currentPortionLongTermDebt = null,
    Object? otherCurrentLiabilities = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      accountsPayable: null == accountsPayable
          ? _value.accountsPayable
          : accountsPayable // ignore: cast_nullable_to_non_nullable
              as double,
      shortTermDebt: null == shortTermDebt
          ? _value.shortTermDebt
          : shortTermDebt // ignore: cast_nullable_to_non_nullable
              as double,
      accruedExpenses: null == accruedExpenses
          ? _value.accruedExpenses
          : accruedExpenses // ignore: cast_nullable_to_non_nullable
              as double,
      currentPortionLongTermDebt: null == currentPortionLongTermDebt
          ? _value.currentPortionLongTermDebt
          : currentPortionLongTermDebt // ignore: cast_nullable_to_non_nullable
              as double,
      otherCurrentLiabilities: null == otherCurrentLiabilities
          ? _value.otherCurrentLiabilities
          : otherCurrentLiabilities // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrentLiabilitiesImplCopyWith<$Res>
    implements $CurrentLiabilitiesCopyWith<$Res> {
  factory _$$CurrentLiabilitiesImplCopyWith(_$CurrentLiabilitiesImpl value,
          $Res Function(_$CurrentLiabilitiesImpl) then) =
      __$$CurrentLiabilitiesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double accountsPayable,
      double shortTermDebt,
      double accruedExpenses,
      double currentPortionLongTermDebt,
      double otherCurrentLiabilities,
      double total});
}

/// @nodoc
class __$$CurrentLiabilitiesImplCopyWithImpl<$Res>
    extends _$CurrentLiabilitiesCopyWithImpl<$Res, _$CurrentLiabilitiesImpl>
    implements _$$CurrentLiabilitiesImplCopyWith<$Res> {
  __$$CurrentLiabilitiesImplCopyWithImpl(_$CurrentLiabilitiesImpl _value,
      $Res Function(_$CurrentLiabilitiesImpl) _then)
      : super(_value, _then);

  /// Create a copy of CurrentLiabilities
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountsPayable = null,
    Object? shortTermDebt = null,
    Object? accruedExpenses = null,
    Object? currentPortionLongTermDebt = null,
    Object? otherCurrentLiabilities = null,
    Object? total = null,
  }) {
    return _then(_$CurrentLiabilitiesImpl(
      accountsPayable: null == accountsPayable
          ? _value.accountsPayable
          : accountsPayable // ignore: cast_nullable_to_non_nullable
              as double,
      shortTermDebt: null == shortTermDebt
          ? _value.shortTermDebt
          : shortTermDebt // ignore: cast_nullable_to_non_nullable
              as double,
      accruedExpenses: null == accruedExpenses
          ? _value.accruedExpenses
          : accruedExpenses // ignore: cast_nullable_to_non_nullable
              as double,
      currentPortionLongTermDebt: null == currentPortionLongTermDebt
          ? _value.currentPortionLongTermDebt
          : currentPortionLongTermDebt // ignore: cast_nullable_to_non_nullable
              as double,
      otherCurrentLiabilities: null == otherCurrentLiabilities
          ? _value.otherCurrentLiabilities
          : otherCurrentLiabilities // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrentLiabilitiesImpl implements _CurrentLiabilities {
  const _$CurrentLiabilitiesImpl(
      {required this.accountsPayable,
      required this.shortTermDebt,
      required this.accruedExpenses,
      required this.currentPortionLongTermDebt,
      required this.otherCurrentLiabilities,
      required this.total});

  factory _$CurrentLiabilitiesImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrentLiabilitiesImplFromJson(json);

  @override
  final double accountsPayable;
  @override
  final double shortTermDebt;
  @override
  final double accruedExpenses;
  @override
  final double currentPortionLongTermDebt;
  @override
  final double otherCurrentLiabilities;
  @override
  final double total;

  @override
  String toString() {
    return 'CurrentLiabilities(accountsPayable: $accountsPayable, shortTermDebt: $shortTermDebt, accruedExpenses: $accruedExpenses, currentPortionLongTermDebt: $currentPortionLongTermDebt, otherCurrentLiabilities: $otherCurrentLiabilities, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrentLiabilitiesImpl &&
            (identical(other.accountsPayable, accountsPayable) ||
                other.accountsPayable == accountsPayable) &&
            (identical(other.shortTermDebt, shortTermDebt) ||
                other.shortTermDebt == shortTermDebt) &&
            (identical(other.accruedExpenses, accruedExpenses) ||
                other.accruedExpenses == accruedExpenses) &&
            (identical(other.currentPortionLongTermDebt,
                    currentPortionLongTermDebt) ||
                other.currentPortionLongTermDebt ==
                    currentPortionLongTermDebt) &&
            (identical(
                    other.otherCurrentLiabilities, otherCurrentLiabilities) ||
                other.otherCurrentLiabilities == otherCurrentLiabilities) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      accountsPayable,
      shortTermDebt,
      accruedExpenses,
      currentPortionLongTermDebt,
      otherCurrentLiabilities,
      total);

  /// Create a copy of CurrentLiabilities
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrentLiabilitiesImplCopyWith<_$CurrentLiabilitiesImpl> get copyWith =>
      __$$CurrentLiabilitiesImplCopyWithImpl<_$CurrentLiabilitiesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrentLiabilitiesImplToJson(
      this,
    );
  }
}

abstract class _CurrentLiabilities implements CurrentLiabilities {
  const factory _CurrentLiabilities(
      {required final double accountsPayable,
      required final double shortTermDebt,
      required final double accruedExpenses,
      required final double currentPortionLongTermDebt,
      required final double otherCurrentLiabilities,
      required final double total}) = _$CurrentLiabilitiesImpl;

  factory _CurrentLiabilities.fromJson(Map<String, dynamic> json) =
      _$CurrentLiabilitiesImpl.fromJson;

  @override
  double get accountsPayable;
  @override
  double get shortTermDebt;
  @override
  double get accruedExpenses;
  @override
  double get currentPortionLongTermDebt;
  @override
  double get otherCurrentLiabilities;
  @override
  double get total;

  /// Create a copy of CurrentLiabilities
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrentLiabilitiesImplCopyWith<_$CurrentLiabilitiesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NonCurrentLiabilities _$NonCurrentLiabilitiesFromJson(
    Map<String, dynamic> json) {
  return _NonCurrentLiabilities.fromJson(json);
}

/// @nodoc
mixin _$NonCurrentLiabilities {
  double get longTermDebt => throw _privateConstructorUsedError;
  double get deferredTaxLiabilities => throw _privateConstructorUsedError;
  double get otherNonCurrentLiabilities => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;

  /// Serializes this NonCurrentLiabilities to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NonCurrentLiabilities
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NonCurrentLiabilitiesCopyWith<NonCurrentLiabilities> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NonCurrentLiabilitiesCopyWith<$Res> {
  factory $NonCurrentLiabilitiesCopyWith(NonCurrentLiabilities value,
          $Res Function(NonCurrentLiabilities) then) =
      _$NonCurrentLiabilitiesCopyWithImpl<$Res, NonCurrentLiabilities>;
  @useResult
  $Res call(
      {double longTermDebt,
      double deferredTaxLiabilities,
      double otherNonCurrentLiabilities,
      double total});
}

/// @nodoc
class _$NonCurrentLiabilitiesCopyWithImpl<$Res,
        $Val extends NonCurrentLiabilities>
    implements $NonCurrentLiabilitiesCopyWith<$Res> {
  _$NonCurrentLiabilitiesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NonCurrentLiabilities
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? longTermDebt = null,
    Object? deferredTaxLiabilities = null,
    Object? otherNonCurrentLiabilities = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      longTermDebt: null == longTermDebt
          ? _value.longTermDebt
          : longTermDebt // ignore: cast_nullable_to_non_nullable
              as double,
      deferredTaxLiabilities: null == deferredTaxLiabilities
          ? _value.deferredTaxLiabilities
          : deferredTaxLiabilities // ignore: cast_nullable_to_non_nullable
              as double,
      otherNonCurrentLiabilities: null == otherNonCurrentLiabilities
          ? _value.otherNonCurrentLiabilities
          : otherNonCurrentLiabilities // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NonCurrentLiabilitiesImplCopyWith<$Res>
    implements $NonCurrentLiabilitiesCopyWith<$Res> {
  factory _$$NonCurrentLiabilitiesImplCopyWith(
          _$NonCurrentLiabilitiesImpl value,
          $Res Function(_$NonCurrentLiabilitiesImpl) then) =
      __$$NonCurrentLiabilitiesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double longTermDebt,
      double deferredTaxLiabilities,
      double otherNonCurrentLiabilities,
      double total});
}

/// @nodoc
class __$$NonCurrentLiabilitiesImplCopyWithImpl<$Res>
    extends _$NonCurrentLiabilitiesCopyWithImpl<$Res,
        _$NonCurrentLiabilitiesImpl>
    implements _$$NonCurrentLiabilitiesImplCopyWith<$Res> {
  __$$NonCurrentLiabilitiesImplCopyWithImpl(_$NonCurrentLiabilitiesImpl _value,
      $Res Function(_$NonCurrentLiabilitiesImpl) _then)
      : super(_value, _then);

  /// Create a copy of NonCurrentLiabilities
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? longTermDebt = null,
    Object? deferredTaxLiabilities = null,
    Object? otherNonCurrentLiabilities = null,
    Object? total = null,
  }) {
    return _then(_$NonCurrentLiabilitiesImpl(
      longTermDebt: null == longTermDebt
          ? _value.longTermDebt
          : longTermDebt // ignore: cast_nullable_to_non_nullable
              as double,
      deferredTaxLiabilities: null == deferredTaxLiabilities
          ? _value.deferredTaxLiabilities
          : deferredTaxLiabilities // ignore: cast_nullable_to_non_nullable
              as double,
      otherNonCurrentLiabilities: null == otherNonCurrentLiabilities
          ? _value.otherNonCurrentLiabilities
          : otherNonCurrentLiabilities // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NonCurrentLiabilitiesImpl implements _NonCurrentLiabilities {
  const _$NonCurrentLiabilitiesImpl(
      {required this.longTermDebt,
      required this.deferredTaxLiabilities,
      required this.otherNonCurrentLiabilities,
      required this.total});

  factory _$NonCurrentLiabilitiesImpl.fromJson(Map<String, dynamic> json) =>
      _$$NonCurrentLiabilitiesImplFromJson(json);

  @override
  final double longTermDebt;
  @override
  final double deferredTaxLiabilities;
  @override
  final double otherNonCurrentLiabilities;
  @override
  final double total;

  @override
  String toString() {
    return 'NonCurrentLiabilities(longTermDebt: $longTermDebt, deferredTaxLiabilities: $deferredTaxLiabilities, otherNonCurrentLiabilities: $otherNonCurrentLiabilities, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NonCurrentLiabilitiesImpl &&
            (identical(other.longTermDebt, longTermDebt) ||
                other.longTermDebt == longTermDebt) &&
            (identical(other.deferredTaxLiabilities, deferredTaxLiabilities) ||
                other.deferredTaxLiabilities == deferredTaxLiabilities) &&
            (identical(other.otherNonCurrentLiabilities,
                    otherNonCurrentLiabilities) ||
                other.otherNonCurrentLiabilities ==
                    otherNonCurrentLiabilities) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, longTermDebt,
      deferredTaxLiabilities, otherNonCurrentLiabilities, total);

  /// Create a copy of NonCurrentLiabilities
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NonCurrentLiabilitiesImplCopyWith<_$NonCurrentLiabilitiesImpl>
      get copyWith => __$$NonCurrentLiabilitiesImplCopyWithImpl<
          _$NonCurrentLiabilitiesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NonCurrentLiabilitiesImplToJson(
      this,
    );
  }
}

abstract class _NonCurrentLiabilities implements NonCurrentLiabilities {
  const factory _NonCurrentLiabilities(
      {required final double longTermDebt,
      required final double deferredTaxLiabilities,
      required final double otherNonCurrentLiabilities,
      required final double total}) = _$NonCurrentLiabilitiesImpl;

  factory _NonCurrentLiabilities.fromJson(Map<String, dynamic> json) =
      _$NonCurrentLiabilitiesImpl.fromJson;

  @override
  double get longTermDebt;
  @override
  double get deferredTaxLiabilities;
  @override
  double get otherNonCurrentLiabilities;
  @override
  double get total;

  /// Create a copy of NonCurrentLiabilities
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NonCurrentLiabilitiesImplCopyWith<_$NonCurrentLiabilitiesImpl>
      get copyWith => throw _privateConstructorUsedError;
}

Equity _$EquityFromJson(Map<String, dynamic> json) {
  return _Equity.fromJson(json);
}

/// @nodoc
mixin _$Equity {
  double get commonStock => throw _privateConstructorUsedError;
  double get retainedEarnings => throw _privateConstructorUsedError;
  double get additionalPaidInCapital => throw _privateConstructorUsedError;
  double get otherEquity => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;

  /// Serializes this Equity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Equity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EquityCopyWith<Equity> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EquityCopyWith<$Res> {
  factory $EquityCopyWith(Equity value, $Res Function(Equity) then) =
      _$EquityCopyWithImpl<$Res, Equity>;
  @useResult
  $Res call(
      {double commonStock,
      double retainedEarnings,
      double additionalPaidInCapital,
      double otherEquity,
      double total});
}

/// @nodoc
class _$EquityCopyWithImpl<$Res, $Val extends Equity>
    implements $EquityCopyWith<$Res> {
  _$EquityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Equity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commonStock = null,
    Object? retainedEarnings = null,
    Object? additionalPaidInCapital = null,
    Object? otherEquity = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      commonStock: null == commonStock
          ? _value.commonStock
          : commonStock // ignore: cast_nullable_to_non_nullable
              as double,
      retainedEarnings: null == retainedEarnings
          ? _value.retainedEarnings
          : retainedEarnings // ignore: cast_nullable_to_non_nullable
              as double,
      additionalPaidInCapital: null == additionalPaidInCapital
          ? _value.additionalPaidInCapital
          : additionalPaidInCapital // ignore: cast_nullable_to_non_nullable
              as double,
      otherEquity: null == otherEquity
          ? _value.otherEquity
          : otherEquity // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EquityImplCopyWith<$Res> implements $EquityCopyWith<$Res> {
  factory _$$EquityImplCopyWith(
          _$EquityImpl value, $Res Function(_$EquityImpl) then) =
      __$$EquityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double commonStock,
      double retainedEarnings,
      double additionalPaidInCapital,
      double otherEquity,
      double total});
}

/// @nodoc
class __$$EquityImplCopyWithImpl<$Res>
    extends _$EquityCopyWithImpl<$Res, _$EquityImpl>
    implements _$$EquityImplCopyWith<$Res> {
  __$$EquityImplCopyWithImpl(
      _$EquityImpl _value, $Res Function(_$EquityImpl) _then)
      : super(_value, _then);

  /// Create a copy of Equity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commonStock = null,
    Object? retainedEarnings = null,
    Object? additionalPaidInCapital = null,
    Object? otherEquity = null,
    Object? total = null,
  }) {
    return _then(_$EquityImpl(
      commonStock: null == commonStock
          ? _value.commonStock
          : commonStock // ignore: cast_nullable_to_non_nullable
              as double,
      retainedEarnings: null == retainedEarnings
          ? _value.retainedEarnings
          : retainedEarnings // ignore: cast_nullable_to_non_nullable
              as double,
      additionalPaidInCapital: null == additionalPaidInCapital
          ? _value.additionalPaidInCapital
          : additionalPaidInCapital // ignore: cast_nullable_to_non_nullable
              as double,
      otherEquity: null == otherEquity
          ? _value.otherEquity
          : otherEquity // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EquityImpl implements _Equity {
  const _$EquityImpl(
      {required this.commonStock,
      required this.retainedEarnings,
      required this.additionalPaidInCapital,
      required this.otherEquity,
      required this.total});

  factory _$EquityImpl.fromJson(Map<String, dynamic> json) =>
      _$$EquityImplFromJson(json);

  @override
  final double commonStock;
  @override
  final double retainedEarnings;
  @override
  final double additionalPaidInCapital;
  @override
  final double otherEquity;
  @override
  final double total;

  @override
  String toString() {
    return 'Equity(commonStock: $commonStock, retainedEarnings: $retainedEarnings, additionalPaidInCapital: $additionalPaidInCapital, otherEquity: $otherEquity, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EquityImpl &&
            (identical(other.commonStock, commonStock) ||
                other.commonStock == commonStock) &&
            (identical(other.retainedEarnings, retainedEarnings) ||
                other.retainedEarnings == retainedEarnings) &&
            (identical(
                    other.additionalPaidInCapital, additionalPaidInCapital) ||
                other.additionalPaidInCapital == additionalPaidInCapital) &&
            (identical(other.otherEquity, otherEquity) ||
                other.otherEquity == otherEquity) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, commonStock, retainedEarnings,
      additionalPaidInCapital, otherEquity, total);

  /// Create a copy of Equity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EquityImplCopyWith<_$EquityImpl> get copyWith =>
      __$$EquityImplCopyWithImpl<_$EquityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EquityImplToJson(
      this,
    );
  }
}

abstract class _Equity implements Equity {
  const factory _Equity(
      {required final double commonStock,
      required final double retainedEarnings,
      required final double additionalPaidInCapital,
      required final double otherEquity,
      required final double total}) = _$EquityImpl;

  factory _Equity.fromJson(Map<String, dynamic> json) = _$EquityImpl.fromJson;

  @override
  double get commonStock;
  @override
  double get retainedEarnings;
  @override
  double get additionalPaidInCapital;
  @override
  double get otherEquity;
  @override
  double get total;

  /// Create a copy of Equity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EquityImplCopyWith<_$EquityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BalanceSheetSummary _$BalanceSheetSummaryFromJson(Map<String, dynamic> json) {
  return _BalanceSheetSummary.fromJson(json);
}

/// @nodoc
mixin _$BalanceSheetSummary {
  String get companyName => throw _privateConstructorUsedError;
  String get storeName => throw _privateConstructorUsedError;
  DateTime get periodDate => throw _privateConstructorUsedError;
  double get totalAssets => throw _privateConstructorUsedError;
  double get totalLiabilities => throw _privateConstructorUsedError;
  double get totalEquity => throw _privateConstructorUsedError;
  double get currentRatio => throw _privateConstructorUsedError;
  double get debtToEquityRatio => throw _privateConstructorUsedError;
  double get returnOnEquity => throw _privateConstructorUsedError;

  /// Serializes this BalanceSheetSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BalanceSheetSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BalanceSheetSummaryCopyWith<BalanceSheetSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BalanceSheetSummaryCopyWith<$Res> {
  factory $BalanceSheetSummaryCopyWith(
          BalanceSheetSummary value, $Res Function(BalanceSheetSummary) then) =
      _$BalanceSheetSummaryCopyWithImpl<$Res, BalanceSheetSummary>;
  @useResult
  $Res call(
      {String companyName,
      String storeName,
      DateTime periodDate,
      double totalAssets,
      double totalLiabilities,
      double totalEquity,
      double currentRatio,
      double debtToEquityRatio,
      double returnOnEquity});
}

/// @nodoc
class _$BalanceSheetSummaryCopyWithImpl<$Res, $Val extends BalanceSheetSummary>
    implements $BalanceSheetSummaryCopyWith<$Res> {
  _$BalanceSheetSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BalanceSheetSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyName = null,
    Object? storeName = null,
    Object? periodDate = null,
    Object? totalAssets = null,
    Object? totalLiabilities = null,
    Object? totalEquity = null,
    Object? currentRatio = null,
    Object? debtToEquityRatio = null,
    Object? returnOnEquity = null,
  }) {
    return _then(_value.copyWith(
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      periodDate: null == periodDate
          ? _value.periodDate
          : periodDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalAssets: null == totalAssets
          ? _value.totalAssets
          : totalAssets // ignore: cast_nullable_to_non_nullable
              as double,
      totalLiabilities: null == totalLiabilities
          ? _value.totalLiabilities
          : totalLiabilities // ignore: cast_nullable_to_non_nullable
              as double,
      totalEquity: null == totalEquity
          ? _value.totalEquity
          : totalEquity // ignore: cast_nullable_to_non_nullable
              as double,
      currentRatio: null == currentRatio
          ? _value.currentRatio
          : currentRatio // ignore: cast_nullable_to_non_nullable
              as double,
      debtToEquityRatio: null == debtToEquityRatio
          ? _value.debtToEquityRatio
          : debtToEquityRatio // ignore: cast_nullable_to_non_nullable
              as double,
      returnOnEquity: null == returnOnEquity
          ? _value.returnOnEquity
          : returnOnEquity // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BalanceSheetSummaryImplCopyWith<$Res>
    implements $BalanceSheetSummaryCopyWith<$Res> {
  factory _$$BalanceSheetSummaryImplCopyWith(_$BalanceSheetSummaryImpl value,
          $Res Function(_$BalanceSheetSummaryImpl) then) =
      __$$BalanceSheetSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String companyName,
      String storeName,
      DateTime periodDate,
      double totalAssets,
      double totalLiabilities,
      double totalEquity,
      double currentRatio,
      double debtToEquityRatio,
      double returnOnEquity});
}

/// @nodoc
class __$$BalanceSheetSummaryImplCopyWithImpl<$Res>
    extends _$BalanceSheetSummaryCopyWithImpl<$Res, _$BalanceSheetSummaryImpl>
    implements _$$BalanceSheetSummaryImplCopyWith<$Res> {
  __$$BalanceSheetSummaryImplCopyWithImpl(_$BalanceSheetSummaryImpl _value,
      $Res Function(_$BalanceSheetSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of BalanceSheetSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyName = null,
    Object? storeName = null,
    Object? periodDate = null,
    Object? totalAssets = null,
    Object? totalLiabilities = null,
    Object? totalEquity = null,
    Object? currentRatio = null,
    Object? debtToEquityRatio = null,
    Object? returnOnEquity = null,
  }) {
    return _then(_$BalanceSheetSummaryImpl(
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      periodDate: null == periodDate
          ? _value.periodDate
          : periodDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalAssets: null == totalAssets
          ? _value.totalAssets
          : totalAssets // ignore: cast_nullable_to_non_nullable
              as double,
      totalLiabilities: null == totalLiabilities
          ? _value.totalLiabilities
          : totalLiabilities // ignore: cast_nullable_to_non_nullable
              as double,
      totalEquity: null == totalEquity
          ? _value.totalEquity
          : totalEquity // ignore: cast_nullable_to_non_nullable
              as double,
      currentRatio: null == currentRatio
          ? _value.currentRatio
          : currentRatio // ignore: cast_nullable_to_non_nullable
              as double,
      debtToEquityRatio: null == debtToEquityRatio
          ? _value.debtToEquityRatio
          : debtToEquityRatio // ignore: cast_nullable_to_non_nullable
              as double,
      returnOnEquity: null == returnOnEquity
          ? _value.returnOnEquity
          : returnOnEquity // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BalanceSheetSummaryImpl implements _BalanceSheetSummary {
  const _$BalanceSheetSummaryImpl(
      {required this.companyName,
      required this.storeName,
      required this.periodDate,
      required this.totalAssets,
      required this.totalLiabilities,
      required this.totalEquity,
      required this.currentRatio,
      required this.debtToEquityRatio,
      required this.returnOnEquity});

  factory _$BalanceSheetSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$BalanceSheetSummaryImplFromJson(json);

  @override
  final String companyName;
  @override
  final String storeName;
  @override
  final DateTime periodDate;
  @override
  final double totalAssets;
  @override
  final double totalLiabilities;
  @override
  final double totalEquity;
  @override
  final double currentRatio;
  @override
  final double debtToEquityRatio;
  @override
  final double returnOnEquity;

  @override
  String toString() {
    return 'BalanceSheetSummary(companyName: $companyName, storeName: $storeName, periodDate: $periodDate, totalAssets: $totalAssets, totalLiabilities: $totalLiabilities, totalEquity: $totalEquity, currentRatio: $currentRatio, debtToEquityRatio: $debtToEquityRatio, returnOnEquity: $returnOnEquity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BalanceSheetSummaryImpl &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.periodDate, periodDate) ||
                other.periodDate == periodDate) &&
            (identical(other.totalAssets, totalAssets) ||
                other.totalAssets == totalAssets) &&
            (identical(other.totalLiabilities, totalLiabilities) ||
                other.totalLiabilities == totalLiabilities) &&
            (identical(other.totalEquity, totalEquity) ||
                other.totalEquity == totalEquity) &&
            (identical(other.currentRatio, currentRatio) ||
                other.currentRatio == currentRatio) &&
            (identical(other.debtToEquityRatio, debtToEquityRatio) ||
                other.debtToEquityRatio == debtToEquityRatio) &&
            (identical(other.returnOnEquity, returnOnEquity) ||
                other.returnOnEquity == returnOnEquity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      companyName,
      storeName,
      periodDate,
      totalAssets,
      totalLiabilities,
      totalEquity,
      currentRatio,
      debtToEquityRatio,
      returnOnEquity);

  /// Create a copy of BalanceSheetSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BalanceSheetSummaryImplCopyWith<_$BalanceSheetSummaryImpl> get copyWith =>
      __$$BalanceSheetSummaryImplCopyWithImpl<_$BalanceSheetSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BalanceSheetSummaryImplToJson(
      this,
    );
  }
}

abstract class _BalanceSheetSummary implements BalanceSheetSummary {
  const factory _BalanceSheetSummary(
      {required final String companyName,
      required final String storeName,
      required final DateTime periodDate,
      required final double totalAssets,
      required final double totalLiabilities,
      required final double totalEquity,
      required final double currentRatio,
      required final double debtToEquityRatio,
      required final double returnOnEquity}) = _$BalanceSheetSummaryImpl;

  factory _BalanceSheetSummary.fromJson(Map<String, dynamic> json) =
      _$BalanceSheetSummaryImpl.fromJson;

  @override
  String get companyName;
  @override
  String get storeName;
  @override
  DateTime get periodDate;
  @override
  double get totalAssets;
  @override
  double get totalLiabilities;
  @override
  double get totalEquity;
  @override
  double get currentRatio;
  @override
  double get debtToEquityRatio;
  @override
  double get returnOnEquity;

  /// Create a copy of BalanceSheetSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BalanceSheetSummaryImplCopyWith<_$BalanceSheetSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FinancialRatios _$FinancialRatiosFromJson(Map<String, dynamic> json) {
  return _FinancialRatios.fromJson(json);
}

/// @nodoc
mixin _$FinancialRatios {
// Liquidity Ratios
  double get currentRatio => throw _privateConstructorUsedError;
  double get quickRatio => throw _privateConstructorUsedError;
  double get cashRatio => throw _privateConstructorUsedError; // Leverage Ratios
  double get debtToEquityRatio => throw _privateConstructorUsedError;
  double get debtToAssetsRatio => throw _privateConstructorUsedError;
  double get equityMultiplier =>
      throw _privateConstructorUsedError; // Efficiency Ratios
  double get assetTurnover => throw _privateConstructorUsedError;
  double get inventoryTurnover => throw _privateConstructorUsedError;
  double get receivablesTurnover =>
      throw _privateConstructorUsedError; // Profitability Ratios
  double get returnOnAssets => throw _privateConstructorUsedError;
  double get returnOnEquity => throw _privateConstructorUsedError;
  double get grossProfitMargin => throw _privateConstructorUsedError;
  double get netProfitMargin => throw _privateConstructorUsedError;

  /// Serializes this FinancialRatios to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FinancialRatios
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinancialRatiosCopyWith<FinancialRatios> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialRatiosCopyWith<$Res> {
  factory $FinancialRatiosCopyWith(
          FinancialRatios value, $Res Function(FinancialRatios) then) =
      _$FinancialRatiosCopyWithImpl<$Res, FinancialRatios>;
  @useResult
  $Res call(
      {double currentRatio,
      double quickRatio,
      double cashRatio,
      double debtToEquityRatio,
      double debtToAssetsRatio,
      double equityMultiplier,
      double assetTurnover,
      double inventoryTurnover,
      double receivablesTurnover,
      double returnOnAssets,
      double returnOnEquity,
      double grossProfitMargin,
      double netProfitMargin});
}

/// @nodoc
class _$FinancialRatiosCopyWithImpl<$Res, $Val extends FinancialRatios>
    implements $FinancialRatiosCopyWith<$Res> {
  _$FinancialRatiosCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinancialRatios
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentRatio = null,
    Object? quickRatio = null,
    Object? cashRatio = null,
    Object? debtToEquityRatio = null,
    Object? debtToAssetsRatio = null,
    Object? equityMultiplier = null,
    Object? assetTurnover = null,
    Object? inventoryTurnover = null,
    Object? receivablesTurnover = null,
    Object? returnOnAssets = null,
    Object? returnOnEquity = null,
    Object? grossProfitMargin = null,
    Object? netProfitMargin = null,
  }) {
    return _then(_value.copyWith(
      currentRatio: null == currentRatio
          ? _value.currentRatio
          : currentRatio // ignore: cast_nullable_to_non_nullable
              as double,
      quickRatio: null == quickRatio
          ? _value.quickRatio
          : quickRatio // ignore: cast_nullable_to_non_nullable
              as double,
      cashRatio: null == cashRatio
          ? _value.cashRatio
          : cashRatio // ignore: cast_nullable_to_non_nullable
              as double,
      debtToEquityRatio: null == debtToEquityRatio
          ? _value.debtToEquityRatio
          : debtToEquityRatio // ignore: cast_nullable_to_non_nullable
              as double,
      debtToAssetsRatio: null == debtToAssetsRatio
          ? _value.debtToAssetsRatio
          : debtToAssetsRatio // ignore: cast_nullable_to_non_nullable
              as double,
      equityMultiplier: null == equityMultiplier
          ? _value.equityMultiplier
          : equityMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      assetTurnover: null == assetTurnover
          ? _value.assetTurnover
          : assetTurnover // ignore: cast_nullable_to_non_nullable
              as double,
      inventoryTurnover: null == inventoryTurnover
          ? _value.inventoryTurnover
          : inventoryTurnover // ignore: cast_nullable_to_non_nullable
              as double,
      receivablesTurnover: null == receivablesTurnover
          ? _value.receivablesTurnover
          : receivablesTurnover // ignore: cast_nullable_to_non_nullable
              as double,
      returnOnAssets: null == returnOnAssets
          ? _value.returnOnAssets
          : returnOnAssets // ignore: cast_nullable_to_non_nullable
              as double,
      returnOnEquity: null == returnOnEquity
          ? _value.returnOnEquity
          : returnOnEquity // ignore: cast_nullable_to_non_nullable
              as double,
      grossProfitMargin: null == grossProfitMargin
          ? _value.grossProfitMargin
          : grossProfitMargin // ignore: cast_nullable_to_non_nullable
              as double,
      netProfitMargin: null == netProfitMargin
          ? _value.netProfitMargin
          : netProfitMargin // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FinancialRatiosImplCopyWith<$Res>
    implements $FinancialRatiosCopyWith<$Res> {
  factory _$$FinancialRatiosImplCopyWith(_$FinancialRatiosImpl value,
          $Res Function(_$FinancialRatiosImpl) then) =
      __$$FinancialRatiosImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double currentRatio,
      double quickRatio,
      double cashRatio,
      double debtToEquityRatio,
      double debtToAssetsRatio,
      double equityMultiplier,
      double assetTurnover,
      double inventoryTurnover,
      double receivablesTurnover,
      double returnOnAssets,
      double returnOnEquity,
      double grossProfitMargin,
      double netProfitMargin});
}

/// @nodoc
class __$$FinancialRatiosImplCopyWithImpl<$Res>
    extends _$FinancialRatiosCopyWithImpl<$Res, _$FinancialRatiosImpl>
    implements _$$FinancialRatiosImplCopyWith<$Res> {
  __$$FinancialRatiosImplCopyWithImpl(
      _$FinancialRatiosImpl _value, $Res Function(_$FinancialRatiosImpl) _then)
      : super(_value, _then);

  /// Create a copy of FinancialRatios
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentRatio = null,
    Object? quickRatio = null,
    Object? cashRatio = null,
    Object? debtToEquityRatio = null,
    Object? debtToAssetsRatio = null,
    Object? equityMultiplier = null,
    Object? assetTurnover = null,
    Object? inventoryTurnover = null,
    Object? receivablesTurnover = null,
    Object? returnOnAssets = null,
    Object? returnOnEquity = null,
    Object? grossProfitMargin = null,
    Object? netProfitMargin = null,
  }) {
    return _then(_$FinancialRatiosImpl(
      currentRatio: null == currentRatio
          ? _value.currentRatio
          : currentRatio // ignore: cast_nullable_to_non_nullable
              as double,
      quickRatio: null == quickRatio
          ? _value.quickRatio
          : quickRatio // ignore: cast_nullable_to_non_nullable
              as double,
      cashRatio: null == cashRatio
          ? _value.cashRatio
          : cashRatio // ignore: cast_nullable_to_non_nullable
              as double,
      debtToEquityRatio: null == debtToEquityRatio
          ? _value.debtToEquityRatio
          : debtToEquityRatio // ignore: cast_nullable_to_non_nullable
              as double,
      debtToAssetsRatio: null == debtToAssetsRatio
          ? _value.debtToAssetsRatio
          : debtToAssetsRatio // ignore: cast_nullable_to_non_nullable
              as double,
      equityMultiplier: null == equityMultiplier
          ? _value.equityMultiplier
          : equityMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      assetTurnover: null == assetTurnover
          ? _value.assetTurnover
          : assetTurnover // ignore: cast_nullable_to_non_nullable
              as double,
      inventoryTurnover: null == inventoryTurnover
          ? _value.inventoryTurnover
          : inventoryTurnover // ignore: cast_nullable_to_non_nullable
              as double,
      receivablesTurnover: null == receivablesTurnover
          ? _value.receivablesTurnover
          : receivablesTurnover // ignore: cast_nullable_to_non_nullable
              as double,
      returnOnAssets: null == returnOnAssets
          ? _value.returnOnAssets
          : returnOnAssets // ignore: cast_nullable_to_non_nullable
              as double,
      returnOnEquity: null == returnOnEquity
          ? _value.returnOnEquity
          : returnOnEquity // ignore: cast_nullable_to_non_nullable
              as double,
      grossProfitMargin: null == grossProfitMargin
          ? _value.grossProfitMargin
          : grossProfitMargin // ignore: cast_nullable_to_non_nullable
              as double,
      netProfitMargin: null == netProfitMargin
          ? _value.netProfitMargin
          : netProfitMargin // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialRatiosImpl implements _FinancialRatios {
  const _$FinancialRatiosImpl(
      {required this.currentRatio,
      required this.quickRatio,
      required this.cashRatio,
      required this.debtToEquityRatio,
      required this.debtToAssetsRatio,
      required this.equityMultiplier,
      required this.assetTurnover,
      required this.inventoryTurnover,
      required this.receivablesTurnover,
      required this.returnOnAssets,
      required this.returnOnEquity,
      required this.grossProfitMargin,
      required this.netProfitMargin});

  factory _$FinancialRatiosImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialRatiosImplFromJson(json);

// Liquidity Ratios
  @override
  final double currentRatio;
  @override
  final double quickRatio;
  @override
  final double cashRatio;
// Leverage Ratios
  @override
  final double debtToEquityRatio;
  @override
  final double debtToAssetsRatio;
  @override
  final double equityMultiplier;
// Efficiency Ratios
  @override
  final double assetTurnover;
  @override
  final double inventoryTurnover;
  @override
  final double receivablesTurnover;
// Profitability Ratios
  @override
  final double returnOnAssets;
  @override
  final double returnOnEquity;
  @override
  final double grossProfitMargin;
  @override
  final double netProfitMargin;

  @override
  String toString() {
    return 'FinancialRatios(currentRatio: $currentRatio, quickRatio: $quickRatio, cashRatio: $cashRatio, debtToEquityRatio: $debtToEquityRatio, debtToAssetsRatio: $debtToAssetsRatio, equityMultiplier: $equityMultiplier, assetTurnover: $assetTurnover, inventoryTurnover: $inventoryTurnover, receivablesTurnover: $receivablesTurnover, returnOnAssets: $returnOnAssets, returnOnEquity: $returnOnEquity, grossProfitMargin: $grossProfitMargin, netProfitMargin: $netProfitMargin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialRatiosImpl &&
            (identical(other.currentRatio, currentRatio) ||
                other.currentRatio == currentRatio) &&
            (identical(other.quickRatio, quickRatio) ||
                other.quickRatio == quickRatio) &&
            (identical(other.cashRatio, cashRatio) ||
                other.cashRatio == cashRatio) &&
            (identical(other.debtToEquityRatio, debtToEquityRatio) ||
                other.debtToEquityRatio == debtToEquityRatio) &&
            (identical(other.debtToAssetsRatio, debtToAssetsRatio) ||
                other.debtToAssetsRatio == debtToAssetsRatio) &&
            (identical(other.equityMultiplier, equityMultiplier) ||
                other.equityMultiplier == equityMultiplier) &&
            (identical(other.assetTurnover, assetTurnover) ||
                other.assetTurnover == assetTurnover) &&
            (identical(other.inventoryTurnover, inventoryTurnover) ||
                other.inventoryTurnover == inventoryTurnover) &&
            (identical(other.receivablesTurnover, receivablesTurnover) ||
                other.receivablesTurnover == receivablesTurnover) &&
            (identical(other.returnOnAssets, returnOnAssets) ||
                other.returnOnAssets == returnOnAssets) &&
            (identical(other.returnOnEquity, returnOnEquity) ||
                other.returnOnEquity == returnOnEquity) &&
            (identical(other.grossProfitMargin, grossProfitMargin) ||
                other.grossProfitMargin == grossProfitMargin) &&
            (identical(other.netProfitMargin, netProfitMargin) ||
                other.netProfitMargin == netProfitMargin));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentRatio,
      quickRatio,
      cashRatio,
      debtToEquityRatio,
      debtToAssetsRatio,
      equityMultiplier,
      assetTurnover,
      inventoryTurnover,
      receivablesTurnover,
      returnOnAssets,
      returnOnEquity,
      grossProfitMargin,
      netProfitMargin);

  /// Create a copy of FinancialRatios
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialRatiosImplCopyWith<_$FinancialRatiosImpl> get copyWith =>
      __$$FinancialRatiosImplCopyWithImpl<_$FinancialRatiosImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialRatiosImplToJson(
      this,
    );
  }
}

abstract class _FinancialRatios implements FinancialRatios {
  const factory _FinancialRatios(
      {required final double currentRatio,
      required final double quickRatio,
      required final double cashRatio,
      required final double debtToEquityRatio,
      required final double debtToAssetsRatio,
      required final double equityMultiplier,
      required final double assetTurnover,
      required final double inventoryTurnover,
      required final double receivablesTurnover,
      required final double returnOnAssets,
      required final double returnOnEquity,
      required final double grossProfitMargin,
      required final double netProfitMargin}) = _$FinancialRatiosImpl;

  factory _FinancialRatios.fromJson(Map<String, dynamic> json) =
      _$FinancialRatiosImpl.fromJson;

// Liquidity Ratios
  @override
  double get currentRatio;
  @override
  double get quickRatio;
  @override
  double get cashRatio; // Leverage Ratios
  @override
  double get debtToEquityRatio;
  @override
  double get debtToAssetsRatio;
  @override
  double get equityMultiplier; // Efficiency Ratios
  @override
  double get assetTurnover;
  @override
  double get inventoryTurnover;
  @override
  double get receivablesTurnover; // Profitability Ratios
  @override
  double get returnOnAssets;
  @override
  double get returnOnEquity;
  @override
  double get grossProfitMargin;
  @override
  double get netProfitMargin;

  /// Create a copy of FinancialRatios
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinancialRatiosImplCopyWith<_$FinancialRatiosImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
