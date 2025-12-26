// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_flow.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

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
  String? get journalAiDescription => throw _privateConstructorUsedError;
  String get journalType => throw _privateConstructorUsedError;
  String get accountId => throw _privateConstructorUsedError;
  String get accountName => throw _privateConstructorUsedError;
  CreatedBy get createdBy => throw _privateConstructorUsedError;
  CounterAccount? get counterAccount => throw _privateConstructorUsedError;
  List<JournalAttachment> get attachments => throw _privateConstructorUsedError;

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
      String? journalAiDescription,
      String journalType,
      String accountId,
      String accountName,
      CreatedBy createdBy,
      CounterAccount? counterAccount,
      List<JournalAttachment> attachments});

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
    Object? journalAiDescription = freezed,
    Object? journalType = null,
    Object? accountId = null,
    Object? accountName = null,
    Object? createdBy = null,
    Object? counterAccount = freezed,
    Object? attachments = null,
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
      journalAiDescription: freezed == journalAiDescription
          ? _value.journalAiDescription
          : journalAiDescription // ignore: cast_nullable_to_non_nullable
              as String?,
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
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<JournalAttachment>,
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
      String? journalAiDescription,
      String journalType,
      String accountId,
      String accountName,
      CreatedBy createdBy,
      CounterAccount? counterAccount,
      List<JournalAttachment> attachments});

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
    Object? journalAiDescription = freezed,
    Object? journalType = null,
    Object? accountId = null,
    Object? accountName = null,
    Object? createdBy = null,
    Object? counterAccount = freezed,
    Object? attachments = null,
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
      journalAiDescription: freezed == journalAiDescription
          ? _value.journalAiDescription
          : journalAiDescription // ignore: cast_nullable_to_non_nullable
              as String?,
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
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<JournalAttachment>,
    ));
  }
}

/// @nodoc

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
      this.journalAiDescription,
      required this.journalType,
      required this.accountId,
      required this.accountName,
      required this.createdBy,
      this.counterAccount,
      final List<JournalAttachment> attachments = const []})
      : _attachments = attachments;

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
  final String? journalAiDescription;
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
  final List<JournalAttachment> _attachments;
  @override
  @JsonKey()
  List<JournalAttachment> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  String toString() {
    return 'JournalFlow(flowId: $flowId, createdAt: $createdAt, systemTime: $systemTime, balanceBefore: $balanceBefore, flowAmount: $flowAmount, balanceAfter: $balanceAfter, journalId: $journalId, journalDescription: $journalDescription, journalAiDescription: $journalAiDescription, journalType: $journalType, accountId: $accountId, accountName: $accountName, createdBy: $createdBy, counterAccount: $counterAccount, attachments: $attachments)';
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
            (identical(other.journalAiDescription, journalAiDescription) ||
                other.journalAiDescription == journalAiDescription) &&
            (identical(other.journalType, journalType) ||
                other.journalType == journalType) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.counterAccount, counterAccount) ||
                other.counterAccount == counterAccount) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments));
  }

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
      journalAiDescription,
      journalType,
      accountId,
      accountName,
      createdBy,
      counterAccount,
      const DeepCollectionEquality().hash(_attachments));

  /// Create a copy of JournalFlow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JournalFlowImplCopyWith<_$JournalFlowImpl> get copyWith =>
      __$$JournalFlowImplCopyWithImpl<_$JournalFlowImpl>(this, _$identity);
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
      final String? journalAiDescription,
      required final String journalType,
      required final String accountId,
      required final String accountName,
      required final CreatedBy createdBy,
      final CounterAccount? counterAccount,
      final List<JournalAttachment> attachments}) = _$JournalFlowImpl;

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
  String? get journalAiDescription;
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
  @override
  List<JournalAttachment> get attachments;

  /// Create a copy of JournalFlow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JournalFlowImplCopyWith<_$JournalFlowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$JournalAttachment {
  String get attachmentId => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  String get fileType => throw _privateConstructorUsedError;
  String? get fileUrl => throw _privateConstructorUsedError;
  String? get ocrText => throw _privateConstructorUsedError;
  String? get ocrStatus => throw _privateConstructorUsedError;

  /// Create a copy of JournalAttachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JournalAttachmentCopyWith<JournalAttachment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JournalAttachmentCopyWith<$Res> {
  factory $JournalAttachmentCopyWith(
          JournalAttachment value, $Res Function(JournalAttachment) then) =
      _$JournalAttachmentCopyWithImpl<$Res, JournalAttachment>;
  @useResult
  $Res call(
      {String attachmentId,
      String fileName,
      String fileType,
      String? fileUrl,
      String? ocrText,
      String? ocrStatus});
}

/// @nodoc
class _$JournalAttachmentCopyWithImpl<$Res, $Val extends JournalAttachment>
    implements $JournalAttachmentCopyWith<$Res> {
  _$JournalAttachmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JournalAttachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attachmentId = null,
    Object? fileName = null,
    Object? fileType = null,
    Object? fileUrl = freezed,
    Object? ocrText = freezed,
    Object? ocrStatus = freezed,
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
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      ocrText: freezed == ocrText
          ? _value.ocrText
          : ocrText // ignore: cast_nullable_to_non_nullable
              as String?,
      ocrStatus: freezed == ocrStatus
          ? _value.ocrStatus
          : ocrStatus // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JournalAttachmentImplCopyWith<$Res>
    implements $JournalAttachmentCopyWith<$Res> {
  factory _$$JournalAttachmentImplCopyWith(_$JournalAttachmentImpl value,
          $Res Function(_$JournalAttachmentImpl) then) =
      __$$JournalAttachmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String attachmentId,
      String fileName,
      String fileType,
      String? fileUrl,
      String? ocrText,
      String? ocrStatus});
}

/// @nodoc
class __$$JournalAttachmentImplCopyWithImpl<$Res>
    extends _$JournalAttachmentCopyWithImpl<$Res, _$JournalAttachmentImpl>
    implements _$$JournalAttachmentImplCopyWith<$Res> {
  __$$JournalAttachmentImplCopyWithImpl(_$JournalAttachmentImpl _value,
      $Res Function(_$JournalAttachmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of JournalAttachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attachmentId = null,
    Object? fileName = null,
    Object? fileType = null,
    Object? fileUrl = freezed,
    Object? ocrText = freezed,
    Object? ocrStatus = freezed,
  }) {
    return _then(_$JournalAttachmentImpl(
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
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      ocrText: freezed == ocrText
          ? _value.ocrText
          : ocrText // ignore: cast_nullable_to_non_nullable
              as String?,
      ocrStatus: freezed == ocrStatus
          ? _value.ocrStatus
          : ocrStatus // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$JournalAttachmentImpl extends _JournalAttachment {
  const _$JournalAttachmentImpl(
      {required this.attachmentId,
      required this.fileName,
      required this.fileType,
      this.fileUrl,
      this.ocrText,
      this.ocrStatus})
      : super._();

  @override
  final String attachmentId;
  @override
  final String fileName;
  @override
  final String fileType;
  @override
  final String? fileUrl;
  @override
  final String? ocrText;
  @override
  final String? ocrStatus;

  @override
  String toString() {
    return 'JournalAttachment(attachmentId: $attachmentId, fileName: $fileName, fileType: $fileType, fileUrl: $fileUrl, ocrText: $ocrText, ocrStatus: $ocrStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JournalAttachmentImpl &&
            (identical(other.attachmentId, attachmentId) ||
                other.attachmentId == attachmentId) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileType, fileType) ||
                other.fileType == fileType) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.ocrText, ocrText) || other.ocrText == ocrText) &&
            (identical(other.ocrStatus, ocrStatus) ||
                other.ocrStatus == ocrStatus));
  }

  @override
  int get hashCode => Object.hash(runtimeType, attachmentId, fileName, fileType,
      fileUrl, ocrText, ocrStatus);

  /// Create a copy of JournalAttachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JournalAttachmentImplCopyWith<_$JournalAttachmentImpl> get copyWith =>
      __$$JournalAttachmentImplCopyWithImpl<_$JournalAttachmentImpl>(
          this, _$identity);
}

abstract class _JournalAttachment extends JournalAttachment {
  const factory _JournalAttachment(
      {required final String attachmentId,
      required final String fileName,
      required final String fileType,
      final String? fileUrl,
      final String? ocrText,
      final String? ocrStatus}) = _$JournalAttachmentImpl;
  const _JournalAttachment._() : super._();

  @override
  String get attachmentId;
  @override
  String get fileName;
  @override
  String get fileType;
  @override
  String? get fileUrl;
  @override
  String? get ocrText;
  @override
  String? get ocrStatus;

  /// Create a copy of JournalAttachment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JournalAttachmentImplCopyWith<_$JournalAttachmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
