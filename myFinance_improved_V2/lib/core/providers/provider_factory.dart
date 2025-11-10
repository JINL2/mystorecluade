// lib/core/providers/provider_factory.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider Factory - Eliminates Provider Boilerplate
///
/// 🎯 Problem:
/// ```dart
/// final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
///   final repo = ref.watch(authRepositoryProvider);
///   return LoginUseCase(authRepository: repo);
/// });
/// // This pattern repeated 100+ times...
/// ```
///
/// ✅ Solution:
/// ```dart
/// final loginUseCaseProvider = ProviderFactory.useCase1(
///   LoginUseCase.new,
///   authRepositoryProvider,
/// );
/// ```
///
/// Reduces 77 lines → 20 lines (74% reduction)
class ProviderFactory {
  /// Create UseCase with 1 Repository dependency
  ///
  /// Example:
  /// ```dart
  /// final loginUseCaseProvider = ProviderFactory.useCase1(
  ///   LoginUseCase.new,  // Constructor reference
  ///   authRepositoryProvider,
  /// );
  /// ```
  static Provider<UC> useCase1<UC, R>(
    UC Function(R) constructor,
    ProviderBase<R> repoProvider,
  ) {
    return Provider<UC>((ref) => constructor(ref.watch(repoProvider)));
  }

  /// Create UseCase with 2 Repository dependencies
  ///
  /// Example:
  /// ```dart
  /// final transferUseCaseProvider = ProviderFactory.useCase2(
  ///   TransferUseCase.new,
  ///   bankRepositoryProvider,
  ///   vaultRepositoryProvider,
  /// );
  /// ```
  static Provider<UC> useCase2<UC, R1, R2>(
    UC Function(R1, R2) constructor,
    ProviderBase<R1> repo1Provider,
    ProviderBase<R2> repo2Provider,
  ) {
    return Provider<UC>((ref) {
      return constructor(
        ref.watch(repo1Provider),
        ref.watch(repo2Provider),
      );
    });
  }

  /// Create UseCase with 3 Repository dependencies
  static Provider<UC> useCase3<UC, R1, R2, R3>(
    UC Function(R1, R2, R3) constructor,
    ProviderBase<R1> repo1Provider,
    ProviderBase<R2> repo2Provider,
    ProviderBase<R3> repo3Provider,
  ) {
    return Provider<UC>((ref) {
      return constructor(
        ref.watch(repo1Provider),
        ref.watch(repo2Provider),
        ref.watch(repo3Provider),
      );
    });
  }

  /// Create Repository with 1 DataSource dependency
  ///
  /// Example:
  /// ```dart
  /// final userRepositoryProvider = ProviderFactory.repository(
  ///   UserRepositoryImpl.new,
  ///   userDataSourceProvider,
  /// );
  /// ```
  static Provider<R> repository<R, DS>(
    R Function(DS) constructor,
    ProviderBase<DS> dataSourceProvider,
  ) {
    return Provider<R>((ref) => constructor(ref.watch(dataSourceProvider)));
  }

  /// Create Repository with 2 DataSource dependencies
  static Provider<R> repository2<R, DS1, DS2>(
    R Function(DS1, DS2) constructor,
    ProviderBase<DS1> ds1Provider,
    ProviderBase<DS2> ds2Provider,
  ) {
    return Provider<R>((ref) {
      return constructor(
        ref.watch(ds1Provider),
        ref.watch(ds2Provider),
      );
    });
  }

  /// Create DataSource with Supabase client
  ///
  /// Example:
  /// ```dart
  /// final userDataSourceProvider = ProviderFactory.dataSource(
  ///   UserDataSource.new,
  ///   supabaseClientProvider,
  /// );
  /// ```
  static Provider<DS> dataSource<DS>(
    DS Function(dynamic) constructor,
    ProviderBase<dynamic> clientProvider,
  ) {
    return Provider<DS>((ref) => constructor(ref.watch(clientProvider)));
  }

  /// Create StateNotifier with dependencies
  ///
  /// Example:
  /// ```dart
  /// final authNotifierProvider = ProviderFactory.stateNotifier<AuthNotifier, AuthState>(
  ///   (ref) => AuthNotifier(
  ///     loginUseCase: ref.watch(loginUseCaseProvider),
  ///     logoutUseCase: ref.watch(logoutUseCaseProvider),
  ///   ),
  /// );
  /// ```
  static StateNotifierProvider<N, S> stateNotifier<N extends StateNotifier<S>, S>(
    N Function(Ref) create,
  ) {
    return StateNotifierProvider<N, S>((ref) => create(ref));
  }

  /// Create AsyncNotifier provider (Riverpod 2.0+)
  ///
  /// Example:
  /// ```dart
  /// final userDataProvider = ProviderFactory.asyncNotifier(
  ///   () => UserDataNotifier(),
  /// );
  /// ```
  static AutoDisposeAsyncNotifierProvider<N, S>
      asyncNotifier<N extends AutoDisposeAsyncNotifier<S>, S>(
    N Function() create,
  ) {
    return AutoDisposeAsyncNotifierProvider<N, S>(create);
  }

  /// Create FutureProvider with auto-dispose
  ///
  /// Example:
  /// ```dart
  /// final currentUserProvider = ProviderFactory.future(
  ///   (ref) => ref.watch(getUserUseCaseProvider).execute(),
  /// );
  /// ```
  static AutoDisposeFutureProvider<T> future<T>(
    Future<T> Function(AutoDisposeFutureProviderRef<T>) create,
  ) {
    return FutureProvider.autoDispose<T>(create);
  }

  /// Create StreamProvider with auto-dispose
  static AutoDisposeStreamProvider<T> stream<T>(
    Stream<T> Function(AutoDisposeStreamProviderRef<T>) create,
  ) {
    return StreamProvider.autoDispose<T>(create);
  }
}

/// Extension methods for cleaner provider syntax
extension ProviderRefX on Ref {
  /// Watch a provider with type inference
  T use<T>(ProviderBase<T> provider) => watch(provider);

  /// Read a provider once
  T once<T>(ProviderBase<T> provider) => read(provider);
}
