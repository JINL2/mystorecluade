/// Create Transaction From Template Use Case - Business logic orchestration
///
/// Purpose: Orchestrates transaction creation from template:
/// - Converts template data to Transaction entity
/// - Extracts and resolves counterparty/cash location information
/// - Builds transaction lines with proper amounts
/// - Delegates persistence to Repository
///
/// Clean Architecture: DOMAIN LAYER - Use Case
///
/// **의존성 규칙**:
/// - ✅ Domain Layer만 의존 (Entities, Repositories, Value Objects)
/// - ❌ Data Layer 의존 금지 (repository_providers 등)
/// - ❌ Presentation Layer 의존 금지
library;
import '../repositories/transaction_repository.dart';

/// Input parameters for creating transaction from template
///
/// **데이터 흐름**:
/// Presentation → Use Case Params → Repository Params → Entity → RPC
class CreateTransactionFromTemplateParams {
  final Map<String, dynamic> template;
  final double amount;
  final String? description;
  final String? selectedMyCashLocationId;
  final String? selectedCounterpartyId;
  final String? selectedCounterpartyCashLocationId;
  final String companyId;
  final String userId;
  final String? storeId;

  const CreateTransactionFromTemplateParams({
    required this.template,
    required this.amount,
    this.description,
    this.selectedMyCashLocationId,
    this.selectedCounterpartyId,
    this.selectedCounterpartyCashLocationId,
    required this.companyId,
    required this.userId,
    this.storeId,
  });
}

/// Use case for creating transactions from templates
///
/// **Clean Architecture 준수**:
/// - Use Case는 Domain Layer에 위치
/// - Repository 인터페이스만 의존 (구현체는 DI로 주입)
/// - 비즈니스 로직 조율만 담당
class CreateTransactionFromTemplateUseCase {
  final TransactionRepository _transactionRepository;

  const CreateTransactionFromTemplateUseCase({
    required TransactionRepository transactionRepository,
  }) : _transactionRepository = transactionRepository;

  /// Execute: Create transaction from template
  /// Returns the created journal ID for attachment uploads
  ///
  /// **비즈니스 플로우**:
  /// 1. Use Case Params 받기
  /// 2. Repository Params로 변환
  /// 3. Repository에 위임
  /// 4. Journal ID 반환 (첨부파일 업로드용)
  Future<String> execute(CreateTransactionFromTemplateParams params) async {
    // ✅ SIMPLIFIED: Delegate to Repository's saveFromTemplate method
    // Repository handles all template → RPC conversion logic
    final repositoryParams = CreateFromTemplateParams(
      template: params.template,
      amount: params.amount,
      description: params.description,
      companyId: params.companyId,
      userId: params.userId,
      storeId: params.storeId,
      selectedMyCashLocationId: params.selectedMyCashLocationId,
      selectedCounterpartyId: params.selectedCounterpartyId,
      selectedCounterpartyCashLocationId: params.selectedCounterpartyCashLocationId,
      entryDate: DateTime.now(),
    );

    // Returns journal_id for attachment uploads
    return await _transactionRepository.saveFromTemplate(repositoryParams);
  }

  /// Extract counterparty ID from template or user selection
  String? _extractCounterpartyId(CreateTransactionFromTemplateParams params) {
    // Priority: user selection > template counterparty_id > template data
    if (params.selectedCounterpartyId != null) {
      return params.selectedCounterpartyId;
    }

    final templateCounterpartyId = params.template['counterparty_id'];
    if (templateCounterpartyId != null && templateCounterpartyId.toString().isNotEmpty) {
      return templateCounterpartyId.toString();
    }

    // Look for counterparty in template data
    final templateData = params.template['data'] as List? ?? [];
    for (var line in templateData) {
      final counterpartyId = line['counterparty_id'];
      if (counterpartyId != null && counterpartyId.toString().isNotEmpty) {
        return counterpartyId.toString();
      }
    }

    return null;
  }

  /// Extract counterparty name from template
  String? _extractCounterpartyName(CreateTransactionFromTemplateParams params) {
    final templateData = params.template['data'] as List? ?? [];
    for (var line in templateData) {
      final counterpartyName = line['counterparty_name'];
      if (counterpartyName != null && counterpartyName.toString().isNotEmpty) {
        return counterpartyName.toString();
      }
    }
    return null;
  }

  /// Extract cash location ID
  String? _extractCashLocationId(
    CreateTransactionFromTemplateParams params,
    Map<String, dynamic> debitEntry,
    Map<String, dynamic> creditEntry,
  ) {
    // Priority: user selection > entry cash_location_id
    if (params.selectedMyCashLocationId != null) {
      return params.selectedMyCashLocationId;
    }

    // Check debit entry
    final debitCashLocationId = debitEntry['cash_location_id'];
    if (debitCashLocationId != null && debitCashLocationId.toString().isNotEmpty) {
      return debitCashLocationId.toString();
    }

    // Check credit entry
    final creditCashLocationId = creditEntry['cash_location_id'];
    if (creditCashLocationId != null && creditCashLocationId.toString().isNotEmpty) {
      return creditCashLocationId.toString();
    }

    return null;
  }

  /// Extract cash location name
  String? _extractCashLocationName(
    CreateTransactionFromTemplateParams params,
    Map<String, dynamic> debitEntry,
    Map<String, dynamic> creditEntry,
  ) {
    // Check debit entry
    final debitCashLocationName = debitEntry['cash_location_name'];
    if (debitCashLocationName != null && debitCashLocationName.toString().isNotEmpty) {
      return debitCashLocationName.toString();
    }

    // Check credit entry
    final creditCashLocationName = creditEntry['cash_location_name'];
    if (creditCashLocationName != null && creditCashLocationName.toString().isNotEmpty) {
      return creditCashLocationName.toString();
    }

    return null;
  }

  /// Extract counterparty cash location ID
  String? _extractCounterpartyCashLocationId(CreateTransactionFromTemplateParams params) {
    // Priority: user selection > template counterparty_cash_location_id > template data
    if (params.selectedCounterpartyCashLocationId != null) {
      return params.selectedCounterpartyCashLocationId;
    }

    final templateCounterpartyCashLoc = params.template['counterparty_cash_location_id'];
    if (templateCounterpartyCashLoc != null && templateCounterpartyCashLoc.toString().isNotEmpty) {
      return templateCounterpartyCashLoc.toString();
    }

    // Look for counterparty cash location in template data
    final templateData = params.template['data'] as List? ?? [];
    for (var line in templateData) {
      final counterpartyCashLoc = line['counterparty_cash_location_id'];
      if (counterpartyCashLoc != null && counterpartyCashLoc.toString().isNotEmpty) {
        return counterpartyCashLoc.toString();
      }
    }

    return null;
  }
}
