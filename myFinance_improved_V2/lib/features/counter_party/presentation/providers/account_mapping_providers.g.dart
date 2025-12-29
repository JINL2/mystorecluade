// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_mapping_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountMappingsHash() => r'690e2ba4758a223b0cb748d70bda40854b033559';

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

/// Provider for fetching account mappings for a counterparty
///
/// Copied from [accountMappings].
@ProviderFor(accountMappings)
const accountMappingsProvider = AccountMappingsFamily();

/// Provider for fetching account mappings for a counterparty
///
/// Copied from [accountMappings].
class AccountMappingsFamily extends Family<AsyncValue<List<AccountMapping>>> {
  /// Provider for fetching account mappings for a counterparty
  ///
  /// Copied from [accountMappings].
  const AccountMappingsFamily();

  /// Provider for fetching account mappings for a counterparty
  ///
  /// Copied from [accountMappings].
  AccountMappingsProvider call(
    String counterpartyId,
  ) {
    return AccountMappingsProvider(
      counterpartyId,
    );
  }

  @override
  AccountMappingsProvider getProviderOverride(
    covariant AccountMappingsProvider provider,
  ) {
    return call(
      provider.counterpartyId,
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
  String? get name => r'accountMappingsProvider';
}

/// Provider for fetching account mappings for a counterparty
///
/// Copied from [accountMappings].
class AccountMappingsProvider
    extends AutoDisposeFutureProvider<List<AccountMapping>> {
  /// Provider for fetching account mappings for a counterparty
  ///
  /// Copied from [accountMappings].
  AccountMappingsProvider(
    String counterpartyId,
  ) : this._internal(
          (ref) => accountMappings(
            ref as AccountMappingsRef,
            counterpartyId,
          ),
          from: accountMappingsProvider,
          name: r'accountMappingsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountMappingsHash,
          dependencies: AccountMappingsFamily._dependencies,
          allTransitiveDependencies:
              AccountMappingsFamily._allTransitiveDependencies,
          counterpartyId: counterpartyId,
        );

  AccountMappingsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.counterpartyId,
  }) : super.internal();

  final String counterpartyId;

  @override
  Override overrideWith(
    FutureOr<List<AccountMapping>> Function(AccountMappingsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountMappingsProvider._internal(
        (ref) => create(ref as AccountMappingsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        counterpartyId: counterpartyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AccountMapping>> createElement() {
    return _AccountMappingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountMappingsProvider &&
        other.counterpartyId == counterpartyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, counterpartyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccountMappingsRef on AutoDisposeFutureProviderRef<List<AccountMapping>> {
  /// The parameter `counterpartyId` of this provider.
  String get counterpartyId;
}

class _AccountMappingsProviderElement
    extends AutoDisposeFutureProviderElement<List<AccountMapping>>
    with AccountMappingsRef {
  _AccountMappingsProviderElement(super.provider);

  @override
  String get counterpartyId =>
      (origin as AccountMappingsProvider).counterpartyId;
}

String _$availableAccountsHash() => r'4a22a44be078116e8a4846db191c33b68719649d';

/// Provider for fetching available accounts for mapping
///
/// Copied from [availableAccounts].
@ProviderFor(availableAccounts)
const availableAccountsProvider = AvailableAccountsFamily();

/// Provider for fetching available accounts for mapping
///
/// Copied from [availableAccounts].
class AvailableAccountsFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// Provider for fetching available accounts for mapping
  ///
  /// Copied from [availableAccounts].
  const AvailableAccountsFamily();

  /// Provider for fetching available accounts for mapping
  ///
  /// Copied from [availableAccounts].
  AvailableAccountsProvider call(
    String companyId,
  ) {
    return AvailableAccountsProvider(
      companyId,
    );
  }

  @override
  AvailableAccountsProvider getProviderOverride(
    covariant AvailableAccountsProvider provider,
  ) {
    return call(
      provider.companyId,
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
  String? get name => r'availableAccountsProvider';
}

/// Provider for fetching available accounts for mapping
///
/// Copied from [availableAccounts].
class AvailableAccountsProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// Provider for fetching available accounts for mapping
  ///
  /// Copied from [availableAccounts].
  AvailableAccountsProvider(
    String companyId,
  ) : this._internal(
          (ref) => availableAccounts(
            ref as AvailableAccountsRef,
            companyId,
          ),
          from: availableAccountsProvider,
          name: r'availableAccountsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$availableAccountsHash,
          dependencies: AvailableAccountsFamily._dependencies,
          allTransitiveDependencies:
              AvailableAccountsFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  AvailableAccountsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.companyId,
  }) : super.internal();

  final String companyId;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(AvailableAccountsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AvailableAccountsProvider._internal(
        (ref) => create(ref as AvailableAccountsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        companyId: companyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _AvailableAccountsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AvailableAccountsProvider && other.companyId == companyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AvailableAccountsRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `companyId` of this provider.
  String get companyId;
}

class _AvailableAccountsProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with AvailableAccountsRef {
  _AvailableAccountsProviderElement(super.provider);

  @override
  String get companyId => (origin as AvailableAccountsProvider).companyId;
}

String _$linkedCompanyInfoHash() => r'b1dda256a7643cc99d008df2d95c7aa05db1bcfc';

/// Provider for fetching linked company information
///
/// Copied from [linkedCompanyInfo].
@ProviderFor(linkedCompanyInfo)
const linkedCompanyInfoProvider = LinkedCompanyInfoFamily();

/// Provider for fetching linked company information
///
/// Copied from [linkedCompanyInfo].
class LinkedCompanyInfoFamily
    extends Family<AsyncValue<Map<String, dynamic>?>> {
  /// Provider for fetching linked company information
  ///
  /// Copied from [linkedCompanyInfo].
  const LinkedCompanyInfoFamily();

  /// Provider for fetching linked company information
  ///
  /// Copied from [linkedCompanyInfo].
  LinkedCompanyInfoProvider call(
    String counterpartyId,
  ) {
    return LinkedCompanyInfoProvider(
      counterpartyId,
    );
  }

  @override
  LinkedCompanyInfoProvider getProviderOverride(
    covariant LinkedCompanyInfoProvider provider,
  ) {
    return call(
      provider.counterpartyId,
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
  String? get name => r'linkedCompanyInfoProvider';
}

/// Provider for fetching linked company information
///
/// Copied from [linkedCompanyInfo].
class LinkedCompanyInfoProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>?> {
  /// Provider for fetching linked company information
  ///
  /// Copied from [linkedCompanyInfo].
  LinkedCompanyInfoProvider(
    String counterpartyId,
  ) : this._internal(
          (ref) => linkedCompanyInfo(
            ref as LinkedCompanyInfoRef,
            counterpartyId,
          ),
          from: linkedCompanyInfoProvider,
          name: r'linkedCompanyInfoProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$linkedCompanyInfoHash,
          dependencies: LinkedCompanyInfoFamily._dependencies,
          allTransitiveDependencies:
              LinkedCompanyInfoFamily._allTransitiveDependencies,
          counterpartyId: counterpartyId,
        );

  LinkedCompanyInfoProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.counterpartyId,
  }) : super.internal();

  final String counterpartyId;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>?> Function(LinkedCompanyInfoRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LinkedCompanyInfoProvider._internal(
        (ref) => create(ref as LinkedCompanyInfoRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        counterpartyId: counterpartyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>?> createElement() {
    return _LinkedCompanyInfoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LinkedCompanyInfoProvider &&
        other.counterpartyId == counterpartyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, counterpartyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LinkedCompanyInfoRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>?> {
  /// The parameter `counterpartyId` of this provider.
  String get counterpartyId;
}

class _LinkedCompanyInfoProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>?>
    with LinkedCompanyInfoRef {
  _LinkedCompanyInfoProviderElement(super.provider);

  @override
  String get counterpartyId =>
      (origin as LinkedCompanyInfoProvider).counterpartyId;
}

String _$linkedCompanyAccountsHash() =>
    r'6d3213e4741a31dcfbcfc691293a11ac8593aa29';

/// Provider for fetching available accounts for the linked company
///
/// Copied from [linkedCompanyAccounts].
@ProviderFor(linkedCompanyAccounts)
const linkedCompanyAccountsProvider = LinkedCompanyAccountsFamily();

/// Provider for fetching available accounts for the linked company
///
/// Copied from [linkedCompanyAccounts].
class LinkedCompanyAccountsFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// Provider for fetching available accounts for the linked company
  ///
  /// Copied from [linkedCompanyAccounts].
  const LinkedCompanyAccountsFamily();

  /// Provider for fetching available accounts for the linked company
  ///
  /// Copied from [linkedCompanyAccounts].
  LinkedCompanyAccountsProvider call(
    String linkedCompanyId,
  ) {
    return LinkedCompanyAccountsProvider(
      linkedCompanyId,
    );
  }

  @override
  LinkedCompanyAccountsProvider getProviderOverride(
    covariant LinkedCompanyAccountsProvider provider,
  ) {
    return call(
      provider.linkedCompanyId,
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
  String? get name => r'linkedCompanyAccountsProvider';
}

/// Provider for fetching available accounts for the linked company
///
/// Copied from [linkedCompanyAccounts].
class LinkedCompanyAccountsProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// Provider for fetching available accounts for the linked company
  ///
  /// Copied from [linkedCompanyAccounts].
  LinkedCompanyAccountsProvider(
    String linkedCompanyId,
  ) : this._internal(
          (ref) => linkedCompanyAccounts(
            ref as LinkedCompanyAccountsRef,
            linkedCompanyId,
          ),
          from: linkedCompanyAccountsProvider,
          name: r'linkedCompanyAccountsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$linkedCompanyAccountsHash,
          dependencies: LinkedCompanyAccountsFamily._dependencies,
          allTransitiveDependencies:
              LinkedCompanyAccountsFamily._allTransitiveDependencies,
          linkedCompanyId: linkedCompanyId,
        );

  LinkedCompanyAccountsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.linkedCompanyId,
  }) : super.internal();

  final String linkedCompanyId;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(
            LinkedCompanyAccountsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LinkedCompanyAccountsProvider._internal(
        (ref) => create(ref as LinkedCompanyAccountsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        linkedCompanyId: linkedCompanyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _LinkedCompanyAccountsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LinkedCompanyAccountsProvider &&
        other.linkedCompanyId == linkedCompanyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, linkedCompanyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LinkedCompanyAccountsRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `linkedCompanyId` of this provider.
  String get linkedCompanyId;
}

class _LinkedCompanyAccountsProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with LinkedCompanyAccountsRef {
  _LinkedCompanyAccountsProviderElement(super.provider);

  @override
  String get linkedCompanyId =>
      (origin as LinkedCompanyAccountsProvider).linkedCompanyId;
}

String _$createAccountMappingHash() =>
    r'01e5c9b6a60377bbffac7588ab5dc1223474361f';

/// Provider for creating a new account mapping
///
/// Copied from [createAccountMapping].
@ProviderFor(createAccountMapping)
const createAccountMappingProvider = CreateAccountMappingFamily();

/// Provider for creating a new account mapping
///
/// Copied from [createAccountMapping].
class CreateAccountMappingFamily extends Family<AsyncValue<AccountMapping>> {
  /// Provider for creating a new account mapping
  ///
  /// Copied from [createAccountMapping].
  const CreateAccountMappingFamily();

  /// Provider for creating a new account mapping
  ///
  /// Copied from [createAccountMapping].
  CreateAccountMappingProvider call(
    CreateAccountMappingParams params,
  ) {
    return CreateAccountMappingProvider(
      params,
    );
  }

  @override
  CreateAccountMappingProvider getProviderOverride(
    covariant CreateAccountMappingProvider provider,
  ) {
    return call(
      provider.params,
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
  String? get name => r'createAccountMappingProvider';
}

/// Provider for creating a new account mapping
///
/// Copied from [createAccountMapping].
class CreateAccountMappingProvider
    extends AutoDisposeFutureProvider<AccountMapping> {
  /// Provider for creating a new account mapping
  ///
  /// Copied from [createAccountMapping].
  CreateAccountMappingProvider(
    CreateAccountMappingParams params,
  ) : this._internal(
          (ref) => createAccountMapping(
            ref as CreateAccountMappingRef,
            params,
          ),
          from: createAccountMappingProvider,
          name: r'createAccountMappingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createAccountMappingHash,
          dependencies: CreateAccountMappingFamily._dependencies,
          allTransitiveDependencies:
              CreateAccountMappingFamily._allTransitiveDependencies,
          params: params,
        );

  CreateAccountMappingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final CreateAccountMappingParams params;

  @override
  Override overrideWith(
    FutureOr<AccountMapping> Function(CreateAccountMappingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateAccountMappingProvider._internal(
        (ref) => create(ref as CreateAccountMappingRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AccountMapping> createElement() {
    return _CreateAccountMappingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateAccountMappingProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateAccountMappingRef on AutoDisposeFutureProviderRef<AccountMapping> {
  /// The parameter `params` of this provider.
  CreateAccountMappingParams get params;
}

class _CreateAccountMappingProviderElement
    extends AutoDisposeFutureProviderElement<AccountMapping>
    with CreateAccountMappingRef {
  _CreateAccountMappingProviderElement(super.provider);

  @override
  CreateAccountMappingParams get params =>
      (origin as CreateAccountMappingProvider).params;
}

String _$deleteAccountMappingHash() =>
    r'8b64882434a566ef522b09511dac21b2d637fb2f';

/// Provider for deleting an account mapping
///
/// Copied from [deleteAccountMapping].
@ProviderFor(deleteAccountMapping)
const deleteAccountMappingProvider = DeleteAccountMappingFamily();

/// Provider for deleting an account mapping
///
/// Copied from [deleteAccountMapping].
class DeleteAccountMappingFamily extends Family<AsyncValue<bool>> {
  /// Provider for deleting an account mapping
  ///
  /// Copied from [deleteAccountMapping].
  const DeleteAccountMappingFamily();

  /// Provider for deleting an account mapping
  ///
  /// Copied from [deleteAccountMapping].
  DeleteAccountMappingProvider call(
    DeleteAccountMappingParams params,
  ) {
    return DeleteAccountMappingProvider(
      params,
    );
  }

  @override
  DeleteAccountMappingProvider getProviderOverride(
    covariant DeleteAccountMappingProvider provider,
  ) {
    return call(
      provider.params,
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
  String? get name => r'deleteAccountMappingProvider';
}

/// Provider for deleting an account mapping
///
/// Copied from [deleteAccountMapping].
class DeleteAccountMappingProvider extends AutoDisposeFutureProvider<bool> {
  /// Provider for deleting an account mapping
  ///
  /// Copied from [deleteAccountMapping].
  DeleteAccountMappingProvider(
    DeleteAccountMappingParams params,
  ) : this._internal(
          (ref) => deleteAccountMapping(
            ref as DeleteAccountMappingRef,
            params,
          ),
          from: deleteAccountMappingProvider,
          name: r'deleteAccountMappingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$deleteAccountMappingHash,
          dependencies: DeleteAccountMappingFamily._dependencies,
          allTransitiveDependencies:
              DeleteAccountMappingFamily._allTransitiveDependencies,
          params: params,
        );

  DeleteAccountMappingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final DeleteAccountMappingParams params;

  @override
  Override overrideWith(
    FutureOr<bool> Function(DeleteAccountMappingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteAccountMappingProvider._internal(
        (ref) => create(ref as DeleteAccountMappingRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _DeleteAccountMappingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteAccountMappingProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeleteAccountMappingRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `params` of this provider.
  DeleteAccountMappingParams get params;
}

class _DeleteAccountMappingProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with DeleteAccountMappingRef {
  _DeleteAccountMappingProviderElement(super.provider);

  @override
  DeleteAccountMappingParams get params =>
      (origin as DeleteAccountMappingProvider).params;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
