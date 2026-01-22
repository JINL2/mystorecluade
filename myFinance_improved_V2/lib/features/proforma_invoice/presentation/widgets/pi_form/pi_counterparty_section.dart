import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/domain/entities/selector_entities.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../counter_party/presentation/widgets/counter_party_form.dart';
import '../../providers/pi_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/toss_bottom_sheet.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/selection_bottom_sheet_common.dart';

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
    TossBottomSheet.showFullscreen<bool>(
      context: context,
      builder: (context) => const CounterPartyForm(),
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
                fontWeight: TossFontWeight.semibold,
              ),
            ),
            const SizedBox(width: TossSpacing.space0_5),
            Text(
              '*',
              style: TossTextStyles.label.copyWith(
                color: TossColors.error,
                fontWeight: TossFontWeight.semibold,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: _showCreateCounterpartySheet,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: TossSpacing.iconSM2, color: TossColors.primary),
              const SizedBox(width: TossSpacing.space0_5),
              Text(
                'Add New',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.primary,
                  fontWeight: TossFontWeight.semibold,
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
            Icon(Icons.person_add_outlined, size: TossSpacing.iconMD, color: TossColors.primary),
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
        color: TossColors.transparent,
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
                      fontWeight: widget.counterpartyId != null ? TossFontWeight.semibold : TossFontWeight.regular,
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
    SelectionBottomSheetCommon.show<void>(
      context: context,
      title: 'Counterparty',
      maxHeightRatio: 0.8,
      itemCount: counterparties.length,
      itemBuilder: (context, index) {
        final cp = counterparties[index];
        final isSelected = cp.id == widget.counterpartyId;
        return Material(
          color: TossColors.transparent,
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
                            fontWeight: TossFontWeight.medium,
                          ),
                        ),
                        if (cp.type.isNotEmpty) ...[
                          const SizedBox(height: TossSpacing.space0_5),
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
        );
      },
    );
  }
}
