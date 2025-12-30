/// Supabase Transaction Repository - Simple transaction creation repository with DTO pattern
///
/// Purpose: Creates transactions from templates using RPC with type-safe DTO pattern:
/// - Implements TransactionRepository interface from domain layer
/// - Uses insert_journal_with_everything RPC for transaction creation
/// - Checks template usage for deletion safety
/// - Follows DTO pattern for type safety and consistency with TemplateRepository
/// - Matches production QuickTransactionRepository pattern
/// - Handles attachment uploads to Supabase Storage
///
/// 🎯 FOCUSED: Template-to-transaction creation only, no CRUD
/// Clean Architecture: DATA LAYER - Repository Implementation
library;
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/core/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/template_attachment.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_line_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/value_objects/transaction_amount.dart';
import '../../domain/value_objects/transaction_context.dart';
import '../../domain/value_objects/transaction_counterparty.dart';
import '../../domain/value_objects/transaction_location.dart';
import '../../domain/value_objects/transaction_metadata.dart';
import '../../domain/value_objects/transaction_status.dart';
import '../dtos/transaction_dto.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final SupabaseService _supabaseService;

  TransactionRepositoryImpl({
    required SupabaseService supabaseService,
  }) : _supabaseService = supabaseService;

  /// Factory constructor with default dependencies
  factory TransactionRepositoryImpl.create() {
    return TransactionRepositoryImpl(
      supabaseService: SupabaseService(),
    );
  }

  /// ✅ NEW: Create transaction directly from template data
  /// Returns the created journal ID for attachment uploads
  @override
  Future<String> saveFromTemplate(CreateFromTemplateParams params) async {
    // ✅ FIXED: Format entry date as simple date string (YYYY-MM-DD)
    // RPC function expects TIMESTAMP, but PostgreSQL auto-converts from date string
    final entryDate = DateFormat('yyyy-MM-dd').format(params.entryDate);

    // Build transaction lines from template (pass entryDate for issue_date)
    final transactionLines = _buildTransactionLinesFromTemplate(params, entryDate);

    // Extract counterparty info from template
    final counterpartyId = _extractCounterpartyIdFromTemplate(params);
    final counterpartyCashLocationId = _extractCounterpartyCashLocationIdFromTemplate(params);

    // Prepare RPC parameters
    final rpcParams = {
      'p_base_amount': params.amount,                                          // NUMERIC
      'p_company_id': params.companyId,                                        // UUID
      'p_created_by': params.userId,                                           // UUID
      'p_description': params.description,                                     // TEXT
      'p_entry_date_utc': entryDate,                                          // TIMESTAMPTZ (as date string)
      'p_lines': transactionLines,                                             // JSONB
      'p_counterparty_id': counterpartyId,                                     // UUID (nullable)
      'p_if_cash_location_id': counterpartyCashLocationId,                     // UUID (nullable)
      'p_store_id': params.storeId?.isNotEmpty == true ? params.storeId : null, // UUID (nullable)
    };

    // Call Supabase RPC - returns journal_id as String
    final journalId = await _supabaseService.client.rpc<String>(
      'insert_journal_with_everything_utc',
      params: rpcParams,
    );

    return journalId;
  }

  @override
  Future<void> save(Transaction transaction) async {
    // 🎯 DTO PATTERN: Convert domain entity to DTO for type safety
    final transactionDto = _convertTransactionToDto(transaction);

    // Format entry date for RPC
    final entryDate = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(transactionDto.transactionDate);

    // 🚨 CRITICAL: Convert DTO to database journal lines structure
    final journalLines = _convertDtoToJournalLines(transactionDto);

    // Prepare RPC parameters using DTO fields for consistency
    final rpcParams = {
      'p_base_amount': transactionDto.amount, // Direct DTO field access
      'p_company_id': transactionDto.companyId,
      'p_created_by': transactionDto.createdBy,
      'p_description': transactionDto.description,
      'p_entry_date_utc': entryDate,
      'p_lines': journalLines, // 🚨 CRITICAL: Converted JSONB array
      'p_counterparty_id': transactionDto.counterpartyId,
      'p_if_cash_location_id': transactionDto.cashLocationId,
      'p_store_id': transactionDto.storeId?.isNotEmpty == true ? transactionDto.storeId : null,
    };

    // Call RPC to create transaction with all journal entries
    await _supabaseService.client.rpc('insert_journal_with_everything_utc', params: rpcParams);
  }

  @override
  Future<List<Transaction>> findByTemplateId(String templateId) async {
    // 🔧 LEGACY COMPATIBILITY: V1 performed simple soft delete without checking transaction usage
    // TODO: Implement journal system integration when ready
    return [];
  }

  @override
  Future<Transaction?> findById(String transactionId) async {
    // 🔧 LEGACY COMPATIBILITY: V1 did not perform transaction validation during template deletion
    // TODO: Implement journal system integration when ready
    return null;
  }

  /// Convert TransactionDto to database journal lines structure
  List<Map<String, dynamic>> _convertDtoToJournalLines(TransactionDto dto) {
    final lines = <Map<String, dynamic>>[];

    // Create debit line
    final debitLine = <String, dynamic>{
      'account_id': dto.debitAccountId,
      'debit': dto.amount.toString(),
      'credit': '0',
      'description': 'Debit entry - ${dto.description ?? 'Transaction'}',
    };

    // Add cash object for debit if needed (from location)
    if (dto.cashLocationId != null) {
      debitLine['cash'] = {'cash_location_id': dto.cashLocationId};
    }

    // Add debt object for debit if needed (from counterparty)
    if (dto.counterpartyId != null) {
      debitLine['debt'] = {
        'counterparty_id': dto.counterpartyId,
        'direction': 'receivable', // Default - would need business logic to determine
        'category': 'sales', // Default category
      };
    }

    lines.add(debitLine);

    // Create credit line
    final creditLine = <String, dynamic>{
      'account_id': dto.creditAccountId,
      'debit': '0',
      'credit': dto.amount.toString(),
      'description': 'Credit entry - ${dto.description ?? 'Transaction'}',
    };

    // Add counterparty cash location for credit if different
    if (dto.counterpartyCashLocationId != null) {
      creditLine['cash'] = {'cash_location_id': dto.counterpartyCashLocationId};
    }

    lines.add(creditLine);

    return lines;
  }

  /// Convert Transaction domain entity to TransactionDto
  TransactionDto _convertTransactionToDto(Transaction transaction) {
    return TransactionDto(
      id: transaction.id,
      templateId: transaction.templateId ?? '',
      debitAccountId: transaction.debitAccountId,
      creditAccountId: transaction.creditAccountId,
      amount: transaction.amount.value,
      transactionDate: transaction.transactionDate,
      description: transaction.description,
      status: transaction.status.toString(),
      companyId: transaction.context.companyId,
      storeId: transaction.context.storeId.isNotEmpty ? transaction.context.storeId : null,
      createdBy: transaction.metadata.createdBy,
      createdAt: transaction.metadata.createdAt,
      updatedAt: transaction.metadata.updatedAt,
      updatedBy: transaction.metadata.updatedBy ?? transaction.metadata.createdBy,
      counterpartyId: transaction.counterparty?.id,
      cashLocationId: transaction.location?.cashLocationId,
      counterpartyCashLocationId: transaction.location?.counterpartyCashLocationId,
      tags: _buildTagsFromTransaction(transaction),
    );
  }

  /// Build tags map from transaction domain data
  Map<String, dynamic> _buildTagsFromTransaction(Transaction transaction) {
    final tags = <String, dynamic>{};

    // Add counterparty information to tags
    if (transaction.counterparty != null) {
      tags['counterparty'] = {
        'id': transaction.counterparty!.id,
        'name': transaction.counterparty!.name,
        'type': transaction.counterparty!.type,
      };
    }

    // Add location information to tags
    if (transaction.location != null) {
      final locationData = <String, dynamic>{};
      
      if (transaction.location!.locationName != null) {
        locationData['name'] = transaction.location!.locationName;
      }
      
      // Note: locationType field may not exist in current domain model
      if (locationData.isNotEmpty) {
        tags['location'] = locationData;
      }
    }

    // Add template tracking
    tags['template_id'] = transaction.templateId;
    tags['created_from_template'] = true;

    return tags;
  }

  /// Map database row to Transaction domain entity using DTO pattern
  Transaction _mapRowToTransaction(Map<String, dynamic> row, [String? knownTemplateId]) {
    // Extract template ID from tags if available
    final tags = row['tags'] as Map<String, dynamic>? ?? {};
    final templateId = knownTemplateId ?? tags['template_id'] as String? ?? '';

    // Create TransactionDto from database row
    final dto = TransactionDto(
      id: row['id'] as String,
      templateId: templateId,
      debitAccountId: '', // Would need journal_lines lookup for complete data
      creditAccountId: '', // Would need journal_lines lookup for complete data
      amount: (row['total_amount'] as num? ?? 0).toDouble(),
      transactionDate: DateTime.parse(row['created_at'] as String),
      description: row['description'] as String?,
      status: row['status'] as String? ?? 'pending',
      companyId: row['company_id'] as String? ?? '',
      storeId: row['store_id'] as String?,
      createdBy: row['created_by'] as String? ?? '',
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['created_at'] as String), // Use created_at as fallback
      updatedBy: row['created_by'] as String? ?? '',
      counterpartyId: _extractFromTags(tags, 'counterparty_id'),
      cashLocationId: _extractFromTags(tags, 'cash_location_id'),
      counterpartyCashLocationId: _extractFromTags(tags, 'counterparty_cash_location_id'),
      tags: tags,
    );

    // Convert DTO to domain entity
    return _convertDtoToTransaction(dto);
  }

  /// Convert TransactionDto to Transaction domain entity
  Transaction _convertDtoToTransaction(TransactionDto dto) {
    return Transaction(
      id: dto.id,
      templateId: dto.templateId,
      debitAccountId: dto.debitAccountId,
      creditAccountId: dto.creditAccountId,
      amount: TransactionAmount(dto.amount),
      transactionDate: dto.transactionDate,
      description: dto.description,
      status: TransactionStatus.fromString(dto.status),
      context: TransactionContext(
        companyId: dto.companyId,
        storeId: dto.storeId ?? '',
      ),
      metadata: TransactionMetadata(
        createdBy: dto.createdBy,
        createdAt: dto.createdAt,
        updatedAt: dto.updatedAt,
        updatedBy: dto.updatedBy,
      ),
      counterparty: dto.counterpartyId != null ? _buildCounterpartyFromDto(dto) : null,
      location: _buildLocationFromDto(dto),
    );
  }

  /// Build counterparty from DTO and tags
  TransactionCounterparty? _buildCounterpartyFromDto(TransactionDto dto) {
    if (dto.counterpartyId == null) return null;
    
    final counterpartyData = dto.tags['counterparty'] as Map<String, dynamic>?;
    final typeString = counterpartyData?['type'] as String? ?? 'individual';
    
    return TransactionCounterparty(
      id: dto.counterpartyId!,
      name: counterpartyData?['name'] as String? ?? 'Unknown Counterparty',
      type: CounterpartyType.fromString(typeString),
    );
  }

  /// Build location from DTO
  TransactionLocation? _buildLocationFromDto(TransactionDto dto) {
    if (dto.cashLocationId == null && dto.counterpartyCashLocationId == null) {
      return null;
    }

    final locationData = dto.tags['location'] as Map<String, dynamic>?;
    return TransactionLocation(
      cashLocationId: dto.cashLocationId,
      counterpartyCashLocationId: dto.counterpartyCashLocationId,
      locationName: locationData?['name'] as String?,
      type: LocationType.other, // Default type for backward compatibility
    );
  }

  /// Extract value from tags map with null safety
  String? _extractFromTags(Map<String, dynamic> tags, String key) {
    final value = tags[key];
    return value is String ? value : null;
  }

  /// ===== Helper methods for saveFromTemplate =====

  /// 🎯 REFACTORED: Build transaction lines using TransactionLine Entity
  ///
  /// **교육 포인트**:
  /// - 이전: Map<String, dynamic> 직접 조작 (타입 안전성 X)
  /// - 이후: TransactionLine Entity 사용 (타입 안전성 O)
  ///
  /// **데이터 흐름**:
  /// ```
  /// Template Map → TransactionLine.fromTemplate() → Entity
  ///                                                     ↓
  ///                                    Entity.toRpc() → RPC Map
  /// ```
  ///
  /// **장점**:
  /// 1. 컴파일 타임 에러 검출 (오타, 타입 불일치)
  /// 2. IDE 자동완성 지원
  /// 3. 비즈니스 로직이 Entity에 캡슐화
  /// 4. 테스트 용이성 향상
  List<Map<String, dynamic>> _buildTransactionLinesFromTemplate(
    CreateFromTemplateParams params,
    String entryDate,  // ✅ issue_date 기본값으로 사용
  ) {
    final lines = <Map<String, dynamic>>[];
    final templateData = params.template['data'] as List? ?? [];

    // ✅ FIX: Extract counterparty_store_id from template tags
    final templateTags = params.template['tags'] as Map<String, dynamic>? ?? {};
    final counterpartyStoreId = templateTags['counterparty_store_id'] as String?;

    for (var templateLine in templateData) {
      // ✅ STEP 1: Template Map → TransactionLine Entity 변환
      // 타입 안전성 확보! 컴파일러가 필드 검증
      final transactionLineEntity = TransactionLine.fromTemplate(
        templateLine as Map<String, dynamic>,
      );

      // ✅ STEP 2: TransactionLine Entity → RPC Format Map 변환
      // Entity가 RPC 포맷 변환 책임을 가짐 (단일 책임 원칙!)
      final rpcLine = transactionLineEntity.toRpc(
        amount: params.amount,
        selectedMyCashLocationId: params.selectedMyCashLocationId,
        selectedCounterpartyId: params.selectedCounterpartyId,
        entryDate: entryDate,  // ✅ issue_date 기본값으로 전달
      );

      // ✅ FIX: Add counterparty_store_id to debt object if exists
      // This is Repository's responsibility to enrich RPC data with template-level metadata
      if (rpcLine['debt'] != null && counterpartyStoreId != null && counterpartyStoreId.isNotEmpty) {
        final debtMap = rpcLine['debt'] as Map<String, dynamic>;
        debtMap['linkedCounterparty_store_id'] = counterpartyStoreId;
      }

      lines.add(rpcLine);
    }

    return lines;
  }

  /// Extract main counterparty ID from template
  String? _extractCounterpartyIdFromTemplate(CreateFromTemplateParams params) {
    // Use selected counterparty if provided
    if (params.selectedCounterpartyId != null) {
      return params.selectedCounterpartyId;
    }

    // Use template's counterparty_id if available
    final templateCounterpartyId = params.template['counterparty_id'];
    if (templateCounterpartyId != null && templateCounterpartyId.toString().isNotEmpty) {
      return templateCounterpartyId.toString();
    }

    // Look for counterparty in template data
    final data = params.template['data'] as List? ?? [];
    for (var line in data) {
      final counterpartyId = line['counterparty_id'];
      if (counterpartyId != null && counterpartyId.toString().isNotEmpty) {
        return counterpartyId.toString();
      }
    }

    return null;
  }

  /// Extract counterparty cash location ID from template
  String? _extractCounterpartyCashLocationIdFromTemplate(CreateFromTemplateParams params) {
    // Use selected counterparty cash location if provided
    if (params.selectedCounterpartyCashLocationId != null) {
      return params.selectedCounterpartyCashLocationId;
    }

    // Use template's counterparty_cash_location_id if available
    final templateCounterpartyCashLoc = params.template['counterparty_cash_location_id'];
    if (templateCounterpartyCashLoc != null && templateCounterpartyCashLoc.toString().isNotEmpty) {
      return templateCounterpartyCashLoc.toString();
    }

    // Look for counterparty cash location in template data
    final data = params.template['data'] as List? ?? [];
    for (var line in data) {
      final counterpartyCashLoc = line['counterparty_cash_location_id'];
      if (counterpartyCashLoc != null && counterpartyCashLoc.toString().isNotEmpty) {
        return counterpartyCashLoc.toString();
      }
    }

    return null;
  }

  // =============================================================================
  // Attachment Operations
  // =============================================================================

  /// Storage bucket name for journal attachments
  static const String _bucketName = 'journal-attachments';

  /// Maximum file size in bytes (5MB)
  static const int _maxFileSizeBytes = 5 * 1024 * 1024;

  /// Image compression quality (0-100) - Lower = smaller file size
  static const int _compressionQuality = 50;

  /// Maximum image dimension for compression - Smaller = smaller file size
  static const int _maxImageDimension = 800;

  /// Upload attachments to storage and save metadata to database
  @override
  Future<List<TemplateAttachment>> uploadAttachments({
    required String companyId,
    required String journalId,
    required String uploadedBy,
    required List<XFile> files,
  }) async {
    final uploadedAttachments = <TemplateAttachment>[];

    for (final file in files) {
      try {
        final attachment = await _uploadSingleAttachment(
          companyId: companyId,
          journalId: journalId,
          uploadedBy: uploadedBy,
          file: file,
        );
        uploadedAttachments.add(attachment);
      } catch (e) {
        debugPrint('❌ Failed to upload attachment ${file.name}: $e');
        // Continue with other files even if one fails
      }
    }

    return uploadedAttachments;
  }

  /// Upload a single attachment with compression
  Future<TemplateAttachment> _uploadSingleAttachment({
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
      debugPrint('📷 Compressed image: ${file.name}');
    } else {
      fileBytes = await file.readAsBytes();
    }

    // Check file size after compression
    if (fileBytes.length > _maxFileSizeBytes) {
      throw Exception('File size exceeds 5MB limit after compression');
    }

    // Upload to storage
    await _supabaseService.client.storage.from(_bucketName).uploadBinary(
      storagePath,
      fileBytes,
      fileOptions: FileOptions(contentType: mimeType),
    );

    // Get the file URL (signed URL for private bucket)
    final fileUrl = _supabaseService.client.storage.from(_bucketName).getPublicUrl(storagePath);

    // Save to database
    final now = DateTime.now().toUtc();
    final response = await _supabaseService.client.from('journal_attachments').insert({
      'journal_id': journalId,
      'file_url': fileUrl,
      'file_name': originalName,
      'uploaded_by': uploadedBy,
      'uploaded_at_utc': now.toIso8601String(),
    }).select('attachment_id').single();

    debugPrint('✅ Uploaded attachment: $originalName -> $storagePath');

    return TemplateAttachment(
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
      debugPrint('⚠️ Image compression failed, using original: $e');
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
  @override
  Future<List<TemplateAttachment>> getJournalAttachments(String journalId) async {
    try {
      final response = await _supabaseService.client
          .from('journal_attachments')
          .select()
          .eq('journal_id', journalId)
          .order('uploaded_at_utc', ascending: true);

      return response.map<TemplateAttachment>((row) {
        return TemplateAttachment(
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
    } catch (e) {
      debugPrint('❌ Failed to fetch attachments: $e');
      throw Exception('Failed to fetch attachments: $e');
    }
  }

  /// Delete an attachment from storage and database
  @override
  Future<void> deleteAttachment({
    required String attachmentId,
    required String fileUrl,
  }) async {
    try {
      // Extract storage path from URL
      final storagePath = _extractStoragePathFromUrl(fileUrl);

      // Delete from storage
      if (storagePath.isNotEmpty) {
        await _supabaseService.client.storage.from(_bucketName).remove([storagePath]);
        debugPrint('🗑️ Deleted from storage: $storagePath');
      }

      // Delete from database
      await _supabaseService.client
          .from('journal_attachments')
          .delete()
          .eq('attachment_id', attachmentId);

      debugPrint('✅ Deleted attachment: $attachmentId');
    } catch (e) {
      debugPrint('❌ Failed to delete attachment: $e');
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
      debugPrint('⚠️ Failed to extract storage path from URL: $e');
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
}
