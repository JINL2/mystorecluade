import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/fixed_asset_data_source.dart';
import '../../data/repositories/fixed_asset_repository_impl.dart';
import '../../domain/repositories/fixed_asset_repository.dart';
import 'fixed_asset_notifier.dart';
import 'states/fixed_asset_state.dart';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Infrastructure Providers (DI)
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Supabase Client Provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Data Source Provider
final fixedAssetDataSourceProvider = Provider<FixedAssetDataSource>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return FixedAssetDataSource(supabase);
});

/// Repository Provider
final fixedAssetRepositoryProvider = Provider<FixedAssetRepository>((ref) {
  final dataSource = ref.watch(fixedAssetDataSourceProvider);
  return FixedAssetRepositoryImpl(dataSource);
});

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 State Notifier Providers
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Fixed Asset Provider - 메인 상태 관리
final fixedAssetProvider = StateNotifierProvider<FixedAssetNotifier, FixedAssetState>((ref) {
  return FixedAssetNotifier(
    repository: ref.watch(fixedAssetRepositoryProvider),
  );
});

/// Fixed Asset Form Provider - 폼 상태 관리
final fixedAssetFormProvider = StateNotifierProvider<FixedAssetFormNotifier, FixedAssetFormState>((ref) {
  return FixedAssetFormNotifier();
});

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Helper Providers (Computed/Utility)
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 회사 기본 통화 Provider
final companyBaseCurrencyProvider = FutureProvider.family<String?, String>((ref, companyId) async {
  final repository = ref.watch(fixedAssetRepositoryProvider);
  return await repository.getCompanyBaseCurrency(companyId);
});

/// 통화 심볼 Provider
final currencySymbolProvider = FutureProvider.family<String, String>((ref, currencyId) async {
  final repository = ref.watch(fixedAssetRepositoryProvider);
  return await repository.getCurrencySymbol(currencyId);
});
