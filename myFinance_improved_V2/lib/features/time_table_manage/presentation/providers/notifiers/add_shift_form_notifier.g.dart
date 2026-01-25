// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_shift_form_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$addShiftFormNotifierHash() =>
    r'4cdfef9cc30ca9eb3b6f370a71d7bffc2ec4a5df';

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

abstract class _$AddShiftFormNotifier
    extends BuildlessAutoDisposeNotifier<AddShiftFormState> {
  late final String storeId;

  AddShiftFormState build(
    String storeId,
  );
}

/// Add Shift Form Notifier
///
/// Manages the business logic for the Add Shift form.
/// Uses UseCases for Clean Architecture compliance.
///
/// Usage:
/// ```dart
/// final formState = ref.watch(addShiftFormNotifierProvider(storeId));
/// final notifier = ref.read(addShiftFormNotifierProvider(storeId).notifier);
/// ```
///
/// Copied from [AddShiftFormNotifier].
@ProviderFor(AddShiftFormNotifier)
const addShiftFormNotifierProvider = AddShiftFormNotifierFamily();

/// Add Shift Form Notifier
///
/// Manages the business logic for the Add Shift form.
/// Uses UseCases for Clean Architecture compliance.
///
/// Usage:
/// ```dart
/// final formState = ref.watch(addShiftFormNotifierProvider(storeId));
/// final notifier = ref.read(addShiftFormNotifierProvider(storeId).notifier);
/// ```
///
/// Copied from [AddShiftFormNotifier].
class AddShiftFormNotifierFamily extends Family<AddShiftFormState> {
  /// Add Shift Form Notifier
  ///
  /// Manages the business logic for the Add Shift form.
  /// Uses UseCases for Clean Architecture compliance.
  ///
  /// Usage:
  /// ```dart
  /// final formState = ref.watch(addShiftFormNotifierProvider(storeId));
  /// final notifier = ref.read(addShiftFormNotifierProvider(storeId).notifier);
  /// ```
  ///
  /// Copied from [AddShiftFormNotifier].
  const AddShiftFormNotifierFamily();

  /// Add Shift Form Notifier
  ///
  /// Manages the business logic for the Add Shift form.
  /// Uses UseCases for Clean Architecture compliance.
  ///
  /// Usage:
  /// ```dart
  /// final formState = ref.watch(addShiftFormNotifierProvider(storeId));
  /// final notifier = ref.read(addShiftFormNotifierProvider(storeId).notifier);
  /// ```
  ///
  /// Copied from [AddShiftFormNotifier].
  AddShiftFormNotifierProvider call(
    String storeId,
  ) {
    return AddShiftFormNotifierProvider(
      storeId,
    );
  }

  @override
  AddShiftFormNotifierProvider getProviderOverride(
    covariant AddShiftFormNotifierProvider provider,
  ) {
    return call(
      provider.storeId,
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
  String? get name => r'addShiftFormNotifierProvider';
}

/// Add Shift Form Notifier
///
/// Manages the business logic for the Add Shift form.
/// Uses UseCases for Clean Architecture compliance.
///
/// Usage:
/// ```dart
/// final formState = ref.watch(addShiftFormNotifierProvider(storeId));
/// final notifier = ref.read(addShiftFormNotifierProvider(storeId).notifier);
/// ```
///
/// Copied from [AddShiftFormNotifier].
class AddShiftFormNotifierProvider extends AutoDisposeNotifierProviderImpl<
    AddShiftFormNotifier, AddShiftFormState> {
  /// Add Shift Form Notifier
  ///
  /// Manages the business logic for the Add Shift form.
  /// Uses UseCases for Clean Architecture compliance.
  ///
  /// Usage:
  /// ```dart
  /// final formState = ref.watch(addShiftFormNotifierProvider(storeId));
  /// final notifier = ref.read(addShiftFormNotifierProvider(storeId).notifier);
  /// ```
  ///
  /// Copied from [AddShiftFormNotifier].
  AddShiftFormNotifierProvider(
    String storeId,
  ) : this._internal(
          () => AddShiftFormNotifier()..storeId = storeId,
          from: addShiftFormNotifierProvider,
          name: r'addShiftFormNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$addShiftFormNotifierHash,
          dependencies: AddShiftFormNotifierFamily._dependencies,
          allTransitiveDependencies:
              AddShiftFormNotifierFamily._allTransitiveDependencies,
          storeId: storeId,
        );

  AddShiftFormNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storeId,
  }) : super.internal();

  final String storeId;

  @override
  AddShiftFormState runNotifierBuild(
    covariant AddShiftFormNotifier notifier,
  ) {
    return notifier.build(
      storeId,
    );
  }

  @override
  Override overrideWith(AddShiftFormNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: AddShiftFormNotifierProvider._internal(
        () => create()..storeId = storeId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storeId: storeId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<AddShiftFormNotifier, AddShiftFormState>
      createElement() {
    return _AddShiftFormNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddShiftFormNotifierProvider && other.storeId == storeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AddShiftFormNotifierRef
    on AutoDisposeNotifierProviderRef<AddShiftFormState> {
  /// The parameter `storeId` of this provider.
  String get storeId;
}

class _AddShiftFormNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<AddShiftFormNotifier,
        AddShiftFormState> with AddShiftFormNotifierRef {
  _AddShiftFormNotifierProviderElement(super.provider);

  @override
  String get storeId => (origin as AddShiftFormNotifierProvider).storeId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
