// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_flow.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

JournalFlow _$JournalFlowFromJson(Map<String, dynamic> json) {
  return _JournalFlow.fromJson(json);
}

/// @nodoc
mixin _$JournalFlow {
  String get flowId => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get systemTime => throw _privateConstructorUsedError;
  double get balanceBefore => throw _privateConstructorUsedError;
  double get flowAmount => throw _privateConstructorUsedError;
  double get balanceAfter => throw _privateConstructorUsedError;
  String get journalId => throw _privateConstructorUsedError;
  String get journalDescription => throw _privateConstructorUsedError;
  String get journalType => throw _privateConstructorUsedError;
  String get accountId => throw _privateConstructorUsedError;
  String get accountName => throw _privateConstructorUsedError;
  CreatedBy get createdBy => throw _privateConstructorUsedError;
  CounterAccount? get counterAccount => throw _privateConstructorUsedError;

  /// Serializes this JournalFlow to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JournalFlow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JournalFlowCopyWith<JournalFlow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JournalFlowCopyWith<$Res> {
  factory $JournalFlowCopyWith(
          JournalFlow value, $Res Function(JournalFlow) then) =
      _$JournalFlowCopyWithImpl<$Res, JournalFlow>;
  @useResult
  $Res call(
      {String flowId,
      String createdAt,
      String systemTime,
      double balanceBefore,
      double flowAmount,
      double balanceAfter,
      String journalId,
      String journalDescription,
      String journalType,
      String accountId,
      String accountName,
      CreatedBy createdBy,
      CounterAccount? counterAccount});

  $CreatedByCopyWith<$Res> get createdBy;
  $CounterAccountCopyWith<$Res>? get counterAccount;
}

/// @nodoc
class _$JournalFlowCopyWithImpl<$Res, $Val extends JournalFlow>
    implements $JournalFlowCopyWith<$Res> {
  _$JournalFlowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JournalFlow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flowId = null,
    Object? createdAt = null,
    Object? systemTime = null,
    Object? balanceBefore = null,
    Object? flowAmount = null,
    Object? balanceAfter = null,
    Object? journalId = null,
    Object? journalDescription = null,
    Object? journalType = null,
    Object? accountId = null,
    Object? accountName = null,
    Object? createdBy = null,
    Object? counterAccount = freezed,
  }) {
    return _then(_value.copyWith(
      flowId: null == flowId
          ? _value.flowId
          : flowId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      systemTime: null == systemTime
          ? _value.systemTime
          : systemTime // ignore: cast_nullable_to_non_nullable
              as String,
      balanceBefore: null == balanceBefore
          ? _value.balanceBefore
          : balanceBefore // ignore: cast_nullable_to_non_nullable
              as double,
      flowAmount: null == flowAmount
          ? _value.flowAmount
          : flowAmount // ignore: cast_nullable_to_non_nullable
              as double,
      balanceAfter: null == balanceAfter
          ? _value.balanceAfter
          : balanceAfter // ignore: cast_nullable_to_non_nullable
              as double,
      journalId: null == journalId
          ? _value.journalId
          : journalId // ignore: cast_nullable_to_non_nullable
              as String,
      journalDescription: null == journalDescription
          ? _value.journalDescription
          : journalDescription // ignore: cast_nullable_to_non_nullable
              as String,
      journalType: null == journalType
          ? _value.journalType
          : journalType // ignore: cast_nullable_to_non_nullable
              as String,
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as CreatedBy,
      counterAccount: freezed == counterAccount
          ? _value.counterAccount
          : counterAccount // ignore: cast_nullable_to_non_nullable
              as CounterAccount?,
    ) as $Val);
  }

  /// Create a copy of JournalFlow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CreatedByCopyWith<$Res> get createdBy {
    return $CreatedByCopyWith<$Res>(_value.createdBy, (value) {
      return _then(_value.copyWith(createdBy: value) as $Val);
    });
  }

  /// Create a copy of JournalFlow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CounterAccountCopyWith<$Res>? get counterAccount {
    if (_value.counterAccount == null) {
      return null;
    }

    return $CounterAccountCopyWith<$Res>(_value.counterAccount!, (value) {
      return _then(_value.copyWith(counterAccount: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$JournalFlowImplCopyWith<$Res>
    implements $JournalFlowCopyWith<$Res> {
  factory _$$JournalFlowImplCopyWith(
          _$JournalFlowImpl value, $Res Function(_$JournalFlowImpl) then) =
      __$$JournalFlowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String flowId,
      String createdAt,
      String systemTime,
      double balanceBefore,
      double flowAmount,
      double balanceAfter,
      String journalId,
      String journalDescription,
      String journalType,
      String accountId,
      String accountName,
      CreatedBy createdBy,
      CounterAccount? counterAccount});

  @override
  $CreatedByCopyWith<$Res> get createdBy;
  @override
  $CounterAccountCopyWith<$Res>? get counterAccount;
}

/// @nodoc
class __$$JournalFlowImplCopyWithImpl<$Res>
    extends _$JournalFlowCopyWithImpl<$Res, _$JournalFlowImpl>
    implements _$$JournalFlowImplCopyWith<$Res> {
  __$$JournalFlowImplCopyWithImpl(
      _$JournalFlowImpl _value, $Res Function(_$JournalFlowImpl) _then)
      : super(_value, _then);

  /// Create a copy of JournalFlow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flowId = null,
    Object? createdAt = null,
    Object? systemTime = null,
    Object? balanceBefore = null,
    Object? flowAmount = null,
    Object? balanceAfter = null,
    Object? journalId = null,
    Object? journalDescription = null,
    Object? journalType = null,
    Object? accountId = null,
    Object? accountName = null,
    Object? createdBy = null,
    Object? counterAccount = freezed,
  }) {
    return _then(_$JournalFlowImpl(
      flowId: null == flowId
          ? _value.flowId
          : flowId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      systemTime: null == systemTime
          ? _value.systemTime
          : systemTime // ignore: cast_nullable_to_non_nullable
              as String,
      balanceBefore: null == balanceBefore
          ? _value.balanceBefore
          : balanceBefore // ignore: cast_nullable_to_non_nullable
              as double,
      flowAmount: null == flowAmount
          ? _value.flowAmount
          : flowAmount // ignore: cast_nullable_to_non_nullable
              as double,
      balanceAfter: null == balanceAfter
          ? _value.balanceAfter
          : balanceAfter // ignore: cast_nullable_to_non_nullable
              as double,
      journalId: null == journalId
          ? _value.journalId
          : journalId // ignore: cast_nullable_to_non_nullable
              as String,
      journalDescription: null == journalDescription
          ? _value.journalDescription
          : journalDescription // ignore: cast_nullable_to_non_nullable
              as String,
      journalType: null == journalType
          ? _value.journalType
          : journalType // ignore: cast_nullable_to_non_nullable
              as String,
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as CreatedBy,
      counterAccount: freezed == counterAccount
          ? _value.counterAccount
          : counterAccount // ignore: cast_nullable_to_non_nullable
              as CounterAccount?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JournalFlowImpl implements _JournalFlow {
  const _$JournalFlowImpl(
      {required this.flowId,
      required this.createdAt,
      required this.systemTime,
      required this.balanceBefore,
      required this.flowAmount,
      required this.balanceAfter,
      required this.journalId,
      required this.journalDescription,
      required this.journalType,
      required this.accountId,
      required this.accountName,
      required this.createdBy,
      this.counterAccount});

  factory _$JournalFlowImpl.fromJson(Map<String, dynamic> json) =>
      _$$JournalFlowImplFromJson(json);

  @override
  final String flowId;
  @override
  final String createdAt;
  @override
  final String systemTime;
  @override
  final double balanceBefore;
  @override
  final double flowAmount;
  @override
  final double balanceAfter;
  @override
  final String journalId;
  @override
  final String journalDescription;
  @override
  final String journalType;
  @override
  final String accountId;
  @override
  final String accountName;
  @override
  final CreatedBy createdBy;
  @override
  final CounterAccount? counterAccount;

  @override
  String toString() {
    return 'JournalFlow(flowId: $flowId, createdAt: $createdAt, systemTime: $systemTime, balanceBefore: $balanceBefore, flowAmount: $flowAmount, balanceAfter: $balanceAfter, journalId: $journalId, journalDescription: $journalDescription, journalType: $journalType, accountId: $accountId, accountName: $accountName, createdBy: $createdBy, counterAccount: $counterAccount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JournalFlowImpl &&
            (identical(other.flowId, flowId) || other.flowId == flowId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.systemTime, systemTime) ||
                other.systemTime == systemTime) &&
            (identical(other.balanceBefore, balanceBefore) ||
                other.balanceBefore == balanceBefore) &&
            (identical(other.flowAmount, flowAmount) ||
                other.flowAmount == flowAmount) &&
            (identical(other.balanceAfter, balanceAfter) ||
                other.balanceAfter == balanceAfter) &&
            (identical(other.journalId, journalId) ||
                other.journalId == journalId) &&
            (identical(other.journalDescription, journalDescription) ||
                other.journalDescription == journalDescription) &&
            (identical(other.journalType, journalType) ||
                other.journalType == journalType) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.counterAccount, counterAccount) ||
                other.counterAccount == counterAccount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      flowId,
      createdAt,
      systemTime,
      balanceBefore,
      flowAmount,
      balanceAfter,
      journalId,
      journalDescription,
      journalType,
      accountId,
      accountName,
      createdBy,
      counterAccount);

  /// Create a copy of JournalFlow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JournalFlowImplCopyWith<_$JournalFlowImpl> get copyWith =>
      __$$JournalFlowImplCopyWithImpl<_$JournalFlowImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JournalFlowImplToJson(
      this,
    );
  }
}

abstract class _JournalFlow implements JournalFlow {
  const factory _JournalFlow(
      {required final String flowId,
      required final String createdAt,
      required final String systemTime,
      required final double balanceBefore,
      required final double flowAmount,
      required final double balanceAfter,
      required final String journalId,
      required final String journalDescription,
      required final String journalType,
      required final String accountId,
      required final String accountName,
      required final CreatedBy createdBy,
      final CounterAccount? counterAccount}) = _$JournalFlowImpl;

  factory _JournalFlow.fromJson(Map<String, dynamic> json) =
      _$JournalFlowImpl.fromJson;

  @override
  String get flowId;
  @override
  String get createdAt;
  @override
  String get systemTime;
  @override
  double get balanceBefore;
  @override
  double get flowAmount;
  @override
  double get balanceAfter;
  @override
  String get journalId;
  @override
  String get journalDescription;
  @override
  String get journalType;
  @override
  String get accountId;
  @override
  String get accountName;
  @override
  CreatedBy get createdBy;
  @override
  CounterAccount? get counterAccount;

  /// Create a copy of JournalFlow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JournalFlowImplCopyWith<_$JournalFlowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActualFlow _$ActualFlowFromJson(Map<String, dynamic> json) {
  return _ActualFlow.fromJson(json);
}

/// @nodoc
mixin _$ActualFlow {
  String get flowId => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get systemTime => throw _privateConstructorUsedError;
  double get balanceBefore => throw _privateConstructorUsedError;
  double get flowAmount => throw _privateConstructorUsedError;
  double get balanceAfter => throw _privateConstructorUsedError;
  CurrencyInfo get currency => throw _privateConstructorUsedError;
  CreatedBy get createdBy => throw _privateConstructorUsedError;
  List<DenominationDetail> get currentDenominations =>
      throw _privateConstructorUsedError;

  /// Serializes this ActualFlow to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActualFlow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActualFlowCopyWith<ActualFlow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActualFlowCopyWith<$Res> {
  factory $ActualFlowCopyWith(
          ActualFlow value, $Res Function(ActualFlow) then) =
      _$ActualFlowCopyWithImpl<$Res, ActualFlow>;
  @useResult
  $Res call(
      {String flowId,
      String createdAt,
      String systemTime,
      double balanceBefore,
      double flowAmount,
      double balanceAfter,
      CurrencyInfo currency,
      CreatedBy createdBy,
      List<DenominationDetail> currentDenominations});

  $CurrencyInfoCopyWith<$Res> get currency;
  $CreatedByCopyWith<$Res> get createdBy;
}

/// @nodoc
class _$ActualFlowCopyWithImpl<$Res, $Val extends ActualFlow>
    implements $ActualFlowCopyWith<$Res> {
  _$ActualFlowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActualFlow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flowId = null,
    Object? createdAt = null,
    Object? systemTime = null,
    Object? balanceBefore = null,
    Object? flowAmount = null,
    Object? balanceAfter = null,
    Object? currency = null,
    Object? createdBy = null,
    Object? currentDenominations = null,
  }) {
    return _then(_value.copyWith(
      flowId: null == flowId
          ? _value.flowId
          : flowId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      systemTime: null == systemTime
          ? _value.systemTime
          : systemTime // ignore: cast_nullable_to_non_nullable
              as String,
      balanceBefore: null == balanceBefore
          ? _value.balanceBefore
          : balanceBefore // ignore: cast_nullable_to_non_nullable
              as double,
      flowAmount: null == flowAmount
          ? _value.flowAmount
          : flowAmount // ignore: cast_nullable_to_non_nullable
              as double,
      balanceAfter: null == balanceAfter
          ? _value.balanceAfter
          : balanceAfter // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as CurrencyInfo,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as CreatedBy,
      currentDenominations: null == currentDenominations
          ? _value.currentDenominations
          : currentDenominations // ignore: cast_nullable_to_non_nullable
              as List<DenominationDetail>,
    ) as $Val);
  }

  /// Create a copy of ActualFlow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CurrencyInfoCopyWith<$Res> get currency {
    return $CurrencyInfoCopyWith<$Res>(_value.currency, (value) {
      return _then(_value.copyWith(currency: value) as $Val);
    });
  }

  /// Create a copy of ActualFlow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CreatedByCopyWith<$Res> get createdBy {
    return $CreatedByCopyWith<$Res>(_value.createdBy, (value) {
      return _then(_value.copyWith(createdBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ActualFlowImplCopyWith<$Res>
    implements $ActualFlowCopyWith<$Res> {
  factory _$$ActualFlowImplCopyWith(
          _$ActualFlowImpl value, $Res Function(_$ActualFlowImpl) then) =
      __$$ActualFlowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String flowId,
      String createdAt,
      String systemTime,
      double balanceBefore,
      double flowAmount,
      double balanceAfter,
      CurrencyInfo currency,
      CreatedBy createdBy,
      List<DenominationDetail> currentDenominations});

  @override
  $CurrencyInfoCopyWith<$Res> get currency;
  @override
  $CreatedByCopyWith<$Res> get createdBy;
}

/// @nodoc
class __$$ActualFlowImplCopyWithImpl<$Res>
    extends _$ActualFlowCopyWithImpl<$Res, _$ActualFlowImpl>
    implements _$$ActualFlowImplCopyWith<$Res> {
  __$$ActualFlowImplCopyWithImpl(
      _$ActualFlowImpl _value, $Res Function(_$ActualFlowImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActualFlow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flowId = null,
    Object? createdAt = null,
    Object? systemTime = null,
    Object? balanceBefore = null,
    Object? flowAmount = null,
    Object? balanceAfter = null,
    Object? currency = null,
    Object? createdBy = null,
    Object? currentDenominations = null,
  }) {
    return _then(_$ActualFlowImpl(
      flowId: null == flowId
          ? _value.flowId
          : flowId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      systemTime: null == systemTime
          ? _value.systemTime
          : systemTime // ignore: cast_nullable_to_non_nullable
              as String,
      balanceBefore: null == balanceBefore
          ? _value.balanceBefore
          : balanceBefore // ignore: cast_nullable_to_non_nullable
              as double,
      flowAmount: null == flowAmount
          ? _value.flowAmount
          : flowAmount // ignore: cast_nullable_to_non_nullable
              as double,
      balanceAfter: null == balanceAfter
          ? _value.balanceAfter
          : balanceAfter // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as CurrencyInfo,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as CreatedBy,
      currentDenominations: null == currentDenominations
          ? _value._currentDenominations
          : currentDenominations // ignore: cast_nullable_to_non_nullable
              as List<DenominationDetail>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActualFlowImpl implements _ActualFlow {
  const _$ActualFlowImpl(
      {required this.flowId,
      required this.createdAt,
      required this.systemTime,
      required this.balanceBefore,
      required this.flowAmount,
      required this.balanceAfter,
      required this.currency,
      required this.createdBy,
      required final List<DenominationDetail> currentDenominations})
      : _currentDenominations = currentDenominations;

  factory _$ActualFlowImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActualFlowImplFromJson(json);

  @override
  final String flowId;
  @override
  final String createdAt;
  @override
  final String systemTime;
  @override
  final double balanceBefore;
  @override
  final double flowAmount;
  @override
  final double balanceAfter;
  @override
  final CurrencyInfo currency;
  @override
  final CreatedBy createdBy;
  final List<DenominationDetail> _currentDenominations;
  @override
  List<DenominationDetail> get currentDenominations {
    if (_currentDenominations is EqualUnmodifiableListView)
      return _currentDenominations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currentDenominations);
  }

  @override
  String toString() {
    return 'ActualFlow(flowId: $flowId, createdAt: $createdAt, systemTime: $systemTime, balanceBefore: $balanceBefore, flowAmount: $flowAmount, balanceAfter: $balanceAfter, currency: $currency, createdBy: $createdBy, currentDenominations: $currentDenominations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActualFlowImpl &&
            (identical(other.flowId, flowId) || other.flowId == flowId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.systemTime, systemTime) ||
                other.systemTime == systemTime) &&
            (identical(other.balanceBefore, balanceBefore) ||
                other.balanceBefore == balanceBefore) &&
            (identical(other.flowAmount, flowAmount) ||
                other.flowAmount == flowAmount) &&
            (identical(other.balanceAfter, balanceAfter) ||
                other.balanceAfter == balanceAfter) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            const DeepCollectionEquality()
                .equals(other._currentDenominations, _currentDenominations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      flowId,
      createdAt,
      systemTime,
      balanceBefore,
      flowAmount,
      balanceAfter,
      currency,
      createdBy,
      const DeepCollectionEquality().hash(_currentDenominations));

  /// Create a copy of ActualFlow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActualFlowImplCopyWith<_$ActualFlowImpl> get copyWith =>
      __$$ActualFlowImplCopyWithImpl<_$ActualFlowImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActualFlowImplToJson(
      this,
    );
  }
}

abstract class _ActualFlow implements ActualFlow {
  const factory _ActualFlow(
          {required final String flowId,
          required final String createdAt,
          required final String systemTime,
          required final double balanceBefore,
          required final double flowAmount,
          required final double balanceAfter,
          required final CurrencyInfo currency,
          required final CreatedBy createdBy,
          required final List<DenominationDetail> currentDenominations}) =
      _$ActualFlowImpl;

  factory _ActualFlow.fromJson(Map<String, dynamic> json) =
      _$ActualFlowImpl.fromJson;

  @override
  String get flowId;
  @override
  String get createdAt;
  @override
  String get systemTime;
  @override
  double get balanceBefore;
  @override
  double get flowAmount;
  @override
  double get balanceAfter;
  @override
  CurrencyInfo get currency;
  @override
  CreatedBy get createdBy;
  @override
  List<DenominationDetail> get currentDenominations;

  /// Create a copy of ActualFlow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActualFlowImplCopyWith<_$ActualFlowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LocationSummary _$LocationSummaryFromJson(Map<String, dynamic> json) {
  return _LocationSummary.fromJson(json);
}

/// @nodoc
mixin _$LocationSummary {
  String get cashLocationId => throw _privateConstructorUsedError;
  String get locationName => throw _privateConstructorUsedError;
  String get locationType => throw _privateConstructorUsedError;
  String? get bankName => throw _privateConstructorUsedError;
  String? get bankAccount => throw _privateConstructorUsedError;
  String get currencyCode => throw _privateConstructorUsedError;
  String get currencyId => throw _privateConstructorUsedError;
  String? get baseCurrencySymbol => throw _privateConstructorUsedError;

  /// Serializes this LocationSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocationSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationSummaryCopyWith<LocationSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationSummaryCopyWith<$Res> {
  factory $LocationSummaryCopyWith(
          LocationSummary value, $Res Function(LocationSummary) then) =
      _$LocationSummaryCopyWithImpl<$Res, LocationSummary>;
  @useResult
  $Res call(
      {String cashLocationId,
      String locationName,
      String locationType,
      String? bankName,
      String? bankAccount,
      String currencyCode,
      String currencyId,
      String? baseCurrencySymbol});
}

/// @nodoc
class _$LocationSummaryCopyWithImpl<$Res, $Val extends LocationSummary>
    implements $LocationSummaryCopyWith<$Res> {
  _$LocationSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cashLocationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? bankName = freezed,
    Object? bankAccount = freezed,
    Object? currencyCode = null,
    Object? currencyId = null,
    Object? baseCurrencySymbol = freezed,
  }) {
    return _then(_value.copyWith(
      cashLocationId: null == cashLocationId
          ? _value.cashLocationId
          : cashLocationId // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccount: freezed == bankAccount
          ? _value.bankAccount
          : bankAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      baseCurrencySymbol: freezed == baseCurrencySymbol
          ? _value.baseCurrencySymbol
          : baseCurrencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationSummaryImplCopyWith<$Res>
    implements $LocationSummaryCopyWith<$Res> {
  factory _$$LocationSummaryImplCopyWith(_$LocationSummaryImpl value,
          $Res Function(_$LocationSummaryImpl) then) =
      __$$LocationSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String cashLocationId,
      String locationName,
      String locationType,
      String? bankName,
      String? bankAccount,
      String currencyCode,
      String currencyId,
      String? baseCurrencySymbol});
}

/// @nodoc
class __$$LocationSummaryImplCopyWithImpl<$Res>
    extends _$LocationSummaryCopyWithImpl<$Res, _$LocationSummaryImpl>
    implements _$$LocationSummaryImplCopyWith<$Res> {
  __$$LocationSummaryImplCopyWithImpl(
      _$LocationSummaryImpl _value, $Res Function(_$LocationSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocationSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cashLocationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? bankName = freezed,
    Object? bankAccount = freezed,
    Object? currencyCode = null,
    Object? currencyId = null,
    Object? baseCurrencySymbol = freezed,
  }) {
    return _then(_$LocationSummaryImpl(
      cashLocationId: null == cashLocationId
          ? _value.cashLocationId
          : cashLocationId // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccount: freezed == bankAccount
          ? _value.bankAccount
          : bankAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      baseCurrencySymbol: freezed == baseCurrencySymbol
          ? _value.baseCurrencySymbol
          : baseCurrencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationSummaryImpl implements _LocationSummary {
  const _$LocationSummaryImpl(
      {required this.cashLocationId,
      required this.locationName,
      required this.locationType,
      this.bankName,
      this.bankAccount,
      required this.currencyCode,
      required this.currencyId,
      this.baseCurrencySymbol});

  factory _$LocationSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationSummaryImplFromJson(json);

  @override
  final String cashLocationId;
  @override
  final String locationName;
  @override
  final String locationType;
  @override
  final String? bankName;
  @override
  final String? bankAccount;
  @override
  final String currencyCode;
  @override
  final String currencyId;
  @override
  final String? baseCurrencySymbol;

  @override
  String toString() {
    return 'LocationSummary(cashLocationId: $cashLocationId, locationName: $locationName, locationType: $locationType, bankName: $bankName, bankAccount: $bankAccount, currencyCode: $currencyCode, currencyId: $currencyId, baseCurrencySymbol: $baseCurrencySymbol)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationSummaryImpl &&
            (identical(other.cashLocationId, cashLocationId) ||
                other.cashLocationId == cashLocationId) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.locationType, locationType) ||
                other.locationType == locationType) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.bankAccount, bankAccount) ||
                other.bankAccount == bankAccount) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.baseCurrencySymbol, baseCurrencySymbol) ||
                other.baseCurrencySymbol == baseCurrencySymbol));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      cashLocationId,
      locationName,
      locationType,
      bankName,
      bankAccount,
      currencyCode,
      currencyId,
      baseCurrencySymbol);

  /// Create a copy of LocationSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationSummaryImplCopyWith<_$LocationSummaryImpl> get copyWith =>
      __$$LocationSummaryImplCopyWithImpl<_$LocationSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationSummaryImplToJson(
      this,
    );
  }
}

abstract class _LocationSummary implements LocationSummary {
  const factory _LocationSummary(
      {required final String cashLocationId,
      required final String locationName,
      required final String locationType,
      final String? bankName,
      final String? bankAccount,
      required final String currencyCode,
      required final String currencyId,
      final String? baseCurrencySymbol}) = _$LocationSummaryImpl;

  factory _LocationSummary.fromJson(Map<String, dynamic> json) =
      _$LocationSummaryImpl.fromJson;

  @override
  String get cashLocationId;
  @override
  String get locationName;
  @override
  String get locationType;
  @override
  String? get bankName;
  @override
  String? get bankAccount;
  @override
  String get currencyCode;
  @override
  String get currencyId;
  @override
  String? get baseCurrencySymbol;

  /// Create a copy of LocationSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationSummaryImplCopyWith<_$LocationSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CounterAccount _$CounterAccountFromJson(Map<String, dynamic> json) {
  return _CounterAccount.fromJson(json);
}

/// @nodoc
mixin _$CounterAccount {
  String get accountId => throw _privateConstructorUsedError;
  String get accountName => throw _privateConstructorUsedError;
  String get accountType => throw _privateConstructorUsedError;
  double get debit => throw _privateConstructorUsedError;
  double get credit => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  /// Serializes this CounterAccount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CounterAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CounterAccountCopyWith<CounterAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CounterAccountCopyWith<$Res> {
  factory $CounterAccountCopyWith(
          CounterAccount value, $Res Function(CounterAccount) then) =
      _$CounterAccountCopyWithImpl<$Res, CounterAccount>;
  @useResult
  $Res call(
      {String accountId,
      String accountName,
      String accountType,
      double debit,
      double credit,
      String description});
}

/// @nodoc
class _$CounterAccountCopyWithImpl<$Res, $Val extends CounterAccount>
    implements $CounterAccountCopyWith<$Res> {
  _$CounterAccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CounterAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? accountName = null,
    Object? accountType = null,
    Object? debit = null,
    Object? credit = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      accountType: null == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as String,
      debit: null == debit
          ? _value.debit
          : debit // ignore: cast_nullable_to_non_nullable
              as double,
      credit: null == credit
          ? _value.credit
          : credit // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CounterAccountImplCopyWith<$Res>
    implements $CounterAccountCopyWith<$Res> {
  factory _$$CounterAccountImplCopyWith(_$CounterAccountImpl value,
          $Res Function(_$CounterAccountImpl) then) =
      __$$CounterAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String accountId,
      String accountName,
      String accountType,
      double debit,
      double credit,
      String description});
}

/// @nodoc
class __$$CounterAccountImplCopyWithImpl<$Res>
    extends _$CounterAccountCopyWithImpl<$Res, _$CounterAccountImpl>
    implements _$$CounterAccountImplCopyWith<$Res> {
  __$$CounterAccountImplCopyWithImpl(
      _$CounterAccountImpl _value, $Res Function(_$CounterAccountImpl) _then)
      : super(_value, _then);

  /// Create a copy of CounterAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? accountName = null,
    Object? accountType = null,
    Object? debit = null,
    Object? credit = null,
    Object? description = null,
  }) {
    return _then(_$CounterAccountImpl(
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      accountType: null == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as String,
      debit: null == debit
          ? _value.debit
          : debit // ignore: cast_nullable_to_non_nullable
              as double,
      credit: null == credit
          ? _value.credit
          : credit // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CounterAccountImpl implements _CounterAccount {
  const _$CounterAccountImpl(
      {required this.accountId,
      required this.accountName,
      required this.accountType,
      required this.debit,
      required this.credit,
      required this.description});

  factory _$CounterAccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$CounterAccountImplFromJson(json);

  @override
  final String accountId;
  @override
  final String accountName;
  @override
  final String accountType;
  @override
  final double debit;
  @override
  final double credit;
  @override
  final String description;

  @override
  String toString() {
    return 'CounterAccount(accountId: $accountId, accountName: $accountName, accountType: $accountType, debit: $debit, credit: $credit, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CounterAccountImpl &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.accountType, accountType) ||
                other.accountType == accountType) &&
            (identical(other.debit, debit) || other.debit == debit) &&
            (identical(other.credit, credit) || other.credit == credit) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accountId, accountName,
      accountType, debit, credit, description);

  /// Create a copy of CounterAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CounterAccountImplCopyWith<_$CounterAccountImpl> get copyWith =>
      __$$CounterAccountImplCopyWithImpl<_$CounterAccountImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CounterAccountImplToJson(
      this,
    );
  }
}

abstract class _CounterAccount implements CounterAccount {
  const factory _CounterAccount(
      {required final String accountId,
      required final String accountName,
      required final String accountType,
      required final double debit,
      required final double credit,
      required final String description}) = _$CounterAccountImpl;

  factory _CounterAccount.fromJson(Map<String, dynamic> json) =
      _$CounterAccountImpl.fromJson;

  @override
  String get accountId;
  @override
  String get accountName;
  @override
  String get accountType;
  @override
  double get debit;
  @override
  double get credit;
  @override
  String get description;

  /// Create a copy of CounterAccount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CounterAccountImplCopyWith<_$CounterAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CurrencyInfo _$CurrencyInfoFromJson(Map<String, dynamic> json) {
  return _CurrencyInfo.fromJson(json);
}

/// @nodoc
mixin _$CurrencyInfo {
  String get currencyId => throw _privateConstructorUsedError;
  String get currencyCode => throw _privateConstructorUsedError;
  String get currencyName => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;

  /// Serializes this CurrencyInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CurrencyInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrencyInfoCopyWith<CurrencyInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrencyInfoCopyWith<$Res> {
  factory $CurrencyInfoCopyWith(
          CurrencyInfo value, $Res Function(CurrencyInfo) then) =
      _$CurrencyInfoCopyWithImpl<$Res, CurrencyInfo>;
  @useResult
  $Res call(
      {String currencyId,
      String currencyCode,
      String currencyName,
      String symbol});
}

/// @nodoc
class _$CurrencyInfoCopyWithImpl<$Res, $Val extends CurrencyInfo>
    implements $CurrencyInfoCopyWith<$Res> {
  _$CurrencyInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurrencyInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyId = null,
    Object? currencyCode = null,
    Object? currencyName = null,
    Object? symbol = null,
  }) {
    return _then(_value.copyWith(
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencyName: null == currencyName
          ? _value.currencyName
          : currencyName // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrencyInfoImplCopyWith<$Res>
    implements $CurrencyInfoCopyWith<$Res> {
  factory _$$CurrencyInfoImplCopyWith(
          _$CurrencyInfoImpl value, $Res Function(_$CurrencyInfoImpl) then) =
      __$$CurrencyInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String currencyId,
      String currencyCode,
      String currencyName,
      String symbol});
}

/// @nodoc
class __$$CurrencyInfoImplCopyWithImpl<$Res>
    extends _$CurrencyInfoCopyWithImpl<$Res, _$CurrencyInfoImpl>
    implements _$$CurrencyInfoImplCopyWith<$Res> {
  __$$CurrencyInfoImplCopyWithImpl(
      _$CurrencyInfoImpl _value, $Res Function(_$CurrencyInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CurrencyInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyId = null,
    Object? currencyCode = null,
    Object? currencyName = null,
    Object? symbol = null,
  }) {
    return _then(_$CurrencyInfoImpl(
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencyName: null == currencyName
          ? _value.currencyName
          : currencyName // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrencyInfoImpl implements _CurrencyInfo {
  const _$CurrencyInfoImpl(
      {required this.currencyId,
      required this.currencyCode,
      required this.currencyName,
      required this.symbol});

  factory _$CurrencyInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrencyInfoImplFromJson(json);

  @override
  final String currencyId;
  @override
  final String currencyCode;
  @override
  final String currencyName;
  @override
  final String symbol;

  @override
  String toString() {
    return 'CurrencyInfo(currencyId: $currencyId, currencyCode: $currencyCode, currencyName: $currencyName, symbol: $symbol)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrencyInfoImpl &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.currencyName, currencyName) ||
                other.currencyName == currencyName) &&
            (identical(other.symbol, symbol) || other.symbol == symbol));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, currencyId, currencyCode, currencyName, symbol);

  /// Create a copy of CurrencyInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrencyInfoImplCopyWith<_$CurrencyInfoImpl> get copyWith =>
      __$$CurrencyInfoImplCopyWithImpl<_$CurrencyInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrencyInfoImplToJson(
      this,
    );
  }
}

abstract class _CurrencyInfo implements CurrencyInfo {
  const factory _CurrencyInfo(
      {required final String currencyId,
      required final String currencyCode,
      required final String currencyName,
      required final String symbol}) = _$CurrencyInfoImpl;

  factory _CurrencyInfo.fromJson(Map<String, dynamic> json) =
      _$CurrencyInfoImpl.fromJson;

  @override
  String get currencyId;
  @override
  String get currencyCode;
  @override
  String get currencyName;
  @override
  String get symbol;

  /// Create a copy of CurrencyInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrencyInfoImplCopyWith<_$CurrencyInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreatedBy _$CreatedByFromJson(Map<String, dynamic> json) {
  return _CreatedBy.fromJson(json);
}

/// @nodoc
mixin _$CreatedBy {
  String get userId => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;

  /// Serializes this CreatedBy to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreatedBy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatedByCopyWith<CreatedBy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatedByCopyWith<$Res> {
  factory $CreatedByCopyWith(CreatedBy value, $Res Function(CreatedBy) then) =
      _$CreatedByCopyWithImpl<$Res, CreatedBy>;
  @useResult
  $Res call({String userId, String fullName});
}

/// @nodoc
class _$CreatedByCopyWithImpl<$Res, $Val extends CreatedBy>
    implements $CreatedByCopyWith<$Res> {
  _$CreatedByCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatedBy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? fullName = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreatedByImplCopyWith<$Res>
    implements $CreatedByCopyWith<$Res> {
  factory _$$CreatedByImplCopyWith(
          _$CreatedByImpl value, $Res Function(_$CreatedByImpl) then) =
      __$$CreatedByImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, String fullName});
}

/// @nodoc
class __$$CreatedByImplCopyWithImpl<$Res>
    extends _$CreatedByCopyWithImpl<$Res, _$CreatedByImpl>
    implements _$$CreatedByImplCopyWith<$Res> {
  __$$CreatedByImplCopyWithImpl(
      _$CreatedByImpl _value, $Res Function(_$CreatedByImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreatedBy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? fullName = null,
  }) {
    return _then(_$CreatedByImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatedByImpl implements _CreatedBy {
  const _$CreatedByImpl({required this.userId, required this.fullName});

  factory _$CreatedByImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatedByImplFromJson(json);

  @override
  final String userId;
  @override
  final String fullName;

  @override
  String toString() {
    return 'CreatedBy(userId: $userId, fullName: $fullName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatedByImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, fullName);

  /// Create a copy of CreatedBy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatedByImplCopyWith<_$CreatedByImpl> get copyWith =>
      __$$CreatedByImplCopyWithImpl<_$CreatedByImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatedByImplToJson(
      this,
    );
  }
}

abstract class _CreatedBy implements CreatedBy {
  const factory _CreatedBy(
      {required final String userId,
      required final String fullName}) = _$CreatedByImpl;

  factory _CreatedBy.fromJson(Map<String, dynamic> json) =
      _$CreatedByImpl.fromJson;

  @override
  String get userId;
  @override
  String get fullName;

  /// Create a copy of CreatedBy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatedByImplCopyWith<_$CreatedByImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DenominationDetail _$DenominationDetailFromJson(Map<String, dynamic> json) {
  return _DenominationDetail.fromJson(json);
}

/// @nodoc
mixin _$DenominationDetail {
  String get denominationId => throw _privateConstructorUsedError;
  double get denominationValue => throw _privateConstructorUsedError;
  String get denominationType => throw _privateConstructorUsedError;
  int get previousQuantity => throw _privateConstructorUsedError;
  int get currentQuantity => throw _privateConstructorUsedError;
  int get quantityChange => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  String? get currencySymbol =>
      throw _privateConstructorUsedError; // Bank multi-currency fields
  String? get currencyId => throw _privateConstructorUsedError;
  String? get currencyCode => throw _privateConstructorUsedError;
  String? get currencyName => throw _privateConstructorUsedError;
  double? get amount => throw _privateConstructorUsedError;
  double? get exchangeRate => throw _privateConstructorUsedError;
  double? get amountInBaseCurrency => throw _privateConstructorUsedError;

  /// Serializes this DenominationDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DenominationDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DenominationDetailCopyWith<DenominationDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DenominationDetailCopyWith<$Res> {
  factory $DenominationDetailCopyWith(
          DenominationDetail value, $Res Function(DenominationDetail) then) =
      _$DenominationDetailCopyWithImpl<$Res, DenominationDetail>;
  @useResult
  $Res call(
      {String denominationId,
      double denominationValue,
      String denominationType,
      int previousQuantity,
      int currentQuantity,
      int quantityChange,
      double subtotal,
      String? currencySymbol,
      String? currencyId,
      String? currencyCode,
      String? currencyName,
      double? amount,
      double? exchangeRate,
      double? amountInBaseCurrency});
}

/// @nodoc
class _$DenominationDetailCopyWithImpl<$Res, $Val extends DenominationDetail>
    implements $DenominationDetailCopyWith<$Res> {
  _$DenominationDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DenominationDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? denominationId = null,
    Object? denominationValue = null,
    Object? denominationType = null,
    Object? previousQuantity = null,
    Object? currentQuantity = null,
    Object? quantityChange = null,
    Object? subtotal = null,
    Object? currencySymbol = freezed,
    Object? currencyId = freezed,
    Object? currencyCode = freezed,
    Object? currencyName = freezed,
    Object? amount = freezed,
    Object? exchangeRate = freezed,
    Object? amountInBaseCurrency = freezed,
  }) {
    return _then(_value.copyWith(
      denominationId: null == denominationId
          ? _value.denominationId
          : denominationId // ignore: cast_nullable_to_non_nullable
              as String,
      denominationValue: null == denominationValue
          ? _value.denominationValue
          : denominationValue // ignore: cast_nullable_to_non_nullable
              as double,
      denominationType: null == denominationType
          ? _value.denominationType
          : denominationType // ignore: cast_nullable_to_non_nullable
              as String,
      previousQuantity: null == previousQuantity
          ? _value.previousQuantity
          : previousQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      currentQuantity: null == currentQuantity
          ? _value.currentQuantity
          : currentQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      quantityChange: null == quantityChange
          ? _value.quantityChange
          : quantityChange // ignore: cast_nullable_to_non_nullable
              as int,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      currencySymbol: freezed == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyId: freezed == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: freezed == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyName: freezed == currencyName
          ? _value.currencyName
          : currencyName // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      exchangeRate: freezed == exchangeRate
          ? _value.exchangeRate
          : exchangeRate // ignore: cast_nullable_to_non_nullable
              as double?,
      amountInBaseCurrency: freezed == amountInBaseCurrency
          ? _value.amountInBaseCurrency
          : amountInBaseCurrency // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DenominationDetailImplCopyWith<$Res>
    implements $DenominationDetailCopyWith<$Res> {
  factory _$$DenominationDetailImplCopyWith(_$DenominationDetailImpl value,
          $Res Function(_$DenominationDetailImpl) then) =
      __$$DenominationDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String denominationId,
      double denominationValue,
      String denominationType,
      int previousQuantity,
      int currentQuantity,
      int quantityChange,
      double subtotal,
      String? currencySymbol,
      String? currencyId,
      String? currencyCode,
      String? currencyName,
      double? amount,
      double? exchangeRate,
      double? amountInBaseCurrency});
}

/// @nodoc
class __$$DenominationDetailImplCopyWithImpl<$Res>
    extends _$DenominationDetailCopyWithImpl<$Res, _$DenominationDetailImpl>
    implements _$$DenominationDetailImplCopyWith<$Res> {
  __$$DenominationDetailImplCopyWithImpl(_$DenominationDetailImpl _value,
      $Res Function(_$DenominationDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of DenominationDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? denominationId = null,
    Object? denominationValue = null,
    Object? denominationType = null,
    Object? previousQuantity = null,
    Object? currentQuantity = null,
    Object? quantityChange = null,
    Object? subtotal = null,
    Object? currencySymbol = freezed,
    Object? currencyId = freezed,
    Object? currencyCode = freezed,
    Object? currencyName = freezed,
    Object? amount = freezed,
    Object? exchangeRate = freezed,
    Object? amountInBaseCurrency = freezed,
  }) {
    return _then(_$DenominationDetailImpl(
      denominationId: null == denominationId
          ? _value.denominationId
          : denominationId // ignore: cast_nullable_to_non_nullable
              as String,
      denominationValue: null == denominationValue
          ? _value.denominationValue
          : denominationValue // ignore: cast_nullable_to_non_nullable
              as double,
      denominationType: null == denominationType
          ? _value.denominationType
          : denominationType // ignore: cast_nullable_to_non_nullable
              as String,
      previousQuantity: null == previousQuantity
          ? _value.previousQuantity
          : previousQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      currentQuantity: null == currentQuantity
          ? _value.currentQuantity
          : currentQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      quantityChange: null == quantityChange
          ? _value.quantityChange
          : quantityChange // ignore: cast_nullable_to_non_nullable
              as int,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      currencySymbol: freezed == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyId: freezed == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: freezed == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyName: freezed == currencyName
          ? _value.currencyName
          : currencyName // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      exchangeRate: freezed == exchangeRate
          ? _value.exchangeRate
          : exchangeRate // ignore: cast_nullable_to_non_nullable
              as double?,
      amountInBaseCurrency: freezed == amountInBaseCurrency
          ? _value.amountInBaseCurrency
          : amountInBaseCurrency // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DenominationDetailImpl implements _DenominationDetail {
  const _$DenominationDetailImpl(
      {required this.denominationId,
      required this.denominationValue,
      required this.denominationType,
      required this.previousQuantity,
      required this.currentQuantity,
      required this.quantityChange,
      required this.subtotal,
      this.currencySymbol,
      this.currencyId,
      this.currencyCode,
      this.currencyName,
      this.amount,
      this.exchangeRate,
      this.amountInBaseCurrency});

  factory _$DenominationDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$DenominationDetailImplFromJson(json);

  @override
  final String denominationId;
  @override
  final double denominationValue;
  @override
  final String denominationType;
  @override
  final int previousQuantity;
  @override
  final int currentQuantity;
  @override
  final int quantityChange;
  @override
  final double subtotal;
  @override
  final String? currencySymbol;
// Bank multi-currency fields
  @override
  final String? currencyId;
  @override
  final String? currencyCode;
  @override
  final String? currencyName;
  @override
  final double? amount;
  @override
  final double? exchangeRate;
  @override
  final double? amountInBaseCurrency;

  @override
  String toString() {
    return 'DenominationDetail(denominationId: $denominationId, denominationValue: $denominationValue, denominationType: $denominationType, previousQuantity: $previousQuantity, currentQuantity: $currentQuantity, quantityChange: $quantityChange, subtotal: $subtotal, currencySymbol: $currencySymbol, currencyId: $currencyId, currencyCode: $currencyCode, currencyName: $currencyName, amount: $amount, exchangeRate: $exchangeRate, amountInBaseCurrency: $amountInBaseCurrency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DenominationDetailImpl &&
            (identical(other.denominationId, denominationId) ||
                other.denominationId == denominationId) &&
            (identical(other.denominationValue, denominationValue) ||
                other.denominationValue == denominationValue) &&
            (identical(other.denominationType, denominationType) ||
                other.denominationType == denominationType) &&
            (identical(other.previousQuantity, previousQuantity) ||
                other.previousQuantity == previousQuantity) &&
            (identical(other.currentQuantity, currentQuantity) ||
                other.currentQuantity == currentQuantity) &&
            (identical(other.quantityChange, quantityChange) ||
                other.quantityChange == quantityChange) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.currencyName, currencyName) ||
                other.currencyName == currencyName) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.exchangeRate, exchangeRate) ||
                other.exchangeRate == exchangeRate) &&
            (identical(other.amountInBaseCurrency, amountInBaseCurrency) ||
                other.amountInBaseCurrency == amountInBaseCurrency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      denominationId,
      denominationValue,
      denominationType,
      previousQuantity,
      currentQuantity,
      quantityChange,
      subtotal,
      currencySymbol,
      currencyId,
      currencyCode,
      currencyName,
      amount,
      exchangeRate,
      amountInBaseCurrency);

  /// Create a copy of DenominationDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DenominationDetailImplCopyWith<_$DenominationDetailImpl> get copyWith =>
      __$$DenominationDetailImplCopyWithImpl<_$DenominationDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DenominationDetailImplToJson(
      this,
    );
  }
}

abstract class _DenominationDetail implements DenominationDetail {
  const factory _DenominationDetail(
      {required final String denominationId,
      required final double denominationValue,
      required final String denominationType,
      required final int previousQuantity,
      required final int currentQuantity,
      required final int quantityChange,
      required final double subtotal,
      final String? currencySymbol,
      final String? currencyId,
      final String? currencyCode,
      final String? currencyName,
      final double? amount,
      final double? exchangeRate,
      final double? amountInBaseCurrency}) = _$DenominationDetailImpl;

  factory _DenominationDetail.fromJson(Map<String, dynamic> json) =
      _$DenominationDetailImpl.fromJson;

  @override
  String get denominationId;
  @override
  double get denominationValue;
  @override
  String get denominationType;
  @override
  int get previousQuantity;
  @override
  int get currentQuantity;
  @override
  int get quantityChange;
  @override
  double get subtotal;
  @override
  String? get currencySymbol; // Bank multi-currency fields
  @override
  String? get currencyId;
  @override
  String? get currencyCode;
  @override
  String? get currencyName;
  @override
  double? get amount;
  @override
  double? get exchangeRate;
  @override
  double? get amountInBaseCurrency;

  /// Create a copy of DenominationDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DenominationDetailImplCopyWith<_$DenominationDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StockFlowData _$StockFlowDataFromJson(Map<String, dynamic> json) {
  return _StockFlowData.fromJson(json);
}

/// @nodoc
mixin _$StockFlowData {
  LocationSummary? get locationSummary => throw _privateConstructorUsedError;
  List<JournalFlow> get journalFlows => throw _privateConstructorUsedError;
  List<ActualFlow> get actualFlows => throw _privateConstructorUsedError;

  /// Serializes this StockFlowData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockFlowData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockFlowDataCopyWith<StockFlowData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockFlowDataCopyWith<$Res> {
  factory $StockFlowDataCopyWith(
          StockFlowData value, $Res Function(StockFlowData) then) =
      _$StockFlowDataCopyWithImpl<$Res, StockFlowData>;
  @useResult
  $Res call(
      {LocationSummary? locationSummary,
      List<JournalFlow> journalFlows,
      List<ActualFlow> actualFlows});

  $LocationSummaryCopyWith<$Res>? get locationSummary;
}

/// @nodoc
class _$StockFlowDataCopyWithImpl<$Res, $Val extends StockFlowData>
    implements $StockFlowDataCopyWith<$Res> {
  _$StockFlowDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockFlowData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationSummary = freezed,
    Object? journalFlows = null,
    Object? actualFlows = null,
  }) {
    return _then(_value.copyWith(
      locationSummary: freezed == locationSummary
          ? _value.locationSummary
          : locationSummary // ignore: cast_nullable_to_non_nullable
              as LocationSummary?,
      journalFlows: null == journalFlows
          ? _value.journalFlows
          : journalFlows // ignore: cast_nullable_to_non_nullable
              as List<JournalFlow>,
      actualFlows: null == actualFlows
          ? _value.actualFlows
          : actualFlows // ignore: cast_nullable_to_non_nullable
              as List<ActualFlow>,
    ) as $Val);
  }

  /// Create a copy of StockFlowData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationSummaryCopyWith<$Res>? get locationSummary {
    if (_value.locationSummary == null) {
      return null;
    }

    return $LocationSummaryCopyWith<$Res>(_value.locationSummary!, (value) {
      return _then(_value.copyWith(locationSummary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StockFlowDataImplCopyWith<$Res>
    implements $StockFlowDataCopyWith<$Res> {
  factory _$$StockFlowDataImplCopyWith(
          _$StockFlowDataImpl value, $Res Function(_$StockFlowDataImpl) then) =
      __$$StockFlowDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {LocationSummary? locationSummary,
      List<JournalFlow> journalFlows,
      List<ActualFlow> actualFlows});

  @override
  $LocationSummaryCopyWith<$Res>? get locationSummary;
}

/// @nodoc
class __$$StockFlowDataImplCopyWithImpl<$Res>
    extends _$StockFlowDataCopyWithImpl<$Res, _$StockFlowDataImpl>
    implements _$$StockFlowDataImplCopyWith<$Res> {
  __$$StockFlowDataImplCopyWithImpl(
      _$StockFlowDataImpl _value, $Res Function(_$StockFlowDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockFlowData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationSummary = freezed,
    Object? journalFlows = null,
    Object? actualFlows = null,
  }) {
    return _then(_$StockFlowDataImpl(
      locationSummary: freezed == locationSummary
          ? _value.locationSummary
          : locationSummary // ignore: cast_nullable_to_non_nullable
              as LocationSummary?,
      journalFlows: null == journalFlows
          ? _value._journalFlows
          : journalFlows // ignore: cast_nullable_to_non_nullable
              as List<JournalFlow>,
      actualFlows: null == actualFlows
          ? _value._actualFlows
          : actualFlows // ignore: cast_nullable_to_non_nullable
              as List<ActualFlow>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockFlowDataImpl implements _StockFlowData {
  const _$StockFlowDataImpl(
      {this.locationSummary,
      required final List<JournalFlow> journalFlows,
      required final List<ActualFlow> actualFlows})
      : _journalFlows = journalFlows,
        _actualFlows = actualFlows;

  factory _$StockFlowDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockFlowDataImplFromJson(json);

  @override
  final LocationSummary? locationSummary;
  final List<JournalFlow> _journalFlows;
  @override
  List<JournalFlow> get journalFlows {
    if (_journalFlows is EqualUnmodifiableListView) return _journalFlows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_journalFlows);
  }

  final List<ActualFlow> _actualFlows;
  @override
  List<ActualFlow> get actualFlows {
    if (_actualFlows is EqualUnmodifiableListView) return _actualFlows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actualFlows);
  }

  @override
  String toString() {
    return 'StockFlowData(locationSummary: $locationSummary, journalFlows: $journalFlows, actualFlows: $actualFlows)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockFlowDataImpl &&
            (identical(other.locationSummary, locationSummary) ||
                other.locationSummary == locationSummary) &&
            const DeepCollectionEquality()
                .equals(other._journalFlows, _journalFlows) &&
            const DeepCollectionEquality()
                .equals(other._actualFlows, _actualFlows));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      locationSummary,
      const DeepCollectionEquality().hash(_journalFlows),
      const DeepCollectionEquality().hash(_actualFlows));

  /// Create a copy of StockFlowData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockFlowDataImplCopyWith<_$StockFlowDataImpl> get copyWith =>
      __$$StockFlowDataImplCopyWithImpl<_$StockFlowDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockFlowDataImplToJson(
      this,
    );
  }
}

abstract class _StockFlowData implements StockFlowData {
  const factory _StockFlowData(
      {final LocationSummary? locationSummary,
      required final List<JournalFlow> journalFlows,
      required final List<ActualFlow> actualFlows}) = _$StockFlowDataImpl;

  factory _StockFlowData.fromJson(Map<String, dynamic> json) =
      _$StockFlowDataImpl.fromJson;

  @override
  LocationSummary? get locationSummary;
  @override
  List<JournalFlow> get journalFlows;
  @override
  List<ActualFlow> get actualFlows;

  /// Create a copy of StockFlowData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockFlowDataImplCopyWith<_$StockFlowDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaginationInfo _$PaginationInfoFromJson(Map<String, dynamic> json) {
  return _PaginationInfo.fromJson(json);
}

/// @nodoc
mixin _$PaginationInfo {
  int get offset => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get totalJournalFlows => throw _privateConstructorUsedError;
  int get totalActualFlows => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  /// Serializes this PaginationInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginationInfoCopyWith<PaginationInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationInfoCopyWith<$Res> {
  factory $PaginationInfoCopyWith(
          PaginationInfo value, $Res Function(PaginationInfo) then) =
      _$PaginationInfoCopyWithImpl<$Res, PaginationInfo>;
  @useResult
  $Res call(
      {int offset,
      int limit,
      int totalJournalFlows,
      int totalActualFlows,
      bool hasMore});
}

/// @nodoc
class _$PaginationInfoCopyWithImpl<$Res, $Val extends PaginationInfo>
    implements $PaginationInfoCopyWith<$Res> {
  _$PaginationInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offset = null,
    Object? limit = null,
    Object? totalJournalFlows = null,
    Object? totalActualFlows = null,
    Object? hasMore = null,
  }) {
    return _then(_value.copyWith(
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      totalJournalFlows: null == totalJournalFlows
          ? _value.totalJournalFlows
          : totalJournalFlows // ignore: cast_nullable_to_non_nullable
              as int,
      totalActualFlows: null == totalActualFlows
          ? _value.totalActualFlows
          : totalActualFlows // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginationInfoImplCopyWith<$Res>
    implements $PaginationInfoCopyWith<$Res> {
  factory _$$PaginationInfoImplCopyWith(_$PaginationInfoImpl value,
          $Res Function(_$PaginationInfoImpl) then) =
      __$$PaginationInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int offset,
      int limit,
      int totalJournalFlows,
      int totalActualFlows,
      bool hasMore});
}

/// @nodoc
class __$$PaginationInfoImplCopyWithImpl<$Res>
    extends _$PaginationInfoCopyWithImpl<$Res, _$PaginationInfoImpl>
    implements _$$PaginationInfoImplCopyWith<$Res> {
  __$$PaginationInfoImplCopyWithImpl(
      _$PaginationInfoImpl _value, $Res Function(_$PaginationInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offset = null,
    Object? limit = null,
    Object? totalJournalFlows = null,
    Object? totalActualFlows = null,
    Object? hasMore = null,
  }) {
    return _then(_$PaginationInfoImpl(
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      totalJournalFlows: null == totalJournalFlows
          ? _value.totalJournalFlows
          : totalJournalFlows // ignore: cast_nullable_to_non_nullable
              as int,
      totalActualFlows: null == totalActualFlows
          ? _value.totalActualFlows
          : totalActualFlows // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginationInfoImpl implements _PaginationInfo {
  const _$PaginationInfoImpl(
      {required this.offset,
      required this.limit,
      required this.totalJournalFlows,
      required this.totalActualFlows,
      required this.hasMore});

  factory _$PaginationInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationInfoImplFromJson(json);

  @override
  final int offset;
  @override
  final int limit;
  @override
  final int totalJournalFlows;
  @override
  final int totalActualFlows;
  @override
  final bool hasMore;

  @override
  String toString() {
    return 'PaginationInfo(offset: $offset, limit: $limit, totalJournalFlows: $totalJournalFlows, totalActualFlows: $totalActualFlows, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationInfoImpl &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.totalJournalFlows, totalJournalFlows) ||
                other.totalJournalFlows == totalJournalFlows) &&
            (identical(other.totalActualFlows, totalActualFlows) ||
                other.totalActualFlows == totalActualFlows) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, offset, limit, totalJournalFlows, totalActualFlows, hasMore);

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationInfoImplCopyWith<_$PaginationInfoImpl> get copyWith =>
      __$$PaginationInfoImplCopyWithImpl<_$PaginationInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationInfoImplToJson(
      this,
    );
  }
}

abstract class _PaginationInfo implements PaginationInfo {
  const factory _PaginationInfo(
      {required final int offset,
      required final int limit,
      required final int totalJournalFlows,
      required final int totalActualFlows,
      required final bool hasMore}) = _$PaginationInfoImpl;

  factory _PaginationInfo.fromJson(Map<String, dynamic> json) =
      _$PaginationInfoImpl.fromJson;

  @override
  int get offset;
  @override
  int get limit;
  @override
  int get totalJournalFlows;
  @override
  int get totalActualFlows;
  @override
  bool get hasMore;

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationInfoImplCopyWith<_$PaginationInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StockFlowResponse _$StockFlowResponseFromJson(Map<String, dynamic> json) {
  return _StockFlowResponse.fromJson(json);
}

/// @nodoc
mixin _$StockFlowResponse {
  bool get success => throw _privateConstructorUsedError;
  StockFlowData? get data => throw _privateConstructorUsedError;
  PaginationInfo? get pagination => throw _privateConstructorUsedError;

  /// Serializes this StockFlowResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockFlowResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockFlowResponseCopyWith<StockFlowResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockFlowResponseCopyWith<$Res> {
  factory $StockFlowResponseCopyWith(
          StockFlowResponse value, $Res Function(StockFlowResponse) then) =
      _$StockFlowResponseCopyWithImpl<$Res, StockFlowResponse>;
  @useResult
  $Res call({bool success, StockFlowData? data, PaginationInfo? pagination});

  $StockFlowDataCopyWith<$Res>? get data;
  $PaginationInfoCopyWith<$Res>? get pagination;
}

/// @nodoc
class _$StockFlowResponseCopyWithImpl<$Res, $Val extends StockFlowResponse>
    implements $StockFlowResponseCopyWith<$Res> {
  _$StockFlowResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockFlowResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
    Object? pagination = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as StockFlowData?,
      pagination: freezed == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationInfo?,
    ) as $Val);
  }

  /// Create a copy of StockFlowResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StockFlowDataCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $StockFlowDataCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }

  /// Create a copy of StockFlowResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaginationInfoCopyWith<$Res>? get pagination {
    if (_value.pagination == null) {
      return null;
    }

    return $PaginationInfoCopyWith<$Res>(_value.pagination!, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StockFlowResponseImplCopyWith<$Res>
    implements $StockFlowResponseCopyWith<$Res> {
  factory _$$StockFlowResponseImplCopyWith(_$StockFlowResponseImpl value,
          $Res Function(_$StockFlowResponseImpl) then) =
      __$$StockFlowResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, StockFlowData? data, PaginationInfo? pagination});

  @override
  $StockFlowDataCopyWith<$Res>? get data;
  @override
  $PaginationInfoCopyWith<$Res>? get pagination;
}

/// @nodoc
class __$$StockFlowResponseImplCopyWithImpl<$Res>
    extends _$StockFlowResponseCopyWithImpl<$Res, _$StockFlowResponseImpl>
    implements _$$StockFlowResponseImplCopyWith<$Res> {
  __$$StockFlowResponseImplCopyWithImpl(_$StockFlowResponseImpl _value,
      $Res Function(_$StockFlowResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockFlowResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
    Object? pagination = freezed,
  }) {
    return _then(_$StockFlowResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as StockFlowData?,
      pagination: freezed == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationInfo?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockFlowResponseImpl implements _StockFlowResponse {
  const _$StockFlowResponseImpl(
      {required this.success, this.data, this.pagination});

  factory _$StockFlowResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockFlowResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final StockFlowData? data;
  @override
  final PaginationInfo? pagination;

  @override
  String toString() {
    return 'StockFlowResponse(success: $success, data: $data, pagination: $pagination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockFlowResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, data, pagination);

  /// Create a copy of StockFlowResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockFlowResponseImplCopyWith<_$StockFlowResponseImpl> get copyWith =>
      __$$StockFlowResponseImplCopyWithImpl<_$StockFlowResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockFlowResponseImplToJson(
      this,
    );
  }
}

abstract class _StockFlowResponse implements StockFlowResponse {
  const factory _StockFlowResponse(
      {required final bool success,
      final StockFlowData? data,
      final PaginationInfo? pagination}) = _$StockFlowResponseImpl;

  factory _StockFlowResponse.fromJson(Map<String, dynamic> json) =
      _$StockFlowResponseImpl.fromJson;

  @override
  bool get success;
  @override
  StockFlowData? get data;
  @override
  PaginationInfo? get pagination;

  /// Create a copy of StockFlowResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockFlowResponseImplCopyWith<_$StockFlowResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
