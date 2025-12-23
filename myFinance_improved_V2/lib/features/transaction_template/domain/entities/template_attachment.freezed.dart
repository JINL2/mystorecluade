// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'template_attachment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TemplateAttachment {
  /// Attachment ID from database (null if not yet saved)
  String? get attachmentId => throw _privateConstructorUsedError;

  /// Journal ID this attachment belongs to (null before journal is created)
  String? get journalId => throw _privateConstructorUsedError;

  /// Local file for pending uploads (not serialized)
  XFile? get localFile => throw _privateConstructorUsedError;

  /// Storage URL after upload
  String? get fileUrl => throw _privateConstructorUsedError;

  /// Original file name
  String get fileName => throw _privateConstructorUsedError;

  /// File size in bytes (for validation)
  int get fileSizeBytes => throw _privateConstructorUsedError;

  /// MIME type of the file
  String? get mimeType => throw _privateConstructorUsedError;

  /// User who uploaded the file
  String? get uploadedBy => throw _privateConstructorUsedError;

  /// Upload timestamp in UTC
  DateTime? get uploadedAtUtc => throw _privateConstructorUsedError;

  /// Create a copy of TemplateAttachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateAttachmentCopyWith<TemplateAttachment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateAttachmentCopyWith<$Res> {
  factory $TemplateAttachmentCopyWith(
          TemplateAttachment value, $Res Function(TemplateAttachment) then) =
      _$TemplateAttachmentCopyWithImpl<$Res, TemplateAttachment>;
  @useResult
  $Res call(
      {String? attachmentId,
      String? journalId,
      XFile? localFile,
      String? fileUrl,
      String fileName,
      int fileSizeBytes,
      String? mimeType,
      String? uploadedBy,
      DateTime? uploadedAtUtc});
}

/// @nodoc
class _$TemplateAttachmentCopyWithImpl<$Res, $Val extends TemplateAttachment>
    implements $TemplateAttachmentCopyWith<$Res> {
  _$TemplateAttachmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateAttachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attachmentId = freezed,
    Object? journalId = freezed,
    Object? localFile = freezed,
    Object? fileUrl = freezed,
    Object? fileName = null,
    Object? fileSizeBytes = null,
    Object? mimeType = freezed,
    Object? uploadedBy = freezed,
    Object? uploadedAtUtc = freezed,
  }) {
    return _then(_value.copyWith(
      attachmentId: freezed == attachmentId
          ? _value.attachmentId
          : attachmentId // ignore: cast_nullable_to_non_nullable
              as String?,
      journalId: freezed == journalId
          ? _value.journalId
          : journalId // ignore: cast_nullable_to_non_nullable
              as String?,
      localFile: freezed == localFile
          ? _value.localFile
          : localFile // ignore: cast_nullable_to_non_nullable
              as XFile?,
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileSizeBytes: null == fileSizeBytes
          ? _value.fileSizeBytes
          : fileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadedBy: freezed == uploadedBy
          ? _value.uploadedBy
          : uploadedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadedAtUtc: freezed == uploadedAtUtc
          ? _value.uploadedAtUtc
          : uploadedAtUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemplateAttachmentImplCopyWith<$Res>
    implements $TemplateAttachmentCopyWith<$Res> {
  factory _$$TemplateAttachmentImplCopyWith(_$TemplateAttachmentImpl value,
          $Res Function(_$TemplateAttachmentImpl) then) =
      __$$TemplateAttachmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? attachmentId,
      String? journalId,
      XFile? localFile,
      String? fileUrl,
      String fileName,
      int fileSizeBytes,
      String? mimeType,
      String? uploadedBy,
      DateTime? uploadedAtUtc});
}

/// @nodoc
class __$$TemplateAttachmentImplCopyWithImpl<$Res>
    extends _$TemplateAttachmentCopyWithImpl<$Res, _$TemplateAttachmentImpl>
    implements _$$TemplateAttachmentImplCopyWith<$Res> {
  __$$TemplateAttachmentImplCopyWithImpl(_$TemplateAttachmentImpl _value,
      $Res Function(_$TemplateAttachmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplateAttachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attachmentId = freezed,
    Object? journalId = freezed,
    Object? localFile = freezed,
    Object? fileUrl = freezed,
    Object? fileName = null,
    Object? fileSizeBytes = null,
    Object? mimeType = freezed,
    Object? uploadedBy = freezed,
    Object? uploadedAtUtc = freezed,
  }) {
    return _then(_$TemplateAttachmentImpl(
      attachmentId: freezed == attachmentId
          ? _value.attachmentId
          : attachmentId // ignore: cast_nullable_to_non_nullable
              as String?,
      journalId: freezed == journalId
          ? _value.journalId
          : journalId // ignore: cast_nullable_to_non_nullable
              as String?,
      localFile: freezed == localFile
          ? _value.localFile
          : localFile // ignore: cast_nullable_to_non_nullable
              as XFile?,
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileSizeBytes: null == fileSizeBytes
          ? _value.fileSizeBytes
          : fileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadedBy: freezed == uploadedBy
          ? _value.uploadedBy
          : uploadedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadedAtUtc: freezed == uploadedAtUtc
          ? _value.uploadedAtUtc
          : uploadedAtUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$TemplateAttachmentImpl extends _TemplateAttachment {
  const _$TemplateAttachmentImpl(
      {this.attachmentId,
      this.journalId,
      this.localFile,
      this.fileUrl,
      required this.fileName,
      this.fileSizeBytes = 0,
      this.mimeType,
      this.uploadedBy,
      this.uploadedAtUtc})
      : super._();

  /// Attachment ID from database (null if not yet saved)
  @override
  final String? attachmentId;

  /// Journal ID this attachment belongs to (null before journal is created)
  @override
  final String? journalId;

  /// Local file for pending uploads (not serialized)
  @override
  final XFile? localFile;

  /// Storage URL after upload
  @override
  final String? fileUrl;

  /// Original file name
  @override
  final String fileName;

  /// File size in bytes (for validation)
  @override
  @JsonKey()
  final int fileSizeBytes;

  /// MIME type of the file
  @override
  final String? mimeType;

  /// User who uploaded the file
  @override
  final String? uploadedBy;

  /// Upload timestamp in UTC
  @override
  final DateTime? uploadedAtUtc;

  @override
  String toString() {
    return 'TemplateAttachment(attachmentId: $attachmentId, journalId: $journalId, localFile: $localFile, fileUrl: $fileUrl, fileName: $fileName, fileSizeBytes: $fileSizeBytes, mimeType: $mimeType, uploadedBy: $uploadedBy, uploadedAtUtc: $uploadedAtUtc)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateAttachmentImpl &&
            (identical(other.attachmentId, attachmentId) ||
                other.attachmentId == attachmentId) &&
            (identical(other.journalId, journalId) ||
                other.journalId == journalId) &&
            (identical(other.localFile, localFile) ||
                other.localFile == localFile) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileSizeBytes, fileSizeBytes) ||
                other.fileSizeBytes == fileSizeBytes) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.uploadedBy, uploadedBy) ||
                other.uploadedBy == uploadedBy) &&
            (identical(other.uploadedAtUtc, uploadedAtUtc) ||
                other.uploadedAtUtc == uploadedAtUtc));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      attachmentId,
      journalId,
      localFile,
      fileUrl,
      fileName,
      fileSizeBytes,
      mimeType,
      uploadedBy,
      uploadedAtUtc);

  /// Create a copy of TemplateAttachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateAttachmentImplCopyWith<_$TemplateAttachmentImpl> get copyWith =>
      __$$TemplateAttachmentImplCopyWithImpl<_$TemplateAttachmentImpl>(
          this, _$identity);
}

abstract class _TemplateAttachment extends TemplateAttachment {
  const factory _TemplateAttachment(
      {final String? attachmentId,
      final String? journalId,
      final XFile? localFile,
      final String? fileUrl,
      required final String fileName,
      final int fileSizeBytes,
      final String? mimeType,
      final String? uploadedBy,
      final DateTime? uploadedAtUtc}) = _$TemplateAttachmentImpl;
  const _TemplateAttachment._() : super._();

  /// Attachment ID from database (null if not yet saved)
  @override
  String? get attachmentId;

  /// Journal ID this attachment belongs to (null before journal is created)
  @override
  String? get journalId;

  /// Local file for pending uploads (not serialized)
  @override
  XFile? get localFile;

  /// Storage URL after upload
  @override
  String? get fileUrl;

  /// Original file name
  @override
  String get fileName;

  /// File size in bytes (for validation)
  @override
  int get fileSizeBytes;

  /// MIME type of the file
  @override
  String? get mimeType;

  /// User who uploaded the file
  @override
  String? get uploadedBy;

  /// Upload timestamp in UTC
  @override
  DateTime? get uploadedAtUtc;

  /// Create a copy of TemplateAttachment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateAttachmentImplCopyWith<_$TemplateAttachmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
