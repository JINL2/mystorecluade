// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manager_overview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ManagerOverview _$ManagerOverviewFromJson(Map<String, dynamic> json) {
  return _ManagerOverview.fromJson(json);
}

/// @nodoc
mixin _$ManagerOverview {
  /// Month in yyyy-MM format
  String get month => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_shifts')
  int get totalShifts => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_approved_requests')
  int get totalApprovedRequests => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pending_requests')
  int get totalPendingRequests => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_employees')
  int get totalEmployees => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_estimated_cost')
  double get totalEstimatedCost => throw _privateConstructorUsedError;
  @JsonKey(name: 'additional_stats', defaultValue: <String, dynamic>{})
  Map<String, dynamic> get additionalStats =>
      throw _privateConstructorUsedError;

  /// Serializes this ManagerOverview to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ManagerOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManagerOverviewCopyWith<ManagerOverview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagerOverviewCopyWith<$Res> {
  factory $ManagerOverviewCopyWith(
          ManagerOverview value, $Res Function(ManagerOverview) then) =
      _$ManagerOverviewCopyWithImpl<$Res, ManagerOverview>;
  @useResult
  $Res call(
      {String month,
      @JsonKey(name: 'total_shifts') int totalShifts,
      @JsonKey(name: 'total_approved_requests') int totalApprovedRequests,
      @JsonKey(name: 'total_pending_requests') int totalPendingRequests,
      @JsonKey(name: 'total_employees') int totalEmployees,
      @JsonKey(name: 'total_estimated_cost') double totalEstimatedCost,
      @JsonKey(name: 'additional_stats', defaultValue: <String, dynamic>{})
      Map<String, dynamic> additionalStats});
}

/// @nodoc
class _$ManagerOverviewCopyWithImpl<$Res, $Val extends ManagerOverview>
    implements $ManagerOverviewCopyWith<$Res> {
  _$ManagerOverviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManagerOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? totalShifts = null,
    Object? totalApprovedRequests = null,
    Object? totalPendingRequests = null,
    Object? totalEmployees = null,
    Object? totalEstimatedCost = null,
    Object? additionalStats = null,
  }) {
    return _then(_value.copyWith(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      totalShifts: null == totalShifts
          ? _value.totalShifts
          : totalShifts // ignore: cast_nullable_to_non_nullable
              as int,
      totalApprovedRequests: null == totalApprovedRequests
          ? _value.totalApprovedRequests
          : totalApprovedRequests // ignore: cast_nullable_to_non_nullable
              as int,
      totalPendingRequests: null == totalPendingRequests
          ? _value.totalPendingRequests
          : totalPendingRequests // ignore: cast_nullable_to_non_nullable
              as int,
      totalEmployees: null == totalEmployees
          ? _value.totalEmployees
          : totalEmployees // ignore: cast_nullable_to_non_nullable
              as int,
      totalEstimatedCost: null == totalEstimatedCost
          ? _value.totalEstimatedCost
          : totalEstimatedCost // ignore: cast_nullable_to_non_nullable
              as double,
      additionalStats: null == additionalStats
          ? _value.additionalStats
          : additionalStats // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManagerOverviewImplCopyWith<$Res>
    implements $ManagerOverviewCopyWith<$Res> {
  factory _$$ManagerOverviewImplCopyWith(_$ManagerOverviewImpl value,
          $Res Function(_$ManagerOverviewImpl) then) =
      __$$ManagerOverviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String month,
      @JsonKey(name: 'total_shifts') int totalShifts,
      @JsonKey(name: 'total_approved_requests') int totalApprovedRequests,
      @JsonKey(name: 'total_pending_requests') int totalPendingRequests,
      @JsonKey(name: 'total_employees') int totalEmployees,
      @JsonKey(name: 'total_estimated_cost') double totalEstimatedCost,
      @JsonKey(name: 'additional_stats', defaultValue: <String, dynamic>{})
      Map<String, dynamic> additionalStats});
}

/// @nodoc
class __$$ManagerOverviewImplCopyWithImpl<$Res>
    extends _$ManagerOverviewCopyWithImpl<$Res, _$ManagerOverviewImpl>
    implements _$$ManagerOverviewImplCopyWith<$Res> {
  __$$ManagerOverviewImplCopyWithImpl(
      _$ManagerOverviewImpl _value, $Res Function(_$ManagerOverviewImpl) _then)
      : super(_value, _then);

  /// Create a copy of ManagerOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? totalShifts = null,
    Object? totalApprovedRequests = null,
    Object? totalPendingRequests = null,
    Object? totalEmployees = null,
    Object? totalEstimatedCost = null,
    Object? additionalStats = null,
  }) {
    return _then(_$ManagerOverviewImpl(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      totalShifts: null == totalShifts
          ? _value.totalShifts
          : totalShifts // ignore: cast_nullable_to_non_nullable
              as int,
      totalApprovedRequests: null == totalApprovedRequests
          ? _value.totalApprovedRequests
          : totalApprovedRequests // ignore: cast_nullable_to_non_nullable
              as int,
      totalPendingRequests: null == totalPendingRequests
          ? _value.totalPendingRequests
          : totalPendingRequests // ignore: cast_nullable_to_non_nullable
              as int,
      totalEmployees: null == totalEmployees
          ? _value.totalEmployees
          : totalEmployees // ignore: cast_nullable_to_non_nullable
              as int,
      totalEstimatedCost: null == totalEstimatedCost
          ? _value.totalEstimatedCost
          : totalEstimatedCost // ignore: cast_nullable_to_non_nullable
              as double,
      additionalStats: null == additionalStats
          ? _value._additionalStats
          : additionalStats // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ManagerOverviewImpl extends _ManagerOverview {
  const _$ManagerOverviewImpl(
      {required this.month,
      @JsonKey(name: 'total_shifts') required this.totalShifts,
      @JsonKey(name: 'total_approved_requests')
      required this.totalApprovedRequests,
      @JsonKey(name: 'total_pending_requests')
      required this.totalPendingRequests,
      @JsonKey(name: 'total_employees') required this.totalEmployees,
      @JsonKey(name: 'total_estimated_cost') required this.totalEstimatedCost,
      @JsonKey(name: 'additional_stats', defaultValue: <String, dynamic>{})
      required final Map<String, dynamic> additionalStats})
      : _additionalStats = additionalStats,
        super._();

  factory _$ManagerOverviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$ManagerOverviewImplFromJson(json);

  /// Month in yyyy-MM format
  @override
  final String month;
  @override
  @JsonKey(name: 'total_shifts')
  final int totalShifts;
  @override
  @JsonKey(name: 'total_approved_requests')
  final int totalApprovedRequests;
  @override
  @JsonKey(name: 'total_pending_requests')
  final int totalPendingRequests;
  @override
  @JsonKey(name: 'total_employees')
  final int totalEmployees;
  @override
  @JsonKey(name: 'total_estimated_cost')
  final double totalEstimatedCost;
  final Map<String, dynamic> _additionalStats;
  @override
  @JsonKey(name: 'additional_stats', defaultValue: <String, dynamic>{})
  Map<String, dynamic> get additionalStats {
    if (_additionalStats is EqualUnmodifiableMapView) return _additionalStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_additionalStats);
  }

  @override
  String toString() {
    return 'ManagerOverview(month: $month, totalShifts: $totalShifts, totalApprovedRequests: $totalApprovedRequests, totalPendingRequests: $totalPendingRequests, totalEmployees: $totalEmployees, totalEstimatedCost: $totalEstimatedCost, additionalStats: $additionalStats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManagerOverviewImpl &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.totalShifts, totalShifts) ||
                other.totalShifts == totalShifts) &&
            (identical(other.totalApprovedRequests, totalApprovedRequests) ||
                other.totalApprovedRequests == totalApprovedRequests) &&
            (identical(other.totalPendingRequests, totalPendingRequests) ||
                other.totalPendingRequests == totalPendingRequests) &&
            (identical(other.totalEmployees, totalEmployees) ||
                other.totalEmployees == totalEmployees) &&
            (identical(other.totalEstimatedCost, totalEstimatedCost) ||
                other.totalEstimatedCost == totalEstimatedCost) &&
            const DeepCollectionEquality()
                .equals(other._additionalStats, _additionalStats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      month,
      totalShifts,
      totalApprovedRequests,
      totalPendingRequests,
      totalEmployees,
      totalEstimatedCost,
      const DeepCollectionEquality().hash(_additionalStats));

  /// Create a copy of ManagerOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManagerOverviewImplCopyWith<_$ManagerOverviewImpl> get copyWith =>
      __$$ManagerOverviewImplCopyWithImpl<_$ManagerOverviewImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ManagerOverviewImplToJson(
      this,
    );
  }
}

abstract class _ManagerOverview extends ManagerOverview {
  const factory _ManagerOverview(
          {required final String month,
          @JsonKey(name: 'total_shifts') required final int totalShifts,
          @JsonKey(name: 'total_approved_requests')
          required final int totalApprovedRequests,
          @JsonKey(name: 'total_pending_requests')
          required final int totalPendingRequests,
          @JsonKey(name: 'total_employees') required final int totalEmployees,
          @JsonKey(name: 'total_estimated_cost')
          required final double totalEstimatedCost,
          @JsonKey(name: 'additional_stats', defaultValue: <String, dynamic>{})
          required final Map<String, dynamic> additionalStats}) =
      _$ManagerOverviewImpl;
  const _ManagerOverview._() : super._();

  factory _ManagerOverview.fromJson(Map<String, dynamic> json) =
      _$ManagerOverviewImpl.fromJson;

  /// Month in yyyy-MM format
  @override
  String get month;
  @override
  @JsonKey(name: 'total_shifts')
  int get totalShifts;
  @override
  @JsonKey(name: 'total_approved_requests')
  int get totalApprovedRequests;
  @override
  @JsonKey(name: 'total_pending_requests')
  int get totalPendingRequests;
  @override
  @JsonKey(name: 'total_employees')
  int get totalEmployees;
  @override
  @JsonKey(name: 'total_estimated_cost')
  double get totalEstimatedCost;
  @override
  @JsonKey(name: 'additional_stats', defaultValue: <String, dynamic>{})
  Map<String, dynamic> get additionalStats;

  /// Create a copy of ManagerOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManagerOverviewImplCopyWith<_$ManagerOverviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
