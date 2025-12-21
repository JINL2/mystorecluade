import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'states/transaction_state.dart';
import 'validator_providers.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/usecases/create_transaction_usecase.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/value_objects/transaction_context.dart';
import '../../domain/providers/repository_providers.dart'; // ✅ Changed from data to domain

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Transaction Creation Notifier - 트랜잭션 생성 상태 관리
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// Flutter 표준 구조: Notifier가 직접 UseCase/Repository 호출
class TransactionCreationNotifier extends StateNotifier<TransactionCreationState> {
  final CreateTransactionUseCase _createUseCase;
  final TransactionRepository _repository;

  TransactionCreationNotifier({
    required CreateTransactionUseCase createUseCase,
    required TransactionRepository repository,
  })  : _createUseCase = createUseCase,
        _repository = repository,
        super(const TransactionCreationState());

  /// 템플릿에서 트랜잭션 생성 (직접 UseCase 호출)
  Future<bool> createFromTemplate({
    required String templateId,
    required String debitAccountId,
    required String creditAccountId,
    required double amount,
    required DateTime transactionDate,
    required String createdBy,
    required TransactionContext context,
    String? description,
    String? referenceNumber,
  }) async {
    state = state.copyWith(
      isCreating: true,
      errorMessage: null,
      fieldErrors: {},
    );

    try {
      // ✅ Flutter 표준: UseCase 직접 호출 (Controller 없음)
      final result = await _createUseCase.execute(
        CreateTransactionCommand(
          templateId: templateId,
          debitAccountId: debitAccountId,
          creditAccountId: creditAccountId,
          amount: amount,
          transactionDate: transactionDate,
          createdBy: createdBy,
          context: context,
          description: description,
          referenceNumber: referenceNumber,
        ),
      );

      if (result.isSuccess && result.transaction != null) {
        state = state.copyWith(
          isCreating: false,
          createdTransaction: result.transaction,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isCreating: false,
          errorMessage: result.errorMessage ?? 'Unknown error occurred',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isCreating: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// 양식 필드 업데이트
  void updateFormField({
    String? selectedTemplateId,
    double? amount,
    String? note,
    String? cashLocationId,
    String? counterpartyId,
  }) {
    state = state.copyWith(
      selectedTemplateId: selectedTemplateId ?? state.selectedTemplateId,
      amount: amount ?? state.amount,
      note: note ?? state.note,
      cashLocationId: cashLocationId ?? state.cashLocationId,
      counterpartyId: counterpartyId ?? state.counterpartyId,
    );
  }

  /// 필드 검증
  Future<void> validateField(String fieldName, dynamic value) async {
    state = state.copyWith(isValidating: true);

    try {
      String? error;

      switch (fieldName) {
        case 'amount':
          if (value == null || (value as double) <= 0) {
            error = 'Amount must be greater than 0';
          }
          break;
        case 'template':
          if (value == null || (value as String).isEmpty) {
            error = 'Please select a template';
          }
          break;
        case 'cashLocation':
          if (value == null || (value as String).isEmpty) {
            error = 'Please select a cash location';
          }
          break;
        case 'counterparty':
          if (value == null || (value as String).isEmpty) {
            error = 'Please select a counterparty';
          }
          break;
      }

      if (error != null) {
        final updatedErrors = Map<String, String>.from(state.fieldErrors);
        updatedErrors[fieldName] = error;
        state = state.copyWith(
          isValidating: false,
          fieldErrors: updatedErrors,
        );
      } else {
        final updatedErrors = Map<String, String>.from(state.fieldErrors);
        updatedErrors.remove(fieldName);
        state = state.copyWith(
          isValidating: false,
          fieldErrors: updatedErrors,
        );
      }
    } catch (e) {
      final updatedErrors = Map<String, String>.from(state.fieldErrors);
      updatedErrors[fieldName] = e.toString();
      state = state.copyWith(
        isValidating: false,
        fieldErrors: updatedErrors,
      );
    }
  }

  /// 필드 에러 설정
  void setFieldError(String fieldName, String error) {
    final updatedErrors = Map<String, String>.from(state.fieldErrors);
    updatedErrors[fieldName] = error;
    state = state.copyWith(fieldErrors: updatedErrors);
  }

  /// 필드 에러 지우기
  void clearFieldError(String fieldName) {
    final updatedErrors = Map<String, String>.from(state.fieldErrors);
    updatedErrors.remove(fieldName);
    state = state.copyWith(fieldErrors: updatedErrors);
  }

  /// 상태 초기화
  void reset() {
    state = const TransactionCreationState();
  }
}

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Providers (DI)
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Transaction Creation Provider
final transactionCreationProvider = StateNotifierProvider<TransactionCreationNotifier, TransactionCreationState>((ref) {
  return TransactionCreationNotifier(
    createUseCase: ref.read(createTransactionUseCaseProvider),
    repository: ref.read(transactionRepositoryProvider),
  );
});

/// UseCase Providers (Domain Layer DI)
final createTransactionUseCaseProvider = Provider<CreateTransactionUseCase>((ref) {
  return CreateTransactionUseCase(
    transactionRepository: ref.read(transactionRepositoryProvider),
    transactionValidator: ref.read(transactionValidatorProvider),
  );
});
