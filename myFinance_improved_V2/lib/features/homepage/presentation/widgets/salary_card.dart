import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/services/supabase_service.dart';
import '../../data/datasources/homepage_data_source.dart';

/// Salary view tab enum
enum SalaryViewTab { company, store }

/// Provider for selected salary tab (default: company)
final selectedSalaryTabProvider = StateProvider<SalaryViewTab>((ref) => SalaryViewTab.company);

/// Provider for HomepageDataSource
final _homepageDataSourceProvider = Provider<HomepageDataSource>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return HomepageDataSource(supabaseService);
});

/// Provider for fetching user's salary using homepage_user_salary RPC
///
/// Returns full RPC response with company_total and by_store data
final homepageUserSalaryProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final appState = ref.watch(appStateProvider);
  final dataSource = ref.read(_homepageDataSourceProvider);

  final userId = appState.userId;
  final companyId = appState.companyChoosen;

  if (userId.isEmpty || companyId.isEmpty) {
    return _defaultSalaryResponse();
  }

  try {
    final response = await dataSource.getUserSalary(
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
    final salaryAsync = ref.watch(homepageUserSalaryProvider);
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
                style: TossTextStyles.h3.copyWith(
                  fontSize: 15,
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

          // Salary Amount
          salaryAsync.when(
            data: (salaryData) => _buildSalaryContent(
              salaryData,
              selectedTab,
              appState.storeChoosen,
            ),
            loading: () => _buildLoadingState(),
            error: (error, _) => _buildErrorState(error.toString()),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryContent(
    Map<String, dynamic> salaryData,
    SalaryViewTab selectedTab,
    String selectedStoreId,
  ) {
    // Get salary info
    final salaryInfo = salaryData['salary_info'] as Map<String, dynamic>? ?? {};
    final currencySymbol = salaryInfo['currency_symbol'] as String? ?? '₫';

    // Get period stats based on selected tab
    Map<String, dynamic> thisMonthStats;

    if (selectedTab == SalaryViewTab.company) {
      // Company total
      final companyTotal = salaryData['company_total'] as Map<String, dynamic>? ?? {};
      thisMonthStats = companyTotal['this_month'] as Map<String, dynamic>? ?? _defaultPeriodStats();
    } else {
      // Store specific - find store in by_store array
      final byStore = salaryData['by_store'] as List<dynamic>? ?? [];

      // Find the selected store
      Map<String, dynamic>? storeData;
      for (final item in byStore) {
        final store = item as Map<String, dynamic>;
        if (store['store_id'] == selectedStoreId) {
          storeData = store;
          break;
        }
      }

      if (storeData != null) {
        thisMonthStats = storeData['this_month'] as Map<String, dynamic>? ?? _defaultPeriodStats();
      } else {
        thisMonthStats = _defaultPeriodStats();
      }
    }

    final totalPayment = (thisMonthStats['total_payment'] as num?)?.toDouble() ?? 0.0;
    final bonusPay = (thisMonthStats['bonus_pay'] as num?)?.toDouble() ?? 0.0;
    final changePercentage = (thisMonthStats['change_percentage'] as num?)?.toDouble() ?? 0.0;
    final previousPayment = (thisMonthStats['previous_total_payment'] as num?)?.toDouble() ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Amount
        Text(
          '$currencySymbol${_formatAmountWithComma(totalPayment)}',
          style: TossTextStyles.display.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 28,
            height: 1.2,
            letterSpacing: -1.0,
          ),
        ),

        // Change percentage (if previous payment exists)
        if (previousPayment > 0)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Icon(
                  changePercentage >= 0 ? Icons.trending_up : Icons.trending_down,
                  color: changePercentage >= 0 ? TossColors.primary : TossColors.error,
                  size: 16,
                ),
                const SizedBox(width: TossSpacing.space1),
                Text(
                  '${changePercentage >= 0 ? '' : ''}${changePercentage.toStringAsFixed(1)}% vs last month',
                  style: TossTextStyles.caption.copyWith(
                    color: changePercentage >= 0 ? TossColors.primary : TossColors.error,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

        // Overtime bonus (if > 0)
        if (bonusPay > 0)
          Padding(
            padding: const EdgeInsets.only(top: TossSpacing.space2),
            child: Text(
              '+$currencySymbol${_formatAmountWithComma(bonusPay)} overtime bonus',
              style: TossTextStyles.body.copyWith(
                color: TossColors.success,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Column(
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
        const SizedBox(height: TossSpacing.space2),
        Container(
          width: 150,
          height: 20,
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
            size: 20,
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
          horizontal: 14,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : TossColors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: TossTextStyles.caption.copyWith(
            fontSize: 12,
            color: isSelected ? TossColors.white : TossColors.textTertiary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
