// Data Source: JournalEntryDataSource
// Handles all API calls and database queries for journal entries

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/monitoring/sentry_config.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/journal_attachment.dart';
import '../models/journal_entry_model.dart';

class JournalEntryDataSource {
  final SupabaseClient _supabase;

  JournalEntryDataSource(this._supabase);

  /// Fetch all accounts from the database
  Future<List<Map<String, dynamic>>> getAccounts() async {
    try {
      final response = await _supabase
          .from('accounts')
          .select('account_id, account_name, category_tag')
          .order('account_name');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch accounts: $e');
    }
  }

  /// Fetch counterparties for a specific company
  Future<List<Map<String, dynamic>>> getCounterparties(String companyId) async {
    try {
      if (companyId.isEmpty) {
        return [];
      }

      final response = await _supabase
          .from('counterparties')
          .select('counterparty_id, name, is_internal, linked_company_id')
          .eq('company_id', companyId)
          .order('name');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch counterparties: $e');
    }
  }

  /// Fetch stores for a linked company (counterparty)
  Future<List<Map<String, dynamic>>> getCounterpartyStores(String linkedCompanyId) async {
    try {
      if (linkedCompanyId.isEmpty) {
        return [];
      }

      final response = await _supabase
          .from('stores')
          .select('store_id, store_name')
          .eq('company_id', linkedCompanyId)
          .order('store_name');

      return List<Map<String, dynamic>>.from(response);
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'JournalEntry: Failed to fetch counterparty stores',
        extra: {'linkedCompanyId': linkedCompanyId},
      );
      throw Exception('Failed to fetch counterparty stores: $e');
    }
  }

  /// Fetch cash locations using RPC
  Future<List<Map<String, dynamic>>> getCashLocations({
    required String companyId,
    String? storeId,
  }) async {
    try {
      if (companyId.isEmpty) {
        return [];
      }

      // Use RPC to get cash locations
      final response = await _supabase.rpc<List<dynamic>>(
        'get_cash_locations',
        params: {
          'p_company_id': companyId,
        },
      );

      // Convert RPC response to expected format
      final locations = response.map((item) {
        final location = {
          'cash_location_id': item['id'],
          'location_name': item['name'],
          'location_type': item['type'],
          'store_id': item['storeId'],
        };

        // Filter by store if specified
        if (storeId != null && storeId.isNotEmpty) {
          if (item['storeId'] == storeId) {
            return location;
          }
          return null;
        }

        return location;
      }).whereType<Map<String, dynamic>>().toList();

      return locations;
    } catch (e) {
      throw Exception('Failed to fetch cash locations: $e');
    }
  }

  /// Check account mapping for internal transactions
  Future<Map<String, dynamic>?> checkAccountMapping({
    required String companyId,
    required String counterpartyId,
    required String accountId,
  }) async {
    try {
      final response = await _supabase
          .from('account_mappings')
          .select('my_account_id, linked_account_id, direction')
          .eq('my_company_id', companyId)
          .eq('counterparty_id', counterpartyId)
          .eq('my_account_id', accountId)
          .maybeSingle();

      if (response != null) {
        return {
          'my_account_id': response['my_account_id'],
          'linked_account_id': response['linked_account_id'],
          'direction': response['direction'],
        };
      }

      return null;
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'JournalEntry: Failed to check account mapping',
        extra: {
          'companyId': companyId,
          'counterpartyId': counterpartyId,
          'accountId': accountId,
        },
      );
      return null;
    }
  }

  /// Fetch exchange rates using RPC
  Future<Map<String, dynamic>> getExchangeRates(String companyId) async {
    try {
      if (companyId.isEmpty) {
        throw Exception('Company ID is required');
      }

      final response = await _supabase.rpc<Map<String, dynamic>>(
        'get_exchange_rate_v2',
        params: {
          'p_company_id': companyId,
        },
      );

      return response;
    } catch (e) {
      throw Exception('Failed to fetch exchange rates: $e');
    }
  }

  /// Submit journal entry using RPC and return the created journal ID
  Future<String> submitJournalEntry({
    required JournalEntryModel journalEntry,
    required String userId,
    required String companyId,
    String? storeId,
  }) async {
    try {
      // Convert entry date to UTC for database storage
      // RPC expects 'yyyy-MM-dd HH:mm:ss' format in UTC
      final entryDate = DateTimeUtils.toRpcFormat(journalEntry.entryDate);

      // Prepare journal lines
      final pLines = journalEntry.getTransactionLinesJson();

      // Get main counterparty ID
      final mainCounterpartyId = journalEntry.getMainCounterpartyId();

      // Calculate total debits for base amount
      final totalDebits = journalEntry.transactionLines
          .where((line) => line.isDebit)
          .fold(0.0, (sum, line) => sum + line.amount);

      // 🔍 DEBUG: Print JSON being sent to RPC
      debugPrint('🔵 [9] JournalEntryDataSource.submitJournalEntry');
      debugPrint('═══════════════════════════════════════════');
      debugPrint('🔍 insert_journal_with_everything_utc DEBUG');
      debugPrint('═══════════════════════════════════════════');
      debugPrint('p_base_amount: $totalDebits');
      debugPrint('p_company_id: $companyId');
      debugPrint('p_created_by: $userId');
      debugPrint('p_description: ${journalEntry.overallDescription}');
      debugPrint('p_entry_date_utc: $entryDate');
      debugPrint('p_counterparty_id: $mainCounterpartyId');
      debugPrint('p_if_cash_location_id: ${journalEntry.counterpartyCashLocationId}');
      debugPrint('p_store_id: $storeId');
      debugPrint('───────────────────────────────────────────');
      debugPrint('p_lines (${pLines.length} lines):');
      for (int i = 0; i < pLines.length; i++) {
        debugPrint('  Line $i: ${pLines[i]}');
      }
      debugPrint('═══════════════════════════════════════════');

      // Call the journal RPC - returns journal_id as String
      final journalId = await _supabase.rpc<String>(
        'insert_journal_with_everything_utc',
        params: {
          'p_base_amount': totalDebits,
          'p_company_id': companyId,
          'p_created_by': userId,
          'p_description': journalEntry.overallDescription,
          'p_entry_date_utc': entryDate,
          'p_lines': pLines,
          'p_counterparty_id': mainCounterpartyId,
          'p_if_cash_location_id': journalEntry.counterpartyCashLocationId,
          'p_store_id': storeId,
        },
      );

      return journalId;
    } catch (e) {
      throw Exception('Failed to create journal entry: $e');
    }
  }

  // =============================================================================
  // Attachment Operations
  // =============================================================================

  /// Storage bucket name for journal attachments
  static const String _bucketName = 'journal-attachments';

  /// Maximum file size in bytes (5MB)
  static const int _maxFileSizeBytes = 5 * 1024 * 1024;

  /// Image compression quality (0-100)
  /// Lower value = smaller file size, reduced quality
  /// 50 produces ~100-150KB images for most photos
  static const int _compressionQuality = 50;

  /// Maximum image dimension for compression
  /// 1000px is sufficient for receipt/document viewing
  static const int _maxImageDimension = 1000;

  /// Upload attachments to storage and save metadata to database
  Future<List<JournalAttachment>> uploadAttachments({
    required String companyId,
    required String journalId,
    required String uploadedBy,
    required List<XFile> files,
  }) async {
    final uploadedAttachments = <JournalAttachment>[];

    for (final file in files) {
      try {
        final attachment = await _uploadSingleAttachment(
          companyId: companyId,
          journalId: journalId,
          uploadedBy: uploadedBy,
          file: file,
        );
        uploadedAttachments.add(attachment);
      } catch (e, stackTrace) {
        SentryConfig.captureException(
          e,
          stackTrace,
          hint: 'JournalEntry: Failed to upload attachment',
          extra: {'fileName': file.name},
        );
        // Continue with other files even if one fails
      }
    }

    return uploadedAttachments;
  }

  /// Upload a single attachment with compression
  Future<JournalAttachment> _uploadSingleAttachment({
    required String companyId,
    required String journalId,
    required String uploadedBy,
    required XFile file,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final originalName = file.name;
    final fileName = '${timestamp}_$originalName';
    final mimeType = _getMimeType(originalName);

    // Storage path: {company_id}/{journal_id}/{timestamp}_{filename}
    final storagePath = '$companyId/$journalId/$fileName';

    // Compress image if applicable
    Uint8List fileBytes;
    if (_isImageFile(originalName)) {
      fileBytes = await _compressImage(file);
    } else {
      fileBytes = await file.readAsBytes();
    }

    // Check file size after compression
    if (fileBytes.length > _maxFileSizeBytes) {
      throw Exception('File size exceeds 5MB limit after compression');
    }

    // Upload to storage
    await _supabase.storage.from(_bucketName).uploadBinary(
      storagePath,
      fileBytes,
      fileOptions: FileOptions(contentType: mimeType),
    );

    // Get the file URL (signed URL for private bucket)
    final fileUrl = _supabase.storage.from(_bucketName).getPublicUrl(storagePath);

    // Save to database
    final now = DateTime.now().toUtc();
    final response = await _supabase.from('journal_attachments').insert({
      'journal_id': journalId,
      'file_url': fileUrl,
      'file_name': originalName,
      'uploaded_by': uploadedBy,
      'uploaded_at_utc': now.toIso8601String(),
    }).select('attachment_id').single();

    return JournalAttachment(
      attachmentId: response['attachment_id'] as String,
      journalId: journalId,
      fileUrl: fileUrl,
      fileName: originalName,
      fileSizeBytes: fileBytes.length,
      mimeType: mimeType,
      uploadedBy: uploadedBy,
      uploadedAtUtc: now,
    );
  }

  /// Compress image using flutter_image_compress
  Future<Uint8List> _compressImage(XFile file) async {
    try {
      final filePath = file.path;

      // Use flutter_image_compress for compression
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        filePath,
        minWidth: _maxImageDimension,
        minHeight: _maxImageDimension,
        quality: _compressionQuality,
        format: _getCompressFormat(file.name),
      );

      if (compressedBytes != null) {
        return compressedBytes;
      }

      // Fallback to original if compression fails
      return await file.readAsBytes();
    } catch (e) {
      // Fallback to original if compression fails
      return await file.readAsBytes();
    }
  }

  /// Get compress format based on file extension
  CompressFormat _getCompressFormat(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'png':
        return CompressFormat.png;
      case 'webp':
        return CompressFormat.webp;
      default:
        return CompressFormat.jpeg;
    }
  }

  /// Get all attachments for a journal entry
  Future<List<JournalAttachment>> getJournalAttachments(String journalId) async {
    try {
      final response = await _supabase
          .from('journal_attachments')
          .select()
          .eq('journal_id', journalId)
          .order('uploaded_at_utc', ascending: true);

      return response.map<JournalAttachment>((row) {
        return JournalAttachment(
          attachmentId: row['attachment_id'] as String,
          journalId: row['journal_id'] as String,
          fileUrl: row['file_url'] as String,
          fileName: row['file_name'] as String? ?? 'unknown',
          uploadedBy: row['uploaded_by'] as String?,
          uploadedAtUtc: row['uploaded_at_utc'] != null
              ? DateTime.parse(row['uploaded_at_utc'] as String)
              : null,
        );
      }).toList();
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'JournalEntry: Failed to fetch attachments',
        extra: {'journalId': journalId},
      );
      throw Exception('Failed to fetch attachments: $e');
    }
  }

  /// Delete an attachment from storage and database
  Future<void> deleteAttachment({
    required String attachmentId,
    required String fileUrl,
  }) async {
    try {
      // Extract storage path from URL
      final storagePath = _extractStoragePathFromUrl(fileUrl);

      // Delete from storage
      if (storagePath.isNotEmpty) {
        await _supabase.storage.from(_bucketName).remove([storagePath]);
      }

      // Delete from database
      await _supabase
          .from('journal_attachments')
          .delete()
          .eq('attachment_id', attachmentId);
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'JournalEntry: Failed to delete attachment',
        extra: {'attachmentId': attachmentId},
      );
      throw Exception('Failed to delete attachment: $e');
    }
  }

  /// Extract storage path from public URL
  String _extractStoragePathFromUrl(String fileUrl) {
    try {
      final uri = Uri.parse(fileUrl);
      final pathSegments = uri.pathSegments;

      // Find the bucket name index and extract the path after it
      final bucketIndex = pathSegments.indexOf(_bucketName);
      if (bucketIndex != -1 && bucketIndex < pathSegments.length - 1) {
        return pathSegments.sublist(bucketIndex + 1).join('/');
      }

      return '';
    } catch (e) {
      return '';
    }
  }

  /// Get MIME type from file name
  String _getMimeType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }

  /// Check if file is an image
  bool _isImageFile(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'webp', 'gif'].contains(ext);
  }

  /// Create signed URL for private bucket access
  Future<String> createSignedUrl(String storagePath, {int expiresIn = 3600}) async {
    try {
      final signedUrl = await _supabase.storage
          .from(_bucketName)
          .createSignedUrl(storagePath, expiresIn);
      return signedUrl;
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'JournalEntry: Failed to create signed URL',
        extra: {'storagePath': storagePath},
      );
      throw Exception('Failed to create signed URL: $e');
    }
  }
}
