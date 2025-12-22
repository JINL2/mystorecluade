import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/repository_providers.dart'; // ✅ Clean Architecture: Presentation → Data
import '../../domain/constants/permission_constants.dart';
import '../../domain/entities/template_entity.dart';
import '../../domain/enums/template_constants.dart';
import '../../domain/repositories/template_repository.dart';
import '../../domain/usecases/create_template_usecase.dart';
import '../../domain/usecases/delete_template_usecase.dart';
import '../../domain/usecases/update_template_usecase.dart';
import '../../domain/value_objects/template_filter.dart';
import 'states/template_state.dart';
import 'use_case_providers.dart';
import 'validator_providers.dart';

part 'template_provider.g.dart';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Template Notifier - 상태 관리 + 비즈니스 로직 조율
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// Flutter 표준 구조: Notifier가 직접 UseCase/Repository 호출
/// Controller 레이어 없이 Domain Layer와 직접 통신
///
/// ✅ 2025 Riverpod: @riverpod 어노테이션 사용
@riverpod
class TemplateNotifier extends _$TemplateNotifier {
  late final CreateTemplateUseCase _createUseCase;
  late final DeleteTemplateUseCase _deleteUseCase;
  late final UpdateTemplateUseCase _updateUseCase;
  late final TemplateRepository _repository;

  @override
  TemplateState build() {
    _createUseCase = ref.read(createTemplateUseCaseProvider);
    _deleteUseCase = ref.read(deleteTemplateUseCaseProvider);
    _updateUseCase = ref.read(updateTemplateUseCaseProvider);
    _repository = ref.read(templateRepositoryProvider);
    return const TemplateState();
  }

  /// 템플릿 목록 로드 (직접 Repository 호출)
  Future<void> loadTemplates({
    required String companyId,
    String? storeId,
    bool includeInactive = false,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // ✅ Flutter 표준: Repository 직접 호출 (Controller 없음)
      final templates = await _repository.findByContext(
        companyId: companyId,
        storeId: storeId,
        isActive: includeInactive ? null : true,
      );

      state = state.copyWith(
        isLoading: false,
        templates: templates,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// 템플릿 생성 (직접 UseCase 호출)
  Future<bool> createTemplate(CreateTemplateCommand command) async {
    state = state.copyWith(isCreating: true, errorMessage: null);

    try {
      // ✅ Flutter 표준: UseCase 직접 호출 (Controller 없음)
      final result = await _createUseCase.execute(command);

      if (result.isSuccess) {
        state = state.copyWith(isCreating: false);

        // 자동 새로고침
        await loadTemplates(
          companyId: command.companyId,
          storeId: command.storeId,
        );

        return true;
      } else {
        state = state.copyWith(
          isCreating: false,
          errorMessage: result.errorMessage ?? 'Failed to create template',
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

  /// 템플릿 삭제 (직접 UseCase 호출)
  Future<bool> deleteTemplate(DeleteTemplateCommand command) async {
    state = state.copyWith(errorMessage: null);

    try {
      // ✅ Flutter 표준: UseCase 직접 호출
      final result = await _deleteUseCase.execute(command);

      if (result.isSuccess) {
        // 로컬 상태에서 삭제된 템플릿 제거
        final updatedTemplates = state.templates
            .where((template) => template.templateId != command.templateId)
            .toList();

        state = state.copyWith(
          templates: updatedTemplates,
          errorMessage: null,
        );

        return true;
      } else {
        state = state.copyWith(
          errorMessage: result.errorMessage ?? 'Failed to delete template',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  /// 템플릿 업데이트 (직접 UseCase 호출)
  Future<bool> updateTemplate(UpdateTemplateCommand command) async {
    state = state.copyWith(errorMessage: null);

    try {
      // ✅ Flutter 표준: UseCase 직접 호출
      final result = await _updateUseCase.execute(command);

      if (result.isSuccess) {
        // 업데이트된 템플릿 다시 로드
        final updatedTemplate = await _repository.findById(command.templateId);
        if (updatedTemplate != null) {
          // 로컬 상태에서 해당 템플릿 업데이트
          final updatedTemplates = state.templates.map((template) {
            if (template.templateId == command.templateId) {
              return updatedTemplate;
            }
            return template;
          }).toList();

          state = state.copyWith(
            templates: updatedTemplates,
            errorMessage: null,
          );
        }

        return true;
      } else {
        state = state.copyWith(
          errorMessage: result.error ?? 'Failed to update template',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  /// 템플릿 검색 (직접 Repository 호출)
  Future<void> searchTemplates({
    String? namePattern,
    String? companyId,
    String? storeId,
    String? createdBy,
    int? limit,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // ✅ Flutter 표준: Repository 직접 호출
      final templates = await _repository.search(
        namePattern: namePattern,
        companyId: companyId,
        storeId: storeId,
        createdBy: createdBy,
        limit: limit,
      );

      state = state.copyWith(
        isLoading: false,
        templates: templates,
        searchQuery: namePattern,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// 특정 템플릿 가져오기 (직접 Repository 호출)
  Future<TransactionTemplate?> getTemplateById(String templateId) async {
    try {
      // ✅ Flutter 표준: Repository 직접 호출
      return await _repository.findById(templateId);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return null;
    }
  }

  /// 템플릿 이름 사용 가능 여부 확인 (직접 Repository 호출)
  Future<bool> isNameAvailable(String name, String companyId) async {
    try {
      // ✅ Flutter 표준: Repository 직접 호출
      final exists = await _repository.nameExists(name, companyId);
      return !exists;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  /// 검색 쿼리 업데이트
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// 필터 업데이트
  void updateFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  /// 에러 메시지 지우기
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// 상태 초기화
  void reset() {
    state = const TemplateState();
  }
}

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Template Creation Notifier - 템플릿 생성 전용 상태 관리
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// ✅ 2025 Riverpod: @riverpod 어노테이션 사용
@riverpod
class TemplateCreationNotifier extends _$TemplateCreationNotifier {
  late final CreateTemplateUseCase _createUseCase;

  @override
  TemplateCreationState build() {
    _createUseCase = ref.read(createTemplateUseCaseProvider);
    return const TemplateCreationState();
  }

  /// 템플릿 생성
  Future<bool> createTemplate(CreateTemplateCommand command) async {
    state = state.copyWith(
      isCreating: true,
      errorMessage: null,
      fieldErrors: {},
    );

    try {
      // ✅ Flutter 표준: UseCase 직접 호출
      final result = await _createUseCase.execute(command);

      if (result.isSuccess) {
        state = state.copyWith(
          isCreating: false,
          createdTemplate: null,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isCreating: false,
          errorMessage: result.errorMessage ?? 'Failed to create template',
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
    state = const TemplateCreationState();
  }
}

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Template Filter Notifier - 필터 상태 관리
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// ✅ 2025 Riverpod: @riverpod 어노테이션 사용
@riverpod
class TemplateFilterNotifier extends _$TemplateFilterNotifier {
  @override
  TemplateFilterState build() => const TemplateFilterState();

  /// 가시성 필터 업데이트
  void updateVisibilityFilter(String filter) {
    state = state.copyWith(visibilityFilter: filter);
  }

  /// 상태 필터 업데이트
  void updateStatusFilter(String filter) {
    state = state.copyWith(statusFilter: filter);
  }

  /// 검색 텍스트 업데이트
  void updateSearchText(String text) {
    state = state.copyWith(searchText: text);
  }

  /// 내 템플릿만 보기 토글
  void toggleMyTemplatesOnly() {
    state = state.copyWith(showMyTemplatesOnly: !state.showMyTemplatesOnly);
  }

  /// 모든 필터 초기화
  void clearAllFilters() {
    state = const TemplateFilterState();
  }

  /// 필터 초기화 (별칭)
  void clearFilter() {
    clearAllFilters();
  }

  /// Account 필터만 제거
  void clearAccountFilter() {
    state = state.copyWith(accountIds: []);
  }

  /// Counterparty 필터만 제거
  void clearCounterpartyFilter() {
    state = state.copyWith(counterpartyId: '');
  }

  /// Cash Location 필터만 제거
  void clearCashLocationFilter() {
    state = state.copyWith(cashLocationId: '');
  }

  /// 복합 필터 업데이트
  void updateFilter(TemplateFilter filter) {
    state = state.copyWith(
      searchText: filter.searchQuery ?? '',
      visibilityFilter: filter.visibilityLevel ?? 'all',
      accountIds: filter.accountIds,
      counterpartyId: filter.counterpartyId,
      cashLocationId: filter.cashLocationId,
    );
  }

  /// 특정 필터 조합 적용
  void applyFilters({
    String? visibilityFilter,
    String? statusFilter,
    String? searchText,
    bool? showMyTemplatesOnly,
  }) {
    state = state.copyWith(
      visibilityFilter: visibilityFilter ?? state.visibilityFilter,
      statusFilter: statusFilter ?? state.statusFilter,
      searchText: searchText ?? state.searchText,
      showMyTemplatesOnly: showMyTemplatesOnly ?? state.showMyTemplatesOnly,
    );
  }
}

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Providers (DI)
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// ✅ 2025 Riverpod: @riverpod 어노테이션으로 자동 생성됨
/// - templateNotifierProvider (from @riverpod TemplateNotifier)
/// - templateCreationNotifierProvider (from @riverpod TemplateCreationNotifier)
/// - templateFilterNotifierProvider (from @riverpod TemplateFilterNotifier)

/// UseCase Providers (Domain Layer DI)
final createTemplateUseCaseProvider = Provider<CreateTemplateUseCase>((ref) {
  return CreateTemplateUseCase(
    templateRepository: ref.read(templateRepositoryProvider),
    templateValidator: ref.read(templateValidatorProvider),
  );
});

final deleteTemplateUseCaseProvider = Provider<DeleteTemplateUseCase>((ref) {
  return DeleteTemplateUseCase(
    templateRepository: ref.read(templateRepositoryProvider),
    transactionRepository: ref.read(transactionRepositoryProvider),
  );
});

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Computed Providers (UI Helper Providers)
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Filtered Templates Provider - 필터가 적용된 템플릿 목록
///
/// TemplateState와 TemplateFilterState를 결합하여 필터링된 템플릿 반환
@riverpod
List<TransactionTemplate> filteredTemplates(Ref ref) {
  final templateState = ref.watch(templateNotifierProvider);
  final filterState = ref.watch(templateFilterNotifierProvider);

  // Start with all templates
  var filtered = templateState.templates;

  // 검색어 필터
  if (filterState.searchText.isNotEmpty) {
    final searchLower = filterState.searchText.toLowerCase();
    filtered = filtered.where((template) {
      final name = template.name.toLowerCase();
      final description = (template.description ?? '').toLowerCase();
      return name.contains(searchLower) || description.contains(searchLower);
    }).toList();
  }

  // 내 템플릿만 보기 필터 (TODO: userId 필요)
  if (filterState.showMyTemplatesOnly) {
    // filtered = filtered.where((t) => t.createdBy == currentUserId).toList();
  }

  // 가시성 필터
  if (filterState.visibilityFilter != 'all') {
    filtered = filtered.where((template) {
      return filterState.visibilityFilter == 'admin'
          ? template.permission == TemplateConstants.adminPermissionUUID
          : template.permission != TemplateConstants.adminPermissionUUID;
    }).toList();
  }

  // 상태 필터
  if (filterState.statusFilter != 'all') {
    filtered = filtered.where((template) {
      return filterState.statusFilter == 'active' ? template.isActive : !template.isActive;
    }).toList();
  }

  // Account 필터 - template.data[].account_id로 필터링 (debit/credit 둘 다 확인)
  // template.data는 List<Map<String, dynamic>> 타입 (lines 배열 자체)
  if (filterState.accountIds != null && filterState.accountIds!.isNotEmpty) {
    filtered = filtered.where((template) {
      final lines = template.data; // data 자체가 lines 배열
      // 템플릿의 lines에 선택된 계정이 하나라도 있으면 표시 (debit/credit 구분 없이)
      return lines.any((line) {
        final accountId = line['account_id'] as String?;
        return accountId != null && filterState.accountIds!.contains(accountId);
      });
    }).toList();
  }

  // Counterparty 필터 - template.counterparty_id로 필터링
  if (filterState.counterpartyId != null) {
    filtered = filtered.where((template) {
      return template.counterpartyId == filterState.counterpartyId;
    }).toList();
  }

  // Cash Location 필터 - template.data[].cash_location_id로 필터링
  if (filterState.cashLocationId != null) {
    filtered = filtered.where((template) {
      final lines = template.data;
      // lines의 cash_location_id 중 하나라도 일치하면 표시
      return lines.any((line) {
        final cashLocationId = line['cash_location_id'] as String?;
        return cashLocationId == filterState.cashLocationId;
      });
    }).toList();
  }

  return filtered;
}

/// Can Delete Templates Provider - 템플릿 삭제 권한 확인
///
/// 현재 사용자의 권한을 확인하여 Admin 권한 여부 반환
/// Permission Provider - Check if user can delete templates (has admin access)
///
/// Checks user permissions from appStateProvider:
/// - Has adminPermission UUID → true (can access Admin tab and delete any templates)
/// - No adminPermission UUID → false (can only access General tab and delete own templates)
@riverpod
bool canDeleteTemplates(Ref ref) {
  final appState = ref.watch(appStateProvider);
  final user = appState.user;

  if (user.isEmpty) {
    return false;
  }

  // Get selected company data
  final companyId = appState.companyChoosen;
  if (companyId.isEmpty) {
    return false;
  }

  // Find the selected company in user's companies list
  final companies = user['companies'] as List<dynamic>? ?? [];
  final selectedCompany = companies.cast<Map<String, dynamic>>().firstWhere(
    (company) => company['company_id'] == companyId,
    orElse: () => <String, dynamic>{},
  );

  if (selectedCompany.isEmpty) {
    return false;
  }

  // Get user's permissions in this company
  final role = selectedCompany['role'] as Map<String, dynamic>? ?? {};
  final permissionsList = role['permissions'] as List<dynamic>? ?? [];

  // Convert to Set<String> for permission checking
  final permissions = permissionsList.cast<String>().toSet();

  // Check if user has admin permission UUID
  final hasAdminPermission = PermissionChecker.hasAdminPermission(permissions);

  return hasAdminPermission;
}

/// Can Edit Template Provider - 특정 템플릿 수정 권한 확인
///
/// 현재 사용자가 특정 템플릿을 수정할 수 있는지 확인
/// - Admin 권한 보유자: 모든 템플릿 수정 가능
/// - 일반 사용자: 본인이 생성한 템플릿만 수정 가능
@riverpod
bool canEditTemplate(Ref ref, String? createdBy) {
  // Admin은 모든 템플릿 수정 가능
  final hasAdminPermission = ref.watch(canDeleteTemplatesProvider);
  if (hasAdminPermission) return true;

  // 본인이 만든 템플릿인지 확인
  if (createdBy == null) return false;

  final appState = ref.watch(appStateProvider);
  final currentUserId = appState.user['user_id'] as String?;

  return currentUserId != null && currentUserId == createdBy;
}

/// Refresh Templates Provider - 템플릿 새로고침 함수
///
/// UI에서 pull-to-refresh 등에 사용할 수 있는 새로고침 함수 제공
@riverpod
Future<void> Function() refreshTemplates(Ref ref) {
  return () async {
    // Get company and store from app state
    final appState = ref.read(appStateProvider);
    final notifier = ref.read(templateNotifierProvider.notifier);

    await notifier.loadTemplates(
      companyId: appState.companyChoosen,
      storeId: appState.storeChoosen,
    );
  };
}
