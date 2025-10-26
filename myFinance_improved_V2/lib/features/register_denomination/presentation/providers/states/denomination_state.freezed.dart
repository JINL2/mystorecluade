// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'denomination_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DenominationState {
  /// List of denominations for the selected currency
  List<Denomination> get denominations => throw _privateConstructorUsedError;

  /// Currently selected denomination for editing
  Denomination? get selectedDenomination => throw _privateConstructorUsedError;

  /// Whether currently loading denominations
  bool get isLoading => throw _privateConstructorUsedError;

  /// Whether currently adding a denomination
  bool get isAdding => throw _privateConstructorUsedError;

  /// Whether currently updating a denomination
  bool get isUpdating => throw _privateConstructorUsedError;

  /// Whether currently deleting a denomination
  bool get isDeleting => throw _privateConstructorUsedError;

  /// Error message if any error occurred
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Field-specific validation errors
  Map<String, String> get fieldErrors => throw _privateConstructorUsedError;

  /// Selected currency ID for filtering
  String? get selectedCurrencyId => throw _privateConstructorUsedError;

  /// Create a copy of DenominationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DenominationStateCopyWith<DenominationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DenominationStateCopyWith<$Res> {
  factory $DenominationStateCopyWith(
          DenominationState value, $Res Function(DenominationState) then) =
      _$DenominationStateCopyWithImpl<$Res, DenominationState>;
  @useResult
  $Res call(
      {List<Denomination> denominations,
      Denomination? selectedDenomination,
      bool isLoading,
      bool isAdding,
      bool isUpdating,
      bool isDeleting,
      String? errorMessage,
      Map<String, String> fieldErrors,
      String? selectedCurrencyId});

  $DenominationCopyWith<$Res>? get selectedDenomination;
}

/// @nodoc
class _$DenominationStateCopyWithImpl<$Res, $Val extends DenominationState>
    implements $DenominationStateCopyWith<$Res> {
  _$DenominationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DenominationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? denominations = null,
    Object? selectedDenomination = freezed,
    Object? isLoading = null,
    Object? isAdding = null,
    Object? isUpdating = null,
    Object? isDeleting = null,
    Object? errorMessage = freezed,
    Object? fieldErrors = null,
    Object? selectedCurrencyId = freezed,
  }) {
    return _then(_value.copyWith(
      denominations: null == denominations
          ? _value.denominations
          : denominations // ignore: cast_nullable_to_non_nullable
              as List<Denomination>,
      selectedDenomination: freezed == selectedDenomination
          ? _value.selectedDenomination
          : selectedDenomination // ignore: cast_nullable_to_non_nullable
              as Denomination?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdding: null == isAdding
          ? _value.isAdding
          : isAdding // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdating: null == isUpdating
          ? _value.isUpdating
          : isUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleting: null == isDeleting
          ? _value.isDeleting
          : isDeleting // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldErrors: null == fieldErrors
          ? _value.fieldErrors
          : fieldErrors // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      selectedCurrencyId: freezed == selectedCurrencyId
          ? _value.selectedCurrencyId
          : selectedCurrencyId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of DenominationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DenominationCopyWith<$Res>? get selectedDenomination {
    if (_value.selectedDenomination == null) {
      return null;
    }

    return $DenominationCopyWith<$Res>(_value.selectedDenomination!, (value) {
      return _then(_value.copyWith(selectedDenomination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DenominationStateImplCopyWith<$Res>
    implements $DenominationStateCopyWith<$Res> {
  factory _$$DenominationStateImplCopyWith(_$DenominationStateImpl value,
          $Res Function(_$DenominationStateImpl) then) =
      __$$DenominationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Denomination> denominations,
      Denomination? selectedDenomination,
      bool isLoading,
      bool isAdding,
      bool isUpdating,
      bool isDeleting,
      String? errorMessage,
      Map<String, String> fieldErrors,
      String? selectedCurrencyId});

  @override
  $DenominationCopyWith<$Res>? get selectedDenomination;
}

/// @nodoc
class __$$DenominationStateImplCopyWithImpl<$Res>
    extends _$DenominationStateCopyWithImpl<$Res, _$DenominationStateImpl>
    implements _$$DenominationStateImplCopyWith<$Res> {
  __$$DenominationStateImplCopyWithImpl(_$DenominationStateImpl _value,
      $Res Function(_$DenominationStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DenominationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? denominations = null,
    Object? selectedDenomination = freezed,
    Object? isLoading = null,
    Object? isAdding = null,
    Object? isUpdating = null,
    Object? isDeleting = null,
    Object? errorMessage = freezed,
    Object? fieldErrors = null,
    Object? selectedCurrencyId = freezed,
  }) {
    return _then(_$DenominationStateImpl(
      denominations: null == denominations
          ? _value._denominations
          : denominations // ignore: cast_nullable_to_non_nullable
              as List<Denomination>,
      selectedDenomination: freezed == selectedDenomination
          ? _value.selectedDenomination
          : selectedDenomination // ignore: cast_nullable_to_non_nullable
              as Denomination?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdding: null == isAdding
          ? _value.isAdding
          : isAdding // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdating: null == isUpdating
          ? _value.isUpdating
          : isUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleting: null == isDeleting
          ? _value.isDeleting
          : isDeleting // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldErrors: null == fieldErrors
          ? _value._fieldErrors
          : fieldErrors // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      selectedCurrencyId: freezed == selectedCurrencyId
          ? _value.selectedCurrencyId
          : selectedCurrencyId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$DenominationStateImpl implements _DenominationState {
  const _$DenominationStateImpl(
      {final List<Denomination> denominations = const [],
      this.selectedDenomination,
      this.isLoading = false,
      this.isAdding = false,
      this.isUpdating = false,
      this.isDeleting = false,
      this.errorMessage,
      final Map<String, String> fieldErrors = const {},
      this.selectedCurrencyId})
      : _denominations = denominations,
        _fieldErrors = fieldErrors;

  /// List of denominations for the selected currency
  final List<Denomination> _denominations;

  /// List of denominations for the selected currency
  @override
  @JsonKey()
  List<Denomination> get denominations {
    if (_denominations is EqualUnmodifiableListView) return _denominations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_denominations);
  }

  /// Currently selected denomination for editing
  @override
  final Denomination? selectedDenomination;

  /// Whether currently loading denominations
  @override
  @JsonKey()
  final bool isLoading;

  /// Whether currently adding a denomination
  @override
  @JsonKey()
  final bool isAdding;

  /// Whether currently updating a denomination
  @override
  @JsonKey()
  final bool isUpdating;

  /// Whether currently deleting a denomination
  @override
  @JsonKey()
  final bool isDeleting;

  /// Error message if any error occurred
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

  /// Selected currency ID for filtering
  @override
  final String? selectedCurrencyId;

  @override
  String toString() {
    return 'DenominationState(denominations: $denominations, selectedDenomination: $selectedDenomination, isLoading: $isLoading, isAdding: $isAdding, isUpdating: $isUpdating, isDeleting: $isDeleting, errorMessage: $errorMessage, fieldErrors: $fieldErrors, selectedCurrencyId: $selectedCurrencyId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DenominationStateImpl &&
            const DeepCollectionEquality()
                .equals(other._denominations, _denominations) &&
            (identical(other.selectedDenomination, selectedDenomination) ||
                other.selectedDenomination == selectedDenomination) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isAdding, isAdding) ||
                other.isAdding == isAdding) &&
            (identical(other.isUpdating, isUpdating) ||
                other.isUpdating == isUpdating) &&
            (identical(other.isDeleting, isDeleting) ||
                other.isDeleting == isDeleting) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality()
                .equals(other._fieldErrors, _fieldErrors) &&
            (identical(other.selectedCurrencyId, selectedCurrencyId) ||
                other.selectedCurrencyId == selectedCurrencyId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_denominations),
      selectedDenomination,
      isLoading,
      isAdding,
      isUpdating,
      isDeleting,
      errorMessage,
      const DeepCollectionEquality().hash(_fieldErrors),
      selectedCurrencyId);

  /// Create a copy of DenominationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DenominationStateImplCopyWith<_$DenominationStateImpl> get copyWith =>
      __$$DenominationStateImplCopyWithImpl<_$DenominationStateImpl>(
          this, _$identity);
}

abstract class _DenominationState implements DenominationState {
  const factory _DenominationState(
      {final List<Denomination> denominations,
      final Denomination? selectedDenomination,
      final bool isLoading,
      final bool isAdding,
      final bool isUpdating,
      final bool isDeleting,
      final String? errorMessage,
      final Map<String, String> fieldErrors,
      final String? selectedCurrencyId}) = _$DenominationStateImpl;

  /// List of denominations for the selected currency
  @override
  List<Denomination> get denominations;

  /// Currently selected denomination for editing
  @override
  Denomination? get selectedDenomination;

  /// Whether currently loading denominations
  @override
  bool get isLoading;

  /// Whether currently adding a denomination
  @override
  bool get isAdding;

  /// Whether currently updating a denomination
  @override
  bool get isUpdating;

  /// Whether currently deleting a denomination
  @override
  bool get isDeleting;

  /// Error message if any error occurred
  @override
  String? get errorMessage;

  /// Field-specific validation errors
  @override
  Map<String, String> get fieldErrors;

  /// Selected currency ID for filtering
  @override
  String? get selectedCurrencyId;

  /// Create a copy of DenominationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DenominationStateImplCopyWith<_$DenominationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DenominationCreationState {
  /// Whether currently creating
  bool get isCreating => throw _privateConstructorUsedError;

  /// Whether currently validating
  bool get isValidating => throw _privateConstructorUsedError;

  /// Created denomination
  Denomination? get createdDenomination => throw _privateConstructorUsedError;

  /// Error message
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Field-specific validation errors
  Map<String, String> get fieldErrors => throw _privateConstructorUsedError;

  /// Form fields
  double? get value => throw _privateConstructorUsedError;
  DenominationType? get type => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get emoji => throw _privateConstructorUsedError;

  /// Create a copy of DenominationCreationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DenominationCreationStateCopyWith<DenominationCreationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DenominationCreationStateCopyWith<$Res> {
  factory $DenominationCreationStateCopyWith(DenominationCreationState value,
          $Res Function(DenominationCreationState) then) =
      _$DenominationCreationStateCopyWithImpl<$Res, DenominationCreationState>;
  @useResult
  $Res call(
      {bool isCreating,
      bool isValidating,
      Denomination? createdDenomination,
      String? errorMessage,
      Map<String, String> fieldErrors,
      double? value,
      DenominationType? type,
      String? displayName,
      String? emoji});

  $DenominationCopyWith<$Res>? get createdDenomination;
}

/// @nodoc
class _$DenominationCreationStateCopyWithImpl<$Res,
        $Val extends DenominationCreationState>
    implements $DenominationCreationStateCopyWith<$Res> {
  _$DenominationCreationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DenominationCreationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCreating = null,
    Object? isValidating = null,
    Object? createdDenomination = freezed,
    Object? errorMessage = freezed,
    Object? fieldErrors = null,
    Object? value = freezed,
    Object? type = freezed,
    Object? displayName = freezed,
    Object? emoji = freezed,
  }) {
    return _then(_value.copyWith(
      isCreating: null == isCreating
          ? _value.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      isValidating: null == isValidating
          ? _value.isValidating
          : isValidating // ignore: cast_nullable_to_non_nullable
              as bool,
      createdDenomination: freezed == createdDenomination
          ? _value.createdDenomination
          : createdDenomination // ignore: cast_nullable_to_non_nullable
              as Denomination?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldErrors: null == fieldErrors
          ? _value.fieldErrors
          : fieldErrors // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as DenominationType?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      emoji: freezed == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of DenominationCreationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DenominationCopyWith<$Res>? get createdDenomination {
    if (_value.createdDenomination == null) {
      return null;
    }

    return $DenominationCopyWith<$Res>(_value.createdDenomination!, (value) {
      return _then(_value.copyWith(createdDenomination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DenominationCreationStateImplCopyWith<$Res>
    implements $DenominationCreationStateCopyWith<$Res> {
  factory _$$DenominationCreationStateImplCopyWith(
          _$DenominationCreationStateImpl value,
          $Res Function(_$DenominationCreationStateImpl) then) =
      __$$DenominationCreationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isCreating,
      bool isValidating,
      Denomination? createdDenomination,
      String? errorMessage,
      Map<String, String> fieldErrors,
      double? value,
      DenominationType? type,
      String? displayName,
      String? emoji});

  @override
  $DenominationCopyWith<$Res>? get createdDenomination;
}

/// @nodoc
class __$$DenominationCreationStateImplCopyWithImpl<$Res>
    extends _$DenominationCreationStateCopyWithImpl<$Res,
        _$DenominationCreationStateImpl>
    implements _$$DenominationCreationStateImplCopyWith<$Res> {
  __$$DenominationCreationStateImplCopyWithImpl(
      _$DenominationCreationStateImpl _value,
      $Res Function(_$DenominationCreationStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DenominationCreationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCreating = null,
    Object? isValidating = null,
    Object? createdDenomination = freezed,
    Object? errorMessage = freezed,
    Object? fieldErrors = null,
    Object? value = freezed,
    Object? type = freezed,
    Object? displayName = freezed,
    Object? emoji = freezed,
  }) {
    return _then(_$DenominationCreationStateImpl(
      isCreating: null == isCreating
          ? _value.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      isValidating: null == isValidating
          ? _value.isValidating
          : isValidating // ignore: cast_nullable_to_non_nullable
              as bool,
      createdDenomination: freezed == createdDenomination
          ? _value.createdDenomination
          : createdDenomination // ignore: cast_nullable_to_non_nullable
              as Denomination?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldErrors: null == fieldErrors
          ? _value._fieldErrors
          : fieldErrors // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as DenominationType?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      emoji: freezed == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$DenominationCreationStateImpl implements _DenominationCreationState {
  const _$DenominationCreationStateImpl(
      {this.isCreating = false,
      this.isValidating = false,
      this.createdDenomination,
      this.errorMessage,
      final Map<String, String> fieldErrors = const {},
      this.value,
      this.type,
      this.displayName,
      this.emoji})
      : _fieldErrors = fieldErrors;

  /// Whether currently creating
  @override
  @JsonKey()
  final bool isCreating;

  /// Whether currently validating
  @override
  @JsonKey()
  final bool isValidating;

  /// Created denomination
  @override
  final Denomination? createdDenomination;

  /// Error message
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

  /// Form fields
  @override
  final double? value;
  @override
  final DenominationType? type;
  @override
  final String? displayName;
  @override
  final String? emoji;

  @override
  String toString() {
    return 'DenominationCreationState(isCreating: $isCreating, isValidating: $isValidating, createdDenomination: $createdDenomination, errorMessage: $errorMessage, fieldErrors: $fieldErrors, value: $value, type: $type, displayName: $displayName, emoji: $emoji)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DenominationCreationStateImpl &&
            (identical(other.isCreating, isCreating) ||
                other.isCreating == isCreating) &&
            (identical(other.isValidating, isValidating) ||
                other.isValidating == isValidating) &&
            (identical(other.createdDenomination, createdDenomination) ||
                other.createdDenomination == createdDenomination) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality()
                .equals(other._fieldErrors, _fieldErrors) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.emoji, emoji) || other.emoji == emoji));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isCreating,
      isValidating,
      createdDenomination,
      errorMessage,
      const DeepCollectionEquality().hash(_fieldErrors),
      value,
      type,
      displayName,
      emoji);

  /// Create a copy of DenominationCreationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DenominationCreationStateImplCopyWith<_$DenominationCreationStateImpl>
      get copyWith => __$$DenominationCreationStateImplCopyWithImpl<
          _$DenominationCreationStateImpl>(this, _$identity);
}

abstract class _DenominationCreationState implements DenominationCreationState {
  const factory _DenominationCreationState(
      {final bool isCreating,
      final bool isValidating,
      final Denomination? createdDenomination,
      final String? errorMessage,
      final Map<String, String> fieldErrors,
      final double? value,
      final DenominationType? type,
      final String? displayName,
      final String? emoji}) = _$DenominationCreationStateImpl;

  /// Whether currently creating
  @override
  bool get isCreating;

  /// Whether currently validating
  @override
  bool get isValidating;

  /// Created denomination
  @override
  Denomination? get createdDenomination;

  /// Error message
  @override
  String? get errorMessage;

  /// Field-specific validation errors
  @override
  Map<String, String> get fieldErrors;

  /// Form fields
  @override
  double? get value;
  @override
  DenominationType? get type;
  @override
  String? get displayName;
  @override
  String? get emoji;

  /// Create a copy of DenominationCreationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DenominationCreationStateImplCopyWith<_$DenominationCreationStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
