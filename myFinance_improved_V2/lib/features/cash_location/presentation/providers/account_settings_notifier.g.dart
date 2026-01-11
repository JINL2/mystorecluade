// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_settings_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountSettingsNotifierHash() =>
    r'eab5cb54baa9b436172cd3e16f9922b2030b92f0';

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

abstract class _$AccountSettingsNotifier
    extends BuildlessAutoDisposeNotifier<AccountSettingsState> {
  late final AccountSettingsParams params;

  AccountSettingsState build(
    AccountSettingsParams params,
  );
}

/// Notifier for Account Settings Page
///
/// Manages all business logic for account settings including:
/// - Loading cash location data
/// - Updating name, note, description
/// - Toggling main account status
/// - Deleting the account
///
/// Copied from [AccountSettingsNotifier].
@ProviderFor(AccountSettingsNotifier)
const accountSettingsNotifierProvider = AccountSettingsNotifierFamily();

/// Notifier for Account Settings Page
///
/// Manages all business logic for account settings including:
/// - Loading cash location data
/// - Updating name, note, description
/// - Toggling main account status
/// - Deleting the account
///
/// Copied from [AccountSettingsNotifier].
class AccountSettingsNotifierFamily extends Family<AccountSettingsState> {
  /// Notifier for Account Settings Page
  ///
  /// Manages all business logic for account settings including:
  /// - Loading cash location data
  /// - Updating name, note, description
  /// - Toggling main account status
  /// - Deleting the account
  ///
  /// Copied from [AccountSettingsNotifier].
  const AccountSettingsNotifierFamily();

  /// Notifier for Account Settings Page
  ///
  /// Manages all business logic for account settings including:
  /// - Loading cash location data
  /// - Updating name, note, description
  /// - Toggling main account status
  /// - Deleting the account
  ///
  /// Copied from [AccountSettingsNotifier].
  AccountSettingsNotifierProvider call(
    AccountSettingsParams params,
  ) {
    return AccountSettingsNotifierProvider(
      params,
    );
  }

  @override
  AccountSettingsNotifierProvider getProviderOverride(
    covariant AccountSettingsNotifierProvider provider,
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
  String? get name => r'accountSettingsNotifierProvider';
}

/// Notifier for Account Settings Page
///
/// Manages all business logic for account settings including:
/// - Loading cash location data
/// - Updating name, note, description
/// - Toggling main account status
/// - Deleting the account
///
/// Copied from [AccountSettingsNotifier].
class AccountSettingsNotifierProvider extends AutoDisposeNotifierProviderImpl<
    AccountSettingsNotifier, AccountSettingsState> {
  /// Notifier for Account Settings Page
  ///
  /// Manages all business logic for account settings including:
  /// - Loading cash location data
  /// - Updating name, note, description
  /// - Toggling main account status
  /// - Deleting the account
  ///
  /// Copied from [AccountSettingsNotifier].
  AccountSettingsNotifierProvider(
    AccountSettingsParams params,
  ) : this._internal(
          () => AccountSettingsNotifier()..params = params,
          from: accountSettingsNotifierProvider,
          name: r'accountSettingsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountSettingsNotifierHash,
          dependencies: AccountSettingsNotifierFamily._dependencies,
          allTransitiveDependencies:
              AccountSettingsNotifierFamily._allTransitiveDependencies,
          params: params,
        );

  AccountSettingsNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final AccountSettingsParams params;

  @override
  AccountSettingsState runNotifierBuild(
    covariant AccountSettingsNotifier notifier,
  ) {
    return notifier.build(
      params,
    );
  }

  @override
  Override overrideWith(AccountSettingsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: AccountSettingsNotifierProvider._internal(
        () => create()..params = params,
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
  AutoDisposeNotifierProviderElement<AccountSettingsNotifier,
      AccountSettingsState> createElement() {
    return _AccountSettingsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountSettingsNotifierProvider && other.params == params;
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
mixin AccountSettingsNotifierRef
    on AutoDisposeNotifierProviderRef<AccountSettingsState> {
  /// The parameter `params` of this provider.
  AccountSettingsParams get params;
}

class _AccountSettingsNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<AccountSettingsNotifier,
        AccountSettingsState> with AccountSettingsNotifierRef {
  _AccountSettingsNotifierProviderElement(super.provider);

  @override
  AccountSettingsParams get params =>
      (origin as AccountSettingsNotifierProvider).params;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
