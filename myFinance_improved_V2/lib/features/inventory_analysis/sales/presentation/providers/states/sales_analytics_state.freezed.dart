// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_analytics_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CategoryInfo {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Create a copy of CategoryInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryInfoCopyWith<CategoryInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryInfoCopyWith<$Res> {
  factory $CategoryInfoCopyWith(
          CategoryInfo value, $Res Function(CategoryInfo) then) =
      _$CategoryInfoCopyWithImpl<$Res, CategoryInfo>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$CategoryInfoCopyWithImpl<$Res, $Val extends CategoryInfo>
    implements $CategoryInfoCopyWith<$Res> {
  _$CategoryInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryInfoImplCopyWith<$Res>
    implements $CategoryInfoCopyWith<$Res> {
  factory _$$CategoryInfoImplCopyWith(
          _$CategoryInfoImpl value, $Res Function(_$CategoryInfoImpl) then) =
      __$$CategoryInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$CategoryInfoImplCopyWithImpl<$Res>
    extends _$CategoryInfoCopyWithImpl<$Res, _$CategoryInfoImpl>
    implements _$$CategoryInfoImplCopyWith<$Res> {
  __$$CategoryInfoImplCopyWithImpl(
      _$CategoryInfoImpl _value, $Res Function(_$CategoryInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoryInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$CategoryInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CategoryInfoImpl implements _CategoryInfo {
  const _$CategoryInfoImpl({required this.id, required this.name});

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'CategoryInfo(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of CategoryInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryInfoImplCopyWith<_$CategoryInfoImpl> get copyWith =>
      __$$CategoryInfoImplCopyWithImpl<_$CategoryInfoImpl>(this, _$identity);
}

abstract class _CategoryInfo implements CategoryInfo {
  const factory _CategoryInfo(
      {required final String id,
      required final String name}) = _$CategoryInfoImpl;

  @override
  String get id;
  @override
  String get name;

  /// Create a copy of CategoryInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryInfoImplCopyWith<_$CategoryInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SalesAnalyticsV2State {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isRefreshing => throw _privateConstructorUsedError;
  bool get isDrillDownLoading => throw _privateConstructorUsedError;
  bool get isCategoryTrendLoading => throw _privateConstructorUsedError;
  SalesAnalyticsResponse? get timeSeries => throw _privateConstructorUsedError;
  SalesAnalyticsResponse? get topProducts => throw _privateConstructorUsedError;
  SalesAnalyticsResponse? get categoryTrend =>
      throw _privateConstructorUsedError;
  DrillDownResponse? get drillDownData => throw _privateConstructorUsedError;
  BcgMatrix? get bcgMatrix => throw _privateConstructorUsedError;
  DrillDownState get drillDownState => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  TimeRange get selectedTimeRange => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  Metric get selectedMetric => throw _privateConstructorUsedError;
  String? get selectedCategoryId => throw _privateConstructorUsedError;
  List<CategoryInfo> get availableCategories =>
      throw _privateConstructorUsedError;
  String get currencySymbol => throw _privateConstructorUsedError;

  /// Create a copy of SalesAnalyticsV2State
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalesAnalyticsV2StateCopyWith<SalesAnalyticsV2State> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalesAnalyticsV2StateCopyWith<$Res> {
  factory $SalesAnalyticsV2StateCopyWith(SalesAnalyticsV2State value,
          $Res Function(SalesAnalyticsV2State) then) =
      _$SalesAnalyticsV2StateCopyWithImpl<$Res, SalesAnalyticsV2State>;
  @useResult
  $Res call(
      {bool isLoading,
      bool isRefreshing,
      bool isDrillDownLoading,
      bool isCategoryTrendLoading,
      SalesAnalyticsResponse? timeSeries,
      SalesAnalyticsResponse? topProducts,
      SalesAnalyticsResponse? categoryTrend,
      DrillDownResponse? drillDownData,
      BcgMatrix? bcgMatrix,
      DrillDownState drillDownState,
      String? error,
      TimeRange selectedTimeRange,
      DateTime startDate,
      DateTime endDate,
      Metric selectedMetric,
      String? selectedCategoryId,
      List<CategoryInfo> availableCategories,
      String currencySymbol});

  $SalesAnalyticsResponseCopyWith<$Res>? get timeSeries;
  $SalesAnalyticsResponseCopyWith<$Res>? get topProducts;
  $SalesAnalyticsResponseCopyWith<$Res>? get categoryTrend;
  $DrillDownResponseCopyWith<$Res>? get drillDownData;
  $BcgMatrixCopyWith<$Res>? get bcgMatrix;
  $DrillDownStateCopyWith<$Res> get drillDownState;
}

/// @nodoc
class _$SalesAnalyticsV2StateCopyWithImpl<$Res,
        $Val extends SalesAnalyticsV2State>
    implements $SalesAnalyticsV2StateCopyWith<$Res> {
  _$SalesAnalyticsV2StateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalesAnalyticsV2State
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isRefreshing = null,
    Object? isDrillDownLoading = null,
    Object? isCategoryTrendLoading = null,
    Object? timeSeries = freezed,
    Object? topProducts = freezed,
    Object? categoryTrend = freezed,
    Object? drillDownData = freezed,
    Object? bcgMatrix = freezed,
    Object? drillDownState = null,
    Object? error = freezed,
    Object? selectedTimeRange = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? selectedMetric = null,
    Object? selectedCategoryId = freezed,
    Object? availableCategories = null,
    Object? currencySymbol = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      isDrillDownLoading: null == isDrillDownLoading
          ? _value.isDrillDownLoading
          : isDrillDownLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCategoryTrendLoading: null == isCategoryTrendLoading
          ? _value.isCategoryTrendLoading
          : isCategoryTrendLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      timeSeries: freezed == timeSeries
          ? _value.timeSeries
          : timeSeries // ignore: cast_nullable_to_non_nullable
              as SalesAnalyticsResponse?,
      topProducts: freezed == topProducts
          ? _value.topProducts
          : topProducts // ignore: cast_nullable_to_non_nullable
              as SalesAnalyticsResponse?,
      categoryTrend: freezed == categoryTrend
          ? _value.categoryTrend
          : categoryTrend // ignore: cast_nullable_to_non_nullable
              as SalesAnalyticsResponse?,
      drillDownData: freezed == drillDownData
          ? _value.drillDownData
          : drillDownData // ignore: cast_nullable_to_non_nullable
              as DrillDownResponse?,
      bcgMatrix: freezed == bcgMatrix
          ? _value.bcgMatrix
          : bcgMatrix // ignore: cast_nullable_to_non_nullable
              as BcgMatrix?,
      drillDownState: null == drillDownState
          ? _value.drillDownState
          : drillDownState // ignore: cast_nullable_to_non_nullable
              as DrillDownState,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedTimeRange: null == selectedTimeRange
          ? _value.selectedTimeRange
          : selectedTimeRange // ignore: cast_nullable_to_non_nullable
              as TimeRange,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedMetric: null == selectedMetric
          ? _value.selectedMetric
          : selectedMetric // ignore: cast_nullable_to_non_nullable
              as Metric,
      selectedCategoryId: freezed == selectedCategoryId
          ? _value.selectedCategoryId
          : selectedCategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      availableCategories: null == availableCategories
          ? _value.availableCategories
          : availableCategories // ignore: cast_nullable_to_non_nullable
              as List<CategoryInfo>,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of SalesAnalyticsV2State
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SalesAnalyticsResponseCopyWith<$Res>? get timeSeries {
    if (_value.timeSeries == null) {
      return null;
    }

    return $SalesAnalyticsResponseCopyWith<$Res>(_value.timeSeries!, (value) {
      return _then(_value.copyWith(timeSeries: value) as $Val);
    });
  }

  /// Create a copy of SalesAnalyticsV2State
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SalesAnalyticsResponseCopyWith<$Res>? get topProducts {
    if (_value.topProducts == null) {
      return null;
    }

    return $SalesAnalyticsResponseCopyWith<$Res>(_value.topProducts!, (value) {
      return _then(_value.copyWith(topProducts: value) as $Val);
    });
  }

  /// Create a copy of SalesAnalyticsV2State
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SalesAnalyticsResponseCopyWith<$Res>? get categoryTrend {
    if (_value.categoryTrend == null) {
      return null;
    }

    return $SalesAnalyticsResponseCopyWith<$Res>(_value.categoryTrend!,
        (value) {
      return _then(_value.copyWith(categoryTrend: value) as $Val);
    });
  }

  /// Create a copy of SalesAnalyticsV2State
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DrillDownResponseCopyWith<$Res>? get drillDownData {
    if (_value.drillDownData == null) {
      return null;
    }

    return $DrillDownResponseCopyWith<$Res>(_value.drillDownData!, (value) {
      return _then(_value.copyWith(drillDownData: value) as $Val);
    });
  }

  /// Create a copy of SalesAnalyticsV2State
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BcgMatrixCopyWith<$Res>? get bcgMatrix {
    if (_value.bcgMatrix == null) {
      return null;
    }

    return $BcgMatrixCopyWith<$Res>(_value.bcgMatrix!, (value) {
      return _then(_value.copyWith(bcgMatrix: value) as $Val);
    });
  }

  /// Create a copy of SalesAnalyticsV2State
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DrillDownStateCopyWith<$Res> get drillDownState {
    return $DrillDownStateCopyWith<$Res>(_value.drillDownState, (value) {
      return _then(_value.copyWith(drillDownState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SalesAnalyticsV2StateImplCopyWith<$Res>
    implements $SalesAnalyticsV2StateCopyWith<$Res> {
  factory _$$SalesAnalyticsV2StateImplCopyWith(
          _$SalesAnalyticsV2StateImpl value,
          $Res Function(_$SalesAnalyticsV2StateImpl) then) =
      __$$SalesAnalyticsV2StateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isRefreshing,
      bool isDrillDownLoading,
      bool isCategoryTrendLoading,
      SalesAnalyticsResponse? timeSeries,
      SalesAnalyticsResponse? topProducts,
      SalesAnalyticsResponse? categoryTrend,
      DrillDownResponse? drillDownData,
      BcgMatrix? bcgMatrix,
      DrillDownState drillDownState,
      String? error,
      TimeRange selectedTimeRange,
      DateTime startDate,
      DateTime endDate,
      Metric selectedMetric,
      String? selectedCategoryId,
      List<CategoryInfo> availableCategories,
      String currencySymbol});

  @override
  $SalesAnalyticsResponseCopyWith<$Res>? get timeSeries;
  @override
  $SalesAnalyticsResponseCopyWith<$Res>? get topProducts;
  @override
  $SalesAnalyticsResponseCopyWith<$Res>? get categoryTrend;
  @override
  $DrillDownResponseCopyWith<$Res>? get drillDownData;
  @override
  $BcgMatrixCopyWith<$Res>? get bcgMatrix;
  @override
  $DrillDownStateCopyWith<$Res> get drillDownState;
}

/// @nodoc
class __$$SalesAnalyticsV2StateImplCopyWithImpl<$Res>
    extends _$SalesAnalyticsV2StateCopyWithImpl<$Res,
        _$SalesAnalyticsV2StateImpl>
    implements _$$SalesAnalyticsV2StateImplCopyWith<$Res> {
  __$$SalesAnalyticsV2StateImplCopyWithImpl(_$SalesAnalyticsV2StateImpl _value,
      $Res Function(_$SalesAnalyticsV2StateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SalesAnalyticsV2State
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isRefreshing = null,
    Object? isDrillDownLoading = null,
    Object? isCategoryTrendLoading = null,
    Object? timeSeries = freezed,
    Object? topProducts = freezed,
    Object? categoryTrend = freezed,
    Object? drillDownData = freezed,
    Object? bcgMatrix = freezed,
    Object? drillDownState = null,
    Object? error = freezed,
    Object? selectedTimeRange = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? selectedMetric = null,
    Object? selectedCategoryId = freezed,
    Object? availableCategories = null,
    Object? currencySymbol = null,
  }) {
    return _then(_$SalesAnalyticsV2StateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      isDrillDownLoading: null == isDrillDownLoading
          ? _value.isDrillDownLoading
          : isDrillDownLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCategoryTrendLoading: null == isCategoryTrendLoading
          ? _value.isCategoryTrendLoading
          : isCategoryTrendLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      timeSeries: freezed == timeSeries
          ? _value.timeSeries
          : timeSeries // ignore: cast_nullable_to_non_nullable
              as SalesAnalyticsResponse?,
      topProducts: freezed == topProducts
          ? _value.topProducts
          : topProducts // ignore: cast_nullable_to_non_nullable
              as SalesAnalyticsResponse?,
      categoryTrend: freezed == categoryTrend
          ? _value.categoryTrend
          : categoryTrend // ignore: cast_nullable_to_non_nullable
              as SalesAnalyticsResponse?,
      drillDownData: freezed == drillDownData
          ? _value.drillDownData
          : drillDownData // ignore: cast_nullable_to_non_nullable
              as DrillDownResponse?,
      bcgMatrix: freezed == bcgMatrix
          ? _value.bcgMatrix
          : bcgMatrix // ignore: cast_nullable_to_non_nullable
              as BcgMatrix?,
      drillDownState: null == drillDownState
          ? _value.drillDownState
          : drillDownState // ignore: cast_nullable_to_non_nullable
              as DrillDownState,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedTimeRange: null == selectedTimeRange
          ? _value.selectedTimeRange
          : selectedTimeRange // ignore: cast_nullable_to_non_nullable
              as TimeRange,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedMetric: null == selectedMetric
          ? _value.selectedMetric
          : selectedMetric // ignore: cast_nullable_to_non_nullable
              as Metric,
      selectedCategoryId: freezed == selectedCategoryId
          ? _value.selectedCategoryId
          : selectedCategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      availableCategories: null == availableCategories
          ? _value._availableCategories
          : availableCategories // ignore: cast_nullable_to_non_nullable
              as List<CategoryInfo>,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SalesAnalyticsV2StateImpl extends _SalesAnalyticsV2State {
  const _$SalesAnalyticsV2StateImpl(
      {this.isLoading = false,
      this.isRefreshing = false,
      this.isDrillDownLoading = false,
      this.isCategoryTrendLoading = false,
      this.timeSeries,
      this.topProducts,
      this.categoryTrend,
      this.drillDownData,
      this.bcgMatrix,
      this.drillDownState = const DrillDownState(),
      this.error,
      this.selectedTimeRange = TimeRange.thisMonth,
      required this.startDate,
      required this.endDate,
      this.selectedMetric = Metric.revenue,
      this.selectedCategoryId,
      final List<CategoryInfo> availableCategories = const [],
      this.currencySymbol = '₫'})
      : _availableCategories = availableCategories,
        super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isRefreshing;
  @override
  @JsonKey()
  final bool isDrillDownLoading;
  @override
  @JsonKey()
  final bool isCategoryTrendLoading;
  @override
  final SalesAnalyticsResponse? timeSeries;
  @override
  final SalesAnalyticsResponse? topProducts;
  @override
  final SalesAnalyticsResponse? categoryTrend;
  @override
  final DrillDownResponse? drillDownData;
  @override
  final BcgMatrix? bcgMatrix;
  @override
  @JsonKey()
  final DrillDownState drillDownState;
  @override
  final String? error;
  @override
  @JsonKey()
  final TimeRange selectedTimeRange;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  @JsonKey()
  final Metric selectedMetric;
  @override
  final String? selectedCategoryId;
  final List<CategoryInfo> _availableCategories;
  @override
  @JsonKey()
  List<CategoryInfo> get availableCategories {
    if (_availableCategories is EqualUnmodifiableListView)
      return _availableCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableCategories);
  }

  @override
  @JsonKey()
  final String currencySymbol;

  @override
  String toString() {
    return 'SalesAnalyticsV2State(isLoading: $isLoading, isRefreshing: $isRefreshing, isDrillDownLoading: $isDrillDownLoading, isCategoryTrendLoading: $isCategoryTrendLoading, timeSeries: $timeSeries, topProducts: $topProducts, categoryTrend: $categoryTrend, drillDownData: $drillDownData, bcgMatrix: $bcgMatrix, drillDownState: $drillDownState, error: $error, selectedTimeRange: $selectedTimeRange, startDate: $startDate, endDate: $endDate, selectedMetric: $selectedMetric, selectedCategoryId: $selectedCategoryId, availableCategories: $availableCategories, currencySymbol: $currencySymbol)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalesAnalyticsV2StateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            (identical(other.isDrillDownLoading, isDrillDownLoading) ||
                other.isDrillDownLoading == isDrillDownLoading) &&
            (identical(other.isCategoryTrendLoading, isCategoryTrendLoading) ||
                other.isCategoryTrendLoading == isCategoryTrendLoading) &&
            (identical(other.timeSeries, timeSeries) ||
                other.timeSeries == timeSeries) &&
            (identical(other.topProducts, topProducts) ||
                other.topProducts == topProducts) &&
            (identical(other.categoryTrend, categoryTrend) ||
                other.categoryTrend == categoryTrend) &&
            (identical(other.drillDownData, drillDownData) ||
                other.drillDownData == drillDownData) &&
            (identical(other.bcgMatrix, bcgMatrix) ||
                other.bcgMatrix == bcgMatrix) &&
            (identical(other.drillDownState, drillDownState) ||
                other.drillDownState == drillDownState) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.selectedTimeRange, selectedTimeRange) ||
                other.selectedTimeRange == selectedTimeRange) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.selectedMetric, selectedMetric) ||
                other.selectedMetric == selectedMetric) &&
            (identical(other.selectedCategoryId, selectedCategoryId) ||
                other.selectedCategoryId == selectedCategoryId) &&
            const DeepCollectionEquality()
                .equals(other._availableCategories, _availableCategories) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      isRefreshing,
      isDrillDownLoading,
      isCategoryTrendLoading,
      timeSeries,
      topProducts,
      categoryTrend,
      drillDownData,
      bcgMatrix,
      drillDownState,
      error,
      selectedTimeRange,
      startDate,
      endDate,
      selectedMetric,
      selectedCategoryId,
      const DeepCollectionEquality().hash(_availableCategories),
      currencySymbol);

  /// Create a copy of SalesAnalyticsV2State
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalesAnalyticsV2StateImplCopyWith<_$SalesAnalyticsV2StateImpl>
      get copyWith => __$$SalesAnalyticsV2StateImplCopyWithImpl<
          _$SalesAnalyticsV2StateImpl>(this, _$identity);
}

abstract class _SalesAnalyticsV2State extends SalesAnalyticsV2State {
  const factory _SalesAnalyticsV2State(
      {final bool isLoading,
      final bool isRefreshing,
      final bool isDrillDownLoading,
      final bool isCategoryTrendLoading,
      final SalesAnalyticsResponse? timeSeries,
      final SalesAnalyticsResponse? topProducts,
      final SalesAnalyticsResponse? categoryTrend,
      final DrillDownResponse? drillDownData,
      final BcgMatrix? bcgMatrix,
      final DrillDownState drillDownState,
      final String? error,
      final TimeRange selectedTimeRange,
      required final DateTime startDate,
      required final DateTime endDate,
      final Metric selectedMetric,
      final String? selectedCategoryId,
      final List<CategoryInfo> availableCategories,
      final String currencySymbol}) = _$SalesAnalyticsV2StateImpl;
  const _SalesAnalyticsV2State._() : super._();

  @override
  bool get isLoading;
  @override
  bool get isRefreshing;
  @override
  bool get isDrillDownLoading;
  @override
  bool get isCategoryTrendLoading;
  @override
  SalesAnalyticsResponse? get timeSeries;
  @override
  SalesAnalyticsResponse? get topProducts;
  @override
  SalesAnalyticsResponse? get categoryTrend;
  @override
  DrillDownResponse? get drillDownData;
  @override
  BcgMatrix? get bcgMatrix;
  @override
  DrillDownState get drillDownState;
  @override
  String? get error;
  @override
  TimeRange get selectedTimeRange;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  Metric get selectedMetric;
  @override
  String? get selectedCategoryId;
  @override
  List<CategoryInfo> get availableCategories;
  @override
  String get currencySymbol;

  /// Create a copy of SalesAnalyticsV2State
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalesAnalyticsV2StateImplCopyWith<_$SalesAnalyticsV2StateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
