/// Quick Transaction Builder - Business logic for creating transactions from quick templates
///
/// Purpose: Handles the complex business logic of building transactions:
/// - Builds transaction lines from template data
/// - Handles cash location resolution
/// - Manages counterparty information
/// - Formats data for RPC calls
/// - Provides error handling and validation
///
/// Usage: QuickTransactionBuilder.build(template, amount, selections)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../providers/app_state_provider.dart';
import '../../../../providers/auth_provider.dart';

class QuickTransactionBuilder {
  /// Build and execute a transaction from a quick template
  static Future<void> createTransaction({
    required WidgetRef ref,
    required Map<String, dynamic> template,
    required double amount,
    String? description,
    String? selectedMyCashLocationId,
    String? selectedCounterpartyId,
    String? selectedCounterpartyCashLocationId,
  }) async {
    final supabase = Supabase.instance.client;
    final appState = ref.read(appStateProvider);
    final user = ref.read(authStateProvider);
    
    if (user == null) throw Exception('User not authenticated');
    
    // Build transaction lines from template
    final pLines = await _buildQuickTransactionLines(
      template: template,
      amount: amount,
      selectedMyCashLocationId: selectedMyCashLocationId,
      selectedCounterpartyId: selectedCounterpartyId,
    );
    
    // Extract main counterparty info
    final mainCounterpartyId = _extractMainCounterpartyId(template, selectedCounterpartyId);
    
    // Format entry date
    final entryDate = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(DateTime.now());
    
    // Prepare RPC parameters
    final rpcParams = {
      'p_base_amount': amount,
      'p_company_id': appState.companyChoosen,
      'p_created_by': user.id,
      'p_description': description,
      'p_entry_date': entryDate,
      'p_lines': pLines,
      'p_counterparty_id': mainCounterpartyId,
      'p_if_cash_location_id': selectedCounterpartyCashLocationId,
      'p_store_id': appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null,
    };
    
    // Call RPC to create transaction
    await supabase.rpc('insert_journal_with_everything', params: rpcParams);
  }
  
  static Future<List<Map<String, dynamic>>> _buildQuickTransactionLines({
    required Map<String, dynamic> template,
    required double amount,
    String? selectedMyCashLocationId,
    String? selectedCounterpartyId,
  }) async {
    final lines = <Map<String, dynamic>>[];
    final templateData = template['data'] as List? ?? [];
    final tags = template['tags'] as Map? ?? {};
    
    // Get cash location info if needed
    Map<String, dynamic>? myCashLocationData;
    if (selectedMyCashLocationId != null) {
      myCashLocationData = await _getCashLocationData(selectedMyCashLocationId!);
    } else {
      // Try to get from template tags
      final tagsCashLocations = tags['cash_locations'] as List? ?? [];
      if (tagsCashLocations.isNotEmpty) {
        final cashLocationId = tagsCashLocations.first as String?;
        if (cashLocationId != null && cashLocationId != 'none') {
          myCashLocationData = await _getCashLocationData(cashLocationId);
        }
      }
    }
    
    // Build lines from template
    for (var templateLine in templateData) {
      final line = <String, dynamic>{
        'account_id': templateLine['account_id'],
        'description': templateLine['description'] ?? '',
      };
      
      // Set amounts
      if (templateLine['type'] == 'debit') {
        line['debit'] = amount.toString();
        line['credit'] = '0';
      } else {
        line['debit'] = '0';
        line['credit'] = amount.toString();
      }
      
      // Add counterparty info if present
      final counterpartyId = templateLine['counterparty_id'] ?? selectedCounterpartyId;
      if (counterpartyId != null) {
        line['counterparty_id'] = counterpartyId;
      }
      
      // Handle cash accounts
      if (templateLine['category_tag'] == 'cash' && myCashLocationData != null) {
        line['cash'] = {
          'cash_location_id': myCashLocationData['cash_location_id'],
          'cash_location_name': myCashLocationData['location_name'] ?? '',
        };
      }
      
      // For quick templates, skip complex debt configuration
      // Users can use detailed mode for debt tracking
      
      lines.add(line);
    }
    
    return lines;
  }
  
  static Future<Map<String, dynamic>?> _getCashLocationData(String cashLocationId) async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('cash_locations')
          .select('cash_location_id, location_name')
          .eq('cash_location_id', cashLocationId)
          .maybeSingle();
      return response;
    } catch (e) {
      // Return null if cash location not found
      return null;
    }
  }
  
  static String? _extractMainCounterpartyId(
    Map<String, dynamic> template,
    String? selectedCounterpartyId,
  ) {
    // Use selected counterparty if provided
    if (selectedCounterpartyId != null) {
      return selectedCounterpartyId;
    }
    
    // Use template's counterparty_id if available
    final templateCounterpartyId = template['counterparty_id'];
    if (templateCounterpartyId != null && templateCounterpartyId.toString().isNotEmpty) {
      return templateCounterpartyId.toString();
    }
    
    // Look for counterparty in template data
    final data = template['data'] as List? ?? [];
    for (var line in data) {
      final counterpartyId = line['counterparty_id'];
      if (counterpartyId != null && counterpartyId.toString().isNotEmpty) {
        return counterpartyId.toString();
      }
    }
    
    return null;
  }
  
  /// Validate that a template can be processed with quick builder
  static QuickBuilderValidation validateTemplate(Map<String, dynamic> template) {
    final errors = <String>[];
    final warnings = <String>[];
    
    // Check for required template structure
    final data = template['data'] as List? ?? [];
    if (data.isEmpty) {
      errors.add('Template has no transaction data');
    }
    
    // Check for complex debt requirements
    bool hasComplexDebt = false;
    for (var line in data) {
      final categoryTag = line['category_tag'] as String? ?? '';
      if (categoryTag == 'payable' || categoryTag == 'receivable') {
        // Check if this requires complex debt configuration
        final hasInterest = line['interest_rate'] != null && (line['interest_rate'] as num? ?? 0) > 0;
        final hasSpecificDates = line['due_date'] != null || line['issue_date'] != null;
        if (hasInterest || hasSpecificDates) {
          hasComplexDebt = true;
          warnings.add('Template contains complex debt configuration that will be simplified');
        }
      }
    }
    
    return QuickBuilderValidation(
      canProcess: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      hasComplexDebt: hasComplexDebt,
    );
  }
}

class QuickBuilderValidation {
  final bool canProcess;
  final List<String> errors;
  final List<String> warnings;
  final bool hasComplexDebt;
  
  const QuickBuilderValidation({
    required this.canProcess,
    required this.errors,
    required this.warnings,
    required this.hasComplexDebt,
  });
}