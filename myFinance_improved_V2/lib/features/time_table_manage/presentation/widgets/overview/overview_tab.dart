import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/shift_metadata.dart';
import '../../providers/states/time_table_state.dart';
import '../../providers/time_table_providers.dart';
import 'attention_items_builder.dart';
import 'attention_timeline.dart';
import 'current_activity_card_builder.dart';
import 'overview_helpers.dart';
import 'upcoming_card_builder.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import 'package:myfinance_improved/shared/widgets/organisms/skeleton/toss_detail_skeleton.dart';

/// Overview Tab
///
/// Main overview tab showing:
/// - Store selector
/// - Currently Active shift with snapshot metrics
/// - Upcoming shift with staff grid
/// - Need Attention horizontal scroll
class OverviewTab extends ConsumerStatefulWidget {
  final String? selectedStoreId;
  final VoidCallback onStoreSelectorTap;
  final void Function(String storeId)? onStoreChanged;
  /// Callback to navigate to Schedule tab with a specific date
  final void Function(DateTime date)? onNavigateToSchedule;
  /// Callback to navigate to Problems tab with a specific date
  final void Function(DateTime date)? onNavigateToProblems;

  const OverviewTab({
    super.key,
    required this.selectedStoreId,
    required this.onStoreSelectorTap,
    this.onStoreChanged,
    this.onNavigateToSchedule,
    this.onNavigateToProblems,
  });

  @override
  ConsumerState<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends ConsumerState<OverviewTab>
    with OverviewHelpersMixin {
  /// Center date for the attention timeline (defaults to today)
  late DateTime _timelineCenterDate;

  /// Attention items builder (handles complex attention item logic)
  late AttentionItemsBuilder _attentionItemsBuilder;

  @override
  void initState() {
    super.initState();
    _timelineCenterDate = DateTime.now();
    _attentionItemsBuilder = AttentionItemsBuilder(
      selectedStoreId: widget.selectedStoreId,
    );
  }

  @override
  void didUpdateWidget(OverviewTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update builder when store changes
    if (widget.selectedStoreId != oldWidget.selectedStoreId) {
      _attentionItemsBuilder = AttentionItemsBuilder(
        selectedStoreId: widget.selectedStoreId,
      );
    }
  }

  /// Move timeline to previous 5 days
  void _navigateToPreviousDays() {
    setState(() {
      _timelineCenterDate = _timelineCenterDate.subtract(const Duration(days: 5));
    });
  }

  /// Move timeline to next 5 days
  void _navigateToNextDays() {
    setState(() {
      _timelineCenterDate = _timelineCenterDate.add(const Duration(days: 5));
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final stores = extractStores(appState.user, appState.companyChoosen);

    // If no store selected, show store selector only (if multiple stores exist)
    if (widget.selectedStoreId == null || widget.selectedStoreId!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (stores.length > 1) ...[
              _buildStoreSelector(stores),
              const SizedBox(height: TossSpacing.space6),
            ],
            const Expanded(
              child: Center(
                child: Text('Please select a store'),
              ),
            ),
          ],
        ),
      );
    }

    // Watch monthly shift status for current activity data
    final monthlyStatusState = ref.watch(monthlyShiftStatusProvider(widget.selectedStoreId!));

    // Watch manager cards for attendance data (on-time/late/not-checked-in)
    final managerCardsState = ref.watch(managerCardsProvider(widget.selectedStoreId!));

    // Watch shift metadata for all available shifts (including those with 0 requests)
    final shiftMetadataAsync = ref.watch(shiftMetadataProvider(widget.selectedStoreId!));

    // Check loading states
    final isMonthlyStatusLoading = monthlyStatusState.isLoading;
    final isManagerCardsLoading = managerCardsState.isLoading;
    final isMetadataLoading = shiftMetadataAsync.isLoading;

    // ✅ FIX: Check if we have cached data
    // Only show full loading view for INITIAL load (no cached data)
    // During refresh, keep showing cached data to prevent "data disappearing" UX issue
    final hasMonthlyData = monthlyStatusState.dataByMonth.isNotEmpty;
    final hasCardsData = managerCardsState.dataByMonth.isNotEmpty;
    final hasMetadata = shiftMetadataAsync.valueOrNull != null;
    final hasCachedData = hasMonthlyData || hasCardsData || hasMetadata;

    final isInitialLoading = (isMonthlyStatusLoading || isManagerCardsLoading || isMetadataLoading) && !hasCachedData;

    // Show skeleton ONLY for initial load (no cached data yet)
    if (isInitialLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStoreSelector(stores),
            const Expanded(
              child: TossDetailSkeleton(
                showHeader: false,
                showChart: false,
                sectionCount: 3,
              ),
            ),
          ],
        ),
      );
    }

    // All data is ready - extract values
    final allDailyShifts = monthlyStatusState.allMonthlyStatuses
        .expand((status) => status.dailyShifts)
        .toList();
    final shiftMetadata = shiftMetadataAsync.valueOrNull;

    // ✅ UseCase: Find current activity shift
    final findCurrentShiftUseCase = ref.watch(findCurrentShiftUseCaseProvider);
    final currentActivityShift = findCurrentShiftUseCase(allDailyShifts);

    // ✅ UseCase: Find upcoming shift (next after current activity)
    final findUpcomingShiftUseCase = ref.watch(findUpcomingShiftUseCaseProvider);
    final upcomingShift = findUpcomingShiftUseCase(allDailyShifts, currentActivityShift);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Extra spacing above Store
          const SizedBox(height: TossSpacing.space4),

          // 1️⃣ Store Selector Dropdown (hide if only 1 store)
          if (stores.length > 1) ...[
            _buildStoreSelector(stores),
            const SizedBox(height: TossSpacing.space6),
          ],

          // 2️⃣ Currently Active Section
          _buildSectionLabel('Currently Active'),
          const SizedBox(height: TossSpacing.space2),
          CurrentActivityCardBuilder(
            selectedStoreId: widget.selectedStoreId,
            currentShift: currentActivityShift,
            managerCardsState: managerCardsState,
            allDailyShifts: allDailyShifts,
          ),
          const SizedBox(height: TossSpacing.space6),

          // 3️⃣ Upcoming Section
          _buildSectionLabel('Upcoming'),
          const SizedBox(height: TossSpacing.space2),
          UpcomingCardBuilder(upcomingShift: upcomingShift),
          const SizedBox(height: TossSpacing.space6),

          // 4️⃣ Need Attention Section (Timeline View)
          _buildNeedAttentionTimeline(managerCardsState, monthlyStatusState, shiftMetadata),
        ],
      ),
    );
  }

  /// Build section label
  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TossTextStyles.labelMedium.copyWith(
        color: TossColors.gray600,
      ),
    );
  }

  /// Build Need Attention Timeline (new design)
  ///
  /// Shows a 5-day timeline with:
  /// - Orange dots = Coverage gaps (tap → Schedule tab)
  /// - Red dots = Staff problems (tap → Problems tab)
  /// - Pagination: `< 7 more` and `5 more >` buttons
  ///
  /// OPTIMIZATION: Uses centralized coverageGapProvider for consistent data
  /// across Overview and Schedule tabs. Single source of truth for:
  /// - Business hours (no default value fallback during loading)
  /// - Coverage gap calculation
  /// - TODAY time-based filtering
  Widget _buildNeedAttentionTimeline(
    ManagerShiftCardsState? managerCardsState,
    MonthlyShiftStatusState? monthlyStatusState,
    ShiftMetadata? shiftMetadata,
  ) {
    // Use centralized coverage gap provider for consistent data across tabs
    // This provider handles business hours fetching internally and waits for loading
    CoverageGapState? coverageGapState;
    if (widget.selectedStoreId != null) {
      final now = DateTime.now();
      final state = ref.watch(monthCoverageGapProvider(MonthCoverageGapKey(
        storeId: widget.selectedStoreId!,
        year: now.year,
        month: now.month,
      )));

      // If coverage gap provider is still loading, show loading state
      if (state.isLoading) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
          child: TossLoadingView.inline(size: TossSpacing.iconLG),
        );
      }
      coverageGapState = state;
    }

    final attentionItems = _attentionItemsBuilder.getAttentionItems(
      managerCardsState: managerCardsState,
      monthlyStatusState: monthlyStatusState,
      shiftMetadata: shiftMetadata,
      getAllCards: getAllCards,
      formatDate: formatDate,
      formatTimeRange: formatTimeRange,
      parseShiftEndTime: parseShiftEndTime,
      coverageGapState: coverageGapState,
    );

    // Get pre-computed problem count from problemStatusProvider (O(1) - already cached)
    // This ensures consistency with Problems tab and avoids redundant calculations
    final int? precomputedProblemCount;
    if (widget.selectedStoreId != null) {
      final problemData = ref.watch(problemStatusProvider(ProblemStatusKey(
        storeId: widget.selectedStoreId!,
        focusedMonth: DateTime.now(), // Overview uses current month
      )));
      precomputedProblemCount = problemData.thisMonthCount;
    } else {
      precomputedProblemCount = null;
    }

    return AttentionTimeline(
      items: attentionItems,
      centerDate: _timelineCenterDate,
      precomputedProblemCount: precomputedProblemCount,
      onDateTap: (date, hasProblem) {
        // Tap on date circle: if has problems → Problems tab, otherwise → Schedule tab
        if (hasProblem) {
          widget.onNavigateToProblems?.call(date);
        } else {
          widget.onNavigateToSchedule?.call(date);
        }
      },
      onScheduleTap: (date) {
        // Navigate to Schedule tab with the selected date
        widget.onNavigateToSchedule?.call(date);
      },
      onProblemTap: (date) {
        // Navigate to Problems tab with the selected date
        widget.onNavigateToProblems?.call(date);
      },
      onPrevious: _navigateToPreviousDays,
      onNext: _navigateToNextDays,
    );
  }

  /// Build store selector dropdown (same as Schedule tab)
  Widget _buildStoreSelector(List<dynamic> stores) {
    final storeItems = stores.map((store) {
      final storeMap = store as Map<String, dynamic>;
      return TossDropdownItem<String>(
        value: storeMap['store_id']?.toString() ?? '',
        label: storeMap['store_name']?.toString() ?? 'Unknown',
      );
    }).toList();

    return TossDropdown<String>(
      label: 'Store',
      value: widget.selectedStoreId,
      items: storeItems,
      onChanged: (newValue) {
        if (newValue != null && newValue != widget.selectedStoreId) {
          // Notify parent of store change with the new store ID
          widget.onStoreChanged?.call(newValue);
        }
      },
    );
  }

}
