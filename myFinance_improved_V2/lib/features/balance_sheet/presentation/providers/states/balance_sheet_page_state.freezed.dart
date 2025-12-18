// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'balance_sheet_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BalanceSheetPageState {
// Tab state
  int get selectedTabIndex =>
      throw _privateConstructorUsedError; // 0: Balance Sheet, 1: Income Statement
// Date selection
  DateRange get dateRange =>
      throw _privateConstructorUsedError; // Loading states
  bool get isLoadingBalanceSheet => throw _privateConstructorUsedError;
  bool get isLoadingIncomeStatement => throw _privateConstructorUsedError;
  bool get isLoadingStores => throw _privateConstructorUsedError;
  bool get isLoadingCurrency =>
      throw _privateConstructorUsedError; // Error states
  String? get balanceSheetError => throw _privateConstructorUsedError;
  String? get incomeStatementError =>
      throw _privateConstructorUsedError; // Data loaded flags
  bool get hasBalanceSheetData => throw _privateConstructorUsedError;
  bool get hasIncomeStatementData => throw _privateConstructorUsedError;

  /// Create a copy of BalanceSheetPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BalanceSheetPageStateCopyWith<BalanceSheetPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BalanceSheetPageStateCopyWith<$Res> {
  factory $BalanceSheetPageStateCopyWith(BalanceSheetPageState value,
          $Res Function(BalanceSheetPageState) then) =
      _$BalanceSheetPageStateCopyWithImpl<$Res, BalanceSheetPageState>;
  @useResult
  $Res call(
      {int selectedTabIndex,
      DateRange dateRange,
      bool isLoadingBalanceSheet,
      bool isLoadingIncomeStatement,
      bool isLoadingStores,
      bool isLoadingCurrency,
      String? balanceSheetError,
      String? incomeStatementError,
      bool hasBalanceSheetData,
      bool hasIncomeStatementData});

  $DateRangeCopyWith<$Res> get dateRange;
}

/// @nodoc
class _$BalanceSheetPageStateCopyWithImpl<$Res,
        $Val extends BalanceSheetPageState>
    implements $BalanceSheetPageStateCopyWith<$Res> {
  _$BalanceSheetPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BalanceSheetPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedTabIndex = null,
    Object? dateRange = null,
    Object? isLoadingBalanceSheet = null,
    Object? isLoadingIncomeStatement = null,
    Object? isLoadingStores = null,
    Object? isLoadingCurrency = null,
    Object? balanceSheetError = freezed,
    Object? incomeStatementError = freezed,
    Object? hasBalanceSheetData = null,
    Object? hasIncomeStatementData = null,
  }) {
    return _then(_value.copyWith(
      selectedTabIndex: null == selectedTabIndex
          ? _value.selectedTabIndex
          : selectedTabIndex // ignore: cast_nullable_to_non_nullable
              as int,
      dateRange: null == dateRange
          ? _value.dateRange
          : dateRange // ignore: cast_nullable_to_non_nullable
              as DateRange,
      isLoadingBalanceSheet: null == isLoadingBalanceSheet
          ? _value.isLoadingBalanceSheet
          : isLoadingBalanceSheet // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingIncomeStatement: null == isLoadingIncomeStatement
          ? _value.isLoadingIncomeStatement
          : isLoadingIncomeStatement // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingStores: null == isLoadingStores
          ? _value.isLoadingStores
          : isLoadingStores // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingCurrency: null == isLoadingCurrency
          ? _value.isLoadingCurrency
          : isLoadingCurrency // ignore: cast_nullable_to_non_nullable
              as bool,
      balanceSheetError: freezed == balanceSheetError
          ? _value.balanceSheetError
          : balanceSheetError // ignore: cast_nullable_to_non_nullable
              as String?,
      incomeStatementError: freezed == incomeStatementError
          ? _value.incomeStatementError
          : incomeStatementError // ignore: cast_nullable_to_non_nullable
              as String?,
      hasBalanceSheetData: null == hasBalanceSheetData
          ? _value.hasBalanceSheetData
          : hasBalanceSheetData // ignore: cast_nullable_to_non_nullable
              as bool,
      hasIncomeStatementData: null == hasIncomeStatementData
          ? _value.hasIncomeStatementData
          : hasIncomeStatementData // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of BalanceSheetPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DateRangeCopyWith<$Res> get dateRange {
    return $DateRangeCopyWith<$Res>(_value.dateRange, (value) {
      return _then(_value.copyWith(dateRange: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BalanceSheetPageStateImplCopyWith<$Res>
    implements $BalanceSheetPageStateCopyWith<$Res> {
  factory _$$BalanceSheetPageStateImplCopyWith(
          _$BalanceSheetPageStateImpl value,
          $Res Function(_$BalanceSheetPageStateImpl) then) =
      __$$BalanceSheetPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int selectedTabIndex,
      DateRange dateRange,
      bool isLoadingBalanceSheet,
      bool isLoadingIncomeStatement,
      bool isLoadingStores,
      bool isLoadingCurrency,
      String? balanceSheetError,
      String? incomeStatementError,
      bool hasBalanceSheetData,
      bool hasIncomeStatementData});

  @override
  $DateRangeCopyWith<$Res> get dateRange;
}

/// @nodoc
class __$$BalanceSheetPageStateImplCopyWithImpl<$Res>
    extends _$BalanceSheetPageStateCopyWithImpl<$Res,
        _$BalanceSheetPageStateImpl>
    implements _$$BalanceSheetPageStateImplCopyWith<$Res> {
  __$$BalanceSheetPageStateImplCopyWithImpl(_$BalanceSheetPageStateImpl _value,
      $Res Function(_$BalanceSheetPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of BalanceSheetPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedTabIndex = null,
    Object? dateRange = null,
    Object? isLoadingBalanceSheet = null,
    Object? isLoadingIncomeStatement = null,
    Object? isLoadingStores = null,
    Object? isLoadingCurrency = null,
    Object? balanceSheetError = freezed,
    Object? incomeStatementError = freezed,
    Object? hasBalanceSheetData = null,
    Object? hasIncomeStatementData = null,
  }) {
    return _then(_$BalanceSheetPageStateImpl(
      selectedTabIndex: null == selectedTabIndex
          ? _value.selectedTabIndex
          : selectedTabIndex // ignore: cast_nullable_to_non_nullable
              as int,
      dateRange: null == dateRange
          ? _value.dateRange
          : dateRange // ignore: cast_nullable_to_non_nullable
              as DateRange,
      isLoadingBalanceSheet: null == isLoadingBalanceSheet
          ? _value.isLoadingBalanceSheet
          : isLoadingBalanceSheet // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingIncomeStatement: null == isLoadingIncomeStatement
          ? _value.isLoadingIncomeStatement
          : isLoadingIncomeStatement // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingStores: null == isLoadingStores
          ? _value.isLoadingStores
          : isLoadingStores // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingCurrency: null == isLoadingCurrency
          ? _value.isLoadingCurrency
          : isLoadingCurrency // ignore: cast_nullable_to_non_nullable
              as bool,
      balanceSheetError: freezed == balanceSheetError
          ? _value.balanceSheetError
          : balanceSheetError // ignore: cast_nullable_to_non_nullable
              as String?,
      incomeStatementError: freezed == incomeStatementError
          ? _value.incomeStatementError
          : incomeStatementError // ignore: cast_nullable_to_non_nullable
              as String?,
      hasBalanceSheetData: null == hasBalanceSheetData
          ? _value.hasBalanceSheetData
          : hasBalanceSheetData // ignore: cast_nullable_to_non_nullable
              as bool,
      hasIncomeStatementData: null == hasIncomeStatementData
          ? _value.hasIncomeStatementData
          : hasIncomeStatementData // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BalanceSheetPageStateImpl extends _BalanceSheetPageState {
  const _$BalanceSheetPageStateImpl(
      {this.selectedTabIndex = 0,
      required this.dateRange,
      this.isLoadingBalanceSheet = false,
      this.isLoadingIncomeStatement = false,
      this.isLoadingStores = false,
      this.isLoadingCurrency = false,
      this.balanceSheetError,
      this.incomeStatementError,
      this.hasBalanceSheetData = false,
      this.hasIncomeStatementData = false})
      : super._();

// Tab state
  @override
  @JsonKey()
  final int selectedTabIndex;
// 0: Balance Sheet, 1: Income Statement
// Date selection
  @override
  final DateRange dateRange;
// Loading states
  @override
  @JsonKey()
  final bool isLoadingBalanceSheet;
  @override
  @JsonKey()
  final bool isLoadingIncomeStatement;
  @override
  @JsonKey()
  final bool isLoadingStores;
  @override
  @JsonKey()
  final bool isLoadingCurrency;
// Error states
  @override
  final String? balanceSheetError;
  @override
  final String? incomeStatementError;
// Data loaded flags
  @override
  @JsonKey()
  final bool hasBalanceSheetData;
  @override
  @JsonKey()
  final bool hasIncomeStatementData;

  @override
  String toString() {
    return 'BalanceSheetPageState(selectedTabIndex: $selectedTabIndex, dateRange: $dateRange, isLoadingBalanceSheet: $isLoadingBalanceSheet, isLoadingIncomeStatement: $isLoadingIncomeStatement, isLoadingStores: $isLoadingStores, isLoadingCurrency: $isLoadingCurrency, balanceSheetError: $balanceSheetError, incomeStatementError: $incomeStatementError, hasBalanceSheetData: $hasBalanceSheetData, hasIncomeStatementData: $hasIncomeStatementData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BalanceSheetPageStateImpl &&
            (identical(other.selectedTabIndex, selectedTabIndex) ||
                other.selectedTabIndex == selectedTabIndex) &&
            (identical(other.dateRange, dateRange) ||
                other.dateRange == dateRange) &&
            (identical(other.isLoadingBalanceSheet, isLoadingBalanceSheet) ||
                other.isLoadingBalanceSheet == isLoadingBalanceSheet) &&
            (identical(
                    other.isLoadingIncomeStatement, isLoadingIncomeStatement) ||
                other.isLoadingIncomeStatement == isLoadingIncomeStatement) &&
            (identical(other.isLoadingStores, isLoadingStores) ||
                other.isLoadingStores == isLoadingStores) &&
            (identical(other.isLoadingCurrency, isLoadingCurrency) ||
                other.isLoadingCurrency == isLoadingCurrency) &&
            (identical(other.balanceSheetError, balanceSheetError) ||
                other.balanceSheetError == balanceSheetError) &&
            (identical(other.incomeStatementError, incomeStatementError) ||
                other.incomeStatementError == incomeStatementError) &&
            (identical(other.hasBalanceSheetData, hasBalanceSheetData) ||
                other.hasBalanceSheetData == hasBalanceSheetData) &&
            (identical(other.hasIncomeStatementData, hasIncomeStatementData) ||
                other.hasIncomeStatementData == hasIncomeStatementData));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      selectedTabIndex,
      dateRange,
      isLoadingBalanceSheet,
      isLoadingIncomeStatement,
      isLoadingStores,
      isLoadingCurrency,
      balanceSheetError,
      incomeStatementError,
      hasBalanceSheetData,
      hasIncomeStatementData);

  /// Create a copy of BalanceSheetPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BalanceSheetPageStateImplCopyWith<_$BalanceSheetPageStateImpl>
      get copyWith => __$$BalanceSheetPageStateImplCopyWithImpl<
          _$BalanceSheetPageStateImpl>(this, _$identity);
}

abstract class _BalanceSheetPageState extends BalanceSheetPageState {
  const factory _BalanceSheetPageState(
      {final int selectedTabIndex,
      required final DateRange dateRange,
      final bool isLoadingBalanceSheet,
      final bool isLoadingIncomeStatement,
      final bool isLoadingStores,
      final bool isLoadingCurrency,
      final String? balanceSheetError,
      final String? incomeStatementError,
      final bool hasBalanceSheetData,
      final bool hasIncomeStatementData}) = _$BalanceSheetPageStateImpl;
  const _BalanceSheetPageState._() : super._();

// Tab state
  @override
  int get selectedTabIndex; // 0: Balance Sheet, 1: Income Statement
// Date selection
  @override
  DateRange get dateRange; // Loading states
  @override
  bool get isLoadingBalanceSheet;
  @override
  bool get isLoadingIncomeStatement;
  @override
  bool get isLoadingStores;
  @override
  bool get isLoadingCurrency; // Error states
  @override
  String? get balanceSheetError;
  @override
  String? get incomeStatementError; // Data loaded flags
  @override
  bool get hasBalanceSheetData;
  @override
  bool get hasIncomeStatementData;

  /// Create a copy of BalanceSheetPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BalanceSheetPageStateImplCopyWith<_$BalanceSheetPageStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DateRangeSelectionState {
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  bool get isValid => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of DateRangeSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DateRangeSelectionStateCopyWith<DateRangeSelectionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DateRangeSelectionStateCopyWith<$Res> {
  factory $DateRangeSelectionStateCopyWith(DateRangeSelectionState value,
          $Res Function(DateRangeSelectionState) then) =
      _$DateRangeSelectionStateCopyWithImpl<$Res, DateRangeSelectionState>;
  @useResult
  $Res call(
      {DateTime startDate,
      DateTime endDate,
      bool isValid,
      String? errorMessage});
}

/// @nodoc
class _$DateRangeSelectionStateCopyWithImpl<$Res,
        $Val extends DateRangeSelectionState>
    implements $DateRangeSelectionStateCopyWith<$Res> {
  _$DateRangeSelectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DateRangeSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? isValid = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DateRangeSelectionStateImplCopyWith<$Res>
    implements $DateRangeSelectionStateCopyWith<$Res> {
  factory _$$DateRangeSelectionStateImplCopyWith(
          _$DateRangeSelectionStateImpl value,
          $Res Function(_$DateRangeSelectionStateImpl) then) =
      __$$DateRangeSelectionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime startDate,
      DateTime endDate,
      bool isValid,
      String? errorMessage});
}

/// @nodoc
class __$$DateRangeSelectionStateImplCopyWithImpl<$Res>
    extends _$DateRangeSelectionStateCopyWithImpl<$Res,
        _$DateRangeSelectionStateImpl>
    implements _$$DateRangeSelectionStateImplCopyWith<$Res> {
  __$$DateRangeSelectionStateImplCopyWithImpl(
      _$DateRangeSelectionStateImpl _value,
      $Res Function(_$DateRangeSelectionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DateRangeSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? isValid = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$DateRangeSelectionStateImpl(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$DateRangeSelectionStateImpl extends _DateRangeSelectionState {
  const _$DateRangeSelectionStateImpl(
      {required this.startDate,
      required this.endDate,
      this.isValid = false,
      this.errorMessage})
      : super._();

  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  @JsonKey()
  final bool isValid;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'DateRangeSelectionState(startDate: $startDate, endDate: $endDate, isValid: $isValid, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DateRangeSelectionStateImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isValid, isValid) || other.isValid == isValid) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, startDate, endDate, isValid, errorMessage);

  /// Create a copy of DateRangeSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DateRangeSelectionStateImplCopyWith<_$DateRangeSelectionStateImpl>
      get copyWith => __$$DateRangeSelectionStateImplCopyWithImpl<
          _$DateRangeSelectionStateImpl>(this, _$identity);
}

abstract class _DateRangeSelectionState extends DateRangeSelectionState {
  const factory _DateRangeSelectionState(
      {required final DateTime startDate,
      required final DateTime endDate,
      final bool isValid,
      final String? errorMessage}) = _$DateRangeSelectionStateImpl;
  const _DateRangeSelectionState._() : super._();

  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  bool get isValid;
  @override
  String? get errorMessage;

  /// Create a copy of DateRangeSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DateRangeSelectionStateImplCopyWith<_$DateRangeSelectionStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$StoreSelectionState {
  String? get selectedStoreId =>
      throw _privateConstructorUsedError; // null means Headquarters
  List<StoreOption> get availableStores => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of StoreSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreSelectionStateCopyWith<StoreSelectionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreSelectionStateCopyWith<$Res> {
  factory $StoreSelectionStateCopyWith(
          StoreSelectionState value, $Res Function(StoreSelectionState) then) =
      _$StoreSelectionStateCopyWithImpl<$Res, StoreSelectionState>;
  @useResult
  $Res call(
      {String? selectedStoreId,
      List<StoreOption> availableStores,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class _$StoreSelectionStateCopyWithImpl<$Res, $Val extends StoreSelectionState>
    implements $StoreSelectionStateCopyWith<$Res> {
  _$StoreSelectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedStoreId = freezed,
    Object? availableStores = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      selectedStoreId: freezed == selectedStoreId
          ? _value.selectedStoreId
          : selectedStoreId // ignore: cast_nullable_to_non_nullable
              as String?,
      availableStores: null == availableStores
          ? _value.availableStores
          : availableStores // ignore: cast_nullable_to_non_nullable
              as List<StoreOption>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoreSelectionStateImplCopyWith<$Res>
    implements $StoreSelectionStateCopyWith<$Res> {
  factory _$$StoreSelectionStateImplCopyWith(_$StoreSelectionStateImpl value,
          $Res Function(_$StoreSelectionStateImpl) then) =
      __$$StoreSelectionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? selectedStoreId,
      List<StoreOption> availableStores,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class __$$StoreSelectionStateImplCopyWithImpl<$Res>
    extends _$StoreSelectionStateCopyWithImpl<$Res, _$StoreSelectionStateImpl>
    implements _$$StoreSelectionStateImplCopyWith<$Res> {
  __$$StoreSelectionStateImplCopyWithImpl(_$StoreSelectionStateImpl _value,
      $Res Function(_$StoreSelectionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoreSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedStoreId = freezed,
    Object? availableStores = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$StoreSelectionStateImpl(
      selectedStoreId: freezed == selectedStoreId
          ? _value.selectedStoreId
          : selectedStoreId // ignore: cast_nullable_to_non_nullable
              as String?,
      availableStores: null == availableStores
          ? _value._availableStores
          : availableStores // ignore: cast_nullable_to_non_nullable
              as List<StoreOption>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$StoreSelectionStateImpl implements _StoreSelectionState {
  const _$StoreSelectionStateImpl(
      {this.selectedStoreId,
      final List<StoreOption> availableStores = const [],
      this.isLoading = false,
      this.errorMessage})
      : _availableStores = availableStores;

  @override
  final String? selectedStoreId;
// null means Headquarters
  final List<StoreOption> _availableStores;
// null means Headquarters
  @override
  @JsonKey()
  List<StoreOption> get availableStores {
    if (_availableStores is EqualUnmodifiableListView) return _availableStores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableStores);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'StoreSelectionState(selectedStoreId: $selectedStoreId, availableStores: $availableStores, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreSelectionStateImpl &&
            (identical(other.selectedStoreId, selectedStoreId) ||
                other.selectedStoreId == selectedStoreId) &&
            const DeepCollectionEquality()
                .equals(other._availableStores, _availableStores) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      selectedStoreId,
      const DeepCollectionEquality().hash(_availableStores),
      isLoading,
      errorMessage);

  /// Create a copy of StoreSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreSelectionStateImplCopyWith<_$StoreSelectionStateImpl> get copyWith =>
      __$$StoreSelectionStateImplCopyWithImpl<_$StoreSelectionStateImpl>(
          this, _$identity);
}

abstract class _StoreSelectionState implements StoreSelectionState {
  const factory _StoreSelectionState(
      {final String? selectedStoreId,
      final List<StoreOption> availableStores,
      final bool isLoading,
      final String? errorMessage}) = _$StoreSelectionStateImpl;

  @override
  String? get selectedStoreId; // null means Headquarters
  @override
  List<StoreOption> get availableStores;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;

  /// Create a copy of StoreSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreSelectionStateImplCopyWith<_$StoreSelectionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$StoreOption {
  String get storeId => throw _privateConstructorUsedError;
  String get storeName => throw _privateConstructorUsedError;
  String? get storeCode => throw _privateConstructorUsedError;

  /// Create a copy of StoreOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreOptionCopyWith<StoreOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreOptionCopyWith<$Res> {
  factory $StoreOptionCopyWith(
          StoreOption value, $Res Function(StoreOption) then) =
      _$StoreOptionCopyWithImpl<$Res, StoreOption>;
  @useResult
  $Res call({String storeId, String storeName, String? storeCode});
}

/// @nodoc
class _$StoreOptionCopyWithImpl<$Res, $Val extends StoreOption>
    implements $StoreOptionCopyWith<$Res> {
  _$StoreOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? storeName = null,
    Object? storeCode = freezed,
  }) {
    return _then(_value.copyWith(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      storeCode: freezed == storeCode
          ? _value.storeCode
          : storeCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoreOptionImplCopyWith<$Res>
    implements $StoreOptionCopyWith<$Res> {
  factory _$$StoreOptionImplCopyWith(
          _$StoreOptionImpl value, $Res Function(_$StoreOptionImpl) then) =
      __$$StoreOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String storeId, String storeName, String? storeCode});
}

/// @nodoc
class __$$StoreOptionImplCopyWithImpl<$Res>
    extends _$StoreOptionCopyWithImpl<$Res, _$StoreOptionImpl>
    implements _$$StoreOptionImplCopyWith<$Res> {
  __$$StoreOptionImplCopyWithImpl(
      _$StoreOptionImpl _value, $Res Function(_$StoreOptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoreOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? storeName = null,
    Object? storeCode = freezed,
  }) {
    return _then(_$StoreOptionImpl(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      storeCode: freezed == storeCode
          ? _value.storeCode
          : storeCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$StoreOptionImpl extends _StoreOption {
  const _$StoreOptionImpl(
      {required this.storeId, required this.storeName, this.storeCode})
      : super._();

  @override
  final String storeId;
  @override
  final String storeName;
  @override
  final String? storeCode;

  @override
  String toString() {
    return 'StoreOption(storeId: $storeId, storeName: $storeName, storeCode: $storeCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreOptionImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.storeCode, storeCode) ||
                other.storeCode == storeCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, storeId, storeName, storeCode);

  /// Create a copy of StoreOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreOptionImplCopyWith<_$StoreOptionImpl> get copyWith =>
      __$$StoreOptionImplCopyWithImpl<_$StoreOptionImpl>(this, _$identity);
}

abstract class _StoreOption extends StoreOption {
  const factory _StoreOption(
      {required final String storeId,
      required final String storeName,
      final String? storeCode}) = _$StoreOptionImpl;
  const _StoreOption._() : super._();

  @override
  String get storeId;
  @override
  String get storeName;
  @override
  String? get storeCode;

  /// Create a copy of StoreOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreOptionImplCopyWith<_$StoreOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
