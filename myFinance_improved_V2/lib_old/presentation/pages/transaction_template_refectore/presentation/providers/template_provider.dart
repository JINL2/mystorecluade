import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'states/template_state.dart';
import 'validator_providers.dart';
import '../../domain/entities/template_entity.dart';
import '../../domain/usecases/create_template_usecase.dart';
import '../../domain/usecases/delete_template_usecase.dart';
import '../../domain/repositories/template_repository.dart';
import '../../domain/value_objects/template_filter.dart';
import '../../domain/providers/repository_providers.dart'; // ✅ Changed from data to domain
import '../../../../providers/app_state_provider.dart'; // Import appStateProvider

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Template Notifier - 상태 관리 + 비즈니스 로직 조율
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// Flutter 표준 구조: Notifier가 직접 UseCase/Repository 호출
/// Controller 레이어 없이 Domain Layer와 직접 통신
class TemplateNotifier extends StateNotifier<TemplateState> {
  final CreateTemplateUseCase _createUseCase;
  final DeleteTemplateUseCase _deleteUseCase;
  final TemplateRepository _repository;

  TemplateNotifier({
    required CreateTemplateUseCase createUseCase,
    required DeleteTemplateUseCase deleteUseCase,
    required TemplateRepository repository,
  })  : _createUseCase = createUseCase,
        _deleteUseCase = deleteUseCase,
        _repository = repository,
        super(const TemplateState());

  /// 템플릿 목록 로드 (직접 Repository 호출)
  Future<void> loadTemplates({
    required String companyId,
    String? storeId,
    bool includeInactive = false,
  }) async {
    print('🟢 DEBUG: TemplateNotifier.loadTemplates START - companyId=$companyId, storeId=$storeId');
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // ✅ Flutter 표준: Repository 직접 호출 (Controller 없음)
      final templates = await _repository.findByContext(
        companyId: companyId,
        storeId: storeId,
        isActive: includeInactive ? null : true,
      );

      print('🟢 DEBUG: TemplateNotifier - Received ${templates.length} templates');
      if (templates.isNotEmpty) {
        print('🟢 DEBUG: TemplateNotifier - First template: ${templates.first.name}');
      }

      state = state.copyWith(
        isLoading: false,
        templates: templates,
        errorMessage: null,
      );

      print('🟢 DEBUG: TemplateNotifier.loadTemplates SUCCESS - State updated with ${state.templates.length} templates');
    } catch (e) {
      print('🔴 DEBUG: TemplateNotifier.loadTemplates ERROR - $e');
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
class TemplateCreationNotifier extends StateNotifier<TemplateCreationState> {
  final CreateTemplateUseCase _createUseCase;

  TemplateCreationNotifier({
    required CreateTemplateUseCase createUseCase,
  })  : _createUseCase = createUseCase,
        super(const TemplateCreationState());

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
class TemplateFilterNotifier extends StateNotifier<TemplateFilterState> {
  TemplateFilterNotifier() : super(const TemplateFilterState());

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

  /// 복합 필터 업데이트
  void updateFilter(TemplateFilter filter) {
    state = state.copyWith(
      searchText: filter.searchQuery ?? '',
      visibilityFilter: filter.visibilityLevel ?? 'all',
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

/// Template Provider - 메인 템플릿 상태 관리
final templateProvider = StateNotifierProvider<TemplateNotifier, TemplateState>((ref) {
  return TemplateNotifier(
    createUseCase: ref.read(createTemplateUseCaseProvider),
    deleteUseCase: ref.read(deleteTemplateUseCaseProvider),
    repository: ref.read(templateRepositoryProvider),
  );
});

/// Template Creation Provider - 템플릿 생성 전용
final templateCreationProvider = StateNotifierProvider<TemplateCreationNotifier, TemplateCreationState>((ref) {
  return TemplateCreationNotifier(
    createUseCase: ref.read(createTemplateUseCaseProvider),
  );
});

/// Template Filter Provider - 필터 상태
final templateFilterProvider = StateNotifierProvider<TemplateFilterNotifier, TemplateFilterState>((ref) {
  return TemplateFilterNotifier();
});

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
final filteredTemplatesProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final templateState = ref.watch(templateProvider);
  final filterState = ref.watch(templateFilterProvider);

  // 로딩 중이거나 에러가 있으면 해당 상태 반환
  if (templateState.isLoading) {
    return const AsyncValue.loading();
  }

  if (templateState.errorMessage != null) {
    return AsyncValue.error(
      templateState.errorMessage!,
      StackTrace.current,
    );
  }

  // 템플릿을 Map<String, dynamic> 형식으로 변환
  final templatesAsMap = templateState.templates.map((template) {
    // Extract counterparty name from tags if available
    final tags = template.tags;
    String? counterpartyName;
    if (tags['counterparty_name'] != null) {
      counterpartyName = tags['counterparty_name'] as String?;
    }

    return {
      'template_id': template.templateId,
      'name': template.name,
      'template_description': template.description,
      'permission': template.permission,
      'data': template.data,
      'tags': template.tags,
      'usage_count': 0, // TODO: Add usage tracking
      'is_active': template.isActive,
      'created_at': template.createdAt,
      'counterparty_name': counterpartyName,
      'counterparty_id': template.counterpartyId,
    };
  }).toList();

  // 필터 적용
  var filtered = templatesAsMap;

  // 검색어 필터
  if (filterState.searchText.isNotEmpty) {
    final searchLower = filterState.searchText.toLowerCase();
    filtered = filtered.where((template) {
      final name = (template['name'] as String?) ?? '';
      final description = (template['template_description'] as String?) ?? '';
      return name.toLowerCase().contains(searchLower) ||
             description.toLowerCase().contains(searchLower);
    }).toList();
  }

  // 내 템플릿만 보기 필터 (TODO: userId 필요)
  if (filterState.showMyTemplatesOnly) {
    // filtered = filtered.where((t) => t['created_by'] == currentUserId).toList();
  }

  // 가시성 필터
  if (filterState.visibilityFilter != 'all') {
    filtered = filtered.where((template) {
      final permission = template['permission']?.toString() ?? '';
      return filterState.visibilityFilter == 'admin'
          ? permission == 'admin_permission'
          : permission != 'admin_permission';
    }).toList();
  }

  // 상태 필터
  if (filterState.statusFilter != 'all') {
    filtered = filtered.where((template) {
      final isActive = template['is_active'] as bool? ?? true;
      return filterState.statusFilter == 'active' ? isActive : !isActive;
    }).toList();
  }

  return AsyncValue.data(filtered);
});

/// Can Delete Templates Provider - 템플릿 삭제 권한 확인
///
/// 현재 사용자의 권한을 확인하여 Admin 권한 여부 반환
final canDeleteTemplatesProvider = Provider<bool>((ref) {
  // TODO: 실제 권한 시스템 연동 필요
  // 현재는 임시로 true 반환 (개발 중)
  // 실제로는 appStateProvider나 authProvider에서 사용자 권한 확인 필요
  return true;
});

/// Refresh Templates Provider - 템플릿 새로고침 함수
///
/// UI에서 pull-to-refresh 등에 사용할 수 있는 새로고침 함수 제공
final refreshTemplatesProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    // Get company and store from app state
    final appState = ref.read(appStateProvider);
    final notifier = ref.read(templateProvider.notifier);

    await notifier.loadTemplates(
      companyId: appState.companyChoosen,
      storeId: appState.storeChoosen,
    );
  };
});
