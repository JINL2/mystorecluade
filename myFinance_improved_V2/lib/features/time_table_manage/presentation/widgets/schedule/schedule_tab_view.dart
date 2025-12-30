import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_error_view.dart';
import '../../../../../shared/widgets/common/toss_loading_view.dart';
import '../../providers/time_table_providers.dart';

/// Schedule Tab View
///
/// Displays calendar-based schedule view with shift management.
class ScheduleTabView extends ConsumerStatefulWidget {
  final String storeId;

  const ScheduleTabView({
    super.key,
    required this.storeId,
  });

  @override
  ConsumerState<ScheduleTabView> createState() => _ScheduleTabViewState();
}

class _ScheduleTabViewState extends ConsumerState<ScheduleTabView> {
  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final selectedDate = ref.read(selectedDateProvider);
    ref
        .read(monthlyShiftStatusProvider(widget.storeId).notifier)
        .loadMonth(month: selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(monthlyShiftStatusProvider(widget.storeId));

    if (state.isLoading) {
      return const TossLoadingView();
    }

    if (state.error != null) {
      return TossErrorView(
        error: state.error!,
        title: 'Failed to Load Data',
        onRetry: _loadData,
      );
    }

    return Column(
      children: [
        // Calendar header
        Container(
          padding: const EdgeInsets.all(TossSpacing.space4),
          color: TossColors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'January 2024', // TODO: Dynamic month
                style: TossTextStyles.h3,
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      // TODO: Previous month
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      // TODO: Next month
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        // Calendar body (placeholder)
        Expanded(
          child: Center(
            child: Text(
              'Calendar View (In Development)',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
