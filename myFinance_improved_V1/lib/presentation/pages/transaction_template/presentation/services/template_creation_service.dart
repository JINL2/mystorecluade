/// Template Creation Service - Business logic for creating transaction templates
///
/// Purpose: Handles the complex process of template creation:
/// - Builds template data arrays from form selections
/// - Constructs tags for categorization and filtering
/// - Manages RPC calls to create templates in database
/// - Handles optimistic UI updates and error recovery
/// - Provides success/error dialog management
///
/// Usage: TemplateCreationService.createTemplate(ref, templateData)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/app_state_provider.dart';
import '../../../../providers/entities/account_provider.dart';
import '../../../../providers/entities/cash_location_provider.dart';
import '../../../../../data/services/transaction_template_service.dart';
import '../../../../../data/services/supabase_service.dart';
import '../../data/providers/template_filter_provider.dart';
import '../../../../../core/themes/toss_colors.dart';
import '../../../../../core/themes/toss_text_styles.dart';
import '../../../../../core/themes/toss_spacing.dart';
import '../../../../../core/themes/toss_border_radius.dart';

class TemplateCreationService {
  /// Create a new transaction template
  static Future<TemplateCreationResult> createTemplate({
    required WidgetRef ref,
    required TemplateCreationData templateData,
  }) async {
    try {
      // Get app state data
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;
      final userId = appState.user['user_id'] as String;
      
      // Build template data array
      final dataArray = await _buildTemplateDataArray(ref, templateData);
      
      // Build tags for categorization
      final tags = await _buildTemplateTags(ref, templateData);
      
      // Determine template-level counterparty information
      final counterpartyInfo = _determineTemplateCounterparty(templateData);
      
      // Create the template via service
      final templateService = TransactionTemplateService(ref.read(supabaseServiceProvider));
      
      await templateService.createTemplate(
        name: templateData.name,
        description: templateData.description,
        companyId: companyId,
        storeId: storeId,
        userId: userId,
        data: dataArray,
        tags: tags,
        visibilityLevel: templateData.visibilityLevel,
        permission: templateData.permission,
        counterpartyId: counterpartyInfo.counterpartyId,
        counterpartyCashLocationId: counterpartyInfo.cashLocationId,
      );
      
      // Create optimistic template for immediate UI update
      final optimisticTemplate = _buildOptimisticTemplate(
        templateData: templateData,
        dataArray: dataArray,
        tags: tags,
        counterpartyInfo: counterpartyInfo,
        appState: appState,
      );
      
      // Refresh template provider
      ref.invalidate(filteredTransactionTemplatesProvider);
      
      return TemplateCreationResult.success(optimisticTemplate);
      
    } catch (e) {
      return TemplateCreationResult.error(e.toString());
    }
  }
  
  /// Show success dialog
  static Future<void> showSuccessDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: TossColors.successLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: TossColors.success,
                  size: 40,
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'Success!',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'Template created successfully',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TossTextStyles.button.copyWith(
                  color: TossColors.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  
  /// Show error dialog
  static Future<void> showErrorDialog(BuildContext context, String error) async {
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: TossColors.errorLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: TossColors.error,
                  size: 40,
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'Error',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'Failed to create template',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                error,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'OK',
                style: TossTextStyles.button.copyWith(
                  color: TossColors.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  
  // Private helper methods
  
  static Future<List<Map<String, dynamic>>> _buildTemplateDataArray(
    WidgetRef ref,
    TemplateCreationData templateData,
  ) async {
    // Get account details
    final debitAccount = await ref.read(accountByIdProvider(templateData.selectedDebitAccountId!).future);
    final creditAccount = await ref.read(accountByIdProvider(templateData.selectedCreditAccountId!).future);
    
    // Get cash location names
    String? debitCashLocationName;
    String? creditCashLocationName;
    
    if (templateData.selectedDebitMyCashLocationId != null) {
      final cashLocation = await ref.read(cashLocationByIdProvider(templateData.selectedDebitMyCashLocationId!).future);
      debitCashLocationName = cashLocation?.name;
    }
    
    if (templateData.selectedCreditMyCashLocationId != null) {
      final cashLocation = await ref.read(cashLocationByIdProvider(templateData.selectedCreditMyCashLocationId!).future);
      creditCashLocationName = cashLocation?.name;
    }
    
    return [
      {
        "type": "debit",
        "debit": "0",
        "amount": "0",
        "credit": "0",
        "account_id": templateData.selectedDebitAccountId,
        "description": null,
        "account_name": debitAccount?.name,
        "category_tag": debitAccount?.categoryTag,
        "counterparty_id": templateData.selectedDebitCounterpartyId,
        "cash_location_id": templateData.selectedDebitMyCashLocationId,
        "counterparty_name": templateData.selectedDebitCounterpartyData?['name'],
        "cash_location_name": debitCashLocationName,
        "counterparty_cash_location_id": templateData.selectedDebitCashLocationId,
      },
      {
        "type": "credit",
        "debit": "0",
        "amount": "0",
        "credit": "0",
        "account_id": templateData.selectedCreditAccountId,
        "description": null,
        "account_name": creditAccount?.name,
        "category_tag": creditAccount?.categoryTag,
        "counterparty_id": templateData.selectedCreditCounterpartyId,
        "cash_location_id": templateData.selectedCreditMyCashLocationId,
        "counterparty_name": templateData.selectedCreditCounterpartyData?['name'],
        "cash_location_name": creditCashLocationName,
        "counterparty_cash_location_id": templateData.selectedCreditCashLocationId,
      },
    ];
  }
  
  static Future<Map<String, dynamic>> _buildTemplateTags(
    WidgetRef ref,
    TemplateCreationData templateData,
  ) async {
    // Get account details for category tags
    final debitAccount = await ref.read(accountByIdProvider(templateData.selectedDebitAccountId!).future);
    final creditAccount = await ref.read(accountByIdProvider(templateData.selectedCreditAccountId!).future);
    
    // Build account IDs list
    final accountIds = [templateData.selectedDebitAccountId!, templateData.selectedCreditAccountId!];
    
    // Build cash location IDs list
    final cashLocationIds = <String>[];
    if (templateData.selectedDebitMyCashLocationId != null) {
      cashLocationIds.add(templateData.selectedDebitMyCashLocationId!);
    }
    if (templateData.selectedCreditMyCashLocationId != null) {
      cashLocationIds.add(templateData.selectedCreditMyCashLocationId!);
    }
    
    // Build categories list from actual category tags
    final categories = <String>[];
    if (debitAccount?.categoryTag != null) {
      categories.add(debitAccount!.categoryTag!);
    }
    if (creditAccount?.categoryTag != null) {
      categories.add(creditAccount!.categoryTag!);
    }
    
    // Remove duplicates
    final uniqueCategories = categories.toSet().toList();
    
    // Determine counterparty store ID
    String? counterpartyStoreId;
    if (templateData.selectedDebitStoreId != null) {
      counterpartyStoreId = templateData.selectedDebitStoreId;
    } else if (templateData.selectedCreditStoreId != null) {
      counterpartyStoreId = templateData.selectedCreditStoreId;
    }
    
    final tags = {
      "accounts": accountIds,
      "categories": uniqueCategories,
      "cash_locations": cashLocationIds,
    };
    
    if (counterpartyStoreId != null) {
      tags["counterparty_store_id"] = [counterpartyStoreId];
    }
    
    return tags;
  }
  
  static TemplateCounterpartyInfo _determineTemplateCounterparty(TemplateCreationData templateData) {
    // Prioritize debit counterparty, fallback to credit
    if (templateData.selectedDebitCounterpartyId != null) {
      return TemplateCounterpartyInfo(
        counterpartyId: templateData.selectedDebitCounterpartyId,
        cashLocationId: templateData.selectedDebitCashLocationId,
      );
    } else if (templateData.selectedCreditCounterpartyId != null) {
      return TemplateCounterpartyInfo(
        counterpartyId: templateData.selectedCreditCounterpartyId,
        cashLocationId: templateData.selectedCreditCashLocationId,
      );
    }
    
    return TemplateCounterpartyInfo(
      counterpartyId: null,
      cashLocationId: null,
    );
  }
  
  static Map<String, dynamic> _buildOptimisticTemplate({
    required TemplateCreationData templateData,
    required List<Map<String, dynamic>> dataArray,
    required Map<String, dynamic> tags,
    required TemplateCounterpartyInfo counterpartyInfo,
    required dynamic appState,
  }) {
    return {
      'template_id': 'temp_${DateTime.now().millisecondsSinceEpoch}',
      'name': templateData.name,
      'template_description': templateData.description,
      'data': dataArray,
      'permission': templateData.permission,
      'tags': tags,
      'visibility_level': templateData.visibilityLevel,
      'is_active': true,
      'company_id': appState.companyChoosen,
      'store_id': appState.storeChoosen,
      'counterparty_id': counterpartyInfo.counterpartyId,
      'counterparty_cash_location_id': counterpartyInfo.cashLocationId,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}

class TemplateCreationData {
  final String name;
  final String? description;
  final String? selectedDebitAccountId;
  final String? selectedCreditAccountId;
  final String? selectedDebitCounterpartyId;
  final Map<String, dynamic>? selectedDebitCounterpartyData;
  final String? selectedCreditCounterpartyId;
  final Map<String, dynamic>? selectedCreditCounterpartyData;
  final String? selectedDebitStoreId;
  final String? selectedDebitCashLocationId;
  final String? selectedCreditStoreId;
  final String? selectedCreditCashLocationId;
  final String? selectedDebitMyCashLocationId;
  final String? selectedCreditMyCashLocationId;
  final String visibilityLevel;
  final String permission;
  
  const TemplateCreationData({
    required this.name,
    this.description,
    this.selectedDebitAccountId,
    this.selectedCreditAccountId,
    this.selectedDebitCounterpartyId,
    this.selectedDebitCounterpartyData,
    this.selectedCreditCounterpartyId,
    this.selectedCreditCounterpartyData,
    this.selectedDebitStoreId,
    this.selectedDebitCashLocationId,
    this.selectedCreditStoreId,
    this.selectedCreditCashLocationId,
    this.selectedDebitMyCashLocationId,
    this.selectedCreditMyCashLocationId,
    required this.visibilityLevel,
    required this.permission,
  });
}

class TemplateCounterpartyInfo {
  final String? counterpartyId;
  final String? cashLocationId;
  
  const TemplateCounterpartyInfo({
    this.counterpartyId,
    this.cashLocationId,
  });
}

class TemplateCreationResult {
  final bool isSuccess;
  final String? error;
  final Map<String, dynamic>? optimisticTemplate;
  
  const TemplateCreationResult._({
    required this.isSuccess,
    this.error,
    this.optimisticTemplate,
  });
  
  factory TemplateCreationResult.success(Map<String, dynamic> template) {
    return TemplateCreationResult._(
      isSuccess: true,
      optimisticTemplate: template,
    );
  }
  
  factory TemplateCreationResult.error(String error) {
    return TemplateCreationResult._(
      isSuccess: false,
      error: error,
    );
  }
}