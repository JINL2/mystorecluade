import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../providers/cash_location_provider.dart';

class CashLocationFilterTabs extends ConsumerWidget {
  const CashLocationFilterTabs({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(cashLocationFilterProvider);
    final selectedType = filter.locationType;
    
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        children: [
          _buildTab(
            label: 'All',
            isSelected: selectedType == null,
            onTap: () {
              ref.read(cashLocationFilterProvider.notifier).update(
                (state) => state.copyWith(locationType: null),
              );
            },
          ),
          _buildTab(
            label: 'Cash',
            icon: Icons.payments_outlined,
            isSelected: selectedType == 'cash',
            onTap: () {
              ref.read(cashLocationFilterProvider.notifier).update(
                (state) => state.copyWith(locationType: 'cash'),
              );
            },
          ),
          _buildTab(
            label: 'Bank',
            icon: Icons.account_balance_outlined,
            isSelected: selectedType == 'bank',
            onTap: () {
              ref.read(cashLocationFilterProvider.notifier).update(
                (state) => state.copyWith(locationType: 'bank'),
              );
            },
          ),
          _buildTab(
            label: 'Vault',
            icon: Icons.lock_outline,
            isSelected: selectedType == 'vault',
            onTap: () {
              ref.read(cashLocationFilterProvider.notifier).update(
                (state) => state.copyWith(locationType: 'vault'),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildTab({
    required String label,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 16,
                      color: isSelected ? TossColors.primary : TossColors.gray600,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    label,
                    style: TossTextStyles.caption.copyWith(
                      color: isSelected ? TossColors.primary : TossColors.gray600,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}