// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EmployeeInfo _$EmployeeInfoFromJson(Map<String, dynamic> json) {
  return _EmployeeInfo.fromJson(json);
}

/// @nodoc
mixin _$EmployeeInfo {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_name')
  String get userName => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_image')
  String? get profileImage => throw _privateConstructorUsedError;
  String? get position => throw _privateConstructorUsedError;
  @JsonKey(name: 'hourly_wage')
  double? get hourlyWage => throw _privateConstructorUsedError;

  /// Serializes this EmployeeInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeInfoCopyWith<EmployeeInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeInfoCopyWith<$Res> {
  factory $EmployeeInfoCopyWith(
          EmployeeInfo value, $Res Function(EmployeeInfo) then) =
      _$EmployeeInfoCopyWithImpl<$Res, EmployeeInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'user_name') String userName,
      @JsonKey(name: 'profile_image') String? profileImage,
      String? position,
      @JsonKey(name: 'hourly_wage') double? hourlyWage});
}

/// @nodoc
class _$EmployeeInfoCopyWithImpl<$Res, $Val extends EmployeeInfo>
    implements $EmployeeInfoCopyWith<$Res> {
  _$EmployeeInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? profileImage = freezed,
    Object? position = freezed,
    Object? hourlyWage = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String?,
      hourlyWage: freezed == hourlyWage
          ? _value.hourlyWage
          : hourlyWage // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmployeeInfoImplCopyWith<$Res>
    implements $EmployeeInfoCopyWith<$Res> {
  factory _$$EmployeeInfoImplCopyWith(
          _$EmployeeInfoImpl value, $Res Function(_$EmployeeInfoImpl) then) =
      __$$EmployeeInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'user_name') String userName,
      @JsonKey(name: 'profile_image') String? profileImage,
      String? position,
      @JsonKey(name: 'hourly_wage') double? hourlyWage});
}

/// @nodoc
class __$$EmployeeInfoImplCopyWithImpl<$Res>
    extends _$EmployeeInfoCopyWithImpl<$Res, _$EmployeeInfoImpl>
    implements _$$EmployeeInfoImplCopyWith<$Res> {
  __$$EmployeeInfoImplCopyWithImpl(
      _$EmployeeInfoImpl _value, $Res Function(_$EmployeeInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of EmployeeInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? profileImage = freezed,
    Object? position = freezed,
    Object? hourlyWage = freezed,
  }) {
    return _then(_$EmployeeInfoImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String?,
      hourlyWage: freezed == hourlyWage
          ? _value.hourlyWage
          : hourlyWage // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeInfoImpl extends _EmployeeInfo {
  const _$EmployeeInfoImpl(
      {@JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'user_name') required this.userName,
      @JsonKey(name: 'profile_image') this.profileImage,
      this.position,
      @JsonKey(name: 'hourly_wage') this.hourlyWage})
      : super._();

  factory _$EmployeeInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeInfoImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'user_name')
  final String userName;
  @override
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  @override
  final String? position;
  @override
  @JsonKey(name: 'hourly_wage')
  final double? hourlyWage;

  @override
  String toString() {
    return 'EmployeeInfo(userId: $userId, userName: $userName, profileImage: $profileImage, position: $position, hourlyWage: $hourlyWage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeInfoImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.hourlyWage, hourlyWage) ||
                other.hourlyWage == hourlyWage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, userId, userName, profileImage, position, hourlyWage);

  /// Create a copy of EmployeeInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeInfoImplCopyWith<_$EmployeeInfoImpl> get copyWith =>
      __$$EmployeeInfoImplCopyWithImpl<_$EmployeeInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeInfoImplToJson(
      this,
    );
  }
}

abstract class _EmployeeInfo extends EmployeeInfo {
  const factory _EmployeeInfo(
          {@JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'user_name') required final String userName,
          @JsonKey(name: 'profile_image') final String? profileImage,
          final String? position,
          @JsonKey(name: 'hourly_wage') final double? hourlyWage}) =
      _$EmployeeInfoImpl;
  const _EmployeeInfo._() : super._();

  factory _EmployeeInfo.fromJson(Map<String, dynamic> json) =
      _$EmployeeInfoImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'user_name')
  String get userName;
  @override
  @JsonKey(name: 'profile_image')
  String? get profileImage;
  @override
  String? get position;
  @override
  @JsonKey(name: 'hourly_wage')
  double? get hourlyWage;

  /// Create a copy of EmployeeInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeInfoImplCopyWith<_$EmployeeInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
