// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_options_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FilterOptionsModel {
  List<FilterOptionModel> get stores => throw _privateConstructorUsedError;
  List<FilterOptionModel> get accounts => throw _privateConstructorUsedError;
  @JsonKey(name: 'cash_locations')
  List<FilterOptionModel> get cashLocations =>
      throw _privateConstructorUsedError;
  List<FilterOptionModel> get counterparties =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'journal_types')
  List<FilterOptionModel> get journalTypes =>
      throw _privateConstructorUsedError;
  List<FilterOptionModel> get users => throw _privateConstructorUsedError;

  /// Create a copy of FilterOptionsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FilterOptionsModelCopyWith<FilterOptionsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilterOptionsModelCopyWith<$Res> {
  factory $FilterOptionsModelCopyWith(
          FilterOptionsModel value, $Res Function(FilterOptionsModel) then) =
      _$FilterOptionsModelCopyWithImpl<$Res, FilterOptionsModel>;
  @useResult
  $Res call(
      {List<FilterOptionModel> stores,
      List<FilterOptionModel> accounts,
      @JsonKey(name: 'cash_locations') List<FilterOptionModel> cashLocations,
      List<FilterOptionModel> counterparties,
      @JsonKey(name: 'journal_types') List<FilterOptionModel> journalTypes,
      List<FilterOptionModel> users});
}

/// @nodoc
class _$FilterOptionsModelCopyWithImpl<$Res, $Val extends FilterOptionsModel>
    implements $FilterOptionsModelCopyWith<$Res> {
  _$FilterOptionsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FilterOptionsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stores = null,
    Object? accounts = null,
    Object? cashLocations = null,
    Object? counterparties = null,
    Object? journalTypes = null,
    Object? users = null,
  }) {
    return _then(_value.copyWith(
      stores: null == stores
          ? _value.stores
          : stores // ignore: cast_nullable_to_non_nullable
              as List<FilterOptionModel>,
      accounts: null == accounts
          ? _value.accounts
          : accounts // ignore: cast_nullable_to_non_nullable
              as List<FilterOptionModel>,
      cashLocations: null == cashLocations
          ? _value.cashLocations
          : cashLocations // ignore: cast_nullable_to_non_nullable
              as List<FilterOptionModel>,
      counterparties: null == counterparties
          ? _value.counterparties
          : counterparties // ignore: cast_nullable_to_non_nullable
              as List<FilterOptionModel>,
      journalTypes: null == journalTypes
          ? _value.journalTypes
          : journalTypes // ignore: cast_nullable_to_non_nullable
              as List<FilterOptionModel>,
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<FilterOptionModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FilterOptionsModelImplCopyWith<$Res>
    implements $FilterOptionsModelCopyWith<$Res> {
  factory _$$FilterOptionsModelImplCopyWith(_$FilterOptionsModelImpl value,
          $Res Function(_$FilterOptionsModelImpl) then) =
      __$$FilterOptionsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<FilterOptionModel> stores,
      List<FilterOptionModel> accounts,
      @JsonKey(name: 'cash_locations') List<FilterOptionModel> cashLocations,
      List<FilterOptionModel> counterparties,
      @JsonKey(name: 'journal_types') List<FilterOptionModel> journalTypes,
      List<FilterOptionModel> users});
}

/// @nodoc
class __$$FilterOptionsModelImplCopyWithImpl<$Res>
    extends _$FilterOptionsModelCopyWithImpl<$Res, _$FilterOptionsModelImpl>
    implements _$$FilterOptionsModelImplCopyWith<$Res> {
  __$$FilterOptionsModelImplCopyWithImpl(_$FilterOptionsModelImpl _value,
      $Res Function(_$FilterOptionsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FilterOptionsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stores = null,
    Object? accounts = null,
    Object? cashLocations = null,
    Object? counterparties = null,
    Object? journalTypes = null,
    Object? users = null,
  }) {
    return _then(_$FilterOptionsModelImpl(
      stores: null == stores
          ? _value._stores
          : stores // ignore: cast_nullable_to_non_nullable
              as List<FilterOptionModel>,
      accounts: null == accounts
          ? _value._accounts
          : accounts // ignore: cast_nullable_to_non_nullable
              as List<FilterOptionModel>,
      cashLocations: null == cashLocations
          ? _value._cashLocations
          : cashLocations // ignore: cast_nullable_to_non_nullable
              as List<FilterOptionModel>,
      counterparties: null == counterparties
          ? _value._counterparties
          : counterparties // ignore: cast_nullable_to_non_nullable
              as List<FilterOptionModel>,
      journalTypes: null == journalTypes
          ? _value._journalTypes
          : journalTypes // ignore: cast_nullable_to_non_nullable
              as List<FilterOptionModel>,
      users: null == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<FilterOptionModel>,
    ));
  }
}

/// @nodoc

class _$FilterOptionsModelImpl implements _FilterOptionsModel {
  const _$FilterOptionsModelImpl(
      {final List<FilterOptionModel> stores = const [],
      final List<FilterOptionModel> accounts = const [],
      @JsonKey(name: 'cash_locations')
      final List<FilterOptionModel> cashLocations = const [],
      final List<FilterOptionModel> counterparties = const [],
      @JsonKey(name: 'journal_types')
      final List<FilterOptionModel> journalTypes = const [],
      final List<FilterOptionModel> users = const []})
      : _stores = stores,
        _accounts = accounts,
        _cashLocations = cashLocations,
        _counterparties = counterparties,
        _journalTypes = journalTypes,
        _users = users;

  final List<FilterOptionModel> _stores;
  @override
  @JsonKey()
  List<FilterOptionModel> get stores {
    if (_stores is EqualUnmodifiableListView) return _stores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stores);
  }

  final List<FilterOptionModel> _accounts;
  @override
  @JsonKey()
  List<FilterOptionModel> get accounts {
    if (_accounts is EqualUnmodifiableListView) return _accounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_accounts);
  }

  final List<FilterOptionModel> _cashLocations;
  @override
  @JsonKey(name: 'cash_locations')
  List<FilterOptionModel> get cashLocations {
    if (_cashLocations is EqualUnmodifiableListView) return _cashLocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cashLocations);
  }

  final List<FilterOptionModel> _counterparties;
  @override
  @JsonKey()
  List<FilterOptionModel> get counterparties {
    if (_counterparties is EqualUnmodifiableListView) return _counterparties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_counterparties);
  }

  final List<FilterOptionModel> _journalTypes;
  @override
  @JsonKey(name: 'journal_types')
  List<FilterOptionModel> get journalTypes {
    if (_journalTypes is EqualUnmodifiableListView) return _journalTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_journalTypes);
  }

  final List<FilterOptionModel> _users;
  @override
  @JsonKey()
  List<FilterOptionModel> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  @override
  String toString() {
    return 'FilterOptionsModel(stores: $stores, accounts: $accounts, cashLocations: $cashLocations, counterparties: $counterparties, journalTypes: $journalTypes, users: $users)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterOptionsModelImpl &&
            const DeepCollectionEquality().equals(other._stores, _stores) &&
            const DeepCollectionEquality().equals(other._accounts, _accounts) &&
            const DeepCollectionEquality()
                .equals(other._cashLocations, _cashLocations) &&
            const DeepCollectionEquality()
                .equals(other._counterparties, _counterparties) &&
            const DeepCollectionEquality()
                .equals(other._journalTypes, _journalTypes) &&
            const DeepCollectionEquality().equals(other._users, _users));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_stores),
      const DeepCollectionEquality().hash(_accounts),
      const DeepCollectionEquality().hash(_cashLocations),
      const DeepCollectionEquality().hash(_counterparties),
      const DeepCollectionEquality().hash(_journalTypes),
      const DeepCollectionEquality().hash(_users));

  /// Create a copy of FilterOptionsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterOptionsModelImplCopyWith<_$FilterOptionsModelImpl> get copyWith =>
      __$$FilterOptionsModelImplCopyWithImpl<_$FilterOptionsModelImpl>(
          this, _$identity);
}

abstract class _FilterOptionsModel implements FilterOptionsModel {
  const factory _FilterOptionsModel(
      {final List<FilterOptionModel> stores,
      final List<FilterOptionModel> accounts,
      @JsonKey(name: 'cash_locations')
      final List<FilterOptionModel> cashLocations,
      final List<FilterOptionModel> counterparties,
      @JsonKey(name: 'journal_types')
      final List<FilterOptionModel> journalTypes,
      final List<FilterOptionModel> users}) = _$FilterOptionsModelImpl;

  @override
  List<FilterOptionModel> get stores;
  @override
  List<FilterOptionModel> get accounts;
  @override
  @JsonKey(name: 'cash_locations')
  List<FilterOptionModel> get cashLocations;
  @override
  List<FilterOptionModel> get counterparties;
  @override
  @JsonKey(name: 'journal_types')
  List<FilterOptionModel> get journalTypes;
  @override
  List<FilterOptionModel> get users;

  /// Create a copy of FilterOptionsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilterOptionsModelImplCopyWith<_$FilterOptionsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FilterOptionModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_count')
  int get transactionCount => throw _privateConstructorUsedError;

  /// Create a copy of FilterOptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FilterOptionModelCopyWith<FilterOptionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilterOptionModelCopyWith<$Res> {
  factory $FilterOptionModelCopyWith(
          FilterOptionModel value, $Res Function(FilterOptionModel) then) =
      _$FilterOptionModelCopyWithImpl<$Res, FilterOptionModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'transaction_count') int transactionCount});
}

/// @nodoc
class _$FilterOptionModelCopyWithImpl<$Res, $Val extends FilterOptionModel>
    implements $FilterOptionModelCopyWith<$Res> {
  _$FilterOptionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FilterOptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? transactionCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FilterOptionModelImplCopyWith<$Res>
    implements $FilterOptionModelCopyWith<$Res> {
  factory _$$FilterOptionModelImplCopyWith(_$FilterOptionModelImpl value,
          $Res Function(_$FilterOptionModelImpl) then) =
      __$$FilterOptionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'transaction_count') int transactionCount});
}

/// @nodoc
class __$$FilterOptionModelImplCopyWithImpl<$Res>
    extends _$FilterOptionModelCopyWithImpl<$Res, _$FilterOptionModelImpl>
    implements _$$FilterOptionModelImplCopyWith<$Res> {
  __$$FilterOptionModelImplCopyWithImpl(_$FilterOptionModelImpl _value,
      $Res Function(_$FilterOptionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FilterOptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? transactionCount = null,
  }) {
    return _then(_$FilterOptionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$FilterOptionModelImpl implements _FilterOptionModel {
  const _$FilterOptionModelImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'transaction_count') this.transactionCount = 0});

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'transaction_count')
  final int transactionCount;

  @override
  String toString() {
    return 'FilterOptionModel(id: $id, name: $name, transactionCount: $transactionCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterOptionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, transactionCount);

  /// Create a copy of FilterOptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterOptionModelImplCopyWith<_$FilterOptionModelImpl> get copyWith =>
      __$$FilterOptionModelImplCopyWithImpl<_$FilterOptionModelImpl>(
          this, _$identity);
}

abstract class _FilterOptionModel implements FilterOptionModel {
  const factory _FilterOptionModel(
          {required final String id,
          required final String name,
          @JsonKey(name: 'transaction_count') final int transactionCount}) =
      _$FilterOptionModelImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'transaction_count')
  int get transactionCount;

  /// Create a copy of FilterOptionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilterOptionModelImplCopyWith<_$FilterOptionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
