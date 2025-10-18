import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/features/homepage/data/datasources/company_remote_datasource.dart';
import 'package:myfinance_improved/features/homepage/data/repositories/company_repository_impl.dart';
import 'package:myfinance_improved/features/homepage/domain/repositories/company_repository.dart';
import 'package:myfinance_improved/features/homepage/domain/usecases/create_company.dart';
import 'package:myfinance_improved/features/homepage/domain/usecases/get_company_types.dart';
import 'package:myfinance_improved/features/homepage/domain/usecases/get_currencies.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/company_type.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/currency.dart';
import 'package:myfinance_improved/features/homepage/presentation/providers/company_state.dart';
import 'package:myfinance_improved/features/homepage/presentation/providers/company_notifier.dart';

/// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Company Remote Data Source provider
final companyRemoteDataSourceProvider = Provider<CompanyRemoteDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return CompanyRemoteDataSourceImpl(supabaseClient);
});

/// Company Repository provider
final companyRepositoryProvider = Provider<CompanyRepository>((ref) {
  final remoteDataSource = ref.watch(companyRemoteDataSourceProvider);
  return CompanyRepositoryImpl(remoteDataSource);
});

/// Create Company Use Case provider
final createCompanyUseCaseProvider = Provider<CreateCompany>((ref) {
  final repository = ref.watch(companyRepositoryProvider);
  return CreateCompany(repository);
});

/// Get Company Types Use Case provider
final getCompanyTypesUseCaseProvider = Provider<GetCompanyTypes>((ref) {
  final repository = ref.watch(companyRepositoryProvider);
  return GetCompanyTypes(repository);
});

/// Get Currencies Use Case provider
final getCurrenciesUseCaseProvider = Provider<GetCurrencies>((ref) {
  final repository = ref.watch(companyRepositoryProvider);
  return GetCurrencies(repository);
});

/// Company Types FutureProvider for dropdown
final companyTypesProvider = FutureProvider<List<CompanyType>>((ref) async {
  final getCompanyTypes = ref.watch(getCompanyTypesUseCaseProvider);
  final result = await getCompanyTypes();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (companyTypes) => companyTypes,
  );
});

/// Currencies FutureProvider for dropdown
final currenciesProvider = FutureProvider<List<Currency>>((ref) async {
  final getCurrencies = ref.watch(getCurrenciesUseCaseProvider);
  final result = await getCurrencies();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (currencies) => currencies,
  );
});

/// Company StateNotifier Provider
final companyNotifierProvider =
    StateNotifierProvider<CompanyNotifier, CompanyState>((ref) {
  final createCompany = ref.watch(createCompanyUseCaseProvider);
  return CompanyNotifier(createCompany);
});
