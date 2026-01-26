import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/datasources/fixed_asset_data_source.dart';
import '../data/repositories/fixed_asset_repository_impl.dart';
import '../domain/repositories/fixed_asset_repository.dart';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Infrastructure Layer - Dependency Injection
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// This file is the ONLY place where Data layer implementations
/// are referenced. Presentation layer imports only this file
/// to get the abstract Repository provider.

/// Supabase Client Provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Data Source Provider (Internal - not exported)
final _fixedAssetDataSourceProvider = Provider<FixedAssetDataSource>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return FixedAssetDataSource(supabase);
});

/// Repository Provider - Exposes abstract interface only
final fixedAssetRepositoryProvider = Provider<FixedAssetRepository>((ref) {
  final dataSource = ref.watch(_fixedAssetDataSourceProvider);
  return FixedAssetRepositoryImpl(dataSource);
});
