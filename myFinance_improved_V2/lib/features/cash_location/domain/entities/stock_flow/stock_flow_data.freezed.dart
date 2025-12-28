// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_flow_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StockFlowData {
  LocationSummary? get locationSummary => throw _privateConstructorUsedError;
  List<JournalFlow> get journalFlows => throw _privateConstructorUsedError;
  List<ActualFlow> get actualFlows => throw _privateConstructorUsedError;

  /// Create a copy of StockFlowData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockFlowDataCopyWith<StockFlowData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockFlowDataCopyWith<$Res> {
  factory $StockFlowDataCopyWith(
          StockFlowData value, $Res Function(StockFlowData) then) =
      _$StockFlowDataCopyWithImpl<$Res, StockFlowData>;
  @useResult
  $Res call(
      {LocationSummary? locationSummary,
      List<JournalFlow> journalFlows,
      List<ActualFlow> actualFlows});

  $LocationSummaryCopyWith<$Res>? get locationSummary;
}

/// @nodoc
class _$StockFlowDataCopyWithImpl<$Res, $Val extends StockFlowData>
    implements $StockFlowDataCopyWith<$Res> {
  _$StockFlowDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockFlowData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationSummary = freezed,
    Object? journalFlows = null,
    Object? actualFlows = null,
  }) {
    return _then(_value.copyWith(
      locationSummary: freezed == locationSummary
          ? _value.locationSummary
          : locationSummary // ignore: cast_nullable_to_non_nullable
              as LocationSummary?,
      journalFlows: null == journalFlows
          ? _value.journalFlows
          : journalFlows // ignore: cast_nullable_to_non_nullable
              as List<JournalFlow>,
      actualFlows: null == actualFlows
          ? _value.actualFlows
          : actualFlows // ignore: cast_nullable_to_non_nullable
              as List<ActualFlow>,
    ) as $Val);
  }

  /// Create a copy of StockFlowData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationSummaryCopyWith<$Res>? get locationSummary {
    if (_value.locationSummary == null) {
      return null;
    }

    return $LocationSummaryCopyWith<$Res>(_value.locationSummary!, (value) {
      return _then(_value.copyWith(locationSummary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StockFlowDataImplCopyWith<$Res>
    implements $StockFlowDataCopyWith<$Res> {
  factory _$$StockFlowDataImplCopyWith(
          _$StockFlowDataImpl value, $Res Function(_$StockFlowDataImpl) then) =
      __$$StockFlowDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {LocationSummary? locationSummary,
      List<JournalFlow> journalFlows,
      List<ActualFlow> actualFlows});

  @override
  $LocationSummaryCopyWith<$Res>? get locationSummary;
}

/// @nodoc
class __$$StockFlowDataImplCopyWithImpl<$Res>
    extends _$StockFlowDataCopyWithImpl<$Res, _$StockFlowDataImpl>
    implements _$$StockFlowDataImplCopyWith<$Res> {
  __$$StockFlowDataImplCopyWithImpl(
      _$StockFlowDataImpl _value, $Res Function(_$StockFlowDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockFlowData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationSummary = freezed,
    Object? journalFlows = null,
    Object? actualFlows = null,
  }) {
    return _then(_$StockFlowDataImpl(
      locationSummary: freezed == locationSummary
          ? _value.locationSummary
          : locationSummary // ignore: cast_nullable_to_non_nullable
              as LocationSummary?,
      journalFlows: null == journalFlows
          ? _value._journalFlows
          : journalFlows // ignore: cast_nullable_to_non_nullable
              as List<JournalFlow>,
      actualFlows: null == actualFlows
          ? _value._actualFlows
          : actualFlows // ignore: cast_nullable_to_non_nullable
              as List<ActualFlow>,
    ));
  }
}

/// @nodoc

class _$StockFlowDataImpl implements _StockFlowData {
  const _$StockFlowDataImpl(
      {this.locationSummary,
      required final List<JournalFlow> journalFlows,
      required final List<ActualFlow> actualFlows})
      : _journalFlows = journalFlows,
        _actualFlows = actualFlows;

  @override
  final LocationSummary? locationSummary;
  final List<JournalFlow> _journalFlows;
  @override
  List<JournalFlow> get journalFlows {
    if (_journalFlows is EqualUnmodifiableListView) return _journalFlows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_journalFlows);
  }

  final List<ActualFlow> _actualFlows;
  @override
  List<ActualFlow> get actualFlows {
    if (_actualFlows is EqualUnmodifiableListView) return _actualFlows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actualFlows);
  }

  @override
  String toString() {
    return 'StockFlowData(locationSummary: $locationSummary, journalFlows: $journalFlows, actualFlows: $actualFlows)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockFlowDataImpl &&
            (identical(other.locationSummary, locationSummary) ||
                other.locationSummary == locationSummary) &&
            const DeepCollectionEquality()
                .equals(other._journalFlows, _journalFlows) &&
            const DeepCollectionEquality()
                .equals(other._actualFlows, _actualFlows));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      locationSummary,
      const DeepCollectionEquality().hash(_journalFlows),
      const DeepCollectionEquality().hash(_actualFlows));

  /// Create a copy of StockFlowData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockFlowDataImplCopyWith<_$StockFlowDataImpl> get copyWith =>
      __$$StockFlowDataImplCopyWithImpl<_$StockFlowDataImpl>(this, _$identity);
}

abstract class _StockFlowData implements StockFlowData {
  const factory _StockFlowData(
      {final LocationSummary? locationSummary,
      required final List<JournalFlow> journalFlows,
      required final List<ActualFlow> actualFlows}) = _$StockFlowDataImpl;

  @override
  LocationSummary? get locationSummary;
  @override
  List<JournalFlow> get journalFlows;
  @override
  List<ActualFlow> get actualFlows;

  /// Create a copy of StockFlowData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockFlowDataImplCopyWith<_$StockFlowDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PaginationInfo {
  int get offset => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get totalJournalFlows => throw _privateConstructorUsedError;
  int get totalActualFlows => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginationInfoCopyWith<PaginationInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationInfoCopyWith<$Res> {
  factory $PaginationInfoCopyWith(
          PaginationInfo value, $Res Function(PaginationInfo) then) =
      _$PaginationInfoCopyWithImpl<$Res, PaginationInfo>;
  @useResult
  $Res call(
      {int offset,
      int limit,
      int totalJournalFlows,
      int totalActualFlows,
      bool hasMore});
}

/// @nodoc
class _$PaginationInfoCopyWithImpl<$Res, $Val extends PaginationInfo>
    implements $PaginationInfoCopyWith<$Res> {
  _$PaginationInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offset = null,
    Object? limit = null,
    Object? totalJournalFlows = null,
    Object? totalActualFlows = null,
    Object? hasMore = null,
  }) {
    return _then(_value.copyWith(
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      totalJournalFlows: null == totalJournalFlows
          ? _value.totalJournalFlows
          : totalJournalFlows // ignore: cast_nullable_to_non_nullable
              as int,
      totalActualFlows: null == totalActualFlows
          ? _value.totalActualFlows
          : totalActualFlows // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginationInfoImplCopyWith<$Res>
    implements $PaginationInfoCopyWith<$Res> {
  factory _$$PaginationInfoImplCopyWith(_$PaginationInfoImpl value,
          $Res Function(_$PaginationInfoImpl) then) =
      __$$PaginationInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int offset,
      int limit,
      int totalJournalFlows,
      int totalActualFlows,
      bool hasMore});
}

/// @nodoc
class __$$PaginationInfoImplCopyWithImpl<$Res>
    extends _$PaginationInfoCopyWithImpl<$Res, _$PaginationInfoImpl>
    implements _$$PaginationInfoImplCopyWith<$Res> {
  __$$PaginationInfoImplCopyWithImpl(
      _$PaginationInfoImpl _value, $Res Function(_$PaginationInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offset = null,
    Object? limit = null,
    Object? totalJournalFlows = null,
    Object? totalActualFlows = null,
    Object? hasMore = null,
  }) {
    return _then(_$PaginationInfoImpl(
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      totalJournalFlows: null == totalJournalFlows
          ? _value.totalJournalFlows
          : totalJournalFlows // ignore: cast_nullable_to_non_nullable
              as int,
      totalActualFlows: null == totalActualFlows
          ? _value.totalActualFlows
          : totalActualFlows // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PaginationInfoImpl implements _PaginationInfo {
  const _$PaginationInfoImpl(
      {required this.offset,
      required this.limit,
      required this.totalJournalFlows,
      required this.totalActualFlows,
      required this.hasMore});

  @override
  final int offset;
  @override
  final int limit;
  @override
  final int totalJournalFlows;
  @override
  final int totalActualFlows;
  @override
  final bool hasMore;

  @override
  String toString() {
    return 'PaginationInfo(offset: $offset, limit: $limit, totalJournalFlows: $totalJournalFlows, totalActualFlows: $totalActualFlows, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationInfoImpl &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.totalJournalFlows, totalJournalFlows) ||
                other.totalJournalFlows == totalJournalFlows) &&
            (identical(other.totalActualFlows, totalActualFlows) ||
                other.totalActualFlows == totalActualFlows) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, offset, limit, totalJournalFlows, totalActualFlows, hasMore);

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationInfoImplCopyWith<_$PaginationInfoImpl> get copyWith =>
      __$$PaginationInfoImplCopyWithImpl<_$PaginationInfoImpl>(
          this, _$identity);
}

abstract class _PaginationInfo implements PaginationInfo {
  const factory _PaginationInfo(
      {required final int offset,
      required final int limit,
      required final int totalJournalFlows,
      required final int totalActualFlows,
      required final bool hasMore}) = _$PaginationInfoImpl;

  @override
  int get offset;
  @override
  int get limit;
  @override
  int get totalJournalFlows;
  @override
  int get totalActualFlows;
  @override
  bool get hasMore;

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationInfoImplCopyWith<_$PaginationInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$StockFlowResponse {
  bool get success => throw _privateConstructorUsedError;
  StockFlowData? get data => throw _privateConstructorUsedError;
  PaginationInfo? get pagination => throw _privateConstructorUsedError;

  /// Create a copy of StockFlowResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockFlowResponseCopyWith<StockFlowResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockFlowResponseCopyWith<$Res> {
  factory $StockFlowResponseCopyWith(
          StockFlowResponse value, $Res Function(StockFlowResponse) then) =
      _$StockFlowResponseCopyWithImpl<$Res, StockFlowResponse>;
  @useResult
  $Res call({bool success, StockFlowData? data, PaginationInfo? pagination});

  $StockFlowDataCopyWith<$Res>? get data;
  $PaginationInfoCopyWith<$Res>? get pagination;
}

/// @nodoc
class _$StockFlowResponseCopyWithImpl<$Res, $Val extends StockFlowResponse>
    implements $StockFlowResponseCopyWith<$Res> {
  _$StockFlowResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockFlowResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
    Object? pagination = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as StockFlowData?,
      pagination: freezed == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationInfo?,
    ) as $Val);
  }

  /// Create a copy of StockFlowResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StockFlowDataCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $StockFlowDataCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }

  /// Create a copy of StockFlowResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaginationInfoCopyWith<$Res>? get pagination {
    if (_value.pagination == null) {
      return null;
    }

    return $PaginationInfoCopyWith<$Res>(_value.pagination!, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StockFlowResponseImplCopyWith<$Res>
    implements $StockFlowResponseCopyWith<$Res> {
  factory _$$StockFlowResponseImplCopyWith(_$StockFlowResponseImpl value,
          $Res Function(_$StockFlowResponseImpl) then) =
      __$$StockFlowResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, StockFlowData? data, PaginationInfo? pagination});

  @override
  $StockFlowDataCopyWith<$Res>? get data;
  @override
  $PaginationInfoCopyWith<$Res>? get pagination;
}

/// @nodoc
class __$$StockFlowResponseImplCopyWithImpl<$Res>
    extends _$StockFlowResponseCopyWithImpl<$Res, _$StockFlowResponseImpl>
    implements _$$StockFlowResponseImplCopyWith<$Res> {
  __$$StockFlowResponseImplCopyWithImpl(_$StockFlowResponseImpl _value,
      $Res Function(_$StockFlowResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockFlowResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
    Object? pagination = freezed,
  }) {
    return _then(_$StockFlowResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as StockFlowData?,
      pagination: freezed == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationInfo?,
    ));
  }
}

/// @nodoc

class _$StockFlowResponseImpl implements _StockFlowResponse {
  const _$StockFlowResponseImpl(
      {required this.success, this.data, this.pagination});

  @override
  final bool success;
  @override
  final StockFlowData? data;
  @override
  final PaginationInfo? pagination;

  @override
  String toString() {
    return 'StockFlowResponse(success: $success, data: $data, pagination: $pagination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockFlowResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination));
  }

  @override
  int get hashCode => Object.hash(runtimeType, success, data, pagination);

  /// Create a copy of StockFlowResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockFlowResponseImplCopyWith<_$StockFlowResponseImpl> get copyWith =>
      __$$StockFlowResponseImplCopyWithImpl<_$StockFlowResponseImpl>(
          this, _$identity);
}

abstract class _StockFlowResponse implements StockFlowResponse {
  const factory _StockFlowResponse(
      {required final bool success,
      final StockFlowData? data,
      final PaginationInfo? pagination}) = _$StockFlowResponseImpl;

  @override
  bool get success;
  @override
  StockFlowData? get data;
  @override
  PaginationInfo? get pagination;

  /// Create a copy of StockFlowResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockFlowResponseImplCopyWith<_$StockFlowResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
