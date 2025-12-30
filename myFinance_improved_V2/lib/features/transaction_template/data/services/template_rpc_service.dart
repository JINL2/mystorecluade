/// Template RPC Service - Direct RPC calls for template-based transactions
///
/// Purpose: Executes RPC calls for creating transactions from templates:
/// - Calls insert_journal_with_everything_utc RPC directly
/// - Uses TemplateLinesBuilder to construct p_lines
/// - Uses TemplateLinesValidator for pre-validation
/// - Returns TemplateRpcResult for structured responses
///
/// This replaces the old create_transaction_from_template RPC approach.
/// Clean Architecture: DATA LAYER - Service (Infrastructure)
library;

import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:myfinance_improved/core/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/enums/template_enums.dart';
import '../../domain/services/template_lines_builder.dart';
import '../../domain/validators/template_lines_validator.dart';
import '../../domain/value_objects/template_analysis_result.dart';
import '../../domain/value_objects/template_defaults.dart';
import '../../domain/value_objects/template_rpc_result.dart';

/// Service for executing template-based transaction creation via RPC
///
/// Usage:
/// ```dart
/// final service = TemplateRpcService(supabaseService);
/// final result = await service.createTransaction(
///   template: templateData,
///   amount: 1000,
///   companyId: 'uuid',
///   storeId: 'uuid',
///   userId: 'uuid',
/// );
///
/// result.when(
///   success: (journalId, _, __) => print('Created: $journalId'),
///   failure: (code, message, _, __, ___) => print('Error: $message'),
/// );
/// ```
class TemplateRpcService {
  final SupabaseService _supabaseService;

  TemplateRpcService(this._supabaseService);

  /// Create transaction from template using direct RPC
  ///
  /// Parameters:
  /// - [template]: The template map containing 'data' array and metadata
  /// - [amount]: Transaction amount (required)
  /// - [companyId]: Company ID for the transaction
  /// - [storeId]: Store ID for the transaction
  /// - [userId]: User ID for audit trail
  /// - [description]: Optional description (uses template default if not provided)
  /// - [selectedCashLocationId]: User-selected cash location (overrides template)
  /// - [selectedCounterpartyId]: User-selected counterparty (for debt transactions)
  /// - [selectedCounterpartyStoreId]: For internal transfers
  /// - [selectedCounterpartyCashLocationId]: For internal transfers
  /// - [entryDate]: Transaction date (defaults to today)
  ///
  /// Returns: TemplateRpcResult (success with journalId or failure with error details)
  Future<TemplateRpcResult> createTransaction({
    required Map<String, dynamic> template,
    required double amount,
    required String companyId,
    required String storeId,
    required String userId,
    String? description,
    String? selectedCashLocationId,
    String? selectedCounterpartyId,
    String? selectedCounterpartyStoreId,
    String? selectedCounterpartyCashLocationId,
    DateTime? entryDate,
  }) async {
    try {
      _debugLog('═══════════════════════════════════════════════════════════════');
      _debugLog('🚀 TemplateRpcService.createTransaction() START');
      _debugLog('═══════════════════════════════════════════════════════════════');
      _debugLog('📝 Input Parameters:');
      _debugLog('   - template name: ${template['name']}');
      _debugLog('   - template id: ${template['id']}');
      _debugLog('   - amount: $amount');
      _debugLog('   - companyId: $companyId');
      _debugLog('   - storeId: $storeId');
      _debugLog('   - selectedCashLocationId: $selectedCashLocationId');
      _debugLog('   - selectedCounterpartyId: $selectedCounterpartyId');
      _debugLog('   - entryDate: $entryDate');
      _debugLog('');

      // 1. Determine RPC type
      _debugLog('📊 STEP 1: Determining RPC Type...');
      final rpcType = TemplateAnalysisResult.determineRpcType(template);
      _debugLog('   ✅ RPC Type: ${rpcType.name} (${rpcType.displayName})');
      if (rpcType == TemplateRpcType.unknown) {
        _debugLog('   ❌ FAILED: Unknown RPC type');
        return TemplateRpcResult.validationError(
          message: 'Unable to determine transaction type for this template',
        );
      }

      // 2. Extract defaults from template
      _debugLog('');
      _debugLog('📋 STEP 2: Extracting Template Defaults...');
      final defaults = TemplateDefaults.fromTemplate(template);
      _debugLog('   - cashLocationId: ${defaults.cashLocationId}');
      _debugLog('   - counterpartyId: ${defaults.counterpartyId}');
      _debugLog('   - counterpartyStoreId: ${defaults.counterpartyStoreId}');
      _debugLog('   - counterpartyCashLocationId: ${defaults.counterpartyCashLocationId}');
      _debugLog('   - linkedCompanyId: ${defaults.linkedCompanyId}');
      _debugLog('   - debtCategory: ${defaults.debtCategory}');
      _debugLog('   - debtDirection: ${defaults.debtDirection}');
      _debugLog('   - description: ${defaults.description}');
      _debugLog('   - baseAmount: ${defaults.baseAmount}');

      // 3. Build p_lines
      _debugLog('');
      _debugLog('🔧 STEP 3: Building p_lines...');
      final lines = TemplateLinesBuilder.build(
        template: template,
        amount: amount,
        rpcType: rpcType,
        defaults: defaults,
        selectedCashLocationId: selectedCashLocationId,
        selectedCounterpartyId: selectedCounterpartyId,
        selectedCounterpartyStoreId: selectedCounterpartyStoreId,
        selectedCounterpartyCashLocationId: selectedCounterpartyCashLocationId,
        entryDate: entryDate,
      );
      _debugLog('   ✅ Built ${lines.length} lines');
      _debugLogLines(lines);

      // 4. Validate lines
      _debugLog('');
      _debugLog('✔️ STEP 4: Validating lines...');
      final validationErrors = TemplateLinesValidator.validate(
        lines: lines,
        rpcType: rpcType,
        amount: amount,
      );

      if (validationErrors.isNotEmpty) {
        _debugLog('   ❌ VALIDATION FAILED: ${validationErrors.length} errors');
        for (var i = 0; i < validationErrors.length; i++) {
          final err = validationErrors[i];
          _debugLog('   Error $i: [${err.fieldName}] ${err.message}');
        }
        return TemplateRpcResult.validationError(
          message: validationErrors.first.message,
          fieldErrors: validationErrors
              .map((e) => FieldError(
                    fieldName: e.fieldName,
                    message: e.message,
                    invalidValue: e.fieldValue,
                  ),)
              .toList(),
        );
      }
      _debugLog('   ✅ Validation passed');

      // 5. Prepare RPC parameters (matching test_template_mapping_page.dart)
      _debugLog('');
      _debugLog('📦 STEP 5: Preparing RPC parameters...');
      final effectiveDescription =
          description ?? defaults.description ?? template['name']?.toString();
      final effectiveEntryDate = entryDate ?? DateTime.now();
      final entryDateUtc = effectiveEntryDate.toUtc().toIso8601String();

      // Extract counterparty_id and if_cash_location_id from defaults or selections
      final effectiveCounterpartyId = selectedCounterpartyId ?? defaults.counterpartyId;
      final effectiveIfCashLocationId = selectedCounterpartyCashLocationId ?? defaults.counterpartyCashLocationId;

      final rpcParams = {
        'p_base_amount': amount,
        'p_company_id': companyId,
        'p_created_by': userId,
        'p_description': effectiveDescription ?? 'Template transaction',
        'p_entry_date_utc': entryDateUtc,
        'p_lines': lines,
        'p_counterparty_id': effectiveCounterpartyId,
        'p_if_cash_location_id': effectiveIfCashLocationId,
        'p_store_id': storeId.isNotEmpty ? storeId : null,
      };
      _debugLog('   RPC Params:');
      _debugLog('   - p_base_amount: ${rpcParams['p_base_amount']}');
      _debugLog('   - p_company_id: ${rpcParams['p_company_id']}');
      _debugLog('   - p_created_by: ${rpcParams['p_created_by']}');
      _debugLog('   - p_entry_date_utc: ${rpcParams['p_entry_date_utc']}');
      _debugLog('   - p_description: ${rpcParams['p_description']}');
      _debugLog('   - p_counterparty_id: ${rpcParams['p_counterparty_id']}');
      _debugLog('   - p_if_cash_location_id: ${rpcParams['p_if_cash_location_id']}');
      _debugLog('   - p_store_id: ${rpcParams['p_store_id']}');
      _debugLog('   - p_lines: ${jsonEncode(lines)}');

      // 6. Execute RPC
      _debugLog('');
      _debugLog('🌐 STEP 6: Executing RPC (insert_journal_with_everything_utc)...');
      final response = await _supabaseService.client.rpc<dynamic>(
        'insert_journal_with_everything_utc',
        params: rpcParams,
      );

      // 7. Parse response
      // RPC returns journal_id directly as string (not wrapped in object)
      _debugLog('');
      _debugLog('📨 STEP 7: Parsing RPC response...');
      _debugLog('   Response type: ${response.runtimeType}');
      _debugLog('   Response: $response');

      if (response == null) {
        _debugLog('   ❌ Response is NULL');
        return const TemplateRpcResult.failure(
          errorCode: 'NULL_RESPONSE',
          errorMessage: 'RPC returned null response',
          isRecoverable: true,
        );
      }

      // Handle different response types
      TemplateRpcResult result;
      if (response is String) {
        // Direct journal_id string returned
        result = TemplateRpcResult.success(journalId: response);
      } else if (response is Map<String, dynamic>) {
        // Legacy format: {"success": true, "journal_id": "uuid"}
        result = TemplateRpcResult.fromRpcResponse(response);
      } else {
        // Try to use as string
        result = TemplateRpcResult.success(journalId: response.toString());
      }

      _debugLog('');
      _debugLog('═══════════════════════════════════════════════════════════════');
      if (result.isSuccess) {
        _debugLog('✅ SUCCESS: journal_id = ${result.journalIdOrNull}');
      } else {
        _debugLog('❌ FAILURE: ${result.errorMessageOrNull}');
      }
      _debugLog('═══════════════════════════════════════════════════════════════');
      return result;
    } on PostgrestException catch (e) {
      // Handle Supabase-specific errors
      _debugLog('');
      _debugLog('💥 PostgrestException: ${e.code} - ${e.message}');
      _debugLog('   Details: ${e.details}');
      return _handlePostgrestError(e);
    } on Exception catch (e) {
      // Handle general exceptions
      _debugLog('');
      _debugLog('💥 Exception: $e');
      return TemplateRpcResult.unknownError(
        message: 'Failed to create transaction',
        technicalDetails: e.toString(),
      );
    }
  }

  /// Debug logging helper (only prints in debug mode)
  void _debugLog(String message) {
    if (kDebugMode) {
      debugPrint('[TemplateRpcService] $message');
    }
  }

  /// Debug log p_lines array in formatted way
  void _debugLogLines(List<Map<String, dynamic>> lines) {
    if (!kDebugMode) return;
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final debit = line['debit'];
      final credit = line['credit'];
      final type = debit != null ? 'DR' : 'CR';
      final amount = debit ?? credit ?? 0;
      final hasCash = line['cash'] != null;
      final hasDebt = line['debt'] != null;
      _debugLog('   Line[$i]: $type $amount ${hasCash ? '[cash: ${line['cash']}]' : ''}${hasDebt ? '[debt: ${line['debt']}]' : ''}');
      _debugLog('            account_id: ${line['account_id']}');
    }
  }

  /// Handle PostgrestException and convert to TemplateRpcResult
  TemplateRpcResult _handlePostgrestError(PostgrestException e) {
    // Common error codes
    switch (e.code) {
      case '23505': // Unique constraint violation
        return const TemplateRpcResult.failure(
          errorCode: 'DUPLICATE_ENTRY',
          errorMessage: 'A similar transaction already exists',
          isRecoverable: false,
        );

      case '23503': // Foreign key constraint violation
        return const TemplateRpcResult.failure(
          errorCode: 'INVALID_REFERENCE',
          errorMessage: 'One or more referenced records no longer exist',
          isRecoverable: false,
        );

      case '23514': // Check constraint violation
        return const TemplateRpcResult.failure(
          errorCode: 'INVALID_DATA',
          errorMessage: 'Transaction data does not meet requirements',
          isRecoverable: true,
        );

      case 'PGRST116': // No rows returned
        return const TemplateRpcResult.failure(
          errorCode: 'NOT_FOUND',
          errorMessage: 'Required data not found',
          isRecoverable: false,
        );

      default:
        return TemplateRpcResult.failure(
          errorCode: e.code ?? 'DATABASE_ERROR',
          errorMessage: e.message,
          isRecoverable: true,
          technicalDetails: e.details?.toString(),
        );
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Utility Methods
  // ═══════════════════════════════════════════════════════════════════════════

  /// Validate template before transaction creation (dry run)
  ///
  /// Returns validation errors without executing RPC.
  /// Useful for UI validation before user submits.
  Future<List<FieldError>> validateTemplate({
    required Map<String, dynamic> template,
    required double amount,
    String? selectedCashLocationId,
    String? selectedCounterpartyId,
  }) async {
    final rpcType = TemplateAnalysisResult.determineRpcType(template);
    if (rpcType == TemplateRpcType.unknown) {
      return [
        const FieldError(
          fieldName: 'template',
          message: 'Unable to determine transaction type',
        ),
      ];
    }

    final defaults = TemplateDefaults.fromTemplate(template);
    final lines = TemplateLinesBuilder.build(
      template: template,
      amount: amount,
      rpcType: rpcType,
      defaults: defaults,
      selectedCashLocationId: selectedCashLocationId,
      selectedCounterpartyId: selectedCounterpartyId,
    );

    final errors = TemplateLinesValidator.validate(
      lines: lines,
      rpcType: rpcType,
      amount: amount,
    );

    return errors
        .map((e) => FieldError(
              fieldName: e.fieldName,
              message: e.message,
              invalidValue: e.fieldValue,
            ),)
        .toList();
  }

  /// Get preview of p_lines that would be sent to RPC
  ///
  /// Useful for debugging and UI preview.
  Map<String, dynamic> getPreview({
    required Map<String, dynamic> template,
    required double amount,
    String? selectedCashLocationId,
    String? selectedCounterpartyId,
  }) {
    final rpcType = TemplateAnalysisResult.determineRpcType(template);
    final defaults = TemplateDefaults.fromTemplate(template);
    final lines = TemplateLinesBuilder.build(
      template: template,
      amount: amount,
      rpcType: rpcType,
      defaults: defaults,
      selectedCashLocationId: selectedCashLocationId,
      selectedCounterpartyId: selectedCounterpartyId,
    );

    return {
      'rpc_type': rpcType.name,
      'rpc_type_display': rpcType.displayName,
      'lines_count': lines.length,
      'lines': lines,
      'summary': TemplateLinesBuilder.summarizeLines(lines),
    };
  }
}
