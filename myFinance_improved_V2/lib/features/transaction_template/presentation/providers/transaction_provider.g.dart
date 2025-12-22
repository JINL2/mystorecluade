// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionCreationNotifierHash() =>
    r'f8e5ffc2f6b0d75e962765a09a363186a2078b0a';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Transaction Creation Notifier - 트랜잭션 생성 상태 관리
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// Flutter 표준 구조: Notifier가 직접 UseCase/Repository 호출
///
/// ✅ 2025 Riverpod: @riverpod 어노테이션 사용
///
/// Copied from [TransactionCreationNotifier].
@ProviderFor(TransactionCreationNotifier)
final transactionCreationNotifierProvider = AutoDisposeNotifierProvider<
    TransactionCreationNotifier, TransactionCreationState>.internal(
  TransactionCreationNotifier.new,
  name: r'transactionCreationNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionCreationNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TransactionCreationNotifier
    = AutoDisposeNotifier<TransactionCreationState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
