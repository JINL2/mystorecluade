// Presentation Page: Inventory Count
// Page for managing inventory counts with empty state for first-time users

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/toss/toss_badge.dart';

/// Inventory Count Page
class InventoryCountPage extends ConsumerStatefulWidget {
  const InventoryCountPage({super.key});

  @override
  ConsumerState<InventoryCountPage> createState() => _InventoryCountPageState();
}

class _InventoryCountPageState extends ConsumerState<InventoryCountPage> {
  // TODO: Replace with actual API check for inventory count history
  bool _hasInventoryCountHistory = true;

  // Mock data for inventory count history
  final List<_InventoryCount> _mockInventoryCounts = [
    _InventoryCount(
      id: '1',
      date: DateTime(2025, 12, 18, 16, 26),
      title: 'JC & Ngoc work',
      location: 'Lux 1',
      userName: 'JC',
      status: _InventoryCountStatus.inProgress,
      memo: 'Weekly inventory check for main store',
    ),
    _InventoryCount(
      id: '2',
      date: DateTime(2025, 12, 12, 14, 30),
      title: 'December 12, 2025',
      location: 'Warehouse',
      userName: 'Ngoc',
      status: _InventoryCountStatus.done,
      memo: 'nhzwn hindwxbiyqhixnquxnuqnuqnuodqnuxnuqnxuqnudnii qnxiqnucnduqnxuqnucqnuxnquxnu...',
    ),
    _InventoryCount(
      id: '3',
      date: DateTime(2025, 11, 5, 9, 0),
      title: 'November Stock Check',
      location: 'Lux 1',
      userName: 'JC',
      status: _InventoryCountStatus.done,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: _hasInventoryCountHistory
          ? _buildInventoryCountList()
          : _buildEmptyState(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: TossColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).maybePop(),
        icon: const Icon(
          Icons.close,
          color: TossColors.gray900,
          size: 22,
        ),
      ),
      title: Text(
        'Inventory Count',
        style: TossTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.w700,
          color: TossColors.gray900,
        ),
      ),
      titleSpacing: 0,
      actions: [
        IconButton(
          onPressed: _hasInventoryCountHistory ? _onAddPressed : null,
          icon: Icon(
            Icons.add,
            color: _hasInventoryCountHistory
                ? TossColors.gray900
                : TossColors.gray300,
            size: 24,
          ),
          splashRadius: 20,
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildEmptyState() {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Clipboard icon
              const Icon(
                Icons.assignment_outlined,
                size: 48,
                color: TossColors.gray400,
              ),
              const SizedBox(height: TossSpacing.space6),
              // Description text
              Text(
                'Run an inventory count to keep numbers accurate - individually or as a team.',
                textAlign: TextAlign.center,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: TossSpacing.space6),
              // Start Inventory Count button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onStartInventoryCount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TossColors.primary,
                    foregroundColor: TossColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Start Inventory Count',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInventoryCountList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
      itemCount: _mockInventoryCounts.length,
      itemBuilder: (context, index) {
        final item = _mockInventoryCounts[index];
        return _buildInventoryCountItem(item);
      },
    );
  }

  Widget _buildInventoryCountItem(_InventoryCount item) {
    final day = item.date.day.toString().padLeft(2, '0');
    final month = item.date.month.toString().padLeft(2, '0');
    final dateStr = '$day.$month';

    return GestureDetector(
      onTap: () => _onItemTap(item),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date column
            SizedBox(
              width: 48,
              child: Text(
                dateStr,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Content column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    item.title,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Location
                  Text(
                    item.location,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space2),
                  // User row
                  Row(
                    children: [
                      // User avatar
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: TossColors.gray200,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            item.userName.isNotEmpty
                                ? item.userName[0].toUpperCase()
                                : '?',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // User name
                      Text(
                        item.userName,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Status badge
            _buildStatusBadge(item.status),
          ],
        ),
      ),
    );
  }

  void _onItemTap(_InventoryCount item) {
    context.pushNamed(
      'inventoryCountDetail',
      extra: {
        'countId': item.id,
        'title': item.title,
        'location': item.location,
        'startedAt': item.date,
        'status': item.status == _InventoryCountStatus.inProgress
            ? 'inProgress'
            : 'done',
        'memo': item.memo,
      },
    );
  }

  Widget _buildStatusBadge(_InventoryCountStatus status) {
    final isInProgress = status == _InventoryCountStatus.inProgress;

    return TossStatusBadge(
      label: isInProgress ? 'In progress' : 'Done',
      status: isInProgress ? BadgeStatus.success : BadgeStatus.info,
    );
  }

  void _onAddPressed() {
    context.pushNamed('newInventoryCount');
  }

  void _onStartInventoryCount() {
    context.pushNamed('newInventoryCount');
  }
}

/// Inventory count status enum
enum _InventoryCountStatus {
  inProgress,
  done,
}

/// Inventory count data model
class _InventoryCount {
  final String id;
  final DateTime date;
  final String title;
  final String location;
  final String userName;
  final _InventoryCountStatus status;
  final String? memo;

  _InventoryCount({
    required this.id,
    required this.date,
    required this.title,
    required this.location,
    required this.userName,
    required this.status,
    this.memo,
  });
}
