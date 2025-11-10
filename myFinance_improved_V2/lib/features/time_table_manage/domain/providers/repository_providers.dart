/// Repository Providers for time_table_manage module
///
/// Following Clean Architecture pattern: This file provides a facade
/// to the data layer's repository providers, allowing presentation layer
/// to access repositories through the domain layer.
///
/// This ensures proper dependency flow: Presentation → Domain → Data
export '../../data/providers/time_table_data_providers.dart'
    show timeTableRepositoryProvider;
