import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../domain/entities/revenue.dart';
import '../../domain/revenue_period.dart';
import '../providers/homepage_providers.dart';

class RevenueCard extends ConsumerWidget {
  const RevenueCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch selected period and tab
    final selectedPeriod = ref.watch(selectedRevenuePeriodProvider);
    final selectedTab = ref.watch(selectedRevenueTabProvider);

    // REMOVED: autoSwitchToStoreTabProvider - 사용자 탭 선택 유지

    // Enable company/store change logging (debug only)
    ref.watch(companyChangeListenerProvider);
    ref.watch(storeChangeListenerProvider);

    // Watch revenue data with cache (Toss style - prevents layout jump)
    final revenueState = ref.watch(revenueWithCacheProvider(selectedPeriod));

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
              // Title with period selector (TossBottomSheet)
              GestureDetector(
                onTap: () => _showPeriodSelector(context, ref, selectedPeriod),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selectedPeriod.displayName,
                      style: TossTextStyles.titleMedium.copyWith(
                        color: TossColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space1),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: TossColors.textSecondary,
                      size: 20,
                    ),
                  ],
                ),
              ),

              // Company/Store tabs on right
              _TabSelector(
                key: ValueKey(selectedTab), // 탭 상태 변경 시 위젯 재생성
                selectedTab: selectedTab,
                onTabChanged: (RevenueViewTab tab) {
                  ref.read(selectedRevenueTabProvider.notifier).state = tab;
                },
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space4),

          // Revenue amount - Toss style: show cached data with shimmer overlay
          _buildRevenueContent(revenueState),
        ],
      ),
    );
  }

  /// Builds revenue content with Toss-style loading overlay
  /// Shows previous data with shimmer when loading new data
  Widget _buildRevenueContent(RevenueWithLoadingState state) {
    // Case 1: Has data (fresh or cached) - show with optional loading overlay
    if (state.hasData) {
      return _RevenueContentWithOverlay(
        revenue: state.revenue!,
        isLoading: state.isRefreshing,
      );
    }

    // Case 2: Initial loading (no cached data yet)
    if (state.isLoading) {
      return const _LoadingRevenue();
    }

    // Case 3: Error with no cached data
    if (state.hasError) {
      return _ErrorRevenue(error: state.error.toString());
    }

    // Fallback
    return const _LoadingRevenue();
  }

  void _showPeriodSelector(
    BuildContext context,
    WidgetRef ref,
    RevenuePeriod selectedPeriod,
  ) {
    // Convert RevenuePeriod enum to SelectionItem list
    final items = RevenuePeriod.values.map((period) {
      return SelectionItem(
        id: period.name,
        title: period.displayName,
      );
    }).toList();

    SelectionBottomSheetCommon.show(
      context: context,
      title: 'Select Period',
      maxHeightRatio: 0.55, // 6 items need more space to avoid scrolling
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = item.id == selectedPeriod.name;
        return SelectionListItem(
          item: item,
          isSelected: isSelected,
          variant: SelectionItemVariant.minimal,
          onTap: () {
            final period = RevenuePeriod.values.firstWhere(
              (p) => p.name == item.id,
              orElse: () => RevenuePeriod.today,
            );
            // Mark as user manually selected - disable auto-switch
            ref.read(userManuallySelectedPeriodProvider.notifier).state = true;
            ref.read(selectedRevenuePeriodProvider.notifier).state = period;
            Navigator.pop(context);
          },
        );
      },
    );
  }
}

/// Revenue content with optional shimmer overlay (Toss style)
/// When isLoading is true, shows shimmer animation over the existing content
class _RevenueContentWithOverlay extends StatelessWidget {
  final Revenue revenue;
  final bool isLoading;

  const _RevenueContentWithOverlay({
    required this.revenue,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Actual content (always visible)
        _RevenueContent(revenue: revenue),

        // Shimmer overlay when loading
        if (isLoading)
          Positioned.fill(
            child: _ShimmerOverlay(),
          ),
      ],
    );
  }
}

/// Actual revenue display content with smooth number animation
class _RevenueContent extends StatefulWidget {
  final Revenue revenue;

  const _RevenueContent({required this.revenue});

  @override
  State<_RevenueContent> createState() => _RevenueContentState();
}

class _RevenueContentState extends State<_RevenueContent>
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
    _previousAmount = widget.revenue.amount;
    _amountAnimation = AlwaysStoppedAnimation(widget.revenue.amount);
  }

  @override
  void didUpdateWidget(covariant _RevenueContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.revenue.amount != widget.revenue.amount) {
      _previousAmount = oldWidget.revenue.amount;
      _amountAnimation = Tween<double>(
        begin: _previousAmount,
        end: widget.revenue.amount,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: TossAnimations.standard,
      ));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatAmount(double amount) {
    final intAmount = amount.toInt();
    return intAmount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Animated Amount
        AnimatedBuilder(
          animation: _amountAnimation,
          builder: (context, child) {
            return Text(
              '${widget.revenue.currencyCode}${_formatAmount(_amountAnimation.value)}',
              style: TossTextStyles.h1.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w700,
                height: 1.2,
                letterSpacing: -1.0,
              ),
            );
          },
        ),

        // Growth indicator with smooth transition
        AnimatedSwitcher(
          duration: TossAnimations.normal,
          switchInCurve: TossAnimations.enter,
          switchOutCurve: TossAnimations.exit,
          child: Padding(
            key: ValueKey('${widget.revenue.growthPercentage}_${widget.revenue.isIncreased}'),
            padding: const EdgeInsets.only(top: TossSpacing.space1),
            child: widget.revenue.previousAmount != 0
                ? Row(
                    children: [
                      Icon(
                        widget.revenue.isIncreased ? Icons.trending_up : Icons.trending_down,
                        color: widget.revenue.isIncreased ? TossColors.primary : TossColors.error,
                        size: 16,
                      ),
                      const SizedBox(width: TossSpacing.space1),
                      Text(
                        '${widget.revenue.isIncreased ? '' : '-'}${widget.revenue.growthPercentage.abs().toStringAsFixed(1)}% ${widget.revenue.period.comparisonText}',
                        style: TossTextStyles.caption.copyWith(
                          color: widget.revenue.isIncreased ? TossColors.primary : TossColors.error,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )
                : SizedBox(height: TossSpacing.space4),
          ),
        ),
      ],
    );
  }
}

/// Shimmer overlay animation using TossAnimations
class _ShimmerOverlay extends StatefulWidget {
  @override
  State<_ShimmerOverlay> createState() => _ShimmerOverlayState();
}

class _ShimmerOverlayState extends State<_ShimmerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: TossAnimations.loadingPulse, // 1200ms - Toss shimmer timing
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

/// Initial loading state (when no cached data available)
class _LoadingRevenue extends StatelessWidget {
  const _LoadingRevenue();

  @override
  Widget build(BuildContext context) {
    // Use fixed height to prevent layout jump
    return SizedBox(
      height: 56, // 36 (amount) + 4 (spacing) + 16 (growth indicator)
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 36,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
          ),
          SizedBox(height: TossSpacing.space1),
          Container(
            width: 150,
            height: 16,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabSelector extends StatefulWidget {
  final RevenueViewTab selectedTab;
  final ValueChanged<RevenueViewTab> onTabChanged;

  const _TabSelector({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  State<_TabSelector> createState() => _TabSelectorState();
}

class _TabSelectorState extends State<_TabSelector> {
  @override
  Widget build(BuildContext context) {
    return TossSectionBar.compact(
      tabs: const ['Store', 'Company'],
      initialIndex: widget.selectedTab == RevenueViewTab.store ? 0 : 1,
      onTabChanged: (index) {
        widget.onTabChanged(index == 0 ? RevenueViewTab.store : RevenueViewTab.company);
      },
    );
  }
}

class _ErrorRevenue extends StatelessWidget {
  final String error;

  const _ErrorRevenue({required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.error.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: TossColors.white,
            size: 20,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              'Unable to load revenue data',
              style: TossTextStyles.body.copyWith(
                color: TossColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
