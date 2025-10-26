// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_filter_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TransactionFilterState {
  /// Date range filter - from date
  DateTime? get dateFrom => throw _privateConstructorUsedError;

  /// Date range filter - to date
  DateTime? get dateTo => throw _privateConstructorUsedError;

  /// Single account filter
  String? get accountId => throw _privateConstructorUsedError;

  /// Multiple accounts filter
  List<String>? get accountIds => throw _privateConstructorUsedError;

  /// Cash location filter
  String? get cashLocationId => throw _privateConstructorUsedError;

  /// Counterparty filter
  String? get counterpartyId => throw _privateConstructorUsedError;

  /// Created by user filter
  String? get createdBy => throw _privateConstructorUsedError;

  /// Transaction scope (company, branch, personal)
  TransactionScope get scope => throw _privateConstructorUsedError;

  /// Create a copy of TransactionFilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionFilterStateCopyWith<TransactionFilterState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionFilterStateCopyWith<$Res> {
  factory $TransactionFilterStateCopyWith(TransactionFilterState value,
          $Res Function(TransactionFilterState) then) =
      _$TransactionFilterStateCopyWithImpl<$Res, TransactionFilterState>;
  @useResult
  $Res call(
      {DateTime? dateFrom,
      DateTime? dateTo,
      String? accountId,
      List<String>? accountIds,
      String? cashLocationId,
      String? counterpartyId,
      String? createdBy,
      TransactionScope scope});
}

/// @nodoc
class _$TransactionFilterStateCopyWithImpl<$Res,
        $Val extends TransactionFilterState>
    implements $TransactionFilterStateCopyWith<$Res> {
  _$TransactionFilterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionFilterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateFrom = freezed,
    Object? dateTo = freezed,
    Object? accountId = freezed,
    Object? accountIds = freezed,
    Object? cashLocationId = freezed,
    Object? counterpartyId = freezed,
    Object? createdBy = freezed,
    Object? scope = null,
  }) {
    return _then(_value.copyWith(
      dateFrom: freezed == dateFrom
          ? _value.dateFrom
          : dateFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dateTo: freezed == dateTo
          ? _value.dateTo
          : dateTo // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
      accountIds: freezed == accountIds
          ? _value.accountIds
          : accountIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      cashLocationId: freezed == cashLocationId
          ? _value.cashLocationId
          : cashLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyId: freezed == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      scope: null == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as TransactionScope,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionFilterStateImplCopyWith<$Res>
    implements $TransactionFilterStateCopyWith<$Res> {
  factory _$$TransactionFilterStateImplCopyWith(
          _$TransactionFilterStateImpl value,
          $Res Function(_$TransactionFilterStateImpl) then) =
      __$$TransactionFilterStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime? dateFrom,
      DateTime? dateTo,
      String? accountId,
      List<String>? accountIds,
      String? cashLocationId,
      String? counterpartyId,
      String? createdBy,
      TransactionScope scope});
}

/// @nodoc
class __$$TransactionFilterStateImplCopyWithImpl<$Res>
    extends _$TransactionFilterStateCopyWithImpl<$Res,
        _$TransactionFilterStateImpl>
    implements _$$TransactionFilterStateImplCopyWith<$Res> {
  __$$TransactionFilterStateImplCopyWithImpl(
      _$TransactionFilterStateImpl _value,
      $Res Function(_$TransactionFilterStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionFilterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateFrom = freezed,
    Object? dateTo = freezed,
    Object? accountId = freezed,
    Object? accountIds = freezed,
    Object? cashLocationId = freezed,
    Object? counterpartyId = freezed,
    Object? createdBy = freezed,
    Object? scope = null,
  }) {
    return _then(_$TransactionFilterStateImpl(
      dateFrom: freezed == dateFrom
          ? _value.dateFrom
          : dateFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dateTo: freezed == dateTo
          ? _value.dateTo
          : dateTo // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
      accountIds: freezed == accountIds
          ? _value._accountIds
          : accountIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      cashLocationId: freezed == cashLocationId
          ? _value.cashLocationId
          : cashLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyId: freezed == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      scope: null == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as TransactionScope,
    ));
  }
}

/// @nodoc

class _$TransactionFilterStateImpl extends _TransactionFilterState {
  const _$TransactionFilterStateImpl(
      {this.dateFrom,
      this.dateTo,
      this.accountId,
      final List<String>? accountIds,
      this.cashLocationId,
      this.counterpartyId,
      this.createdBy,
      this.scope = TransactionScope.company})
      : _accountIds = accountIds,
        super._();

  /// Date range filter - from date
  @override
  final DateTime? dateFrom;

  /// Date range filter - to date
  @override
  final DateTime? dateTo;

  /// Single account filter
  @override
  final String? accountId;

  /// Multiple accounts filter
  final List<String>? _accountIds;

  /// Multiple accounts filter
  @override
  List<String>? get accountIds {
    final value = _accountIds;
    if (value == null) return null;
    if (_accountIds is EqualUnmodifiableListView) return _accountIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Cash location filter
  @override
  final String? cashLocationId;

  /// Counterparty filter
  @override
  final String? counterpartyId;

  /// Created by user filter
  @override
  final String? createdBy;

  /// Transaction scope (company, branch, personal)
  @override
  @JsonKey()
  final TransactionScope scope;

  @override
  String toString() {
    return 'TransactionFilterState(dateFrom: $dateFrom, dateTo: $dateTo, accountId: $accountId, accountIds: $accountIds, cashLocationId: $cashLocationId, counterpartyId: $counterpartyId, createdBy: $createdBy, scope: $scope)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionFilterStateImpl &&
            (identical(other.dateFrom, dateFrom) ||
                other.dateFrom == dateFrom) &&
            (identical(other.dateTo, dateTo) || other.dateTo == dateTo) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            const DeepCollectionEquality()
                .equals(other._accountIds, _accountIds) &&
            (identical(other.cashLocationId, cashLocationId) ||
                other.cashLocationId == cashLocationId) &&
            (identical(other.counterpartyId, counterpartyId) ||
                other.counterpartyId == counterpartyId) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.scope, scope) || other.scope == scope));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      dateFrom,
      dateTo,
      accountId,
      const DeepCollectionEquality().hash(_accountIds),
      cashLocationId,
      counterpartyId,
      createdBy,
      scope);

  /// Create a copy of TransactionFilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionFilterStateImplCopyWith<_$TransactionFilterStateImpl>
      get copyWith => __$$TransactionFilterStateImplCopyWithImpl<
          _$TransactionFilterStateImpl>(this, _$identity);
}

abstract class _TransactionFilterState extends TransactionFilterState {
  const factory _TransactionFilterState(
      {final DateTime? dateFrom,
      final DateTime? dateTo,
      final String? accountId,
      final List<String>? accountIds,
      final String? cashLocationId,
      final String? counterpartyId,
      final String? createdBy,
      final TransactionScope scope}) = _$TransactionFilterStateImpl;
  const _TransactionFilterState._() : super._();

  /// Date range filter - from date
  @override
  DateTime? get dateFrom;

  /// Date range filter - to date
  @override
  DateTime? get dateTo;

  /// Single account filter
  @override
  String? get accountId;

  /// Multiple accounts filter
  @override
  List<String>? get accountIds;

  /// Cash location filter
  @override
  String? get cashLocationId;

  /// Counterparty filter
  @override
  String? get counterpartyId;

  /// Created by user filter
  @override
  String? get createdBy;

  /// Transaction scope (company, branch, personal)
  @override
  TransactionScope get scope;

  /// Create a copy of TransactionFilterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionFilterStateImplCopyWith<_$TransactionFilterStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FilterOptionsState {
  List<Map<String, dynamic>> get accounts => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get cashLocations =>
      throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get counterparties =>
      throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get journalTypes =>
      throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of FilterOptionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FilterOptionsStateCopyWith<FilterOptionsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilterOptionsStateCopyWith<$Res> {
  factory $FilterOptionsStateCopyWith(
          FilterOptionsState value, $Res Function(FilterOptionsState) then) =
      _$FilterOptionsStateCopyWithImpl<$Res, FilterOptionsState>;
  @useResult
  $Res call(
      {List<Map<String, dynamic>> accounts,
      List<Map<String, dynamic>> cashLocations,
      List<Map<String, dynamic>> counterparties,
      List<Map<String, dynamic>> journalTypes,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class _$FilterOptionsStateCopyWithImpl<$Res, $Val extends FilterOptionsState>
    implements $FilterOptionsStateCopyWith<$Res> {
  _$FilterOptionsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FilterOptionsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accounts = null,
    Object? cashLocations = null,
    Object? counterparties = null,
    Object? journalTypes = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      accounts: null == accounts
          ? _value.accounts
          : accounts // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      cashLocations: null == cashLocations
          ? _value.cashLocations
          : cashLocations // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      counterparties: null == counterparties
          ? _value.counterparties
          : counterparties // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      journalTypes: null == journalTypes
          ? _value.journalTypes
          : journalTypes // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
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
abstract class _$$FilterOptionsStateImplCopyWith<$Res>
    implements $FilterOptionsStateCopyWith<$Res> {
  factory _$$FilterOptionsStateImplCopyWith(_$FilterOptionsStateImpl value,
          $Res Function(_$FilterOptionsStateImpl) then) =
      __$$FilterOptionsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Map<String, dynamic>> accounts,
      List<Map<String, dynamic>> cashLocations,
      List<Map<String, dynamic>> counterparties,
      List<Map<String, dynamic>> journalTypes,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class __$$FilterOptionsStateImplCopyWithImpl<$Res>
    extends _$FilterOptionsStateCopyWithImpl<$Res, _$FilterOptionsStateImpl>
    implements _$$FilterOptionsStateImplCopyWith<$Res> {
  __$$FilterOptionsStateImplCopyWithImpl(_$FilterOptionsStateImpl _value,
      $Res Function(_$FilterOptionsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FilterOptionsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accounts = null,
    Object? cashLocations = null,
    Object? counterparties = null,
    Object? journalTypes = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$FilterOptionsStateImpl(
      accounts: null == accounts
          ? _value._accounts
          : accounts // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      cashLocations: null == cashLocations
          ? _value._cashLocations
          : cashLocations // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      counterparties: null == counterparties
          ? _value._counterparties
          : counterparties // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      journalTypes: null == journalTypes
          ? _value._journalTypes
          : journalTypes // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
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

class _$FilterOptionsStateImpl implements _FilterOptionsState {
  const _$FilterOptionsStateImpl(
      {final List<Map<String, dynamic>> accounts = const [],
      final List<Map<String, dynamic>> cashLocations = const [],
      final List<Map<String, dynamic>> counterparties = const [],
      final List<Map<String, dynamic>> journalTypes = const [],
      this.isLoading = false,
      this.errorMessage})
      : _accounts = accounts,
        _cashLocations = cashLocations,
        _counterparties = counterparties,
        _journalTypes = journalTypes;

  final List<Map<String, dynamic>> _accounts;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get accounts {
    if (_accounts is EqualUnmodifiableListView) return _accounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_accounts);
  }

  final List<Map<String, dynamic>> _cashLocations;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get cashLocations {
    if (_cashLocations is EqualUnmodifiableListView) return _cashLocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cashLocations);
  }

  final List<Map<String, dynamic>> _counterparties;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get counterparties {
    if (_counterparties is EqualUnmodifiableListView) return _counterparties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_counterparties);
  }

  final List<Map<String, dynamic>> _journalTypes;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get journalTypes {
    if (_journalTypes is EqualUnmodifiableListView) return _journalTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_journalTypes);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'FilterOptionsState(accounts: $accounts, cashLocations: $cashLocations, counterparties: $counterparties, journalTypes: $journalTypes, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterOptionsStateImpl &&
            const DeepCollectionEquality().equals(other._accounts, _accounts) &&
            const DeepCollectionEquality()
                .equals(other._cashLocations, _cashLocations) &&
            const DeepCollectionEquality()
                .equals(other._counterparties, _counterparties) &&
            const DeepCollectionEquality()
                .equals(other._journalTypes, _journalTypes) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_accounts),
      const DeepCollectionEquality().hash(_cashLocations),
      const DeepCollectionEquality().hash(_counterparties),
      const DeepCollectionEquality().hash(_journalTypes),
      isLoading,
      errorMessage);

  /// Create a copy of FilterOptionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterOptionsStateImplCopyWith<_$FilterOptionsStateImpl> get copyWith =>
      __$$FilterOptionsStateImplCopyWithImpl<_$FilterOptionsStateImpl>(
          this, _$identity);
}

abstract class _FilterOptionsState implements FilterOptionsState {
  const factory _FilterOptionsState(
      {final List<Map<String, dynamic>> accounts,
      final List<Map<String, dynamic>> cashLocations,
      final List<Map<String, dynamic>> counterparties,
      final List<Map<String, dynamic>> journalTypes,
      final bool isLoading,
      final String? errorMessage}) = _$FilterOptionsStateImpl;

  @override
  List<Map<String, dynamic>> get accounts;
  @override
  List<Map<String, dynamic>> get cashLocations;
  @override
  List<Map<String, dynamic>> get counterparties;
  @override
  List<Map<String, dynamic>> get journalTypes;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;

  /// Create a copy of FilterOptionsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilterOptionsStateImplCopyWith<_$FilterOptionsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
