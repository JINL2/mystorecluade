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

JournalEntry _$JournalEntryFromJson(Map<String, dynamic> json) {
  return _JournalEntry.fromJson(json);
}

/// @nodoc
mixin _$JournalEntry {
  String get journalId => throw _privateConstructorUsedError;
  String get journalDescription => throw _privateConstructorUsedError;
  String get entryDate => throw _privateConstructorUsedError;
  DateTime get transactionDate => throw _privateConstructorUsedError;
  List<JournalLine> get lines => throw _privateConstructorUsedError;

  /// Serializes this JournalEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

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
@JsonSerializable()
class _$JournalEntryImpl extends _JournalEntry {
  const _$JournalEntryImpl(
      {required this.journalId,
      required this.journalDescription,
      required this.entryDate,
      required this.transactionDate,
      required final List<JournalLine> lines})
      : _lines = lines,
        super._();

  factory _$JournalEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$JournalEntryImplFromJson(json);

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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  @override
  Map<String, dynamic> toJson() {
    return _$$JournalEntryImplToJson(
      this,
    );
  }
}

abstract class _JournalEntry extends JournalEntry {
  const factory _JournalEntry(
      {required final String journalId,
      required final String journalDescription,
      required final String entryDate,
      required final DateTime transactionDate,
      required final List<JournalLine> lines}) = _$JournalEntryImpl;
  const _JournalEntry._() : super._();

  factory _JournalEntry.fromJson(Map<String, dynamic> json) =
      _$JournalEntryImpl.fromJson;

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

JournalLine _$JournalLineFromJson(Map<String, dynamic> json) {
  return _JournalLine.fromJson(json);
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

  /// Serializes this JournalLine to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

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
@JsonSerializable()
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

  factory _$JournalLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$JournalLineImplFromJson(json);

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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  @override
  Map<String, dynamic> toJson() {
    return _$$JournalLineImplToJson(
      this,
    );
  }
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

  factory _JournalLine.fromJson(Map<String, dynamic> json) =
      _$JournalLineImpl.fromJson;

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

TransactionDisplay _$TransactionDisplayFromJson(Map<String, dynamic> json) {
  return _TransactionDisplay.fromJson(json);
}

/// @nodoc
mixin _$TransactionDisplay {
  String get date => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get locationName => throw _privateConstructorUsedError;
  String get personName => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  bool get isIncome => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  JournalEntry get journalEntry => throw _privateConstructorUsedError;

  /// Serializes this TransactionDisplay to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionDisplay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionDisplayCopyWith<TransactionDisplay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionDisplayCopyWith<$Res> {
  factory $TransactionDisplayCopyWith(
          TransactionDisplay value, $Res Function(TransactionDisplay) then) =
      _$TransactionDisplayCopyWithImpl<$Res, TransactionDisplay>;
  @useResult
  $Res call(
      {String date,
      String time,
      String title,
      String locationName,
      String personName,
      double amount,
      bool isIncome,
      String description,
      JournalEntry journalEntry});

  $JournalEntryCopyWith<$Res> get journalEntry;
}

/// @nodoc
class _$TransactionDisplayCopyWithImpl<$Res, $Val extends TransactionDisplay>
    implements $TransactionDisplayCopyWith<$Res> {
  _$TransactionDisplayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionDisplay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? time = null,
    Object? title = null,
    Object? locationName = null,
    Object? personName = null,
    Object? amount = null,
    Object? isIncome = null,
    Object? description = null,
    Object? journalEntry = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      personName: null == personName
          ? _value.personName
          : personName // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      isIncome: null == isIncome
          ? _value.isIncome
          : isIncome // ignore: cast_nullable_to_non_nullable
              as bool,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      journalEntry: null == journalEntry
          ? _value.journalEntry
          : journalEntry // ignore: cast_nullable_to_non_nullable
              as JournalEntry,
    ) as $Val);
  }

  /// Create a copy of TransactionDisplay
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
abstract class _$$TransactionDisplayImplCopyWith<$Res>
    implements $TransactionDisplayCopyWith<$Res> {
  factory _$$TransactionDisplayImplCopyWith(_$TransactionDisplayImpl value,
          $Res Function(_$TransactionDisplayImpl) then) =
      __$$TransactionDisplayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String date,
      String time,
      String title,
      String locationName,
      String personName,
      double amount,
      bool isIncome,
      String description,
      JournalEntry journalEntry});

  @override
  $JournalEntryCopyWith<$Res> get journalEntry;
}

/// @nodoc
class __$$TransactionDisplayImplCopyWithImpl<$Res>
    extends _$TransactionDisplayCopyWithImpl<$Res, _$TransactionDisplayImpl>
    implements _$$TransactionDisplayImplCopyWith<$Res> {
  __$$TransactionDisplayImplCopyWithImpl(_$TransactionDisplayImpl _value,
      $Res Function(_$TransactionDisplayImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionDisplay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? time = null,
    Object? title = null,
    Object? locationName = null,
    Object? personName = null,
    Object? amount = null,
    Object? isIncome = null,
    Object? description = null,
    Object? journalEntry = null,
  }) {
    return _then(_$TransactionDisplayImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      personName: null == personName
          ? _value.personName
          : personName // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      isIncome: null == isIncome
          ? _value.isIncome
          : isIncome // ignore: cast_nullable_to_non_nullable
              as bool,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      journalEntry: null == journalEntry
          ? _value.journalEntry
          : journalEntry // ignore: cast_nullable_to_non_nullable
              as JournalEntry,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionDisplayImpl implements _TransactionDisplay {
  const _$TransactionDisplayImpl(
      {required this.date,
      required this.time,
      required this.title,
      required this.locationName,
      required this.personName,
      required this.amount,
      required this.isIncome,
      required this.description,
      required this.journalEntry});

  factory _$TransactionDisplayImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionDisplayImplFromJson(json);

  @override
  final String date;
  @override
  final String time;
  @override
  final String title;
  @override
  final String locationName;
  @override
  final String personName;
  @override
  final double amount;
  @override
  final bool isIncome;
  @override
  final String description;
  @override
  final JournalEntry journalEntry;

  @override
  String toString() {
    return 'TransactionDisplay(date: $date, time: $time, title: $title, locationName: $locationName, personName: $personName, amount: $amount, isIncome: $isIncome, description: $description, journalEntry: $journalEntry)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionDisplayImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.personName, personName) ||
                other.personName == personName) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.isIncome, isIncome) ||
                other.isIncome == isIncome) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.journalEntry, journalEntry) ||
                other.journalEntry == journalEntry));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, time, title, locationName,
      personName, amount, isIncome, description, journalEntry);

  /// Create a copy of TransactionDisplay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionDisplayImplCopyWith<_$TransactionDisplayImpl> get copyWith =>
      __$$TransactionDisplayImplCopyWithImpl<_$TransactionDisplayImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionDisplayImplToJson(
      this,
    );
  }
}

abstract class _TransactionDisplay implements TransactionDisplay {
  const factory _TransactionDisplay(
      {required final String date,
      required final String time,
      required final String title,
      required final String locationName,
      required final String personName,
      required final double amount,
      required final bool isIncome,
      required final String description,
      required final JournalEntry journalEntry}) = _$TransactionDisplayImpl;

  factory _TransactionDisplay.fromJson(Map<String, dynamic> json) =
      _$TransactionDisplayImpl.fromJson;

  @override
  String get date;
  @override
  String get time;
  @override
  String get title;
  @override
  String get locationName;
  @override
  String get personName;
  @override
  double get amount;
  @override
  bool get isIncome;
  @override
  String get description;
  @override
  JournalEntry get journalEntry;

  /// Create a copy of TransactionDisplay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionDisplayImplCopyWith<_$TransactionDisplayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
