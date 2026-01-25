import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/datasources/shipment_remote_datasource.dart';
import '../data/repositories/shipment_repository_impl.dart';
import '../domain/repositories/shipment_repository.dart';
import '../domain/usecases/create_shipment_v3_usecase.dart';
import '../domain/usecases/get_shipments_usecase.dart';

/// Shipment Feature Dependency Injection Providers
///
/// Provides all dependencies for the shipment feature following Clean Architecture.

// =============================================================================
// Data Layer Providers
// =============================================================================

/// Supabase client provider
final _supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Remote datasource provider
final shipmentRemoteDatasourceProvider =
    Provider<ShipmentRemoteDatasource>((ref) {
  final supabase = ref.watch(_supabaseClientProvider);
  return ShipmentRemoteDatasourceImpl(supabase);
});

// =============================================================================
// Repository Provider
// =============================================================================

/// Repository provider - exposes domain interface, hides implementation
final shipmentRepositoryProvider = Provider<ShipmentRepository>((ref) {
  final remoteDatasource = ref.watch(shipmentRemoteDatasourceProvider);
  return ShipmentRepositoryImpl(remoteDatasource);
});

// =============================================================================
// UseCase Providers
// =============================================================================

/// Get shipments usecase provider (paginated with RPC)
final getShipmentsUseCaseProvider = Provider<GetShipmentsUseCase>((ref) {
  final repository = ref.watch(shipmentRepositoryProvider);
  return GetShipmentsUseCase(repository);
});

/// Get shipment detail usecase provider (using inventory_get_shipment_detail_v2 RPC)
final getShipmentDetailUseCaseProvider =
    Provider<GetShipmentDetailUseCase>((ref) {
  final repository = ref.watch(shipmentRepositoryProvider);
  return GetShipmentDetailUseCase(repository);
});

/// Close shipment usecase provider (using inventory_close_shipment RPC)
final closeShipmentUseCaseProvider = Provider<CloseShipmentUseCase>((ref) {
  final repository = ref.watch(shipmentRepositoryProvider);
  return CloseShipmentUseCase(repository);
});

/// Create shipment v3 usecase provider (using inventory_create_shipment_v3 RPC)
final createShipmentV3UseCaseProvider =
    Provider<CreateShipmentV3UseCase>((ref) {
  final repository = ref.watch(shipmentRepositoryProvider);
  return CreateShipmentV3UseCase(repository);
});

/// Get counterparties usecase provider (using get_counterparty_info RPC)
final getCounterpartiesUseCaseProvider =
    Provider<GetCounterpartiesUseCase>((ref) {
  final repository = ref.watch(shipmentRepositoryProvider);
  return GetCounterpartiesUseCase(repository);
});

/// Get linkable orders usecase provider (using inventory_get_order_info RPC)
final getLinkableOrdersUseCaseProvider =
    Provider<GetLinkableOrdersUseCase>((ref) {
  final repository = ref.watch(shipmentRepositoryProvider);
  return GetLinkableOrdersUseCase(repository);
});
