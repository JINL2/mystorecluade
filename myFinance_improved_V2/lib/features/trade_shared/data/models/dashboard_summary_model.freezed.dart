// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DashboardSummaryModel _$DashboardSummaryModelFromJson(
    Map<String, dynamic> json) {
  return _DashboardSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$DashboardSummaryModel {
  DashboardOverviewModel get overview => throw _privateConstructorUsedError;
  @JsonKey(name: 'by_status')
  Map<String, Map<String, int>> get byStatus =>
      throw _privateConstructorUsedError;
  DashboardAlertSummaryModel get alerts => throw _privateConstructorUsedError;
  @JsonKey(name: 'recent_activities')
  List<RecentActivityModel> get recentActivities =>
      throw _privateConstructorUsedError;

  /// Serializes this DashboardSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardSummaryModelCopyWith<DashboardSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardSummaryModelCopyWith<$Res> {
  factory $DashboardSummaryModelCopyWith(DashboardSummaryModel value,
          $Res Function(DashboardSummaryModel) then) =
      _$DashboardSummaryModelCopyWithImpl<$Res, DashboardSummaryModel>;
  @useResult
  $Res call(
      {DashboardOverviewModel overview,
      @JsonKey(name: 'by_status') Map<String, Map<String, int>> byStatus,
      DashboardAlertSummaryModel alerts,
      @JsonKey(name: 'recent_activities')
      List<RecentActivityModel> recentActivities});

  $DashboardOverviewModelCopyWith<$Res> get overview;
  $DashboardAlertSummaryModelCopyWith<$Res> get alerts;
}

/// @nodoc
class _$DashboardSummaryModelCopyWithImpl<$Res,
        $Val extends DashboardSummaryModel>
    implements $DashboardSummaryModelCopyWith<$Res> {
  _$DashboardSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overview = null,
    Object? byStatus = null,
    Object? alerts = null,
    Object? recentActivities = null,
  }) {
    return _then(_value.copyWith(
      overview: null == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as DashboardOverviewModel,
      byStatus: null == byStatus
          ? _value.byStatus
          : byStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, Map<String, int>>,
      alerts: null == alerts
          ? _value.alerts
          : alerts // ignore: cast_nullable_to_non_nullable
              as DashboardAlertSummaryModel,
      recentActivities: null == recentActivities
          ? _value.recentActivities
          : recentActivities // ignore: cast_nullable_to_non_nullable
              as List<RecentActivityModel>,
    ) as $Val);
  }

  /// Create a copy of DashboardSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DashboardOverviewModelCopyWith<$Res> get overview {
    return $DashboardOverviewModelCopyWith<$Res>(_value.overview, (value) {
      return _then(_value.copyWith(overview: value) as $Val);
    });
  }

  /// Create a copy of DashboardSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DashboardAlertSummaryModelCopyWith<$Res> get alerts {
    return $DashboardAlertSummaryModelCopyWith<$Res>(_value.alerts, (value) {
      return _then(_value.copyWith(alerts: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DashboardSummaryModelImplCopyWith<$Res>
    implements $DashboardSummaryModelCopyWith<$Res> {
  factory _$$DashboardSummaryModelImplCopyWith(
          _$DashboardSummaryModelImpl value,
          $Res Function(_$DashboardSummaryModelImpl) then) =
      __$$DashboardSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DashboardOverviewModel overview,
      @JsonKey(name: 'by_status') Map<String, Map<String, int>> byStatus,
      DashboardAlertSummaryModel alerts,
      @JsonKey(name: 'recent_activities')
      List<RecentActivityModel> recentActivities});

  @override
  $DashboardOverviewModelCopyWith<$Res> get overview;
  @override
  $DashboardAlertSummaryModelCopyWith<$Res> get alerts;
}

/// @nodoc
class __$$DashboardSummaryModelImplCopyWithImpl<$Res>
    extends _$DashboardSummaryModelCopyWithImpl<$Res,
        _$DashboardSummaryModelImpl>
    implements _$$DashboardSummaryModelImplCopyWith<$Res> {
  __$$DashboardSummaryModelImplCopyWithImpl(_$DashboardSummaryModelImpl _value,
      $Res Function(_$DashboardSummaryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overview = null,
    Object? byStatus = null,
    Object? alerts = null,
    Object? recentActivities = null,
  }) {
    return _then(_$DashboardSummaryModelImpl(
      overview: null == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as DashboardOverviewModel,
      byStatus: null == byStatus
          ? _value._byStatus
          : byStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, Map<String, int>>,
      alerts: null == alerts
          ? _value.alerts
          : alerts // ignore: cast_nullable_to_non_nullable
              as DashboardAlertSummaryModel,
      recentActivities: null == recentActivities
          ? _value._recentActivities
          : recentActivities // ignore: cast_nullable_to_non_nullable
              as List<RecentActivityModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardSummaryModelImpl extends _DashboardSummaryModel {
  const _$DashboardSummaryModelImpl(
      {required this.overview,
      @JsonKey(name: 'by_status')
      final Map<String, Map<String, int>> byStatus = const {},
      required this.alerts,
      @JsonKey(name: 'recent_activities')
      final List<RecentActivityModel> recentActivities = const []})
      : _byStatus = byStatus,
        _recentActivities = recentActivities,
        super._();

  factory _$DashboardSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardSummaryModelImplFromJson(json);

  @override
  final DashboardOverviewModel overview;
  final Map<String, Map<String, int>> _byStatus;
  @override
  @JsonKey(name: 'by_status')
  Map<String, Map<String, int>> get byStatus {
    if (_byStatus is EqualUnmodifiableMapView) return _byStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_byStatus);
  }

  @override
  final DashboardAlertSummaryModel alerts;
  final List<RecentActivityModel> _recentActivities;
  @override
  @JsonKey(name: 'recent_activities')
  List<RecentActivityModel> get recentActivities {
    if (_recentActivities is EqualUnmodifiableListView)
      return _recentActivities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentActivities);
  }

  @override
  String toString() {
    return 'DashboardSummaryModel(overview: $overview, byStatus: $byStatus, alerts: $alerts, recentActivities: $recentActivities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardSummaryModelImpl &&
            (identical(other.overview, overview) ||
                other.overview == overview) &&
            const DeepCollectionEquality().equals(other._byStatus, _byStatus) &&
            (identical(other.alerts, alerts) || other.alerts == alerts) &&
            const DeepCollectionEquality()
                .equals(other._recentActivities, _recentActivities));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      overview,
      const DeepCollectionEquality().hash(_byStatus),
      alerts,
      const DeepCollectionEquality().hash(_recentActivities));

  /// Create a copy of DashboardSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardSummaryModelImplCopyWith<_$DashboardSummaryModelImpl>
      get copyWith => __$$DashboardSummaryModelImplCopyWithImpl<
          _$DashboardSummaryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardSummaryModelImplToJson(
      this,
    );
  }
}

abstract class _DashboardSummaryModel extends DashboardSummaryModel {
  const factory _DashboardSummaryModel(
      {required final DashboardOverviewModel overview,
      @JsonKey(name: 'by_status') final Map<String, Map<String, int>> byStatus,
      required final DashboardAlertSummaryModel alerts,
      @JsonKey(name: 'recent_activities')
      final List<RecentActivityModel>
          recentActivities}) = _$DashboardSummaryModelImpl;
  const _DashboardSummaryModel._() : super._();

  factory _DashboardSummaryModel.fromJson(Map<String, dynamic> json) =
      _$DashboardSummaryModelImpl.fromJson;

  @override
  DashboardOverviewModel get overview;
  @override
  @JsonKey(name: 'by_status')
  Map<String, Map<String, int>> get byStatus;
  @override
  DashboardAlertSummaryModel get alerts;
  @override
  @JsonKey(name: 'recent_activities')
  List<RecentActivityModel> get recentActivities;

  /// Create a copy of DashboardSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardSummaryModelImplCopyWith<_$DashboardSummaryModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

DashboardOverviewModel _$DashboardOverviewModelFromJson(
    Map<String, dynamic> json) {
  return _DashboardOverviewModel.fromJson(json);
}

/// @nodoc
mixin _$DashboardOverviewModel {
// Document counts
  @JsonKey(name: 'total_pi_count')
  int get totalPICount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_po_count')
  int get totalPOCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_lc_count')
  int get totalLCCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_shipment_count')
  int get totalShipmentCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_ci_count')
  int get totalCICount => throw _privateConstructorUsedError; // Active counts
  @JsonKey(name: 'active_pos')
  int get activePOs => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_lcs')
  int get activeLCs => throw _privateConstructorUsedError;
  @JsonKey(name: 'pending_shipments')
  int get pendingShipments => throw _privateConstructorUsedError;
  @JsonKey(name: 'in_transit_count')
  int get inTransitCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'pending_payments')
  int get pendingPayments =>
      throw _privateConstructorUsedError; // Amount totals
  @JsonKey(name: 'total_trade_volume')
  double get totalTradeVolume => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_lc_value')
  double get totalLCValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_received')
  double get totalReceived => throw _privateConstructorUsedError;
  @JsonKey(name: 'pending_payment_amount')
  double get pendingPaymentAmount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;

  /// Serializes this DashboardOverviewModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardOverviewModelCopyWith<DashboardOverviewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardOverviewModelCopyWith<$Res> {
  factory $DashboardOverviewModelCopyWith(DashboardOverviewModel value,
          $Res Function(DashboardOverviewModel) then) =
      _$DashboardOverviewModelCopyWithImpl<$Res, DashboardOverviewModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_pi_count') int totalPICount,
      @JsonKey(name: 'total_po_count') int totalPOCount,
      @JsonKey(name: 'total_lc_count') int totalLCCount,
      @JsonKey(name: 'total_shipment_count') int totalShipmentCount,
      @JsonKey(name: 'total_ci_count') int totalCICount,
      @JsonKey(name: 'active_pos') int activePOs,
      @JsonKey(name: 'active_lcs') int activeLCs,
      @JsonKey(name: 'pending_shipments') int pendingShipments,
      @JsonKey(name: 'in_transit_count') int inTransitCount,
      @JsonKey(name: 'pending_payments') int pendingPayments,
      @JsonKey(name: 'total_trade_volume') double totalTradeVolume,
      @JsonKey(name: 'total_lc_value') double totalLCValue,
      @JsonKey(name: 'total_received') double totalReceived,
      @JsonKey(name: 'pending_payment_amount') double pendingPaymentAmount,
      String currency});
}

/// @nodoc
class _$DashboardOverviewModelCopyWithImpl<$Res,
        $Val extends DashboardOverviewModel>
    implements $DashboardOverviewModelCopyWith<$Res> {
  _$DashboardOverviewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPICount = null,
    Object? totalPOCount = null,
    Object? totalLCCount = null,
    Object? totalShipmentCount = null,
    Object? totalCICount = null,
    Object? activePOs = null,
    Object? activeLCs = null,
    Object? pendingShipments = null,
    Object? inTransitCount = null,
    Object? pendingPayments = null,
    Object? totalTradeVolume = null,
    Object? totalLCValue = null,
    Object? totalReceived = null,
    Object? pendingPaymentAmount = null,
    Object? currency = null,
  }) {
    return _then(_value.copyWith(
      totalPICount: null == totalPICount
          ? _value.totalPICount
          : totalPICount // ignore: cast_nullable_to_non_nullable
              as int,
      totalPOCount: null == totalPOCount
          ? _value.totalPOCount
          : totalPOCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalLCCount: null == totalLCCount
          ? _value.totalLCCount
          : totalLCCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalShipmentCount: null == totalShipmentCount
          ? _value.totalShipmentCount
          : totalShipmentCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalCICount: null == totalCICount
          ? _value.totalCICount
          : totalCICount // ignore: cast_nullable_to_non_nullable
              as int,
      activePOs: null == activePOs
          ? _value.activePOs
          : activePOs // ignore: cast_nullable_to_non_nullable
              as int,
      activeLCs: null == activeLCs
          ? _value.activeLCs
          : activeLCs // ignore: cast_nullable_to_non_nullable
              as int,
      pendingShipments: null == pendingShipments
          ? _value.pendingShipments
          : pendingShipments // ignore: cast_nullable_to_non_nullable
              as int,
      inTransitCount: null == inTransitCount
          ? _value.inTransitCount
          : inTransitCount // ignore: cast_nullable_to_non_nullable
              as int,
      pendingPayments: null == pendingPayments
          ? _value.pendingPayments
          : pendingPayments // ignore: cast_nullable_to_non_nullable
              as int,
      totalTradeVolume: null == totalTradeVolume
          ? _value.totalTradeVolume
          : totalTradeVolume // ignore: cast_nullable_to_non_nullable
              as double,
      totalLCValue: null == totalLCValue
          ? _value.totalLCValue
          : totalLCValue // ignore: cast_nullable_to_non_nullable
              as double,
      totalReceived: null == totalReceived
          ? _value.totalReceived
          : totalReceived // ignore: cast_nullable_to_non_nullable
              as double,
      pendingPaymentAmount: null == pendingPaymentAmount
          ? _value.pendingPaymentAmount
          : pendingPaymentAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DashboardOverviewModelImplCopyWith<$Res>
    implements $DashboardOverviewModelCopyWith<$Res> {
  factory _$$DashboardOverviewModelImplCopyWith(
          _$DashboardOverviewModelImpl value,
          $Res Function(_$DashboardOverviewModelImpl) then) =
      __$$DashboardOverviewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_pi_count') int totalPICount,
      @JsonKey(name: 'total_po_count') int totalPOCount,
      @JsonKey(name: 'total_lc_count') int totalLCCount,
      @JsonKey(name: 'total_shipment_count') int totalShipmentCount,
      @JsonKey(name: 'total_ci_count') int totalCICount,
      @JsonKey(name: 'active_pos') int activePOs,
      @JsonKey(name: 'active_lcs') int activeLCs,
      @JsonKey(name: 'pending_shipments') int pendingShipments,
      @JsonKey(name: 'in_transit_count') int inTransitCount,
      @JsonKey(name: 'pending_payments') int pendingPayments,
      @JsonKey(name: 'total_trade_volume') double totalTradeVolume,
      @JsonKey(name: 'total_lc_value') double totalLCValue,
      @JsonKey(name: 'total_received') double totalReceived,
      @JsonKey(name: 'pending_payment_amount') double pendingPaymentAmount,
      String currency});
}

/// @nodoc
class __$$DashboardOverviewModelImplCopyWithImpl<$Res>
    extends _$DashboardOverviewModelCopyWithImpl<$Res,
        _$DashboardOverviewModelImpl>
    implements _$$DashboardOverviewModelImplCopyWith<$Res> {
  __$$DashboardOverviewModelImplCopyWithImpl(
      _$DashboardOverviewModelImpl _value,
      $Res Function(_$DashboardOverviewModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPICount = null,
    Object? totalPOCount = null,
    Object? totalLCCount = null,
    Object? totalShipmentCount = null,
    Object? totalCICount = null,
    Object? activePOs = null,
    Object? activeLCs = null,
    Object? pendingShipments = null,
    Object? inTransitCount = null,
    Object? pendingPayments = null,
    Object? totalTradeVolume = null,
    Object? totalLCValue = null,
    Object? totalReceived = null,
    Object? pendingPaymentAmount = null,
    Object? currency = null,
  }) {
    return _then(_$DashboardOverviewModelImpl(
      totalPICount: null == totalPICount
          ? _value.totalPICount
          : totalPICount // ignore: cast_nullable_to_non_nullable
              as int,
      totalPOCount: null == totalPOCount
          ? _value.totalPOCount
          : totalPOCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalLCCount: null == totalLCCount
          ? _value.totalLCCount
          : totalLCCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalShipmentCount: null == totalShipmentCount
          ? _value.totalShipmentCount
          : totalShipmentCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalCICount: null == totalCICount
          ? _value.totalCICount
          : totalCICount // ignore: cast_nullable_to_non_nullable
              as int,
      activePOs: null == activePOs
          ? _value.activePOs
          : activePOs // ignore: cast_nullable_to_non_nullable
              as int,
      activeLCs: null == activeLCs
          ? _value.activeLCs
          : activeLCs // ignore: cast_nullable_to_non_nullable
              as int,
      pendingShipments: null == pendingShipments
          ? _value.pendingShipments
          : pendingShipments // ignore: cast_nullable_to_non_nullable
              as int,
      inTransitCount: null == inTransitCount
          ? _value.inTransitCount
          : inTransitCount // ignore: cast_nullable_to_non_nullable
              as int,
      pendingPayments: null == pendingPayments
          ? _value.pendingPayments
          : pendingPayments // ignore: cast_nullable_to_non_nullable
              as int,
      totalTradeVolume: null == totalTradeVolume
          ? _value.totalTradeVolume
          : totalTradeVolume // ignore: cast_nullable_to_non_nullable
              as double,
      totalLCValue: null == totalLCValue
          ? _value.totalLCValue
          : totalLCValue // ignore: cast_nullable_to_non_nullable
              as double,
      totalReceived: null == totalReceived
          ? _value.totalReceived
          : totalReceived // ignore: cast_nullable_to_non_nullable
              as double,
      pendingPaymentAmount: null == pendingPaymentAmount
          ? _value.pendingPaymentAmount
          : pendingPaymentAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardOverviewModelImpl extends _DashboardOverviewModel {
  const _$DashboardOverviewModelImpl(
      {@JsonKey(name: 'total_pi_count') this.totalPICount = 0,
      @JsonKey(name: 'total_po_count') this.totalPOCount = 0,
      @JsonKey(name: 'total_lc_count') this.totalLCCount = 0,
      @JsonKey(name: 'total_shipment_count') this.totalShipmentCount = 0,
      @JsonKey(name: 'total_ci_count') this.totalCICount = 0,
      @JsonKey(name: 'active_pos') this.activePOs = 0,
      @JsonKey(name: 'active_lcs') this.activeLCs = 0,
      @JsonKey(name: 'pending_shipments') this.pendingShipments = 0,
      @JsonKey(name: 'in_transit_count') this.inTransitCount = 0,
      @JsonKey(name: 'pending_payments') this.pendingPayments = 0,
      @JsonKey(name: 'total_trade_volume') this.totalTradeVolume = 0,
      @JsonKey(name: 'total_lc_value') this.totalLCValue = 0,
      @JsonKey(name: 'total_received') this.totalReceived = 0,
      @JsonKey(name: 'pending_payment_amount') this.pendingPaymentAmount = 0,
      this.currency = 'USD'})
      : super._();

  factory _$DashboardOverviewModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardOverviewModelImplFromJson(json);

// Document counts
  @override
  @JsonKey(name: 'total_pi_count')
  final int totalPICount;
  @override
  @JsonKey(name: 'total_po_count')
  final int totalPOCount;
  @override
  @JsonKey(name: 'total_lc_count')
  final int totalLCCount;
  @override
  @JsonKey(name: 'total_shipment_count')
  final int totalShipmentCount;
  @override
  @JsonKey(name: 'total_ci_count')
  final int totalCICount;
// Active counts
  @override
  @JsonKey(name: 'active_pos')
  final int activePOs;
  @override
  @JsonKey(name: 'active_lcs')
  final int activeLCs;
  @override
  @JsonKey(name: 'pending_shipments')
  final int pendingShipments;
  @override
  @JsonKey(name: 'in_transit_count')
  final int inTransitCount;
  @override
  @JsonKey(name: 'pending_payments')
  final int pendingPayments;
// Amount totals
  @override
  @JsonKey(name: 'total_trade_volume')
  final double totalTradeVolume;
  @override
  @JsonKey(name: 'total_lc_value')
  final double totalLCValue;
  @override
  @JsonKey(name: 'total_received')
  final double totalReceived;
  @override
  @JsonKey(name: 'pending_payment_amount')
  final double pendingPaymentAmount;
  @override
  @JsonKey()
  final String currency;

  @override
  String toString() {
    return 'DashboardOverviewModel(totalPICount: $totalPICount, totalPOCount: $totalPOCount, totalLCCount: $totalLCCount, totalShipmentCount: $totalShipmentCount, totalCICount: $totalCICount, activePOs: $activePOs, activeLCs: $activeLCs, pendingShipments: $pendingShipments, inTransitCount: $inTransitCount, pendingPayments: $pendingPayments, totalTradeVolume: $totalTradeVolume, totalLCValue: $totalLCValue, totalReceived: $totalReceived, pendingPaymentAmount: $pendingPaymentAmount, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardOverviewModelImpl &&
            (identical(other.totalPICount, totalPICount) ||
                other.totalPICount == totalPICount) &&
            (identical(other.totalPOCount, totalPOCount) ||
                other.totalPOCount == totalPOCount) &&
            (identical(other.totalLCCount, totalLCCount) ||
                other.totalLCCount == totalLCCount) &&
            (identical(other.totalShipmentCount, totalShipmentCount) ||
                other.totalShipmentCount == totalShipmentCount) &&
            (identical(other.totalCICount, totalCICount) ||
                other.totalCICount == totalCICount) &&
            (identical(other.activePOs, activePOs) ||
                other.activePOs == activePOs) &&
            (identical(other.activeLCs, activeLCs) ||
                other.activeLCs == activeLCs) &&
            (identical(other.pendingShipments, pendingShipments) ||
                other.pendingShipments == pendingShipments) &&
            (identical(other.inTransitCount, inTransitCount) ||
                other.inTransitCount == inTransitCount) &&
            (identical(other.pendingPayments, pendingPayments) ||
                other.pendingPayments == pendingPayments) &&
            (identical(other.totalTradeVolume, totalTradeVolume) ||
                other.totalTradeVolume == totalTradeVolume) &&
            (identical(other.totalLCValue, totalLCValue) ||
                other.totalLCValue == totalLCValue) &&
            (identical(other.totalReceived, totalReceived) ||
                other.totalReceived == totalReceived) &&
            (identical(other.pendingPaymentAmount, pendingPaymentAmount) ||
                other.pendingPaymentAmount == pendingPaymentAmount) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalPICount,
      totalPOCount,
      totalLCCount,
      totalShipmentCount,
      totalCICount,
      activePOs,
      activeLCs,
      pendingShipments,
      inTransitCount,
      pendingPayments,
      totalTradeVolume,
      totalLCValue,
      totalReceived,
      pendingPaymentAmount,
      currency);

  /// Create a copy of DashboardOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardOverviewModelImplCopyWith<_$DashboardOverviewModelImpl>
      get copyWith => __$$DashboardOverviewModelImplCopyWithImpl<
          _$DashboardOverviewModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardOverviewModelImplToJson(
      this,
    );
  }
}

abstract class _DashboardOverviewModel extends DashboardOverviewModel {
  const factory _DashboardOverviewModel(
      {@JsonKey(name: 'total_pi_count') final int totalPICount,
      @JsonKey(name: 'total_po_count') final int totalPOCount,
      @JsonKey(name: 'total_lc_count') final int totalLCCount,
      @JsonKey(name: 'total_shipment_count') final int totalShipmentCount,
      @JsonKey(name: 'total_ci_count') final int totalCICount,
      @JsonKey(name: 'active_pos') final int activePOs,
      @JsonKey(name: 'active_lcs') final int activeLCs,
      @JsonKey(name: 'pending_shipments') final int pendingShipments,
      @JsonKey(name: 'in_transit_count') final int inTransitCount,
      @JsonKey(name: 'pending_payments') final int pendingPayments,
      @JsonKey(name: 'total_trade_volume') final double totalTradeVolume,
      @JsonKey(name: 'total_lc_value') final double totalLCValue,
      @JsonKey(name: 'total_received') final double totalReceived,
      @JsonKey(name: 'pending_payment_amount')
      final double pendingPaymentAmount,
      final String currency}) = _$DashboardOverviewModelImpl;
  const _DashboardOverviewModel._() : super._();

  factory _DashboardOverviewModel.fromJson(Map<String, dynamic> json) =
      _$DashboardOverviewModelImpl.fromJson;

// Document counts
  @override
  @JsonKey(name: 'total_pi_count')
  int get totalPICount;
  @override
  @JsonKey(name: 'total_po_count')
  int get totalPOCount;
  @override
  @JsonKey(name: 'total_lc_count')
  int get totalLCCount;
  @override
  @JsonKey(name: 'total_shipment_count')
  int get totalShipmentCount;
  @override
  @JsonKey(name: 'total_ci_count')
  int get totalCICount; // Active counts
  @override
  @JsonKey(name: 'active_pos')
  int get activePOs;
  @override
  @JsonKey(name: 'active_lcs')
  int get activeLCs;
  @override
  @JsonKey(name: 'pending_shipments')
  int get pendingShipments;
  @override
  @JsonKey(name: 'in_transit_count')
  int get inTransitCount;
  @override
  @JsonKey(name: 'pending_payments')
  int get pendingPayments; // Amount totals
  @override
  @JsonKey(name: 'total_trade_volume')
  double get totalTradeVolume;
  @override
  @JsonKey(name: 'total_lc_value')
  double get totalLCValue;
  @override
  @JsonKey(name: 'total_received')
  double get totalReceived;
  @override
  @JsonKey(name: 'pending_payment_amount')
  double get pendingPaymentAmount;
  @override
  String get currency;

  /// Create a copy of DashboardOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardOverviewModelImplCopyWith<_$DashboardOverviewModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

DashboardAlertSummaryModel _$DashboardAlertSummaryModelFromJson(
    Map<String, dynamic> json) {
  return _DashboardAlertSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$DashboardAlertSummaryModel {
  @JsonKey(name: 'expiring_lcs')
  int get expiringLCs => throw _privateConstructorUsedError;
  @JsonKey(name: 'overdue_shipments')
  int get overdueShipments => throw _privateConstructorUsedError;
  @JsonKey(name: 'pending_documents')
  int get pendingDocuments => throw _privateConstructorUsedError;
  int get discrepancies => throw _privateConstructorUsedError;
  @JsonKey(name: 'payments_due')
  int get paymentsDue => throw _privateConstructorUsedError;

  /// Serializes this DashboardAlertSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardAlertSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardAlertSummaryModelCopyWith<DashboardAlertSummaryModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardAlertSummaryModelCopyWith<$Res> {
  factory $DashboardAlertSummaryModelCopyWith(DashboardAlertSummaryModel value,
          $Res Function(DashboardAlertSummaryModel) then) =
      _$DashboardAlertSummaryModelCopyWithImpl<$Res,
          DashboardAlertSummaryModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'expiring_lcs') int expiringLCs,
      @JsonKey(name: 'overdue_shipments') int overdueShipments,
      @JsonKey(name: 'pending_documents') int pendingDocuments,
      int discrepancies,
      @JsonKey(name: 'payments_due') int paymentsDue});
}

/// @nodoc
class _$DashboardAlertSummaryModelCopyWithImpl<$Res,
        $Val extends DashboardAlertSummaryModel>
    implements $DashboardAlertSummaryModelCopyWith<$Res> {
  _$DashboardAlertSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardAlertSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expiringLCs = null,
    Object? overdueShipments = null,
    Object? pendingDocuments = null,
    Object? discrepancies = null,
    Object? paymentsDue = null,
  }) {
    return _then(_value.copyWith(
      expiringLCs: null == expiringLCs
          ? _value.expiringLCs
          : expiringLCs // ignore: cast_nullable_to_non_nullable
              as int,
      overdueShipments: null == overdueShipments
          ? _value.overdueShipments
          : overdueShipments // ignore: cast_nullable_to_non_nullable
              as int,
      pendingDocuments: null == pendingDocuments
          ? _value.pendingDocuments
          : pendingDocuments // ignore: cast_nullable_to_non_nullable
              as int,
      discrepancies: null == discrepancies
          ? _value.discrepancies
          : discrepancies // ignore: cast_nullable_to_non_nullable
              as int,
      paymentsDue: null == paymentsDue
          ? _value.paymentsDue
          : paymentsDue // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DashboardAlertSummaryModelImplCopyWith<$Res>
    implements $DashboardAlertSummaryModelCopyWith<$Res> {
  factory _$$DashboardAlertSummaryModelImplCopyWith(
          _$DashboardAlertSummaryModelImpl value,
          $Res Function(_$DashboardAlertSummaryModelImpl) then) =
      __$$DashboardAlertSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'expiring_lcs') int expiringLCs,
      @JsonKey(name: 'overdue_shipments') int overdueShipments,
      @JsonKey(name: 'pending_documents') int pendingDocuments,
      int discrepancies,
      @JsonKey(name: 'payments_due') int paymentsDue});
}

/// @nodoc
class __$$DashboardAlertSummaryModelImplCopyWithImpl<$Res>
    extends _$DashboardAlertSummaryModelCopyWithImpl<$Res,
        _$DashboardAlertSummaryModelImpl>
    implements _$$DashboardAlertSummaryModelImplCopyWith<$Res> {
  __$$DashboardAlertSummaryModelImplCopyWithImpl(
      _$DashboardAlertSummaryModelImpl _value,
      $Res Function(_$DashboardAlertSummaryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardAlertSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expiringLCs = null,
    Object? overdueShipments = null,
    Object? pendingDocuments = null,
    Object? discrepancies = null,
    Object? paymentsDue = null,
  }) {
    return _then(_$DashboardAlertSummaryModelImpl(
      expiringLCs: null == expiringLCs
          ? _value.expiringLCs
          : expiringLCs // ignore: cast_nullable_to_non_nullable
              as int,
      overdueShipments: null == overdueShipments
          ? _value.overdueShipments
          : overdueShipments // ignore: cast_nullable_to_non_nullable
              as int,
      pendingDocuments: null == pendingDocuments
          ? _value.pendingDocuments
          : pendingDocuments // ignore: cast_nullable_to_non_nullable
              as int,
      discrepancies: null == discrepancies
          ? _value.discrepancies
          : discrepancies // ignore: cast_nullable_to_non_nullable
              as int,
      paymentsDue: null == paymentsDue
          ? _value.paymentsDue
          : paymentsDue // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardAlertSummaryModelImpl extends _DashboardAlertSummaryModel {
  const _$DashboardAlertSummaryModelImpl(
      {@JsonKey(name: 'expiring_lcs') this.expiringLCs = 0,
      @JsonKey(name: 'overdue_shipments') this.overdueShipments = 0,
      @JsonKey(name: 'pending_documents') this.pendingDocuments = 0,
      this.discrepancies = 0,
      @JsonKey(name: 'payments_due') this.paymentsDue = 0})
      : super._();

  factory _$DashboardAlertSummaryModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$DashboardAlertSummaryModelImplFromJson(json);

  @override
  @JsonKey(name: 'expiring_lcs')
  final int expiringLCs;
  @override
  @JsonKey(name: 'overdue_shipments')
  final int overdueShipments;
  @override
  @JsonKey(name: 'pending_documents')
  final int pendingDocuments;
  @override
  @JsonKey()
  final int discrepancies;
  @override
  @JsonKey(name: 'payments_due')
  final int paymentsDue;

  @override
  String toString() {
    return 'DashboardAlertSummaryModel(expiringLCs: $expiringLCs, overdueShipments: $overdueShipments, pendingDocuments: $pendingDocuments, discrepancies: $discrepancies, paymentsDue: $paymentsDue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardAlertSummaryModelImpl &&
            (identical(other.expiringLCs, expiringLCs) ||
                other.expiringLCs == expiringLCs) &&
            (identical(other.overdueShipments, overdueShipments) ||
                other.overdueShipments == overdueShipments) &&
            (identical(other.pendingDocuments, pendingDocuments) ||
                other.pendingDocuments == pendingDocuments) &&
            (identical(other.discrepancies, discrepancies) ||
                other.discrepancies == discrepancies) &&
            (identical(other.paymentsDue, paymentsDue) ||
                other.paymentsDue == paymentsDue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, expiringLCs, overdueShipments,
      pendingDocuments, discrepancies, paymentsDue);

  /// Create a copy of DashboardAlertSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardAlertSummaryModelImplCopyWith<_$DashboardAlertSummaryModelImpl>
      get copyWith => __$$DashboardAlertSummaryModelImplCopyWithImpl<
          _$DashboardAlertSummaryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardAlertSummaryModelImplToJson(
      this,
    );
  }
}

abstract class _DashboardAlertSummaryModel extends DashboardAlertSummaryModel {
  const factory _DashboardAlertSummaryModel(
          {@JsonKey(name: 'expiring_lcs') final int expiringLCs,
          @JsonKey(name: 'overdue_shipments') final int overdueShipments,
          @JsonKey(name: 'pending_documents') final int pendingDocuments,
          final int discrepancies,
          @JsonKey(name: 'payments_due') final int paymentsDue}) =
      _$DashboardAlertSummaryModelImpl;
  const _DashboardAlertSummaryModel._() : super._();

  factory _DashboardAlertSummaryModel.fromJson(Map<String, dynamic> json) =
      _$DashboardAlertSummaryModelImpl.fromJson;

  @override
  @JsonKey(name: 'expiring_lcs')
  int get expiringLCs;
  @override
  @JsonKey(name: 'overdue_shipments')
  int get overdueShipments;
  @override
  @JsonKey(name: 'pending_documents')
  int get pendingDocuments;
  @override
  int get discrepancies;
  @override
  @JsonKey(name: 'payments_due')
  int get paymentsDue;

  /// Create a copy of DashboardAlertSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardAlertSummaryModelImplCopyWith<_$DashboardAlertSummaryModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

RecentActivityModel _$RecentActivityModelFromJson(Map<String, dynamic> json) {
  return _RecentActivityModel.fromJson(json);
}

/// @nodoc
mixin _$RecentActivityModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'entity_type')
  String get entityType => throw _privateConstructorUsedError;
  @JsonKey(name: 'entity_id')
  String get entityId => throw _privateConstructorUsedError;
  @JsonKey(name: 'entity_number')
  String? get entityNumber => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  @JsonKey(name: 'action_detail')
  String? get actionDetail => throw _privateConstructorUsedError;
  @JsonKey(name: 'previous_status')
  String? get previousStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_status')
  String? get newStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_name')
  String? get userName => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this RecentActivityModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecentActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecentActivityModelCopyWith<RecentActivityModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentActivityModelCopyWith<$Res> {
  factory $RecentActivityModelCopyWith(
          RecentActivityModel value, $Res Function(RecentActivityModel) then) =
      _$RecentActivityModelCopyWithImpl<$Res, RecentActivityModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'entity_type') String entityType,
      @JsonKey(name: 'entity_id') String entityId,
      @JsonKey(name: 'entity_number') String? entityNumber,
      String action,
      @JsonKey(name: 'action_detail') String? actionDetail,
      @JsonKey(name: 'previous_status') String? previousStatus,
      @JsonKey(name: 'new_status') String? newStatus,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'user_name') String? userName,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$RecentActivityModelCopyWithImpl<$Res, $Val extends RecentActivityModel>
    implements $RecentActivityModelCopyWith<$Res> {
  _$RecentActivityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecentActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? entityNumber = freezed,
    Object? action = null,
    Object? actionDetail = freezed,
    Object? previousStatus = freezed,
    Object? newStatus = freezed,
    Object? userId = freezed,
    Object? userName = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      entityNumber: freezed == entityNumber
          ? _value.entityNumber
          : entityNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      actionDetail: freezed == actionDetail
          ? _value.actionDetail
          : actionDetail // ignore: cast_nullable_to_non_nullable
              as String?,
      previousStatus: freezed == previousStatus
          ? _value.previousStatus
          : previousStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      newStatus: freezed == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecentActivityModelImplCopyWith<$Res>
    implements $RecentActivityModelCopyWith<$Res> {
  factory _$$RecentActivityModelImplCopyWith(_$RecentActivityModelImpl value,
          $Res Function(_$RecentActivityModelImpl) then) =
      __$$RecentActivityModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'entity_type') String entityType,
      @JsonKey(name: 'entity_id') String entityId,
      @JsonKey(name: 'entity_number') String? entityNumber,
      String action,
      @JsonKey(name: 'action_detail') String? actionDetail,
      @JsonKey(name: 'previous_status') String? previousStatus,
      @JsonKey(name: 'new_status') String? newStatus,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'user_name') String? userName,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$RecentActivityModelImplCopyWithImpl<$Res>
    extends _$RecentActivityModelCopyWithImpl<$Res, _$RecentActivityModelImpl>
    implements _$$RecentActivityModelImplCopyWith<$Res> {
  __$$RecentActivityModelImplCopyWithImpl(_$RecentActivityModelImpl _value,
      $Res Function(_$RecentActivityModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecentActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? entityNumber = freezed,
    Object? action = null,
    Object? actionDetail = freezed,
    Object? previousStatus = freezed,
    Object? newStatus = freezed,
    Object? userId = freezed,
    Object? userName = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$RecentActivityModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      entityNumber: freezed == entityNumber
          ? _value.entityNumber
          : entityNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      actionDetail: freezed == actionDetail
          ? _value.actionDetail
          : actionDetail // ignore: cast_nullable_to_non_nullable
              as String?,
      previousStatus: freezed == previousStatus
          ? _value.previousStatus
          : previousStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      newStatus: freezed == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecentActivityModelImpl extends _RecentActivityModel {
  const _$RecentActivityModelImpl(
      {required this.id,
      @JsonKey(name: 'entity_type') required this.entityType,
      @JsonKey(name: 'entity_id') required this.entityId,
      @JsonKey(name: 'entity_number') this.entityNumber,
      required this.action,
      @JsonKey(name: 'action_detail') this.actionDetail,
      @JsonKey(name: 'previous_status') this.previousStatus,
      @JsonKey(name: 'new_status') this.newStatus,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'user_name') this.userName,
      @JsonKey(name: 'created_at') required this.createdAt})
      : super._();

  factory _$RecentActivityModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecentActivityModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'entity_type')
  final String entityType;
  @override
  @JsonKey(name: 'entity_id')
  final String entityId;
  @override
  @JsonKey(name: 'entity_number')
  final String? entityNumber;
  @override
  final String action;
  @override
  @JsonKey(name: 'action_detail')
  final String? actionDetail;
  @override
  @JsonKey(name: 'previous_status')
  final String? previousStatus;
  @override
  @JsonKey(name: 'new_status')
  final String? newStatus;
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  @JsonKey(name: 'user_name')
  final String? userName;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'RecentActivityModel(id: $id, entityType: $entityType, entityId: $entityId, entityNumber: $entityNumber, action: $action, actionDetail: $actionDetail, previousStatus: $previousStatus, newStatus: $newStatus, userId: $userId, userName: $userName, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentActivityModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.entityNumber, entityNumber) ||
                other.entityNumber == entityNumber) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.actionDetail, actionDetail) ||
                other.actionDetail == actionDetail) &&
            (identical(other.previousStatus, previousStatus) ||
                other.previousStatus == previousStatus) &&
            (identical(other.newStatus, newStatus) ||
                other.newStatus == newStatus) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      entityType,
      entityId,
      entityNumber,
      action,
      actionDetail,
      previousStatus,
      newStatus,
      userId,
      userName,
      createdAt);

  /// Create a copy of RecentActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentActivityModelImplCopyWith<_$RecentActivityModelImpl> get copyWith =>
      __$$RecentActivityModelImplCopyWithImpl<_$RecentActivityModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecentActivityModelImplToJson(
      this,
    );
  }
}

abstract class _RecentActivityModel extends RecentActivityModel {
  const factory _RecentActivityModel(
          {required final String id,
          @JsonKey(name: 'entity_type') required final String entityType,
          @JsonKey(name: 'entity_id') required final String entityId,
          @JsonKey(name: 'entity_number') final String? entityNumber,
          required final String action,
          @JsonKey(name: 'action_detail') final String? actionDetail,
          @JsonKey(name: 'previous_status') final String? previousStatus,
          @JsonKey(name: 'new_status') final String? newStatus,
          @JsonKey(name: 'user_id') final String? userId,
          @JsonKey(name: 'user_name') final String? userName,
          @JsonKey(name: 'created_at') required final DateTime createdAt}) =
      _$RecentActivityModelImpl;
  const _RecentActivityModel._() : super._();

  factory _RecentActivityModel.fromJson(Map<String, dynamic> json) =
      _$RecentActivityModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'entity_type')
  String get entityType;
  @override
  @JsonKey(name: 'entity_id')
  String get entityId;
  @override
  @JsonKey(name: 'entity_number')
  String? get entityNumber;
  @override
  String get action;
  @override
  @JsonKey(name: 'action_detail')
  String? get actionDetail;
  @override
  @JsonKey(name: 'previous_status')
  String? get previousStatus;
  @override
  @JsonKey(name: 'new_status')
  String? get newStatus;
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  @JsonKey(name: 'user_name')
  String? get userName;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of RecentActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecentActivityModelImplCopyWith<_$RecentActivityModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
