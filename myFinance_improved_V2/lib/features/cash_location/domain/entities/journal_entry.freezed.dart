// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$JournalEntry {
  String get journalId => throw _privateConstructorUsedError;
  String get journalDescription => throw _privateConstructorUsedError;
  String get entryDate => throw _privateConstructorUsedError;
  DateTime get transactionDate => throw _privateConstructorUsedError;
  List<JournalLine> get lines => throw _privateConstructorUsedError;

  /// Create a copy of JournalEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JournalEntryCopyWith<JournalEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JournalEntryCopyWith<$Res> {
  factory $JournalEntryCopyWith(
          JournalEntry value, $Res Function(JournalEntry) then) =
      _$JournalEntryCopyWithImpl<$Res, JournalEntry>;
  @useResult
  $Res call(
      {String journalId,
      String journalDescription,
      String entryDate,
      DateTime transactionDate,
      List<JournalLine> lines});
}

/// @nodoc
class _$JournalEntryCopyWithImpl<$Res, $Val extends JournalEntry>
    implements $JournalEntryCopyWith<$Res> {
  _$JournalEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JournalEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? journalId = null,
    Object? journalDescription = null,
    Object? entryDate = null,
    Object? transactionDate = null,
    Object? lines = null,
  }) {
    return _then(_value.copyWith(
      journalId: null == journalId
          ? _value.journalId
          : journalId // ignore: cast_nullable_to_non_nullable
              as String,
      journalDescription: null == journalDescription
          ? _value.journalDescription
          : journalDescription // ignore: cast_nullable_to_non_nullable
              as String,
      entryDate: null == entryDate
          ? _value.entryDate
          : entryDate // ignore: cast_nullable_to_non_nullable
              as String,
      transactionDate: null == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lines: null == lines
          ? _value.lines
          : lines // ignore: cast_nullable_to_non_nullable
              as List<JournalLine>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JournalEntryImplCopyWith<$Res>
    implements $JournalEntryCopyWith<$Res> {
  factory _$$JournalEntryImplCopyWith(
          _$JournalEntryImpl value, $Res Function(_$JournalEntryImpl) then) =
      __$$JournalEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String journalId,
      String journalDescription,
      String entryDate,
      DateTime transactionDate,
      List<JournalLine> lines});
}

/// @nodoc
class __$$JournalEntryImplCopyWithImpl<$Res>
    extends _$JournalEntryCopyWithImpl<$Res, _$JournalEntryImpl>
    implements _$$JournalEntryImplCopyWith<$Res> {
  __$$JournalEntryImplCopyWithImpl(
      _$JournalEntryImpl _value, $Res Function(_$JournalEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of JournalEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? journalId = null,
    Object? journalDescription = null,
    Object? entryDate = null,
    Object? transactionDate = null,
    Object? lines = null,
  }) {
    return _then(_$JournalEntryImpl(
      journalId: null == journalId
          ? _value.journalId
          : journalId // ignore: cast_nullable_to_non_nullable
              as String,
      journalDescription: null == journalDescription
          ? _value.journalDescription
          : journalDescription // ignore: cast_nullable_to_non_nullable
              as String,
      entryDate: null == entryDate
          ? _value.entryDate
          : entryDate // ignore: cast_nullable_to_non_nullable
              as String,
      transactionDate: null == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lines: null == lines
          ? _value._lines
          : lines // ignore: cast_nullable_to_non_nullable
              as List<JournalLine>,
    ));
  }
}

/// @nodoc

class _$JournalEntryImpl extends _JournalEntry {
  const _$JournalEntryImpl(
      {required this.journalId,
      required this.journalDescription,
      required this.entryDate,
      required this.transactionDate,
      required final List<JournalLine> lines})
      : _lines = lines,
        super._();

  @override
  final String journalId;
  @override
  final String journalDescription;
  @override
  final String entryDate;
  @override
  final DateTime transactionDate;
  final List<JournalLine> _lines;
  @override
  List<JournalLine> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  @override
  String toString() {
    return 'JournalEntry(journalId: $journalId, journalDescription: $journalDescription, entryDate: $entryDate, transactionDate: $transactionDate, lines: $lines)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JournalEntryImpl &&
            (identical(other.journalId, journalId) ||
                other.journalId == journalId) &&
            (identical(other.journalDescription, journalDescription) ||
                other.journalDescription == journalDescription) &&
            (identical(other.entryDate, entryDate) ||
                other.entryDate == entryDate) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            const DeepCollectionEquality().equals(other._lines, _lines));
  }

  @override
  int get hashCode => Object.hash(runtimeType, journalId, journalDescription,
      entryDate, transactionDate, const DeepCollectionEquality().hash(_lines));

  /// Create a copy of JournalEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JournalEntryImplCopyWith<_$JournalEntryImpl> get copyWith =>
      __$$JournalEntryImplCopyWithImpl<_$JournalEntryImpl>(this, _$identity);
}

abstract class _JournalEntry extends JournalEntry {
  const factory _JournalEntry(
      {required final String journalId,
      required final String journalDescription,
      required final String entryDate,
      required final DateTime transactionDate,
      required final List<JournalLine> lines}) = _$JournalEntryImpl;
  const _JournalEntry._() : super._();

  @override
  String get journalId;
  @override
  String get journalDescription;
  @override
  String get entryDate;
  @override
  DateTime get transactionDate;
  @override
  List<JournalLine> get lines;

  /// Create a copy of JournalEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JournalEntryImplCopyWith<_$JournalEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$JournalLine {
  String get lineId => throw _privateConstructorUsedError;
  String? get cashLocationId => throw _privateConstructorUsedError;
  String? get locationName => throw _privateConstructorUsedError;
  String? get locationType => throw _privateConstructorUsedError;
  String get accountId => throw _privateConstructorUsedError;
  String get accountName => throw _privateConstructorUsedError;
  double get debit => throw _privateConstructorUsedError;
  double get credit => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  /// Create a copy of JournalLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JournalLineCopyWith<JournalLine> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JournalLineCopyWith<$Res> {
  factory $JournalLineCopyWith(
          JournalLine value, $Res Function(JournalLine) then) =
      _$JournalLineCopyWithImpl<$Res, JournalLine>;
  @useResult
  $Res call(
      {String lineId,
      String? cashLocationId,
      String? locationName,
      String? locationType,
      String accountId,
      String accountName,
      double debit,
      double credit,
      String description});
}

/// @nodoc
class _$JournalLineCopyWithImpl<$Res, $Val extends JournalLine>
    implements $JournalLineCopyWith<$Res> {
  _$JournalLineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JournalLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lineId = null,
    Object? cashLocationId = freezed,
    Object? locationName = freezed,
    Object? locationType = freezed,
    Object? accountId = null,
    Object? accountName = null,
    Object? debit = null,
    Object? credit = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      lineId: null == lineId
          ? _value.lineId
          : lineId // ignore: cast_nullable_to_non_nullable
              as String,
      cashLocationId: freezed == cashLocationId
          ? _value.cashLocationId
          : cashLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
      locationName: freezed == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
      locationType: freezed == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String?,
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
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
abstract class _$$JournalLineImplCopyWith<$Res>
    implements $JournalLineCopyWith<$Res> {
  factory _$$JournalLineImplCopyWith(
          _$JournalLineImpl value, $Res Function(_$JournalLineImpl) then) =
      __$$JournalLineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String lineId,
      String? cashLocationId,
      String? locationName,
      String? locationType,
      String accountId,
      String accountName,
      double debit,
      double credit,
      String description});
}

/// @nodoc
class __$$JournalLineImplCopyWithImpl<$Res>
    extends _$JournalLineCopyWithImpl<$Res, _$JournalLineImpl>
    implements _$$JournalLineImplCopyWith<$Res> {
  __$$JournalLineImplCopyWithImpl(
      _$JournalLineImpl _value, $Res Function(_$JournalLineImpl) _then)
      : super(_value, _then);

  /// Create a copy of JournalLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lineId = null,
    Object? cashLocationId = freezed,
    Object? locationName = freezed,
    Object? locationType = freezed,
    Object? accountId = null,
    Object? accountName = null,
    Object? debit = null,
    Object? credit = null,
    Object? description = null,
  }) {
    return _then(_$JournalLineImpl(
      lineId: null == lineId
          ? _value.lineId
          : lineId // ignore: cast_nullable_to_non_nullable
              as String,
      cashLocationId: freezed == cashLocationId
          ? _value.cashLocationId
          : cashLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
      locationName: freezed == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
      locationType: freezed == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String?,
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
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

class _$JournalLineImpl implements _JournalLine {
  const _$JournalLineImpl(
      {required this.lineId,
      this.cashLocationId,
      this.locationName,
      this.locationType,
      required this.accountId,
      required this.accountName,
      required this.debit,
      required this.credit,
      required this.description});

  @override
  final String lineId;
  @override
  final String? cashLocationId;
  @override
  final String? locationName;
  @override
  final String? locationType;
  @override
  final String accountId;
  @override
  final String accountName;
  @override
  final double debit;
  @override
  final double credit;
  @override
  final String description;

  @override
  String toString() {
    return 'JournalLine(lineId: $lineId, cashLocationId: $cashLocationId, locationName: $locationName, locationType: $locationType, accountId: $accountId, accountName: $accountName, debit: $debit, credit: $credit, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JournalLineImpl &&
            (identical(other.lineId, lineId) || other.lineId == lineId) &&
            (identical(other.cashLocationId, cashLocationId) ||
                other.cashLocationId == cashLocationId) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.locationType, locationType) ||
                other.locationType == locationType) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.debit, debit) || other.debit == debit) &&
            (identical(other.credit, credit) || other.credit == credit) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      lineId,
      cashLocationId,
      locationName,
      locationType,
      accountId,
      accountName,
      debit,
      credit,
      description);

  /// Create a copy of JournalLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JournalLineImplCopyWith<_$JournalLineImpl> get copyWith =>
      __$$JournalLineImplCopyWithImpl<_$JournalLineImpl>(this, _$identity);
}

abstract class _JournalLine implements JournalLine {
  const factory _JournalLine(
      {required final String lineId,
      final String? cashLocationId,
      final String? locationName,
      final String? locationType,
      required final String accountId,
      required final String accountName,
      required final double debit,
      required final double credit,
      required final String description}) = _$JournalLineImpl;

  @override
  String get lineId;
  @override
  String? get cashLocationId;
  @override
  String? get locationName;
  @override
  String? get locationType;
  @override
  String get accountId;
  @override
  String get accountName;
  @override
  double get debit;
  @override
  double get credit;
  @override
  String get description;

  /// Create a copy of JournalLine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JournalLineImplCopyWith<_$JournalLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TransactionData {
  JournalLine get cashLine => throw _privateConstructorUsedError;
  JournalLine get counterpartLine => throw _privateConstructorUsedError;
  bool get isIncome => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  JournalEntry get journalEntry => throw _privateConstructorUsedError;

  /// Create a copy of TransactionData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionDataCopyWith<TransactionData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionDataCopyWith<$Res> {
  factory $TransactionDataCopyWith(
          TransactionData value, $Res Function(TransactionData) then) =
      _$TransactionDataCopyWithImpl<$Res, TransactionData>;
  @useResult
  $Res call(
      {JournalLine cashLine,
      JournalLine counterpartLine,
      bool isIncome,
      double amount,
      JournalEntry journalEntry});

  $JournalLineCopyWith<$Res> get cashLine;
  $JournalLineCopyWith<$Res> get counterpartLine;
  $JournalEntryCopyWith<$Res> get journalEntry;
}

/// @nodoc
class _$TransactionDataCopyWithImpl<$Res, $Val extends TransactionData>
    implements $TransactionDataCopyWith<$Res> {
  _$TransactionDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cashLine = null,
    Object? counterpartLine = null,
    Object? isIncome = null,
    Object? amount = null,
    Object? journalEntry = null,
  }) {
    return _then(_value.copyWith(
      cashLine: null == cashLine
          ? _value.cashLine
          : cashLine // ignore: cast_nullable_to_non_nullable
              as JournalLine,
      counterpartLine: null == counterpartLine
          ? _value.counterpartLine
          : counterpartLine // ignore: cast_nullable_to_non_nullable
              as JournalLine,
      isIncome: null == isIncome
          ? _value.isIncome
          : isIncome // ignore: cast_nullable_to_non_nullable
              as bool,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      journalEntry: null == journalEntry
          ? _value.journalEntry
          : journalEntry // ignore: cast_nullable_to_non_nullable
              as JournalEntry,
    ) as $Val);
  }

  /// Create a copy of TransactionData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $JournalLineCopyWith<$Res> get cashLine {
    return $JournalLineCopyWith<$Res>(_value.cashLine, (value) {
      return _then(_value.copyWith(cashLine: value) as $Val);
    });
  }

  /// Create a copy of TransactionData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $JournalLineCopyWith<$Res> get counterpartLine {
    return $JournalLineCopyWith<$Res>(_value.counterpartLine, (value) {
      return _then(_value.copyWith(counterpartLine: value) as $Val);
    });
  }

  /// Create a copy of TransactionData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $JournalEntryCopyWith<$Res> get journalEntry {
    return $JournalEntryCopyWith<$Res>(_value.journalEntry, (value) {
      return _then(_value.copyWith(journalEntry: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TransactionDataImplCopyWith<$Res>
    implements $TransactionDataCopyWith<$Res> {
  factory _$$TransactionDataImplCopyWith(_$TransactionDataImpl value,
          $Res Function(_$TransactionDataImpl) then) =
      __$$TransactionDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {JournalLine cashLine,
      JournalLine counterpartLine,
      bool isIncome,
      double amount,
      JournalEntry journalEntry});

  @override
  $JournalLineCopyWith<$Res> get cashLine;
  @override
  $JournalLineCopyWith<$Res> get counterpartLine;
  @override
  $JournalEntryCopyWith<$Res> get journalEntry;
}

/// @nodoc
class __$$TransactionDataImplCopyWithImpl<$Res>
    extends _$TransactionDataCopyWithImpl<$Res, _$TransactionDataImpl>
    implements _$$TransactionDataImplCopyWith<$Res> {
  __$$TransactionDataImplCopyWithImpl(
      _$TransactionDataImpl _value, $Res Function(_$TransactionDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cashLine = null,
    Object? counterpartLine = null,
    Object? isIncome = null,
    Object? amount = null,
    Object? journalEntry = null,
  }) {
    return _then(_$TransactionDataImpl(
      cashLine: null == cashLine
          ? _value.cashLine
          : cashLine // ignore: cast_nullable_to_non_nullable
              as JournalLine,
      counterpartLine: null == counterpartLine
          ? _value.counterpartLine
          : counterpartLine // ignore: cast_nullable_to_non_nullable
              as JournalLine,
      isIncome: null == isIncome
          ? _value.isIncome
          : isIncome // ignore: cast_nullable_to_non_nullable
              as bool,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      journalEntry: null == journalEntry
          ? _value.journalEntry
          : journalEntry // ignore: cast_nullable_to_non_nullable
              as JournalEntry,
    ));
  }
}

/// @nodoc

class _$TransactionDataImpl implements _TransactionData {
  const _$TransactionDataImpl(
      {required this.cashLine,
      required this.counterpartLine,
      required this.isIncome,
      required this.amount,
      required this.journalEntry});

  @override
  final JournalLine cashLine;
  @override
  final JournalLine counterpartLine;
  @override
  final bool isIncome;
  @override
  final double amount;
  @override
  final JournalEntry journalEntry;

  @override
  String toString() {
    return 'TransactionData(cashLine: $cashLine, counterpartLine: $counterpartLine, isIncome: $isIncome, amount: $amount, journalEntry: $journalEntry)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionDataImpl &&
            (identical(other.cashLine, cashLine) ||
                other.cashLine == cashLine) &&
            (identical(other.counterpartLine, counterpartLine) ||
                other.counterpartLine == counterpartLine) &&
            (identical(other.isIncome, isIncome) ||
                other.isIncome == isIncome) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.journalEntry, journalEntry) ||
                other.journalEntry == journalEntry));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, cashLine, counterpartLine, isIncome, amount, journalEntry);

  /// Create a copy of TransactionData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionDataImplCopyWith<_$TransactionDataImpl> get copyWith =>
      __$$TransactionDataImplCopyWithImpl<_$TransactionDataImpl>(
          this, _$identity);
}

abstract class _TransactionData implements TransactionData {
  const factory _TransactionData(
      {required final JournalLine cashLine,
      required final JournalLine counterpartLine,
      required final bool isIncome,
      required final double amount,
      required final JournalEntry journalEntry}) = _$TransactionDataImpl;

  @override
  JournalLine get cashLine;
  @override
  JournalLine get counterpartLine;
  @override
  bool get isIncome;
  @override
  double get amount;
  @override
  JournalEntry get journalEntry;

  /// Create a copy of TransactionData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionDataImplCopyWith<_$TransactionDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
