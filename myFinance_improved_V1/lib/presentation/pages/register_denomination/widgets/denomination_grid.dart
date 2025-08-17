import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../core/themes/toss_animations.dart';
import '../../../../domain/entities/denomination.dart';
import '../providers/denomination_providers.dart';

class DenominationGrid extends ConsumerWidget {
  final List<Denomination> denominations;

  const DenominationGrid({
    super.key,
    required this.denominations,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(), // Prevent scroll conflicts
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: TossSpacing.space2,
        crossAxisSpacing: TossSpacing.space2,
        childAspectRatio: 1.1, // Slightly wider than square
      ),
      itemCount: denominations.length,
      itemBuilder: (context, index) => DenominationItem(
        denomination: denominations[index],
        onTap: () => _onDenominationTap(context, ref, denominations[index]),
        onLongPress: () => _onDenominationLongPress(context, ref, denominations[index]),
      ),
    );
  }

  void _onDenominationTap(BuildContext context, WidgetRef ref, Denomination denomination) {
    // Show edit options
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      builder: (context) => _buildDenominationOptionsSheet(context, ref, denomination),
    );
  }

  void _onDenominationLongPress(BuildContext context, WidgetRef ref, Denomination denomination) {
    // Show delete confirmation with haptic feedback
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        title: Text(
          'Delete Denomination',
          style: TossTextStyles.h3,
        ),
        content: Text(
          'Are you sure you want to delete ${denomination.formattedValue} ${denomination.displayName}?',
          style: TossTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TossTextStyles.labelLarge.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(denominationOperationsProvider.notifier)
                    .removeDenomination(denomination.id, denomination.currencyId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${denomination.formattedValue} deleted'),
                      backgroundColor: TossColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete denomination: $e'),
                      backgroundColor: TossColors.error,
                    ),
                  );
                }
              }
            },
            child: Text(
              'Delete',
              style: TossTextStyles.labelLarge.copyWith(
                color: TossColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDenominationOptionsSheet(BuildContext context, WidgetRef ref, Denomination denomination) {
    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xxl),
          topRight: Radius.circular(TossBorderRadius.xxl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const SizedBox(height: TossSpacing.space3),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: TossSpacing.space5),
          
          // Title
          Text(
            '${denomination.formattedValue} ${denomination.displayName}',
            style: TossTextStyles.h3,
          ),
          const SizedBox(height: TossSpacing.space5),
          
          // Options
          _buildOptionItem(
            context,
            icon: Icons.delete,
            title: 'Delete',
            isDestructive: true,
            onTap: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(denominationOperationsProvider.notifier)
                    .removeDenomination(denomination.id, denomination.currencyId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${denomination.formattedValue} deleted'),
                      backgroundColor: TossColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete denomination: $e'),
                      backgroundColor: TossColors.error,
                    ),
                  );
                }
              }
            },
          ),
          
          SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space4),
        ],
      ),
    );
  }

  Widget _buildOptionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space5,
          vertical: TossSpacing.space4,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: isDestructive ? TossColors.error : TossColors.gray700,
            ),
            const SizedBox(width: TossSpacing.space4),
            Expanded(
              child: Text(
                title,
                style: TossTextStyles.body.copyWith(
                  color: isDestructive ? TossColors.error : TossColors.gray900,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DenominationItem extends StatelessWidget {
  final Denomination denomination;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const DenominationItem({
    super.key,
    required this.denomination,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: TossAnimatedWidget(
        enableTap: true,
        duration: TossAnimations.quick,
        curve: TossAnimations.standard,
        child: Container(
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: TossColors.gray200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: TossColors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Simple emoji icon
              Text(
                denomination.emoji,
                style: TossTextStyles.h2,
              ),
              const SizedBox(height: TossSpacing.space2),
              
              // Value
              Text(
                denomination.formattedValue,
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TossSpacing.space1),
              
              // Simple type text
              Text(
                denomination.type == DenominationType.coin ? 'Coin' : 'Bill',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}