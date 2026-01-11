// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_hub.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AnalyticsSummaryCard {
  String get title => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'good', 'warning', 'critical', 'insufficient'
  String get statusText => throw _privateConstructorUsedError;
  String get primaryMetric => throw _privateConstructorUsedError;
  String? get secondaryMetric => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsSummaryCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsSummaryCardCopyWith<AnalyticsSummaryCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsSummaryCardCopyWith<$Res> {
  factory $AnalyticsSummaryCardCopyWith(AnalyticsSummaryCard value,
          $Res Function(AnalyticsSummaryCard) then) =
      _$AnalyticsSummaryCardCopyWithImpl<$Res, AnalyticsSummaryCard>;
  @useResult
  $Res call(
      {String title,
      String status,
      String statusText,
      String primaryMetric,
      String? secondaryMetric});
}

/// @nodoc
class _$AnalyticsSummaryCardCopyWithImpl<$Res,
        $Val extends AnalyticsSummaryCard>
    implements $AnalyticsSummaryCardCopyWith<$Res> {
  _$AnalyticsSummaryCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsSummaryCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? status = null,
    Object? statusText = null,
    Object? primaryMetric = null,
    Object? secondaryMetric = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      statusText: null == statusText
          ? _value.statusText
          : statusText // ignore: cast_nullable_to_non_nullable
              as String,
      primaryMetric: null == primaryMetric
          ? _value.primaryMetric
          : primaryMetric // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryMetric: freezed == secondaryMetric
          ? _value.secondaryMetric
          : secondaryMetric // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnalyticsSummaryCardImplCopyWith<$Res>
    implements $AnalyticsSummaryCardCopyWith<$Res> {
  factory _$$AnalyticsSummaryCardImplCopyWith(_$AnalyticsSummaryCardImpl value,
          $Res Function(_$AnalyticsSummaryCardImpl) then) =
      __$$AnalyticsSummaryCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String status,
      String statusText,
      String primaryMetric,
      String? secondaryMetric});
}

/// @nodoc
class __$$AnalyticsSummaryCardImplCopyWithImpl<$Res>
    extends _$AnalyticsSummaryCardCopyWithImpl<$Res, _$AnalyticsSummaryCardImpl>
    implements _$$AnalyticsSummaryCardImplCopyWith<$Res> {
  __$$AnalyticsSummaryCardImplCopyWithImpl(_$AnalyticsSummaryCardImpl _value,
      $Res Function(_$AnalyticsSummaryCardImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnalyticsSummaryCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? status = null,
    Object? statusText = null,
    Object? primaryMetric = null,
    Object? secondaryMetric = freezed,
  }) {
    return _then(_$AnalyticsSummaryCardImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      statusText: null == statusText
          ? _value.statusText
          : statusText // ignore: cast_nullable_to_non_nullable
              as String,
      primaryMetric: null == primaryMetric
          ? _value.primaryMetric
          : primaryMetric // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryMetric: freezed == secondaryMetric
          ? _value.secondaryMetric
          : secondaryMetric // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AnalyticsSummaryCardImpl implements _AnalyticsSummaryCard {
  const _$AnalyticsSummaryCardImpl(
      {required this.title,
      required this.status,
      required this.statusText,
      required this.primaryMetric,
      this.secondaryMetric});

  @override
  final String title;
  @override
  final String status;
// 'good', 'warning', 'critical', 'insufficient'
  @override
  final String statusText;
  @override
  final String primaryMetric;
  @override
  final String? secondaryMetric;

  @override
  String toString() {
    return 'AnalyticsSummaryCard(title: $title, status: $status, statusText: $statusText, primaryMetric: $primaryMetric, secondaryMetric: $secondaryMetric)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsSummaryCardImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusText, statusText) ||
                other.statusText == statusText) &&
            (identical(other.primaryMetric, primaryMetric) ||
                other.primaryMetric == primaryMetric) &&
            (identical(other.secondaryMetric, secondaryMetric) ||
                other.secondaryMetric == secondaryMetric));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, title, status, statusText, primaryMetric, secondaryMetric);

  /// Create a copy of AnalyticsSummaryCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsSummaryCardImplCopyWith<_$AnalyticsSummaryCardImpl>
      get copyWith =>
          __$$AnalyticsSummaryCardImplCopyWithImpl<_$AnalyticsSummaryCardImpl>(
              this, _$identity);
}

abstract class _AnalyticsSummaryCard implements AnalyticsSummaryCard {
  const factory _AnalyticsSummaryCard(
      {required final String title,
      required final String status,
      required final String statusText,
      required final String primaryMetric,
      final String? secondaryMetric}) = _$AnalyticsSummaryCardImpl;

  @override
  String get title;
  @override
  String get status; // 'good', 'warning', 'critical', 'insufficient'
  @override
  String get statusText;
  @override
  String get primaryMetric;
  @override
  String? get secondaryMetric;

  /// Create a copy of AnalyticsSummaryCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsSummaryCardImplCopyWith<_$AnalyticsSummaryCardImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AnalyticsHubData {
  SalesDashboard? get salesDashboard => throw _privateConstructorUsedError;
  SupplyChainStatus? get supplyChainStatus =>
      throw _privateConstructorUsedError;
  DiscrepancyOverview? get discrepancyOverview =>
      throw _privateConstructorUsedError;
  InventoryOptimization? get inventoryOptimization =>
      throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsHubData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsHubDataCopyWith<AnalyticsHubData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsHubDataCopyWith<$Res> {
  factory $AnalyticsHubDataCopyWith(
          AnalyticsHubData value, $Res Function(AnalyticsHubData) then) =
      _$AnalyticsHubDataCopyWithImpl<$Res, AnalyticsHubData>;
  @useResult
  $Res call(
      {SalesDashboard? salesDashboard,
      SupplyChainStatus? supplyChainStatus,
      DiscrepancyOverview? discrepancyOverview,
      InventoryOptimization? inventoryOptimization});

  $SalesDashboardCopyWith<$Res>? get salesDashboard;
  $SupplyChainStatusCopyWith<$Res>? get supplyChainStatus;
  $DiscrepancyOverviewCopyWith<$Res>? get discrepancyOverview;
  $InventoryOptimizationCopyWith<$Res>? get inventoryOptimization;
}

/// @nodoc
class _$AnalyticsHubDataCopyWithImpl<$Res, $Val extends AnalyticsHubData>
    implements $AnalyticsHubDataCopyWith<$Res> {
  _$AnalyticsHubDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsHubData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? salesDashboard = freezed,
    Object? supplyChainStatus = freezed,
    Object? discrepancyOverview = freezed,
    Object? inventoryOptimization = freezed,
  }) {
    return _then(_value.copyWith(
      salesDashboard: freezed == salesDashboard
          ? _value.salesDashboard
          : salesDashboard // ignore: cast_nullable_to_non_nullable
              as SalesDashboard?,
      supplyChainStatus: freezed == supplyChainStatus
          ? _value.supplyChainStatus
          : supplyChainStatus // ignore: cast_nullable_to_non_nullable
              as SupplyChainStatus?,
      discrepancyOverview: freezed == discrepancyOverview
          ? _value.discrepancyOverview
          : discrepancyOverview // ignore: cast_nullable_to_non_nullable
              as DiscrepancyOverview?,
      inventoryOptimization: freezed == inventoryOptimization
          ? _value.inventoryOptimization
          : inventoryOptimization // ignore: cast_nullable_to_non_nullable
              as InventoryOptimization?,
    ) as $Val);
  }

  /// Create a copy of AnalyticsHubData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SalesDashboardCopyWith<$Res>? get salesDashboard {
    if (_value.salesDashboard == null) {
      return null;
    }

    return $SalesDashboardCopyWith<$Res>(_value.salesDashboard!, (value) {
      return _then(_value.copyWith(salesDashboard: value) as $Val);
    });
  }

  /// Create a copy of AnalyticsHubData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SupplyChainStatusCopyWith<$Res>? get supplyChainStatus {
    if (_value.supplyChainStatus == null) {
      return null;
    }

    return $SupplyChainStatusCopyWith<$Res>(_value.supplyChainStatus!, (value) {
      return _then(_value.copyWith(supplyChainStatus: value) as $Val);
    });
  }

  /// Create a copy of AnalyticsHubData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DiscrepancyOverviewCopyWith<$Res>? get discrepancyOverview {
    if (_value.discrepancyOverview == null) {
      return null;
    }

    return $DiscrepancyOverviewCopyWith<$Res>(_value.discrepancyOverview!,
        (value) {
      return _then(_value.copyWith(discrepancyOverview: value) as $Val);
    });
  }

  /// Create a copy of AnalyticsHubData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InventoryOptimizationCopyWith<$Res>? get inventoryOptimization {
    if (_value.inventoryOptimization == null) {
      return null;
    }

    return $InventoryOptimizationCopyWith<$Res>(_value.inventoryOptimization!,
        (value) {
      return _then(_value.copyWith(inventoryOptimization: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnalyticsHubDataImplCopyWith<$Res>
    implements $AnalyticsHubDataCopyWith<$Res> {
  factory _$$AnalyticsHubDataImplCopyWith(_$AnalyticsHubDataImpl value,
          $Res Function(_$AnalyticsHubDataImpl) then) =
      __$$AnalyticsHubDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SalesDashboard? salesDashboard,
      SupplyChainStatus? supplyChainStatus,
      DiscrepancyOverview? discrepancyOverview,
      InventoryOptimization? inventoryOptimization});

  @override
  $SalesDashboardCopyWith<$Res>? get salesDashboard;
  @override
  $SupplyChainStatusCopyWith<$Res>? get supplyChainStatus;
  @override
  $DiscrepancyOverviewCopyWith<$Res>? get discrepancyOverview;
  @override
  $InventoryOptimizationCopyWith<$Res>? get inventoryOptimization;
}

/// @nodoc
class __$$AnalyticsHubDataImplCopyWithImpl<$Res>
    extends _$AnalyticsHubDataCopyWithImpl<$Res, _$AnalyticsHubDataImpl>
    implements _$$AnalyticsHubDataImplCopyWith<$Res> {
  __$$AnalyticsHubDataImplCopyWithImpl(_$AnalyticsHubDataImpl _value,
      $Res Function(_$AnalyticsHubDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnalyticsHubData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? salesDashboard = freezed,
    Object? supplyChainStatus = freezed,
    Object? discrepancyOverview = freezed,
    Object? inventoryOptimization = freezed,
  }) {
    return _then(_$AnalyticsHubDataImpl(
      salesDashboard: freezed == salesDashboard
          ? _value.salesDashboard
          : salesDashboard // ignore: cast_nullable_to_non_nullable
              as SalesDashboard?,
      supplyChainStatus: freezed == supplyChainStatus
          ? _value.supplyChainStatus
          : supplyChainStatus // ignore: cast_nullable_to_non_nullable
              as SupplyChainStatus?,
      discrepancyOverview: freezed == discrepancyOverview
          ? _value.discrepancyOverview
          : discrepancyOverview // ignore: cast_nullable_to_non_nullable
              as DiscrepancyOverview?,
      inventoryOptimization: freezed == inventoryOptimization
          ? _value.inventoryOptimization
          : inventoryOptimization // ignore: cast_nullable_to_non_nullable
              as InventoryOptimization?,
    ));
  }
}

/// @nodoc

class _$AnalyticsHubDataImpl extends _AnalyticsHubData {
  const _$AnalyticsHubDataImpl(
      {required this.salesDashboard,
      required this.supplyChainStatus,
      required this.discrepancyOverview,
      required this.inventoryOptimization})
      : super._();

  @override
  final SalesDashboard? salesDashboard;
  @override
  final SupplyChainStatus? supplyChainStatus;
  @override
  final DiscrepancyOverview? discrepancyOverview;
  @override
  final InventoryOptimization? inventoryOptimization;

  @override
  String toString() {
    return 'AnalyticsHubData(salesDashboard: $salesDashboard, supplyChainStatus: $supplyChainStatus, discrepancyOverview: $discrepancyOverview, inventoryOptimization: $inventoryOptimization)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsHubDataImpl &&
            (identical(other.salesDashboard, salesDashboard) ||
                other.salesDashboard == salesDashboard) &&
            (identical(other.supplyChainStatus, supplyChainStatus) ||
                other.supplyChainStatus == supplyChainStatus) &&
            (identical(other.discrepancyOverview, discrepancyOverview) ||
                other.discrepancyOverview == discrepancyOverview) &&
            (identical(other.inventoryOptimization, inventoryOptimization) ||
                other.inventoryOptimization == inventoryOptimization));
  }

  @override
  int get hashCode => Object.hash(runtimeType, salesDashboard,
      supplyChainStatus, discrepancyOverview, inventoryOptimization);

  /// Create a copy of AnalyticsHubData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsHubDataImplCopyWith<_$AnalyticsHubDataImpl> get copyWith =>
      __$$AnalyticsHubDataImplCopyWithImpl<_$AnalyticsHubDataImpl>(
          this, _$identity);
}

abstract class _AnalyticsHubData extends AnalyticsHubData {
  const factory _AnalyticsHubData(
          {required final SalesDashboard? salesDashboard,
          required final SupplyChainStatus? supplyChainStatus,
          required final DiscrepancyOverview? discrepancyOverview,
          required final InventoryOptimization? inventoryOptimization}) =
      _$AnalyticsHubDataImpl;
  const _AnalyticsHubData._() : super._();

  @override
  SalesDashboard? get salesDashboard;
  @override
  SupplyChainStatus? get supplyChainStatus;
  @override
  DiscrepancyOverview? get discrepancyOverview;
  @override
  InventoryOptimization? get inventoryOptimization;

  /// Create a copy of AnalyticsHubData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsHubDataImplCopyWith<_$AnalyticsHubDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
