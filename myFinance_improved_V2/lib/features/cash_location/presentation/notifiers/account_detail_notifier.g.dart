// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountDetailNotifierHash() =>
    r'21faa7e54c7e8ebf455f6a7c19346dd238098fb7';

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

abstract class _$AccountDetailNotifier
    extends BuildlessAutoDisposeNotifier<AccountDetailState> {
  late final String locationId;

  AccountDetailState build(
    String locationId,
  );
}

/// Notifier for Account Detail page
///
/// Handles:
/// - Loading journal/actual flows with pagination
/// - Creating error adjustments
/// - Creating foreign currency translations
/// - Refreshing data
///
/// Copied from [AccountDetailNotifier].
@ProviderFor(AccountDetailNotifier)
const accountDetailNotifierProvider = AccountDetailNotifierFamily();

/// Notifier for Account Detail page
///
/// Handles:
/// - Loading journal/actual flows with pagination
/// - Creating error adjustments
/// - Creating foreign currency translations
/// - Refreshing data
///
/// Copied from [AccountDetailNotifier].
class AccountDetailNotifierFamily extends Family<AccountDetailState> {
  /// Notifier for Account Detail page
  ///
  /// Handles:
  /// - Loading journal/actual flows with pagination
  /// - Creating error adjustments
  /// - Creating foreign currency translations
  /// - Refreshing data
  ///
  /// Copied from [AccountDetailNotifier].
  const AccountDetailNotifierFamily();

  /// Notifier for Account Detail page
  ///
  /// Handles:
  /// - Loading journal/actual flows with pagination
  /// - Creating error adjustments
  /// - Creating foreign currency translations
  /// - Refreshing data
  ///
  /// Copied from [AccountDetailNotifier].
  AccountDetailNotifierProvider call(
    String locationId,
  ) {
    return AccountDetailNotifierProvider(
      locationId,
    );
  }

  @override
  AccountDetailNotifierProvider getProviderOverride(
    covariant AccountDetailNotifierProvider provider,
  ) {
    return call(
      provider.locationId,
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
  String? get name => r'accountDetailNotifierProvider';
}

/// Notifier for Account Detail page
///
/// Handles:
/// - Loading journal/actual flows with pagination
/// - Creating error adjustments
/// - Creating foreign currency translations
/// - Refreshing data
///
/// Copied from [AccountDetailNotifier].
class AccountDetailNotifierProvider extends AutoDisposeNotifierProviderImpl<
    AccountDetailNotifier, AccountDetailState> {
  /// Notifier for Account Detail page
  ///
  /// Handles:
  /// - Loading journal/actual flows with pagination
  /// - Creating error adjustments
  /// - Creating foreign currency translations
  /// - Refreshing data
  ///
  /// Copied from [AccountDetailNotifier].
  AccountDetailNotifierProvider(
    String locationId,
  ) : this._internal(
          () => AccountDetailNotifier()..locationId = locationId,
          from: accountDetailNotifierProvider,
          name: r'accountDetailNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountDetailNotifierHash,
          dependencies: AccountDetailNotifierFamily._dependencies,
          allTransitiveDependencies:
              AccountDetailNotifierFamily._allTransitiveDependencies,
          locationId: locationId,
        );

  AccountDetailNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.locationId,
  }) : super.internal();

  final String locationId;

  @override
  AccountDetailState runNotifierBuild(
    covariant AccountDetailNotifier notifier,
  ) {
    return notifier.build(
      locationId,
    );
  }

  @override
  Override overrideWith(AccountDetailNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: AccountDetailNotifierProvider._internal(
        () => create()..locationId = locationId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        locationId: locationId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<AccountDetailNotifier, AccountDetailState>
      createElement() {
    return _AccountDetailNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountDetailNotifierProvider &&
        other.locationId == locationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, locationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccountDetailNotifierRef
    on AutoDisposeNotifierProviderRef<AccountDetailState> {
  /// The parameter `locationId` of this provider.
  String get locationId;
}

class _AccountDetailNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<AccountDetailNotifier,
        AccountDetailState> with AccountDetailNotifierRef {
  _AccountDetailNotifierProviderElement(super.provider);

  @override
  String get locationId => (origin as AccountDetailNotifierProvider).locationId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
