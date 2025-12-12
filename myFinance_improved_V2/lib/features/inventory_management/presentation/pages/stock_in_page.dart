// Presentation Page: Stock In (Record Stock In)
// Page for managing stock in records with empty state for first-time users

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/toss/toss_badge.dart';

/// Stock In Page (Record Stock In)
class StockInPage extends ConsumerStatefulWidget {
  const StockInPage({super.key});

  @override
  ConsumerState<StockInPage> createState() => _StockInPageState();
}

class _StockInPageState extends ConsumerState<StockInPage> {
  // TODO: Replace with actual API check for stock in history
  final bool _hasStockInHistory = true;

  // Mock data for stock in history
  final List<_StockInRecord> _mockStockInRecords = [
    _StockInRecord(
      id: '1',
      date: DateTime(2025, 12, 18),
      shipmentCode: '#SH-2005-001',
      location: 'Lux 1',
      userName: 'Alex Nguyen',
      status: _StockInStatus.inProgress,
      arrivalPercentage: 60,
    ),
    _StockInRecord(
      id: '2',
      date: DateTime(2025, 12, 12),
      shipmentCode: '#SH-2005-001',
      location: 'Lux 1',
      userName: 'Jamie Lee',
      status: _StockInStatus.done,
      arrivalPercentage: 60,
    ),
    _StockInRecord(
      id: '3',
      date: DateTime(2025, 11, 5),
      shipmentCode: '#SH-2005-001',
      location: 'Warehouse',
      userName: 'Taylor Kim',
      status: _StockInStatus.done,
      arrivalPercentage: 60,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: _hasStockInHistory ? _buildStockInList() : _buildEmptyState(),
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
        'Record Stock In',
        style: TossTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.w700,
          color: TossColors.gray900,
        ),
      ),
      titleSpacing: 0,
      actions: [
        IconButton(
          onPressed: _hasStockInHistory ? _onAddPressed : null,
          icon: Icon(
            Icons.add,
            color:
                _hasStockInHistory ? TossColors.gray900 : TossColors.gray300,
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
              // Box → Store icons
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Box icon
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 48,
                    color: TossColors.gray400,
                  ),
                  SizedBox(width: 12),
                  // Arrow icon
                  Icon(
                    Icons.arrow_forward,
                    size: 24,
                    color: TossColors.gray400,
                  ),
                  SizedBox(width: 12),
                  // Store icon
                  Icon(
                    Icons.storefront_outlined,
                    size: 48,
                    color: TossColors.gray400,
                  ),
                ],
              ),
              const SizedBox(height: TossSpacing.space6),
              // Description text
              Text(
                'Count the arrived stock and confirm it matches\nthe shipment order.',
                textAlign: TextAlign.center,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: TossSpacing.space6),
              // Start Stock In Record button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onStartStockInRecord,
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
                        'Start Stock In Record',
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

  Widget _buildStockInList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
      itemCount: _mockStockInRecords.length,
      itemBuilder: (context, index) {
        final item = _mockStockInRecords[index];
        return _buildStockInItem(item);
      },
    );
  }

  Widget _buildStockInItem(_StockInRecord item) {
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
                  // Shipment Code
                  Text(
                    item.shipmentCode,
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
            // Right column: Status badge and arrival percentage
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Status badge
                _buildStatusBadge(item.status),
                const SizedBox(height: 4),
                // Shipment arrival percentage
                Text(
                  'Shipment arrival: ${item.arrivalPercentage}%',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTap(_StockInRecord item) {
    // TODO: Navigate to stock in detail page
  }

  Widget _buildStatusBadge(_StockInStatus status) {
    final isInProgress = status == _StockInStatus.inProgress;

    return TossStatusBadge(
      label: isInProgress ? 'In progress' : 'Done',
      status: isInProgress ? BadgeStatus.success : BadgeStatus.info,
    );
  }

  void _onAddPressed() {
    context.pushNamed('newStockInRecord');
  }

  void _onStartStockInRecord() {
    context.pushNamed('newStockInRecord');
  }
}

/// Stock in status enum
enum _StockInStatus {
  inProgress,
  done,
}

/// Stock in record data model
class _StockInRecord {
  final String id;
  final DateTime date;
  final String shipmentCode;
  final String location;
  final String userName;
  final _StockInStatus status;
  final int arrivalPercentage;
  final String? memo;

  _StockInRecord({
    required this.id,
    required this.date,
    required this.shipmentCode,
    required this.location,
    required this.userName,
    required this.status,
    required this.arrivalPercentage,
    this.memo,
  });
}
