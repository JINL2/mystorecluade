import '../../../data/dtos/template_usage_response_dto.dart';
import '../../../domain/entities/template_attachment.dart';
import '../../../domain/enums/template_enums.dart';
import '../../../domain/value_objects/template_analysis_result.dart';

/// Template Usage State - 템플릿 사용 모달 UI 상태
///
/// Riverpod Provider로 관리되어 위젯 라이프사이클과 독립적으로 동작.
/// "Looking up a deactivated widget's ancestor" 에러를 방지.
class TemplateUsageState {
  // RPC Response
  final TemplateUsageResponseDto? rpcResponse;
  final bool isLoadingRpc;
  final String? rpcError;

  // Form values
  final String amount;
  final String description;

  // Selection state
  final String? selectedMyCashLocationId;
  final String? selectedCounterpartyId;
  final String? selectedCounterpartyStoreId;
  final String? selectedCounterpartyCashLocationId;

  // UI state
  final bool showTemplateDetails;
  final bool hasMultipleCurrencies;

  // Validation errors
  final String? amountError;
  final String? cashLocationError;
  final String? counterpartyError;

  // Attachments
  final List<TemplateAttachment> pendingAttachments;

  // Submission state
  final bool isSubmitting;
  final String? submitError;
  final String? submitSuccess;

  const TemplateUsageState({
    this.rpcResponse,
    this.isLoadingRpc = true,
    this.rpcError,
    this.amount = '',
    this.description = '',
    this.selectedMyCashLocationId,
    this.selectedCounterpartyId,
    this.selectedCounterpartyStoreId,
    this.selectedCounterpartyCashLocationId,
    this.showTemplateDetails = false,
    this.hasMultipleCurrencies = false,
    this.amountError,
    this.cashLocationError,
    this.counterpartyError,
    this.pendingAttachments = const [],
    this.isSubmitting = false,
    this.submitError,
    this.submitSuccess,
  });

  /// Determine RPC type from template data
  TemplateRpcType get rpcType {
    final templateData = rpcResponse?.template?.data;
    if (templateData == null || templateData.isEmpty) {
      return TemplateRpcType.unknown;
    }
    // Build template map for analysis
    final template = {
      'data': templateData,
      'name': rpcResponse?.template?.name,
    };
    return TemplateAnalysisResult.determineRpcType(template);
  }

  /// Check if this is a CashCash transfer (2 cash locations, no user selection)
  bool get isCashCashTransfer => rpcType == TemplateRpcType.cashCash;

  /// UI Config helpers
  /// NOTE: CashCash transfers have 2 different cash locations in template,
  /// so we should NOT show the cash location selector (it would override both!)
  bool get showCashLocationSelector {
    // CashCash: Never show selector - each line uses its own template value
    if (isCashCashTransfer) return false;
    return rpcResponse?.uiConfig?.showCashLocationSelector ?? false;
  }
  bool get showCounterpartySelector =>
      rpcResponse?.uiConfig?.showCounterpartySelector ?? false;
  bool get showCounterpartyStoreSelector =>
      rpcResponse?.uiConfig?.showCounterpartyStoreSelector ?? false;
  bool get showCounterpartyCashLocationSelector =>
      rpcResponse?.uiConfig?.showCounterpartyCashLocationSelector ?? false;

  /// Check if template requires attachment
  bool get requiresAttachment =>
      rpcResponse?.template?.requiredAttachment ?? false;

  /// Check if attachment requirement is satisfied
  bool get attachmentRequirementSatisfied {
    if (!requiresAttachment) return true;
    return pendingAttachments.isNotEmpty;
  }

  /// Comprehensive form validation
  bool get isFormValid {
    if (isLoadingRpc || rpcResponse == null) return false;
    if (amountError != null) return false;

    // Parse and validate amount
    final cleanAmount = amount.replaceAll(',', '').replaceAll(' ', '');
    final parsedAmount = double.tryParse(cleanAmount);
    if (parsedAmount == null || parsedAmount <= 0) return false;

    // Use getter methods that handle CashCash special case
    // CashCash: showCashLocationSelector returns false, so this check is skipped
    if (showCashLocationSelector && selectedMyCashLocationId == null) {
      return false;
    }

    if (showCounterpartySelector && selectedCounterpartyId == null) {
      return false;
    }

    if (showCounterpartyStoreSelector && selectedCounterpartyStoreId == null) {
      return false;
    }

    if (showCounterpartyCashLocationSelector &&
        selectedCounterpartyCashLocationId == null) {
      return false;
    }

    return attachmentRequirementSatisfied;
  }

  TemplateUsageState copyWith({
    TemplateUsageResponseDto? rpcResponse,
    bool? isLoadingRpc,
    String? rpcError,
    String? amount,
    String? description,
    String? selectedMyCashLocationId,
    String? selectedCounterpartyId,
    String? selectedCounterpartyStoreId,
    String? selectedCounterpartyCashLocationId,
    bool? showTemplateDetails,
    bool? hasMultipleCurrencies,
    String? amountError,
    String? cashLocationError,
    String? counterpartyError,
    List<TemplateAttachment>? pendingAttachments,
    bool? isSubmitting,
    String? submitError,
    String? submitSuccess,
    // Nullable clear flags
    bool clearRpcError = false,
    bool clearAmountError = false,
    bool clearCashLocationError = false,
    bool clearCounterpartyError = false,
    bool clearSubmitError = false,
    bool clearSubmitSuccess = false,
  }) {
    return TemplateUsageState(
      rpcResponse: rpcResponse ?? this.rpcResponse,
      isLoadingRpc: isLoadingRpc ?? this.isLoadingRpc,
      rpcError: clearRpcError ? null : (rpcError ?? this.rpcError),
      amount: amount ?? this.amount,
      description: description ?? this.description,
      selectedMyCashLocationId:
          selectedMyCashLocationId ?? this.selectedMyCashLocationId,
      selectedCounterpartyId:
          selectedCounterpartyId ?? this.selectedCounterpartyId,
      selectedCounterpartyStoreId:
          selectedCounterpartyStoreId ?? this.selectedCounterpartyStoreId,
      selectedCounterpartyCashLocationId: selectedCounterpartyCashLocationId ??
          this.selectedCounterpartyCashLocationId,
      showTemplateDetails: showTemplateDetails ?? this.showTemplateDetails,
      hasMultipleCurrencies:
          hasMultipleCurrencies ?? this.hasMultipleCurrencies,
      amountError: clearAmountError ? null : (amountError ?? this.amountError),
      cashLocationError: clearCashLocationError
          ? null
          : (cashLocationError ?? this.cashLocationError),
      counterpartyError: clearCounterpartyError
          ? null
          : (counterpartyError ?? this.counterpartyError),
      pendingAttachments: pendingAttachments ?? this.pendingAttachments,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError:
          clearSubmitError ? null : (submitError ?? this.submitError),
      submitSuccess:
          clearSubmitSuccess ? null : (submitSuccess ?? this.submitSuccess),
    );
  }
}
