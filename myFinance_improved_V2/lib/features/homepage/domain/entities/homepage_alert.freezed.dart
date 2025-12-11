// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'homepage_alert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomepageAlert {
  bool get isShow => throw _privateConstructorUsedError;
  bool get isChecked => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;

  /// Create a copy of HomepageAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomepageAlertCopyWith<HomepageAlert> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomepageAlertCopyWith<$Res> {
  factory $HomepageAlertCopyWith(
          HomepageAlert value, $Res Function(HomepageAlert) then) =
      _$HomepageAlertCopyWithImpl<$Res, HomepageAlert>;
  @useResult
  $Res call({bool isShow, bool isChecked, String? content});
}

/// @nodoc
class _$HomepageAlertCopyWithImpl<$Res, $Val extends HomepageAlert>
    implements $HomepageAlertCopyWith<$Res> {
  _$HomepageAlertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomepageAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isShow = null,
    Object? isChecked = null,
    Object? content = freezed,
  }) {
    return _then(_value.copyWith(
      isShow: null == isShow
          ? _value.isShow
          : isShow // ignore: cast_nullable_to_non_nullable
              as bool,
      isChecked: null == isChecked
          ? _value.isChecked
          : isChecked // ignore: cast_nullable_to_non_nullable
              as bool,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomepageAlertImplCopyWith<$Res>
    implements $HomepageAlertCopyWith<$Res> {
  factory _$$HomepageAlertImplCopyWith(
          _$HomepageAlertImpl value, $Res Function(_$HomepageAlertImpl) then) =
      __$$HomepageAlertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isShow, bool isChecked, String? content});
}

/// @nodoc
class __$$HomepageAlertImplCopyWithImpl<$Res>
    extends _$HomepageAlertCopyWithImpl<$Res, _$HomepageAlertImpl>
    implements _$$HomepageAlertImplCopyWith<$Res> {
  __$$HomepageAlertImplCopyWithImpl(
      _$HomepageAlertImpl _value, $Res Function(_$HomepageAlertImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomepageAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isShow = null,
    Object? isChecked = null,
    Object? content = freezed,
  }) {
    return _then(_$HomepageAlertImpl(
      isShow: null == isShow
          ? _value.isShow
          : isShow // ignore: cast_nullable_to_non_nullable
              as bool,
      isChecked: null == isChecked
          ? _value.isChecked
          : isChecked // ignore: cast_nullable_to_non_nullable
              as bool,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$HomepageAlertImpl extends _HomepageAlert {
  const _$HomepageAlertImpl(
      {this.isShow = false, this.isChecked = false, this.content})
      : super._();

  @override
  @JsonKey()
  final bool isShow;
  @override
  @JsonKey()
  final bool isChecked;
  @override
  final String? content;

  @override
  String toString() {
    return 'HomepageAlert(isShow: $isShow, isChecked: $isChecked, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomepageAlertImpl &&
            (identical(other.isShow, isShow) || other.isShow == isShow) &&
            (identical(other.isChecked, isChecked) ||
                other.isChecked == isChecked) &&
            (identical(other.content, content) || other.content == content));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isShow, isChecked, content);

  /// Create a copy of HomepageAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomepageAlertImplCopyWith<_$HomepageAlertImpl> get copyWith =>
      __$$HomepageAlertImplCopyWithImpl<_$HomepageAlertImpl>(this, _$identity);
}

abstract class _HomepageAlert extends HomepageAlert {
  const factory _HomepageAlert(
      {final bool isShow,
      final bool isChecked,
      final String? content}) = _$HomepageAlertImpl;
  const _HomepageAlert._() : super._();

  @override
  bool get isShow;
  @override
  bool get isChecked;
  @override
  String? get content;

  /// Create a copy of HomepageAlert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomepageAlertImplCopyWith<_$HomepageAlertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
