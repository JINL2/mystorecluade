import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../../core/services/revenuecat_service.dart';

/// Subscription state for the app
class SubscriptionState {
  final bool isPro;
  final bool isLoading;
  final String? errorMessage;
  final CustomerInfo? customerInfo;

  const SubscriptionState({
    this.isPro = false,
    this.isLoading = false,
    this.errorMessage,
    this.customerInfo,
  });

  SubscriptionState copyWith({
    bool? isPro,
    bool? isLoading,
    String? errorMessage,
    CustomerInfo? customerInfo,
  }) {
    return SubscriptionState(
      isPro: isPro ?? this.isPro,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      customerInfo: customerInfo ?? this.customerInfo,
    );
  }
}

/// Subscription notifier for managing subscription state
class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionNotifier() : super(const SubscriptionState());

  /// Check current subscription status
  Future<void> checkSubscriptionStatus() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final isPro = await RevenueCatService().checkProStatus();
      final customerInfo = await RevenueCatService().getCustomerInfo();

      state = state.copyWith(
        isPro: isPro,
        isLoading: false,
        customerInfo: customerInfo,
      );

      debugPrint('✅ [SubscriptionProvider] Pro status: $isPro');
    } catch (e) {
      debugPrint('❌ [SubscriptionProvider] Error checking status: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Update subscription state after purchase
  void updateProStatus(bool isPro, CustomerInfo? customerInfo) {
    state = state.copyWith(
      isPro: isPro,
      customerInfo: customerInfo,
    );
  }

  /// Reset subscription state (e.g., on logout)
  void reset() {
    state = const SubscriptionState();
  }
}

/// Provider for subscription state
final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionState>((ref) {
  return SubscriptionNotifier();
});

/// Simple provider to check if user is Pro
///
/// Use this provider to conditionally show Pro features:
/// ```dart
/// final isPro = ref.watch(isProProvider);
/// if (isPro) {
///   // Show Pro feature
/// }
/// ```
final isProProvider = Provider<bool>((ref) {
  final subscriptionState = ref.watch(subscriptionProvider);
  return subscriptionState.isPro;
});

/// FutureProvider to fetch Pro status from RevenueCat
///
/// Automatically fetches and caches the Pro status.
/// Use ref.invalidate(proStatusProvider) to refresh.
final proStatusProvider = FutureProvider<bool>((ref) async {
  try {
    final isPro = await RevenueCatService().checkProStatus();

    // Update the subscription state provider too
    ref.read(subscriptionProvider.notifier).updateProStatus(
      isPro,
      await RevenueCatService().getCustomerInfo(),
    );

    return isPro;
  } catch (e) {
    debugPrint('❌ [proStatusProvider] Error: $e');
    return false;
  }
});

/// Provider for available packages (subscription options)
final availablePackagesProvider = FutureProvider<List<Package>>((ref) async {
  try {
    return await RevenueCatService().getAvailablePackages();
  } catch (e) {
    debugPrint('❌ [availablePackagesProvider] Error: $e');
    return [];
  }
});

/// Provider for customer info
final customerInfoProvider = FutureProvider<CustomerInfo?>((ref) async {
  try {
    return await RevenueCatService().getCustomerInfo();
  } catch (e) {
    debugPrint('❌ [customerInfoProvider] Error: $e');
    return null;
  }
});
