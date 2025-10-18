import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/repositories/homepage_repository.dart';
import '../datasources/homepage_data_source.dart';
import 'homepage_repository_impl.dart';

/// Provider for SupabaseService (Data layer internal)
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

/// Provider for HomepageDataSource
///
/// Creates the data source that handles Supabase RPC calls.
final homepageDataSourceProvider = Provider<HomepageDataSource>((ref) {
  final supabaseService = ref.read(supabaseServiceProvider);
  return HomepageDataSource(supabaseService);
});

/// Provider for HomepageRepository
///
/// Creates the repository implementation that coordinates data fetching.
final homepageRepositoryProvider = Provider<HomepageRepository>((ref) {
  final dataSource = ref.watch(homepageDataSourceProvider);
  return HomepageRepositoryImpl(dataSource: dataSource);
});
