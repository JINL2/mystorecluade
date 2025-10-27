// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TransactionModel {
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
  List<TransactionLineModel> get lines => throw _privateConstructorUsedError;
  @JsonKey(name: 'attachments')
  List<TransactionAttachmentModel> get attachments =>
      throw _privateConstructorUsedError;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionModelCopyWith<TransactionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionModelCopyWith<$Res> {
  factory $TransactionModelCopyWith(
          TransactionModel value, $Res Function(TransactionModel) then) =
      _$TransactionModelCopyWithImpl<$Res, TransactionModel>;
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
      @JsonKey(name: 'lines') List<TransactionLineModel> lines,
      @JsonKey(name: 'attachments')
      List<TransactionAttachmentModel> attachments});
}

/// @nodoc
class _$TransactionModelCopyWithImpl<$Res, $Val extends TransactionModel>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionModel
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
              as List<TransactionLineModel>,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<TransactionAttachmentModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionModelImplCopyWith<$Res>
    implements $TransactionModelCopyWith<$Res> {
  factory _$$TransactionModelImplCopyWith(_$TransactionModelImpl value,
          $Res Function(_$TransactionModelImpl) then) =
      __$$TransactionModelImplCopyWithImpl<$Res>;
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
      @JsonKey(name: 'lines') List<TransactionLineModel> lines,
      @JsonKey(name: 'attachments')
      List<TransactionAttachmentModel> attachments});
}

/// @nodoc
class __$$TransactionModelImplCopyWithImpl<$Res>
    extends _$TransactionModelCopyWithImpl<$Res, _$TransactionModelImpl>
    implements _$$TransactionModelImplCopyWith<$Res> {
  __$$TransactionModelImplCopyWithImpl(_$TransactionModelImpl _value,
      $Res Function(_$TransactionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionModel
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
    return _then(_$TransactionModelImpl(
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
              as List<TransactionLineModel>,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<TransactionAttachmentModel>,
    ));
  }
}

/// @nodoc

class _$TransactionModelImpl implements _TransactionModel {
  const _$TransactionModelImpl(
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
      @JsonKey(name: 'lines') required final List<TransactionLineModel> lines,
      @JsonKey(name: 'attachments')
      required final List<TransactionAttachmentModel> attachments})
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
  final List<TransactionLineModel> _lines;
  @override
  @JsonKey(name: 'lines')
  List<TransactionLineModel> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  final List<TransactionAttachmentModel> _attachments;
  @override
  @JsonKey(name: 'attachments')
  List<TransactionAttachmentModel> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  String toString() {
    return 'TransactionModel(journalId: $journalId, journalNumber: $journalNumber, entryDate: $entryDate, createdAt: $createdAt, description: $description, journalType: $journalType, isDraft: $isDraft, storeId: $storeId, storeName: $storeName, storeCode: $storeCode, createdBy: $createdBy, createdByName: $createdByName, currencyCode: $currencyCode, currencySymbol: $currencySymbol, totalDebit: $totalDebit, totalCredit: $totalCredit, totalAmount: $totalAmount, lines: $lines, attachments: $attachments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionModelImpl &&
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

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionModelImplCopyWith<_$TransactionModelImpl> get copyWith =>
      __$$TransactionModelImplCopyWithImpl<_$TransactionModelImpl>(
          this, _$identity);
}

abstract class _TransactionModel implements TransactionModel {
  const factory _TransactionModel(
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
      @JsonKey(name: 'lines') required final List<TransactionLineModel> lines,
      @JsonKey(name: 'attachments')
      required final List<TransactionAttachmentModel>
          attachments}) = _$TransactionModelImpl;

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
  List<TransactionLineModel> get lines;
  @override
  @JsonKey(name: 'attachments')
  List<TransactionAttachmentModel> get attachments;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionModelImplCopyWith<_$TransactionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TransactionLineModel {
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

  /// Create a copy of TransactionLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionLineModelCopyWith<TransactionLineModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionLineModelCopyWith<$Res> {
  factory $TransactionLineModelCopyWith(TransactionLineModel value,
          $Res Function(TransactionLineModel) then) =
      _$TransactionLineModelCopyWithImpl<$Res, TransactionLineModel>;
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
class _$TransactionLineModelCopyWithImpl<$Res,
        $Val extends TransactionLineModel>
    implements $TransactionLineModelCopyWith<$Res> {
  _$TransactionLineModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionLineModel
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
abstract class _$$TransactionLineModelImplCopyWith<$Res>
    implements $TransactionLineModelCopyWith<$Res> {
  factory _$$TransactionLineModelImplCopyWith(_$TransactionLineModelImpl value,
          $Res Function(_$TransactionLineModelImpl) then) =
      __$$TransactionLineModelImplCopyWithImpl<$Res>;
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
class __$$TransactionLineModelImplCopyWithImpl<$Res>
    extends _$TransactionLineModelCopyWithImpl<$Res, _$TransactionLineModelImpl>
    implements _$$TransactionLineModelImplCopyWith<$Res> {
  __$$TransactionLineModelImplCopyWithImpl(_$TransactionLineModelImpl _value,
      $Res Function(_$TransactionLineModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionLineModel
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
    return _then(_$TransactionLineModelImpl(
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

class _$TransactionLineModelImpl implements _TransactionLineModel {
  const _$TransactionLineModelImpl(
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
    return 'TransactionLineModel(lineId: $lineId, accountId: $accountId, accountName: $accountName, accountType: $accountType, debit: $debit, credit: $credit, isDebit: $isDebit, description: $description, counterparty: $counterparty, cashLocation: $cashLocation, displayLocation: $displayLocation, displayCounterparty: $displayCounterparty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionLineModelImpl &&
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

  /// Create a copy of TransactionLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionLineModelImplCopyWith<_$TransactionLineModelImpl>
      get copyWith =>
          __$$TransactionLineModelImplCopyWithImpl<_$TransactionLineModelImpl>(
              this, _$identity);
}

abstract class _TransactionLineModel implements TransactionLineModel {
  const factory _TransactionLineModel(
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
      required final String displayCounterparty}) = _$TransactionLineModelImpl;

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

  /// Create a copy of TransactionLineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionLineModelImplCopyWith<_$TransactionLineModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TransactionAttachmentModel {
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

  /// Create a copy of TransactionAttachmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionAttachmentModelCopyWith<TransactionAttachmentModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionAttachmentModelCopyWith<$Res> {
  factory $TransactionAttachmentModelCopyWith(TransactionAttachmentModel value,
          $Res Function(TransactionAttachmentModel) then) =
      _$TransactionAttachmentModelCopyWithImpl<$Res,
          TransactionAttachmentModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'attachment_id') String attachmentId,
      @JsonKey(name: 'file_name') String fileName,
      @JsonKey(name: 'file_type') String fileType,
      @JsonKey(name: 'file_size') int fileSize,
      @JsonKey(name: 'file_url') String? fileUrl});
}

/// @nodoc
class _$TransactionAttachmentModelCopyWithImpl<$Res,
        $Val extends TransactionAttachmentModel>
    implements $TransactionAttachmentModelCopyWith<$Res> {
  _$TransactionAttachmentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionAttachmentModel
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
abstract class _$$TransactionAttachmentModelImplCopyWith<$Res>
    implements $TransactionAttachmentModelCopyWith<$Res> {
  factory _$$TransactionAttachmentModelImplCopyWith(
          _$TransactionAttachmentModelImpl value,
          $Res Function(_$TransactionAttachmentModelImpl) then) =
      __$$TransactionAttachmentModelImplCopyWithImpl<$Res>;
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
class __$$TransactionAttachmentModelImplCopyWithImpl<$Res>
    extends _$TransactionAttachmentModelCopyWithImpl<$Res,
        _$TransactionAttachmentModelImpl>
    implements _$$TransactionAttachmentModelImplCopyWith<$Res> {
  __$$TransactionAttachmentModelImplCopyWithImpl(
      _$TransactionAttachmentModelImpl _value,
      $Res Function(_$TransactionAttachmentModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionAttachmentModel
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
    return _then(_$TransactionAttachmentModelImpl(
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

class _$TransactionAttachmentModelImpl implements _TransactionAttachmentModel {
  const _$TransactionAttachmentModelImpl(
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
    return 'TransactionAttachmentModel(attachmentId: $attachmentId, fileName: $fileName, fileType: $fileType, fileSize: $fileSize, fileUrl: $fileUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionAttachmentModelImpl &&
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

  /// Create a copy of TransactionAttachmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionAttachmentModelImplCopyWith<_$TransactionAttachmentModelImpl>
      get copyWith => __$$TransactionAttachmentModelImplCopyWithImpl<
          _$TransactionAttachmentModelImpl>(this, _$identity);
}

abstract class _TransactionAttachmentModel
    implements TransactionAttachmentModel {
  const factory _TransactionAttachmentModel(
          {@JsonKey(name: 'attachment_id') required final String attachmentId,
          @JsonKey(name: 'file_name') required final String fileName,
          @JsonKey(name: 'file_type') required final String fileType,
          @JsonKey(name: 'file_size') required final int fileSize,
          @JsonKey(name: 'file_url') final String? fileUrl}) =
      _$TransactionAttachmentModelImpl;

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

  /// Create a copy of TransactionAttachmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionAttachmentModelImplCopyWith<_$TransactionAttachmentModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
