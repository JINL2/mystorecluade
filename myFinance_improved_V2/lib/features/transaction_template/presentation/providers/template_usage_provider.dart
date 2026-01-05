import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:myfinance_improved/app/providers/app_state_provider.dart' as Legacy;
import 'package:myfinance_improved/app/providers/auth_providers.dart';
import 'package:myfinance_improved/shared/widgets/selectors/exchange_rate/index.dart';

import '../../data/providers/repository_providers.dart';
import '../../domain/entities/template_attachment.dart';
import '../../domain/validators/template_form_validator.dart';
import 'states/template_usage_state.dart';
import 'use_case_providers.dart';

/// Template Usage Provider - Family로 템플릿 ID별 상태 관리
final templateUsageNotifierProvider = NotifierProvider.autoDispose
    .family<TemplateUsageFamilyNotifier, TemplateUsageState, String>(
  TemplateUsageFamilyNotifier.new,
);

/// Family Notifier for template-specific state
class TemplateUsageFamilyNotifier
    extends AutoDisposeFamilyNotifier<TemplateUsageState, String> {
  @override
  TemplateUsageState build(String arg) {
    return const TemplateUsageState();
  }

  /// RPC를 통해 템플릿 사용 정보 로드
  Future<void> loadTemplateForUsage(Map<String, dynamic> template) async {
    try {
      final appState = ref.read(Legacy.appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;
      final templateId = template['template_id']?.toString() ?? '';

      if (templateId.isEmpty || companyId.isEmpty) {
        state = state.copyWith(
          isLoadingRpc: false,
          rpcError: 'Invalid template or company ID',
        );
        return;
      }

      final dataSource = ref.read(templateDataSourceProvider);
      final response = await dataSource.getTemplateForUsage(
        templateId: templateId,
        companyId: companyId,
        storeId: storeId.isNotEmpty ? storeId : null,
      );

      if (!response.success) {
        state = state.copyWith(
          isLoadingRpc: false,
          rpcError: response.message ?? 'Failed to load template',
        );
        return;
      }

      final defaults = response.defaults;
      state = state.copyWith(
        rpcResponse: response,
        isLoadingRpc: false,
        clearRpcError: true,
        selectedMyCashLocationId: defaults?.cashLocationId,
        selectedCounterpartyId: defaults?.counterpartyId,
        selectedCounterpartyStoreId: defaults?.counterpartyStoreId,
        selectedCounterpartyCashLocationId: defaults?.counterpartyCashLocationId,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingRpc: false,
        rpcError: 'Error loading template: ${e.toString()}',
      );
    }
  }

  /// 다중 통화 확인 (환율 계산기 버튼 표시 여부)
  Future<void> checkForMultipleCurrencies() async {
    final appState = ref.read(Legacy.appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      state = state.copyWith(hasMultipleCurrencies: false);
      return;
    }

    try {
      final exchangeRatesData = await ref.read(
        calculatorExchangeRateDataProvider(
          CalculatorExchangeRateParams(companyId: companyId),
        ).future,
      );
      final exchangeRates =
          exchangeRatesData['exchange_rates'] as List? ?? [];
      state = state.copyWith(hasMultipleCurrencies: exchangeRates.length > 1);
    } catch (e) {
      state = state.copyWith(hasMultipleCurrencies: false);
    }
  }

  /// 금액 업데이트 및 유효성 검사
  void updateAmount(String value) {
    final error = TemplateFormValidator.validateAmountField(value);
    state = state.copyWith(
      amount: value,
      amountError: error,
      clearAmountError: error == null,
    );
  }

  /// 설명 업데이트
  void updateDescription(String value) {
    state = state.copyWith(description: value);
  }

  /// 현금 위치 선택
  void selectCashLocation(String? id) {
    String? error;
    if (state.showCashLocationSelector && id == null) {
      error = 'Cash location is required';
    }
    state = state.copyWith(
      selectedMyCashLocationId: id,
      cashLocationError: error,
      clearCashLocationError: error == null,
    );
  }

  /// 거래처 선택
  void selectCounterparty(String? id) {
    String? error;
    if (state.showCounterpartySelector && id == null) {
      error = 'Counterparty is required';
    }
    state = state.copyWith(
      selectedCounterpartyId: id,
      counterpartyError: error,
      clearCounterpartyError: error == null,
    );
  }

  /// 거래처 매장 선택
  void selectCounterpartyStore(String? id) {
    state = state.copyWith(selectedCounterpartyStoreId: id);
  }

  /// 거래처 현금 위치 선택
  void selectCounterpartyCashLocation(String? id) {
    state = state.copyWith(selectedCounterpartyCashLocationId: id);
  }

  /// 템플릿 상세 표시 토글
  void toggleTemplateDetails() {
    state = state.copyWith(showTemplateDetails: !state.showTemplateDetails);
  }

  /// 첨부파일 업데이트
  void updateAttachments(List<TemplateAttachment> attachments) {
    state = state.copyWith(pendingAttachments: attachments);
  }

  /// 트랜잭션 생성 제출
  Future<bool> submitTransaction(Map<String, dynamic> template) async {
    if (state.isSubmitting) return false;

    // Validate form
    if (!state.isFormValid) {
      state = state.copyWith(
        submitError: _getValidationErrorMessage(),
      );
      return false;
    }

    state = state.copyWith(
      isSubmitting: true,
      clearSubmitError: true,
      clearSubmitSuccess: true,
    );

    try {
      final cleanAmount =
          state.amount.replaceAll(',', '').replaceAll(' ', '');
      final amount = double.parse(cleanAmount);

      final journalId = await _createTransactionFromTemplate(template, amount);

      state = state.copyWith(
        isSubmitting: false,
        submitSuccess: journalId,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        submitError: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  /// 에러 메시지 초기화
  void clearErrors() {
    state = state.copyWith(
      clearSubmitError: true,
      clearAmountError: true,
      clearCashLocationError: true,
      clearCounterpartyError: true,
    );
  }

  /// 유효성 검사 에러 메시지 생성
  String _getValidationErrorMessage() {
    final amountError = TemplateFormValidator.validateAmountField(state.amount);
    if (amountError != null) return amountError;
    if (state.showCashLocationSelector &&
        state.selectedMyCashLocationId == null) {
      return 'Please select a cash location';
    }
    if (state.showCounterpartySelector &&
        state.selectedCounterpartyId == null) {
      return 'Please select a counterparty';
    }
    if (state.showCounterpartyStoreSelector &&
        state.selectedCounterpartyStoreId == null) {
      return 'Please select a counterparty store';
    }
    if (state.showCounterpartyCashLocationSelector &&
        state.selectedCounterpartyCashLocationId == null) {
      return 'Please select a counterparty cash location';
    }
    if (!state.attachmentRequirementSatisfied) {
      return 'Attachment is required for this template';
    }
    return 'Please fill in all required fields';
  }

  /// 템플릿에서 트랜잭션 생성
  Future<String> _createTransactionFromTemplate(
    Map<String, dynamic> template,
    double amount,
  ) async {
    final legacyAppState = ref.read(Legacy.appStateProvider);
    final user = ref.read(currentUserProvider);

    if (user == null) {
      throw Exception('User not authenticated');
    }

    final companyId = legacyAppState.companyChoosen;
    final storeId = legacyAppState.storeChoosen;
    final userId = user.id;

    final rpcService = ref.read(templateRpcServiceProvider);

    final result = await rpcService.createTransaction(
      template: template,
      amount: amount,
      companyId: companyId,
      storeId: storeId,
      userId: userId,
      description: state.description.isEmpty ? null : state.description,
      selectedCashLocationId: state.selectedMyCashLocationId,
      selectedCounterpartyId: state.selectedCounterpartyId,
      selectedCounterpartyStoreId: state.selectedCounterpartyStoreId,
      selectedCounterpartyCashLocationId:
          state.selectedCounterpartyCashLocationId,
      entryDate: DateTime.now(),
    );

    return result.when(
      success: (journalId, message, createdAt) async {
        // Handle attachments
        if (state.pendingAttachments.isNotEmpty) {
          final pendingFiles = state.pendingAttachments
              .where((a) => a.localFile != null)
              .map((a) => a.localFile!)
              .toList();

          if (pendingFiles.isNotEmpty) {
            final uploadAttachments =
                ref.read(uploadTemplateAttachmentsProvider);
            await uploadAttachments(companyId, journalId, userId, pendingFiles);
          }
        }
        return journalId;
      },
      failure: (errorCode, errorMessage, fieldErrors, isRecoverable,
          technicalDetails) {
        String message = errorMessage;
        if (fieldErrors.isNotEmpty) {
          final fieldErrorMessages = fieldErrors
              .map((e) => '• ${e.fieldName}: ${e.message}')
              .join('\n');
          message = '$errorMessage\n\n$fieldErrorMessages';
        }
        throw Exception(message);
      },
    );
  }
}

/// Form validity provider for external button state
final templateUsageFormValidProvider =
    Provider.autoDispose.family<bool, String>((ref, templateId) {
  final state = ref.watch(templateUsageNotifierProvider(templateId));
  return state.isFormValid;
});

/// Submission state provider for external button state
final templateUsageSubmittingProvider =
    Provider.autoDispose.family<bool, String>((ref, templateId) {
  final state = ref.watch(templateUsageNotifierProvider(templateId));
  return state.isSubmitting;
});
