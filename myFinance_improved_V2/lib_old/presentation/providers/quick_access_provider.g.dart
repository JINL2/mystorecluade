// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_access_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionQuickAccessHash() =>
    r'208909e54bc6f478facb3ea4b60faa13c5765b5c';

/// See also [transactionQuickAccess].
@ProviderFor(transactionQuickAccess)
final transactionQuickAccessProvider =
    AutoDisposeFutureProvider<List<Map<String, dynamic>>>.internal(
  transactionQuickAccess,
  name: r'transactionQuickAccessProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionQuickAccessHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionQuickAccessRef
    = AutoDisposeFutureProviderRef<List<Map<String, dynamic>>>;
String _$templateQuickAccessHash() =>
    r'7cb4de8e42a7bde4945cc1713bb804537549a51a';

/// See also [templateQuickAccess].
@ProviderFor(templateQuickAccess)
final templateQuickAccessProvider =
    AutoDisposeFutureProvider<List<Map<String, dynamic>>>.internal(
  templateQuickAccess,
  name: r'templateQuickAccessProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$templateQuickAccessHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TemplateQuickAccessRef
    = AutoDisposeFutureProviderRef<List<Map<String, dynamic>>>;
String _$journalQuickAccessHash() =>
    r'4bd0e30ff729738ffd9c82c052424256ee5684cb';

/// See also [journalQuickAccess].
@ProviderFor(journalQuickAccess)
final journalQuickAccessProvider =
    AutoDisposeFutureProvider<List<Map<String, dynamic>>>.internal(
  journalQuickAccess,
  name: r'journalQuickAccessProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$journalQuickAccessHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JournalQuickAccessRef
    = AutoDisposeFutureProviderRef<List<Map<String, dynamic>>>;
String _$templateTransactionQuickAccessHash() =>
    r'3c61c6ef36a8749d02ff0f230a190e5895a2b46d';

/// See also [templateTransactionQuickAccess].
@ProviderFor(templateTransactionQuickAccess)
final templateTransactionQuickAccessProvider =
    AutoDisposeFutureProvider<List<Map<String, dynamic>>>.internal(
  templateTransactionQuickAccess,
  name: r'templateTransactionQuickAccessProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$templateTransactionQuickAccessHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TemplateTransactionQuickAccessRef
    = AutoDisposeFutureProviderRef<List<Map<String, dynamic>>>;
String _$templateCreationQuickAccessHash() =>
    r'bb67f541629e6871f9ff6f7835e31998819ac65a';

/// See also [templateCreationQuickAccess].
@ProviderFor(templateCreationQuickAccess)
final templateCreationQuickAccessProvider =
    AutoDisposeFutureProvider<List<Map<String, dynamic>>>.internal(
  templateCreationQuickAccess,
  name: r'templateCreationQuickAccessProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$templateCreationQuickAccessHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TemplateCreationQuickAccessRef
    = AutoDisposeFutureProviderRef<List<Map<String, dynamic>>>;
String _$quickAccessAccountsHash() =>
    r'10f814a5131e3c72106e8acbeb7344f2bc36750c';

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

abstract class _$QuickAccessAccounts
    extends BuildlessAutoDisposeAsyncNotifier<List<Map<String, dynamic>>> {
  late final String? contextType;
  late final int limit;

  FutureOr<List<Map<String, dynamic>>> build({
    String? contextType,
    int limit = 8,
  });
}

/// See also [QuickAccessAccounts].
@ProviderFor(QuickAccessAccounts)
const quickAccessAccountsProvider = QuickAccessAccountsFamily();

/// See also [QuickAccessAccounts].
class QuickAccessAccountsFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [QuickAccessAccounts].
  const QuickAccessAccountsFamily();

  /// See also [QuickAccessAccounts].
  QuickAccessAccountsProvider call({
    String? contextType,
    int limit = 8,
  }) {
    return QuickAccessAccountsProvider(
      contextType: contextType,
      limit: limit,
    );
  }

  @override
  QuickAccessAccountsProvider getProviderOverride(
    covariant QuickAccessAccountsProvider provider,
  ) {
    return call(
      contextType: provider.contextType,
      limit: provider.limit,
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
  String? get name => r'quickAccessAccountsProvider';
}

/// See also [QuickAccessAccounts].
class QuickAccessAccountsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    QuickAccessAccounts, List<Map<String, dynamic>>> {
  /// See also [QuickAccessAccounts].
  QuickAccessAccountsProvider({
    String? contextType,
    int limit = 8,
  }) : this._internal(
          () => QuickAccessAccounts()
            ..contextType = contextType
            ..limit = limit,
          from: quickAccessAccountsProvider,
          name: r'quickAccessAccountsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$quickAccessAccountsHash,
          dependencies: QuickAccessAccountsFamily._dependencies,
          allTransitiveDependencies:
              QuickAccessAccountsFamily._allTransitiveDependencies,
          contextType: contextType,
          limit: limit,
        );

  QuickAccessAccountsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.contextType,
    required this.limit,
  }) : super.internal();

  final String? contextType;
  final int limit;

  @override
  FutureOr<List<Map<String, dynamic>>> runNotifierBuild(
    covariant QuickAccessAccounts notifier,
  ) {
    return notifier.build(
      contextType: contextType,
      limit: limit,
    );
  }

  @override
  Override overrideWith(QuickAccessAccounts Function() create) {
    return ProviderOverride(
      origin: this,
      override: QuickAccessAccountsProvider._internal(
        () => create()
          ..contextType = contextType
          ..limit = limit,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        contextType: contextType,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<QuickAccessAccounts,
      List<Map<String, dynamic>>> createElement() {
    return _QuickAccessAccountsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuickAccessAccountsProvider &&
        other.contextType == contextType &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, contextType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin QuickAccessAccountsRef
    on AutoDisposeAsyncNotifierProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `contextType` of this provider.
  String? get contextType;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _QuickAccessAccountsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<QuickAccessAccounts,
        List<Map<String, dynamic>>> with QuickAccessAccountsRef {
  _QuickAccessAccountsProviderElement(super.provider);

  @override
  String? get contextType =>
      (origin as QuickAccessAccountsProvider).contextType;
  @override
  int get limit => (origin as QuickAccessAccountsProvider).limit;
}

String _$quickAccessTemplatesHash() =>
    r'28b45565cf0892d72e6128a8f2d5dd7425c5d1dc';

abstract class _$QuickAccessTemplates
    extends BuildlessAutoDisposeAsyncNotifier<List<Map<String, dynamic>>> {
  late final String? contextType;
  late final int limit;

  FutureOr<List<Map<String, dynamic>>> build({
    String? contextType,
    int limit = 6,
  });
}

/// See also [QuickAccessTemplates].
@ProviderFor(QuickAccessTemplates)
const quickAccessTemplatesProvider = QuickAccessTemplatesFamily();

/// See also [QuickAccessTemplates].
class QuickAccessTemplatesFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [QuickAccessTemplates].
  const QuickAccessTemplatesFamily();

  /// See also [QuickAccessTemplates].
  QuickAccessTemplatesProvider call({
    String? contextType,
    int limit = 6,
  }) {
    return QuickAccessTemplatesProvider(
      contextType: contextType,
      limit: limit,
    );
  }

  @override
  QuickAccessTemplatesProvider getProviderOverride(
    covariant QuickAccessTemplatesProvider provider,
  ) {
    return call(
      contextType: provider.contextType,
      limit: provider.limit,
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
  String? get name => r'quickAccessTemplatesProvider';
}

/// See also [QuickAccessTemplates].
class QuickAccessTemplatesProvider extends AutoDisposeAsyncNotifierProviderImpl<
    QuickAccessTemplates, List<Map<String, dynamic>>> {
  /// See also [QuickAccessTemplates].
  QuickAccessTemplatesProvider({
    String? contextType,
    int limit = 6,
  }) : this._internal(
          () => QuickAccessTemplates()
            ..contextType = contextType
            ..limit = limit,
          from: quickAccessTemplatesProvider,
          name: r'quickAccessTemplatesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$quickAccessTemplatesHash,
          dependencies: QuickAccessTemplatesFamily._dependencies,
          allTransitiveDependencies:
              QuickAccessTemplatesFamily._allTransitiveDependencies,
          contextType: contextType,
          limit: limit,
        );

  QuickAccessTemplatesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.contextType,
    required this.limit,
  }) : super.internal();

  final String? contextType;
  final int limit;

  @override
  FutureOr<List<Map<String, dynamic>>> runNotifierBuild(
    covariant QuickAccessTemplates notifier,
  ) {
    return notifier.build(
      contextType: contextType,
      limit: limit,
    );
  }

  @override
  Override overrideWith(QuickAccessTemplates Function() create) {
    return ProviderOverride(
      origin: this,
      override: QuickAccessTemplatesProvider._internal(
        () => create()
          ..contextType = contextType
          ..limit = limit,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        contextType: contextType,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<QuickAccessTemplates,
      List<Map<String, dynamic>>> createElement() {
    return _QuickAccessTemplatesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuickAccessTemplatesProvider &&
        other.contextType == contextType &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, contextType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin QuickAccessTemplatesRef
    on AutoDisposeAsyncNotifierProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `contextType` of this provider.
  String? get contextType;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _QuickAccessTemplatesProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<QuickAccessTemplates,
        List<Map<String, dynamic>>> with QuickAccessTemplatesRef {
  _QuickAccessTemplatesProviderElement(super.provider);

  @override
  String? get contextType =>
      (origin as QuickAccessTemplatesProvider).contextType;
  @override
  int get limit => (origin as QuickAccessTemplatesProvider).limit;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
