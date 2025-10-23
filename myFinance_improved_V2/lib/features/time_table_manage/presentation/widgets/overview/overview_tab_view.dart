import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../../shared/widgets/common/toss_error_view.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../providers/time_table_providers.dart';

/// Overview Tab View
///
/// Displays statistical overview and summary information.
class OverviewTabView extends ConsumerStatefulWidget {
  final String storeId;

  const OverviewTabView({
    super.key,
    required this.storeId,
  });

  @override
  ConsumerState<OverviewTabView> createState() => _OverviewTabViewState();
}

class _OverviewTabViewState extends ConsumerState<OverviewTabView> {
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
        .read(managerOverviewProvider(widget.storeId).notifier)
        .loadMonth(month: selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(managerOverviewProvider(widget.storeId));

    if (state.isLoading) {
      return const TossLoadingView();
    }

    if (state.error != null) {
      return TossErrorView(
        error: state.error!,
        title: '데이터 로딩 실패',
        onRetry: _loadData,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '월별 통계',
            style: TossTextStyles.h3,
          ),
          const SizedBox(height: 16),

          // Statistics cards (placeholder)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TossColors.gray200),
            ),
            child: Center(
              child: Text(
                '통계 카드 (개발 중)',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
