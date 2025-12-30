// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'letter_of_credit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LCRequiredDocument {
  String get code => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  int get copiesOriginal => throw _privateConstructorUsedError;
  int get copiesCopy => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Create a copy of LCRequiredDocument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LCRequiredDocumentCopyWith<LCRequiredDocument> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LCRequiredDocumentCopyWith<$Res> {
  factory $LCRequiredDocumentCopyWith(
          LCRequiredDocument value, $Res Function(LCRequiredDocument) then) =
      _$LCRequiredDocumentCopyWithImpl<$Res, LCRequiredDocument>;
  @useResult
  $Res call(
      {String code,
      String? name,
      int copiesOriginal,
      int copiesCopy,
      String? notes});
}

/// @nodoc
class _$LCRequiredDocumentCopyWithImpl<$Res, $Val extends LCRequiredDocument>
    implements $LCRequiredDocumentCopyWith<$Res> {
  _$LCRequiredDocumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LCRequiredDocument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? name = freezed,
    Object? copiesOriginal = null,
    Object? copiesCopy = null,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      copiesOriginal: null == copiesOriginal
          ? _value.copiesOriginal
          : copiesOriginal // ignore: cast_nullable_to_non_nullable
              as int,
      copiesCopy: null == copiesCopy
          ? _value.copiesCopy
          : copiesCopy // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LCRequiredDocumentImplCopyWith<$Res>
    implements $LCRequiredDocumentCopyWith<$Res> {
  factory _$$LCRequiredDocumentImplCopyWith(_$LCRequiredDocumentImpl value,
          $Res Function(_$LCRequiredDocumentImpl) then) =
      __$$LCRequiredDocumentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String code,
      String? name,
      int copiesOriginal,
      int copiesCopy,
      String? notes});
}

/// @nodoc
class __$$LCRequiredDocumentImplCopyWithImpl<$Res>
    extends _$LCRequiredDocumentCopyWithImpl<$Res, _$LCRequiredDocumentImpl>
    implements _$$LCRequiredDocumentImplCopyWith<$Res> {
  __$$LCRequiredDocumentImplCopyWithImpl(_$LCRequiredDocumentImpl _value,
      $Res Function(_$LCRequiredDocumentImpl) _then)
      : super(_value, _then);

  /// Create a copy of LCRequiredDocument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? name = freezed,
    Object? copiesOriginal = null,
    Object? copiesCopy = null,
    Object? notes = freezed,
  }) {
    return _then(_$LCRequiredDocumentImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      copiesOriginal: null == copiesOriginal
          ? _value.copiesOriginal
          : copiesOriginal // ignore: cast_nullable_to_non_nullable
              as int,
      copiesCopy: null == copiesCopy
          ? _value.copiesCopy
          : copiesCopy // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$LCRequiredDocumentImpl implements _LCRequiredDocument {
  const _$LCRequiredDocumentImpl(
      {required this.code,
      this.name,
      this.copiesOriginal = 1,
      this.copiesCopy = 1,
      this.notes});

  @override
  final String code;
  @override
  final String? name;
  @override
  @JsonKey()
  final int copiesOriginal;
  @override
  @JsonKey()
  final int copiesCopy;
  @override
  final String? notes;

  @override
  String toString() {
    return 'LCRequiredDocument(code: $code, name: $name, copiesOriginal: $copiesOriginal, copiesCopy: $copiesCopy, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LCRequiredDocumentImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.copiesOriginal, copiesOriginal) ||
                other.copiesOriginal == copiesOriginal) &&
            (identical(other.copiesCopy, copiesCopy) ||
                other.copiesCopy == copiesCopy) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, code, name, copiesOriginal, copiesCopy, notes);

  /// Create a copy of LCRequiredDocument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LCRequiredDocumentImplCopyWith<_$LCRequiredDocumentImpl> get copyWith =>
      __$$LCRequiredDocumentImplCopyWithImpl<_$LCRequiredDocumentImpl>(
          this, _$identity);
}

abstract class _LCRequiredDocument implements LCRequiredDocument {
  const factory _LCRequiredDocument(
      {required final String code,
      final String? name,
      final int copiesOriginal,
      final int copiesCopy,
      final String? notes}) = _$LCRequiredDocumentImpl;

  @override
  String get code;
  @override
  String? get name;
  @override
  int get copiesOriginal;
  @override
  int get copiesCopy;
  @override
  String? get notes;

  /// Create a copy of LCRequiredDocument
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LCRequiredDocumentImplCopyWith<_$LCRequiredDocumentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LCAmendment {
  String get amendmentId => throw _privateConstructorUsedError;
  String get lcId => throw _privateConstructorUsedError;
  int get amendmentNumber => throw _privateConstructorUsedError;
  DateTime? get amendmentDateUtc => throw _privateConstructorUsedError;
  String get changesSummary => throw _privateConstructorUsedError;
  Map<String, dynamic>? get changesDetail => throw _privateConstructorUsedError;
  double? get amendmentFee => throw _privateConstructorUsedError;
  String? get amendmentFeeCurrencyId => throw _privateConstructorUsedError;
  LCAmendmentStatus get status => throw _privateConstructorUsedError;
  String? get requestedBy => throw _privateConstructorUsedError;
  DateTime? get requestedAtUtc => throw _privateConstructorUsedError;
  DateTime? get processedAtUtc => throw _privateConstructorUsedError;

  /// Create a copy of LCAmendment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LCAmendmentCopyWith<LCAmendment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LCAmendmentCopyWith<$Res> {
  factory $LCAmendmentCopyWith(
          LCAmendment value, $Res Function(LCAmendment) then) =
      _$LCAmendmentCopyWithImpl<$Res, LCAmendment>;
  @useResult
  $Res call(
      {String amendmentId,
      String lcId,
      int amendmentNumber,
      DateTime? amendmentDateUtc,
      String changesSummary,
      Map<String, dynamic>? changesDetail,
      double? amendmentFee,
      String? amendmentFeeCurrencyId,
      LCAmendmentStatus status,
      String? requestedBy,
      DateTime? requestedAtUtc,
      DateTime? processedAtUtc});
}

/// @nodoc
class _$LCAmendmentCopyWithImpl<$Res, $Val extends LCAmendment>
    implements $LCAmendmentCopyWith<$Res> {
  _$LCAmendmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LCAmendment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amendmentId = null,
    Object? lcId = null,
    Object? amendmentNumber = null,
    Object? amendmentDateUtc = freezed,
    Object? changesSummary = null,
    Object? changesDetail = freezed,
    Object? amendmentFee = freezed,
    Object? amendmentFeeCurrencyId = freezed,
    Object? status = null,
    Object? requestedBy = freezed,
    Object? requestedAtUtc = freezed,
    Object? processedAtUtc = freezed,
  }) {
    return _then(_value.copyWith(
      amendmentId: null == amendmentId
          ? _value.amendmentId
          : amendmentId // ignore: cast_nullable_to_non_nullable
              as String,
      lcId: null == lcId
          ? _value.lcId
          : lcId // ignore: cast_nullable_to_non_nullable
              as String,
      amendmentNumber: null == amendmentNumber
          ? _value.amendmentNumber
          : amendmentNumber // ignore: cast_nullable_to_non_nullable
              as int,
      amendmentDateUtc: freezed == amendmentDateUtc
          ? _value.amendmentDateUtc
          : amendmentDateUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      changesSummary: null == changesSummary
          ? _value.changesSummary
          : changesSummary // ignore: cast_nullable_to_non_nullable
              as String,
      changesDetail: freezed == changesDetail
          ? _value.changesDetail
          : changesDetail // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      amendmentFee: freezed == amendmentFee
          ? _value.amendmentFee
          : amendmentFee // ignore: cast_nullable_to_non_nullable
              as double?,
      amendmentFeeCurrencyId: freezed == amendmentFeeCurrencyId
          ? _value.amendmentFeeCurrencyId
          : amendmentFeeCurrencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LCAmendmentStatus,
      requestedBy: freezed == requestedBy
          ? _value.requestedBy
          : requestedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      requestedAtUtc: freezed == requestedAtUtc
          ? _value.requestedAtUtc
          : requestedAtUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      processedAtUtc: freezed == processedAtUtc
          ? _value.processedAtUtc
          : processedAtUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LCAmendmentImplCopyWith<$Res>
    implements $LCAmendmentCopyWith<$Res> {
  factory _$$LCAmendmentImplCopyWith(
          _$LCAmendmentImpl value, $Res Function(_$LCAmendmentImpl) then) =
      __$$LCAmendmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String amendmentId,
      String lcId,
      int amendmentNumber,
      DateTime? amendmentDateUtc,
      String changesSummary,
      Map<String, dynamic>? changesDetail,
      double? amendmentFee,
      String? amendmentFeeCurrencyId,
      LCAmendmentStatus status,
      String? requestedBy,
      DateTime? requestedAtUtc,
      DateTime? processedAtUtc});
}

/// @nodoc
class __$$LCAmendmentImplCopyWithImpl<$Res>
    extends _$LCAmendmentCopyWithImpl<$Res, _$LCAmendmentImpl>
    implements _$$LCAmendmentImplCopyWith<$Res> {
  __$$LCAmendmentImplCopyWithImpl(
      _$LCAmendmentImpl _value, $Res Function(_$LCAmendmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of LCAmendment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amendmentId = null,
    Object? lcId = null,
    Object? amendmentNumber = null,
    Object? amendmentDateUtc = freezed,
    Object? changesSummary = null,
    Object? changesDetail = freezed,
    Object? amendmentFee = freezed,
    Object? amendmentFeeCurrencyId = freezed,
    Object? status = null,
    Object? requestedBy = freezed,
    Object? requestedAtUtc = freezed,
    Object? processedAtUtc = freezed,
  }) {
    return _then(_$LCAmendmentImpl(
      amendmentId: null == amendmentId
          ? _value.amendmentId
          : amendmentId // ignore: cast_nullable_to_non_nullable
              as String,
      lcId: null == lcId
          ? _value.lcId
          : lcId // ignore: cast_nullable_to_non_nullable
              as String,
      amendmentNumber: null == amendmentNumber
          ? _value.amendmentNumber
          : amendmentNumber // ignore: cast_nullable_to_non_nullable
              as int,
      amendmentDateUtc: freezed == amendmentDateUtc
          ? _value.amendmentDateUtc
          : amendmentDateUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      changesSummary: null == changesSummary
          ? _value.changesSummary
          : changesSummary // ignore: cast_nullable_to_non_nullable
              as String,
      changesDetail: freezed == changesDetail
          ? _value._changesDetail
          : changesDetail // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      amendmentFee: freezed == amendmentFee
          ? _value.amendmentFee
          : amendmentFee // ignore: cast_nullable_to_non_nullable
              as double?,
      amendmentFeeCurrencyId: freezed == amendmentFeeCurrencyId
          ? _value.amendmentFeeCurrencyId
          : amendmentFeeCurrencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LCAmendmentStatus,
      requestedBy: freezed == requestedBy
          ? _value.requestedBy
          : requestedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      requestedAtUtc: freezed == requestedAtUtc
          ? _value.requestedAtUtc
          : requestedAtUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      processedAtUtc: freezed == processedAtUtc
          ? _value.processedAtUtc
          : processedAtUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$LCAmendmentImpl extends _LCAmendment {
  const _$LCAmendmentImpl(
      {required this.amendmentId,
      required this.lcId,
      required this.amendmentNumber,
      this.amendmentDateUtc,
      required this.changesSummary,
      final Map<String, dynamic>? changesDetail,
      this.amendmentFee,
      this.amendmentFeeCurrencyId,
      this.status = LCAmendmentStatus.pending,
      this.requestedBy,
      this.requestedAtUtc,
      this.processedAtUtc})
      : _changesDetail = changesDetail,
        super._();

  @override
  final String amendmentId;
  @override
  final String lcId;
  @override
  final int amendmentNumber;
  @override
  final DateTime? amendmentDateUtc;
  @override
  final String changesSummary;
  final Map<String, dynamic>? _changesDetail;
  @override
  Map<String, dynamic>? get changesDetail {
    final value = _changesDetail;
    if (value == null) return null;
    if (_changesDetail is EqualUnmodifiableMapView) return _changesDetail;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final double? amendmentFee;
  @override
  final String? amendmentFeeCurrencyId;
  @override
  @JsonKey()
  final LCAmendmentStatus status;
  @override
  final String? requestedBy;
  @override
  final DateTime? requestedAtUtc;
  @override
  final DateTime? processedAtUtc;

  @override
  String toString() {
    return 'LCAmendment(amendmentId: $amendmentId, lcId: $lcId, amendmentNumber: $amendmentNumber, amendmentDateUtc: $amendmentDateUtc, changesSummary: $changesSummary, changesDetail: $changesDetail, amendmentFee: $amendmentFee, amendmentFeeCurrencyId: $amendmentFeeCurrencyId, status: $status, requestedBy: $requestedBy, requestedAtUtc: $requestedAtUtc, processedAtUtc: $processedAtUtc)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LCAmendmentImpl &&
            (identical(other.amendmentId, amendmentId) ||
                other.amendmentId == amendmentId) &&
            (identical(other.lcId, lcId) || other.lcId == lcId) &&
            (identical(other.amendmentNumber, amendmentNumber) ||
                other.amendmentNumber == amendmentNumber) &&
            (identical(other.amendmentDateUtc, amendmentDateUtc) ||
                other.amendmentDateUtc == amendmentDateUtc) &&
            (identical(other.changesSummary, changesSummary) ||
                other.changesSummary == changesSummary) &&
            const DeepCollectionEquality()
                .equals(other._changesDetail, _changesDetail) &&
            (identical(other.amendmentFee, amendmentFee) ||
                other.amendmentFee == amendmentFee) &&
            (identical(other.amendmentFeeCurrencyId, amendmentFeeCurrencyId) ||
                other.amendmentFeeCurrencyId == amendmentFeeCurrencyId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.requestedBy, requestedBy) ||
                other.requestedBy == requestedBy) &&
            (identical(other.requestedAtUtc, requestedAtUtc) ||
                other.requestedAtUtc == requestedAtUtc) &&
            (identical(other.processedAtUtc, processedAtUtc) ||
                other.processedAtUtc == processedAtUtc));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      amendmentId,
      lcId,
      amendmentNumber,
      amendmentDateUtc,
      changesSummary,
      const DeepCollectionEquality().hash(_changesDetail),
      amendmentFee,
      amendmentFeeCurrencyId,
      status,
      requestedBy,
      requestedAtUtc,
      processedAtUtc);

  /// Create a copy of LCAmendment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LCAmendmentImplCopyWith<_$LCAmendmentImpl> get copyWith =>
      __$$LCAmendmentImplCopyWithImpl<_$LCAmendmentImpl>(this, _$identity);
}

abstract class _LCAmendment extends LCAmendment {
  const factory _LCAmendment(
      {required final String amendmentId,
      required final String lcId,
      required final int amendmentNumber,
      final DateTime? amendmentDateUtc,
      required final String changesSummary,
      final Map<String, dynamic>? changesDetail,
      final double? amendmentFee,
      final String? amendmentFeeCurrencyId,
      final LCAmendmentStatus status,
      final String? requestedBy,
      final DateTime? requestedAtUtc,
      final DateTime? processedAtUtc}) = _$LCAmendmentImpl;
  const _LCAmendment._() : super._();

  @override
  String get amendmentId;
  @override
  String get lcId;
  @override
  int get amendmentNumber;
  @override
  DateTime? get amendmentDateUtc;
  @override
  String get changesSummary;
  @override
  Map<String, dynamic>? get changesDetail;
  @override
  double? get amendmentFee;
  @override
  String? get amendmentFeeCurrencyId;
  @override
  LCAmendmentStatus get status;
  @override
  String? get requestedBy;
  @override
  DateTime? get requestedAtUtc;
  @override
  DateTime? get processedAtUtc;

  /// Create a copy of LCAmendment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LCAmendmentImplCopyWith<_$LCAmendmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LetterOfCredit {
  String get lcId => throw _privateConstructorUsedError;
  String get lcNumber => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String? get storeId =>
      throw _privateConstructorUsedError; // Related documents
  String? get piId => throw _privateConstructorUsedError;
  String? get piNumber => throw _privateConstructorUsedError;
  String? get poId => throw _privateConstructorUsedError;
  String? get poNumber => throw _privateConstructorUsedError; // LC Type
  String get lcTypeCode => throw _privateConstructorUsedError;
  String? get lcTypeName => throw _privateConstructorUsedError; // Parties
  String? get applicantId => throw _privateConstructorUsedError;
  String? get applicantName => throw _privateConstructorUsedError;
  Map<String, dynamic>? get applicantInfo => throw _privateConstructorUsedError;
  Map<String, dynamic>? get beneficiaryInfo =>
      throw _privateConstructorUsedError; // Banks
  String? get issuingBankId => throw _privateConstructorUsedError;
  String? get issuingBankName => throw _privateConstructorUsedError;
  Map<String, dynamic>? get issuingBankInfo =>
      throw _privateConstructorUsedError;
  String? get advisingBankId => throw _privateConstructorUsedError;
  String? get advisingBankName => throw _privateConstructorUsedError;
  Map<String, dynamic>? get advisingBankInfo =>
      throw _privateConstructorUsedError;
  String? get confirmingBankId => throw _privateConstructorUsedError;
  String? get confirmingBankName => throw _privateConstructorUsedError;
  Map<String, dynamic>? get confirmingBankInfo =>
      throw _privateConstructorUsedError; // Amount
  String? get currencyId => throw _privateConstructorUsedError;
  String get currencyCode => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  double get amountUtilized => throw _privateConstructorUsedError;
  double get tolerancePlusPercent => throw _privateConstructorUsedError;
  double get toleranceMinusPercent =>
      throw _privateConstructorUsedError; // Dates
  DateTime? get issueDateUtc => throw _privateConstructorUsedError;
  DateTime get expiryDateUtc => throw _privateConstructorUsedError;
  String? get expiryPlace => throw _privateConstructorUsedError;
  DateTime? get latestShipmentDateUtc => throw _privateConstructorUsedError;
  int get presentationPeriodDays =>
      throw _privateConstructorUsedError; // Payment terms
  String? get paymentTermsCode => throw _privateConstructorUsedError;
  int? get usanceDays => throw _privateConstructorUsedError;
  String? get usanceFrom => throw _privateConstructorUsedError; // Trade terms
  String? get incotermsCode => throw _privateConstructorUsedError;
  String? get incotermsPlace => throw _privateConstructorUsedError;
  String? get portOfLoading => throw _privateConstructorUsedError;
  String? get portOfDischarge => throw _privateConstructorUsedError;
  String? get shippingMethodCode => throw _privateConstructorUsedError;
  bool get partialShipmentAllowed => throw _privateConstructorUsedError;
  bool get transshipmentAllowed =>
      throw _privateConstructorUsedError; // Documents & Conditions
  List<LCRequiredDocument> get requiredDocuments =>
      throw _privateConstructorUsedError;
  String? get specialConditions => throw _privateConstructorUsedError;
  Map<String, dynamic>? get additionalConditions =>
      throw _privateConstructorUsedError; // Status
  LCStatus get status => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  int get amendmentCount => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get internalNotes => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  DateTime? get createdAtUtc => throw _privateConstructorUsedError;
  DateTime? get updatedAtUtc =>
      throw _privateConstructorUsedError; // Amendments
  List<LCAmendment> get amendments => throw _privateConstructorUsedError;

  /// Create a copy of LetterOfCredit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LetterOfCreditCopyWith<LetterOfCredit> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LetterOfCreditCopyWith<$Res> {
  factory $LetterOfCreditCopyWith(
          LetterOfCredit value, $Res Function(LetterOfCredit) then) =
      _$LetterOfCreditCopyWithImpl<$Res, LetterOfCredit>;
  @useResult
  $Res call(
      {String lcId,
      String lcNumber,
      String companyId,
      String? storeId,
      String? piId,
      String? piNumber,
      String? poId,
      String? poNumber,
      String lcTypeCode,
      String? lcTypeName,
      String? applicantId,
      String? applicantName,
      Map<String, dynamic>? applicantInfo,
      Map<String, dynamic>? beneficiaryInfo,
      String? issuingBankId,
      String? issuingBankName,
      Map<String, dynamic>? issuingBankInfo,
      String? advisingBankId,
      String? advisingBankName,
      Map<String, dynamic>? advisingBankInfo,
      String? confirmingBankId,
      String? confirmingBankName,
      Map<String, dynamic>? confirmingBankInfo,
      String? currencyId,
      String currencyCode,
      double amount,
      double amountUtilized,
      double tolerancePlusPercent,
      double toleranceMinusPercent,
      DateTime? issueDateUtc,
      DateTime expiryDateUtc,
      String? expiryPlace,
      DateTime? latestShipmentDateUtc,
      int presentationPeriodDays,
      String? paymentTermsCode,
      int? usanceDays,
      String? usanceFrom,
      String? incotermsCode,
      String? incotermsPlace,
      String? portOfLoading,
      String? portOfDischarge,
      String? shippingMethodCode,
      bool partialShipmentAllowed,
      bool transshipmentAllowed,
      List<LCRequiredDocument> requiredDocuments,
      String? specialConditions,
      Map<String, dynamic>? additionalConditions,
      LCStatus status,
      int version,
      int amendmentCount,
      String? notes,
      String? internalNotes,
      String? createdBy,
      DateTime? createdAtUtc,
      DateTime? updatedAtUtc,
      List<LCAmendment> amendments});
}

/// @nodoc
class _$LetterOfCreditCopyWithImpl<$Res, $Val extends LetterOfCredit>
    implements $LetterOfCreditCopyWith<$Res> {
  _$LetterOfCreditCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LetterOfCredit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lcId = null,
    Object? lcNumber = null,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? piId = freezed,
    Object? piNumber = freezed,
    Object? poId = freezed,
    Object? poNumber = freezed,
    Object? lcTypeCode = null,
    Object? lcTypeName = freezed,
    Object? applicantId = freezed,
    Object? applicantName = freezed,
    Object? applicantInfo = freezed,
    Object? beneficiaryInfo = freezed,
    Object? issuingBankId = freezed,
    Object? issuingBankName = freezed,
    Object? issuingBankInfo = freezed,
    Object? advisingBankId = freezed,
    Object? advisingBankName = freezed,
    Object? advisingBankInfo = freezed,
    Object? confirmingBankId = freezed,
    Object? confirmingBankName = freezed,
    Object? confirmingBankInfo = freezed,
    Object? currencyId = freezed,
    Object? currencyCode = null,
    Object? amount = null,
    Object? amountUtilized = null,
    Object? tolerancePlusPercent = null,
    Object? toleranceMinusPercent = null,
    Object? issueDateUtc = freezed,
    Object? expiryDateUtc = null,
    Object? expiryPlace = freezed,
    Object? latestShipmentDateUtc = freezed,
    Object? presentationPeriodDays = null,
    Object? paymentTermsCode = freezed,
    Object? usanceDays = freezed,
    Object? usanceFrom = freezed,
    Object? incotermsCode = freezed,
    Object? incotermsPlace = freezed,
    Object? portOfLoading = freezed,
    Object? portOfDischarge = freezed,
    Object? shippingMethodCode = freezed,
    Object? partialShipmentAllowed = null,
    Object? transshipmentAllowed = null,
    Object? requiredDocuments = null,
    Object? specialConditions = freezed,
    Object? additionalConditions = freezed,
    Object? status = null,
    Object? version = null,
    Object? amendmentCount = null,
    Object? notes = freezed,
    Object? internalNotes = freezed,
    Object? createdBy = freezed,
    Object? createdAtUtc = freezed,
    Object? updatedAtUtc = freezed,
    Object? amendments = null,
  }) {
    return _then(_value.copyWith(
      lcId: null == lcId
          ? _value.lcId
          : lcId // ignore: cast_nullable_to_non_nullable
              as String,
      lcNumber: null == lcNumber
          ? _value.lcNumber
          : lcNumber // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      piId: freezed == piId
          ? _value.piId
          : piId // ignore: cast_nullable_to_non_nullable
              as String?,
      piNumber: freezed == piNumber
          ? _value.piNumber
          : piNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      poId: freezed == poId
          ? _value.poId
          : poId // ignore: cast_nullable_to_non_nullable
              as String?,
      poNumber: freezed == poNumber
          ? _value.poNumber
          : poNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      lcTypeCode: null == lcTypeCode
          ? _value.lcTypeCode
          : lcTypeCode // ignore: cast_nullable_to_non_nullable
              as String,
      lcTypeName: freezed == lcTypeName
          ? _value.lcTypeName
          : lcTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
      applicantId: freezed == applicantId
          ? _value.applicantId
          : applicantId // ignore: cast_nullable_to_non_nullable
              as String?,
      applicantName: freezed == applicantName
          ? _value.applicantName
          : applicantName // ignore: cast_nullable_to_non_nullable
              as String?,
      applicantInfo: freezed == applicantInfo
          ? _value.applicantInfo
          : applicantInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      beneficiaryInfo: freezed == beneficiaryInfo
          ? _value.beneficiaryInfo
          : beneficiaryInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      issuingBankId: freezed == issuingBankId
          ? _value.issuingBankId
          : issuingBankId // ignore: cast_nullable_to_non_nullable
              as String?,
      issuingBankName: freezed == issuingBankName
          ? _value.issuingBankName
          : issuingBankName // ignore: cast_nullable_to_non_nullable
              as String?,
      issuingBankInfo: freezed == issuingBankInfo
          ? _value.issuingBankInfo
          : issuingBankInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      advisingBankId: freezed == advisingBankId
          ? _value.advisingBankId
          : advisingBankId // ignore: cast_nullable_to_non_nullable
              as String?,
      advisingBankName: freezed == advisingBankName
          ? _value.advisingBankName
          : advisingBankName // ignore: cast_nullable_to_non_nullable
              as String?,
      advisingBankInfo: freezed == advisingBankInfo
          ? _value.advisingBankInfo
          : advisingBankInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      confirmingBankId: freezed == confirmingBankId
          ? _value.confirmingBankId
          : confirmingBankId // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmingBankName: freezed == confirmingBankName
          ? _value.confirmingBankName
          : confirmingBankName // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmingBankInfo: freezed == confirmingBankInfo
          ? _value.confirmingBankInfo
          : confirmingBankInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      currencyId: freezed == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      amountUtilized: null == amountUtilized
          ? _value.amountUtilized
          : amountUtilized // ignore: cast_nullable_to_non_nullable
              as double,
      tolerancePlusPercent: null == tolerancePlusPercent
          ? _value.tolerancePlusPercent
          : tolerancePlusPercent // ignore: cast_nullable_to_non_nullable
              as double,
      toleranceMinusPercent: null == toleranceMinusPercent
          ? _value.toleranceMinusPercent
          : toleranceMinusPercent // ignore: cast_nullable_to_non_nullable
              as double,
      issueDateUtc: freezed == issueDateUtc
          ? _value.issueDateUtc
          : issueDateUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiryDateUtc: null == expiryDateUtc
          ? _value.expiryDateUtc
          : expiryDateUtc // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiryPlace: freezed == expiryPlace
          ? _value.expiryPlace
          : expiryPlace // ignore: cast_nullable_to_non_nullable
              as String?,
      latestShipmentDateUtc: freezed == latestShipmentDateUtc
          ? _value.latestShipmentDateUtc
          : latestShipmentDateUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      presentationPeriodDays: null == presentationPeriodDays
          ? _value.presentationPeriodDays
          : presentationPeriodDays // ignore: cast_nullable_to_non_nullable
              as int,
      paymentTermsCode: freezed == paymentTermsCode
          ? _value.paymentTermsCode
          : paymentTermsCode // ignore: cast_nullable_to_non_nullable
              as String?,
      usanceDays: freezed == usanceDays
          ? _value.usanceDays
          : usanceDays // ignore: cast_nullable_to_non_nullable
              as int?,
      usanceFrom: freezed == usanceFrom
          ? _value.usanceFrom
          : usanceFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      incotermsCode: freezed == incotermsCode
          ? _value.incotermsCode
          : incotermsCode // ignore: cast_nullable_to_non_nullable
              as String?,
      incotermsPlace: freezed == incotermsPlace
          ? _value.incotermsPlace
          : incotermsPlace // ignore: cast_nullable_to_non_nullable
              as String?,
      portOfLoading: freezed == portOfLoading
          ? _value.portOfLoading
          : portOfLoading // ignore: cast_nullable_to_non_nullable
              as String?,
      portOfDischarge: freezed == portOfDischarge
          ? _value.portOfDischarge
          : portOfDischarge // ignore: cast_nullable_to_non_nullable
              as String?,
      shippingMethodCode: freezed == shippingMethodCode
          ? _value.shippingMethodCode
          : shippingMethodCode // ignore: cast_nullable_to_non_nullable
              as String?,
      partialShipmentAllowed: null == partialShipmentAllowed
          ? _value.partialShipmentAllowed
          : partialShipmentAllowed // ignore: cast_nullable_to_non_nullable
              as bool,
      transshipmentAllowed: null == transshipmentAllowed
          ? _value.transshipmentAllowed
          : transshipmentAllowed // ignore: cast_nullable_to_non_nullable
              as bool,
      requiredDocuments: null == requiredDocuments
          ? _value.requiredDocuments
          : requiredDocuments // ignore: cast_nullable_to_non_nullable
              as List<LCRequiredDocument>,
      specialConditions: freezed == specialConditions
          ? _value.specialConditions
          : specialConditions // ignore: cast_nullable_to_non_nullable
              as String?,
      additionalConditions: freezed == additionalConditions
          ? _value.additionalConditions
          : additionalConditions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LCStatus,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      amendmentCount: null == amendmentCount
          ? _value.amendmentCount
          : amendmentCount // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      internalNotes: freezed == internalNotes
          ? _value.internalNotes
          : internalNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAtUtc: freezed == createdAtUtc
          ? _value.createdAtUtc
          : createdAtUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAtUtc: freezed == updatedAtUtc
          ? _value.updatedAtUtc
          : updatedAtUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      amendments: null == amendments
          ? _value.amendments
          : amendments // ignore: cast_nullable_to_non_nullable
              as List<LCAmendment>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LetterOfCreditImplCopyWith<$Res>
    implements $LetterOfCreditCopyWith<$Res> {
  factory _$$LetterOfCreditImplCopyWith(_$LetterOfCreditImpl value,
          $Res Function(_$LetterOfCreditImpl) then) =
      __$$LetterOfCreditImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String lcId,
      String lcNumber,
      String companyId,
      String? storeId,
      String? piId,
      String? piNumber,
      String? poId,
      String? poNumber,
      String lcTypeCode,
      String? lcTypeName,
      String? applicantId,
      String? applicantName,
      Map<String, dynamic>? applicantInfo,
      Map<String, dynamic>? beneficiaryInfo,
      String? issuingBankId,
      String? issuingBankName,
      Map<String, dynamic>? issuingBankInfo,
      String? advisingBankId,
      String? advisingBankName,
      Map<String, dynamic>? advisingBankInfo,
      String? confirmingBankId,
      String? confirmingBankName,
      Map<String, dynamic>? confirmingBankInfo,
      String? currencyId,
      String currencyCode,
      double amount,
      double amountUtilized,
      double tolerancePlusPercent,
      double toleranceMinusPercent,
      DateTime? issueDateUtc,
      DateTime expiryDateUtc,
      String? expiryPlace,
      DateTime? latestShipmentDateUtc,
      int presentationPeriodDays,
      String? paymentTermsCode,
      int? usanceDays,
      String? usanceFrom,
      String? incotermsCode,
      String? incotermsPlace,
      String? portOfLoading,
      String? portOfDischarge,
      String? shippingMethodCode,
      bool partialShipmentAllowed,
      bool transshipmentAllowed,
      List<LCRequiredDocument> requiredDocuments,
      String? specialConditions,
      Map<String, dynamic>? additionalConditions,
      LCStatus status,
      int version,
      int amendmentCount,
      String? notes,
      String? internalNotes,
      String? createdBy,
      DateTime? createdAtUtc,
      DateTime? updatedAtUtc,
      List<LCAmendment> amendments});
}

/// @nodoc
class __$$LetterOfCreditImplCopyWithImpl<$Res>
    extends _$LetterOfCreditCopyWithImpl<$Res, _$LetterOfCreditImpl>
    implements _$$LetterOfCreditImplCopyWith<$Res> {
  __$$LetterOfCreditImplCopyWithImpl(
      _$LetterOfCreditImpl _value, $Res Function(_$LetterOfCreditImpl) _then)
      : super(_value, _then);

  /// Create a copy of LetterOfCredit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lcId = null,
    Object? lcNumber = null,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? piId = freezed,
    Object? piNumber = freezed,
    Object? poId = freezed,
    Object? poNumber = freezed,
    Object? lcTypeCode = null,
    Object? lcTypeName = freezed,
    Object? applicantId = freezed,
    Object? applicantName = freezed,
    Object? applicantInfo = freezed,
    Object? beneficiaryInfo = freezed,
    Object? issuingBankId = freezed,
    Object? issuingBankName = freezed,
    Object? issuingBankInfo = freezed,
    Object? advisingBankId = freezed,
    Object? advisingBankName = freezed,
    Object? advisingBankInfo = freezed,
    Object? confirmingBankId = freezed,
    Object? confirmingBankName = freezed,
    Object? confirmingBankInfo = freezed,
    Object? currencyId = freezed,
    Object? currencyCode = null,
    Object? amount = null,
    Object? amountUtilized = null,
    Object? tolerancePlusPercent = null,
    Object? toleranceMinusPercent = null,
    Object? issueDateUtc = freezed,
    Object? expiryDateUtc = null,
    Object? expiryPlace = freezed,
    Object? latestShipmentDateUtc = freezed,
    Object? presentationPeriodDays = null,
    Object? paymentTermsCode = freezed,
    Object? usanceDays = freezed,
    Object? usanceFrom = freezed,
    Object? incotermsCode = freezed,
    Object? incotermsPlace = freezed,
    Object? portOfLoading = freezed,
    Object? portOfDischarge = freezed,
    Object? shippingMethodCode = freezed,
    Object? partialShipmentAllowed = null,
    Object? transshipmentAllowed = null,
    Object? requiredDocuments = null,
    Object? specialConditions = freezed,
    Object? additionalConditions = freezed,
    Object? status = null,
    Object? version = null,
    Object? amendmentCount = null,
    Object? notes = freezed,
    Object? internalNotes = freezed,
    Object? createdBy = freezed,
    Object? createdAtUtc = freezed,
    Object? updatedAtUtc = freezed,
    Object? amendments = null,
  }) {
    return _then(_$LetterOfCreditImpl(
      lcId: null == lcId
          ? _value.lcId
          : lcId // ignore: cast_nullable_to_non_nullable
              as String,
      lcNumber: null == lcNumber
          ? _value.lcNumber
          : lcNumber // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      piId: freezed == piId
          ? _value.piId
          : piId // ignore: cast_nullable_to_non_nullable
              as String?,
      piNumber: freezed == piNumber
          ? _value.piNumber
          : piNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      poId: freezed == poId
          ? _value.poId
          : poId // ignore: cast_nullable_to_non_nullable
              as String?,
      poNumber: freezed == poNumber
          ? _value.poNumber
          : poNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      lcTypeCode: null == lcTypeCode
          ? _value.lcTypeCode
          : lcTypeCode // ignore: cast_nullable_to_non_nullable
              as String,
      lcTypeName: freezed == lcTypeName
          ? _value.lcTypeName
          : lcTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
      applicantId: freezed == applicantId
          ? _value.applicantId
          : applicantId // ignore: cast_nullable_to_non_nullable
              as String?,
      applicantName: freezed == applicantName
          ? _value.applicantName
          : applicantName // ignore: cast_nullable_to_non_nullable
              as String?,
      applicantInfo: freezed == applicantInfo
          ? _value._applicantInfo
          : applicantInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      beneficiaryInfo: freezed == beneficiaryInfo
          ? _value._beneficiaryInfo
          : beneficiaryInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      issuingBankId: freezed == issuingBankId
          ? _value.issuingBankId
          : issuingBankId // ignore: cast_nullable_to_non_nullable
              as String?,
      issuingBankName: freezed == issuingBankName
          ? _value.issuingBankName
          : issuingBankName // ignore: cast_nullable_to_non_nullable
              as String?,
      issuingBankInfo: freezed == issuingBankInfo
          ? _value._issuingBankInfo
          : issuingBankInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      advisingBankId: freezed == advisingBankId
          ? _value.advisingBankId
          : advisingBankId // ignore: cast_nullable_to_non_nullable
              as String?,
      advisingBankName: freezed == advisingBankName
          ? _value.advisingBankName
          : advisingBankName // ignore: cast_nullable_to_non_nullable
              as String?,
      advisingBankInfo: freezed == advisingBankInfo
          ? _value._advisingBankInfo
          : advisingBankInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      confirmingBankId: freezed == confirmingBankId
          ? _value.confirmingBankId
          : confirmingBankId // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmingBankName: freezed == confirmingBankName
          ? _value.confirmingBankName
          : confirmingBankName // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmingBankInfo: freezed == confirmingBankInfo
          ? _value._confirmingBankInfo
          : confirmingBankInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      currencyId: freezed == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      amountUtilized: null == amountUtilized
          ? _value.amountUtilized
          : amountUtilized // ignore: cast_nullable_to_non_nullable
              as double,
      tolerancePlusPercent: null == tolerancePlusPercent
          ? _value.tolerancePlusPercent
          : tolerancePlusPercent // ignore: cast_nullable_to_non_nullable
              as double,
      toleranceMinusPercent: null == toleranceMinusPercent
          ? _value.toleranceMinusPercent
          : toleranceMinusPercent // ignore: cast_nullable_to_non_nullable
              as double,
      issueDateUtc: freezed == issueDateUtc
          ? _value.issueDateUtc
          : issueDateUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiryDateUtc: null == expiryDateUtc
          ? _value.expiryDateUtc
          : expiryDateUtc // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiryPlace: freezed == expiryPlace
          ? _value.expiryPlace
          : expiryPlace // ignore: cast_nullable_to_non_nullable
              as String?,
      latestShipmentDateUtc: freezed == latestShipmentDateUtc
          ? _value.latestShipmentDateUtc
          : latestShipmentDateUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      presentationPeriodDays: null == presentationPeriodDays
          ? _value.presentationPeriodDays
          : presentationPeriodDays // ignore: cast_nullable_to_non_nullable
              as int,
      paymentTermsCode: freezed == paymentTermsCode
          ? _value.paymentTermsCode
          : paymentTermsCode // ignore: cast_nullable_to_non_nullable
              as String?,
      usanceDays: freezed == usanceDays
          ? _value.usanceDays
          : usanceDays // ignore: cast_nullable_to_non_nullable
              as int?,
      usanceFrom: freezed == usanceFrom
          ? _value.usanceFrom
          : usanceFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      incotermsCode: freezed == incotermsCode
          ? _value.incotermsCode
          : incotermsCode // ignore: cast_nullable_to_non_nullable
              as String?,
      incotermsPlace: freezed == incotermsPlace
          ? _value.incotermsPlace
          : incotermsPlace // ignore: cast_nullable_to_non_nullable
              as String?,
      portOfLoading: freezed == portOfLoading
          ? _value.portOfLoading
          : portOfLoading // ignore: cast_nullable_to_non_nullable
              as String?,
      portOfDischarge: freezed == portOfDischarge
          ? _value.portOfDischarge
          : portOfDischarge // ignore: cast_nullable_to_non_nullable
              as String?,
      shippingMethodCode: freezed == shippingMethodCode
          ? _value.shippingMethodCode
          : shippingMethodCode // ignore: cast_nullable_to_non_nullable
              as String?,
      partialShipmentAllowed: null == partialShipmentAllowed
          ? _value.partialShipmentAllowed
          : partialShipmentAllowed // ignore: cast_nullable_to_non_nullable
              as bool,
      transshipmentAllowed: null == transshipmentAllowed
          ? _value.transshipmentAllowed
          : transshipmentAllowed // ignore: cast_nullable_to_non_nullable
              as bool,
      requiredDocuments: null == requiredDocuments
          ? _value._requiredDocuments
          : requiredDocuments // ignore: cast_nullable_to_non_nullable
              as List<LCRequiredDocument>,
      specialConditions: freezed == specialConditions
          ? _value.specialConditions
          : specialConditions // ignore: cast_nullable_to_non_nullable
              as String?,
      additionalConditions: freezed == additionalConditions
          ? _value._additionalConditions
          : additionalConditions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LCStatus,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      amendmentCount: null == amendmentCount
          ? _value.amendmentCount
          : amendmentCount // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      internalNotes: freezed == internalNotes
          ? _value.internalNotes
          : internalNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAtUtc: freezed == createdAtUtc
          ? _value.createdAtUtc
          : createdAtUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAtUtc: freezed == updatedAtUtc
          ? _value.updatedAtUtc
          : updatedAtUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      amendments: null == amendments
          ? _value._amendments
          : amendments // ignore: cast_nullable_to_non_nullable
              as List<LCAmendment>,
    ));
  }
}

/// @nodoc

class _$LetterOfCreditImpl extends _LetterOfCredit {
  const _$LetterOfCreditImpl(
      {required this.lcId,
      required this.lcNumber,
      required this.companyId,
      this.storeId,
      this.piId,
      this.piNumber,
      this.poId,
      this.poNumber,
      this.lcTypeCode = 'irrevocable',
      this.lcTypeName,
      this.applicantId,
      this.applicantName,
      final Map<String, dynamic>? applicantInfo,
      final Map<String, dynamic>? beneficiaryInfo,
      this.issuingBankId,
      this.issuingBankName,
      final Map<String, dynamic>? issuingBankInfo,
      this.advisingBankId,
      this.advisingBankName,
      final Map<String, dynamic>? advisingBankInfo,
      this.confirmingBankId,
      this.confirmingBankName,
      final Map<String, dynamic>? confirmingBankInfo,
      this.currencyId,
      this.currencyCode = 'USD',
      required this.amount,
      this.amountUtilized = 0,
      this.tolerancePlusPercent = 0,
      this.toleranceMinusPercent = 0,
      this.issueDateUtc,
      required this.expiryDateUtc,
      this.expiryPlace,
      this.latestShipmentDateUtc,
      this.presentationPeriodDays = 21,
      this.paymentTermsCode,
      this.usanceDays,
      this.usanceFrom,
      this.incotermsCode,
      this.incotermsPlace,
      this.portOfLoading,
      this.portOfDischarge,
      this.shippingMethodCode,
      this.partialShipmentAllowed = true,
      this.transshipmentAllowed = true,
      final List<LCRequiredDocument> requiredDocuments = const [],
      this.specialConditions,
      final Map<String, dynamic>? additionalConditions,
      this.status = LCStatus.draft,
      this.version = 1,
      this.amendmentCount = 0,
      this.notes,
      this.internalNotes,
      this.createdBy,
      this.createdAtUtc,
      this.updatedAtUtc,
      final List<LCAmendment> amendments = const []})
      : _applicantInfo = applicantInfo,
        _beneficiaryInfo = beneficiaryInfo,
        _issuingBankInfo = issuingBankInfo,
        _advisingBankInfo = advisingBankInfo,
        _confirmingBankInfo = confirmingBankInfo,
        _requiredDocuments = requiredDocuments,
        _additionalConditions = additionalConditions,
        _amendments = amendments,
        super._();

  @override
  final String lcId;
  @override
  final String lcNumber;
  @override
  final String companyId;
  @override
  final String? storeId;
// Related documents
  @override
  final String? piId;
  @override
  final String? piNumber;
  @override
  final String? poId;
  @override
  final String? poNumber;
// LC Type
  @override
  @JsonKey()
  final String lcTypeCode;
  @override
  final String? lcTypeName;
// Parties
  @override
  final String? applicantId;
  @override
  final String? applicantName;
  final Map<String, dynamic>? _applicantInfo;
  @override
  Map<String, dynamic>? get applicantInfo {
    final value = _applicantInfo;
    if (value == null) return null;
    if (_applicantInfo is EqualUnmodifiableMapView) return _applicantInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _beneficiaryInfo;
  @override
  Map<String, dynamic>? get beneficiaryInfo {
    final value = _beneficiaryInfo;
    if (value == null) return null;
    if (_beneficiaryInfo is EqualUnmodifiableMapView) return _beneficiaryInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Banks
  @override
  final String? issuingBankId;
  @override
  final String? issuingBankName;
  final Map<String, dynamic>? _issuingBankInfo;
  @override
  Map<String, dynamic>? get issuingBankInfo {
    final value = _issuingBankInfo;
    if (value == null) return null;
    if (_issuingBankInfo is EqualUnmodifiableMapView) return _issuingBankInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? advisingBankId;
  @override
  final String? advisingBankName;
  final Map<String, dynamic>? _advisingBankInfo;
  @override
  Map<String, dynamic>? get advisingBankInfo {
    final value = _advisingBankInfo;
    if (value == null) return null;
    if (_advisingBankInfo is EqualUnmodifiableMapView) return _advisingBankInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? confirmingBankId;
  @override
  final String? confirmingBankName;
  final Map<String, dynamic>? _confirmingBankInfo;
  @override
  Map<String, dynamic>? get confirmingBankInfo {
    final value = _confirmingBankInfo;
    if (value == null) return null;
    if (_confirmingBankInfo is EqualUnmodifiableMapView)
      return _confirmingBankInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Amount
  @override
  final String? currencyId;
  @override
  @JsonKey()
  final String currencyCode;
  @override
  final double amount;
  @override
  @JsonKey()
  final double amountUtilized;
  @override
  @JsonKey()
  final double tolerancePlusPercent;
  @override
  @JsonKey()
  final double toleranceMinusPercent;
// Dates
  @override
  final DateTime? issueDateUtc;
  @override
  final DateTime expiryDateUtc;
  @override
  final String? expiryPlace;
  @override
  final DateTime? latestShipmentDateUtc;
  @override
  @JsonKey()
  final int presentationPeriodDays;
// Payment terms
  @override
  final String? paymentTermsCode;
  @override
  final int? usanceDays;
  @override
  final String? usanceFrom;
// Trade terms
  @override
  final String? incotermsCode;
  @override
  final String? incotermsPlace;
  @override
  final String? portOfLoading;
  @override
  final String? portOfDischarge;
  @override
  final String? shippingMethodCode;
  @override
  @JsonKey()
  final bool partialShipmentAllowed;
  @override
  @JsonKey()
  final bool transshipmentAllowed;
// Documents & Conditions
  final List<LCRequiredDocument> _requiredDocuments;
// Documents & Conditions
  @override
  @JsonKey()
  List<LCRequiredDocument> get requiredDocuments {
    if (_requiredDocuments is EqualUnmodifiableListView)
      return _requiredDocuments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requiredDocuments);
  }

  @override
  final String? specialConditions;
  final Map<String, dynamic>? _additionalConditions;
  @override
  Map<String, dynamic>? get additionalConditions {
    final value = _additionalConditions;
    if (value == null) return null;
    if (_additionalConditions is EqualUnmodifiableMapView)
      return _additionalConditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Status
  @override
  @JsonKey()
  final LCStatus status;
  @override
  @JsonKey()
  final int version;
  @override
  @JsonKey()
  final int amendmentCount;
  @override
  final String? notes;
  @override
  final String? internalNotes;
  @override
  final String? createdBy;
  @override
  final DateTime? createdAtUtc;
  @override
  final DateTime? updatedAtUtc;
// Amendments
  final List<LCAmendment> _amendments;
// Amendments
  @override
  @JsonKey()
  List<LCAmendment> get amendments {
    if (_amendments is EqualUnmodifiableListView) return _amendments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_amendments);
  }

  @override
  String toString() {
    return 'LetterOfCredit(lcId: $lcId, lcNumber: $lcNumber, companyId: $companyId, storeId: $storeId, piId: $piId, piNumber: $piNumber, poId: $poId, poNumber: $poNumber, lcTypeCode: $lcTypeCode, lcTypeName: $lcTypeName, applicantId: $applicantId, applicantName: $applicantName, applicantInfo: $applicantInfo, beneficiaryInfo: $beneficiaryInfo, issuingBankId: $issuingBankId, issuingBankName: $issuingBankName, issuingBankInfo: $issuingBankInfo, advisingBankId: $advisingBankId, advisingBankName: $advisingBankName, advisingBankInfo: $advisingBankInfo, confirmingBankId: $confirmingBankId, confirmingBankName: $confirmingBankName, confirmingBankInfo: $confirmingBankInfo, currencyId: $currencyId, currencyCode: $currencyCode, amount: $amount, amountUtilized: $amountUtilized, tolerancePlusPercent: $tolerancePlusPercent, toleranceMinusPercent: $toleranceMinusPercent, issueDateUtc: $issueDateUtc, expiryDateUtc: $expiryDateUtc, expiryPlace: $expiryPlace, latestShipmentDateUtc: $latestShipmentDateUtc, presentationPeriodDays: $presentationPeriodDays, paymentTermsCode: $paymentTermsCode, usanceDays: $usanceDays, usanceFrom: $usanceFrom, incotermsCode: $incotermsCode, incotermsPlace: $incotermsPlace, portOfLoading: $portOfLoading, portOfDischarge: $portOfDischarge, shippingMethodCode: $shippingMethodCode, partialShipmentAllowed: $partialShipmentAllowed, transshipmentAllowed: $transshipmentAllowed, requiredDocuments: $requiredDocuments, specialConditions: $specialConditions, additionalConditions: $additionalConditions, status: $status, version: $version, amendmentCount: $amendmentCount, notes: $notes, internalNotes: $internalNotes, createdBy: $createdBy, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, amendments: $amendments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LetterOfCreditImpl &&
            (identical(other.lcId, lcId) || other.lcId == lcId) &&
            (identical(other.lcNumber, lcNumber) ||
                other.lcNumber == lcNumber) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.piId, piId) || other.piId == piId) &&
            (identical(other.piNumber, piNumber) ||
                other.piNumber == piNumber) &&
            (identical(other.poId, poId) || other.poId == poId) &&
            (identical(other.poNumber, poNumber) ||
                other.poNumber == poNumber) &&
            (identical(other.lcTypeCode, lcTypeCode) ||
                other.lcTypeCode == lcTypeCode) &&
            (identical(other.lcTypeName, lcTypeName) ||
                other.lcTypeName == lcTypeName) &&
            (identical(other.applicantId, applicantId) ||
                other.applicantId == applicantId) &&
            (identical(other.applicantName, applicantName) ||
                other.applicantName == applicantName) &&
            const DeepCollectionEquality()
                .equals(other._applicantInfo, _applicantInfo) &&
            const DeepCollectionEquality()
                .equals(other._beneficiaryInfo, _beneficiaryInfo) &&
            (identical(other.issuingBankId, issuingBankId) ||
                other.issuingBankId == issuingBankId) &&
            (identical(other.issuingBankName, issuingBankName) ||
                other.issuingBankName == issuingBankName) &&
            const DeepCollectionEquality()
                .equals(other._issuingBankInfo, _issuingBankInfo) &&
            (identical(other.advisingBankId, advisingBankId) ||
                other.advisingBankId == advisingBankId) &&
            (identical(other.advisingBankName, advisingBankName) ||
                other.advisingBankName == advisingBankName) &&
            const DeepCollectionEquality()
                .equals(other._advisingBankInfo, _advisingBankInfo) &&
            (identical(other.confirmingBankId, confirmingBankId) ||
                other.confirmingBankId == confirmingBankId) &&
            (identical(other.confirmingBankName, confirmingBankName) ||
                other.confirmingBankName == confirmingBankName) &&
            const DeepCollectionEquality()
                .equals(other._confirmingBankInfo, _confirmingBankInfo) &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.amountUtilized, amountUtilized) ||
                other.amountUtilized == amountUtilized) &&
            (identical(other.tolerancePlusPercent, tolerancePlusPercent) ||
                other.tolerancePlusPercent == tolerancePlusPercent) &&
            (identical(other.toleranceMinusPercent, toleranceMinusPercent) ||
                other.toleranceMinusPercent == toleranceMinusPercent) &&
            (identical(other.issueDateUtc, issueDateUtc) ||
                other.issueDateUtc == issueDateUtc) &&
            (identical(other.expiryDateUtc, expiryDateUtc) ||
                other.expiryDateUtc == expiryDateUtc) &&
            (identical(other.expiryPlace, expiryPlace) ||
                other.expiryPlace == expiryPlace) &&
            (identical(other.latestShipmentDateUtc, latestShipmentDateUtc) ||
                other.latestShipmentDateUtc == latestShipmentDateUtc) &&
            (identical(other.presentationPeriodDays, presentationPeriodDays) ||
                other.presentationPeriodDays == presentationPeriodDays) &&
            (identical(other.paymentTermsCode, paymentTermsCode) ||
                other.paymentTermsCode == paymentTermsCode) &&
            (identical(other.usanceDays, usanceDays) ||
                other.usanceDays == usanceDays) &&
            (identical(other.usanceFrom, usanceFrom) ||
                other.usanceFrom == usanceFrom) &&
            (identical(other.incotermsCode, incotermsCode) ||
                other.incotermsCode == incotermsCode) &&
            (identical(other.incotermsPlace, incotermsPlace) ||
                other.incotermsPlace == incotermsPlace) &&
            (identical(other.portOfLoading, portOfLoading) ||
                other.portOfLoading == portOfLoading) &&
            (identical(other.portOfDischarge, portOfDischarge) ||
                other.portOfDischarge == portOfDischarge) &&
            (identical(other.shippingMethodCode, shippingMethodCode) ||
                other.shippingMethodCode == shippingMethodCode) &&
            (identical(other.partialShipmentAllowed, partialShipmentAllowed) ||
                other.partialShipmentAllowed == partialShipmentAllowed) &&
            (identical(other.transshipmentAllowed, transshipmentAllowed) ||
                other.transshipmentAllowed == transshipmentAllowed) &&
            const DeepCollectionEquality()
                .equals(other._requiredDocuments, _requiredDocuments) &&
            (identical(other.specialConditions, specialConditions) ||
                other.specialConditions == specialConditions) &&
            const DeepCollectionEquality()
                .equals(other._additionalConditions, _additionalConditions) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.amendmentCount, amendmentCount) || other.amendmentCount == amendmentCount) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.internalNotes, internalNotes) || other.internalNotes == internalNotes) &&
            (identical(other.createdBy, createdBy) || other.createdBy == createdBy) &&
            (identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc) &&
            (identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc) &&
            const DeepCollectionEquality().equals(other._amendments, _amendments));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        lcId,
        lcNumber,
        companyId,
        storeId,
        piId,
        piNumber,
        poId,
        poNumber,
        lcTypeCode,
        lcTypeName,
        applicantId,
        applicantName,
        const DeepCollectionEquality().hash(_applicantInfo),
        const DeepCollectionEquality().hash(_beneficiaryInfo),
        issuingBankId,
        issuingBankName,
        const DeepCollectionEquality().hash(_issuingBankInfo),
        advisingBankId,
        advisingBankName,
        const DeepCollectionEquality().hash(_advisingBankInfo),
        confirmingBankId,
        confirmingBankName,
        const DeepCollectionEquality().hash(_confirmingBankInfo),
        currencyId,
        currencyCode,
        amount,
        amountUtilized,
        tolerancePlusPercent,
        toleranceMinusPercent,
        issueDateUtc,
        expiryDateUtc,
        expiryPlace,
        latestShipmentDateUtc,
        presentationPeriodDays,
        paymentTermsCode,
        usanceDays,
        usanceFrom,
        incotermsCode,
        incotermsPlace,
        portOfLoading,
        portOfDischarge,
        shippingMethodCode,
        partialShipmentAllowed,
        transshipmentAllowed,
        const DeepCollectionEquality().hash(_requiredDocuments),
        specialConditions,
        const DeepCollectionEquality().hash(_additionalConditions),
        status,
        version,
        amendmentCount,
        notes,
        internalNotes,
        createdBy,
        createdAtUtc,
        updatedAtUtc,
        const DeepCollectionEquality().hash(_amendments)
      ]);

  /// Create a copy of LetterOfCredit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LetterOfCreditImplCopyWith<_$LetterOfCreditImpl> get copyWith =>
      __$$LetterOfCreditImplCopyWithImpl<_$LetterOfCreditImpl>(
          this, _$identity);
}

abstract class _LetterOfCredit extends LetterOfCredit {
  const factory _LetterOfCredit(
      {required final String lcId,
      required final String lcNumber,
      required final String companyId,
      final String? storeId,
      final String? piId,
      final String? piNumber,
      final String? poId,
      final String? poNumber,
      final String lcTypeCode,
      final String? lcTypeName,
      final String? applicantId,
      final String? applicantName,
      final Map<String, dynamic>? applicantInfo,
      final Map<String, dynamic>? beneficiaryInfo,
      final String? issuingBankId,
      final String? issuingBankName,
      final Map<String, dynamic>? issuingBankInfo,
      final String? advisingBankId,
      final String? advisingBankName,
      final Map<String, dynamic>? advisingBankInfo,
      final String? confirmingBankId,
      final String? confirmingBankName,
      final Map<String, dynamic>? confirmingBankInfo,
      final String? currencyId,
      final String currencyCode,
      required final double amount,
      final double amountUtilized,
      final double tolerancePlusPercent,
      final double toleranceMinusPercent,
      final DateTime? issueDateUtc,
      required final DateTime expiryDateUtc,
      final String? expiryPlace,
      final DateTime? latestShipmentDateUtc,
      final int presentationPeriodDays,
      final String? paymentTermsCode,
      final int? usanceDays,
      final String? usanceFrom,
      final String? incotermsCode,
      final String? incotermsPlace,
      final String? portOfLoading,
      final String? portOfDischarge,
      final String? shippingMethodCode,
      final bool partialShipmentAllowed,
      final bool transshipmentAllowed,
      final List<LCRequiredDocument> requiredDocuments,
      final String? specialConditions,
      final Map<String, dynamic>? additionalConditions,
      final LCStatus status,
      final int version,
      final int amendmentCount,
      final String? notes,
      final String? internalNotes,
      final String? createdBy,
      final DateTime? createdAtUtc,
      final DateTime? updatedAtUtc,
      final List<LCAmendment> amendments}) = _$LetterOfCreditImpl;
  const _LetterOfCredit._() : super._();

  @override
  String get lcId;
  @override
  String get lcNumber;
  @override
  String get companyId;
  @override
  String? get storeId; // Related documents
  @override
  String? get piId;
  @override
  String? get piNumber;
  @override
  String? get poId;
  @override
  String? get poNumber; // LC Type
  @override
  String get lcTypeCode;
  @override
  String? get lcTypeName; // Parties
  @override
  String? get applicantId;
  @override
  String? get applicantName;
  @override
  Map<String, dynamic>? get applicantInfo;
  @override
  Map<String, dynamic>? get beneficiaryInfo; // Banks
  @override
  String? get issuingBankId;
  @override
  String? get issuingBankName;
  @override
  Map<String, dynamic>? get issuingBankInfo;
  @override
  String? get advisingBankId;
  @override
  String? get advisingBankName;
  @override
  Map<String, dynamic>? get advisingBankInfo;
  @override
  String? get confirmingBankId;
  @override
  String? get confirmingBankName;
  @override
  Map<String, dynamic>? get confirmingBankInfo; // Amount
  @override
  String? get currencyId;
  @override
  String get currencyCode;
  @override
  double get amount;
  @override
  double get amountUtilized;
  @override
  double get tolerancePlusPercent;
  @override
  double get toleranceMinusPercent; // Dates
  @override
  DateTime? get issueDateUtc;
  @override
  DateTime get expiryDateUtc;
  @override
  String? get expiryPlace;
  @override
  DateTime? get latestShipmentDateUtc;
  @override
  int get presentationPeriodDays; // Payment terms
  @override
  String? get paymentTermsCode;
  @override
  int? get usanceDays;
  @override
  String? get usanceFrom; // Trade terms
  @override
  String? get incotermsCode;
  @override
  String? get incotermsPlace;
  @override
  String? get portOfLoading;
  @override
  String? get portOfDischarge;
  @override
  String? get shippingMethodCode;
  @override
  bool get partialShipmentAllowed;
  @override
  bool get transshipmentAllowed; // Documents & Conditions
  @override
  List<LCRequiredDocument> get requiredDocuments;
  @override
  String? get specialConditions;
  @override
  Map<String, dynamic>? get additionalConditions; // Status
  @override
  LCStatus get status;
  @override
  int get version;
  @override
  int get amendmentCount;
  @override
  String? get notes;
  @override
  String? get internalNotes;
  @override
  String? get createdBy;
  @override
  DateTime? get createdAtUtc;
  @override
  DateTime? get updatedAtUtc; // Amendments
  @override
  List<LCAmendment> get amendments;

  /// Create a copy of LetterOfCredit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LetterOfCreditImplCopyWith<_$LetterOfCreditImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LCListItem {
  String get lcId => throw _privateConstructorUsedError;
  String get lcNumber => throw _privateConstructorUsedError;
  String? get applicantName => throw _privateConstructorUsedError;
  String? get issuingBankName => throw _privateConstructorUsedError;
  String get currencyCode => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  double get amountUtilized => throw _privateConstructorUsedError;
  LCStatus get status => throw _privateConstructorUsedError;
  DateTime get expiryDateUtc => throw _privateConstructorUsedError;
  DateTime? get latestShipmentDateUtc => throw _privateConstructorUsedError;
  DateTime? get createdAtUtc => throw _privateConstructorUsedError;
  String? get piNumber => throw _privateConstructorUsedError;
  String? get poNumber => throw _privateConstructorUsedError;

  /// Create a copy of LCListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LCListItemCopyWith<LCListItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LCListItemCopyWith<$Res> {
  factory $LCListItemCopyWith(
          LCListItem value, $Res Function(LCListItem) then) =
      _$LCListItemCopyWithImpl<$Res, LCListItem>;
  @useResult
  $Res call(
      {String lcId,
      String lcNumber,
      String? applicantName,
      String? issuingBankName,
      String currencyCode,
      double amount,
      double amountUtilized,
      LCStatus status,
      DateTime expiryDateUtc,
      DateTime? latestShipmentDateUtc,
      DateTime? createdAtUtc,
      String? piNumber,
      String? poNumber});
}

/// @nodoc
class _$LCListItemCopyWithImpl<$Res, $Val extends LCListItem>
    implements $LCListItemCopyWith<$Res> {
  _$LCListItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LCListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lcId = null,
    Object? lcNumber = null,
    Object? applicantName = freezed,
    Object? issuingBankName = freezed,
    Object? currencyCode = null,
    Object? amount = null,
    Object? amountUtilized = null,
    Object? status = null,
    Object? expiryDateUtc = null,
    Object? latestShipmentDateUtc = freezed,
    Object? createdAtUtc = freezed,
    Object? piNumber = freezed,
    Object? poNumber = freezed,
  }) {
    return _then(_value.copyWith(
      lcId: null == lcId
          ? _value.lcId
          : lcId // ignore: cast_nullable_to_non_nullable
              as String,
      lcNumber: null == lcNumber
          ? _value.lcNumber
          : lcNumber // ignore: cast_nullable_to_non_nullable
              as String,
      applicantName: freezed == applicantName
          ? _value.applicantName
          : applicantName // ignore: cast_nullable_to_non_nullable
              as String?,
      issuingBankName: freezed == issuingBankName
          ? _value.issuingBankName
          : issuingBankName // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      amountUtilized: null == amountUtilized
          ? _value.amountUtilized
          : amountUtilized // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LCStatus,
      expiryDateUtc: null == expiryDateUtc
          ? _value.expiryDateUtc
          : expiryDateUtc // ignore: cast_nullable_to_non_nullable
              as DateTime,
      latestShipmentDateUtc: freezed == latestShipmentDateUtc
          ? _value.latestShipmentDateUtc
          : latestShipmentDateUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAtUtc: freezed == createdAtUtc
          ? _value.createdAtUtc
          : createdAtUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      piNumber: freezed == piNumber
          ? _value.piNumber
          : piNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      poNumber: freezed == poNumber
          ? _value.poNumber
          : poNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LCListItemImplCopyWith<$Res>
    implements $LCListItemCopyWith<$Res> {
  factory _$$LCListItemImplCopyWith(
          _$LCListItemImpl value, $Res Function(_$LCListItemImpl) then) =
      __$$LCListItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String lcId,
      String lcNumber,
      String? applicantName,
      String? issuingBankName,
      String currencyCode,
      double amount,
      double amountUtilized,
      LCStatus status,
      DateTime expiryDateUtc,
      DateTime? latestShipmentDateUtc,
      DateTime? createdAtUtc,
      String? piNumber,
      String? poNumber});
}

/// @nodoc
class __$$LCListItemImplCopyWithImpl<$Res>
    extends _$LCListItemCopyWithImpl<$Res, _$LCListItemImpl>
    implements _$$LCListItemImplCopyWith<$Res> {
  __$$LCListItemImplCopyWithImpl(
      _$LCListItemImpl _value, $Res Function(_$LCListItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of LCListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lcId = null,
    Object? lcNumber = null,
    Object? applicantName = freezed,
    Object? issuingBankName = freezed,
    Object? currencyCode = null,
    Object? amount = null,
    Object? amountUtilized = null,
    Object? status = null,
    Object? expiryDateUtc = null,
    Object? latestShipmentDateUtc = freezed,
    Object? createdAtUtc = freezed,
    Object? piNumber = freezed,
    Object? poNumber = freezed,
  }) {
    return _then(_$LCListItemImpl(
      lcId: null == lcId
          ? _value.lcId
          : lcId // ignore: cast_nullable_to_non_nullable
              as String,
      lcNumber: null == lcNumber
          ? _value.lcNumber
          : lcNumber // ignore: cast_nullable_to_non_nullable
              as String,
      applicantName: freezed == applicantName
          ? _value.applicantName
          : applicantName // ignore: cast_nullable_to_non_nullable
              as String?,
      issuingBankName: freezed == issuingBankName
          ? _value.issuingBankName
          : issuingBankName // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      amountUtilized: null == amountUtilized
          ? _value.amountUtilized
          : amountUtilized // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LCStatus,
      expiryDateUtc: null == expiryDateUtc
          ? _value.expiryDateUtc
          : expiryDateUtc // ignore: cast_nullable_to_non_nullable
              as DateTime,
      latestShipmentDateUtc: freezed == latestShipmentDateUtc
          ? _value.latestShipmentDateUtc
          : latestShipmentDateUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAtUtc: freezed == createdAtUtc
          ? _value.createdAtUtc
          : createdAtUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      piNumber: freezed == piNumber
          ? _value.piNumber
          : piNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      poNumber: freezed == poNumber
          ? _value.poNumber
          : poNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$LCListItemImpl extends _LCListItem {
  const _$LCListItemImpl(
      {required this.lcId,
      required this.lcNumber,
      this.applicantName,
      this.issuingBankName,
      required this.currencyCode,
      required this.amount,
      this.amountUtilized = 0,
      required this.status,
      required this.expiryDateUtc,
      this.latestShipmentDateUtc,
      this.createdAtUtc,
      this.piNumber,
      this.poNumber})
      : super._();

  @override
  final String lcId;
  @override
  final String lcNumber;
  @override
  final String? applicantName;
  @override
  final String? issuingBankName;
  @override
  final String currencyCode;
  @override
  final double amount;
  @override
  @JsonKey()
  final double amountUtilized;
  @override
  final LCStatus status;
  @override
  final DateTime expiryDateUtc;
  @override
  final DateTime? latestShipmentDateUtc;
  @override
  final DateTime? createdAtUtc;
  @override
  final String? piNumber;
  @override
  final String? poNumber;

  @override
  String toString() {
    return 'LCListItem(lcId: $lcId, lcNumber: $lcNumber, applicantName: $applicantName, issuingBankName: $issuingBankName, currencyCode: $currencyCode, amount: $amount, amountUtilized: $amountUtilized, status: $status, expiryDateUtc: $expiryDateUtc, latestShipmentDateUtc: $latestShipmentDateUtc, createdAtUtc: $createdAtUtc, piNumber: $piNumber, poNumber: $poNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LCListItemImpl &&
            (identical(other.lcId, lcId) || other.lcId == lcId) &&
            (identical(other.lcNumber, lcNumber) ||
                other.lcNumber == lcNumber) &&
            (identical(other.applicantName, applicantName) ||
                other.applicantName == applicantName) &&
            (identical(other.issuingBankName, issuingBankName) ||
                other.issuingBankName == issuingBankName) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.amountUtilized, amountUtilized) ||
                other.amountUtilized == amountUtilized) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.expiryDateUtc, expiryDateUtc) ||
                other.expiryDateUtc == expiryDateUtc) &&
            (identical(other.latestShipmentDateUtc, latestShipmentDateUtc) ||
                other.latestShipmentDateUtc == latestShipmentDateUtc) &&
            (identical(other.createdAtUtc, createdAtUtc) ||
                other.createdAtUtc == createdAtUtc) &&
            (identical(other.piNumber, piNumber) ||
                other.piNumber == piNumber) &&
            (identical(other.poNumber, poNumber) ||
                other.poNumber == poNumber));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      lcId,
      lcNumber,
      applicantName,
      issuingBankName,
      currencyCode,
      amount,
      amountUtilized,
      status,
      expiryDateUtc,
      latestShipmentDateUtc,
      createdAtUtc,
      piNumber,
      poNumber);

  /// Create a copy of LCListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LCListItemImplCopyWith<_$LCListItemImpl> get copyWith =>
      __$$LCListItemImplCopyWithImpl<_$LCListItemImpl>(this, _$identity);
}

abstract class _LCListItem extends LCListItem {
  const factory _LCListItem(
      {required final String lcId,
      required final String lcNumber,
      final String? applicantName,
      final String? issuingBankName,
      required final String currencyCode,
      required final double amount,
      final double amountUtilized,
      required final LCStatus status,
      required final DateTime expiryDateUtc,
      final DateTime? latestShipmentDateUtc,
      final DateTime? createdAtUtc,
      final String? piNumber,
      final String? poNumber}) = _$LCListItemImpl;
  const _LCListItem._() : super._();

  @override
  String get lcId;
  @override
  String get lcNumber;
  @override
  String? get applicantName;
  @override
  String? get issuingBankName;
  @override
  String get currencyCode;
  @override
  double get amount;
  @override
  double get amountUtilized;
  @override
  LCStatus get status;
  @override
  DateTime get expiryDateUtc;
  @override
  DateTime? get latestShipmentDateUtc;
  @override
  DateTime? get createdAtUtc;
  @override
  String? get piNumber;
  @override
  String? get poNumber;

  /// Create a copy of LCListItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LCListItemImplCopyWith<_$LCListItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
