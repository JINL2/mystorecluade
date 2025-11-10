// lib/features/auth/domain/policies/cache_policy.dart

/// Cache policy defining TTL (Time To Live) for various data types
///
/// This is a domain-level policy that defines business rules about
/// how often we should refresh data from the server.
abstract class CachePolicy {
  /// How long user data remains fresh before needing refresh
  Duration get userDataTTL;

  /// How long feature/permission data remains fresh
  Duration get featuresTTL;

  /// Check if user data should be refreshed based on last fetch time
  bool shouldRefreshUserData(DateTime lastFetchTime) {
    final now = DateTime.now();
    return now.difference(lastFetchTime) > userDataTTL;
  }

  /// Check if features should be refreshed based on last fetch time
  bool shouldRefreshFeatures(DateTime lastFetchTime) {
    final now = DateTime.now();
    return now.difference(lastFetchTime) > featuresTTL;
  }
}

/// Production cache policy with reasonable TTL values
class ProductionCachePolicy implements CachePolicy {
  const ProductionCachePolicy();

  @override
  Duration get userDataTTL => const Duration(hours: 2);

  @override
  Duration get featuresTTL => const Duration(hours: 6);

  @override
  bool shouldRefreshUserData(DateTime lastFetchTime) {
    final now = DateTime.now();
    return now.difference(lastFetchTime) > userDataTTL;
  }

  @override
  bool shouldRefreshFeatures(DateTime lastFetchTime) {
    final now = DateTime.now();
    return now.difference(lastFetchTime) > featuresTTL;
  }
}

/// Development cache policy with shorter TTL for faster iteration
class DevelopmentCachePolicy implements CachePolicy {
  const DevelopmentCachePolicy();

  @override
  Duration get userDataTTL => const Duration(minutes: 5);

  @override
  Duration get featuresTTL => const Duration(minutes: 15);

  @override
  bool shouldRefreshUserData(DateTime lastFetchTime) {
    final now = DateTime.now();
    return now.difference(lastFetchTime) > userDataTTL;
  }

  @override
  bool shouldRefreshFeatures(DateTime lastFetchTime) {
    final now = DateTime.now();
    return now.difference(lastFetchTime) > featuresTTL;
  }
}
