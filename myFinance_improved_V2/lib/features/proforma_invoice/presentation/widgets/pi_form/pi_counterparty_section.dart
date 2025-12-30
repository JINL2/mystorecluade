import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/domain/entities/selector_entities.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_dropdown.dart';
import '../../../../counter_party/presentation/widgets/counter_party_form.dart';
import '../../providers/pi_providers.dart';

/// Counterparty selector section for PI form
class PICounterpartySection extends ConsumerStatefulWidget {
  final String? counterpartyId;
  final TextEditingController counterpartyInfoController;
  final String? errorText;
  final ValueChanged<CounterpartyData?> onCounterpartyChanged;

  const PICounterpartySection({
    super.key,
    required this.counterpartyId,
    required this.counterpartyInfoController,
    this.errorText,
    required this.onCounterpartyChanged,
  });

  @override
  ConsumerState<PICounterpartySection> createState() => _PICounterpartySectionState();
}

class _PICounterpartySectionState extends ConsumerState<PICounterpartySection> {
  void _showCreateCounterpartySheet() {
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.1,
        ),
        child: const CounterPartyForm(),
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
        label: 'Counterparty',
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
              'Failed to load counterparties',
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
              'Counterparty',
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
              'Create your first counterparty',
              style: TossTextStyles.body.copyWith(color: TossColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelector(List<CounterpartyData> counterparties) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        color: TossColors.surface,
        border: Border.all(
          color: widget.errorText != null ? TossColors.error : TossColors.border,
          width: widget.errorText != null ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showBottomSheet(counterparties),
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.counterpartyId != null
                        ? counterparties.firstWhere(
                            (c) => c.id == widget.counterpartyId,
                            orElse: () => counterparties.first,
                          ).name
                        : 'Select counterparty',
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: widget.counterpartyId != null ? TossColors.textPrimary : TossColors.textTertiary,
                      fontWeight: widget.counterpartyId != null ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: TossColors.gray600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(List<CounterpartyData> counterparties) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: const BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: TossSpacing.space3, bottom: TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              child: Text(
                'Counterparty',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Divider(height: 1, thickness: 1, color: TossColors.gray100),
            ),
            const SizedBox(height: TossSpacing.space2),
            // Options list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + TossSpacing.space4,
                ),
                itemCount: counterparties.length,
                itemBuilder: (context, index) {
                  final cp = counterparties[index];
                  final isSelected = cp.id == widget.counterpartyId;
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                      vertical: 2,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        onTap: () {
                          // Build address from additionalData
                          final additionalData = cp.additionalData;
                          final parts = <String>[];
                          if (additionalData != null) {
                            if (additionalData['address'] != null) parts.add(additionalData['address'].toString());
                            if (additionalData['city'] != null) parts.add(additionalData['city'].toString());
                            if (additionalData['country'] != null) parts.add(additionalData['country'].toString());
                          }
                          widget.counterpartyInfoController.text = parts.join(', ');
                          widget.onCounterpartyChanged(cp);
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: TossSpacing.space3,
                            vertical: TossSpacing.space3,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cp.name,
                                      style: TossTextStyles.body.copyWith(
                                        color: TossColors.textPrimary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (cp.type.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        cp.type,
                                        style: TossTextStyles.caption.copyWith(
                                          color: TossColors.gray600,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check,
                                  color: TossColors.primary,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
