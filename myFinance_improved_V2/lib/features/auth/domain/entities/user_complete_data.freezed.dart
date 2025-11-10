// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_complete_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserCompleteData _$UserCompleteDataFromJson(Map<String, dynamic> json) {
  return _UserCompleteData.fromJson(json);
}

/// @nodoc
mixin _$UserCompleteData {
  /// User profile data
  User get user => throw _privateConstructorUsedError;

  /// Companies where user is owner or member
  List<Company> get companies => throw _privateConstructorUsedError;

  /// Stores where user has access
  List<Store> get stores => throw _privateConstructorUsedError;

  /// Serializes this UserCompleteData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserCompleteData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCompleteDataCopyWith<UserCompleteData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCompleteDataCopyWith<$Res> {
  factory $UserCompleteDataCopyWith(
          UserCompleteData value, $Res Function(UserCompleteData) then) =
      _$UserCompleteDataCopyWithImpl<$Res, UserCompleteData>;
  @useResult
  $Res call({User user, List<Company> companies, List<Store> stores});

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class _$UserCompleteDataCopyWithImpl<$Res, $Val extends UserCompleteData>
    implements $UserCompleteDataCopyWith<$Res> {
  _$UserCompleteDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserCompleteData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? companies = null,
    Object? stores = null,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      companies: null == companies
          ? _value.companies
          : companies // ignore: cast_nullable_to_non_nullable
              as List<Company>,
      stores: null == stores
          ? _value.stores
          : stores // ignore: cast_nullable_to_non_nullable
              as List<Store>,
    ) as $Val);
  }

  /// Create a copy of UserCompleteData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserCompleteDataImplCopyWith<$Res>
    implements $UserCompleteDataCopyWith<$Res> {
  factory _$$UserCompleteDataImplCopyWith(_$UserCompleteDataImpl value,
          $Res Function(_$UserCompleteDataImpl) then) =
      __$$UserCompleteDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({User user, List<Company> companies, List<Store> stores});

  @override
  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$$UserCompleteDataImplCopyWithImpl<$Res>
    extends _$UserCompleteDataCopyWithImpl<$Res, _$UserCompleteDataImpl>
    implements _$$UserCompleteDataImplCopyWith<$Res> {
  __$$UserCompleteDataImplCopyWithImpl(_$UserCompleteDataImpl _value,
      $Res Function(_$UserCompleteDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserCompleteData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? companies = null,
    Object? stores = null,
  }) {
    return _then(_$UserCompleteDataImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      companies: null == companies
          ? _value._companies
          : companies // ignore: cast_nullable_to_non_nullable
              as List<Company>,
      stores: null == stores
          ? _value._stores
          : stores // ignore: cast_nullable_to_non_nullable
              as List<Store>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserCompleteDataImpl extends _UserCompleteData {
  const _$UserCompleteDataImpl(
      {required this.user,
      final List<Company> companies = const [],
      final List<Store> stores = const []})
      : _companies = companies,
        _stores = stores,
        super._();

  factory _$UserCompleteDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserCompleteDataImplFromJson(json);

  /// User profile data
  @override
  final User user;

  /// Companies where user is owner or member
  final List<Company> _companies;

  /// Companies where user is owner or member
  @override
  @JsonKey()
  List<Company> get companies {
    if (_companies is EqualUnmodifiableListView) return _companies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_companies);
  }

  /// Stores where user has access
  final List<Store> _stores;

  /// Stores where user has access
  @override
  @JsonKey()
  List<Store> get stores {
    if (_stores is EqualUnmodifiableListView) return _stores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stores);
  }

  @override
  String toString() {
    return 'UserCompleteData(user: $user, companies: $companies, stores: $stores)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserCompleteDataImpl &&
            (identical(other.user, user) || other.user == user) &&
            const DeepCollectionEquality()
                .equals(other._companies, _companies) &&
            const DeepCollectionEquality().equals(other._stores, _stores));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      user,
      const DeepCollectionEquality().hash(_companies),
      const DeepCollectionEquality().hash(_stores));

  /// Create a copy of UserCompleteData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserCompleteDataImplCopyWith<_$UserCompleteDataImpl> get copyWith =>
      __$$UserCompleteDataImplCopyWithImpl<_$UserCompleteDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserCompleteDataImplToJson(
      this,
    );
  }
}

abstract class _UserCompleteData extends UserCompleteData {
  const factory _UserCompleteData(
      {required final User user,
      final List<Company> companies,
      final List<Store> stores}) = _$UserCompleteDataImpl;
  const _UserCompleteData._() : super._();

  factory _UserCompleteData.fromJson(Map<String, dynamic> json) =
      _$UserCompleteDataImpl.fromJson;

  /// User profile data
  @override
  User get user;

  /// Companies where user is owner or member
  @override
  List<Company> get companies;

  /// Stores where user has access
  @override
  List<Store> get stores;

  /// Create a copy of UserCompleteData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserCompleteDataImplCopyWith<_$UserCompleteDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
