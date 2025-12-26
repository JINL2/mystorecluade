import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_border_radius.dart';

/// Quick action buttons for dashboard
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
        Text(
          'Quick Actions',
          style: TossTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.add_circle_outline,
                label: 'New PI',
                description: 'Create Proforma',
                color: TossColors.primary,
                onTap: onCreatePI,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.verified_outlined,
                label: 'L/C Status',
                description: 'View credits',
                color: TossColors.success,
                onTap: onViewLC,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.local_shipping_outlined,
                label: 'Shipments',
                description: 'Track cargo',
                color: TossColors.warning,
                onTap: onViewShipments,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.analytics_outlined,
                label: 'Reports',
                description: 'View analytics',
                color: TossColors.info,
                onTap: onViewReports,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final VoidCallback? onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: TossColors.gray200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                icon,
                color: color,
                size: 22,
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
            Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: 20,
            ),
          ],
        ),
      ),
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
    showModalBottomSheet(
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
                color: color.withOpacity(0.1),
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
            Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
            ),
          ],
        ),
      ),
    );
  }
}
