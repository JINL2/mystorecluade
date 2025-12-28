import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../trade_shared/presentation/widgets/trade_widgets.dart';

/// Quick action buttons for dashboard - Simple horizontal scroll
/// Uses shared widgets from trade_shared
class DashboardQuickActions extends StatelessWidget {
  final VoidCallback? onCreatePI;
  final VoidCallback? onViewLC;
  final VoidCallback? onViewShipments;
  final VoidCallback? onViewReports;

  const DashboardQuickActions({
    super.key,
    this.onCreatePI,
    this.onViewLC,
    this.onViewShipments,
    this.onViewReports,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TradeSectionHeader(title: 'Quick Actions'),
        const SizedBox(height: TossSpacing.space2),
        TradeActionChipsRow(
          chips: [
            TradeActionChipData(
              icon: Icons.add,
              label: 'New PI',
              color: TossColors.primary,
              onTap: onCreatePI,
            ),
            TradeActionChipData(
              icon: Icons.verified_outlined,
              label: 'L/C',
              color: TossColors.success,
              onTap: onViewLC,
            ),
            TradeActionChipData(
              icon: Icons.local_shipping_outlined,
              label: 'Shipments',
              color: TossColors.warning,
              onTap: onViewShipments,
            ),
            TradeActionChipData(
              icon: Icons.analytics_outlined,
              label: 'Reports',
              color: TossColors.info,
              onTap: onViewReports,
            ),
          ],
        ),
      ],
    );
  }
}

/// Floating action button for creating new trade items
class TradeFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const TradeFloatingActionButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed ?? () => _showCreateOptions(context),
      backgroundColor: TossColors.primary,
      foregroundColor: TossColors.white,
      icon: const Icon(Icons.add),
      label: const Text('New'),
    );
  }

  void _showCreateOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _CreateOptionsSheet(),
    );
  }
}

class _CreateOptionsSheet extends StatelessWidget {
  const _CreateOptionsSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: TossSpacing.space4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Text(
              'Create New',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: TossSpacing.space4),

            _buildCreateOption(
              context: context,
              icon: Icons.description_outlined,
              label: 'Proforma Invoice',
              description: 'Start a new trade transaction',
              color: TossColors.info,
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to PI creation
              },
            ),

            _buildCreateOption(
              context: context,
              icon: Icons.receipt_long_outlined,
              label: 'Purchase Order',
              description: 'Create from existing PI',
              color: TossColors.primary,
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to PO creation
              },
            ),

            _buildCreateOption(
              context: context,
              icon: Icons.local_shipping_outlined,
              label: 'Shipment',
              description: 'Record new shipment',
              color: TossColors.warning,
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to Shipment creation
              },
            ),

            _buildCreateOption(
              context: context,
              icon: Icons.receipt_outlined,
              label: 'Commercial Invoice',
              description: 'Generate invoice for shipment',
              color: TossColors.error,
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to CI creation
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: TossSpacing.space3,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TossTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  Text(
                    description,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
            ),
          ],
        ),
      ),
    );
  }
}
