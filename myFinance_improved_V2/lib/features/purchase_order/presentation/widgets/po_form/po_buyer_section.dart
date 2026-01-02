import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/counterparty_provider.dart';
import '../../../../../core/domain/entities/selector_entities.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../counter_party/presentation/widgets/counter_party_form.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Buyer selector section for PO form
class POBuyerSection extends ConsumerStatefulWidget {
  final String? buyerId;
  final String? errorText;
  final ValueChanged<CounterpartyData?> onBuyerChanged;

  const POBuyerSection({
    super.key,
    required this.buyerId,
    this.errorText,
    required this.onBuyerChanged,
  });

  @override
  ConsumerState<POBuyerSection> createState() => _POBuyerSectionState();
}

class _POBuyerSectionState extends ConsumerState<POBuyerSection> {
  void _showCreateCounterpartySheet() {
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: const CounterPartyForm(),
        ),
      ),
    ).then((result) {
      if (result == true) {
        ref.invalidate(currentCounterpartiesProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final counterpartyAsync = ref.watch(currentCounterpartiesProvider);

    return counterpartyAsync.when(
      loading: () => TossDropdown<String>(
        label: 'Buyer',
        items: const [],
        isLoading: true,
        isRequired: true,
        hint: 'Loading...',
      ),
      error: (error, stackTrace) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabelWithAddButton(),
          const SizedBox(height: TossSpacing.space2),
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(color: TossColors.error),
            ),
            child: Text(
              'Failed to load buyers',
              style: TossTextStyles.body.copyWith(color: TossColors.error),
            ),
          ),
        ],
      ),
      data: (counterparties) {
        if (counterparties.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabelWithAddButton(),
              const SizedBox(height: TossSpacing.space2),
              _buildEmptyPlaceholder(),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabelWithAddButton(),
            const SizedBox(height: TossSpacing.space2),
            _buildSelector(counterparties),
          ],
        );
      },
    );
  }

  Widget _buildLabelWithAddButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'Buyer',
              style: TossTextStyles.label.copyWith(
                color: widget.errorText != null ? TossColors.error : TossColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              '*',
              style: TossTextStyles.label.copyWith(
                color: TossColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: _showCreateCounterpartySheet,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 16, color: TossColors.primary),
              const SizedBox(width: 2),
              Text(
                'Add New',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyPlaceholder() {
    return GestureDetector(
      onTap: _showCreateCounterpartySheet,
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: widget.errorText != null ? TossColors.error : TossColors.gray200,
            width: widget.errorText != null ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add_outlined, size: 20, color: TossColors.primary),
            const SizedBox(width: TossSpacing.space2),
            Text(
              'Add your first buyer',
              style: TossTextStyles.body.copyWith(color: TossColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelector(List<CounterpartyData> counterparties) {
    String? currentValue;
    if (widget.buyerId != null && counterparties.any((c) => c.id == widget.buyerId)) {
      currentValue = widget.buyerId;
    }

    return TossDropdown<String>(
      label: '',
      value: currentValue,
      hint: 'Select buyer',
      isRequired: true,
      errorText: widget.errorText,
      items: counterparties.map((c) => TossDropdownItem<String>(
        value: c.id,
        label: c.name,
        subtitle: _getCounterpartySubtitle(c),
      )).toList(),
      onChanged: (v) {
        if (v == null) return;
        try {
          final selected = counterparties.firstWhere((c) => c.id == v);
          widget.onBuyerChanged(selected);
        } catch (e) {
          widget.onBuyerChanged(null);
        }
      },
    );
  }

  String? _getCounterpartySubtitle(CounterpartyData c) {
    final country = c.additionalData?['country'] as String?;
    if (country != null && country.isNotEmpty) {
      return country;
    }
    return c.type.isNotEmpty ? c.type : null;
  }
}
