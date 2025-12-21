// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TransactionData {
  @JsonKey(name: 'journal_id')
  String get journalId => throw _privateConstructorUsedError;
  @JsonKey(name: 'journal_number')
  String get journalNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'entry_date')
  DateTime get entryDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'journal_type')
  String get journalType => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_draft')
  bool get isDraft => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_id')
  String? get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_name')
  String? get storeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_code')
  String? get storeCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  String? get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by_name')
  String get createdByName => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_code')
  String get currencyCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_symbol')
  String get currencySymbol => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_debit')
  double get totalDebit => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_credit')
  double get totalCredit => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  double get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'lines')
  List<TransactionLine> get lines => throw _privateConstructorUsedError;
  @JsonKey(name: 'attachments')
  List<TransactionAttachment> get attachments =>
      throw _privateConstructorUsedError;

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
      {@JsonKey(name: 'journal_id') String journalId,
      @JsonKey(name: 'journal_number') String journalNumber,
      @JsonKey(name: 'entry_date') DateTime entryDate,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'description') String description,
      @JsonKey(name: 'journal_type') String journalType,
      @JsonKey(name: 'is_draft') bool isDraft,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'store_name') String? storeName,
      @JsonKey(name: 'store_code') String? storeCode,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'created_by_name') String createdByName,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'currency_symbol') String currencySymbol,
      @JsonKey(name: 'total_debit') double totalDebit,
      @JsonKey(name: 'total_credit') double totalCredit,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'lines') List<TransactionLine> lines,
      @JsonKey(name: 'attachments') List<TransactionAttachment> attachments});
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
    Object? journalId = null,
    Object? journalNumber = null,
    Object? entryDate = null,
    Object? createdAt = null,
    Object? description = null,
    Object? journalType = null,
    Object? isDraft = null,
    Object? storeId = freezed,
    Object? storeName = freezed,
    Object? storeCode = freezed,
    Object? createdBy = freezed,
    Object? createdByName = null,
    Object? currencyCode = null,
    Object? currencySymbol = null,
    Object? totalDebit = null,
    Object? totalCredit = null,
    Object? totalAmount = null,
    Object? lines = null,
    Object? attachments = null,
  }) {
    return _then(_value.copyWith(
      journalId: null == journalId
          ? _value.journalId
          : journalId // ignore: cast_nullable_to_non_nullable
              as String,
      journalNumber: null == journalNumber
          ? _value.journalNumber
          : journalNumber // ignore: cast_nullable_to_non_nullable
              as String,
      entryDate: null == entryDate
          ? _value.entryDate
          : entryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      journalType: null == journalType
          ? _value.journalType
          : journalType // ignore: cast_nullable_to_non_nullable
              as String,
      isDraft: null == isDraft
          ? _value.isDraft
          : isDraft // ignore: cast_nullable_to_non_nullable
              as bool,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      storeCode: freezed == storeCode
          ? _value.storeCode
          : storeCode // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdByName: null == createdByName
          ? _value.createdByName
          : createdByName // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      totalDebit: null == totalDebit
          ? _value.totalDebit
          : totalDebit // ignore: cast_nullable_to_non_nullable
              as double,
      totalCredit: null == totalCredit
          ? _value.totalCredit
          : totalCredit // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      lines: null == lines
          ? _value.lines
          : lines // ignore: cast_nullable_to_non_nullable
              as List<TransactionLine>,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<TransactionAttachment>,
    ) as $Val);
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
      {@JsonKey(name: 'journal_id') String journalId,
      @JsonKey(name: 'journal_number') String journalNumber,
      @JsonKey(name: 'entry_date') DateTime entryDate,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'description') String description,
      @JsonKey(name: 'journal_type') String journalType,
      @JsonKey(name: 'is_draft') bool isDraft,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'store_name') String? storeName,
      @JsonKey(name: 'store_code') String? storeCode,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'created_by_name') String createdByName,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'currency_symbol') String currencySymbol,
      @JsonKey(name: 'total_debit') double totalDebit,
      @JsonKey(name: 'total_credit') double totalCredit,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'lines') List<TransactionLine> lines,
      @JsonKey(name: 'attachments') List<TransactionAttachment> attachments});
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
    Object? journalId = null,
    Object? journalNumber = null,
    Object? entryDate = null,
    Object? createdAt = null,
    Object? description = null,
    Object? journalType = null,
    Object? isDraft = null,
    Object? storeId = freezed,
    Object? storeName = freezed,
    Object? storeCode = freezed,
    Object? createdBy = freezed,
    Object? createdByName = null,
    Object? currencyCode = null,
    Object? currencySymbol = null,
    Object? totalDebit = null,
    Object? totalCredit = null,
    Object? totalAmount = null,
    Object? lines = null,
    Object? attachments = null,
  }) {
    return _then(_$TransactionDataImpl(
      journalId: null == journalId
          ? _value.journalId
          : journalId // ignore: cast_nullable_to_non_nullable
              as String,
      journalNumber: null == journalNumber
          ? _value.journalNumber
          : journalNumber // ignore: cast_nullable_to_non_nullable
              as String,
      entryDate: null == entryDate
          ? _value.entryDate
          : entryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      journalType: null == journalType
          ? _value.journalType
          : journalType // ignore: cast_nullable_to_non_nullable
              as String,
      isDraft: null == isDraft
          ? _value.isDraft
          : isDraft // ignore: cast_nullable_to_non_nullable
              as bool,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      storeCode: freezed == storeCode
          ? _value.storeCode
          : storeCode // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdByName: null == createdByName
          ? _value.createdByName
          : createdByName // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      totalDebit: null == totalDebit
          ? _value.totalDebit
          : totalDebit // ignore: cast_nullable_to_non_nullable
              as double,
      totalCredit: null == totalCredit
          ? _value.totalCredit
          : totalCredit // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      lines: null == lines
          ? _value._lines
          : lines // ignore: cast_nullable_to_non_nullable
              as List<TransactionLine>,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<TransactionAttachment>,
    ));
  }
}

/// @nodoc

class _$TransactionDataImpl implements _TransactionData {
  const _$TransactionDataImpl(
      {@JsonKey(name: 'journal_id') required this.journalId,
      @JsonKey(name: 'journal_number') required this.journalNumber,
      @JsonKey(name: 'entry_date') required this.entryDate,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'description') required this.description,
      @JsonKey(name: 'journal_type') required this.journalType,
      @JsonKey(name: 'is_draft') required this.isDraft,
      @JsonKey(name: 'store_id') this.storeId,
      @JsonKey(name: 'store_name') this.storeName,
      @JsonKey(name: 'store_code') this.storeCode,
      @JsonKey(name: 'created_by') this.createdBy,
      @JsonKey(name: 'created_by_name') required this.createdByName,
      @JsonKey(name: 'currency_code') required this.currencyCode,
      @JsonKey(name: 'currency_symbol') required this.currencySymbol,
      @JsonKey(name: 'total_debit') required this.totalDebit,
      @JsonKey(name: 'total_credit') required this.totalCredit,
      @JsonKey(name: 'total_amount') required this.totalAmount,
      @JsonKey(name: 'lines') required final List<TransactionLine> lines,
      @JsonKey(name: 'attachments')
      required final List<TransactionAttachment> attachments})
      : _lines = lines,
        _attachments = attachments;

  @override
  @JsonKey(name: 'journal_id')
  final String journalId;
  @override
  @JsonKey(name: 'journal_number')
  final String journalNumber;
  @override
  @JsonKey(name: 'entry_date')
  final DateTime entryDate;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'description')
  final String description;
  @override
  @JsonKey(name: 'journal_type')
  final String journalType;
  @override
  @JsonKey(name: 'is_draft')
  final bool isDraft;
  @override
  @JsonKey(name: 'store_id')
  final String? storeId;
  @override
  @JsonKey(name: 'store_name')
  final String? storeName;
  @override
  @JsonKey(name: 'store_code')
  final String? storeCode;
  @override
  @JsonKey(name: 'created_by')
  final String? createdBy;
  @override
  @JsonKey(name: 'created_by_name')
  final String createdByName;
  @override
  @JsonKey(name: 'currency_code')
  final String currencyCode;
  @override
  @JsonKey(name: 'currency_symbol')
  final String currencySymbol;
  @override
  @JsonKey(name: 'total_debit')
  final double totalDebit;
  @override
  @JsonKey(name: 'total_credit')
  final double totalCredit;
  @override
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  final List<TransactionLine> _lines;
  @override
  @JsonKey(name: 'lines')
  List<TransactionLine> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  final List<TransactionAttachment> _attachments;
  @override
  @JsonKey(name: 'attachments')
  List<TransactionAttachment> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  String toString() {
    return 'TransactionData(journalId: $journalId, journalNumber: $journalNumber, entryDate: $entryDate, createdAt: $createdAt, description: $description, journalType: $journalType, isDraft: $isDraft, storeId: $storeId, storeName: $storeName, storeCode: $storeCode, createdBy: $createdBy, createdByName: $createdByName, currencyCode: $currencyCode, currencySymbol: $currencySymbol, totalDebit: $totalDebit, totalCredit: $totalCredit, totalAmount: $totalAmount, lines: $lines, attachments: $attachments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionDataImpl &&
            (identical(other.journalId, journalId) ||
                other.journalId == journalId) &&
            (identical(other.journalNumber, journalNumber) ||
                other.journalNumber == journalNumber) &&
            (identical(other.entryDate, entryDate) ||
                other.entryDate == entryDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.journalType, journalType) ||
                other.journalType == journalType) &&
            (identical(other.isDraft, isDraft) || other.isDraft == isDraft) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.storeCode, storeCode) ||
                other.storeCode == storeCode) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdByName, createdByName) ||
                other.createdByName == createdByName) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
            (identical(other.totalDebit, totalDebit) ||
                other.totalDebit == totalDebit) &&
            (identical(other.totalCredit, totalCredit) ||
                other.totalCredit == totalCredit) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            const DeepCollectionEquality().equals(other._lines, _lines) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        journalId,
        journalNumber,
        entryDate,
        createdAt,
        description,
        journalType,
        isDraft,
        storeId,
        storeName,
        storeCode,
        createdBy,
        createdByName,
        currencyCode,
        currencySymbol,
        totalDebit,
        totalCredit,
        totalAmount,
        const DeepCollectionEquality().hash(_lines),
        const DeepCollectionEquality().hash(_attachments)
      ]);

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
      {@JsonKey(name: 'journal_id') required final String journalId,
      @JsonKey(name: 'journal_number') required final String journalNumber,
      @JsonKey(name: 'entry_date') required final DateTime entryDate,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'description') required final String description,
      @JsonKey(name: 'journal_type') required final String journalType,
      @JsonKey(name: 'is_draft') required final bool isDraft,
      @JsonKey(name: 'store_id') final String? storeId,
      @JsonKey(name: 'store_name') final String? storeName,
      @JsonKey(name: 'store_code') final String? storeCode,
      @JsonKey(name: 'created_by') final String? createdBy,
      @JsonKey(name: 'created_by_name') required final String createdByName,
      @JsonKey(name: 'currency_code') required final String currencyCode,
      @JsonKey(name: 'currency_symbol') required final String currencySymbol,
      @JsonKey(name: 'total_debit') required final double totalDebit,
      @JsonKey(name: 'total_credit') required final double totalCredit,
      @JsonKey(name: 'total_amount') required final double totalAmount,
      @JsonKey(name: 'lines') required final List<TransactionLine> lines,
      @JsonKey(name: 'attachments')
      required final List<TransactionAttachment>
          attachments}) = _$TransactionDataImpl;

  @override
  @JsonKey(name: 'journal_id')
  String get journalId;
  @override
  @JsonKey(name: 'journal_number')
  String get journalNumber;
  @override
  @JsonKey(name: 'entry_date')
  DateTime get entryDate;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'description')
  String get description;
  @override
  @JsonKey(name: 'journal_type')
  String get journalType;
  @override
  @JsonKey(name: 'is_draft')
  bool get isDraft;
  @override
  @JsonKey(name: 'store_id')
  String? get storeId;
  @override
  @JsonKey(name: 'store_name')
  String? get storeName;
  @override
  @JsonKey(name: 'store_code')
  String? get storeCode;
  @override
  @JsonKey(name: 'created_by')
  String? get createdBy;
  @override
  @JsonKey(name: 'created_by_name')
  String get createdByName;
  @override
  @JsonKey(name: 'currency_code')
  String get currencyCode;
  @override
  @JsonKey(name: 'currency_symbol')
  String get currencySymbol;
  @override
  @JsonKey(name: 'total_debit')
  double get totalDebit;
  @override
  @JsonKey(name: 'total_credit')
  double get totalCredit;
  @override
  @JsonKey(name: 'total_amount')
  double get totalAmount;
  @override
  @JsonKey(name: 'lines')
  List<TransactionLine> get lines;
  @override
  @JsonKey(name: 'attachments')
  List<TransactionAttachment> get attachments;

  /// Create a copy of TransactionData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionDataImplCopyWith<_$TransactionDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TransactionAttachment {
  @JsonKey(name: 'attachment_id')
  String get attachmentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_name')
  String get fileName => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_type')
  String get fileType => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_size')
  int get fileSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_url')
  String? get fileUrl => throw _privateConstructorUsedError;

  /// Create a copy of TransactionAttachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionAttachmentCopyWith<TransactionAttachment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionAttachmentCopyWith<$Res> {
  factory $TransactionAttachmentCopyWith(TransactionAttachment value,
          $Res Function(TransactionAttachment) then) =
      _$TransactionAttachmentCopyWithImpl<$Res, TransactionAttachment>;
  @useResult
  $Res call(
      {@JsonKey(name: 'attachment_id') String attachmentId,
      @JsonKey(name: 'file_name') String fileName,
      @JsonKey(name: 'file_type') String fileType,
      @JsonKey(name: 'file_size') int fileSize,
      @JsonKey(name: 'file_url') String? fileUrl});
}

/// @nodoc
class _$TransactionAttachmentCopyWithImpl<$Res,
        $Val extends TransactionAttachment>
    implements $TransactionAttachmentCopyWith<$Res> {
  _$TransactionAttachmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionAttachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attachmentId = null,
    Object? fileName = null,
    Object? fileType = null,
    Object? fileSize = null,
    Object? fileUrl = freezed,
  }) {
    return _then(_value.copyWith(
      attachmentId: null == attachmentId
          ? _value.attachmentId
          : attachmentId // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileType: null == fileType
          ? _value.fileType
          : fileType // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionAttachmentImplCopyWith<$Res>
    implements $TransactionAttachmentCopyWith<$Res> {
  factory _$$TransactionAttachmentImplCopyWith(
          _$TransactionAttachmentImpl value,
          $Res Function(_$TransactionAttachmentImpl) then) =
      __$$TransactionAttachmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'attachment_id') String attachmentId,
      @JsonKey(name: 'file_name') String fileName,
      @JsonKey(name: 'file_type') String fileType,
      @JsonKey(name: 'file_size') int fileSize,
      @JsonKey(name: 'file_url') String? fileUrl});
}

/// @nodoc
class __$$TransactionAttachmentImplCopyWithImpl<$Res>
    extends _$TransactionAttachmentCopyWithImpl<$Res,
        _$TransactionAttachmentImpl>
    implements _$$TransactionAttachmentImplCopyWith<$Res> {
  __$$TransactionAttachmentImplCopyWithImpl(_$TransactionAttachmentImpl _value,
      $Res Function(_$TransactionAttachmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionAttachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attachmentId = null,
    Object? fileName = null,
    Object? fileType = null,
    Object? fileSize = null,
    Object? fileUrl = freezed,
  }) {
    return _then(_$TransactionAttachmentImpl(
      attachmentId: null == attachmentId
          ? _value.attachmentId
          : attachmentId // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileType: null == fileType
          ? _value.fileType
          : fileType // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$TransactionAttachmentImpl implements _TransactionAttachment {
  const _$TransactionAttachmentImpl(
      {@JsonKey(name: 'attachment_id') required this.attachmentId,
      @JsonKey(name: 'file_name') required this.fileName,
      @JsonKey(name: 'file_type') required this.fileType,
      @JsonKey(name: 'file_size') required this.fileSize,
      @JsonKey(name: 'file_url') this.fileUrl});

  @override
  @JsonKey(name: 'attachment_id')
  final String attachmentId;
  @override
  @JsonKey(name: 'file_name')
  final String fileName;
  @override
  @JsonKey(name: 'file_type')
  final String fileType;
  @override
  @JsonKey(name: 'file_size')
  final int fileSize;
  @override
  @JsonKey(name: 'file_url')
  final String? fileUrl;

  @override
  String toString() {
    return 'TransactionAttachment(attachmentId: $attachmentId, fileName: $fileName, fileType: $fileType, fileSize: $fileSize, fileUrl: $fileUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionAttachmentImpl &&
            (identical(other.attachmentId, attachmentId) ||
                other.attachmentId == attachmentId) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileType, fileType) ||
                other.fileType == fileType) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, attachmentId, fileName, fileType, fileSize, fileUrl);

  /// Create a copy of TransactionAttachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionAttachmentImplCopyWith<_$TransactionAttachmentImpl>
      get copyWith => __$$TransactionAttachmentImplCopyWithImpl<
          _$TransactionAttachmentImpl>(this, _$identity);
}

abstract class _TransactionAttachment implements TransactionAttachment {
  const factory _TransactionAttachment(
          {@JsonKey(name: 'attachment_id') required final String attachmentId,
          @JsonKey(name: 'file_name') required final String fileName,
          @JsonKey(name: 'file_type') required final String fileType,
          @JsonKey(name: 'file_size') required final int fileSize,
          @JsonKey(name: 'file_url') final String? fileUrl}) =
      _$TransactionAttachmentImpl;

  @override
  @JsonKey(name: 'attachment_id')
  String get attachmentId;
  @override
  @JsonKey(name: 'file_name')
  String get fileName;
  @override
  @JsonKey(name: 'file_type')
  String get fileType;
  @override
  @JsonKey(name: 'file_size')
  int get fileSize;
  @override
  @JsonKey(name: 'file_url')
  String? get fileUrl;

  /// Create a copy of TransactionAttachment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionAttachmentImplCopyWith<_$TransactionAttachmentImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TransactionLine {
  @JsonKey(name: 'line_id')
  String get lineId => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_id')
  String get accountId => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_name')
  String get accountName => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_type')
  String get accountType => throw _privateConstructorUsedError;
  @JsonKey(name: 'debit')
  double get debit => throw _privateConstructorUsedError;
  @JsonKey(name: 'credit')
  double get credit => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_debit')
  bool get isDebit => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'counterparty')
  Map<String, dynamic>? get counterparty => throw _privateConstructorUsedError;
  @JsonKey(name: 'cash_location')
  Map<String, dynamic>? get cashLocation => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_location')
  String get displayLocation => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_counterparty')
  String get displayCounterparty => throw _privateConstructorUsedError;

  /// Create a copy of TransactionLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionLineCopyWith<TransactionLine> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionLineCopyWith<$Res> {
  factory $TransactionLineCopyWith(
          TransactionLine value, $Res Function(TransactionLine) then) =
      _$TransactionLineCopyWithImpl<$Res, TransactionLine>;
  @useResult
  $Res call(
      {@JsonKey(name: 'line_id') String lineId,
      @JsonKey(name: 'account_id') String accountId,
      @JsonKey(name: 'account_name') String accountName,
      @JsonKey(name: 'account_type') String accountType,
      @JsonKey(name: 'debit') double debit,
      @JsonKey(name: 'credit') double credit,
      @JsonKey(name: 'is_debit') bool isDebit,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'counterparty') Map<String, dynamic>? counterparty,
      @JsonKey(name: 'cash_location') Map<String, dynamic>? cashLocation,
      @JsonKey(name: 'display_location') String displayLocation,
      @JsonKey(name: 'display_counterparty') String displayCounterparty});
}

/// @nodoc
class _$TransactionLineCopyWithImpl<$Res, $Val extends TransactionLine>
    implements $TransactionLineCopyWith<$Res> {
  _$TransactionLineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lineId = null,
    Object? accountId = null,
    Object? accountName = null,
    Object? accountType = null,
    Object? debit = null,
    Object? credit = null,
    Object? isDebit = null,
    Object? description = freezed,
    Object? counterparty = freezed,
    Object? cashLocation = freezed,
    Object? displayLocation = null,
    Object? displayCounterparty = null,
  }) {
    return _then(_value.copyWith(
      lineId: null == lineId
          ? _value.lineId
          : lineId // ignore: cast_nullable_to_non_nullable
              as String,
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
      isDebit: null == isDebit
          ? _value.isDebit
          : isDebit // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      counterparty: freezed == counterparty
          ? _value.counterparty
          : counterparty // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      cashLocation: freezed == cashLocation
          ? _value.cashLocation
          : cashLocation // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      displayLocation: null == displayLocation
          ? _value.displayLocation
          : displayLocation // ignore: cast_nullable_to_non_nullable
              as String,
      displayCounterparty: null == displayCounterparty
          ? _value.displayCounterparty
          : displayCounterparty // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionLineImplCopyWith<$Res>
    implements $TransactionLineCopyWith<$Res> {
  factory _$$TransactionLineImplCopyWith(_$TransactionLineImpl value,
          $Res Function(_$TransactionLineImpl) then) =
      __$$TransactionLineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'line_id') String lineId,
      @JsonKey(name: 'account_id') String accountId,
      @JsonKey(name: 'account_name') String accountName,
      @JsonKey(name: 'account_type') String accountType,
      @JsonKey(name: 'debit') double debit,
      @JsonKey(name: 'credit') double credit,
      @JsonKey(name: 'is_debit') bool isDebit,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'counterparty') Map<String, dynamic>? counterparty,
      @JsonKey(name: 'cash_location') Map<String, dynamic>? cashLocation,
      @JsonKey(name: 'display_location') String displayLocation,
      @JsonKey(name: 'display_counterparty') String displayCounterparty});
}

/// @nodoc
class __$$TransactionLineImplCopyWithImpl<$Res>
    extends _$TransactionLineCopyWithImpl<$Res, _$TransactionLineImpl>
    implements _$$TransactionLineImplCopyWith<$Res> {
  __$$TransactionLineImplCopyWithImpl(
      _$TransactionLineImpl _value, $Res Function(_$TransactionLineImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lineId = null,
    Object? accountId = null,
    Object? accountName = null,
    Object? accountType = null,
    Object? debit = null,
    Object? credit = null,
    Object? isDebit = null,
    Object? description = freezed,
    Object? counterparty = freezed,
    Object? cashLocation = freezed,
    Object? displayLocation = null,
    Object? displayCounterparty = null,
  }) {
    return _then(_$TransactionLineImpl(
      lineId: null == lineId
          ? _value.lineId
          : lineId // ignore: cast_nullable_to_non_nullable
              as String,
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
      isDebit: null == isDebit
          ? _value.isDebit
          : isDebit // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      counterparty: freezed == counterparty
          ? _value._counterparty
          : counterparty // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      cashLocation: freezed == cashLocation
          ? _value._cashLocation
          : cashLocation // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      displayLocation: null == displayLocation
          ? _value.displayLocation
          : displayLocation // ignore: cast_nullable_to_non_nullable
              as String,
      displayCounterparty: null == displayCounterparty
          ? _value.displayCounterparty
          : displayCounterparty // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TransactionLineImpl implements _TransactionLine {
  const _$TransactionLineImpl(
      {@JsonKey(name: 'line_id') required this.lineId,
      @JsonKey(name: 'account_id') required this.accountId,
      @JsonKey(name: 'account_name') required this.accountName,
      @JsonKey(name: 'account_type') required this.accountType,
      @JsonKey(name: 'debit') required this.debit,
      @JsonKey(name: 'credit') required this.credit,
      @JsonKey(name: 'is_debit') required this.isDebit,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'counterparty') final Map<String, dynamic>? counterparty,
      @JsonKey(name: 'cash_location') final Map<String, dynamic>? cashLocation,
      @JsonKey(name: 'display_location') required this.displayLocation,
      @JsonKey(name: 'display_counterparty') required this.displayCounterparty})
      : _counterparty = counterparty,
        _cashLocation = cashLocation;

  @override
  @JsonKey(name: 'line_id')
  final String lineId;
  @override
  @JsonKey(name: 'account_id')
  final String accountId;
  @override
  @JsonKey(name: 'account_name')
  final String accountName;
  @override
  @JsonKey(name: 'account_type')
  final String accountType;
  @override
  @JsonKey(name: 'debit')
  final double debit;
  @override
  @JsonKey(name: 'credit')
  final double credit;
  @override
  @JsonKey(name: 'is_debit')
  final bool isDebit;
  @override
  @JsonKey(name: 'description')
  final String? description;
  final Map<String, dynamic>? _counterparty;
  @override
  @JsonKey(name: 'counterparty')
  Map<String, dynamic>? get counterparty {
    final value = _counterparty;
    if (value == null) return null;
    if (_counterparty is EqualUnmodifiableMapView) return _counterparty;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _cashLocation;
  @override
  @JsonKey(name: 'cash_location')
  Map<String, dynamic>? get cashLocation {
    final value = _cashLocation;
    if (value == null) return null;
    if (_cashLocation is EqualUnmodifiableMapView) return _cashLocation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'display_location')
  final String displayLocation;
  @override
  @JsonKey(name: 'display_counterparty')
  final String displayCounterparty;

  @override
  String toString() {
    return 'TransactionLine(lineId: $lineId, accountId: $accountId, accountName: $accountName, accountType: $accountType, debit: $debit, credit: $credit, isDebit: $isDebit, description: $description, counterparty: $counterparty, cashLocation: $cashLocation, displayLocation: $displayLocation, displayCounterparty: $displayCounterparty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionLineImpl &&
            (identical(other.lineId, lineId) || other.lineId == lineId) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.accountType, accountType) ||
                other.accountType == accountType) &&
            (identical(other.debit, debit) || other.debit == debit) &&
            (identical(other.credit, credit) || other.credit == credit) &&
            (identical(other.isDebit, isDebit) || other.isDebit == isDebit) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._counterparty, _counterparty) &&
            const DeepCollectionEquality()
                .equals(other._cashLocation, _cashLocation) &&
            (identical(other.displayLocation, displayLocation) ||
                other.displayLocation == displayLocation) &&
            (identical(other.displayCounterparty, displayCounterparty) ||
                other.displayCounterparty == displayCounterparty));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      lineId,
      accountId,
      accountName,
      accountType,
      debit,
      credit,
      isDebit,
      description,
      const DeepCollectionEquality().hash(_counterparty),
      const DeepCollectionEquality().hash(_cashLocation),
      displayLocation,
      displayCounterparty);

  /// Create a copy of TransactionLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionLineImplCopyWith<_$TransactionLineImpl> get copyWith =>
      __$$TransactionLineImplCopyWithImpl<_$TransactionLineImpl>(
          this, _$identity);
}

abstract class _TransactionLine implements TransactionLine {
  const factory _TransactionLine(
      {@JsonKey(name: 'line_id') required final String lineId,
      @JsonKey(name: 'account_id') required final String accountId,
      @JsonKey(name: 'account_name') required final String accountName,
      @JsonKey(name: 'account_type') required final String accountType,
      @JsonKey(name: 'debit') required final double debit,
      @JsonKey(name: 'credit') required final double credit,
      @JsonKey(name: 'is_debit') required final bool isDebit,
      @JsonKey(name: 'description') final String? description,
      @JsonKey(name: 'counterparty') final Map<String, dynamic>? counterparty,
      @JsonKey(name: 'cash_location') final Map<String, dynamic>? cashLocation,
      @JsonKey(name: 'display_location') required final String displayLocation,
      @JsonKey(name: 'display_counterparty')
      required final String displayCounterparty}) = _$TransactionLineImpl;

  @override
  @JsonKey(name: 'line_id')
  String get lineId;
  @override
  @JsonKey(name: 'account_id')
  String get accountId;
  @override
  @JsonKey(name: 'account_name')
  String get accountName;
  @override
  @JsonKey(name: 'account_type')
  String get accountType;
  @override
  @JsonKey(name: 'debit')
  double get debit;
  @override
  @JsonKey(name: 'credit')
  double get credit;
  @override
  @JsonKey(name: 'is_debit')
  bool get isDebit;
  @override
  @JsonKey(name: 'description')
  String? get description;
  @override
  @JsonKey(name: 'counterparty')
  Map<String, dynamic>? get counterparty;
  @override
  @JsonKey(name: 'cash_location')
  Map<String, dynamic>? get cashLocation;
  @override
  @JsonKey(name: 'display_location')
  String get displayLocation;
  @override
  @JsonKey(name: 'display_counterparty')
  String get displayCounterparty;

  /// Create a copy of TransactionLine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionLineImplCopyWith<_$TransactionLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransactionFilter _$TransactionFilterFromJson(Map<String, dynamic> json) {
  return _TransactionFilter.fromJson(json);
}

/// @nodoc
mixin _$TransactionFilter {
  TransactionScope get scope =>
      throw _privateConstructorUsedError; // Default to store view
  DateTime? get dateFrom => throw _privateConstructorUsedError;
  DateTime? get dateTo => throw _privateConstructorUsedError;
  String? get accountId => throw _privateConstructorUsedError;
  List<String>? get accountIds =>
      throw _privateConstructorUsedError; // Support multiple accounts
  String? get cashLocationId => throw _privateConstructorUsedError;
  String? get counterpartyId => throw _privateConstructorUsedError;
  String? get journalType => throw _privateConstructorUsedError;
  String? get createdBy =>
      throw _privateConstructorUsedError; // Filter by who created the transaction
  String? get searchQuery => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get offset => throw _privateConstructorUsedError;

  /// Serializes this TransactionFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionFilterCopyWith<TransactionFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionFilterCopyWith<$Res> {
  factory $TransactionFilterCopyWith(
          TransactionFilter value, $Res Function(TransactionFilter) then) =
      _$TransactionFilterCopyWithImpl<$Res, TransactionFilter>;
  @useResult
  $Res call(
      {TransactionScope scope,
      DateTime? dateFrom,
      DateTime? dateTo,
      String? accountId,
      List<String>? accountIds,
      String? cashLocationId,
      String? counterpartyId,
      String? journalType,
      String? createdBy,
      String? searchQuery,
      int limit,
      int offset});
}

/// @nodoc
class _$TransactionFilterCopyWithImpl<$Res, $Val extends TransactionFilter>
    implements $TransactionFilterCopyWith<$Res> {
  _$TransactionFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scope = null,
    Object? dateFrom = freezed,
    Object? dateTo = freezed,
    Object? accountId = freezed,
    Object? accountIds = freezed,
    Object? cashLocationId = freezed,
    Object? counterpartyId = freezed,
    Object? journalType = freezed,
    Object? createdBy = freezed,
    Object? searchQuery = freezed,
    Object? limit = null,
    Object? offset = null,
  }) {
    return _then(_value.copyWith(
      scope: null == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as TransactionScope,
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
      journalType: freezed == journalType
          ? _value.journalType
          : journalType // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionFilterImplCopyWith<$Res>
    implements $TransactionFilterCopyWith<$Res> {
  factory _$$TransactionFilterImplCopyWith(_$TransactionFilterImpl value,
          $Res Function(_$TransactionFilterImpl) then) =
      __$$TransactionFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {TransactionScope scope,
      DateTime? dateFrom,
      DateTime? dateTo,
      String? accountId,
      List<String>? accountIds,
      String? cashLocationId,
      String? counterpartyId,
      String? journalType,
      String? createdBy,
      String? searchQuery,
      int limit,
      int offset});
}

/// @nodoc
class __$$TransactionFilterImplCopyWithImpl<$Res>
    extends _$TransactionFilterCopyWithImpl<$Res, _$TransactionFilterImpl>
    implements _$$TransactionFilterImplCopyWith<$Res> {
  __$$TransactionFilterImplCopyWithImpl(_$TransactionFilterImpl _value,
      $Res Function(_$TransactionFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scope = null,
    Object? dateFrom = freezed,
    Object? dateTo = freezed,
    Object? accountId = freezed,
    Object? accountIds = freezed,
    Object? cashLocationId = freezed,
    Object? counterpartyId = freezed,
    Object? journalType = freezed,
    Object? createdBy = freezed,
    Object? searchQuery = freezed,
    Object? limit = null,
    Object? offset = null,
  }) {
    return _then(_$TransactionFilterImpl(
      scope: null == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as TransactionScope,
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
      journalType: freezed == journalType
          ? _value.journalType
          : journalType // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionFilterImpl implements _TransactionFilter {
  const _$TransactionFilterImpl(
      {this.scope = TransactionScope.store,
      this.dateFrom,
      this.dateTo,
      this.accountId,
      final List<String>? accountIds,
      this.cashLocationId,
      this.counterpartyId,
      this.journalType,
      this.createdBy,
      this.searchQuery,
      this.limit = 50,
      this.offset = 0})
      : _accountIds = accountIds;

  factory _$TransactionFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionFilterImplFromJson(json);

  @override
  @JsonKey()
  final TransactionScope scope;
// Default to store view
  @override
  final DateTime? dateFrom;
  @override
  final DateTime? dateTo;
  @override
  final String? accountId;
  final List<String>? _accountIds;
  @override
  List<String>? get accountIds {
    final value = _accountIds;
    if (value == null) return null;
    if (_accountIds is EqualUnmodifiableListView) return _accountIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Support multiple accounts
  @override
  final String? cashLocationId;
  @override
  final String? counterpartyId;
  @override
  final String? journalType;
  @override
  final String? createdBy;
// Filter by who created the transaction
  @override
  final String? searchQuery;
  @override
  @JsonKey()
  final int limit;
  @override
  @JsonKey()
  final int offset;

  @override
  String toString() {
    return 'TransactionFilter(scope: $scope, dateFrom: $dateFrom, dateTo: $dateTo, accountId: $accountId, accountIds: $accountIds, cashLocationId: $cashLocationId, counterpartyId: $counterpartyId, journalType: $journalType, createdBy: $createdBy, searchQuery: $searchQuery, limit: $limit, offset: $offset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionFilterImpl &&
            (identical(other.scope, scope) || other.scope == scope) &&
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
            (identical(other.journalType, journalType) ||
                other.journalType == journalType) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      scope,
      dateFrom,
      dateTo,
      accountId,
      const DeepCollectionEquality().hash(_accountIds),
      cashLocationId,
      counterpartyId,
      journalType,
      createdBy,
      searchQuery,
      limit,
      offset);

  /// Create a copy of TransactionFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionFilterImplCopyWith<_$TransactionFilterImpl> get copyWith =>
      __$$TransactionFilterImplCopyWithImpl<_$TransactionFilterImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionFilterImplToJson(
      this,
    );
  }
}

abstract class _TransactionFilter implements TransactionFilter {
  const factory _TransactionFilter(
      {final TransactionScope scope,
      final DateTime? dateFrom,
      final DateTime? dateTo,
      final String? accountId,
      final List<String>? accountIds,
      final String? cashLocationId,
      final String? counterpartyId,
      final String? journalType,
      final String? createdBy,
      final String? searchQuery,
      final int limit,
      final int offset}) = _$TransactionFilterImpl;

  factory _TransactionFilter.fromJson(Map<String, dynamic> json) =
      _$TransactionFilterImpl.fromJson;

  @override
  TransactionScope get scope; // Default to store view
  @override
  DateTime? get dateFrom;
  @override
  DateTime? get dateTo;
  @override
  String? get accountId;
  @override
  List<String>? get accountIds; // Support multiple accounts
  @override
  String? get cashLocationId;
  @override
  String? get counterpartyId;
  @override
  String? get journalType;
  @override
  String? get createdBy; // Filter by who created the transaction
  @override
  String? get searchQuery;
  @override
  int get limit;
  @override
  int get offset;

  /// Create a copy of TransactionFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionFilterImplCopyWith<_$TransactionFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransactionSummary _$TransactionSummaryFromJson(Map<String, dynamic> json) {
  return _TransactionSummary.fromJson(json);
}

/// @nodoc
mixin _$TransactionSummary {
  double get totalIncome => throw _privateConstructorUsedError;
  double get totalExpenses => throw _privateConstructorUsedError;
  double get netAmount => throw _privateConstructorUsedError;
  int get transactionCount => throw _privateConstructorUsedError;
  double get todayTotal => throw _privateConstructorUsedError;
  int get todayCount => throw _privateConstructorUsedError;

  /// Serializes this TransactionSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionSummaryCopyWith<TransactionSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionSummaryCopyWith<$Res> {
  factory $TransactionSummaryCopyWith(
          TransactionSummary value, $Res Function(TransactionSummary) then) =
      _$TransactionSummaryCopyWithImpl<$Res, TransactionSummary>;
  @useResult
  $Res call(
      {double totalIncome,
      double totalExpenses,
      double netAmount,
      int transactionCount,
      double todayTotal,
      int todayCount});
}

/// @nodoc
class _$TransactionSummaryCopyWithImpl<$Res, $Val extends TransactionSummary>
    implements $TransactionSummaryCopyWith<$Res> {
  _$TransactionSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncome = null,
    Object? totalExpenses = null,
    Object? netAmount = null,
    Object? transactionCount = null,
    Object? todayTotal = null,
    Object? todayCount = null,
  }) {
    return _then(_value.copyWith(
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpenses: null == totalExpenses
          ? _value.totalExpenses
          : totalExpenses // ignore: cast_nullable_to_non_nullable
              as double,
      netAmount: null == netAmount
          ? _value.netAmount
          : netAmount // ignore: cast_nullable_to_non_nullable
              as double,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      todayTotal: null == todayTotal
          ? _value.todayTotal
          : todayTotal // ignore: cast_nullable_to_non_nullable
              as double,
      todayCount: null == todayCount
          ? _value.todayCount
          : todayCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionSummaryImplCopyWith<$Res>
    implements $TransactionSummaryCopyWith<$Res> {
  factory _$$TransactionSummaryImplCopyWith(_$TransactionSummaryImpl value,
          $Res Function(_$TransactionSummaryImpl) then) =
      __$$TransactionSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double totalIncome,
      double totalExpenses,
      double netAmount,
      int transactionCount,
      double todayTotal,
      int todayCount});
}

/// @nodoc
class __$$TransactionSummaryImplCopyWithImpl<$Res>
    extends _$TransactionSummaryCopyWithImpl<$Res, _$TransactionSummaryImpl>
    implements _$$TransactionSummaryImplCopyWith<$Res> {
  __$$TransactionSummaryImplCopyWithImpl(_$TransactionSummaryImpl _value,
      $Res Function(_$TransactionSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncome = null,
    Object? totalExpenses = null,
    Object? netAmount = null,
    Object? transactionCount = null,
    Object? todayTotal = null,
    Object? todayCount = null,
  }) {
    return _then(_$TransactionSummaryImpl(
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpenses: null == totalExpenses
          ? _value.totalExpenses
          : totalExpenses // ignore: cast_nullable_to_non_nullable
              as double,
      netAmount: null == netAmount
          ? _value.netAmount
          : netAmount // ignore: cast_nullable_to_non_nullable
              as double,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      todayTotal: null == todayTotal
          ? _value.todayTotal
          : todayTotal // ignore: cast_nullable_to_non_nullable
              as double,
      todayCount: null == todayCount
          ? _value.todayCount
          : todayCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionSummaryImpl implements _TransactionSummary {
  const _$TransactionSummaryImpl(
      {this.totalIncome = 0.0,
      this.totalExpenses = 0.0,
      this.netAmount = 0.0,
      this.transactionCount = 0,
      this.todayTotal = 0.0,
      this.todayCount = 0});

  factory _$TransactionSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionSummaryImplFromJson(json);

  @override
  @JsonKey()
  final double totalIncome;
  @override
  @JsonKey()
  final double totalExpenses;
  @override
  @JsonKey()
  final double netAmount;
  @override
  @JsonKey()
  final int transactionCount;
  @override
  @JsonKey()
  final double todayTotal;
  @override
  @JsonKey()
  final int todayCount;

  @override
  String toString() {
    return 'TransactionSummary(totalIncome: $totalIncome, totalExpenses: $totalExpenses, netAmount: $netAmount, transactionCount: $transactionCount, todayTotal: $todayTotal, todayCount: $todayCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionSummaryImpl &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpenses, totalExpenses) ||
                other.totalExpenses == totalExpenses) &&
            (identical(other.netAmount, netAmount) ||
                other.netAmount == netAmount) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            (identical(other.todayTotal, todayTotal) ||
                other.todayTotal == todayTotal) &&
            (identical(other.todayCount, todayCount) ||
                other.todayCount == todayCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalIncome, totalExpenses,
      netAmount, transactionCount, todayTotal, todayCount);

  /// Create a copy of TransactionSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionSummaryImplCopyWith<_$TransactionSummaryImpl> get copyWith =>
      __$$TransactionSummaryImplCopyWithImpl<_$TransactionSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionSummaryImplToJson(
      this,
    );
  }
}

abstract class _TransactionSummary implements TransactionSummary {
  const factory _TransactionSummary(
      {final double totalIncome,
      final double totalExpenses,
      final double netAmount,
      final int transactionCount,
      final double todayTotal,
      final int todayCount}) = _$TransactionSummaryImpl;

  factory _TransactionSummary.fromJson(Map<String, dynamic> json) =
      _$TransactionSummaryImpl.fromJson;

  @override
  double get totalIncome;
  @override
  double get totalExpenses;
  @override
  double get netAmount;
  @override
  int get transactionCount;
  @override
  double get todayTotal;
  @override
  int get todayCount;

  /// Create a copy of TransactionSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionSummaryImplCopyWith<_$TransactionSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
