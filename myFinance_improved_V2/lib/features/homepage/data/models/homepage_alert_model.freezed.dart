// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'homepage_alert_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HomepageAlertModel _$HomepageAlertModelFromJson(Map<String, dynamic> json) {
  return _HomepageAlertModel.fromJson(json);
}

/// @nodoc
mixin _$HomepageAlertModel {
  @JsonKey(name: 'is_show')
  bool get isShow => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_checked')
  bool get isChecked => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;

  /// Serializes this HomepageAlertModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HomepageAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomepageAlertModelCopyWith<HomepageAlertModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomepageAlertModelCopyWith<$Res> {
  factory $HomepageAlertModelCopyWith(
          HomepageAlertModel value, $Res Function(HomepageAlertModel) then) =
      _$HomepageAlertModelCopyWithImpl<$Res, HomepageAlertModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'is_show') bool isShow,
      @JsonKey(name: 'is_checked') bool isChecked,
      String? content});
}

/// @nodoc
class _$HomepageAlertModelCopyWithImpl<$Res, $Val extends HomepageAlertModel>
    implements $HomepageAlertModelCopyWith<$Res> {
  _$HomepageAlertModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomepageAlertModel
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
abstract class _$$HomepageAlertModelImplCopyWith<$Res>
    implements $HomepageAlertModelCopyWith<$Res> {
  factory _$$HomepageAlertModelImplCopyWith(_$HomepageAlertModelImpl value,
          $Res Function(_$HomepageAlertModelImpl) then) =
      __$$HomepageAlertModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'is_show') bool isShow,
      @JsonKey(name: 'is_checked') bool isChecked,
      String? content});
}

/// @nodoc
class __$$HomepageAlertModelImplCopyWithImpl<$Res>
    extends _$HomepageAlertModelCopyWithImpl<$Res, _$HomepageAlertModelImpl>
    implements _$$HomepageAlertModelImplCopyWith<$Res> {
  __$$HomepageAlertModelImplCopyWithImpl(_$HomepageAlertModelImpl _value,
      $Res Function(_$HomepageAlertModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomepageAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isShow = null,
    Object? isChecked = null,
    Object? content = freezed,
  }) {
    return _then(_$HomepageAlertModelImpl(
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

@JsonSerializable(fieldRename: FieldRename.snake)
class _$HomepageAlertModelImpl extends _HomepageAlertModel {
  const _$HomepageAlertModelImpl(
      {@JsonKey(name: 'is_show') this.isShow = false,
      @JsonKey(name: 'is_checked') this.isChecked = false,
      this.content})
      : super._();

  factory _$HomepageAlertModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomepageAlertModelImplFromJson(json);

  @override
  @JsonKey(name: 'is_show')
  final bool isShow;
  @override
  @JsonKey(name: 'is_checked')
  final bool isChecked;
  @override
  final String? content;

  @override
  String toString() {
    return 'HomepageAlertModel(isShow: $isShow, isChecked: $isChecked, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomepageAlertModelImpl &&
            (identical(other.isShow, isShow) || other.isShow == isShow) &&
            (identical(other.isChecked, isChecked) ||
                other.isChecked == isChecked) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isShow, isChecked, content);

  /// Create a copy of HomepageAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomepageAlertModelImplCopyWith<_$HomepageAlertModelImpl> get copyWith =>
      __$$HomepageAlertModelImplCopyWithImpl<_$HomepageAlertModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomepageAlertModelImplToJson(
      this,
    );
  }
}

abstract class _HomepageAlertModel extends HomepageAlertModel {
  const factory _HomepageAlertModel(
      {@JsonKey(name: 'is_show') final bool isShow,
      @JsonKey(name: 'is_checked') final bool isChecked,
      final String? content}) = _$HomepageAlertModelImpl;
  const _HomepageAlertModel._() : super._();

  factory _HomepageAlertModel.fromJson(Map<String, dynamic> json) =
      _$HomepageAlertModelImpl.fromJson;

  @override
  @JsonKey(name: 'is_show')
  bool get isShow;
  @override
  @JsonKey(name: 'is_checked')
  bool get isChecked;
  @override
  String? get content;

  /// Create a copy of HomepageAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomepageAlertModelImplCopyWith<_$HomepageAlertModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
