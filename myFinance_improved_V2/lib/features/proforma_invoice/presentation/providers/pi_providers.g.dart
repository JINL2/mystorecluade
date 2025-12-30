// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pi_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$piDatasourceHash() => r'9b272be781a354a7327f5d2f74bdad8a3ba01a28';

/// See also [piDatasource].
@ProviderFor(piDatasource)
final piDatasourceProvider = AutoDisposeProvider<PIRemoteDatasource>.internal(
  piDatasource,
  name: r'piDatasourceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$piDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PiDatasourceRef = AutoDisposeProviderRef<PIRemoteDatasource>;
String _$piRepositoryHash() => r'9fce4554d36869e20a5294e8608a50078c34feaa';

/// See also [piRepository].
@ProviderFor(piRepository)
final piRepositoryProvider = AutoDisposeProvider<PIRepository>.internal(
  piRepository,
  name: r'piRepositoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$piRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PiRepositoryRef = AutoDisposeProviderRef<PIRepository>;
String _$pIListNotifierHash() => r'c52f72dfae9b42dd2c2ca58db022c1716ef66312';

/// See also [PIListNotifier].
@ProviderFor(PIListNotifier)
final pIListNotifierProvider =
    NotifierProvider<PIListNotifier, PIListState>.internal(
  PIListNotifier.new,
  name: r'pIListNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pIListNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PIListNotifier = Notifier<PIListState>;
String _$pIDetailNotifierHash() => r'910a9e8cf91264f183042502ad6ee34ee930cb11';

/// See also [PIDetailNotifier].
@ProviderFor(PIDetailNotifier)
final pIDetailNotifierProvider =
    NotifierProvider<PIDetailNotifier, PIDetailState>.internal(
  PIDetailNotifier.new,
  name: r'pIDetailNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pIDetailNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PIDetailNotifier = Notifier<PIDetailState>;
String _$pIFormNotifierHash() => r'ed445577c17c13e8d2374bf22a1df5ba8a1cd8ff';

/// See also [PIFormNotifier].
@ProviderFor(PIFormNotifier)
final pIFormNotifierProvider =
    NotifierProvider<PIFormNotifier, PIFormState>.internal(
  PIFormNotifier.new,
  name: r'pIFormNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pIFormNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PIFormNotifier = Notifier<PIFormState>;
String _$termsTemplateNotifierHash() =>
    r'1928e857ef760d27986599052b097fb7f6a22cc4';

/// See also [TermsTemplateNotifier].
@ProviderFor(TermsTemplateNotifier)
final termsTemplateNotifierProvider =
    NotifierProvider<TermsTemplateNotifier, TermsTemplateState>.internal(
  TermsTemplateNotifier.new,
  name: r'termsTemplateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$termsTemplateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TermsTemplateNotifier = Notifier<TermsTemplateState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
