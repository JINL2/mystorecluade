import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../trade_shared/presentation/providers/trade_shared_providers.dart';
import '../../../trade_shared/presentation/widgets/trade_timeline_widget.dart';

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
    final companyId = ref.read(supabaseClientProvider).auth.currentUser?.userMetadata?['company_id'] as String? ?? '';
    final storeId = ref.read(supabaseClientProvider).auth.currentUser?.userMetadata?['store_id'] as String? ?? '';

    if (companyId.isNotEmpty) {
      ref.read(recentActivitiesProvider.notifier).loadActivities(
            companyId: companyId,
            storeId: storeId.isNotEmpty ? storeId : null,
            entityType: _selectedEntityType,
            limit: 100,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activitiesState = ref.watch(recentActivitiesProvider);

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
