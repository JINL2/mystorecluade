// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company_type_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CompanyTypeModel _$CompanyTypeModelFromJson(Map<String, dynamic> json) {
  return _CompanyTypeModel.fromJson(json);
}

/// @nodoc
mixin _$CompanyTypeModel {
  @JsonKey(name: 'company_type_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'type_name')
  String get typeName => throw _privateConstructorUsedError;

  /// Serializes this CompanyTypeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompanyTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompanyTypeModelCopyWith<CompanyTypeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyTypeModelCopyWith<$Res> {
  factory $CompanyTypeModelCopyWith(
          CompanyTypeModel value, $Res Function(CompanyTypeModel) then) =
      _$CompanyTypeModelCopyWithImpl<$Res, CompanyTypeModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'company_type_id') String id,
      @JsonKey(name: 'type_name') String typeName});
}

/// @nodoc
class _$CompanyTypeModelCopyWithImpl<$Res, $Val extends CompanyTypeModel>
    implements $CompanyTypeModelCopyWith<$Res> {
  _$CompanyTypeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompanyTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? typeName = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      typeName: null == typeName
          ? _value.typeName
          : typeName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompanyTypeModelImplCopyWith<$Res>
    implements $CompanyTypeModelCopyWith<$Res> {
  factory _$$CompanyTypeModelImplCopyWith(_$CompanyTypeModelImpl value,
          $Res Function(_$CompanyTypeModelImpl) then) =
      __$$CompanyTypeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'company_type_id') String id,
      @JsonKey(name: 'type_name') String typeName});
}

/// @nodoc
class __$$CompanyTypeModelImplCopyWithImpl<$Res>
    extends _$CompanyTypeModelCopyWithImpl<$Res, _$CompanyTypeModelImpl>
    implements _$$CompanyTypeModelImplCopyWith<$Res> {
  __$$CompanyTypeModelImplCopyWithImpl(_$CompanyTypeModelImpl _value,
      $Res Function(_$CompanyTypeModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CompanyTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? typeName = null,
  }) {
    return _then(_$CompanyTypeModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      typeName: null == typeName
          ? _value.typeName
          : typeName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompanyTypeModelImpl extends _CompanyTypeModel {
  const _$CompanyTypeModelImpl(
      {@JsonKey(name: 'company_type_id') required this.id,
      @JsonKey(name: 'type_name') required this.typeName})
      : super._();

  factory _$CompanyTypeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanyTypeModelImplFromJson(json);

  @override
  @JsonKey(name: 'company_type_id')
  final String id;
  @override
  @JsonKey(name: 'type_name')
  final String typeName;

  @override
  String toString() {
    return 'CompanyTypeModel(id: $id, typeName: $typeName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanyTypeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.typeName, typeName) ||
                other.typeName == typeName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, typeName);

  /// Create a copy of CompanyTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanyTypeModelImplCopyWith<_$CompanyTypeModelImpl> get copyWith =>
      __$$CompanyTypeModelImplCopyWithImpl<_$CompanyTypeModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanyTypeModelImplToJson(
      this,
    );
  }
}

abstract class _CompanyTypeModel extends CompanyTypeModel {
  const factory _CompanyTypeModel(
          {@JsonKey(name: 'company_type_id') required final String id,
          @JsonKey(name: 'type_name') required final String typeName}) =
      _$CompanyTypeModelImpl;
  const _CompanyTypeModel._() : super._();

  factory _CompanyTypeModel.fromJson(Map<String, dynamic> json) =
      _$CompanyTypeModelImpl.fromJson;

  @override
  @JsonKey(name: 'company_type_id')
  String get id;
  @override
  @JsonKey(name: 'type_name')
  String get typeName;

  /// Create a copy of CompanyTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompanyTypeModelImplCopyWith<_$CompanyTypeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
