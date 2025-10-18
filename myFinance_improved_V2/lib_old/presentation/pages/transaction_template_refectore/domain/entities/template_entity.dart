import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../validators/template_validation_result.dart';
import '../enums/template_enums.dart';
import '../enums/template_constants.dart';
import '../exceptions/template_business_exception.dart';

/// Core business entity representing a transaction template
/// 
/// A transaction template defines a reusable pattern for creating transactions.
/// All transaction details are stored in the 'data' JSONB array.
class TransactionTemplate extends Equatable {
  /// Unique identifier for this template
  final String templateId;
  
  /// Human-readable name for the template (2-100 characters)
  final String name;
  
  /// Optional description providing additional context
  final String? templateDescription;
  
  /// 🚨 CORE: Transaction data JSONB array - contains all transaction lines
  /// Each line: {account_id, debit, credit, description, cash?, debt?, fix_asset?}
  final List<Map<String, dynamic>> data;
  
  /// Template categorization tags
  final Map<String, dynamic> tags;
  
  /// Template visibility and permission
  final String visibilityLevel;
  final String permission;
  
  /// Business context information
  final String companyId;
  final String storeId;
  
  /// Single counterparty ID (for templates with counterparty)
  final String? counterpartyId;
  
  /// Counterparty cash location (for internal transactions)
  final String? counterpartyCashLocationId;
  
  /// Template creation and modification metadata
  final String? createdBy;  // Nullable: DB may not have this field
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? updatedBy;
  final bool isActive;

  const TransactionTemplate({
    required this.templateId,
    required this.name,
    this.templateDescription,
    required this.data,
    required this.tags,
    required this.visibilityLevel,
    required this.permission,
    required this.companyId,
    required this.storeId,
    this.counterpartyId,
    this.counterpartyCashLocationId,
    this.createdBy,  // Optional parameter
    required this.createdAt,
    required this.updatedAt,
    this.updatedBy,
    this.isActive = true,
  });

  /// 🏛️ DOMAIN API: Convenient access to template ID
  /// This getter provides API compatibility while maintaining domain integrity
  String get id => templateId;

  /// 🏛️ DOMAIN API: Convenient access to template description
  /// This getter provides API compatibility while maintaining domain integrity
  String? get description => templateDescription;

  /// 🏛️ DOMAIN API: Check if template is public
  /// This getter provides API compatibility while maintaining domain integrity
  bool get isPublic => visibilityLevel == 'public';

  /// Factory constructor for creating a new template
  factory TransactionTemplate.create({
    required String name,
    String? templateDescription,
    required List<Map<String, dynamic>> data,
    required String visibilityLevel,
    required String permission,
    required String companyId,
    required String storeId,
    String? counterpartyId,
    String? counterpartyCashLocationId,
    String? createdBy,  // ✅ Optional: DB may not have this field, legacy compatibility
    Map<String, dynamic>? tags,
  }) {
    final templateId = _generateTemplateId();
    final now = DateTime.now();

    return TransactionTemplate(
      templateId: templateId,
      name: name,
      templateDescription: templateDescription,
      data: data,
      tags: tags ?? {},
      visibilityLevel: visibilityLevel,
      permission: permission,
      companyId: companyId,
      storeId: storeId,
      counterpartyId: counterpartyId,
      counterpartyCashLocationId: counterpartyCashLocationId,
      createdBy: createdBy,  // Can be null for legacy DB compatibility
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Analyzes the business complexity of this template based on data structure
  FormComplexity analyzeComplexity() {
    bool hasCounterparty = false;
    bool hasCashLocation = false;
    bool hasCounterpartyCashLocation = counterpartyCashLocationId != null;
    
    // Analyze data array for complexity indicators
    for (final line in data) {
      if (line['debt'] != null) {
        hasCounterparty = true;
      }
      if (line['cash'] != null) {
        hasCashLocation = true;
      }
    }
    
    // Simplified complexity logic based on UI requirements
    if (hasCounterparty && hasCashLocation && hasCounterpartyCashLocation) {
      return FormComplexity.complex;
    }
    
    if (hasCounterparty && hasCounterpartyCashLocation) {
      return FormComplexity.withCounterparty;
    }
    
    if (hasCashLocation) {
      return FormComplexity.withCash;
    }
    
    return FormComplexity.simple; // "Just enter these:" - amount, note, cash location
  }

  /// Validates the template's internal consistency (ENHANCED for DB requirements)
  TemplateValidationResult validate() {
    final errors = <String>[];

    // 1. Basic template validation
    if (name.trim().isEmpty) {
      errors.add('Template name is required');
    } else if (name.trim().length < 2) {
      errors.add('Template name must be at least 2 characters');
    } else if (name.trim().length > 100) {
      errors.add('Template name must not exceed 100 characters');
    }

    if (templateDescription != null && templateDescription!.length > 500) {
      errors.add('Description cannot exceed 500 characters');
    }

    if (!_isValidVisibilityLevel(visibilityLevel)) {
      errors.add('Invalid visibility level');
    }

    if (!_isValidPermission(permission)) {
      errors.add('Invalid permission level');
    }

    // 2. 🚨 CRITICAL: Validate data JSONB structure (matches DB requirements)
    final dataValidationErrors = _validateDataJSONBStructure();
    errors.addAll(dataValidationErrors);

    // 3. 🚨 CRITICAL: Validate debit/credit balance
    final balanceValidationErrors = _validateDebitCreditBalance();
    errors.addAll(balanceValidationErrors);

    // 4. 🚨 ENHANCED: Cash object validation
    final cashValidationErrors = _validateCashObjects();
    errors.addAll(cashValidationErrors);

    // 5. 🚨 ENHANCED: Debt object validation  
    final debtValidationErrors = _validateDebtObjects();
    errors.addAll(debtValidationErrors);

    // 6. 🚨 ENHANCED: Fixed asset object validation
    final assetValidationErrors = _validateFixedAssetObjects();
    errors.addAll(assetValidationErrors);

    return TemplateValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// 🚨 CRITICAL: Validates data JSONB structure according to DB requirements
  /// 
  /// This ensures the template's data array matches the exact structure
  /// required by insert_journal_with_everything RPC function
  List<String> _validateDataJSONBStructure() {
    final errors = <String>[];

    // Check if data exists and is not empty
    if (data.isEmpty) {
      errors.add('📊 Template must have at least one journal line in data array');
      return errors;
    }

    // Validate each journal line
    for (int i = 0; i < data.length; i++) {
      final line = data[i];
      final lineNum = i + 1;

      // Check required fields: account_id, debit, credit
      if (line['account_id'] == null || line['account_id'].toString().trim().isEmpty) {
        errors.add('📋 Line $lineNum: account_id is required');
      }

      if (line['debit'] == null) {
        errors.add('📋 Line $lineNum: debit field is required (use "0" if no debit)');
      }

      if (line['credit'] == null) {
        errors.add('📋 Line $lineNum: credit field is required (use "0" if no credit)');
      }

      // Validate debit/credit format
      if (line['debit'] != null) {
        final debitStr = line['debit'].toString();
        if (!_isValidAmountFormat(debitStr)) {
          errors.add('💰 Line $lineNum: debit must be a valid number format');
        }
      }

      if (line['credit'] != null) {
        final creditStr = line['credit'].toString();
        if (!_isValidAmountFormat(creditStr)) {
          errors.add('💰 Line $lineNum: credit must be a valid number format');
        }
      }

      // Check that line has either debit OR credit (not both as non-zero in templates)
      if (line['debit'] != null && line['credit'] != null) {
        final debit = double.tryParse(line['debit'].toString()) ?? 0;
        final credit = double.tryParse(line['credit'].toString()) ?? 0;
        if (debit > 0 && credit > 0) {
          errors.add('⚖️ Line $lineNum: a line cannot have both debit and credit amounts (one should be "0")');
        }
      }
    }

    return errors;
  }

  /// 🚨 CRITICAL: Validates debit/credit balance in template data
  ///
  /// For templates, this checks the structure balance even with "0" amounts
  List<String> _validateDebitCreditBalance() {
    final errors = <String>[];

    if (data.isEmpty) return errors;

    double totalDebit = 0;
    double totalCredit = 0;
    int debitLineCount = 0;
    int creditLineCount = 0;

    for (final line in data) {
      final debit = double.tryParse(line['debit']?.toString() ?? '0') ?? 0;
      final credit = double.tryParse(line['credit']?.toString() ?? '0') ?? 0;

      totalDebit += debit;
      totalCredit += credit;

      if (debit > 0) debitLineCount++;
      if (credit > 0) creditLineCount++;
    }

    // For templates with actual amounts (not all "0")
    if (totalDebit > 0 || totalCredit > 0) {
      if (totalDebit != totalCredit) {
        errors.add('⚖️ Debit total (${totalDebit.toStringAsFixed(0)}) must equal credit total (${totalCredit.toStringAsFixed(0)})');
      }

      // Only validate line counts if there are actual amounts
      // Template structure validation - must have at least one debit and one credit line
      if (debitLineCount == 0) {
        errors.add('📊 Template must have at least one debit line (debit > 0)');
      }

      if (creditLineCount == 0) {
        errors.add('📊 Template must have at least one credit line (credit > 0)');
      }
    } else {
      // ✅ FIX: For templates with all "0" amounts, just check that we have at least 2 lines
      // (one will be used as debit, one as credit when template is applied)
      if (data.length < 2) {
        errors.add('📊 Template must have at least 2 lines (one for debit, one for credit)');
      }
    }

    return errors;
  }

  /// 🚨 ENHANCED: Validates cash objects in data lines
  /// 
  /// According to DB requirements: cash: {cash_location_id: "uuid"}
  List<String> _validateCashObjects() {
    final errors = <String>[];

    for (int i = 0; i < data.length; i++) {
      final line = data[i];
      final lineNum = i + 1;

      // Check if line has cash object
      if (line['cash'] != null) {
        final cashObj = line['cash'];
        
        if (cashObj is! Map) {
          errors.add('💰 Line $lineNum: cash must be an object/map');
          continue;
        }

        final cashMap = cashObj as Map;

        // Validate required cash_location_id
        if (cashMap['cash_location_id'] == null || 
            cashMap['cash_location_id'].toString().trim().isEmpty) {
          errors.add('💰 Line $lineNum: cash object requires cash_location_id');
        }

        // ✅ REMOVED: Account type check - cannot determine from UUID account_id
        // _getAccountType() checks string keywords, but account_id is a UUID
        // Factory ensures correct structure based on categoryTag during creation
        // This validation would require account repository access (breaks Domain layer isolation)
      }
    }

    return errors;
  }

  /// 🚨 ENHANCED: Validates debt objects in data lines
  /// 
  /// According to DB requirements: debt: {counterparty_id, direction, category, ...}
  List<String> _validateDebtObjects() {
    final errors = <String>[];

    for (int i = 0; i < data.length; i++) {
      final line = data[i];
      final lineNum = i + 1;

      // Check if line has debt object
      if (line['debt'] != null) {
        final debtObj = line['debt'];
        
        if (debtObj is! Map) {
          errors.add('👥 Line $lineNum: debt must be an object/map');
          continue;
        }

        final debtMap = debtObj as Map;

        // Validate required fields
        if (debtMap['counterparty_id'] == null || 
            debtMap['counterparty_id'].toString().trim().isEmpty) {
          errors.add('👥 Line $lineNum: debt object requires counterparty_id');
        }

        if (debtMap['direction'] == null || 
            debtMap['direction'].toString().trim().isEmpty) {
          errors.add('👥 Line $lineNum: debt object requires direction (receivable/payable)');
        } else {
          final direction = debtMap['direction'].toString();
          if (direction != 'receivable' && direction != 'payable') {
            errors.add('👥 Line $lineNum: debt direction must be "receivable" or "payable"');
          }
        }

        if (debtMap['category'] == null || 
            debtMap['category'].toString().trim().isEmpty) {
          errors.add('👥 Line $lineNum: debt object requires category (sales/purchase/etc)');
        }

        // 🚨 ENHANCED: Validate internal transaction fields (mirror entry requirements)
        if (debtMap['linkedCounterparty_companyId'] != null &&
            debtMap['linkedCounterparty_companyId'].toString().trim().isNotEmpty) {

          // Internal transaction requires store ID
          if (debtMap['linkedCounterparty_store_id'] == null ||
              debtMap['linkedCounterparty_store_id'].toString().trim().isEmpty) {
            errors.add('🔗 Line $lineNum: internal debt transaction requires linkedCounterparty_store_id for mirror entry');
          }

          // ✅ REMOVED: Company ID validation - Same company internal transactions allowed
          // Scenario: Store-to-store transfers within same company (e.g., inventory transfer between stores)
          // linkedCounterparty_companyId CAN be same as template company_id

          // ✅ REMOVED: Category validation per user request
          // Categories are not restricted for internal transactions
        }

        // ✅ REMOVED: Account type check - cannot determine from UUID account_id
        // _getAccountType() checks string keywords, but account_id is a UUID
        // Factory ensures correct structure based on categoryTag during creation
        // This validation would require account repository access (breaks Domain layer isolation)
      }
    }

    return errors;
  }

  /// 🚨 ENHANCED: Validates fixed asset objects in data lines
  /// 
  /// According to DB requirements: fix_asset: {asset_name, acquisition_date, useful_life_years, ...}
  List<String> _validateFixedAssetObjects() {
    final errors = <String>[];

    for (int i = 0; i < data.length; i++) {
      final line = data[i];
      final lineNum = i + 1;

      // Check if line has fix_asset object
      if (line['fix_asset'] != null) {
        final assetObj = line['fix_asset'];
        
        if (assetObj is! Map) {
          errors.add('🏢 Line $lineNum: fix_asset must be an object/map');
          continue;
        }

        final assetMap = assetObj as Map;

        // Validate required fields
        if (assetMap['asset_name'] == null || 
            assetMap['asset_name'].toString().trim().isEmpty) {
          errors.add('🏢 Line $lineNum: fix_asset object requires asset_name');
        }

        if (assetMap['acquisition_date'] == null || 
            assetMap['acquisition_date'].toString().trim().isEmpty) {
          errors.add('🏢 Line $lineNum: fix_asset object requires acquisition_date');
        } else {
          // Validate date format
          final dateStr = assetMap['acquisition_date'].toString();
          if (!_isValidDateFormat(dateStr)) {
            errors.add('🏢 Line $lineNum: acquisition_date must be in YYYY-MM-DD format');
          }
        }

        if (assetMap['useful_life_years'] == null || 
            assetMap['useful_life_years'].toString().trim().isEmpty) {
          errors.add('🏢 Line $lineNum: fix_asset object requires useful_life_years');
        } else {
          // Validate useful life is a positive number
          final yearsStr = assetMap['useful_life_years'].toString();
          final years = double.tryParse(yearsStr);
          if (years == null || years <= 0) {
            errors.add('🏢 Line $lineNum: useful_life_years must be a positive number');
          }
        }

        // Validate salvage_value if provided
        if (assetMap['salvage_value'] != null) {
          final salvageStr = assetMap['salvage_value'].toString();
          if (!_isValidAmountFormat(salvageStr)) {
            errors.add('🏢 Line $lineNum: salvage_value must be a valid number format');
          }
        }

        // ✅ REMOVED: Account type check - cannot determine from UUID account_id
        // _getAccountType() checks string keywords, but account_id is a UUID
        // Factory ensures correct structure based on categoryTag during creation
        // This validation would require account repository access (breaks Domain layer isolation)
      }
    }

    return errors;
  }

  /// Determines account type from account ID or name
  AccountType _getAccountType(String accountId) {
    final accountLower = accountId.toLowerCase();
    
    if (accountLower.contains('cash')) return AccountType.cash;
    if (accountLower.contains('payable')) return AccountType.payable;
    if (accountLower.contains('receivable')) return AccountType.receivable;
    if (accountLower.contains('bank')) return AccountType.bank;
    if (accountLower.contains('revenue')) return AccountType.revenue;
    if (accountLower.contains('expense')) return AccountType.expense;
    if (accountLower.contains('asset')) return AccountType.asset;
    if (accountLower.contains('liability')) return AccountType.liability;
    
    return AccountType.other;
  }

  /// Validates amount format (numeric string)
  bool _isValidAmountFormat(String amount) {
    if (amount.trim().isEmpty) return false;
    final parsedAmount = double.tryParse(amount);
    return parsedAmount != null && parsedAmount >= 0;
  }

  /// Validates date format (YYYY-MM-DD)
  bool _isValidDateFormat(String date) {
    if (date.trim().isEmpty) return false;
    
    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(date)) return false;
    
    try {
      DateTime.parse(date);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Validates if this template can create transactions with the given amount
  bool canCreateTransactionWithAmount(double amount) {
    return amount > 0; // Simplified - just check positive amount
  }

  /// Creates a copy with updated values
  TransactionTemplate copyWith({
    String? templateId,
    String? name,
    String? templateDescription,
    List<Map<String, dynamic>>? data,
    Map<String, dynamic>? tags,
    String? visibilityLevel,
    String? permission,
    String? companyId,
    String? storeId,
    String? counterpartyId,
    String? counterpartyCashLocationId,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? updatedBy,
    bool? isActive,
  }) {
    return TransactionTemplate(
      templateId: templateId ?? this.templateId,
      name: name ?? this.name,
      templateDescription: templateDescription ?? this.templateDescription,
      data: data ?? this.data,
      tags: tags ?? this.tags,
      visibilityLevel: visibilityLevel ?? this.visibilityLevel,
      permission: permission ?? this.permission,
      companyId: companyId ?? this.companyId,
      storeId: storeId ?? this.storeId,
      counterpartyId: counterpartyId ?? this.counterpartyId,
      counterpartyCashLocationId: counterpartyCashLocationId ?? this.counterpartyCashLocationId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      updatedBy: updatedBy ?? this.updatedBy,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        templateId,
        name,
        templateDescription,
        data,
        tags,
        visibilityLevel,
        permission,
        companyId,
        storeId,
        counterpartyId,
        counterpartyCashLocationId,
        createdBy,
        createdAt,
        updatedAt,
        updatedBy,
        isActive,
      ];

  static String _generateTemplateId() {
    return const Uuid().v4();
  }

  /// Validation helper methods
  static bool _isValidVisibilityLevel(String level) {
    return VisibilityLevels.isValid(level);
  }

  static bool _isValidPermission(String permission) {
    // Permission should be a valid UUID (either manager or common)
    return permission == TemplateConstants.managerPermissionUUID ||
           permission == TemplateConstants.commonPermissionUUID;
  }
}