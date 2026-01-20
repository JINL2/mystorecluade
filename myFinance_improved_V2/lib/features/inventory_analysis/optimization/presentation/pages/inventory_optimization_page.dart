import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/index.dart';
import '../../domain/entities/inventory_dashboard.dart';
import '../../domain/entities/inventory_health.dart';
import '../../domain/entities/inventory_status.dart';
import '../providers/inventory_optimization_providers.dart';
import '../widgets/category_list_tile.dart';
import '../widgets/inventory_summary_section.dart';
import '../widgets/priority_action_card.dart';
import '../widgets/status_filter_chips.dart';
import 'category_list_page.dart';
import 'product_list_page.dart';

/// 재고 최적화 대시보드 페이지 (2026 UI/UX 트렌드 적용)
///
/// 핵심 개선:
/// - 스토어 선택 지원
/// - 우선순위 기반 레이아웃 (중요한 것 먼저)
/// - 중복 정보 제거
/// - 쉬운 용어 사용
/// - Warning 상태 추가
class InventoryOptimizationPage extends ConsumerStatefulWidget {
  final String? companyId;
  final String? storeId;

  const InventoryOptimizationPage({
    super.key,
    this.companyId,
    this.storeId,
  });

  @override
  ConsumerState<InventoryOptimizationPage> createState() =>
      _InventoryOptimizationPageState();
}

class _InventoryOptimizationPageState
    extends ConsumerState<InventoryOptimizationPage> {
  late String _companyId;
  String? _selectedStoreId;
  List<Map<String, dynamic>> _stores = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  void _initializeData() {
    final appState = ref.read(appStateProvider);
    _companyId = widget.companyId?.isNotEmpty == true
        ? widget.companyId!
        : appState.companyChoosen;

    _initializeStores();
    _selectedStoreId = widget.storeId;
  }

  void _initializeStores() {
    final appState = ref.read(appStateProvider);
    final userData = appState.user;
    final companies = userData['companies'] as List<dynamic>? ?? [];

    for (final company in companies) {
      final companyData = company as Map<String, dynamic>;
      if (companyData['company_id'] == _companyId) {
        final storesList = companyData['stores'] as List<dynamic>? ?? [];
        _stores = storesList.map((s) => s as Map<String, dynamic>).toList();
        break;
      }
    }
  }

  void _onStoreChanged(String? storeId) {
    setState(() {
      _selectedStoreId = storeId;
    });
    ref.invalidate(inventoryDashboardProvider(_companyId));
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final companyId = widget.companyId?.isNotEmpty == true
        ? widget.companyId!
        : appState.companyChoosen;

    if (companyId.isEmpty) {
      return const TossScaffold(
        appBar: TossAppBar(title: 'Inventory Health'),
        body: TossEmptyView(
          icon: Icon(Icons.business_outlined, size: 48),
          title: 'No Company Selected',
          description: 'Please select a company first',
        ),
      );
    }

    _companyId = companyId;
    if (_stores.isEmpty) {
      _initializeStores();
    }

    final dashboardAsync = ref.watch(inventoryDashboardProvider(companyId));

    return TossScaffold(
      backgroundColor: TossColors.gray50,
      appBar: TossAppBar(
        title: 'Inventory Health',
        primaryActionIcon: Icons.refresh,
        onPrimaryAction: () {
          ref.invalidate(inventoryDashboardProvider(companyId));
        },
      ),
      body: Column(
        children: [
          // Store Selector
          _buildStoreSelector(),
          // Main Content
          Expanded(
            child: dashboardAsync.when(
              loading: () => const TossLoadingView(),
              error: (error, stack) => TossErrorView(
                error: error,
                onRetry: () {
                  ref.invalidate(inventoryDashboardProvider(companyId));
                },
              ),
              data: (dashboard) => _buildContent(dashboard, companyId),
            ),
          ),
        ],
      ),
    );
  }

  /// Store Selector (Sales Analytics V2와 동일한 패턴)
  Widget _buildStoreSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.paddingMD,
        vertical: TossSpacing.paddingSM,
      ),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(
          bottom: BorderSide(color: TossColors.gray200, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.store_outlined,
            size: TossSpacing.iconSM,
            color: TossColors.textSecondary,
          ),
          const SizedBox(width: TossSpacing.gapSM),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.paddingSM,
                vertical: TossSpacing.paddingXS,
              ),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.button),
                border: Border.all(color: TossColors.gray200),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  value: _selectedStoreId,
                  isExpanded: true,
                  isDense: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: TossColors.gray600,
                    size: 20,
                  ),
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                  ),
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.business,
                            size: 16,
                            color: TossColors.primary,
                          ),
                          const SizedBox(width: TossSpacing.gapSM),
                          Text(
                            'All Stores',
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ..._stores.map((store) {
                      final storeId = store['store_id'] as String;
                      final storeName =
                          store['store_name'] as String? ?? 'Store';
                      return DropdownMenuItem<String?>(
                        value: storeId,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.storefront,
                              size: 16,
                              color: TossColors.gray500,
                            ),
                            const SizedBox(width: TossSpacing.gapSM),
                            Expanded(
                              child: Text(
                                storeName,
                                style: TossTextStyles.body,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                  onChanged: _onStoreChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(InventoryDashboard dashboard, String companyId) {
    final health = dashboard.health;

    // 긴급 조치가 필요한 총 수
    final urgentCount = health.abnormalCount + health.stockoutCount;
    final attentionCount = health.criticalCount + health.warningCount;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(inventoryDashboardProvider(companyId));
      },
      color: TossColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.paddingMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 긴급 조치 필요 (가장 중요) - 빨간색
              if (urgentCount > 0)
                PriorityActionCard.urgent(
                  count: urgentCount,
                  stockoutCount: health.stockoutCount,
                  abnormalCount: health.abnormalCount,
                  onTap: () => _navigateToProductList(
                    companyId,
                    urgentCount == health.stockoutCount
                        ? InventoryStatus.stockout
                        : InventoryStatus.abnormal,
                  ),
                ),
              if (urgentCount > 0) const SizedBox(height: TossSpacing.gapMD),

              // 2. 주의 필요 (두번째 중요) - 주황색
              if (attentionCount > 0)
                PriorityActionCard.attention(
                  count: attentionCount,
                  criticalCount: health.criticalCount,
                  warningCount: health.warningCount,
                  criticalDays: dashboard.thresholds.criticalDays,
                  warningDays: dashboard.thresholds.warningDays,
                  onTap: () => _navigateToProductList(
                    companyId,
                    health.criticalCount > 0
                        ? InventoryStatus.critical
                        : InventoryStatus.warning,
                  ),
                ),
              if (attentionCount > 0)
                const SizedBox(height: TossSpacing.gapLG),

              // 3. 재고 현황 요약 (한눈에 보기)
              InventorySummarySection(
                totalProducts: health.totalProducts,
                normalCount: health.normalCount,
                reorderCount: health.reorderNeededCount,
                overstockCount: health.overstockCount,
                deadStockCount: health.deadStockCount,
              ),
              const SizedBox(height: TossSpacing.gapLG),

              // 4. 빠른 필터 (클릭하면 목록으로 이동)
              _buildQuickFilters(companyId, health),
              const SizedBox(height: TossSpacing.gapLG),

              // 5. Top 카테고리
              _buildTopCategories(dashboard, companyId),

              const SizedBox(height: TossSpacing.gapXL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickFilters(String companyId, InventoryHealth health) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Filters',
          style: TossTextStyles.subtitle.copyWith(
            fontWeight: TossFontWeight.semibold,
          ),
        ),
        const SizedBox(height: TossSpacing.gapMD),
        StatusFilterChips(
          filters: [
            StatusFilterItem(
              status: InventoryStatus.reorderNeeded,
              count: health.reorderNeededCount,
              label: 'Reorder',
            ),
            StatusFilterItem(
              status: InventoryStatus.overstock,
              count: health.overstockCount,
              label: 'Overstock',
            ),
            StatusFilterItem(
              status: InventoryStatus.deadStock,
              count: health.deadStockCount,
              label: 'Dead Stock',
            ),
            StatusFilterItem(
              status: InventoryStatus.warning,
              count: health.warningCount,
              label: 'Warning',
            ),
          ],
          onTap: (status) => _navigateToProductList(companyId, status),
        ),
      ],
    );
  }

  Widget _buildTopCategories(InventoryDashboard dashboard, String companyId) {
    if (dashboard.topCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: TossTextStyles.subtitle.copyWith(
                fontWeight: TossFontWeight.semibold,
              ),
            ),
            TossButton.textButton(
              text: 'View All',
              onPressed: () => _navigateToCategoryList(companyId),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.gapMD),
        ...dashboard.topCategories.take(5).map(
              (category) => Padding(
                padding: const EdgeInsets.only(bottom: TossSpacing.gapMD),
                child: CategoryListTile(
                  category: category,
                  onTap: () => _navigateToProductListByCategory(
                    companyId,
                    category.categoryId,
                    category.categoryName,
                  ),
                ),
              ),
            ),
      ],
    );
  }

  void _navigateToProductList(String companyId, InventoryStatus status) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ProductListPage(
          companyId: companyId,
          statusFilter: status.filterValue,
          title: status.labelEn,
        ),
      ),
    );
  }

  void _navigateToProductListByCategory(
    String companyId,
    String categoryId,
    String categoryName,
  ) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ProductListPage(
          companyId: companyId,
          categoryId: categoryId,
          title: categoryName,
        ),
      ),
    );
  }

  void _navigateToCategoryList(String companyId) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => CategoryListPage(companyId: companyId),
      ),
    );
  }
}
