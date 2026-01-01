import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
// Dashboard 관련은 trade_dashboard 자체 모듈에서 가져옴
import '../providers/dashboard_providers.dart';
// 공유 위젯은 trade_shared에서 가져옴
import '../../../trade_shared/presentation/widgets/trade_timeline_widget.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Page to display all trade activities
class ActivityListPage extends ConsumerStatefulWidget {
  const ActivityListPage({super.key});

  @override
  ConsumerState<ActivityListPage> createState() => _ActivityListPageState();
}

class _ActivityListPageState extends ConsumerState<ActivityListPage> {
  String? _selectedEntityType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadActivities();
    });
  }

  void _loadActivities() {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;

    if (companyId.isNotEmpty) {
      ref.read(recentActivitiesNotifierProvider.notifier).loadActivities(
            companyId: companyId,
            storeId: storeId.isNotEmpty ? storeId : null,
            entityType: _selectedEntityType,
            limit: 100,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activitiesState = ref.watch(recentActivitiesNotifierProvider);

    // Filter activities client-side based on selected entity type
    final filteredActivities = _selectedEntityType == null
        ? activitiesState.activities
        : activitiesState.activities
            .where((a) => a.entityType.toUpperCase() == _selectedEntityType)
            .toList();

    return TossScaffold(
      appBar: AppBar(
        title: const Text('All Activities'),
        backgroundColor: TossColors.white,
        foregroundColor: TossColors.gray900,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space3,
            ),
            color: TossColors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', null),
                  const SizedBox(width: TossSpacing.space2),
                  _buildFilterChip('PI', 'PI'),
                  const SizedBox(width: TossSpacing.space2),
                  _buildFilterChip('PO', 'PO'),
                  const SizedBox(width: TossSpacing.space2),
                  _buildFilterChip('L/C', 'LC'),
                  const SizedBox(width: TossSpacing.space2),
                  _buildFilterChip('Shipment', 'SHIPMENT'),
                  const SizedBox(width: TossSpacing.space2),
                  _buildFilterChip('CI', 'CI'),
                ],
              ),
            ),
          ),
          const Divider(height: 1),

          // Activity list
          Expanded(
            child: activitiesState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : activitiesState.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: TossColors.error,
                            ),
                            const SizedBox(height: TossSpacing.space3),
                            Text(
                              'Failed to load activities',
                              style: TossTextStyles.bodyMedium.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space3),
                            TextButton(
                              onPressed: _loadActivities,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : filteredActivities.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history_outlined,
                                  size: 48,
                                  color: TossColors.gray300,
                                ),
                                const SizedBox(height: TossSpacing.space3),
                                Text(
                                  _selectedEntityType == null
                                      ? 'No activities found'
                                      : 'No $_selectedEntityType activities found',
                                  style: TossTextStyles.bodyMedium.copyWith(
                                    color: TossColors.gray500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async => _loadActivities(),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(TossSpacing.space4),
                              itemCount: filteredActivities.length,
                              itemBuilder: (context, index) {
                                final activity = filteredActivities[index];
                                return TradeActivityListItem(
                                  activity: activity,
                                  onTap: () => _navigateToDetail(activity.entityType, activity.entityId),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? entityType) {
    final isSelected = _selectedEntityType == entityType;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedEntityType = entityType;
        });
      },
      backgroundColor: TossColors.white,
      selectedColor: TossColors.primary.withOpacity(0.1),
      checkmarkColor: TossColors.primary,
      labelStyle: TossTextStyles.caption.copyWith(
        color: isSelected ? TossColors.primary : TossColors.gray600,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? TossColors.primary : TossColors.gray200,
      ),
    );
  }

  void _navigateToDetail(String entityType, String entityId) {
    switch (entityType.toUpperCase()) {
      case 'PI':
        context.push('/trade/proforma-invoice/$entityId');
        break;
      case 'PO':
        context.push('/trade/purchase-order/$entityId');
        break;
      case 'LC':
        context.push('/trade/letter-of-credit/$entityId');
        break;
      case 'SHIPMENT':
        context.push('/trade/shipment/$entityId');
        break;
      case 'CI':
        context.push('/trade/commercial-invoice/$entityId');
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unknown entity type: $entityType')),
        );
    }
  }
}
