// Data Layer - Repository Providers
// Provider definitions for cash location repository
// This isolates data layer implementation details from presentation layer

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/cash_location_repository.dart';
import '../datasources/cash_location_data_source.dart';
import 'cash_location_repository_impl.dart';

/// Cash Location Repository Provider
///
/// Provides instance of CashLocationRepository interface.
/// Presentation layer depends only on the interface, not the implementation.
///
/// Data layer details (DataSource creation, Repository implementation) are hidden.
final cashLocationRepositoryProvider = Provider<CashLocationRepository>((ref) {
  final dataSource = CashLocationDataSource();
  return CashLocationRepositoryImpl(dataSource: dataSource);
});
