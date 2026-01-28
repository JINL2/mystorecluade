// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredTemplatesHash() => r'750eefd9cb011b052f8636826373241fb7f990a0';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Computed Providers (UI Helper Providers)
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// Filtered Templates Provider - 필터가 적용된 템플릿 목록
///
/// TemplateState와 TemplateFilterState를 결합하여 필터링된 템플릿 반환
///
/// Copied from [filteredTemplates].
@ProviderFor(filteredTemplates)
final filteredTemplatesProvider =
    AutoDisposeProvider<List<TransactionTemplate>>.internal(
  filteredTemplates,
  name: r'filteredTemplatesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredTemplatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredTemplatesRef
    = AutoDisposeProviderRef<List<TransactionTemplate>>;
String _$canDeleteTemplatesHash() =>
    r'4fab39dbda04476ccfb4f10798609b7d2f8cf98b';

/// Can Delete Templates Provider - 템플릿 삭제 권한 확인
///
/// 현재 사용자의 권한을 확인하여 Admin 권한 여부 반환
/// Permission Provider - Check if user can delete templates (has admin access)
///
/// Checks user permissions from appStateProvider:
/// - Has adminPermission UUID → true (can access Admin tab and delete any templates)
/// - No adminPermission UUID → false (can only access General tab and delete own templates)
///
/// Copied from [canDeleteTemplates].
@ProviderFor(canDeleteTemplates)
final canDeleteTemplatesProvider = AutoDisposeProvider<bool>.internal(
  canDeleteTemplates,
  name: r'canDeleteTemplatesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$canDeleteTemplatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CanDeleteTemplatesRef = AutoDisposeProviderRef<bool>;
String _$canEditTemplateHash() => r'efac9e7336710e161108d0389e81d4d50238c93f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Can Edit Template Provider - 특정 템플릿 수정 권한 확인
///
/// 현재 사용자가 특정 템플릿을 수정할 수 있는지 확인
/// - Admin 권한 보유자: 모든 템플릿 수정 가능
/// - 일반 사용자: 본인이 생성한 템플릿만 수정 가능
///
/// Copied from [canEditTemplate].
@ProviderFor(canEditTemplate)
const canEditTemplateProvider = CanEditTemplateFamily();

/// Can Edit Template Provider - 특정 템플릿 수정 권한 확인
///
/// 현재 사용자가 특정 템플릿을 수정할 수 있는지 확인
/// - Admin 권한 보유자: 모든 템플릿 수정 가능
/// - 일반 사용자: 본인이 생성한 템플릿만 수정 가능
///
/// Copied from [canEditTemplate].
class CanEditTemplateFamily extends Family<bool> {
  /// Can Edit Template Provider - 특정 템플릿 수정 권한 확인
  ///
  /// 현재 사용자가 특정 템플릿을 수정할 수 있는지 확인
  /// - Admin 권한 보유자: 모든 템플릿 수정 가능
  /// - 일반 사용자: 본인이 생성한 템플릿만 수정 가능
  ///
  /// Copied from [canEditTemplate].
  const CanEditTemplateFamily();

  /// Can Edit Template Provider - 특정 템플릿 수정 권한 확인
  ///
  /// 현재 사용자가 특정 템플릿을 수정할 수 있는지 확인
  /// - Admin 권한 보유자: 모든 템플릿 수정 가능
  /// - 일반 사용자: 본인이 생성한 템플릿만 수정 가능
  ///
  /// Copied from [canEditTemplate].
  CanEditTemplateProvider call(
    String? createdBy,
  ) {
    return CanEditTemplateProvider(
      createdBy,
    );
  }

  @override
  CanEditTemplateProvider getProviderOverride(
    covariant CanEditTemplateProvider provider,
  ) {
    return call(
      provider.createdBy,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'canEditTemplateProvider';
}

/// Can Edit Template Provider - 특정 템플릿 수정 권한 확인
///
/// 현재 사용자가 특정 템플릿을 수정할 수 있는지 확인
/// - Admin 권한 보유자: 모든 템플릿 수정 가능
/// - 일반 사용자: 본인이 생성한 템플릿만 수정 가능
///
/// Copied from [canEditTemplate].
class CanEditTemplateProvider extends AutoDisposeProvider<bool> {
  /// Can Edit Template Provider - 특정 템플릿 수정 권한 확인
  ///
  /// 현재 사용자가 특정 템플릿을 수정할 수 있는지 확인
  /// - Admin 권한 보유자: 모든 템플릿 수정 가능
  /// - 일반 사용자: 본인이 생성한 템플릿만 수정 가능
  ///
  /// Copied from [canEditTemplate].
  CanEditTemplateProvider(
    String? createdBy,
  ) : this._internal(
          (ref) => canEditTemplate(
            ref as CanEditTemplateRef,
            createdBy,
          ),
          from: canEditTemplateProvider,
          name: r'canEditTemplateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$canEditTemplateHash,
          dependencies: CanEditTemplateFamily._dependencies,
          allTransitiveDependencies:
              CanEditTemplateFamily._allTransitiveDependencies,
          createdBy: createdBy,
        );

  CanEditTemplateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.createdBy,
  }) : super.internal();

  final String? createdBy;

  @override
  Override overrideWith(
    bool Function(CanEditTemplateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CanEditTemplateProvider._internal(
        (ref) => create(ref as CanEditTemplateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        createdBy: createdBy,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _CanEditTemplateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CanEditTemplateProvider && other.createdBy == createdBy;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, createdBy.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CanEditTemplateRef on AutoDisposeProviderRef<bool> {
  /// The parameter `createdBy` of this provider.
  String? get createdBy;
}

class _CanEditTemplateProviderElement extends AutoDisposeProviderElement<bool>
    with CanEditTemplateRef {
  _CanEditTemplateProviderElement(super.provider);

  @override
  String? get createdBy => (origin as CanEditTemplateProvider).createdBy;
}

String _$refreshTemplatesHash() => r'48bc7e61b3a58a8456dfe69f3ebeca192aaf1236';

/// Refresh Templates Provider - 템플릿 새로고침 함수
///
/// UI에서 pull-to-refresh 등에 사용할 수 있는 새로고침 함수 제공
///
/// Copied from [refreshTemplates].
@ProviderFor(refreshTemplates)
final refreshTemplatesProvider =
    AutoDisposeProvider<Future<void> Function()>.internal(
  refreshTemplates,
  name: r'refreshTemplatesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$refreshTemplatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RefreshTemplatesRef = AutoDisposeProviderRef<Future<void> Function()>;
String _$templateNotifierHash() => r'95025cf9376f13f8a8e51a59b468c312e3aa8856';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Template Notifier - 상태 관리 + 비즈니스 로직 조율
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// Flutter 표준 구조: Notifier가 직접 UseCase/Repository 호출
/// Controller 레이어 없이 Domain Layer와 직접 통신
///
/// ✅ 2025 Riverpod: @riverpod 어노테이션 사용
///
/// Copied from [TemplateNotifier].
@ProviderFor(TemplateNotifier)
final templateNotifierProvider =
    AutoDisposeNotifierProvider<TemplateNotifier, TemplateState>.internal(
  TemplateNotifier.new,
  name: r'templateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$templateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TemplateNotifier = AutoDisposeNotifier<TemplateState>;
String _$templateCreationNotifierHash() =>
    r'b875d0f423dee5cb50545513a181f412a4da5adc';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Template Creation Notifier - 템플릿 생성 전용 상태 관리
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// ✅ 2025 Riverpod: @riverpod 어노테이션 사용
///
/// Copied from [TemplateCreationNotifier].
@ProviderFor(TemplateCreationNotifier)
final templateCreationNotifierProvider = AutoDisposeNotifierProvider<
    TemplateCreationNotifier, TemplateCreationState>.internal(
  TemplateCreationNotifier.new,
  name: r'templateCreationNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$templateCreationNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TemplateCreationNotifier = AutoDisposeNotifier<TemplateCreationState>;
String _$templateFilterNotifierHash() =>
    r'4dfeaaf32f975c739f4d1fb03643d30fe7606b5b';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Template Filter Notifier - 필터 상태 관리
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// ✅ 2025 Riverpod: @riverpod 어노테이션 사용
///
/// Copied from [TemplateFilterNotifier].
@ProviderFor(TemplateFilterNotifier)
final templateFilterNotifierProvider = AutoDisposeNotifierProvider<
    TemplateFilterNotifier, TemplateFilterState>.internal(
  TemplateFilterNotifier.new,
  name: r'templateFilterNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$templateFilterNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TemplateFilterNotifier = AutoDisposeNotifier<TemplateFilterState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
