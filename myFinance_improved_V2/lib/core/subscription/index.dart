/// Subscription Module
///
/// Centralized subscription limit management for the app.
/// Contains entities, providers, and widgets for subscription-based limits.
///
/// 2026 Update: Added SubscriptionStateNotifier for real-time subscription updates
/// via RevenueCat SDK listener + Supabase Realtime.
///
/// Usage:
/// ```dart
/// import 'package:myfinance_improved/core/subscription/index.dart';
///
/// // Initialize subscription state after login
/// await ref.read(subscriptionStateNotifierProvider.notifier).initialize(userId);
///
/// // Check limits from SubscriptionState (real-time, preferred)
/// final storeLimit = ref.watch(storeLimitFromSubscriptionStateProvider);
///
/// // Check limits from AppState cache (fallback, instant UI response)
/// final storeLimit = ref.watch(storeLimitFromCacheProvider);
///
/// if (!storeLimit.canAdd) {
///   SubscriptionUpgradeDialog.show(context, limitCheck: storeLimit, resourceType: 'store');
/// }
///
/// // Force refresh subscription after purchase
/// await ref.read(subscriptionStateNotifierProvider.notifier).forceRefresh(userId);
/// ```
library;

// Entities
export 'entities/subscription_limit_check.dart';
export 'entities/subscription_state.dart';

// Providers
export 'providers/subscription_limit_providers.dart';
export 'providers/subscription_state_notifier.dart';

// Widgets
export 'widgets/limit_aware_option_card.dart';
export 'widgets/subscription_upgrade_dialog.dart';
