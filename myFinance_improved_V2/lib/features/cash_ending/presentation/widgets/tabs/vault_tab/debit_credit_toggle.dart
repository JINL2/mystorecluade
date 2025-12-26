// lib/features/cash_ending/presentation/widgets/tabs/vault_tab/debit_credit_toggle.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/widgets/toss/toss_button_1.dart';

/// Transaction type for vault operations
enum VaultTransactionType {
  debit,  // In
  credit, // Out
  recount,
}

/// Debit/Credit/Recount toggle widget for vault tab
///
/// Allows selection between In (debit), Out (credit), and Recount modes
class DebitCreditToggle extends StatelessWidget {
  final VaultTransactionType selectedType;
  final ValueChanged<VaultTransactionType> onTypeChanged;

  const DebitCreditToggle({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // In (Debit) Button
        Expanded(
          child: _buildToggleButton(
            label: 'In',
            icon: LucideIcons.arrowDownCircle,
            type: VaultTransactionType.debit,
            isSelected: selectedType == VaultTransactionType.debit,
          ),
        ),
        const SizedBox(width: 8),

        // Out (Credit) Button
        Expanded(
          child: _buildToggleButton(
            label: 'Out',
            icon: LucideIcons.arrowUpCircle,
            type: VaultTransactionType.credit,
            isSelected: selectedType == VaultTransactionType.credit,
          ),
        ),
        const SizedBox(width: 8),

        // Recount Button
        Expanded(
          child: _buildToggleButton(
            label: 'Recount',
            icon: LucideIcons.refreshCw,
            type: VaultTransactionType.recount,
            isSelected: selectedType == VaultTransactionType.recount,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton({
    required String label,
    required IconData icon,
    required VaultTransactionType type,
    required bool isSelected,
  }) {
    if (isSelected) {
      return TossButton1.outlined(
        text: label,
        leadingIcon: Icon(icon, size: 20),
        onPressed: () => onTypeChanged(type),
        fullWidth: true,
        borderRadius: TossBorderRadius.lg,
      );
    } else {
      return TossButton1.outlinedGray(
        text: label,
        leadingIcon: Icon(icon, size: 20),
        onPressed: () => onTypeChanged(type),
        fullWidth: true,
        borderRadius: TossBorderRadius.lg,
      );
    }
  }
}

/// Extension to convert between string and enum
extension VaultTransactionTypeExtension on VaultTransactionType {
  String get stringValue {
    switch (this) {
      case VaultTransactionType.debit:
        return 'debit';
      case VaultTransactionType.credit:
        return 'credit';
      case VaultTransactionType.recount:
        return 'recount';
    }
  }

  static VaultTransactionType fromString(String value) {
    switch (value) {
      case 'debit':
        return VaultTransactionType.debit;
      case 'credit':
        return VaultTransactionType.credit;
      case 'recount':
        return VaultTransactionType.recount;
      default:
        return VaultTransactionType.debit;
    }
  }
}
