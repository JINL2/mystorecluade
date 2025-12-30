// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'po_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$poDatasourceHash() => r'8b86a3d6e4512222b1fe3d4f3efd624a147d3581';

/// See also [poDatasource].
@ProviderFor(poDatasource)
final poDatasourceProvider = Provider<PORemoteDatasource>.internal(
  poDatasource,
  name: r'poDatasourceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$poDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PoDatasourceRef = ProviderRef<PORemoteDatasource>;
String _$poRepositoryHash() => r'58260533b0f8cf02b4a778d2b0d5de2f82f33013';

/// See also [poRepository].
@ProviderFor(poRepository)
final poRepositoryProvider = Provider<PORepository>.internal(
  poRepository,
  name: r'poRepositoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$poRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PoRepositoryRef = ProviderRef<PORepository>;
String _$acceptedPIsForConversionHash() =>
    r'9e989e6f5fdc86648552def2a3d6a62c141826d8';

/// See also [acceptedPIsForConversion].
@ProviderFor(acceptedPIsForConversion)
final acceptedPIsForConversionProvider =
    AutoDisposeFutureProvider<List<AcceptedPIForConversion>>.internal(
  acceptedPIsForConversion,
  name: r'acceptedPIsForConversionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$acceptedPIsForConversionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AcceptedPIsForConversionRef
    = AutoDisposeFutureProviderRef<List<AcceptedPIForConversion>>;
String _$poListHash() => r'36b7583cc542434f6ef566563e448833dd826ac3';

/// See also [PoList].
@ProviderFor(PoList)
final poListProvider =
    AutoDisposeNotifierProvider<PoList, POListState>.internal(
  PoList.new,
  name: r'poListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$poListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PoList = AutoDisposeNotifier<POListState>;
String _$poDetailHash() => r'87e374e470926e7176e4e7cabfb6d58f098823fb';

/// See also [PoDetail].
@ProviderFor(PoDetail)
final poDetailProvider =
    AutoDisposeNotifierProvider<PoDetail, PODetailState>.internal(
  PoDetail.new,
  name: r'poDetailProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$poDetailHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PoDetail = AutoDisposeNotifier<PODetailState>;
String _$poFormHash() => r'55abb85cecf54d29dbb8b81878ad1026c5b3be4c';

/// See also [PoForm].
@ProviderFor(PoForm)
final poFormProvider =
    AutoDisposeNotifierProvider<PoForm, POFormState>.internal(
  PoForm.new,
  name: r'poFormProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$poFormHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PoForm = AutoDisposeNotifier<POFormState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
