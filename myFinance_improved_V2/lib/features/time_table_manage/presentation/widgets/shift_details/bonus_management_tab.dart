import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../domain/entities/shift_card.dart';
import '../../../domain/usecases/update_bonus_amount.dart';
import '../../providers/usecase/time_table_usecase_providers.dart';
import 'bonus_confirmation_dialog.dart';
import 'helpers/salary_calculator.dart';
import 'widgets/bonus_input_section.dart';
import 'widgets/confirm_button.dart';
import 'widgets/payment_details_card.dart';
import 'widgets/salary_info_card.dart';

class BonusManagementTab extends ConsumerStatefulWidget {
  final ShiftCard card;

  const BonusManagementTab({
    super.key,
    required this.card,
  });

  @override
  ConsumerState<BonusManagementTab> createState() => _BonusManagementTabState();
}

class _BonusManagementTabState extends ConsumerState<BonusManagementTab> {
  late TextEditingController bonusController;
  String bonusInputText = '';

  @override
  void initState() {
    super.initState();
    // Initialize bonus controller - always start with empty text
    bonusController = TextEditingController(text: '');
    bonusInputText = bonusController.text;
    bonusController.addListener(() {
      setState(() {
        bonusInputText = bonusController.text;
      });
    });
  }

  @override
  void dispose() {
    bonusController.dispose();
    super.dispose();
  }

  Future<void> _showBonusConfirmationDialog() async {
    // Get current bonus from card
    final num currentBonus = widget.card.bonusAmount ?? 0;

    // Get base pay (paidHour * hourly wage)
    final num basePay = widget.card.paidHour * (widget.card.employee.hourlyWage ?? 0);

    // Get typed bonus (remove commas for parsing)
    String cleanInput = bonusInputText.replaceAll(',', '');
    final num typedBonus = num.tryParse(cleanInput) ?? 0;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BonusConfirmationDialog(
          basePay: basePay,
          currentBonus: currentBonus,
          typedBonus: typedBonus,
        );
      },
    );

    if (result == true && mounted) {
      await _updateBonusAmount(typedBonus);
    }
  }

  Future<void> _updateBonusAmount(num newBonus) async {
    try {
      // Show loading
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: TossColors.primary,
          ),
        ),
      );

      // Get shift request ID from the card
      final shiftRequestId = widget.card.shiftRequestId;

      // Use UseCase instead of Repository directly (Clean Architecture)
      await ref.read(updateBonusAmountUseCaseProvider).call(
        UpdateBonusAmountParams(
          shiftRequestId: shiftRequestId,
          bonusAmount: newBonus.toDouble(),
        ),
      );

      // Close loading dialog
      if (mounted) {
        context.pop();
      }

      // Update the card in parent's state by returning the new bonus amount
      if (mounted) {
        Navigator.of(context).pop({'updated': true, 'bonus_amount': newBonus, 'shift_request_id': shiftRequestId});
      }

    } catch (e) {
      // Close loading dialog if open
      if (mounted && Navigator.canPop(context)) {
        context.pop();
      }

      // Show error message
      if (mounted) {
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Error',
            message: 'Failed to update bonus: $e',
            primaryButtonText: 'OK',
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate salary information using helper
    final calculation = SalaryCalculator.calculate(widget.card);
    final num bonusAmount = widget.card.bonusAmount ?? 0;

    // Create scroll controller for auto-scroll when keyboard appears
    final ScrollController scrollController = ScrollController();

    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                left: TossSpacing.space5,
                right: TossSpacing.space5,
                top: TossSpacing.space5,
                bottom: MediaQuery.of(context).viewInsets.bottom + TossSpacing.space5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Salary & Bonus Information',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space2),
                  Text(
                    'View salary details and set bonus amount',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space5),

                  // Salary Type and Amount
                  SalaryInfoCard(calculation: calculation),
                  const SizedBox(height: TossSpacing.space3),

                  // Combined Payment Information Box
                  PaymentDetailsCard(
                    basePay: calculation.basePay,
                    bonusAmount: bonusAmount,
                  ),
                  const SizedBox(height: TossSpacing.space5),

                  // Divider
                  Container(
                    height: 1,
                    color: TossColors.gray200,
                  ),
                  const SizedBox(height: TossSpacing.space5),

                  // Bonus Input Section
                  BonusInputSection(
                    controller: bonusController,
                    scrollController: scrollController,
                  ),

                  // Add extra padding at the bottom for keyboard
                  const SizedBox(height: TossSpacing.space10),
                ],
              ),
            ),
          ),
          // Bottom button section
          Container(
            padding: const EdgeInsets.all(TossSpacing.space5),
            decoration: BoxDecoration(
              color: TossColors.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.xxl),
                topRight: Radius.circular(TossBorderRadius.xxl),
              ),
              boxShadow: [
                BoxShadow(
                  color: TossColors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: ConfirmButton(
                label: 'Confirm Bonus',
                color: TossColors.primary,
                icon: Icons.check_circle_outline,
                onTap: () {
                  HapticFeedback.lightImpact();
                  _showBonusConfirmationDialog();
                },
                disabled: bonusInputText.isEmpty,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
