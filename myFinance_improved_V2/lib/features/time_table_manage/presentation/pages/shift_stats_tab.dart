import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/common/gray_divider_space.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_selection_bottom_sheet.dart';
import '../../../../app/providers/app_state_provider.dart';

import '../widgets/stats/stats_gauge_card.dart';
import '../widgets/stats/stats_leaderboard.dart';
import '../widgets/stats/stats_metric_row.dart';

/// Stats Tab for Shift Management
///
/// This is the 4th tab in the Shift Management screen.
/// Shows store health metrics, gauges, and reliability leaderboard.
class ShiftStatsTab extends ConsumerStatefulWidget {
  const ShiftStatsTab({super.key});

  @override
  ConsumerState<ShiftStatsTab> createState() => _ShiftStatsTabState();
}

class _ShiftStatsTabState extends ConsumerState<ShiftStatsTab> {
  String? selectedStoreId;
  String selectedStoreName = 'Select Store';
  String selectedPeriod = 'This Month';

  @override
  void initState() {
    super.initState();

    // Initialize from app state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = ref.read(appStateProvider);
      if (appState.storeChoosen.isNotEmpty) {
        setState(() {
          selectedStoreId = appState.storeChoosen;
          // Get store name from user data
          final userData = appState.user;
          final companies = (userData['companies'] as List<dynamic>?) ?? [];
          for (var company in companies) {
            final stores = ((company as Map<String, dynamic>)['stores'] as List<dynamic>?) ?? [];
            for (var store in stores) {
              final storeMap = store as Map<String, dynamic>;
              if (storeMap['store_id'] == selectedStoreId) {
                selectedStoreName = storeMap['store_name']?.toString() ?? 'Select Store';
                break;
              }
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store selector (same as Timesheets tab)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              TossSpacing.space3,
              TossSpacing.space2,
              TossSpacing.space3,
              TossSpacing.space4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Store',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                InkWell(
                  onTap: () async {
                    // Get stores from app state
                    final appState = ref.read(appStateProvider);
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

                    // Show store selector
                    final selectedStore = await TossStoreSelector.show(
                      context: context,
                      stores: stores,
                      selectedStoreId: selectedStoreId,
                      title: 'Select Store',
                    );

                    if (selectedStore != null) {
                      setState(() {
                        selectedStoreId = selectedStore['store_id'] as String?;
                        selectedStoreName = selectedStore['store_name'] as String? ?? 'Select Store';
                      });

                      // Update app state
                      ref.read(appStateProvider.notifier).selectStore(
                        selectedStore['store_id'] as String,
                        storeName: selectedStore['store_name'] as String?,
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2 + 2,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: TossColors.gray200),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedStoreName,
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: TossColors.gray600,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Section Divider (full width)
          const GrayDividerSpace(),

          const SizedBox(height: 32),

          // Store Health Section
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gauges
                StatsGaugeCard(
                  selectedPeriod: selectedPeriod,
                  onPeriodTap: () {
                    // TODO: Show period selection
                  },
                  onTimeRate: 0.88,
                  onTimeDisplay: '88%',
                  problemSolved: 10,
                  totalProblems: 20,
                ),
                const SizedBox(height: 16),

                // Hero Stats
                const StatsMetricRow(
                  lateShifts: '6',
                  lateShiftsChange: '+2',
                  lateShiftsIsNegative: true,
                  understaffedShifts: '4',
                  understaffedShiftsChange: '+1',
                  understaffedIsNegative: true,
                  otHours: '12.5h',
                  otHoursChange: '+0.3h',
                  otHoursIsNegative: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Section Divider (full width)
          const GrayDividerSpace(),

          const SizedBox(height: 24),

          // Reliability Leaderboard
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space3),
            child: StatsLeaderboard(
              topReliabilityList: _getTopReliabilityList(),
              needsAttentionList: _getNeedsAttentionList(),
              onSeeAllTap: () {
                // TODO: Navigate to full leaderboard
              },
            ),
          ),

          const SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }

  // Mock data - Top reliability employees
  List<LeaderboardEmployee> _getTopReliabilityList() {
    return const [
      LeaderboardEmployee(
        rank: 1,
        name: 'Alex Rivera',
        subtitle: '100% on-time · 0 missed shifts this month',
        avatarUrl: 'https://app.banani.co/avatar1.jpeg',
        score: 98,
        change: 2.3,
        isPositive: true,
      ),
      LeaderboardEmployee(
        rank: 2,
        name: 'Taylor Kim',
        subtitle: 'On-time for 26 of last 27 shifts',
        avatarUrl: 'https://app.banani.co/avatar5.jpg',
        score: 94,
        change: 1.1,
        isPositive: true,
      ),
      LeaderboardEmployee(
        rank: 3,
        name: 'Jamie Lee',
        subtitle: 'Late on 3 of last 15 shifts',
        avatarUrl: 'https://app.banani.co/avatar2.jpg',
        score: 90,
        change: -0.4,
        isPositive: false,
      ),
    ];
  }

  // Mock data - Needs attention employees
  List<LeaderboardEmployee> _getNeedsAttentionList() {
    return const [
      LeaderboardEmployee(
        rank: 1,
        name: 'Chris Park',
        subtitle: 'Late on 5 of last 10 shifts',
        avatarUrl: 'https://app.banani.co/avatar3.jpeg',
        score: 72,
        change: -3.2,
        isPositive: false,
      ),
      LeaderboardEmployee(
        rank: 2,
        name: 'Morgan Chen',
        subtitle: '2 no-shows this month',
        avatarUrl: 'https://app.banani.co/avatar4.jpg',
        score: 68,
        change: -5.1,
        isPositive: false,
      ),
    ];
  }
}
