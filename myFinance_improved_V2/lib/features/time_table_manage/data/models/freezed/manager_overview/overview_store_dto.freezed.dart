// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overview_store_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

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
