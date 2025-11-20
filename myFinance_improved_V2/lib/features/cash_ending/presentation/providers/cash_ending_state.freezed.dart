// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cash_ending_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CashEndingState {
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Page State - UI state for cash ending page
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// Current selected tab (0=cash, 1=bank, 2=vault)
  int get currentTabIndex => throw _privateConstructorUsedError;

  /// Saving cash ending in progress
  bool get isSaving => throw _privateConstructorUsedError;

  /// Error message to display
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Success message to display
  String? get successMessage =>
      throw _privateConstructorUsedError; // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Location Selection State
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// Selected store ID (null = headquarter)
  String? get selectedStoreId => throw _privateConstructorUsedError;

  /// Selected cash location ID
  String? get selectedCashLocationId => throw _privateConstructorUsedError;

  /// Selected bank location ID
  String? get selectedBankLocationId => throw _privateConstructorUsedError;

  /// Selected vault location ID
  String? get selectedVaultLocationId =>
      throw _privateConstructorUsedError; // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Currency Selection State
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// Selected currency IDs for cash tab (multiple currencies can be selected)
  List<String> get selectedCashCurrencyIds =>
      throw _privateConstructorUsedError;

  /// Selected currency ID for bank tab
  String? get selectedBankCurrencyId => throw _privateConstructorUsedError;

  /// Selected currency IDs for vault tab (multiple currencies can be selected)
  List<String> get selectedVaultCurrencyIds =>
      throw _privateConstructorUsedError; // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Data State - Available data lists
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// Available stores for the company
  List<Store> get stores => throw _privateConstructorUsedError;

  /// Available cash locations
  List<Location> get cashLocations => throw _privateConstructorUsedError;

  /// Available bank locations
  List<Location> get bankLocations => throw _privateConstructorUsedError;

  /// Available vault locations
  List<Location> get vaultLocations => throw _privateConstructorUsedError;

  /// Available currencies for the company
  List<Currency> get currencies => throw _privateConstructorUsedError;

  /// Recent cash ending history for selected location
  List<CashEnding> get recentCashEndings =>
      throw _privateConstructorUsedError; // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Loading State - Loading states for each operation
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// Loading stores
  bool get isLoadingStores => throw _privateConstructorUsedError;

  /// Loading cash locations
  bool get isLoadingCashLocations => throw _privateConstructorUsedError;

  /// Loading bank locations
  bool get isLoadingBankLocations => throw _privateConstructorUsedError;

  /// Loading vault locations
  bool get isLoadingVaultLocations => throw _privateConstructorUsedError;

  /// Loading currencies
  bool get isLoadingCurrencies => throw _privateConstructorUsedError;

  /// Loading recent cash endings
  bool get isLoadingRecentEndings => throw _privateConstructorUsedError;

  /// Create a copy of CashEndingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CashEndingStateCopyWith<CashEndingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CashEndingStateCopyWith<$Res> {
  factory $CashEndingStateCopyWith(
          CashEndingState value, $Res Function(CashEndingState) then) =
      _$CashEndingStateCopyWithImpl<$Res, CashEndingState>;
  @useResult
  $Res call(
      {int currentTabIndex,
      bool isSaving,
      String? errorMessage,
      String? successMessage,
      String? selectedStoreId,
      String? selectedCashLocationId,
      String? selectedBankLocationId,
      String? selectedVaultLocationId,
      List<String> selectedCashCurrencyIds,
      String? selectedBankCurrencyId,
      List<String> selectedVaultCurrencyIds,
      List<Store> stores,
      List<Location> cashLocations,
      List<Location> bankLocations,
      List<Location> vaultLocations,
      List<Currency> currencies,
      List<CashEnding> recentCashEndings,
      bool isLoadingStores,
      bool isLoadingCashLocations,
      bool isLoadingBankLocations,
      bool isLoadingVaultLocations,
      bool isLoadingCurrencies,
      bool isLoadingRecentEndings});
}

/// @nodoc
class _$CashEndingStateCopyWithImpl<$Res, $Val extends CashEndingState>
    implements $CashEndingStateCopyWith<$Res> {
  _$CashEndingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CashEndingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentTabIndex = null,
    Object? isSaving = null,
    Object? errorMessage = freezed,
    Object? successMessage = freezed,
    Object? selectedStoreId = freezed,
    Object? selectedCashLocationId = freezed,
    Object? selectedBankLocationId = freezed,
    Object? selectedVaultLocationId = freezed,
    Object? selectedCashCurrencyIds = null,
    Object? selectedBankCurrencyId = freezed,
    Object? selectedVaultCurrencyIds = null,
    Object? stores = null,
    Object? cashLocations = null,
    Object? bankLocations = null,
    Object? vaultLocations = null,
    Object? currencies = null,
    Object? recentCashEndings = null,
    Object? isLoadingStores = null,
    Object? isLoadingCashLocations = null,
    Object? isLoadingBankLocations = null,
    Object? isLoadingVaultLocations = null,
    Object? isLoadingCurrencies = null,
    Object? isLoadingRecentEndings = null,
  }) {
    return _then(_value.copyWith(
      currentTabIndex: null == currentTabIndex
          ? _value.currentTabIndex
          : currentTabIndex // ignore: cast_nullable_to_non_nullable
              as int,
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
      selectedStoreId: freezed == selectedStoreId
          ? _value.selectedStoreId
          : selectedStoreId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedCashLocationId: freezed == selectedCashLocationId
          ? _value.selectedCashLocationId
          : selectedCashLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedBankLocationId: freezed == selectedBankLocationId
          ? _value.selectedBankLocationId
          : selectedBankLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedVaultLocationId: freezed == selectedVaultLocationId
          ? _value.selectedVaultLocationId
          : selectedVaultLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedCashCurrencyIds: null == selectedCashCurrencyIds
          ? _value.selectedCashCurrencyIds
          : selectedCashCurrencyIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedBankCurrencyId: freezed == selectedBankCurrencyId
          ? _value.selectedBankCurrencyId
          : selectedBankCurrencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedVaultCurrencyIds: null == selectedVaultCurrencyIds
          ? _value.selectedVaultCurrencyIds
          : selectedVaultCurrencyIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      stores: null == stores
          ? _value.stores
          : stores // ignore: cast_nullable_to_non_nullable
              as List<Store>,
      cashLocations: null == cashLocations
          ? _value.cashLocations
          : cashLocations // ignore: cast_nullable_to_non_nullable
              as List<Location>,
      bankLocations: null == bankLocations
          ? _value.bankLocations
          : bankLocations // ignore: cast_nullable_to_non_nullable
              as List<Location>,
      vaultLocations: null == vaultLocations
          ? _value.vaultLocations
          : vaultLocations // ignore: cast_nullable_to_non_nullable
              as List<Location>,
      currencies: null == currencies
          ? _value.currencies
          : currencies // ignore: cast_nullable_to_non_nullable
              as List<Currency>,
      recentCashEndings: null == recentCashEndings
          ? _value.recentCashEndings
          : recentCashEndings // ignore: cast_nullable_to_non_nullable
              as List<CashEnding>,
      isLoadingStores: null == isLoadingStores
          ? _value.isLoadingStores
          : isLoadingStores // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingCashLocations: null == isLoadingCashLocations
          ? _value.isLoadingCashLocations
          : isLoadingCashLocations // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingBankLocations: null == isLoadingBankLocations
          ? _value.isLoadingBankLocations
          : isLoadingBankLocations // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingVaultLocations: null == isLoadingVaultLocations
          ? _value.isLoadingVaultLocations
          : isLoadingVaultLocations // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingCurrencies: null == isLoadingCurrencies
          ? _value.isLoadingCurrencies
          : isLoadingCurrencies // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingRecentEndings: null == isLoadingRecentEndings
          ? _value.isLoadingRecentEndings
          : isLoadingRecentEndings // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CashEndingStateImplCopyWith<$Res>
    implements $CashEndingStateCopyWith<$Res> {
  factory _$$CashEndingStateImplCopyWith(_$CashEndingStateImpl value,
          $Res Function(_$CashEndingStateImpl) then) =
      __$$CashEndingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int currentTabIndex,
      bool isSaving,
      String? errorMessage,
      String? successMessage,
      String? selectedStoreId,
      String? selectedCashLocationId,
      String? selectedBankLocationId,
      String? selectedVaultLocationId,
      List<String> selectedCashCurrencyIds,
      String? selectedBankCurrencyId,
      List<String> selectedVaultCurrencyIds,
      List<Store> stores,
      List<Location> cashLocations,
      List<Location> bankLocations,
      List<Location> vaultLocations,
      List<Currency> currencies,
      List<CashEnding> recentCashEndings,
      bool isLoadingStores,
      bool isLoadingCashLocations,
      bool isLoadingBankLocations,
      bool isLoadingVaultLocations,
      bool isLoadingCurrencies,
      bool isLoadingRecentEndings});
}

/// @nodoc
class __$$CashEndingStateImplCopyWithImpl<$Res>
    extends _$CashEndingStateCopyWithImpl<$Res, _$CashEndingStateImpl>
    implements _$$CashEndingStateImplCopyWith<$Res> {
  __$$CashEndingStateImplCopyWithImpl(
      _$CashEndingStateImpl _value, $Res Function(_$CashEndingStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CashEndingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentTabIndex = null,
    Object? isSaving = null,
    Object? errorMessage = freezed,
    Object? successMessage = freezed,
    Object? selectedStoreId = freezed,
    Object? selectedCashLocationId = freezed,
    Object? selectedBankLocationId = freezed,
    Object? selectedVaultLocationId = freezed,
    Object? selectedCashCurrencyIds = null,
    Object? selectedBankCurrencyId = freezed,
    Object? selectedVaultCurrencyIds = null,
    Object? stores = null,
    Object? cashLocations = null,
    Object? bankLocations = null,
    Object? vaultLocations = null,
    Object? currencies = null,
    Object? recentCashEndings = null,
    Object? isLoadingStores = null,
    Object? isLoadingCashLocations = null,
    Object? isLoadingBankLocations = null,
    Object? isLoadingVaultLocations = null,
    Object? isLoadingCurrencies = null,
    Object? isLoadingRecentEndings = null,
  }) {
    return _then(_$CashEndingStateImpl(
      currentTabIndex: null == currentTabIndex
          ? _value.currentTabIndex
          : currentTabIndex // ignore: cast_nullable_to_non_nullable
              as int,
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
      selectedStoreId: freezed == selectedStoreId
          ? _value.selectedStoreId
          : selectedStoreId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedCashLocationId: freezed == selectedCashLocationId
          ? _value.selectedCashLocationId
          : selectedCashLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedBankLocationId: freezed == selectedBankLocationId
          ? _value.selectedBankLocationId
          : selectedBankLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedVaultLocationId: freezed == selectedVaultLocationId
          ? _value.selectedVaultLocationId
          : selectedVaultLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedCashCurrencyIds: null == selectedCashCurrencyIds
          ? _value._selectedCashCurrencyIds
          : selectedCashCurrencyIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedBankCurrencyId: freezed == selectedBankCurrencyId
          ? _value.selectedBankCurrencyId
          : selectedBankCurrencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedVaultCurrencyIds: null == selectedVaultCurrencyIds
          ? _value._selectedVaultCurrencyIds
          : selectedVaultCurrencyIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      stores: null == stores
          ? _value._stores
          : stores // ignore: cast_nullable_to_non_nullable
              as List<Store>,
      cashLocations: null == cashLocations
          ? _value._cashLocations
          : cashLocations // ignore: cast_nullable_to_non_nullable
              as List<Location>,
      bankLocations: null == bankLocations
          ? _value._bankLocations
          : bankLocations // ignore: cast_nullable_to_non_nullable
              as List<Location>,
      vaultLocations: null == vaultLocations
          ? _value._vaultLocations
          : vaultLocations // ignore: cast_nullable_to_non_nullable
              as List<Location>,
      currencies: null == currencies
          ? _value._currencies
          : currencies // ignore: cast_nullable_to_non_nullable
              as List<Currency>,
      recentCashEndings: null == recentCashEndings
          ? _value._recentCashEndings
          : recentCashEndings // ignore: cast_nullable_to_non_nullable
              as List<CashEnding>,
      isLoadingStores: null == isLoadingStores
          ? _value.isLoadingStores
          : isLoadingStores // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingCashLocations: null == isLoadingCashLocations
          ? _value.isLoadingCashLocations
          : isLoadingCashLocations // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingBankLocations: null == isLoadingBankLocations
          ? _value.isLoadingBankLocations
          : isLoadingBankLocations // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingVaultLocations: null == isLoadingVaultLocations
          ? _value.isLoadingVaultLocations
          : isLoadingVaultLocations // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingCurrencies: null == isLoadingCurrencies
          ? _value.isLoadingCurrencies
          : isLoadingCurrencies // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingRecentEndings: null == isLoadingRecentEndings
          ? _value.isLoadingRecentEndings
          : isLoadingRecentEndings // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$CashEndingStateImpl extends _CashEndingState {
  const _$CashEndingStateImpl(
      {this.currentTabIndex = 0,
      this.isSaving = false,
      this.errorMessage,
      this.successMessage,
      this.selectedStoreId,
      this.selectedCashLocationId,
      this.selectedBankLocationId,
      this.selectedVaultLocationId,
      final List<String> selectedCashCurrencyIds = const [],
      this.selectedBankCurrencyId,
      final List<String> selectedVaultCurrencyIds = const [],
      final List<Store> stores = const [],
      final List<Location> cashLocations = const [],
      final List<Location> bankLocations = const [],
      final List<Location> vaultLocations = const [],
      final List<Currency> currencies = const [],
      final List<CashEnding> recentCashEndings = const [],
      this.isLoadingStores = false,
      this.isLoadingCashLocations = false,
      this.isLoadingBankLocations = false,
      this.isLoadingVaultLocations = false,
      this.isLoadingCurrencies = false,
      this.isLoadingRecentEndings = false})
      : _selectedCashCurrencyIds = selectedCashCurrencyIds,
        _selectedVaultCurrencyIds = selectedVaultCurrencyIds,
        _stores = stores,
        _cashLocations = cashLocations,
        _bankLocations = bankLocations,
        _vaultLocations = vaultLocations,
        _currencies = currencies,
        _recentCashEndings = recentCashEndings,
        super._();

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Page State - UI state for cash ending page
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// Current selected tab (0=cash, 1=bank, 2=vault)
  @override
  @JsonKey()
  final int currentTabIndex;

  /// Saving cash ending in progress
  @override
  @JsonKey()
  final bool isSaving;

  /// Error message to display
  @override
  final String? errorMessage;

  /// Success message to display
  @override
  final String? successMessage;
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Location Selection State
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// Selected store ID (null = headquarter)
  @override
  final String? selectedStoreId;

  /// Selected cash location ID
  @override
  final String? selectedCashLocationId;

  /// Selected bank location ID
  @override
  final String? selectedBankLocationId;

  /// Selected vault location ID
  @override
  final String? selectedVaultLocationId;
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Currency Selection State
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// Selected currency IDs for cash tab (multiple currencies can be selected)
  final List<String> _selectedCashCurrencyIds;
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Currency Selection State
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// Selected currency IDs for cash tab (multiple currencies can be selected)
  @override
  @JsonKey()
  List<String> get selectedCashCurrencyIds {
    if (_selectedCashCurrencyIds is EqualUnmodifiableListView)
      return _selectedCashCurrencyIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedCashCurrencyIds);
  }

  /// Selected currency ID for bank tab
  @override
  final String? selectedBankCurrencyId;

  /// Selected currency IDs for vault tab (multiple currencies can be selected)
  final List<String> _selectedVaultCurrencyIds;

  /// Selected currency IDs for vault tab (multiple currencies can be selected)
  @override
  @JsonKey()
  List<String> get selectedVaultCurrencyIds {
    if (_selectedVaultCurrencyIds is EqualUnmodifiableListView)
      return _selectedVaultCurrencyIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedVaultCurrencyIds);
  }

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Data State - Available data lists
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// Available stores for the company
  final List<Store> _stores;
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Data State - Available data lists
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// Available stores for the company
  @override
  @JsonKey()
  List<Store> get stores {
    if (_stores is EqualUnmodifiableListView) return _stores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stores);
  }

  /// Available cash locations
  final List<Location> _cashLocations;

  /// Available cash locations
  @override
  @JsonKey()
  List<Location> get cashLocations {
    if (_cashLocations is EqualUnmodifiableListView) return _cashLocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cashLocations);
  }

  /// Available bank locations
  final List<Location> _bankLocations;

  /// Available bank locations
  @override
  @JsonKey()
  List<Location> get bankLocations {
    if (_bankLocations is EqualUnmodifiableListView) return _bankLocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bankLocations);
  }

  /// Available vault locations
  final List<Location> _vaultLocations;

  /// Available vault locations
  @override
  @JsonKey()
  List<Location> get vaultLocations {
    if (_vaultLocations is EqualUnmodifiableListView) return _vaultLocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vaultLocations);
  }

  /// Available currencies for the company
  final List<Currency> _currencies;

  /// Available currencies for the company
  @override
  @JsonKey()
  List<Currency> get currencies {
    if (_currencies is EqualUnmodifiableListView) return _currencies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currencies);
  }

  /// Recent cash ending history for selected location
  final List<CashEnding> _recentCashEndings;

  /// Recent cash ending history for selected location
  @override
  @JsonKey()
  List<CashEnding> get recentCashEndings {
    if (_recentCashEndings is EqualUnmodifiableListView)
      return _recentCashEndings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentCashEndings);
  }

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Loading State - Loading states for each operation
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// Loading stores
  @override
  @JsonKey()
  final bool isLoadingStores;

  /// Loading cash locations
  @override
  @JsonKey()
  final bool isLoadingCashLocations;

  /// Loading bank locations
  @override
  @JsonKey()
  final bool isLoadingBankLocations;

  /// Loading vault locations
  @override
  @JsonKey()
  final bool isLoadingVaultLocations;

  /// Loading currencies
  @override
  @JsonKey()
  final bool isLoadingCurrencies;

  /// Loading recent cash endings
  @override
  @JsonKey()
  final bool isLoadingRecentEndings;

  @override
  String toString() {
    return 'CashEndingState(currentTabIndex: $currentTabIndex, isSaving: $isSaving, errorMessage: $errorMessage, successMessage: $successMessage, selectedStoreId: $selectedStoreId, selectedCashLocationId: $selectedCashLocationId, selectedBankLocationId: $selectedBankLocationId, selectedVaultLocationId: $selectedVaultLocationId, selectedCashCurrencyIds: $selectedCashCurrencyIds, selectedBankCurrencyId: $selectedBankCurrencyId, selectedVaultCurrencyIds: $selectedVaultCurrencyIds, stores: $stores, cashLocations: $cashLocations, bankLocations: $bankLocations, vaultLocations: $vaultLocations, currencies: $currencies, recentCashEndings: $recentCashEndings, isLoadingStores: $isLoadingStores, isLoadingCashLocations: $isLoadingCashLocations, isLoadingBankLocations: $isLoadingBankLocations, isLoadingVaultLocations: $isLoadingVaultLocations, isLoadingCurrencies: $isLoadingCurrencies, isLoadingRecentEndings: $isLoadingRecentEndings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashEndingStateImpl &&
            (identical(other.currentTabIndex, currentTabIndex) ||
                other.currentTabIndex == currentTabIndex) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.successMessage, successMessage) ||
                other.successMessage == successMessage) &&
            (identical(other.selectedStoreId, selectedStoreId) ||
                other.selectedStoreId == selectedStoreId) &&
            (identical(other.selectedCashLocationId, selectedCashLocationId) ||
                other.selectedCashLocationId == selectedCashLocationId) &&
            (identical(other.selectedBankLocationId, selectedBankLocationId) ||
                other.selectedBankLocationId == selectedBankLocationId) &&
            (identical(
                    other.selectedVaultLocationId, selectedVaultLocationId) ||
                other.selectedVaultLocationId == selectedVaultLocationId) &&
            const DeepCollectionEquality().equals(
                other._selectedCashCurrencyIds, _selectedCashCurrencyIds) &&
            (identical(other.selectedBankCurrencyId, selectedBankCurrencyId) ||
                other.selectedBankCurrencyId == selectedBankCurrencyId) &&
            const DeepCollectionEquality().equals(
                other._selectedVaultCurrencyIds, _selectedVaultCurrencyIds) &&
            const DeepCollectionEquality().equals(other._stores, _stores) &&
            const DeepCollectionEquality()
                .equals(other._cashLocations, _cashLocations) &&
            const DeepCollectionEquality()
                .equals(other._bankLocations, _bankLocations) &&
            const DeepCollectionEquality()
                .equals(other._vaultLocations, _vaultLocations) &&
            const DeepCollectionEquality()
                .equals(other._currencies, _currencies) &&
            const DeepCollectionEquality()
                .equals(other._recentCashEndings, _recentCashEndings) &&
            (identical(other.isLoadingStores, isLoadingStores) ||
                other.isLoadingStores == isLoadingStores) &&
            (identical(other.isLoadingCashLocations, isLoadingCashLocations) ||
                other.isLoadingCashLocations == isLoadingCashLocations) &&
            (identical(other.isLoadingBankLocations, isLoadingBankLocations) ||
                other.isLoadingBankLocations == isLoadingBankLocations) &&
            (identical(
                    other.isLoadingVaultLocations, isLoadingVaultLocations) ||
                other.isLoadingVaultLocations == isLoadingVaultLocations) &&
            (identical(other.isLoadingCurrencies, isLoadingCurrencies) ||
                other.isLoadingCurrencies == isLoadingCurrencies) &&
            (identical(other.isLoadingRecentEndings, isLoadingRecentEndings) ||
                other.isLoadingRecentEndings == isLoadingRecentEndings));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        currentTabIndex,
        isSaving,
        errorMessage,
        successMessage,
        selectedStoreId,
        selectedCashLocationId,
        selectedBankLocationId,
        selectedVaultLocationId,
        const DeepCollectionEquality().hash(_selectedCashCurrencyIds),
        selectedBankCurrencyId,
        const DeepCollectionEquality().hash(_selectedVaultCurrencyIds),
        const DeepCollectionEquality().hash(_stores),
        const DeepCollectionEquality().hash(_cashLocations),
        const DeepCollectionEquality().hash(_bankLocations),
        const DeepCollectionEquality().hash(_vaultLocations),
        const DeepCollectionEquality().hash(_currencies),
        const DeepCollectionEquality().hash(_recentCashEndings),
        isLoadingStores,
        isLoadingCashLocations,
        isLoadingBankLocations,
        isLoadingVaultLocations,
        isLoadingCurrencies,
        isLoadingRecentEndings
      ]);

  /// Create a copy of CashEndingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CashEndingStateImplCopyWith<_$CashEndingStateImpl> get copyWith =>
      __$$CashEndingStateImplCopyWithImpl<_$CashEndingStateImpl>(
          this, _$identity);
}

abstract class _CashEndingState extends CashEndingState {
  const factory _CashEndingState(
      {final int currentTabIndex,
      final bool isSaving,
      final String? errorMessage,
      final String? successMessage,
      final String? selectedStoreId,
      final String? selectedCashLocationId,
      final String? selectedBankLocationId,
      final String? selectedVaultLocationId,
      final List<String> selectedCashCurrencyIds,
      final String? selectedBankCurrencyId,
      final List<String> selectedVaultCurrencyIds,
      final List<Store> stores,
      final List<Location> cashLocations,
      final List<Location> bankLocations,
      final List<Location> vaultLocations,
      final List<Currency> currencies,
      final List<CashEnding> recentCashEndings,
      final bool isLoadingStores,
      final bool isLoadingCashLocations,
      final bool isLoadingBankLocations,
      final bool isLoadingVaultLocations,
      final bool isLoadingCurrencies,
      final bool isLoadingRecentEndings}) = _$CashEndingStateImpl;
  const _CashEndingState._() : super._();

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Page State - UI state for cash ending page
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// Current selected tab (0=cash, 1=bank, 2=vault)
  @override
  int get currentTabIndex;

  /// Saving cash ending in progress
  @override
  bool get isSaving;

  /// Error message to display
  @override
  String? get errorMessage;

  /// Success message to display
  @override
  String?
      get successMessage; // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Location Selection State
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// Selected store ID (null = headquarter)
  @override
  String? get selectedStoreId;

  /// Selected cash location ID
  @override
  String? get selectedCashLocationId;

  /// Selected bank location ID
  @override
  String? get selectedBankLocationId;

  /// Selected vault location ID
  @override
  String?
      get selectedVaultLocationId; // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Currency Selection State
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// Selected currency IDs for cash tab (multiple currencies can be selected)
  @override
  List<String> get selectedCashCurrencyIds;

  /// Selected currency ID for bank tab
  @override
  String? get selectedBankCurrencyId;

  /// Selected currency IDs for vault tab (multiple currencies can be selected)
  @override
  List<String>
      get selectedVaultCurrencyIds; // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Data State - Available data lists
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// Available stores for the company
  @override
  List<Store> get stores;

  /// Available cash locations
  @override
  List<Location> get cashLocations;

  /// Available bank locations
  @override
  List<Location> get bankLocations;

  /// Available vault locations
  @override
  List<Location> get vaultLocations;

  /// Available currencies for the company
  @override
  List<Currency> get currencies;

  /// Recent cash ending history for selected location
  @override
  List<CashEnding>
      get recentCashEndings; // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Loading State - Loading states for each operation
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// Loading stores
  @override
  bool get isLoadingStores;

  /// Loading cash locations
  @override
  bool get isLoadingCashLocations;

  /// Loading bank locations
  @override
  bool get isLoadingBankLocations;

  /// Loading vault locations
  @override
  bool get isLoadingVaultLocations;

  /// Loading currencies
  @override
  bool get isLoadingCurrencies;

  /// Loading recent cash endings
  @override
  bool get isLoadingRecentEndings;

  /// Create a copy of CashEndingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CashEndingStateImplCopyWith<_$CashEndingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
