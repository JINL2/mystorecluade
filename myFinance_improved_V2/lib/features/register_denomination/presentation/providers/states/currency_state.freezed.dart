// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'currency_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CurrencyState {
  /// List of company currencies
  List<Currency> get currencies => throw _privateConstructorUsedError;

  /// Currently selected currency
  Currency? get selectedCurrency => throw _privateConstructorUsedError;

  /// Whether currently loading currencies
  bool get isLoading => throw _privateConstructorUsedError;

  /// Whether currently adding a currency
  bool get isAdding => throw _privateConstructorUsedError;

  /// Error message if any error occurred
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Field-specific validation errors
  Map<String, String> get fieldErrors => throw _privateConstructorUsedError;

  /// Create a copy of CurrencyState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrencyStateCopyWith<CurrencyState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrencyStateCopyWith<$Res> {
  factory $CurrencyStateCopyWith(
          CurrencyState value, $Res Function(CurrencyState) then) =
      _$CurrencyStateCopyWithImpl<$Res, CurrencyState>;
  @useResult
  $Res call(
      {List<Currency> currencies,
      Currency? selectedCurrency,
      bool isLoading,
      bool isAdding,
      String? errorMessage,
      Map<String, String> fieldErrors});

  $CurrencyCopyWith<$Res>? get selectedCurrency;
}

/// @nodoc
class _$CurrencyStateCopyWithImpl<$Res, $Val extends CurrencyState>
    implements $CurrencyStateCopyWith<$Res> {
  _$CurrencyStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurrencyState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencies = null,
    Object? selectedCurrency = freezed,
    Object? isLoading = null,
    Object? isAdding = null,
    Object? errorMessage = freezed,
    Object? fieldErrors = null,
  }) {
    return _then(_value.copyWith(
      currencies: null == currencies
          ? _value.currencies
          : currencies // ignore: cast_nullable_to_non_nullable
              as List<Currency>,
      selectedCurrency: freezed == selectedCurrency
          ? _value.selectedCurrency
          : selectedCurrency // ignore: cast_nullable_to_non_nullable
              as Currency?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdding: null == isAdding
          ? _value.isAdding
          : isAdding // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of CurrencyState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CurrencyCopyWith<$Res>? get selectedCurrency {
    if (_value.selectedCurrency == null) {
      return null;
    }

    return $CurrencyCopyWith<$Res>(_value.selectedCurrency!, (value) {
      return _then(_value.copyWith(selectedCurrency: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CurrencyStateImplCopyWith<$Res>
    implements $CurrencyStateCopyWith<$Res> {
  factory _$$CurrencyStateImplCopyWith(
          _$CurrencyStateImpl value, $Res Function(_$CurrencyStateImpl) then) =
      __$$CurrencyStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Currency> currencies,
      Currency? selectedCurrency,
      bool isLoading,
      bool isAdding,
      String? errorMessage,
      Map<String, String> fieldErrors});

  @override
  $CurrencyCopyWith<$Res>? get selectedCurrency;
}

/// @nodoc
class __$$CurrencyStateImplCopyWithImpl<$Res>
    extends _$CurrencyStateCopyWithImpl<$Res, _$CurrencyStateImpl>
    implements _$$CurrencyStateImplCopyWith<$Res> {
  __$$CurrencyStateImplCopyWithImpl(
      _$CurrencyStateImpl _value, $Res Function(_$CurrencyStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CurrencyState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencies = null,
    Object? selectedCurrency = freezed,
    Object? isLoading = null,
    Object? isAdding = null,
    Object? errorMessage = freezed,
    Object? fieldErrors = null,
  }) {
    return _then(_$CurrencyStateImpl(
      currencies: null == currencies
          ? _value._currencies
          : currencies // ignore: cast_nullable_to_non_nullable
              as List<Currency>,
      selectedCurrency: freezed == selectedCurrency
          ? _value.selectedCurrency
          : selectedCurrency // ignore: cast_nullable_to_non_nullable
              as Currency?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdding: null == isAdding
          ? _value.isAdding
          : isAdding // ignore: cast_nullable_to_non_nullable
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

class _$CurrencyStateImpl implements _CurrencyState {
  const _$CurrencyStateImpl(
      {final List<Currency> currencies = const [],
      this.selectedCurrency,
      this.isLoading = false,
      this.isAdding = false,
      this.errorMessage,
      final Map<String, String> fieldErrors = const {}})
      : _currencies = currencies,
        _fieldErrors = fieldErrors;

  /// List of company currencies
  final List<Currency> _currencies;

  /// List of company currencies
  @override
  @JsonKey()
  List<Currency> get currencies {
    if (_currencies is EqualUnmodifiableListView) return _currencies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currencies);
  }

  /// Currently selected currency
  @override
  final Currency? selectedCurrency;

  /// Whether currently loading currencies
  @override
  @JsonKey()
  final bool isLoading;

  /// Whether currently adding a currency
  @override
  @JsonKey()
  final bool isAdding;

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

  @override
  String toString() {
    return 'CurrencyState(currencies: $currencies, selectedCurrency: $selectedCurrency, isLoading: $isLoading, isAdding: $isAdding, errorMessage: $errorMessage, fieldErrors: $fieldErrors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrencyStateImpl &&
            const DeepCollectionEquality()
                .equals(other._currencies, _currencies) &&
            (identical(other.selectedCurrency, selectedCurrency) ||
                other.selectedCurrency == selectedCurrency) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isAdding, isAdding) ||
                other.isAdding == isAdding) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality()
                .equals(other._fieldErrors, _fieldErrors));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_currencies),
      selectedCurrency,
      isLoading,
      isAdding,
      errorMessage,
      const DeepCollectionEquality().hash(_fieldErrors));

  /// Create a copy of CurrencyState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrencyStateImplCopyWith<_$CurrencyStateImpl> get copyWith =>
      __$$CurrencyStateImplCopyWithImpl<_$CurrencyStateImpl>(this, _$identity);
}

abstract class _CurrencyState implements CurrencyState {
  const factory _CurrencyState(
      {final List<Currency> currencies,
      final Currency? selectedCurrency,
      final bool isLoading,
      final bool isAdding,
      final String? errorMessage,
      final Map<String, String> fieldErrors}) = _$CurrencyStateImpl;

  /// List of company currencies
  @override
  List<Currency> get currencies;

  /// Currently selected currency
  @override
  Currency? get selectedCurrency;

  /// Whether currently loading currencies
  @override
  bool get isLoading;

  /// Whether currently adding a currency
  @override
  bool get isAdding;

  /// Error message if any error occurred
  @override
  String? get errorMessage;

  /// Field-specific validation errors
  @override
  Map<String, String> get fieldErrors;

  /// Create a copy of CurrencyState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrencyStateImplCopyWith<_$CurrencyStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CurrencyTypeSelectionState {
  /// List of available currency types
  List<CurrencyType> get availableTypes => throw _privateConstructorUsedError;

  /// Selected currency type
  CurrencyType? get selectedType => throw _privateConstructorUsedError;

  /// Whether currently loading types
  bool get isLoading => throw _privateConstructorUsedError;

  /// Search query for filtering
  String get searchQuery => throw _privateConstructorUsedError;

  /// Error message
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of CurrencyTypeSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrencyTypeSelectionStateCopyWith<CurrencyTypeSelectionState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrencyTypeSelectionStateCopyWith<$Res> {
  factory $CurrencyTypeSelectionStateCopyWith(CurrencyTypeSelectionState value,
          $Res Function(CurrencyTypeSelectionState) then) =
      _$CurrencyTypeSelectionStateCopyWithImpl<$Res,
          CurrencyTypeSelectionState>;
  @useResult
  $Res call(
      {List<CurrencyType> availableTypes,
      CurrencyType? selectedType,
      bool isLoading,
      String searchQuery,
      String? errorMessage});

  $CurrencyTypeCopyWith<$Res>? get selectedType;
}

/// @nodoc
class _$CurrencyTypeSelectionStateCopyWithImpl<$Res,
        $Val extends CurrencyTypeSelectionState>
    implements $CurrencyTypeSelectionStateCopyWith<$Res> {
  _$CurrencyTypeSelectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurrencyTypeSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availableTypes = null,
    Object? selectedType = freezed,
    Object? isLoading = null,
    Object? searchQuery = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      availableTypes: null == availableTypes
          ? _value.availableTypes
          : availableTypes // ignore: cast_nullable_to_non_nullable
              as List<CurrencyType>,
      selectedType: freezed == selectedType
          ? _value.selectedType
          : selectedType // ignore: cast_nullable_to_non_nullable
              as CurrencyType?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of CurrencyTypeSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CurrencyTypeCopyWith<$Res>? get selectedType {
    if (_value.selectedType == null) {
      return null;
    }

    return $CurrencyTypeCopyWith<$Res>(_value.selectedType!, (value) {
      return _then(_value.copyWith(selectedType: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CurrencyTypeSelectionStateImplCopyWith<$Res>
    implements $CurrencyTypeSelectionStateCopyWith<$Res> {
  factory _$$CurrencyTypeSelectionStateImplCopyWith(
          _$CurrencyTypeSelectionStateImpl value,
          $Res Function(_$CurrencyTypeSelectionStateImpl) then) =
      __$$CurrencyTypeSelectionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<CurrencyType> availableTypes,
      CurrencyType? selectedType,
      bool isLoading,
      String searchQuery,
      String? errorMessage});

  @override
  $CurrencyTypeCopyWith<$Res>? get selectedType;
}

/// @nodoc
class __$$CurrencyTypeSelectionStateImplCopyWithImpl<$Res>
    extends _$CurrencyTypeSelectionStateCopyWithImpl<$Res,
        _$CurrencyTypeSelectionStateImpl>
    implements _$$CurrencyTypeSelectionStateImplCopyWith<$Res> {
  __$$CurrencyTypeSelectionStateImplCopyWithImpl(
      _$CurrencyTypeSelectionStateImpl _value,
      $Res Function(_$CurrencyTypeSelectionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CurrencyTypeSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availableTypes = null,
    Object? selectedType = freezed,
    Object? isLoading = null,
    Object? searchQuery = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$CurrencyTypeSelectionStateImpl(
      availableTypes: null == availableTypes
          ? _value._availableTypes
          : availableTypes // ignore: cast_nullable_to_non_nullable
              as List<CurrencyType>,
      selectedType: freezed == selectedType
          ? _value.selectedType
          : selectedType // ignore: cast_nullable_to_non_nullable
              as CurrencyType?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CurrencyTypeSelectionStateImpl implements _CurrencyTypeSelectionState {
  const _$CurrencyTypeSelectionStateImpl(
      {final List<CurrencyType> availableTypes = const [],
      this.selectedType,
      this.isLoading = false,
      this.searchQuery = '',
      this.errorMessage})
      : _availableTypes = availableTypes;

  /// List of available currency types
  final List<CurrencyType> _availableTypes;

  /// List of available currency types
  @override
  @JsonKey()
  List<CurrencyType> get availableTypes {
    if (_availableTypes is EqualUnmodifiableListView) return _availableTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableTypes);
  }

  /// Selected currency type
  @override
  final CurrencyType? selectedType;

  /// Whether currently loading types
  @override
  @JsonKey()
  final bool isLoading;

  /// Search query for filtering
  @override
  @JsonKey()
  final String searchQuery;

  /// Error message
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'CurrencyTypeSelectionState(availableTypes: $availableTypes, selectedType: $selectedType, isLoading: $isLoading, searchQuery: $searchQuery, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrencyTypeSelectionStateImpl &&
            const DeepCollectionEquality()
                .equals(other._availableTypes, _availableTypes) &&
            (identical(other.selectedType, selectedType) ||
                other.selectedType == selectedType) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_availableTypes),
      selectedType,
      isLoading,
      searchQuery,
      errorMessage);

  /// Create a copy of CurrencyTypeSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrencyTypeSelectionStateImplCopyWith<_$CurrencyTypeSelectionStateImpl>
      get copyWith => __$$CurrencyTypeSelectionStateImplCopyWithImpl<
          _$CurrencyTypeSelectionStateImpl>(this, _$identity);
}

abstract class _CurrencyTypeSelectionState
    implements CurrencyTypeSelectionState {
  const factory _CurrencyTypeSelectionState(
      {final List<CurrencyType> availableTypes,
      final CurrencyType? selectedType,
      final bool isLoading,
      final String searchQuery,
      final String? errorMessage}) = _$CurrencyTypeSelectionStateImpl;

  /// List of available currency types
  @override
  List<CurrencyType> get availableTypes;

  /// Selected currency type
  @override
  CurrencyType? get selectedType;

  /// Whether currently loading types
  @override
  bool get isLoading;

  /// Search query for filtering
  @override
  String get searchQuery;

  /// Error message
  @override
  String? get errorMessage;

  /// Create a copy of CurrencyTypeSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrencyTypeSelectionStateImplCopyWith<_$CurrencyTypeSelectionStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
