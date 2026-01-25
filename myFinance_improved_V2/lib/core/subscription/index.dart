/// Subscription Module
///
/// Centralized subscription limit management for the app.
/// Contains entities, providers, and widgets for subscription-based limits.
///
/// 2026 Update: Added SubscriptionStateNotifier for real-time subscription updates
/// via RevenueCat SDK listener + Supabase Realtime.
///
/// ## Architecture (2026-01-25)
///
/// ```
/// SubscriptionStateNotifier ───▶ Subscription data (planName, limits)
/// AppState ───────────────────▶ Usage counts (storeCount, employeeCount)
/// xxxLimitFromCache Providers ─▶ Combined limit checks for UI
/// xxxLimitFresh Providers ────▶ RPC-based checks before create actions
/// ```
///
/// ## Usage
///
/// ```dart
/// import 'package:myfinance_improved/core/subscription/index.dart';
///
/// // Initialize subscription state after login
/// await ref.read(subscriptionStateNotifierProvider.notifier).initialize(userId);
///
/// // Check limits from AppState cache (instant UI response)
/// final storeLimit = ref.watch(storeLimitFromCacheProvider);
/// final employeeLimit = ref.watch(employeeLimitFromCacheProvider);
/// final companyLimit = ref.watch(companyLimitFromCacheProvider);
///
/// if (!storeLimit.canAdd) {
///   SubscriptionUpgradeDialog.show(context, limitCheck: storeLimit, resourceType: 'store');
/// }
///
/// // Fresh limit check before create action (RPC-based)
/// final freshLimit = await ref.read(storeLimitFreshProvider.future);
///
/// // Force refresh subscription after purchase
/// await ref.read(subscriptionStateNotifierProvider.notifier).forceRefresh(userId);
///
/// // Access subscription state directly for UI display
/// final subState = ref.watch(subscriptionStateNotifierProvider).valueOrNull;
/// final planName = subState?.planName ?? 'free';
/// final isPaid = subState?.isPaid ?? false;
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
