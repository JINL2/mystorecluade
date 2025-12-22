// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manager_memo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ManagerMemo {
  String? get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;

  /// Create a copy of ManagerMemo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManagerMemoCopyWith<ManagerMemo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagerMemoCopyWith<$Res> {
  factory $ManagerMemoCopyWith(
          ManagerMemo value, $Res Function(ManagerMemo) then) =
      _$ManagerMemoCopyWithImpl<$Res, ManagerMemo>;
  @useResult
  $Res call({String? id, String content, String? createdAt, String? createdBy});
}

/// @nodoc
class _$ManagerMemoCopyWithImpl<$Res, $Val extends ManagerMemo>
    implements $ManagerMemoCopyWith<$Res> {
  _$ManagerMemoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManagerMemo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? content = null,
    Object? createdAt = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManagerMemoImplCopyWith<$Res>
    implements $ManagerMemoCopyWith<$Res> {
  factory _$$ManagerMemoImplCopyWith(
          _$ManagerMemoImpl value, $Res Function(_$ManagerMemoImpl) then) =
      __$$ManagerMemoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? id, String content, String? createdAt, String? createdBy});
}

/// @nodoc
class __$$ManagerMemoImplCopyWithImpl<$Res>
    extends _$ManagerMemoCopyWithImpl<$Res, _$ManagerMemoImpl>
    implements _$$ManagerMemoImplCopyWith<$Res> {
  __$$ManagerMemoImplCopyWithImpl(
      _$ManagerMemoImpl _value, $Res Function(_$ManagerMemoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ManagerMemo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? content = null,
    Object? createdAt = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_$ManagerMemoImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ManagerMemoImpl extends _ManagerMemo {
  const _$ManagerMemoImpl(
      {this.id, this.content = '', this.createdAt, this.createdBy})
      : super._();

  @override
  final String? id;
  @override
  @JsonKey()
  final String content;
  @override
  final String? createdAt;
  @override
  final String? createdBy;

  @override
  String toString() {
    return 'ManagerMemo(id: $id, content: $content, createdAt: $createdAt, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManagerMemoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, content, createdAt, createdBy);

  /// Create a copy of ManagerMemo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManagerMemoImplCopyWith<_$ManagerMemoImpl> get copyWith =>
      __$$ManagerMemoImplCopyWithImpl<_$ManagerMemoImpl>(this, _$identity);
}

abstract class _ManagerMemo extends ManagerMemo {
  const factory _ManagerMemo(
      {final String? id,
      final String content,
      final String? createdAt,
      final String? createdBy}) = _$ManagerMemoImpl;
  const _ManagerMemo._() : super._();

  @override
  String? get id;
  @override
  String get content;
  @override
  String? get createdAt;
  @override
  String? get createdBy;

  /// Create a copy of ManagerMemo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManagerMemoImplCopyWith<_$ManagerMemoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
