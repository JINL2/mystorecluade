import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Data layer imports (ONLY allowed in DI layer)
import '../data/repositories/currency_repository_impl.dart';
import '../data/repositories/denomination_repository_impl.dart';
import '../data/services/denomination_template_service.dart';
import '../data/services/exchange_rate_service.dart';

// Domain layer imports
import '../domain/repositories/currency_repository.dart';
import '../domain/repositories/denomination_repository.dart';

/// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Currency repository provider
final currencyRepositoryProvider = Provider<CurrencyRepository>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return SupabaseCurrencyRepository(supabaseClient);
});

/// Denomination repository provider
final denominationRepositoryProvider = Provider<DenominationRepository>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  final templateService = ref.watch(denominationTemplateServiceProvider);
  return SupabaseDenominationRepository(supabaseClient, templateService);
});

/// Denomination template service provider
final denominationTemplateServiceProvider = Provider<DenominationTemplateService>((ref) {
  return DenominationTemplateService();
});

/// Exchange rate service provider
final exchangeRateServiceProvider = Provider<ExchangeRateService>((ref) {
  return ExchangeRateService();
});
