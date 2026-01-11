import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_error_view.dart';
import 'package:myfinance_improved/shared/widgets/molecules/navigation/toss_app_bar.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../providers/sales_dashboard_notifier.dart';
import '../widgets/sales_dashboard/index.dart';

/// Sales Dashboard Detail Page
class SalesDashboardPage extends ConsumerStatefulWidget {
  final String companyId;
  final String? storeId;

  const SalesDashboardPage({
    super.key,
    required this.companyId,
    this.storeId,
  });

  @override
  ConsumerState<SalesDashboardPage> createState() => _SalesDashboardPageState();
}

class _SalesDashboardPageState extends ConsumerState<SalesDashboardPage> {
  /// Currently selected store ID (null = All Stores / Company-wide)
  String? _selectedStoreId;

  /// List of stores for the current company
  List<Map<String, dynamic>> _stores = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeStores();
      _loadData();
    });
  }

  /// Initialize stores list from app state
  void _initializeStores() {
    final appState = ref.read(appStateProvider);
    final userData = appState.user;
    final companies = userData['companies'] as List<dynamic>? ?? [];

    // Find current company and get its stores
    for (final company in companies) {
      final companyData = company as Map<String, dynamic>;
      if (companyData['company_id'] == widget.companyId) {
        final storesList = companyData['stores'] as List<dynamic>? ?? [];
        _stores = storesList.map((s) => s as Map<String, dynamic>).toList();
        break;
      }
    }

    // Set initial store selection (null = All Stores)
    _selectedStoreId = widget.storeId;
  }

  /// Load data with current store selection
  void _loadData() {
    ref.read(salesDashboardNotifierProvider.notifier).loadData(
          companyId: widget.companyId,
          storeId: _selectedStoreId,
        );
  }

  /// Handle store selection change
  void _onStoreChanged(String? storeId) {
    setState(() {
      _selectedStoreId = storeId;
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(salesDashboardNotifierProvider);

    return Scaffold(
      backgroundColor: TossColors.gray50,
      appBar: const TossAppBar(
        title: 'Sales Analysis',
      ),
      body: Column(
        children: [
          // Store Selector
          StoreSelector(
            selectedStoreId: _selectedStoreId,
            stores: _stores,
            onChanged: _onStoreChanged,
          ),
          // Main Content
          Expanded(child: _buildBody(state)),
        ],
      ),
    );
  }

  Widget _buildBody(SalesDashboardState state) {
    if (state.isLoading && !state.hasData) {
      return const TossLoadingView();
    }

    if (state.hasError && !state.hasData) {
      return TossErrorView(
        error: Exception(state.errorMessage ?? 'Failed to load data'),
        onRetry: _loadData,
      );
    }

    final data = state.data;
    final bcgMatrix = state.bcgMatrix;

    return RefreshIndicator(
      onRefresh: () => ref.read(salesDashboardNotifierProvider.notifier).refresh(
            companyId: widget.companyId,
            storeId: _selectedStoreId,
          ),
      color: TossColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: TossSpacing.space4),

            // Key Metrics Summary
            if (data != null) MetricsSummarySection(data: data),

            const SizedBox(height: TossSpacing.space4),

            // Monthly Comparison
            if (data != null) MonthlyComparisonSection(data: data),

            const SizedBox(height: TossSpacing.space4),

            // BCG Matrix
            if (bcgMatrix != null) BcgMatrixSection(bcgMatrix: bcgMatrix),

            const SizedBox(height: TossSpacing.space6),
          ],
        ),
      ),
    );
  }
}
