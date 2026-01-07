import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_error_view.dart';
import 'package:myfinance_improved/shared/widgets/molecules/navigation/toss_app_bar.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../domain/entities/analytics_entities.dart'
    hide AnalyticsSummaryCard;
import '../../domain/entities/analytics_hub.dart' as hub_entity;
import '../providers/analytics_hub_provider.dart';
import '../providers/analytics_hub_state.dart';
import '../widgets/analytics_widgets.dart';

/// Inventory Analytics Hub Page
/// 4개의 분석 시스템 요약을 한눈에 보여주는 대시보드
class InventoryAnalyticsHubPage extends ConsumerStatefulWidget {
  final String companyId;
  final String? storeId;

  const InventoryAnalyticsHubPage({
    super.key,
    required this.companyId,
    this.storeId,
  });

  @override
  ConsumerState<InventoryAnalyticsHubPage> createState() =>
      _InventoryAnalyticsHubPageState();
}

class _InventoryAnalyticsHubPageState
    extends ConsumerState<InventoryAnalyticsHubPage> {
  late String _companyId;
  late String? _storeId;

  @override
  void initState() {
    super.initState();
    // 초기 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // If companyId is empty, get it from appStateProvider
      final appState = ref.read(appStateProvider);
      _companyId = widget.companyId.isNotEmpty
          ? widget.companyId
          : appState.companyChoosen;
      _storeId = widget.storeId ?? appState.storeChoosen;

      ref.read(analyticsHubProvider.notifier).loadData(
            companyId: _companyId,
            storeId: _storeId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(analyticsHubProvider);

    return Scaffold(
      backgroundColor: TossColors.gray50,
      appBar: const TossAppBar(
        title: '재고 분석',
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(AnalyticsHubState state) {
    if (state.isLoading && !state.hasData) {
      return const TossLoadingView();
    }

    if (state.hasError && !state.hasData) {
      return TossErrorView(
        error: Exception(state.errorMessage ?? '데이터를 불러올 수 없습니다'),
        onRetry: () => ref.read(analyticsHubProvider.notifier).loadData(
              companyId: _companyId,
              storeId: _storeId,
            ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(analyticsHubProvider.notifier).refresh(
            companyId: _companyId,
            storeId: _storeId,
          ),
      color: TossColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: TossSpacing.space4),

            // Sales Dashboard Card
            _buildCard(
              data: state.data,
              cardGetter: (d) => d.salesCard,
              icon: Icons.trending_up,
              defaultTitle: '수익률 분석',
              onTap: () => _navigateToSalesDetail(),
            ),

            const SizedBox(height: TossSpacing.space3),

            // Inventory Optimization Card
            _buildCard(
              data: state.data,
              cardGetter: (d) => d.optimizationCard,
              icon: Icons.inventory_2_outlined,
              defaultTitle: '재고 최적화',
              onTap: () => _navigateToOptimizationDetail(),
            ),

            const SizedBox(height: TossSpacing.space3),

            // Supply Chain Card
            _buildCard(
              data: state.data,
              cardGetter: (d) => d.supplyChainCard,
              icon: Icons.local_shipping_outlined,
              defaultTitle: '공급망 분석',
              onTap: () => _navigateToSupplyChainDetail(),
            ),

            const SizedBox(height: TossSpacing.space3),

            // Discrepancy Card
            _buildCard(
              data: state.data,
              cardGetter: (d) => d.discrepancyCard,
              icon: Icons.warning_amber_outlined,
              defaultTitle: '재고 불일치',
              onTap: () => _navigateToDiscrepancyDetail(),
            ),

            const SizedBox(height: TossSpacing.space6),
          ],
        ),
      ),
    );
  }

  /// 카드 빌더
  Widget _buildCard({
    required AnalyticsHubData? data,
    required hub_entity.AnalyticsSummaryCard Function(AnalyticsHubData) cardGetter,
    required IconData icon,
    required String defaultTitle,
    required VoidCallback onTap,
  }) {
    String title = defaultTitle;
    String subtitle = '데이터 없음';
    String status = 'normal';

    if (data != null) {
      final card = cardGetter(data);
      title = card.title;
      subtitle = '${card.statusText} · ${card.primaryMetric}';
      status = card.status;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: AnalyticsSummaryCard(
        title: title,
        subtitle: subtitle,
        status: status,
        icon: icon,
        onTap: onTap,
      ),
    );
  }

  void _navigateToSalesDetail() {
    context.push(
      '/inventoryAnalysis/sales',
      extra: {
        'companyId': _companyId,
        'storeId': _storeId,
      },
    );
  }

  void _navigateToOptimizationDetail() {
    context.push(
      '/inventoryAnalysis/optimization',
      extra: {
        'companyId': _companyId,
        'storeId': _storeId,
      },
    );
  }

  void _navigateToSupplyChainDetail() {
    context.push(
      '/inventoryAnalysis/supply-chain',
      extra: {
        'companyId': _companyId,
        'storeId': _storeId,
      },
    );
  }

  void _navigateToDiscrepancyDetail() {
    context.push(
      '/inventoryAnalysis/discrepancy',
      extra: {
        'companyId': _companyId,
        'storeId': _storeId,
      },
    );
  }
}
