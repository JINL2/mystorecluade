import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../domain/providers/repository_providers.dart';

/// Salary view tab enum
enum SalaryViewTab { company, store }

/// Provider for selected salary tab (default: company)
final selectedSalaryTabProvider = StateProvider<SalaryViewTab>((ref) => SalaryViewTab.company);

/// Provider for fetching user's salary using homepage_user_salary RPC
///
/// Returns full RPC response with company_total and by_store data.
/// Uses HomepageRepository (Clean Architecture) instead of direct DataSource access.
final homepageUserSalaryProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final appState = ref.watch(appStateProvider);
  final repository = ref.read(homepageRepositoryProvider);

  final userId = appState.userId;
  final companyId = appState.companyChoosen;

  if (userId.isEmpty || companyId.isEmpty) {
    return _defaultSalaryResponse();
  }

  try {
    final response = await repository.getUserSalary(
      userId: userId,
      companyId: companyId,
      timezone: 'Asia/Ho_Chi_Minh', // TODO: Get from device
    );

    // Check for error in response
    if (response['error'] == true) {
      return _defaultSalaryResponse();
    }

    return response;
  } catch (e) {
    return _defaultSalaryResponse();
  }
});

/// Default salary response when no data available
Map<String, dynamic> _defaultSalaryResponse() {
  return {
    'salary_info': {
      'salary_type': 'hourly',
      'salary_amount': 0,
      'currency_code': 'VND',
      'currency_symbol': '₫',
    },
    'by_store': <Map<String, dynamic>>[],
    'company_total': {
      'today': _defaultPeriodStats(),
      'this_week': _defaultPeriodStats(),
      'this_month': _defaultPeriodStats(),
      'last_month': _defaultPeriodStats(),
      'this_year': _defaultPeriodStats(),
    },
  };
}

Map<String, dynamic> _defaultPeriodStats() {
  return {
    'total_confirmed_hours': 0,
    'base_pay': 0,
    'bonus_pay': 0,
    'total_payment': 0,
    'previous_total_payment': 0,
    'change_percentage': 0,
  };
}

// ============================================================================
// Cached Salary for Smooth UI Transitions (Toss Style)
// ============================================================================

/// Holds the last successfully loaded salary data
final _cachedSalaryProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

/// Provider that returns cached salary + loading state
/// Enables "show previous data with shimmer overlay" pattern
final salaryWithCacheProvider = Provider<SalaryWithLoadingState>((ref) {
  final asyncValue = ref.watch(homepageUserSalaryProvider);
  final cachedSalary = ref.watch(_cachedSalaryProvider);

  // Update cache when new data arrives successfully
  // Use ref.listen instead of whenData + Future.microtask to avoid disposed ref issues
  ref.listen(homepageUserSalaryProvider, (previous, next) {
    next.whenData((data) {
      ref.read(_cachedSalaryProvider.notifier).state = data;
    });
  });

  return SalaryWithLoadingState(
    data: asyncValue.valueOrNull ?? cachedSalary,
    isLoading: asyncValue.isLoading,
    hasError: asyncValue.hasError,
    error: asyncValue.error,
  );
});

/// State class that holds salary data with loading status
class SalaryWithLoadingState {
  final Map<String, dynamic>? data;
  final bool isLoading;
  final bool hasError;
  final Object? error;

  const SalaryWithLoadingState({
    required this.data,
    required this.isLoading,
    required this.hasError,
    this.error,
  });

  bool get hasData => data != null;
  bool get isRefreshing => isLoading && hasData;
}

/// Salary Card - Shows user's monthly salary
///
/// Displayed when user doesn't have permission to view company revenue.
/// Uses homepage_user_salary RPC for data.
/// - Company tab: Shows company_total.this_month
/// - Store tab: Shows selected store's this_month from by_store array
class SalaryCard extends ConsumerWidget {
  const SalaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use cached salary provider (Toss style - prevents layout jump)
    final salaryState = ref.watch(salaryWithCacheProvider);
    final selectedTab = ref.watch(selectedSalaryTabProvider);
    final appState = ref.watch(appStateProvider);

    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space5),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Company/Store tabs on right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title
              Text(
                'My Salary',
                style: TossTextStyles.titleMedium.copyWith(
                  color: TossColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),

              // Company/Store tabs on right
              _SalaryTabSelector(
                selectedTab: selectedTab,
                onTabChanged: (SalaryViewTab tab) {
                  ref.read(selectedSalaryTabProvider.notifier).state = tab;
                },
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),

          // Salary Amount - Toss style: show cached data with shimmer overlay
          _buildSalaryDisplay(salaryState, selectedTab, appState.storeChoosen),
        ],
      ),
    );
  }

  /// Builds salary display with Toss-style loading overlay
  Widget _buildSalaryDisplay(
    SalaryWithLoadingState state,
    SalaryViewTab selectedTab,
    String selectedStoreId,
  ) {
    // Case 1: Has data (fresh or cached) - show with optional loading overlay
    if (state.hasData) {
      return _SalaryContentWithOverlay(
        salaryData: state.data!,
        selectedTab: selectedTab,
        selectedStoreId: selectedStoreId,
        isLoading: state.isRefreshing,
      );
    }

    // Case 2: Initial loading (no cached data yet)
    if (state.isLoading) {
      return _buildLoadingState();
    }

    // Case 3: Error with no cached data
    if (state.hasError) {
      return _buildErrorState(state.error.toString());
    }

    // Fallback
    return _buildLoadingState();
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: TossSpacing.space20 * 2.5,
          height: TossSpacing.space9,
          decoration: BoxDecoration(
            color: TossColors.gray100,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          width: TossSpacing.space20 * 1.875,
          height: TossSpacing.space5,
          decoration: BoxDecoration(
            color: TossColors.gray100,
            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: TossColors.error,
            size: TossSpacing.iconMD,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              'Unable to load salary information',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Format amount with comma separator (like 3,611,500)
  String _formatAmountWithComma(double amount) {
    final intAmount = amount.toInt();
    return intAmount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

/// Tab selector for Company/Store toggle
class _SalaryTabSelector extends StatelessWidget {
  final SalaryViewTab selectedTab;
  final ValueChanged<SalaryViewTab> onTabChanged;

  const _SalaryTabSelector({
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTab(
          'Company',
          SalaryViewTab.company,
          selectedTab == SalaryViewTab.company,
        ),
        _buildTab(
          'Store',
          SalaryViewTab.store,
          selectedTab == SalaryViewTab.store,
        ),
      ],
    );
  }

  Widget _buildTab(String label, SalaryViewTab tab, bool isSelected) {
    return GestureDetector(
      onTap: () => onTabChanged(tab),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3 + TossSpacing.space1 / 2,
          vertical: TossSpacing.space1 + TossSpacing.space1 / 2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : TossColors.transparent,
          borderRadius: BorderRadius.circular(TossBorderRadius.full),
        ),
        child: Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: isSelected ? TossColors.white : TossColors.textTertiary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Salary content with optional shimmer overlay (Toss style)
class _SalaryContentWithOverlay extends StatelessWidget {
  final Map<String, dynamic> salaryData;
  final SalaryViewTab selectedTab;
  final String selectedStoreId;
  final bool isLoading;

  const _SalaryContentWithOverlay({
    required this.salaryData,
    required this.selectedTab,
    required this.selectedStoreId,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Actual content (always visible)
        _SalaryContent(
          salaryData: salaryData,
          selectedTab: selectedTab,
          selectedStoreId: selectedStoreId,
        ),

        // Shimmer overlay when loading
        if (isLoading)
          Positioned.fill(
            child: _SalaryShimmerOverlay(),
          ),
      ],
    );
  }
}

/// Actual salary display content with smooth number animation
class _SalaryContent extends StatefulWidget {
  final Map<String, dynamic> salaryData;
  final SalaryViewTab selectedTab;
  final String selectedStoreId;

  const _SalaryContent({
    required this.salaryData,
    required this.selectedTab,
    required this.selectedStoreId,
  });

  @override
  State<_SalaryContent> createState() => _SalaryContentState();
}

class _SalaryContentState extends State<_SalaryContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _amountAnimation;
  double _previousAmount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: TossAnimations.medium,
      vsync: this,
    );
    final stats = _getThisMonthStats();
    _previousAmount = (stats['total_payment'] as num?)?.toDouble() ?? 0.0;
    _amountAnimation = AlwaysStoppedAnimation(_previousAmount);
  }

  @override
  void didUpdateWidget(covariant _SalaryContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newStats = _getThisMonthStats();
    final newAmount = (newStats['total_payment'] as num?)?.toDouble() ?? 0.0;

    if (_previousAmount != newAmount) {
      _amountAnimation = Tween<double>(
        begin: _previousAmount,
        end: newAmount,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: TossAnimations.standard,
      ));
      _controller.forward(from: 0);
      _previousAmount = newAmount;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Map<String, dynamic> _getThisMonthStats() {
    if (widget.selectedTab == SalaryViewTab.company) {
      final companyTotal = widget.salaryData['company_total'] as Map<String, dynamic>? ?? {};
      return companyTotal['this_month'] as Map<String, dynamic>? ?? _defaultPeriodStats();
    } else {
      final byStore = widget.salaryData['by_store'] as List<dynamic>? ?? [];
      for (final item in byStore) {
        final store = item as Map<String, dynamic>;
        if (store['store_id'] == widget.selectedStoreId) {
          return store['this_month'] as Map<String, dynamic>? ?? _defaultPeriodStats();
        }
      }
      return _defaultPeriodStats();
    }
  }

  String _formatAmountWithComma(double amount) {
    final intAmount = amount.toInt();
    return intAmount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    final salaryInfo = widget.salaryData['salary_info'] as Map<String, dynamic>? ?? {};
    final currencySymbol = salaryInfo['currency_symbol'] as String? ?? '₫';
    final thisMonthStats = _getThisMonthStats();

    final bonusPay = (thisMonthStats['bonus_pay'] as num?)?.toDouble() ?? 0.0;
    final changePercentage = (thisMonthStats['change_percentage'] as num?)?.toDouble() ?? 0.0;
    final previousPayment = (thisMonthStats['previous_total_payment'] as num?)?.toDouble() ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Animated Amount
        AnimatedBuilder(
          animation: _amountAnimation,
          builder: (context, child) {
            return Text(
              '$currencySymbol${_formatAmountWithComma(_amountAnimation.value)}',
              style: TossTextStyles.h1.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w700,
                height: 1.2,
                letterSpacing: -1.0,
              ),
            );
          },
        ),

        // Change percentage with smooth transition
        AnimatedSwitcher(
          duration: TossAnimations.normal,
          switchInCurve: TossAnimations.enter,
          switchOutCurve: TossAnimations.exit,
          child: previousPayment > 0
              ? Padding(
                  key: ValueKey('change_$changePercentage'),
                  padding: const EdgeInsets.only(top: TossSpacing.space1),
                  child: Row(
                    children: [
                      Icon(
                        changePercentage >= 0 ? Icons.trending_up : Icons.trending_down,
                        color: changePercentage >= 0 ? TossColors.primary : TossColors.error,
                        size: TossSpacing.iconSM2,
                      ),
                      const SizedBox(width: TossSpacing.space1),
                      Text(
                        '${changePercentage.toStringAsFixed(1)}% vs last month',
                        style: TossTextStyles.caption.copyWith(
                          color: changePercentage >= 0 ? TossColors.primary : TossColors.error,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(key: ValueKey('no_change'), height: 20),
        ),

        // Overtime bonus with smooth transition
        AnimatedSwitcher(
          duration: TossAnimations.normal,
          switchInCurve: TossAnimations.enter,
          switchOutCurve: TossAnimations.exit,
          child: bonusPay > 0
              ? Padding(
                  key: ValueKey('bonus_$bonusPay'),
                  padding: const EdgeInsets.only(top: TossSpacing.space2),
                  child: Text(
                    '+$currencySymbol${_formatAmountWithComma(bonusPay)} overtime bonus',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('no_bonus')),
        ),
      ],
    );
  }
}

/// Shimmer overlay animation for salary using TossAnimations
class _SalaryShimmerOverlay extends StatefulWidget {
  @override
  State<_SalaryShimmerOverlay> createState() => _SalaryShimmerOverlayState();
}

class _SalaryShimmerOverlayState extends State<_SalaryShimmerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: TossAnimations.loadingPulse,
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: TossAnimations.standard),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                TossColors.surface.withValues(alpha: 0.0),
                TossColors.surface.withValues(alpha: 0.5),
                TossColors.surface.withValues(alpha: 0.0),
              ],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
