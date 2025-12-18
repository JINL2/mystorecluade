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
