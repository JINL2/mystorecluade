import 'package:flutter/material.dart';

import 'package:myfinance_improved/core/domain/entities/selector_entities.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Cash location selection section for cash category accounts
///
/// Wraps the CashLocationSelector with appropriate defaults.
class CashLocationSection extends StatelessWidget {
  final String? selectedLocationId;
  final Set<String>? blockedLocationIds;
  final Function(CashLocationData) onCashLocationSelected;
  final Function(String?) onLocationIdChanged;

  const CashLocationSection({
    super.key,
    required this.selectedLocationId,
    this.blockedLocationIds,
    required this.onCashLocationSelected,
    required this.onLocationIdChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CashLocationSelector(
      selectedLocationId: selectedLocationId,
      blockedLocationIds: blockedLocationIds,
      onCashLocationSelected: onCashLocationSelected,
      onChanged: onLocationIdChanged,
    );
  }
}
