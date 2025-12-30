/// Essential Selectors - Conditional selector components for quick templates
///
/// Purpose: Displays only the essential selectors needed based on template analysis:
/// - Cash location selector (when template needs cash location)
/// - Counterparty selector (when template needs counterparty)
///
/// Automatically determines which selectors to show based on missing items
/// from template analysis results.
///
/// Usage: EssentialSelectors(analysis: analysis, onSelectionChanged: callback)
library;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/cash_location_provider.dart';
import 'package:myfinance_improved/app/providers/counterparty_provider.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_dropdown.dart';

import '../../../domain/value_objects/template_analysis_result.dart';

class EssentialSelectors extends ConsumerWidget {
  final TemplateAnalysisResult analysis;
  final String? selectedMyCashLocationId;
  final String? selectedCounterpartyId;
  final String? selectedCounterpartyCashLocationId;
  final ValueChanged<String?>? onMyCashLocationChanged;
  final ValueChanged<String?>? onCounterpartyChanged;
  final ValueChanged<String?>? onCounterpartyCashLocationChanged;

  const EssentialSelectors({
    super.key,
    required this.analysis,
    this.selectedMyCashLocationId,
    this.selectedCounterpartyId,
    this.selectedCounterpartyCashLocationId,
    this.onMyCashLocationChanged,
    this.onCounterpartyChanged,
    this.onCounterpartyCashLocationChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectors = _buildSelectors(ref);

    if (selectors.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Quick Setup',
          style: TossTextStyles.labelLarge.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        ...selectors.map(
          (selector) => Padding(
            padding: const EdgeInsets.only(bottom: TossSpacing.space3),
            child: selector,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSelectors(WidgetRef ref) {
    final List<Widget> selectors = [];

    // Add cash location selector if needed
    if (analysis.missingItems.contains('cash_location')) {
      selectors.add(_buildCashLocationSelector(ref));
    }

    // Add counterparty selector if needed
    if (analysis.missingItems.contains('counterparty')) {
      selectors.add(_buildCounterpartySelector(ref));
    }

    // Add counterparty cash location selector if needed
    if (analysis.missingItems.contains('counterparty_cash_location')) {
      selectors.add(_buildCounterpartyCashLocationSelector());
    }

    return selectors;
  }

  Widget _buildCashLocationSelector(WidgetRef ref) {
    final cashLocationsAsync = ref.watch(companyCashLocationsProvider);

    return TossDropdown<String>(
      label: 'Cash Location',
      hint: 'Select cash location',
      value: selectedMyCashLocationId,
      isLoading: cashLocationsAsync.isLoading,
      items: cashLocationsAsync.maybeWhen(
        data: (locations) => locations
            .map((l) => TossDropdownItem(
                  value: l.id,
                  label: l.name,
                  subtitle: l.type,
                ))
            .toList(),
        orElse: () => [],
      ),
      onChanged: onMyCashLocationChanged,
    );
  }

  Widget _buildCounterpartySelector(WidgetRef ref) {
    final counterpartiesAsync = ref.watch(currentCounterpartiesProvider);

    return TossDropdown<String>(
      label: 'Counterparty',
      hint: 'Select counterparty',
      value: selectedCounterpartyId,
      isLoading: counterpartiesAsync.isLoading,
      items: counterpartiesAsync.maybeWhen(
        data: (counterparties) => counterparties
            .map((c) => TossDropdownItem(
                  value: c.id,
                  label: c.name,
                  subtitle: c.type,
                ))
            .toList(),
        orElse: () => [],
      ),
      onChanged: onCounterpartyChanged,
    );
  }

  Widget _buildCounterpartyCashLocationSelector() {
    // For counterparty cash location, we would need a specialized selector
    // For now, return a placeholder that matches the interface
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Text(
        'Counterparty Cash Location: ${selectedCounterpartyCashLocationId ?? "Not selected"}',
        style: TossTextStyles.body.copyWith(
          color: TossColors.gray600,
        ),
      ),
    );
  }

  /// Check if all essential selections are complete
  bool get isComplete {
    bool allSelected = true;

    if (analysis.missingItems.contains('cash_location') &&
        selectedMyCashLocationId == null) {
      allSelected = false;
    }

    if (analysis.missingItems.contains('counterparty') &&
        selectedCounterpartyId == null) {
      allSelected = false;
    }

    if (analysis.missingItems.contains('counterparty_cash_location') &&
        selectedCounterpartyCashLocationId == null) {
      allSelected = false;
    }

    return allSelected;
  }

  /// Get validation error messages for incomplete selections
  List<String> get validationErrors {
    final errors = <String>[];

    if (analysis.missingItems.contains('cash_location') &&
        selectedMyCashLocationId == null) {
      errors.add('Please select a cash location');
    }

    if (analysis.missingItems.contains('counterparty') &&
        selectedCounterpartyId == null) {
      errors.add('Please select a counterparty');
    }

    if (analysis.missingItems.contains('counterparty_cash_location') &&
        selectedCounterpartyCashLocationId == null) {
      errors.add('Please select counterparty cash location');
    }

    return errors;
  }
}
