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
  List<TransactionLine> get transactionLines =>
      throw _privateConstructorUsedError;
  List<JournalAttachment> get attachments => throw _privateConstructorUsedError;
  DateTime get entryDate => throw _privateConstructorUsedError;
  String? get overallDescription => throw _privateConstructorUsedError;
  String? get selectedCompanyId => throw _privateConstructorUsedError;
  String? get selectedStoreId => throw _privateConstructorUsedError;
  String? get counterpartyCashLocationId => throw _privateConstructorUsedError;

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
      {List<TransactionLine> transactionLines,
      List<JournalAttachment> attachments,
      DateTime entryDate,
      String? overallDescription,
      String? selectedCompanyId,
      String? selectedStoreId,
      String? counterpartyCashLocationId});
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
    Object? transactionLines = null,
    Object? attachments = null,
    Object? entryDate = null,
    Object? overallDescription = freezed,
    Object? selectedCompanyId = freezed,
    Object? selectedStoreId = freezed,
    Object? counterpartyCashLocationId = freezed,
  }) {
    return _then(_value.copyWith(
      transactionLines: null == transactionLines
          ? _value.transactionLines
          : transactionLines // ignore: cast_nullable_to_non_nullable
              as List<TransactionLine>,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<JournalAttachment>,
      entryDate: null == entryDate
          ? _value.entryDate
          : entryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      overallDescription: freezed == overallDescription
          ? _value.overallDescription
          : overallDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedCompanyId: freezed == selectedCompanyId
          ? _value.selectedCompanyId
          : selectedCompanyId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedStoreId: freezed == selectedStoreId
          ? _value.selectedStoreId
          : selectedStoreId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyCashLocationId: freezed == counterpartyCashLocationId
          ? _value.counterpartyCashLocationId
          : counterpartyCashLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      {List<TransactionLine> transactionLines,
      List<JournalAttachment> attachments,
      DateTime entryDate,
      String? overallDescription,
      String? selectedCompanyId,
      String? selectedStoreId,
      String? counterpartyCashLocationId});
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
    Object? transactionLines = null,
    Object? attachments = null,
    Object? entryDate = null,
    Object? overallDescription = freezed,
    Object? selectedCompanyId = freezed,
    Object? selectedStoreId = freezed,
    Object? counterpartyCashLocationId = freezed,
  }) {
    return _then(_$JournalEntryImpl(
      transactionLines: null == transactionLines
          ? _value._transactionLines
          : transactionLines // ignore: cast_nullable_to_non_nullable
              as List<TransactionLine>,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<JournalAttachment>,
      entryDate: null == entryDate
          ? _value.entryDate
          : entryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      overallDescription: freezed == overallDescription
          ? _value.overallDescription
          : overallDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedCompanyId: freezed == selectedCompanyId
          ? _value.selectedCompanyId
          : selectedCompanyId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedStoreId: freezed == selectedStoreId
          ? _value.selectedStoreId
          : selectedStoreId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyCashLocationId: freezed == counterpartyCashLocationId
          ? _value.counterpartyCashLocationId
          : counterpartyCashLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$JournalEntryImpl extends _JournalEntry {
  const _$JournalEntryImpl(
      {final List<TransactionLine> transactionLines = const [],
      final List<JournalAttachment> attachments = const [],
      required this.entryDate,
      this.overallDescription,
      this.selectedCompanyId,
      this.selectedStoreId,
      this.counterpartyCashLocationId})
      : _transactionLines = transactionLines,
        _attachments = attachments,
        super._();

  final List<TransactionLine> _transactionLines;
  @override
  @JsonKey()
  List<TransactionLine> get transactionLines {
    if (_transactionLines is EqualUnmodifiableListView)
      return _transactionLines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactionLines);
  }

  final List<JournalAttachment> _attachments;
  @override
  @JsonKey()
  List<JournalAttachment> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  final DateTime entryDate;
  @override
  final String? overallDescription;
  @override
  final String? selectedCompanyId;
  @override
  final String? selectedStoreId;
  @override
  final String? counterpartyCashLocationId;

  @override
  String toString() {
    return 'JournalEntry(transactionLines: $transactionLines, attachments: $attachments, entryDate: $entryDate, overallDescription: $overallDescription, selectedCompanyId: $selectedCompanyId, selectedStoreId: $selectedStoreId, counterpartyCashLocationId: $counterpartyCashLocationId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JournalEntryImpl &&
            const DeepCollectionEquality()
                .equals(other._transactionLines, _transactionLines) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.entryDate, entryDate) ||
                other.entryDate == entryDate) &&
            (identical(other.overallDescription, overallDescription) ||
                other.overallDescription == overallDescription) &&
            (identical(other.selectedCompanyId, selectedCompanyId) ||
                other.selectedCompanyId == selectedCompanyId) &&
            (identical(other.selectedStoreId, selectedStoreId) ||
                other.selectedStoreId == selectedStoreId) &&
            (identical(other.counterpartyCashLocationId,
                    counterpartyCashLocationId) ||
                other.counterpartyCashLocationId ==
                    counterpartyCashLocationId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_transactionLines),
      const DeepCollectionEquality().hash(_attachments),
      entryDate,
      overallDescription,
      selectedCompanyId,
      selectedStoreId,
      counterpartyCashLocationId);

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
      {final List<TransactionLine> transactionLines,
      final List<JournalAttachment> attachments,
      required final DateTime entryDate,
      final String? overallDescription,
      final String? selectedCompanyId,
      final String? selectedStoreId,
      final String? counterpartyCashLocationId}) = _$JournalEntryImpl;
  const _JournalEntry._() : super._();

  @override
  List<TransactionLine> get transactionLines;
  @override
  List<JournalAttachment> get attachments;
  @override
  DateTime get entryDate;
  @override
  String? get overallDescription;
  @override
  String? get selectedCompanyId;
  @override
  String? get selectedStoreId;
  @override
  String? get counterpartyCashLocationId;

  /// Create a copy of JournalEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JournalEntryImplCopyWith<_$JournalEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
