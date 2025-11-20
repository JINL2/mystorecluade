// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CompanyModel _$CompanyModelFromJson(Map<String, dynamic> json) {
  return _CompanyModel.fromJson(json);
}

/// @nodoc
mixin _$CompanyModel {
  @JsonKey(name: 'company_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_code')
  String get code => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_type_id')
  String get companyTypeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_currency_id')
  String get baseCurrencyId => throw _privateConstructorUsedError;

  /// Serializes this CompanyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompanyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompanyModelCopyWith<CompanyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyModelCopyWith<$Res> {
  factory $CompanyModelCopyWith(
          CompanyModel value, $Res Function(CompanyModel) then) =
      _$CompanyModelCopyWithImpl<$Res, CompanyModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'company_id') String id,
      @JsonKey(name: 'company_name') String name,
      @JsonKey(name: 'company_code') String code,
      @JsonKey(name: 'company_type_id') String companyTypeId,
      @JsonKey(name: 'base_currency_id') String baseCurrencyId});
}

/// @nodoc
class _$CompanyModelCopyWithImpl<$Res, $Val extends CompanyModel>
    implements $CompanyModelCopyWith<$Res> {
  _$CompanyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompanyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? companyTypeId = null,
    Object? baseCurrencyId = null,
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
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      companyTypeId: null == companyTypeId
          ? _value.companyTypeId
          : companyTypeId // ignore: cast_nullable_to_non_nullable
              as String,
      baseCurrencyId: null == baseCurrencyId
          ? _value.baseCurrencyId
          : baseCurrencyId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompanyModelImplCopyWith<$Res>
    implements $CompanyModelCopyWith<$Res> {
  factory _$$CompanyModelImplCopyWith(
          _$CompanyModelImpl value, $Res Function(_$CompanyModelImpl) then) =
      __$$CompanyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'company_id') String id,
      @JsonKey(name: 'company_name') String name,
      @JsonKey(name: 'company_code') String code,
      @JsonKey(name: 'company_type_id') String companyTypeId,
      @JsonKey(name: 'base_currency_id') String baseCurrencyId});
}

/// @nodoc
class __$$CompanyModelImplCopyWithImpl<$Res>
    extends _$CompanyModelCopyWithImpl<$Res, _$CompanyModelImpl>
    implements _$$CompanyModelImplCopyWith<$Res> {
  __$$CompanyModelImplCopyWithImpl(
      _$CompanyModelImpl _value, $Res Function(_$CompanyModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CompanyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? companyTypeId = null,
    Object? baseCurrencyId = null,
  }) {
    return _then(_$CompanyModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      companyTypeId: null == companyTypeId
          ? _value.companyTypeId
          : companyTypeId // ignore: cast_nullable_to_non_nullable
              as String,
      baseCurrencyId: null == baseCurrencyId
          ? _value.baseCurrencyId
          : baseCurrencyId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompanyModelImpl extends _CompanyModel {
  const _$CompanyModelImpl(
      {@JsonKey(name: 'company_id') required this.id,
      @JsonKey(name: 'company_name') required this.name,
      @JsonKey(name: 'company_code') required this.code,
      @JsonKey(name: 'company_type_id') required this.companyTypeId,
      @JsonKey(name: 'base_currency_id') required this.baseCurrencyId})
      : super._();

  factory _$CompanyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanyModelImplFromJson(json);

  @override
  @JsonKey(name: 'company_id')
  final String id;
  @override
  @JsonKey(name: 'company_name')
  final String name;
  @override
  @JsonKey(name: 'company_code')
  final String code;
  @override
  @JsonKey(name: 'company_type_id')
  final String companyTypeId;
  @override
  @JsonKey(name: 'base_currency_id')
  final String baseCurrencyId;

  @override
  String toString() {
    return 'CompanyModel(id: $id, name: $name, code: $code, companyTypeId: $companyTypeId, baseCurrencyId: $baseCurrencyId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanyModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.companyTypeId, companyTypeId) ||
                other.companyTypeId == companyTypeId) &&
            (identical(other.baseCurrencyId, baseCurrencyId) ||
                other.baseCurrencyId == baseCurrencyId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, code, companyTypeId, baseCurrencyId);

  /// Create a copy of CompanyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanyModelImplCopyWith<_$CompanyModelImpl> get copyWith =>
      __$$CompanyModelImplCopyWithImpl<_$CompanyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanyModelImplToJson(
      this,
    );
  }
}

abstract class _CompanyModel extends CompanyModel {
  const factory _CompanyModel(
      {@JsonKey(name: 'company_id') required final String id,
      @JsonKey(name: 'company_name') required final String name,
      @JsonKey(name: 'company_code') required final String code,
      @JsonKey(name: 'company_type_id') required final String companyTypeId,
      @JsonKey(name: 'base_currency_id')
      required final String baseCurrencyId}) = _$CompanyModelImpl;
  const _CompanyModel._() : super._();

  factory _CompanyModel.fromJson(Map<String, dynamic> json) =
      _$CompanyModelImpl.fromJson;

  @override
  @JsonKey(name: 'company_id')
  String get id;
  @override
  @JsonKey(name: 'company_name')
  String get name;
  @override
  @JsonKey(name: 'company_code')
  String get code;
  @override
  @JsonKey(name: 'company_type_id')
  String get companyTypeId;
  @override
  @JsonKey(name: 'base_currency_id')
  String get baseCurrencyId;

  /// Create a copy of CompanyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompanyModelImplCopyWith<_$CompanyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
