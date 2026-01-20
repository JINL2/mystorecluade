// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'threshold_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ThresholdInfo {
  /// 긴급 임계값 (P10 일수)
  double get criticalDays => throw _privateConstructorUsedError;

  /// 주의 임계값 (P25 일수)
  double get warningDays => throw _privateConstructorUsedError;

  /// 임계값 소스 ('calculated' 또는 'default')
  String get source => throw _privateConstructorUsedError;

  /// 샘플 크기 (통계 계산에 사용된 상품 수)
  int get sampleSize => throw _privateConstructorUsedError;

  /// Create a copy of ThresholdInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ThresholdInfoCopyWith<ThresholdInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThresholdInfoCopyWith<$Res> {
  factory $ThresholdInfoCopyWith(
          ThresholdInfo value, $Res Function(ThresholdInfo) then) =
      _$ThresholdInfoCopyWithImpl<$Res, ThresholdInfo>;
  @useResult
  $Res call(
      {double criticalDays, double warningDays, String source, int sampleSize});
}

/// @nodoc
class _$ThresholdInfoCopyWithImpl<$Res, $Val extends ThresholdInfo>
    implements $ThresholdInfoCopyWith<$Res> {
  _$ThresholdInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ThresholdInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? criticalDays = null,
    Object? warningDays = null,
    Object? source = null,
    Object? sampleSize = null,
  }) {
    return _then(_value.copyWith(
      criticalDays: null == criticalDays
          ? _value.criticalDays
          : criticalDays // ignore: cast_nullable_to_non_nullable
              as double,
      warningDays: null == warningDays
          ? _value.warningDays
          : warningDays // ignore: cast_nullable_to_non_nullable
              as double,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      sampleSize: null == sampleSize
          ? _value.sampleSize
          : sampleSize // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ThresholdInfoImplCopyWith<$Res>
    implements $ThresholdInfoCopyWith<$Res> {
  factory _$$ThresholdInfoImplCopyWith(
          _$ThresholdInfoImpl value, $Res Function(_$ThresholdInfoImpl) then) =
      __$$ThresholdInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double criticalDays, double warningDays, String source, int sampleSize});
}

/// @nodoc
class __$$ThresholdInfoImplCopyWithImpl<$Res>
    extends _$ThresholdInfoCopyWithImpl<$Res, _$ThresholdInfoImpl>
    implements _$$ThresholdInfoImplCopyWith<$Res> {
  __$$ThresholdInfoImplCopyWithImpl(
      _$ThresholdInfoImpl _value, $Res Function(_$ThresholdInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ThresholdInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? criticalDays = null,
    Object? warningDays = null,
    Object? source = null,
    Object? sampleSize = null,
  }) {
    return _then(_$ThresholdInfoImpl(
      criticalDays: null == criticalDays
          ? _value.criticalDays
          : criticalDays // ignore: cast_nullable_to_non_nullable
              as double,
      warningDays: null == warningDays
          ? _value.warningDays
          : warningDays // ignore: cast_nullable_to_non_nullable
              as double,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      sampleSize: null == sampleSize
          ? _value.sampleSize
          : sampleSize // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ThresholdInfoImpl extends _ThresholdInfo {
  const _$ThresholdInfoImpl(
      {required this.criticalDays,
      required this.warningDays,
      required this.source,
      required this.sampleSize})
      : super._();

  /// 긴급 임계값 (P10 일수)
  @override
  final double criticalDays;

  /// 주의 임계값 (P25 일수)
  @override
  final double warningDays;

  /// 임계값 소스 ('calculated' 또는 'default')
  @override
  final String source;

  /// 샘플 크기 (통계 계산에 사용된 상품 수)
  @override
  final int sampleSize;

  @override
  String toString() {
    return 'ThresholdInfo(criticalDays: $criticalDays, warningDays: $warningDays, source: $source, sampleSize: $sampleSize)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThresholdInfoImpl &&
            (identical(other.criticalDays, criticalDays) ||
                other.criticalDays == criticalDays) &&
            (identical(other.warningDays, warningDays) ||
                other.warningDays == warningDays) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.sampleSize, sampleSize) ||
                other.sampleSize == sampleSize));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, criticalDays, warningDays, source, sampleSize);

  /// Create a copy of ThresholdInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ThresholdInfoImplCopyWith<_$ThresholdInfoImpl> get copyWith =>
      __$$ThresholdInfoImplCopyWithImpl<_$ThresholdInfoImpl>(this, _$identity);
}

abstract class _ThresholdInfo extends ThresholdInfo {
  const factory _ThresholdInfo(
      {required final double criticalDays,
      required final double warningDays,
      required final String source,
      required final int sampleSize}) = _$ThresholdInfoImpl;
  const _ThresholdInfo._() : super._();

  /// 긴급 임계값 (P10 일수)
  @override
  double get criticalDays;

  /// 주의 임계값 (P25 일수)
  @override
  double get warningDays;

  /// 임계값 소스 ('calculated' 또는 'default')
  @override
  String get source;

  /// 샘플 크기 (통계 계산에 사용된 상품 수)
  @override
  int get sampleSize;

  /// Create a copy of ThresholdInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ThresholdInfoImplCopyWith<_$ThresholdInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
