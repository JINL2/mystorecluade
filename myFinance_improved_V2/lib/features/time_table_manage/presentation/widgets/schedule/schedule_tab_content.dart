import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/widgets/common/toss_loading_view.dart';
import '../../providers/time_table_providers.dart';
import '../calendar/calendar_month_header.dart';
import '../calendar/time_table_calendar.dart';
import '../common/store_selector_card.dart';
import 'schedule_approve_button.dart';
import 'schedule_shift_data_section.dart';

/// Schedule Tab Content
///
/// Displays calendar-based schedule view with shift management.
/// Extracted from time_table_manage_page to reduce God Widget complexity.
class ScheduleTabContent extends ConsumerWidget {
  final String? selectedStoreId;
  final DateTime selectedDate;
  final DateTime focusedMonth;
  final ScrollController scrollController;
  final String Function(int month) getMonthName;
  final VoidCallback onAddShiftTap;
  final Function(DateTime date) onDateSelected;
  final Future<void> Function() onPreviousMonth;
  final Future<void> Function() onNextMonth;
  final Future<void> Function() onApprovalSuccess;
  final Future<void> Function() fetchMonthlyShiftStatus;
  final VoidCallback onStoreSelectorTap;

  const ScheduleTabContent({
    super.key,
    required this.selectedStoreId,
    required this.selectedDate,
    required this.focusedMonth,
    required this.scrollController,
    required this.getMonthName,
    required this.onAddShiftTap,
    required this.onDateSelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onApprovalSuccess,
    required this.fetchMonthlyShiftStatus,
    required this.onStoreSelectorTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final userData = appState.user;
    final companies = (userData['companies'] as List<dynamic>?) ?? [];
    Map<String, dynamic>? selectedCompany;
    if (companies.isNotEmpty) {
      try {
        selectedCompany = companies.firstWhere(
          (c) => (c as Map<String, dynamic>)['company_id'] == appState.companyChoosen,
        ) as Map<String, dynamic>;
      } catch (e) {
        selectedCompany = companies.first as Map<String, dynamic>;
      }
    }
    final stores = (selectedCompany?['stores'] as List<dynamic>?) ?? [];

    // ✅ Watch monthly shift status provider
    final monthlyShiftState = selectedStoreId != null && selectedStoreId!.isNotEmpty
        ? ref.watch(monthlyShiftStatusProvider(selectedStoreId!))
        : null;
    final monthlyShiftStatusList = monthlyShiftState?.allMonthlyStatuses ?? [];
    final isLoadingShiftStatus = monthlyShiftState?.isLoading ?? false;

    // ✅ Watch selected shift requests provider
    final selectedShiftState = ref.watch(selectedShiftRequestsProvider);
    final selectedShiftRequests = selectedShiftState.selectedIds;
    final selectedShiftApprovalStates = selectedShiftState.approvalStates;
    final selectedShiftRequestIds = selectedShiftState.requestIds;

    // ✅ Watch shift metadata provider
    final shiftMetadataAsync = selectedStoreId != null && selectedStoreId!.isNotEmpty
        ? ref.watch(shiftMetadataProvider(selectedStoreId!))
        : null;
    final shiftMetadata = shiftMetadataAsync?.valueOrNull;
    final isLoadingMetadata = shiftMetadataAsync?.isLoading ?? false;

    return Stack(
      children: [
        Column(
          children: [
            // Store Selector
            StoreSelectorCard(
              selectedStoreId: selectedStoreId,
              stores: stores,
              onTap: onStoreSelectorTap,
            ),

            // Calendar Header
            CalendarMonthHeader(
              focusedMonth: focusedMonth,
              onPreviousMonth: onPreviousMonth,
              onNextMonth: onNextMonth,
              getMonthName: getMonthName,
            ),

            // Main content with scroll
            Expanded(
              child: ListView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: EdgeInsets.zero,
                children: [
                  // Calendar - Toss Style
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                    child: TimeTableCalendar(
                      selectedDate: selectedDate,
                      focusedMonth: focusedMonth,
                      onDateSelected: onDateSelected,
                      shiftMetadata: shiftMetadata,
                      monthlyShiftStatusList: monthlyShiftStatusList,
                    ),
                  ),

                  const SizedBox(height: TossSpacing.space4),

                  // Display Shift Data
                  if (isLoadingShiftStatus)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      child: const Center(
                        child: TossLoadingView(),
                      ),
                    )
                  else
                    ScheduleShiftDataSection(
                      selectedDate: selectedDate,
                      selectedStoreId: selectedStoreId,
                      shiftMetadata: shiftMetadata,
                      isLoadingMetadata: isLoadingMetadata,
                    ),

                  const SizedBox(height: TossSpacing.space4),

                  // Approve/Not Approve Button
                  ScheduleApproveButton(
                    selectedShiftRequests: selectedShiftRequests,
                    selectedShiftApprovalStates: selectedShiftApprovalStates,
                    selectedShiftRequestIds: selectedShiftRequestIds,
                    userId: ref.read(appStateProvider).user['user_id'] ?? '',
                    selectedDate: selectedDate,
                    onSuccess: onApprovalSuccess,
                  ),

                  // Add bottom padding for comfortable scrolling
                  const SizedBox(height: 100), // Increased padding to avoid FAB overlap
                ],
              ),
            ),
          ],
        ),
        // Floating Action Button (FAB)
        Positioned(
          bottom: 20,
          right: 20,
          child: InkWell(
            onTap: () {
              HapticFeedback.mediumImpact();
              onAddShiftTap();
            },
            borderRadius: BorderRadius.circular(TossBorderRadius.xxl + 4),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: TossColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: TossColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: TossColors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add,
                color: TossColors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
