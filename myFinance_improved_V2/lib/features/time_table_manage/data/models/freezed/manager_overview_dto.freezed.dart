// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manager_overview_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ManagerOverviewDto _$ManagerOverviewDtoFromJson(Map<String, dynamic> json) {
  return _ManagerOverviewDto.fromJson(json);
}

/// @nodoc
mixin _$ManagerOverviewDto {
  @JsonKey(name: 'scope')
  OverviewScopeDto get scope => throw _privateConstructorUsedError;
  @JsonKey(name: 'stores')
  List<OverviewStoreDto> get stores => throw _privateConstructorUsedError;

  /// Serializes this ManagerOverviewDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ManagerOverviewDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManagerOverviewDtoCopyWith<ManagerOverviewDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagerOverviewDtoCopyWith<$Res> {
  factory $ManagerOverviewDtoCopyWith(
          ManagerOverviewDto value, $Res Function(ManagerOverviewDto) then) =
      _$ManagerOverviewDtoCopyWithImpl<$Res, ManagerOverviewDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'scope') OverviewScopeDto scope,
      @JsonKey(name: 'stores') List<OverviewStoreDto> stores});

  $OverviewScopeDtoCopyWith<$Res> get scope;
}

/// @nodoc
class _$ManagerOverviewDtoCopyWithImpl<$Res, $Val extends ManagerOverviewDto>
    implements $ManagerOverviewDtoCopyWith<$Res> {
  _$ManagerOverviewDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManagerOverviewDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scope = null,
    Object? stores = null,
  }) {
    return _then(_value.copyWith(
      scope: null == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as OverviewScopeDto,
      stores: null == stores
          ? _value.stores
          : stores // ignore: cast_nullable_to_non_nullable
              as List<OverviewStoreDto>,
    ) as $Val);
  }

  /// Create a copy of ManagerOverviewDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OverviewScopeDtoCopyWith<$Res> get scope {
    return $OverviewScopeDtoCopyWith<$Res>(_value.scope, (value) {
      return _then(_value.copyWith(scope: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ManagerOverviewDtoImplCopyWith<$Res>
    implements $ManagerOverviewDtoCopyWith<$Res> {
  factory _$$ManagerOverviewDtoImplCopyWith(_$ManagerOverviewDtoImpl value,
          $Res Function(_$ManagerOverviewDtoImpl) then) =
      __$$ManagerOverviewDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'scope') OverviewScopeDto scope,
      @JsonKey(name: 'stores') List<OverviewStoreDto> stores});

  @override
  $OverviewScopeDtoCopyWith<$Res> get scope;
}

/// @nodoc
class __$$ManagerOverviewDtoImplCopyWithImpl<$Res>
    extends _$ManagerOverviewDtoCopyWithImpl<$Res, _$ManagerOverviewDtoImpl>
    implements _$$ManagerOverviewDtoImplCopyWith<$Res> {
  __$$ManagerOverviewDtoImplCopyWithImpl(_$ManagerOverviewDtoImpl _value,
      $Res Function(_$ManagerOverviewDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ManagerOverviewDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scope = null,
    Object? stores = null,
  }) {
    return _then(_$ManagerOverviewDtoImpl(
      scope: null == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as OverviewScopeDto,
      stores: null == stores
          ? _value._stores
          : stores // ignore: cast_nullable_to_non_nullable
              as List<OverviewStoreDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ManagerOverviewDtoImpl implements _ManagerOverviewDto {
  const _$ManagerOverviewDtoImpl(
      {@JsonKey(name: 'scope') required this.scope,
      @JsonKey(name: 'stores') final List<OverviewStoreDto> stores = const []})
      : _stores = stores;

  factory _$ManagerOverviewDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ManagerOverviewDtoImplFromJson(json);

  @override
  @JsonKey(name: 'scope')
  final OverviewScopeDto scope;
  final List<OverviewStoreDto> _stores;
  @override
  @JsonKey(name: 'stores')
  List<OverviewStoreDto> get stores {
    if (_stores is EqualUnmodifiableListView) return _stores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stores);
  }

  @override
  String toString() {
    return 'ManagerOverviewDto(scope: $scope, stores: $stores)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManagerOverviewDtoImpl &&
            (identical(other.scope, scope) || other.scope == scope) &&
            const DeepCollectionEquality().equals(other._stores, _stores));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, scope, const DeepCollectionEquality().hash(_stores));

  /// Create a copy of ManagerOverviewDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManagerOverviewDtoImplCopyWith<_$ManagerOverviewDtoImpl> get copyWith =>
      __$$ManagerOverviewDtoImplCopyWithImpl<_$ManagerOverviewDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ManagerOverviewDtoImplToJson(
      this,
    );
  }
}

abstract class _ManagerOverviewDto implements ManagerOverviewDto {
  const factory _ManagerOverviewDto(
          {@JsonKey(name: 'scope') required final OverviewScopeDto scope,
          @JsonKey(name: 'stores') final List<OverviewStoreDto> stores}) =
      _$ManagerOverviewDtoImpl;

  factory _ManagerOverviewDto.fromJson(Map<String, dynamic> json) =
      _$ManagerOverviewDtoImpl.fromJson;

  @override
  @JsonKey(name: 'scope')
  OverviewScopeDto get scope;
  @override
  @JsonKey(name: 'stores')
  List<OverviewStoreDto> get stores;

  /// Create a copy of ManagerOverviewDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManagerOverviewDtoImplCopyWith<_$ManagerOverviewDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OverviewScopeDto _$OverviewScopeDtoFromJson(Map<String, dynamic> json) {
  return _OverviewScopeDto.fromJson(json);
}

/// @nodoc
mixin _$OverviewScopeDto {
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String get companyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_stores')
  int get totalStores => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_range')
  DateRangeDto get dateRange => throw _privateConstructorUsedError;

  /// Serializes this OverviewScopeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OverviewScopeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OverviewScopeDtoCopyWith<OverviewScopeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OverviewScopeDtoCopyWith<$Res> {
  factory $OverviewScopeDtoCopyWith(
          OverviewScopeDto value, $Res Function(OverviewScopeDto) then) =
      _$OverviewScopeDtoCopyWithImpl<$Res, OverviewScopeDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'company_name') String companyName,
      @JsonKey(name: 'total_stores') int totalStores,
      @JsonKey(name: 'date_range') DateRangeDto dateRange});

  $DateRangeDtoCopyWith<$Res> get dateRange;
}

/// @nodoc
class _$OverviewScopeDtoCopyWithImpl<$Res, $Val extends OverviewScopeDto>
    implements $OverviewScopeDtoCopyWith<$Res> {
  _$OverviewScopeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OverviewScopeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyId = null,
    Object? companyName = null,
    Object? totalStores = null,
    Object? dateRange = null,
  }) {
    return _then(_value.copyWith(
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      totalStores: null == totalStores
          ? _value.totalStores
          : totalStores // ignore: cast_nullable_to_non_nullable
              as int,
      dateRange: null == dateRange
          ? _value.dateRange
          : dateRange // ignore: cast_nullable_to_non_nullable
              as DateRangeDto,
    ) as $Val);
  }

  /// Create a copy of OverviewScopeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DateRangeDtoCopyWith<$Res> get dateRange {
    return $DateRangeDtoCopyWith<$Res>(_value.dateRange, (value) {
      return _then(_value.copyWith(dateRange: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OverviewScopeDtoImplCopyWith<$Res>
    implements $OverviewScopeDtoCopyWith<$Res> {
  factory _$$OverviewScopeDtoImplCopyWith(_$OverviewScopeDtoImpl value,
          $Res Function(_$OverviewScopeDtoImpl) then) =
      __$$OverviewScopeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'company_name') String companyName,
      @JsonKey(name: 'total_stores') int totalStores,
      @JsonKey(name: 'date_range') DateRangeDto dateRange});

  @override
  $DateRangeDtoCopyWith<$Res> get dateRange;
}

/// @nodoc
class __$$OverviewScopeDtoImplCopyWithImpl<$Res>
    extends _$OverviewScopeDtoCopyWithImpl<$Res, _$OverviewScopeDtoImpl>
    implements _$$OverviewScopeDtoImplCopyWith<$Res> {
  __$$OverviewScopeDtoImplCopyWithImpl(_$OverviewScopeDtoImpl _value,
      $Res Function(_$OverviewScopeDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of OverviewScopeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyId = null,
    Object? companyName = null,
    Object? totalStores = null,
    Object? dateRange = null,
  }) {
    return _then(_$OverviewScopeDtoImpl(
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      totalStores: null == totalStores
          ? _value.totalStores
          : totalStores // ignore: cast_nullable_to_non_nullable
              as int,
      dateRange: null == dateRange
          ? _value.dateRange
          : dateRange // ignore: cast_nullable_to_non_nullable
              as DateRangeDto,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OverviewScopeDtoImpl implements _OverviewScopeDto {
  const _$OverviewScopeDtoImpl(
      {@JsonKey(name: 'company_id') this.companyId = '',
      @JsonKey(name: 'company_name') this.companyName = '',
      @JsonKey(name: 'total_stores') this.totalStores = 0,
      @JsonKey(name: 'date_range') required this.dateRange});

  factory _$OverviewScopeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OverviewScopeDtoImplFromJson(json);

  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'company_name')
  final String companyName;
  @override
  @JsonKey(name: 'total_stores')
  final int totalStores;
  @override
  @JsonKey(name: 'date_range')
  final DateRangeDto dateRange;

  @override
  String toString() {
    return 'OverviewScopeDto(companyId: $companyId, companyName: $companyName, totalStores: $totalStores, dateRange: $dateRange)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OverviewScopeDtoImpl &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.totalStores, totalStores) ||
                other.totalStores == totalStores) &&
            (identical(other.dateRange, dateRange) ||
                other.dateRange == dateRange));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, companyId, companyName, totalStores, dateRange);

  /// Create a copy of OverviewScopeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OverviewScopeDtoImplCopyWith<_$OverviewScopeDtoImpl> get copyWith =>
      __$$OverviewScopeDtoImplCopyWithImpl<_$OverviewScopeDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OverviewScopeDtoImplToJson(
      this,
    );
  }
}

abstract class _OverviewScopeDto implements OverviewScopeDto {
  const factory _OverviewScopeDto(
          {@JsonKey(name: 'company_id') final String companyId,
          @JsonKey(name: 'company_name') final String companyName,
          @JsonKey(name: 'total_stores') final int totalStores,
          @JsonKey(name: 'date_range') required final DateRangeDto dateRange}) =
      _$OverviewScopeDtoImpl;

  factory _OverviewScopeDto.fromJson(Map<String, dynamic> json) =
      _$OverviewScopeDtoImpl.fromJson;

  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'company_name')
  String get companyName;
  @override
  @JsonKey(name: 'total_stores')
  int get totalStores;
  @override
  @JsonKey(name: 'date_range')
  DateRangeDto get dateRange;

  /// Create a copy of OverviewScopeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OverviewScopeDtoImplCopyWith<_$OverviewScopeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DateRangeDto _$DateRangeDtoFromJson(Map<String, dynamic> json) {
  return _DateRangeDto.fromJson(json);
}

/// @nodoc
mixin _$DateRangeDto {
  @JsonKey(name: 'start_date')
  String get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  String get endDate => throw _privateConstructorUsedError;

  /// Serializes this DateRangeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DateRangeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DateRangeDtoCopyWith<DateRangeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DateRangeDtoCopyWith<$Res> {
  factory $DateRangeDtoCopyWith(
          DateRangeDto value, $Res Function(DateRangeDto) then) =
      _$DateRangeDtoCopyWithImpl<$Res, DateRangeDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate});
}

/// @nodoc
class _$DateRangeDtoCopyWithImpl<$Res, $Val extends DateRangeDto>
    implements $DateRangeDtoCopyWith<$Res> {
  _$DateRangeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DateRangeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(_value.copyWith(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DateRangeDtoImplCopyWith<$Res>
    implements $DateRangeDtoCopyWith<$Res> {
  factory _$$DateRangeDtoImplCopyWith(
          _$DateRangeDtoImpl value, $Res Function(_$DateRangeDtoImpl) then) =
      __$$DateRangeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate});
}

/// @nodoc
class __$$DateRangeDtoImplCopyWithImpl<$Res>
    extends _$DateRangeDtoCopyWithImpl<$Res, _$DateRangeDtoImpl>
    implements _$$DateRangeDtoImplCopyWith<$Res> {
  __$$DateRangeDtoImplCopyWithImpl(
      _$DateRangeDtoImpl _value, $Res Function(_$DateRangeDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of DateRangeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(_$DateRangeDtoImpl(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DateRangeDtoImpl implements _DateRangeDto {
  const _$DateRangeDtoImpl(
      {@JsonKey(name: 'start_date') this.startDate = '',
      @JsonKey(name: 'end_date') this.endDate = ''});

  factory _$DateRangeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DateRangeDtoImplFromJson(json);

  @override
  @JsonKey(name: 'start_date')
  final String startDate;
  @override
  @JsonKey(name: 'end_date')
  final String endDate;

  @override
  String toString() {
    return 'DateRangeDto(startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DateRangeDtoImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, startDate, endDate);

  /// Create a copy of DateRangeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DateRangeDtoImplCopyWith<_$DateRangeDtoImpl> get copyWith =>
      __$$DateRangeDtoImplCopyWithImpl<_$DateRangeDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DateRangeDtoImplToJson(
      this,
    );
  }
}

abstract class _DateRangeDto implements DateRangeDto {
  const factory _DateRangeDto(
      {@JsonKey(name: 'start_date') final String startDate,
      @JsonKey(name: 'end_date') final String endDate}) = _$DateRangeDtoImpl;

  factory _DateRangeDto.fromJson(Map<String, dynamic> json) =
      _$DateRangeDtoImpl.fromJson;

  @override
  @JsonKey(name: 'start_date')
  String get startDate;
  @override
  @JsonKey(name: 'end_date')
  String get endDate;

  /// Create a copy of DateRangeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DateRangeDtoImplCopyWith<_$DateRangeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OverviewStoreDto _$OverviewStoreDtoFromJson(Map<String, dynamic> json) {
  return _OverviewStoreDto.fromJson(json);
}

/// @nodoc
mixin _$OverviewStoreDto {
  @JsonKey(name: 'store_id')
  String get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_name')
  String get storeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'daily_summary')
  List<DailySummaryDto> get dailySummary => throw _privateConstructorUsedError;
  @JsonKey(name: 'monthly_stats')
  List<MonthlyStatDto> get monthlyStats => throw _privateConstructorUsedError;

  /// Serializes this OverviewStoreDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OverviewStoreDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OverviewStoreDtoCopyWith<OverviewStoreDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OverviewStoreDtoCopyWith<$Res> {
  factory $OverviewStoreDtoCopyWith(
          OverviewStoreDto value, $Res Function(OverviewStoreDto) then) =
      _$OverviewStoreDtoCopyWithImpl<$Res, OverviewStoreDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'store_name') String storeName,
      @JsonKey(name: 'daily_summary') List<DailySummaryDto> dailySummary,
      @JsonKey(name: 'monthly_stats') List<MonthlyStatDto> monthlyStats});
}

/// @nodoc
class _$OverviewStoreDtoCopyWithImpl<$Res, $Val extends OverviewStoreDto>
    implements $OverviewStoreDtoCopyWith<$Res> {
  _$OverviewStoreDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OverviewStoreDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? storeName = null,
    Object? dailySummary = null,
    Object? monthlyStats = null,
  }) {
    return _then(_value.copyWith(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      dailySummary: null == dailySummary
          ? _value.dailySummary
          : dailySummary // ignore: cast_nullable_to_non_nullable
              as List<DailySummaryDto>,
      monthlyStats: null == monthlyStats
          ? _value.monthlyStats
          : monthlyStats // ignore: cast_nullable_to_non_nullable
              as List<MonthlyStatDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OverviewStoreDtoImplCopyWith<$Res>
    implements $OverviewStoreDtoCopyWith<$Res> {
  factory _$$OverviewStoreDtoImplCopyWith(_$OverviewStoreDtoImpl value,
          $Res Function(_$OverviewStoreDtoImpl) then) =
      __$$OverviewStoreDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'store_name') String storeName,
      @JsonKey(name: 'daily_summary') List<DailySummaryDto> dailySummary,
      @JsonKey(name: 'monthly_stats') List<MonthlyStatDto> monthlyStats});
}

/// @nodoc
class __$$OverviewStoreDtoImplCopyWithImpl<$Res>
    extends _$OverviewStoreDtoCopyWithImpl<$Res, _$OverviewStoreDtoImpl>
    implements _$$OverviewStoreDtoImplCopyWith<$Res> {
  __$$OverviewStoreDtoImplCopyWithImpl(_$OverviewStoreDtoImpl _value,
      $Res Function(_$OverviewStoreDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of OverviewStoreDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? storeName = null,
    Object? dailySummary = null,
    Object? monthlyStats = null,
  }) {
    return _then(_$OverviewStoreDtoImpl(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      dailySummary: null == dailySummary
          ? _value._dailySummary
          : dailySummary // ignore: cast_nullable_to_non_nullable
              as List<DailySummaryDto>,
      monthlyStats: null == monthlyStats
          ? _value._monthlyStats
          : monthlyStats // ignore: cast_nullable_to_non_nullable
              as List<MonthlyStatDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OverviewStoreDtoImpl implements _OverviewStoreDto {
  const _$OverviewStoreDtoImpl(
      {@JsonKey(name: 'store_id') this.storeId = '',
      @JsonKey(name: 'store_name') this.storeName = '',
      @JsonKey(name: 'daily_summary')
      final List<DailySummaryDto> dailySummary = const [],
      @JsonKey(name: 'monthly_stats')
      final List<MonthlyStatDto> monthlyStats = const []})
      : _dailySummary = dailySummary,
        _monthlyStats = monthlyStats;

  factory _$OverviewStoreDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OverviewStoreDtoImplFromJson(json);

  @override
  @JsonKey(name: 'store_id')
  final String storeId;
  @override
  @JsonKey(name: 'store_name')
  final String storeName;
  final List<DailySummaryDto> _dailySummary;
  @override
  @JsonKey(name: 'daily_summary')
  List<DailySummaryDto> get dailySummary {
    if (_dailySummary is EqualUnmodifiableListView) return _dailySummary;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailySummary);
  }

  final List<MonthlyStatDto> _monthlyStats;
  @override
  @JsonKey(name: 'monthly_stats')
  List<MonthlyStatDto> get monthlyStats {
    if (_monthlyStats is EqualUnmodifiableListView) return _monthlyStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_monthlyStats);
  }

  @override
  String toString() {
    return 'OverviewStoreDto(storeId: $storeId, storeName: $storeName, dailySummary: $dailySummary, monthlyStats: $monthlyStats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OverviewStoreDtoImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            const DeepCollectionEquality()
                .equals(other._dailySummary, _dailySummary) &&
            const DeepCollectionEquality()
                .equals(other._monthlyStats, _monthlyStats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      storeId,
      storeName,
      const DeepCollectionEquality().hash(_dailySummary),
      const DeepCollectionEquality().hash(_monthlyStats));

  /// Create a copy of OverviewStoreDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OverviewStoreDtoImplCopyWith<_$OverviewStoreDtoImpl> get copyWith =>
      __$$OverviewStoreDtoImplCopyWithImpl<_$OverviewStoreDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OverviewStoreDtoImplToJson(
      this,
    );
  }
}

abstract class _OverviewStoreDto implements OverviewStoreDto {
  const factory _OverviewStoreDto(
      {@JsonKey(name: 'store_id') final String storeId,
      @JsonKey(name: 'store_name') final String storeName,
      @JsonKey(name: 'daily_summary') final List<DailySummaryDto> dailySummary,
      @JsonKey(name: 'monthly_stats')
      final List<MonthlyStatDto> monthlyStats}) = _$OverviewStoreDtoImpl;

  factory _OverviewStoreDto.fromJson(Map<String, dynamic> json) =
      _$OverviewStoreDtoImpl.fromJson;

  @override
  @JsonKey(name: 'store_id')
  String get storeId;
  @override
  @JsonKey(name: 'store_name')
  String get storeName;
  @override
  @JsonKey(name: 'daily_summary')
  List<DailySummaryDto> get dailySummary;
  @override
  @JsonKey(name: 'monthly_stats')
  List<MonthlyStatDto> get monthlyStats;

  /// Create a copy of OverviewStoreDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OverviewStoreDtoImplCopyWith<_$OverviewStoreDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailySummaryDto _$DailySummaryDtoFromJson(Map<String, dynamic> json) {
  return _DailySummaryDto.fromJson(json);
}

/// @nodoc
mixin _$DailySummaryDto {
  @JsonKey(name: 'date')
  String get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_required')
  int get totalRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_approved')
  int get totalApproved => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pending')
  int get totalPending => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_problem')
  bool get hasProblem => throw _privateConstructorUsedError;
  @JsonKey(name: 'fill_rate')
  int get fillRate => throw _privateConstructorUsedError;

  /// Serializes this DailySummaryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailySummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailySummaryDtoCopyWith<DailySummaryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailySummaryDtoCopyWith<$Res> {
  factory $DailySummaryDtoCopyWith(
          DailySummaryDto value, $Res Function(DailySummaryDto) then) =
      _$DailySummaryDtoCopyWithImpl<$Res, DailySummaryDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'date') String date,
      @JsonKey(name: 'total_required') int totalRequired,
      @JsonKey(name: 'total_approved') int totalApproved,
      @JsonKey(name: 'total_pending') int totalPending,
      @JsonKey(name: 'has_problem') bool hasProblem,
      @JsonKey(name: 'fill_rate') int fillRate});
}

/// @nodoc
class _$DailySummaryDtoCopyWithImpl<$Res, $Val extends DailySummaryDto>
    implements $DailySummaryDtoCopyWith<$Res> {
  _$DailySummaryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailySummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? totalRequired = null,
    Object? totalApproved = null,
    Object? totalPending = null,
    Object? hasProblem = null,
    Object? fillRate = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      totalRequired: null == totalRequired
          ? _value.totalRequired
          : totalRequired // ignore: cast_nullable_to_non_nullable
              as int,
      totalApproved: null == totalApproved
          ? _value.totalApproved
          : totalApproved // ignore: cast_nullable_to_non_nullable
              as int,
      totalPending: null == totalPending
          ? _value.totalPending
          : totalPending // ignore: cast_nullable_to_non_nullable
              as int,
      hasProblem: null == hasProblem
          ? _value.hasProblem
          : hasProblem // ignore: cast_nullable_to_non_nullable
              as bool,
      fillRate: null == fillRate
          ? _value.fillRate
          : fillRate // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailySummaryDtoImplCopyWith<$Res>
    implements $DailySummaryDtoCopyWith<$Res> {
  factory _$$DailySummaryDtoImplCopyWith(_$DailySummaryDtoImpl value,
          $Res Function(_$DailySummaryDtoImpl) then) =
      __$$DailySummaryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'date') String date,
      @JsonKey(name: 'total_required') int totalRequired,
      @JsonKey(name: 'total_approved') int totalApproved,
      @JsonKey(name: 'total_pending') int totalPending,
      @JsonKey(name: 'has_problem') bool hasProblem,
      @JsonKey(name: 'fill_rate') int fillRate});
}

/// @nodoc
class __$$DailySummaryDtoImplCopyWithImpl<$Res>
    extends _$DailySummaryDtoCopyWithImpl<$Res, _$DailySummaryDtoImpl>
    implements _$$DailySummaryDtoImplCopyWith<$Res> {
  __$$DailySummaryDtoImplCopyWithImpl(
      _$DailySummaryDtoImpl _value, $Res Function(_$DailySummaryDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailySummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? totalRequired = null,
    Object? totalApproved = null,
    Object? totalPending = null,
    Object? hasProblem = null,
    Object? fillRate = null,
  }) {
    return _then(_$DailySummaryDtoImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      totalRequired: null == totalRequired
          ? _value.totalRequired
          : totalRequired // ignore: cast_nullable_to_non_nullable
              as int,
      totalApproved: null == totalApproved
          ? _value.totalApproved
          : totalApproved // ignore: cast_nullable_to_non_nullable
              as int,
      totalPending: null == totalPending
          ? _value.totalPending
          : totalPending // ignore: cast_nullable_to_non_nullable
              as int,
      hasProblem: null == hasProblem
          ? _value.hasProblem
          : hasProblem // ignore: cast_nullable_to_non_nullable
              as bool,
      fillRate: null == fillRate
          ? _value.fillRate
          : fillRate // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailySummaryDtoImpl implements _DailySummaryDto {
  const _$DailySummaryDtoImpl(
      {@JsonKey(name: 'date') this.date = '',
      @JsonKey(name: 'total_required') this.totalRequired = 0,
      @JsonKey(name: 'total_approved') this.totalApproved = 0,
      @JsonKey(name: 'total_pending') this.totalPending = 0,
      @JsonKey(name: 'has_problem') this.hasProblem = false,
      @JsonKey(name: 'fill_rate') this.fillRate = 0});

  factory _$DailySummaryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailySummaryDtoImplFromJson(json);

  @override
  @JsonKey(name: 'date')
  final String date;
  @override
  @JsonKey(name: 'total_required')
  final int totalRequired;
  @override
  @JsonKey(name: 'total_approved')
  final int totalApproved;
  @override
  @JsonKey(name: 'total_pending')
  final int totalPending;
  @override
  @JsonKey(name: 'has_problem')
  final bool hasProblem;
  @override
  @JsonKey(name: 'fill_rate')
  final int fillRate;

  @override
  String toString() {
    return 'DailySummaryDto(date: $date, totalRequired: $totalRequired, totalApproved: $totalApproved, totalPending: $totalPending, hasProblem: $hasProblem, fillRate: $fillRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailySummaryDtoImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.totalRequired, totalRequired) ||
                other.totalRequired == totalRequired) &&
            (identical(other.totalApproved, totalApproved) ||
                other.totalApproved == totalApproved) &&
            (identical(other.totalPending, totalPending) ||
                other.totalPending == totalPending) &&
            (identical(other.hasProblem, hasProblem) ||
                other.hasProblem == hasProblem) &&
            (identical(other.fillRate, fillRate) ||
                other.fillRate == fillRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, totalRequired,
      totalApproved, totalPending, hasProblem, fillRate);

  /// Create a copy of DailySummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailySummaryDtoImplCopyWith<_$DailySummaryDtoImpl> get copyWith =>
      __$$DailySummaryDtoImplCopyWithImpl<_$DailySummaryDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailySummaryDtoImplToJson(
      this,
    );
  }
}

abstract class _DailySummaryDto implements DailySummaryDto {
  const factory _DailySummaryDto(
      {@JsonKey(name: 'date') final String date,
      @JsonKey(name: 'total_required') final int totalRequired,
      @JsonKey(name: 'total_approved') final int totalApproved,
      @JsonKey(name: 'total_pending') final int totalPending,
      @JsonKey(name: 'has_problem') final bool hasProblem,
      @JsonKey(name: 'fill_rate') final int fillRate}) = _$DailySummaryDtoImpl;

  factory _DailySummaryDto.fromJson(Map<String, dynamic> json) =
      _$DailySummaryDtoImpl.fromJson;

  @override
  @JsonKey(name: 'date')
  String get date;
  @override
  @JsonKey(name: 'total_required')
  int get totalRequired;
  @override
  @JsonKey(name: 'total_approved')
  int get totalApproved;
  @override
  @JsonKey(name: 'total_pending')
  int get totalPending;
  @override
  @JsonKey(name: 'has_problem')
  bool get hasProblem;
  @override
  @JsonKey(name: 'fill_rate')
  int get fillRate;

  /// Create a copy of DailySummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailySummaryDtoImplCopyWith<_$DailySummaryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MonthlyStatDto _$MonthlyStatDtoFromJson(Map<String, dynamic> json) {
  return _MonthlyStatDto.fromJson(json);
}

/// @nodoc
mixin _$MonthlyStatDto {
  @JsonKey(name: 'month')
  String get month => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_requests')
  int get totalRequests => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_approved')
  int get totalApproved => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pending')
  int get totalPending => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_problems')
  int get totalProblems => throw _privateConstructorUsedError;

  /// Serializes this MonthlyStatDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyStatDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyStatDtoCopyWith<MonthlyStatDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyStatDtoCopyWith<$Res> {
  factory $MonthlyStatDtoCopyWith(
          MonthlyStatDto value, $Res Function(MonthlyStatDto) then) =
      _$MonthlyStatDtoCopyWithImpl<$Res, MonthlyStatDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'month') String month,
      @JsonKey(name: 'total_requests') int totalRequests,
      @JsonKey(name: 'total_approved') int totalApproved,
      @JsonKey(name: 'total_pending') int totalPending,
      @JsonKey(name: 'total_problems') int totalProblems});
}

/// @nodoc
class _$MonthlyStatDtoCopyWithImpl<$Res, $Val extends MonthlyStatDto>
    implements $MonthlyStatDtoCopyWith<$Res> {
  _$MonthlyStatDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyStatDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? totalRequests = null,
    Object? totalApproved = null,
    Object? totalPending = null,
    Object? totalProblems = null,
  }) {
    return _then(_value.copyWith(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      totalRequests: null == totalRequests
          ? _value.totalRequests
          : totalRequests // ignore: cast_nullable_to_non_nullable
              as int,
      totalApproved: null == totalApproved
          ? _value.totalApproved
          : totalApproved // ignore: cast_nullable_to_non_nullable
              as int,
      totalPending: null == totalPending
          ? _value.totalPending
          : totalPending // ignore: cast_nullable_to_non_nullable
              as int,
      totalProblems: null == totalProblems
          ? _value.totalProblems
          : totalProblems // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyStatDtoImplCopyWith<$Res>
    implements $MonthlyStatDtoCopyWith<$Res> {
  factory _$$MonthlyStatDtoImplCopyWith(_$MonthlyStatDtoImpl value,
          $Res Function(_$MonthlyStatDtoImpl) then) =
      __$$MonthlyStatDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'month') String month,
      @JsonKey(name: 'total_requests') int totalRequests,
      @JsonKey(name: 'total_approved') int totalApproved,
      @JsonKey(name: 'total_pending') int totalPending,
      @JsonKey(name: 'total_problems') int totalProblems});
}

/// @nodoc
class __$$MonthlyStatDtoImplCopyWithImpl<$Res>
    extends _$MonthlyStatDtoCopyWithImpl<$Res, _$MonthlyStatDtoImpl>
    implements _$$MonthlyStatDtoImplCopyWith<$Res> {
  __$$MonthlyStatDtoImplCopyWithImpl(
      _$MonthlyStatDtoImpl _value, $Res Function(_$MonthlyStatDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyStatDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? totalRequests = null,
    Object? totalApproved = null,
    Object? totalPending = null,
    Object? totalProblems = null,
  }) {
    return _then(_$MonthlyStatDtoImpl(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      totalRequests: null == totalRequests
          ? _value.totalRequests
          : totalRequests // ignore: cast_nullable_to_non_nullable
              as int,
      totalApproved: null == totalApproved
          ? _value.totalApproved
          : totalApproved // ignore: cast_nullable_to_non_nullable
              as int,
      totalPending: null == totalPending
          ? _value.totalPending
          : totalPending // ignore: cast_nullable_to_non_nullable
              as int,
      totalProblems: null == totalProblems
          ? _value.totalProblems
          : totalProblems // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlyStatDtoImpl implements _MonthlyStatDto {
  const _$MonthlyStatDtoImpl(
      {@JsonKey(name: 'month') this.month = '',
      @JsonKey(name: 'total_requests') this.totalRequests = 0,
      @JsonKey(name: 'total_approved') this.totalApproved = 0,
      @JsonKey(name: 'total_pending') this.totalPending = 0,
      @JsonKey(name: 'total_problems') this.totalProblems = 0});

  factory _$MonthlyStatDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlyStatDtoImplFromJson(json);

  @override
  @JsonKey(name: 'month')
  final String month;
  @override
  @JsonKey(name: 'total_requests')
  final int totalRequests;
  @override
  @JsonKey(name: 'total_approved')
  final int totalApproved;
  @override
  @JsonKey(name: 'total_pending')
  final int totalPending;
  @override
  @JsonKey(name: 'total_problems')
  final int totalProblems;

  @override
  String toString() {
    return 'MonthlyStatDto(month: $month, totalRequests: $totalRequests, totalApproved: $totalApproved, totalPending: $totalPending, totalProblems: $totalProblems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyStatDtoImpl &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.totalRequests, totalRequests) ||
                other.totalRequests == totalRequests) &&
            (identical(other.totalApproved, totalApproved) ||
                other.totalApproved == totalApproved) &&
            (identical(other.totalPending, totalPending) ||
                other.totalPending == totalPending) &&
            (identical(other.totalProblems, totalProblems) ||
                other.totalProblems == totalProblems));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, month, totalRequests,
      totalApproved, totalPending, totalProblems);

  /// Create a copy of MonthlyStatDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyStatDtoImplCopyWith<_$MonthlyStatDtoImpl> get copyWith =>
      __$$MonthlyStatDtoImplCopyWithImpl<_$MonthlyStatDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlyStatDtoImplToJson(
      this,
    );
  }
}

abstract class _MonthlyStatDto implements MonthlyStatDto {
  const factory _MonthlyStatDto(
          {@JsonKey(name: 'month') final String month,
          @JsonKey(name: 'total_requests') final int totalRequests,
          @JsonKey(name: 'total_approved') final int totalApproved,
          @JsonKey(name: 'total_pending') final int totalPending,
          @JsonKey(name: 'total_problems') final int totalProblems}) =
      _$MonthlyStatDtoImpl;

  factory _MonthlyStatDto.fromJson(Map<String, dynamic> json) =
      _$MonthlyStatDtoImpl.fromJson;

  @override
  @JsonKey(name: 'month')
  String get month;
  @override
  @JsonKey(name: 'total_requests')
  int get totalRequests;
  @override
  @JsonKey(name: 'total_approved')
  int get totalApproved;
  @override
  @JsonKey(name: 'total_pending')
  int get totalPending;
  @override
  @JsonKey(name: 'total_problems')
  int get totalProblems;

  /// Create a copy of MonthlyStatDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyStatDtoImplCopyWith<_$MonthlyStatDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
