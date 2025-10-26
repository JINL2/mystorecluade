// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MyPageState {
  UserProfile? get userProfile => throw _privateConstructorUsedError;
  BusinessDashboard? get businessDashboard =>
      throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isUpdating => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of MyPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MyPageStateCopyWith<MyPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyPageStateCopyWith<$Res> {
  factory $MyPageStateCopyWith(
          MyPageState value, $Res Function(MyPageState) then) =
      _$MyPageStateCopyWithImpl<$Res, MyPageState>;
  @useResult
  $Res call(
      {UserProfile? userProfile,
      BusinessDashboard? businessDashboard,
      bool isLoading,
      bool isUpdating,
      String? errorMessage});

  $UserProfileCopyWith<$Res>? get userProfile;
}

/// @nodoc
class _$MyPageStateCopyWithImpl<$Res, $Val extends MyPageState>
    implements $MyPageStateCopyWith<$Res> {
  _$MyPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MyPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userProfile = freezed,
    Object? businessDashboard = freezed,
    Object? isLoading = null,
    Object? isUpdating = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      userProfile: freezed == userProfile
          ? _value.userProfile
          : userProfile // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      businessDashboard: freezed == businessDashboard
          ? _value.businessDashboard
          : businessDashboard // ignore: cast_nullable_to_non_nullable
              as BusinessDashboard?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdating: null == isUpdating
          ? _value.isUpdating
          : isUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of MyPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res>? get userProfile {
    if (_value.userProfile == null) {
      return null;
    }

    return $UserProfileCopyWith<$Res>(_value.userProfile!, (value) {
      return _then(_value.copyWith(userProfile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MyPageStateImplCopyWith<$Res>
    implements $MyPageStateCopyWith<$Res> {
  factory _$$MyPageStateImplCopyWith(
          _$MyPageStateImpl value, $Res Function(_$MyPageStateImpl) then) =
      __$$MyPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserProfile? userProfile,
      BusinessDashboard? businessDashboard,
      bool isLoading,
      bool isUpdating,
      String? errorMessage});

  @override
  $UserProfileCopyWith<$Res>? get userProfile;
}

/// @nodoc
class __$$MyPageStateImplCopyWithImpl<$Res>
    extends _$MyPageStateCopyWithImpl<$Res, _$MyPageStateImpl>
    implements _$$MyPageStateImplCopyWith<$Res> {
  __$$MyPageStateImplCopyWithImpl(
      _$MyPageStateImpl _value, $Res Function(_$MyPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MyPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userProfile = freezed,
    Object? businessDashboard = freezed,
    Object? isLoading = null,
    Object? isUpdating = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$MyPageStateImpl(
      userProfile: freezed == userProfile
          ? _value.userProfile
          : userProfile // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      businessDashboard: freezed == businessDashboard
          ? _value.businessDashboard
          : businessDashboard // ignore: cast_nullable_to_non_nullable
              as BusinessDashboard?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdating: null == isUpdating
          ? _value.isUpdating
          : isUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$MyPageStateImpl implements _MyPageState {
  const _$MyPageStateImpl(
      {this.userProfile,
      this.businessDashboard,
      this.isLoading = false,
      this.isUpdating = false,
      this.errorMessage});

  @override
  final UserProfile? userProfile;
  @override
  final BusinessDashboard? businessDashboard;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isUpdating;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'MyPageState(userProfile: $userProfile, businessDashboard: $businessDashboard, isLoading: $isLoading, isUpdating: $isUpdating, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MyPageStateImpl &&
            (identical(other.userProfile, userProfile) ||
                other.userProfile == userProfile) &&
            (identical(other.businessDashboard, businessDashboard) ||
                other.businessDashboard == businessDashboard) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isUpdating, isUpdating) ||
                other.isUpdating == isUpdating) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userProfile, businessDashboard,
      isLoading, isUpdating, errorMessage);

  /// Create a copy of MyPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MyPageStateImplCopyWith<_$MyPageStateImpl> get copyWith =>
      __$$MyPageStateImplCopyWithImpl<_$MyPageStateImpl>(this, _$identity);
}

abstract class _MyPageState implements MyPageState {
  const factory _MyPageState(
      {final UserProfile? userProfile,
      final BusinessDashboard? businessDashboard,
      final bool isLoading,
      final bool isUpdating,
      final String? errorMessage}) = _$MyPageStateImpl;

  @override
  UserProfile? get userProfile;
  @override
  BusinessDashboard? get businessDashboard;
  @override
  bool get isLoading;
  @override
  bool get isUpdating;
  @override
  String? get errorMessage;

  /// Create a copy of MyPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MyPageStateImplCopyWith<_$MyPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ProfileEditState {
  bool get isEditing => throw _privateConstructorUsedError;
  bool get isSaving => throw _privateConstructorUsedError;
  bool get isUploadingImage => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  Map<String, String> get fieldErrors => throw _privateConstructorUsedError;

  /// Create a copy of ProfileEditState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileEditStateCopyWith<ProfileEditState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileEditStateCopyWith<$Res> {
  factory $ProfileEditStateCopyWith(
          ProfileEditState value, $Res Function(ProfileEditState) then) =
      _$ProfileEditStateCopyWithImpl<$Res, ProfileEditState>;
  @useResult
  $Res call(
      {bool isEditing,
      bool isSaving,
      bool isUploadingImage,
      String? errorMessage,
      Map<String, String> fieldErrors});
}

/// @nodoc
class _$ProfileEditStateCopyWithImpl<$Res, $Val extends ProfileEditState>
    implements $ProfileEditStateCopyWith<$Res> {
  _$ProfileEditStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileEditState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isEditing = null,
    Object? isSaving = null,
    Object? isUploadingImage = null,
    Object? errorMessage = freezed,
    Object? fieldErrors = null,
  }) {
    return _then(_value.copyWith(
      isEditing: null == isEditing
          ? _value.isEditing
          : isEditing // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _value.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      isUploadingImage: null == isUploadingImage
          ? _value.isUploadingImage
          : isUploadingImage // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldErrors: null == fieldErrors
          ? _value.fieldErrors
          : fieldErrors // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileEditStateImplCopyWith<$Res>
    implements $ProfileEditStateCopyWith<$Res> {
  factory _$$ProfileEditStateImplCopyWith(_$ProfileEditStateImpl value,
          $Res Function(_$ProfileEditStateImpl) then) =
      __$$ProfileEditStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isEditing,
      bool isSaving,
      bool isUploadingImage,
      String? errorMessage,
      Map<String, String> fieldErrors});
}

/// @nodoc
class __$$ProfileEditStateImplCopyWithImpl<$Res>
    extends _$ProfileEditStateCopyWithImpl<$Res, _$ProfileEditStateImpl>
    implements _$$ProfileEditStateImplCopyWith<$Res> {
  __$$ProfileEditStateImplCopyWithImpl(_$ProfileEditStateImpl _value,
      $Res Function(_$ProfileEditStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileEditState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isEditing = null,
    Object? isSaving = null,
    Object? isUploadingImage = null,
    Object? errorMessage = freezed,
    Object? fieldErrors = null,
  }) {
    return _then(_$ProfileEditStateImpl(
      isEditing: null == isEditing
          ? _value.isEditing
          : isEditing // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _value.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      isUploadingImage: null == isUploadingImage
          ? _value.isUploadingImage
          : isUploadingImage // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldErrors: null == fieldErrors
          ? _value._fieldErrors
          : fieldErrors // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc

class _$ProfileEditStateImpl implements _ProfileEditState {
  const _$ProfileEditStateImpl(
      {this.isEditing = false,
      this.isSaving = false,
      this.isUploadingImage = false,
      this.errorMessage,
      final Map<String, String> fieldErrors = const {}})
      : _fieldErrors = fieldErrors;

  @override
  @JsonKey()
  final bool isEditing;
  @override
  @JsonKey()
  final bool isSaving;
  @override
  @JsonKey()
  final bool isUploadingImage;
  @override
  final String? errorMessage;
  final Map<String, String> _fieldErrors;
  @override
  @JsonKey()
  Map<String, String> get fieldErrors {
    if (_fieldErrors is EqualUnmodifiableMapView) return _fieldErrors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_fieldErrors);
  }

  @override
  String toString() {
    return 'ProfileEditState(isEditing: $isEditing, isSaving: $isSaving, isUploadingImage: $isUploadingImage, errorMessage: $errorMessage, fieldErrors: $fieldErrors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileEditStateImpl &&
            (identical(other.isEditing, isEditing) ||
                other.isEditing == isEditing) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.isUploadingImage, isUploadingImage) ||
                other.isUploadingImage == isUploadingImage) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality()
                .equals(other._fieldErrors, _fieldErrors));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isEditing,
      isSaving,
      isUploadingImage,
      errorMessage,
      const DeepCollectionEquality().hash(_fieldErrors));

  /// Create a copy of ProfileEditState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileEditStateImplCopyWith<_$ProfileEditStateImpl> get copyWith =>
      __$$ProfileEditStateImplCopyWithImpl<_$ProfileEditStateImpl>(
          this, _$identity);
}

abstract class _ProfileEditState implements ProfileEditState {
  const factory _ProfileEditState(
      {final bool isEditing,
      final bool isSaving,
      final bool isUploadingImage,
      final String? errorMessage,
      final Map<String, String> fieldErrors}) = _$ProfileEditStateImpl;

  @override
  bool get isEditing;
  @override
  bool get isSaving;
  @override
  bool get isUploadingImage;
  @override
  String? get errorMessage;
  @override
  Map<String, String> get fieldErrors;

  /// Create a copy of ProfileEditState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileEditStateImplCopyWith<_$ProfileEditStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
