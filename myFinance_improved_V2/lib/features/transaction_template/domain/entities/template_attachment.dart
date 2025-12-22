// Domain Entity: TemplateAttachment
// Represents an attachment (image/file) associated with a transaction created from template

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'template_attachment.freezed.dart';

/// Represents an attachment for a transaction created from template.
///
/// Can be in two states:
/// 1. Pending upload: [localFile] is set, [fileUrl] is null
/// 2. Uploaded: [fileUrl] is set, [localFile] may be null
@freezed
class TemplateAttachment with _$TemplateAttachment {
  const TemplateAttachment._();

  const factory TemplateAttachment({
    /// Attachment ID from database (null if not yet saved)
    String? attachmentId,

    /// Journal ID this attachment belongs to (null before journal is created)
    String? journalId,

    /// Local file for pending uploads (not serialized)
    XFile? localFile,

    /// Storage URL after upload
    String? fileUrl,

    /// Original file name
    required String fileName,

    /// File size in bytes (for validation)
    @Default(0) int fileSizeBytes,

    /// MIME type of the file
    String? mimeType,

    /// User who uploaded the file
    String? uploadedBy,

    /// Upload timestamp in UTC
    DateTime? uploadedAtUtc,
  }) = _TemplateAttachment;

  /// Check if this attachment is pending upload
  bool get isPendingUpload => localFile != null && fileUrl == null;

  /// Check if this attachment is already uploaded
  bool get isUploaded => fileUrl != null;

  /// File size in MB for display
  double get fileSizeMB => fileSizeBytes / (1024 * 1024);

  /// Check if file size exceeds limit (5MB)
  bool get exceedsSizeLimit => fileSizeBytes > 5 * 1024 * 1024;

  /// Get file extension from file name
  String get fileExtension {
    final parts = fileName.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  /// Check if this is an image file
  bool get isImage {
    final ext = fileExtension;
    return ['jpg', 'jpeg', 'png', 'webp', 'gif'].contains(ext);
  }

  /// Check if this is a PDF file
  bool get isPdf => fileExtension == 'pdf';

  /// Maximum file size in bytes (5MB)
  static const int maxFileSizeBytes = 5 * 1024 * 1024;

  /// Maximum number of attachments allowed
  static const int maxAttachments = 10;
}
