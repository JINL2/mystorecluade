import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../core/themes/toss_animations.dart';
import '../../../../domain/entities/denomination.dart';
import '../providers/denomination_providers.dart';
import '../providers/currency_providers.dart';

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
        crossAxisCount: 4,
        mainAxisSpacing: TossSpacing.space2,
        crossAxisSpacing: TossSpacing.space2,
        childAspectRatio: 0.85, // More compact for 4 columns
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
    // Add haptic feedback for better UX
    HapticFeedback.lightImpact();
    
    // Debug print to verify tap is working
    debugPrint('Denomination tapped: ${denomination.formattedValue}');
    
    // Show edit options with proper constraints
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _buildDenominationOptionsSheet(context, ref, denomination),
      ),
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
              await _removeDenominationWithRefresh(context, ref, denomination);
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
          const SizedBox(height: TossSpacing.space2),
          
          // Hint text
          Text(
            'Choose an action for this denomination',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
          
          // Options
          _buildOptionItem(
            context,
            icon: Icons.delete,
            title: 'Delete',
            isDestructive: true,
            onTap: () async {
              Navigator.of(context).pop(); // Close the bottom sheet first
              await _removeDenominationWithRefresh(context, ref, denomination);
            },
          ),
          
          SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space4),
        ],
      ),
    );
  }

  Future<void> _removeDenominationWithRefresh(BuildContext context, WidgetRef ref, Denomination denomination) async {
    // Haptic feedback
    HapticFeedback.lightImpact();
    
    // OPTIMISTIC UI UPDATE - Remove from local state immediately
    ref.read(localDenominationListProvider.notifier)
        .optimisticallyRemove(denomination.currencyId, denomination.id);
    
    // Show success message immediately
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${denomination.formattedValue} denomination removed successfully!'),
          backgroundColor: TossColors.success,
        ),
      );
    }
    
    // Success haptic feedback
    HapticFeedback.selectionClick();
    
    try {
      // Remove the denomination from database in the background
      await ref.read(denominationOperationsProvider.notifier)
          .removeDenomination(denomination.id, denomination.currencyId);
      
      // Small delay to ensure database operations complete
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Refresh the remote providers after successful database operation
      ref.invalidate(denominationListProvider(denomination.currencyId));
      ref.invalidate(companyCurrenciesProvider);
      ref.invalidate(companyCurrenciesStreamProvider);
      ref.invalidate(searchFilteredCurrenciesProvider);
      
    } catch (e) {
      // If database operation fails, revert the optimistic update
      // We need to reset local state to sync with remote
      ref.read(localDenominationListProvider.notifier).reset(denomination.currencyId);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove denomination: $e. Change reverted.'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    }
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
      onLongPress: onLongPress, // Keep long press on outer detector
      child: TossAnimatedWidget(
        enableTap: true,
        onTap: onTap, // Use TossAnimatedWidget's tap handling
        duration: TossAnimations.quick,
        curve: TossAnimations.standard,
        child: Container(
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(
              color: TossColors.gray300, // Slightly more visible border
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: TossColors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Smaller emoji icon
              Text(
                denomination.emoji,
                style: TossTextStyles.body.copyWith(fontSize: 18),
              ),
              const SizedBox(height: TossSpacing.space1),
              
              // Value - more compact
              Text(
                denomination.formattedValue,
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              
              // Simple type text - smaller
              Text(
                denomination.type == DenominationType.coin ? 'Coin' : 'Bill',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}