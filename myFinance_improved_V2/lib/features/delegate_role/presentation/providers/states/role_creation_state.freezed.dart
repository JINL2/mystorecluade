// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_creation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RoleCreationState {
  /// Current step in the creation wizard (0: Basic Info, 1: Permissions, 2: Tags)
  int get currentStep => throw _privateConstructorUsedError;

  /// Whether currently creating the role
  bool get isCreating => throw _privateConstructorUsedError;

  /// Whether user is currently editing text fields
  bool get isEditingText => throw _privateConstructorUsedError;

  /// Selected permission IDs
  Set<String> get selectedPermissions => throw _privateConstructorUsedError;

  /// Expanded category IDs for permission tree
  Set<String> get expandedCategories => throw _privateConstructorUsedError;

  /// Selected role tags
  List<String> get selectedTags => throw _privateConstructorUsedError;

  /// Error message if creation failed
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Field-specific validation errors
  Map<String, String> get fieldErrors => throw _privateConstructorUsedError;

  /// Created role ID after successful creation
  String? get createdRoleId => throw _privateConstructorUsedError;

  /// Create a copy of RoleCreationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoleCreationStateCopyWith<RoleCreationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoleCreationStateCopyWith<$Res> {
  factory $RoleCreationStateCopyWith(
          RoleCreationState value, $Res Function(RoleCreationState) then) =
      _$RoleCreationStateCopyWithImpl<$Res, RoleCreationState>;
  @useResult
  $Res call(
      {int currentStep,
      bool isCreating,
      bool isEditingText,
      Set<String> selectedPermissions,
      Set<String> expandedCategories,
      List<String> selectedTags,
      String? errorMessage,
      Map<String, String> fieldErrors,
      String? createdRoleId});
}

/// @nodoc
class _$RoleCreationStateCopyWithImpl<$Res, $Val extends RoleCreationState>
    implements $RoleCreationStateCopyWith<$Res> {
  _$RoleCreationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoleCreationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? isCreating = null,
    Object? isEditingText = null,
    Object? selectedPermissions = null,
    Object? expandedCategories = null,
    Object? selectedTags = null,
    Object? errorMessage = freezed,
    Object? fieldErrors = null,
    Object? createdRoleId = freezed,
  }) {
    return _then(_value.copyWith(
      currentStep: null == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as int,
      isCreating: null == isCreating
          ? _value.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      isEditingText: null == isEditingText
          ? _value.isEditingText
          : isEditingText // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedPermissions: null == selectedPermissions
          ? _value.selectedPermissions
          : selectedPermissions // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      expandedCategories: null == expandedCategories
          ? _value.expandedCategories
          : expandedCategories // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      selectedTags: null == selectedTags
          ? _value.selectedTags
          : selectedTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldErrors: null == fieldErrors
          ? _value.fieldErrors
          : fieldErrors // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      createdRoleId: freezed == createdRoleId
          ? _value.createdRoleId
          : createdRoleId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoleCreationStateImplCopyWith<$Res>
    implements $RoleCreationStateCopyWith<$Res> {
  factory _$$RoleCreationStateImplCopyWith(_$RoleCreationStateImpl value,
          $Res Function(_$RoleCreationStateImpl) then) =
      __$$RoleCreationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int currentStep,
      bool isCreating,
      bool isEditingText,
      Set<String> selectedPermissions,
      Set<String> expandedCategories,
      List<String> selectedTags,
      String? errorMessage,
      Map<String, String> fieldErrors,
      String? createdRoleId});
}

/// @nodoc
class __$$RoleCreationStateImplCopyWithImpl<$Res>
    extends _$RoleCreationStateCopyWithImpl<$Res, _$RoleCreationStateImpl>
    implements _$$RoleCreationStateImplCopyWith<$Res> {
  __$$RoleCreationStateImplCopyWithImpl(_$RoleCreationStateImpl _value,
      $Res Function(_$RoleCreationStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of RoleCreationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? isCreating = null,
    Object? isEditingText = null,
    Object? selectedPermissions = null,
    Object? expandedCategories = null,
    Object? selectedTags = null,
    Object? errorMessage = freezed,
    Object? fieldErrors = null,
    Object? createdRoleId = freezed,
  }) {
    return _then(_$RoleCreationStateImpl(
      currentStep: null == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as int,
      isCreating: null == isCreating
          ? _value.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      isEditingText: null == isEditingText
          ? _value.isEditingText
          : isEditingText // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedPermissions: null == selectedPermissions
          ? _value._selectedPermissions
          : selectedPermissions // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      expandedCategories: null == expandedCategories
          ? _value._expandedCategories
          : expandedCategories // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      selectedTags: null == selectedTags
          ? _value._selectedTags
          : selectedTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldErrors: null == fieldErrors
          ? _value._fieldErrors
          : fieldErrors // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      createdRoleId: freezed == createdRoleId
          ? _value.createdRoleId
          : createdRoleId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$RoleCreationStateImpl implements _RoleCreationState {
  const _$RoleCreationStateImpl(
      {this.currentStep = 0,
      this.isCreating = false,
      this.isEditingText = false,
      final Set<String> selectedPermissions = const {},
      final Set<String> expandedCategories = const {},
      final List<String> selectedTags = const [],
      this.errorMessage,
      final Map<String, String> fieldErrors = const {},
      this.createdRoleId})
      : _selectedPermissions = selectedPermissions,
        _expandedCategories = expandedCategories,
        _selectedTags = selectedTags,
        _fieldErrors = fieldErrors;

  /// Current step in the creation wizard (0: Basic Info, 1: Permissions, 2: Tags)
  @override
  @JsonKey()
  final int currentStep;

  /// Whether currently creating the role
  @override
  @JsonKey()
  final bool isCreating;

  /// Whether user is currently editing text fields
  @override
  @JsonKey()
  final bool isEditingText;

  /// Selected permission IDs
  final Set<String> _selectedPermissions;

  /// Selected permission IDs
  @override
  @JsonKey()
  Set<String> get selectedPermissions {
    if (_selectedPermissions is EqualUnmodifiableSetView)
      return _selectedPermissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedPermissions);
  }

  /// Expanded category IDs for permission tree
  final Set<String> _expandedCategories;

  /// Expanded category IDs for permission tree
  @override
  @JsonKey()
  Set<String> get expandedCategories {
    if (_expandedCategories is EqualUnmodifiableSetView)
      return _expandedCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_expandedCategories);
  }

  /// Selected role tags
  final List<String> _selectedTags;

  /// Selected role tags
  @override
  @JsonKey()
  List<String> get selectedTags {
    if (_selectedTags is EqualUnmodifiableListView) return _selectedTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedTags);
  }

  /// Error message if creation failed
  @override
  final String? errorMessage;

  /// Field-specific validation errors
  final Map<String, String> _fieldErrors;

  /// Field-specific validation errors
  @override
  @JsonKey()
  Map<String, String> get fieldErrors {
    if (_fieldErrors is EqualUnmodifiableMapView) return _fieldErrors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_fieldErrors);
  }

  /// Created role ID after successful creation
  @override
  final String? createdRoleId;

  @override
  String toString() {
    return 'RoleCreationState(currentStep: $currentStep, isCreating: $isCreating, isEditingText: $isEditingText, selectedPermissions: $selectedPermissions, expandedCategories: $expandedCategories, selectedTags: $selectedTags, errorMessage: $errorMessage, fieldErrors: $fieldErrors, createdRoleId: $createdRoleId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoleCreationStateImpl &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.isCreating, isCreating) ||
                other.isCreating == isCreating) &&
            (identical(other.isEditingText, isEditingText) ||
                other.isEditingText == isEditingText) &&
            const DeepCollectionEquality()
                .equals(other._selectedPermissions, _selectedPermissions) &&
            const DeepCollectionEquality()
                .equals(other._expandedCategories, _expandedCategories) &&
            const DeepCollectionEquality()
                .equals(other._selectedTags, _selectedTags) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality()
                .equals(other._fieldErrors, _fieldErrors) &&
            (identical(other.createdRoleId, createdRoleId) ||
                other.createdRoleId == createdRoleId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentStep,
      isCreating,
      isEditingText,
      const DeepCollectionEquality().hash(_selectedPermissions),
      const DeepCollectionEquality().hash(_expandedCategories),
      const DeepCollectionEquality().hash(_selectedTags),
      errorMessage,
      const DeepCollectionEquality().hash(_fieldErrors),
      createdRoleId);

  /// Create a copy of RoleCreationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoleCreationStateImplCopyWith<_$RoleCreationStateImpl> get copyWith =>
      __$$RoleCreationStateImplCopyWithImpl<_$RoleCreationStateImpl>(
          this, _$identity);
}

abstract class _RoleCreationState implements RoleCreationState {
  const factory _RoleCreationState(
      {final int currentStep,
      final bool isCreating,
      final bool isEditingText,
      final Set<String> selectedPermissions,
      final Set<String> expandedCategories,
      final List<String> selectedTags,
      final String? errorMessage,
      final Map<String, String> fieldErrors,
      final String? createdRoleId}) = _$RoleCreationStateImpl;

  /// Current step in the creation wizard (0: Basic Info, 1: Permissions, 2: Tags)
  @override
  int get currentStep;

  /// Whether currently creating the role
  @override
  bool get isCreating;

  /// Whether user is currently editing text fields
  @override
  bool get isEditingText;

  /// Selected permission IDs
  @override
  Set<String> get selectedPermissions;

  /// Expanded category IDs for permission tree
  @override
  Set<String> get expandedCategories;

  /// Selected role tags
  @override
  List<String> get selectedTags;

  /// Error message if creation failed
  @override
  String? get errorMessage;

  /// Field-specific validation errors
  @override
  Map<String, String> get fieldErrors;

  /// Created role ID after successful creation
  @override
  String? get createdRoleId;

  /// Create a copy of RoleCreationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoleCreationStateImplCopyWith<_$RoleCreationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
