// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AccountSettingsState {
  /// The loaded cash location detail
  CashLocationDetail? get location => throw _privateConstructorUsedError;

  /// Current account name (editable)
  String get accountName => throw _privateConstructorUsedError;

  /// Note/memo for the location
  String get note => throw _privateConstructorUsedError;

  /// Description (for cash/vault types)
  String get description => throw _privateConstructorUsedError;

  /// Bank name (for bank type only)
  String get bankName => throw _privateConstructorUsedError;

  /// Account number (for bank type only)
  String get accountNumber => throw _privateConstructorUsedError;

  /// Whether this is the main account
  bool get isMainAccount => throw _privateConstructorUsedError;

  /// Loading state
  bool get isLoading => throw _privateConstructorUsedError;

  /// Whether data is being saved
  bool get isSaving => throw _privateConstructorUsedError;

  /// Error message if any
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Success message for UI feedback
  String? get successMessage => throw _privateConstructorUsedError;

  /// Create a copy of AccountSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountSettingsStateCopyWith<AccountSettingsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountSettingsStateCopyWith<$Res> {
  factory $AccountSettingsStateCopyWith(AccountSettingsState value,
          $Res Function(AccountSettingsState) then) =
      _$AccountSettingsStateCopyWithImpl<$Res, AccountSettingsState>;
  @useResult
  $Res call(
      {CashLocationDetail? location,
      String accountName,
      String note,
      String description,
      String bankName,
      String accountNumber,
      bool isMainAccount,
      bool isLoading,
      bool isSaving,
      String? errorMessage,
      String? successMessage});

  $CashLocationDetailCopyWith<$Res>? get location;
}

/// @nodoc
class _$AccountSettingsStateCopyWithImpl<$Res,
        $Val extends AccountSettingsState>
    implements $AccountSettingsStateCopyWith<$Res> {
  _$AccountSettingsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = freezed,
    Object? accountName = null,
    Object? note = null,
    Object? description = null,
    Object? bankName = null,
    Object? accountNumber = null,
    Object? isMainAccount = null,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? errorMessage = freezed,
    Object? successMessage = freezed,
  }) {
    return _then(_value.copyWith(
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as CashLocationDetail?,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      bankName: null == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String,
      accountNumber: null == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String,
      isMainAccount: null == isMainAccount
          ? _value.isMainAccount
          : isMainAccount // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _value.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      successMessage: freezed == successMessage
          ? _value.successMessage
          : successMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of AccountSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CashLocationDetailCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $CashLocationDetailCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AccountSettingsStateImplCopyWith<$Res>
    implements $AccountSettingsStateCopyWith<$Res> {
  factory _$$AccountSettingsStateImplCopyWith(_$AccountSettingsStateImpl value,
          $Res Function(_$AccountSettingsStateImpl) then) =
      __$$AccountSettingsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {CashLocationDetail? location,
      String accountName,
      String note,
      String description,
      String bankName,
      String accountNumber,
      bool isMainAccount,
      bool isLoading,
      bool isSaving,
      String? errorMessage,
      String? successMessage});

  @override
  $CashLocationDetailCopyWith<$Res>? get location;
}

/// @nodoc
class __$$AccountSettingsStateImplCopyWithImpl<$Res>
    extends _$AccountSettingsStateCopyWithImpl<$Res, _$AccountSettingsStateImpl>
    implements _$$AccountSettingsStateImplCopyWith<$Res> {
  __$$AccountSettingsStateImplCopyWithImpl(_$AccountSettingsStateImpl _value,
      $Res Function(_$AccountSettingsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = freezed,
    Object? accountName = null,
    Object? note = null,
    Object? description = null,
    Object? bankName = null,
    Object? accountNumber = null,
    Object? isMainAccount = null,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? errorMessage = freezed,
    Object? successMessage = freezed,
  }) {
    return _then(_$AccountSettingsStateImpl(
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as CashLocationDetail?,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      bankName: null == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String,
      accountNumber: null == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String,
      isMainAccount: null == isMainAccount
          ? _value.isMainAccount
          : isMainAccount // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _value.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      successMessage: freezed == successMessage
          ? _value.successMessage
          : successMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AccountSettingsStateImpl extends _AccountSettingsState {
  const _$AccountSettingsStateImpl(
      {this.location,
      this.accountName = '',
      this.note = '',
      this.description = '',
      this.bankName = '',
      this.accountNumber = '',
      this.isMainAccount = false,
      this.isLoading = false,
      this.isSaving = false,
      this.errorMessage,
      this.successMessage})
      : super._();

  /// The loaded cash location detail
  @override
  final CashLocationDetail? location;

  /// Current account name (editable)
  @override
  @JsonKey()
  final String accountName;

  /// Note/memo for the location
  @override
  @JsonKey()
  final String note;

  /// Description (for cash/vault types)
  @override
  @JsonKey()
  final String description;

  /// Bank name (for bank type only)
  @override
  @JsonKey()
  final String bankName;

  /// Account number (for bank type only)
  @override
  @JsonKey()
  final String accountNumber;

  /// Whether this is the main account
  @override
  @JsonKey()
  final bool isMainAccount;

  /// Loading state
  @override
  @JsonKey()
  final bool isLoading;

  /// Whether data is being saved
  @override
  @JsonKey()
  final bool isSaving;

  /// Error message if any
  @override
  final String? errorMessage;

  /// Success message for UI feedback
  @override
  final String? successMessage;

  @override
  String toString() {
    return 'AccountSettingsState(location: $location, accountName: $accountName, note: $note, description: $description, bankName: $bankName, accountNumber: $accountNumber, isMainAccount: $isMainAccount, isLoading: $isLoading, isSaving: $isSaving, errorMessage: $errorMessage, successMessage: $successMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountSettingsStateImpl &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.isMainAccount, isMainAccount) ||
                other.isMainAccount == isMainAccount) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.successMessage, successMessage) ||
                other.successMessage == successMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      location,
      accountName,
      note,
      description,
      bankName,
      accountNumber,
      isMainAccount,
      isLoading,
      isSaving,
      errorMessage,
      successMessage);

  /// Create a copy of AccountSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountSettingsStateImplCopyWith<_$AccountSettingsStateImpl>
      get copyWith =>
          __$$AccountSettingsStateImplCopyWithImpl<_$AccountSettingsStateImpl>(
              this, _$identity);
}

abstract class _AccountSettingsState extends AccountSettingsState {
  const factory _AccountSettingsState(
      {final CashLocationDetail? location,
      final String accountName,
      final String note,
      final String description,
      final String bankName,
      final String accountNumber,
      final bool isMainAccount,
      final bool isLoading,
      final bool isSaving,
      final String? errorMessage,
      final String? successMessage}) = _$AccountSettingsStateImpl;
  const _AccountSettingsState._() : super._();

  /// The loaded cash location detail
  @override
  CashLocationDetail? get location;

  /// Current account name (editable)
  @override
  String get accountName;

  /// Note/memo for the location
  @override
  String get note;

  /// Description (for cash/vault types)
  @override
  String get description;

  /// Bank name (for bank type only)
  @override
  String get bankName;

  /// Account number (for bank type only)
  @override
  String get accountNumber;

  /// Whether this is the main account
  @override
  bool get isMainAccount;

  /// Loading state
  @override
  bool get isLoading;

  /// Whether data is being saved
  @override
  bool get isSaving;

  /// Error message if any
  @override
  String? get errorMessage;

  /// Success message for UI feedback
  @override
  String? get successMessage;

  /// Create a copy of AccountSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountSettingsStateImplCopyWith<_$AccountSettingsStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
