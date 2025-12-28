// Domain Entity: JournalAttachment
// Represents an attachment (image/file) associated with a journal entry
//
// Clean Architecture Note:
// This is a pure domain entity. JSON serialization is handled by
// JournalAttachmentDto in the data layer.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'journal_attachment.freezed.dart';

/// Represents an attachment for a journal entry.
///
/// Can be in two states:
/// 1. Pending upload: [localFile] is set, [fileUrl] is null
/// 2. Uploaded: [fileUrl] is set, [localFile] may be null
@Freezed(toJson: false, fromJson: false)
class JournalAttachment with _$JournalAttachment {
  const JournalAttachment._();

  const factory JournalAttachment({
    /// Attachment ID from database (null if not yet saved)
    String? attachmentId,

    /// Journal ID this attachment belongs to (null before journal is created)
    String? journalId,

    /// Local file for pending uploads (runtime only, not serialized)
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
  }) = _JournalAttachment;

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
}
