import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/input_formatters.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../providers/time_table_providers.dart';
import 'bonus_confirmation_dialog.dart';

class BonusManagementTab extends ConsumerStatefulWidget {
  final Map<String, dynamic> card;

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
    final dynamic rawBonusAmount = widget.card['bonus_amount'];
    final num currentBonus = (rawBonusAmount is String
        ? num.tryParse(rawBonusAmount) ?? 0
        : rawBonusAmount ?? 0) as num;

    // Get base pay
    final dynamic rawBasePay = widget.card['base_pay'] ?? '0';
    final num basePay = (rawBasePay is String
        ? num.tryParse(rawBasePay.replaceAll(',', '')) ?? 0
        : rawBasePay ?? 0) as num;

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
      final shiftRequestId = widget.card['shift_request_id'] as String?;

      if (shiftRequestId == null) {
        throw Exception('Shift request ID not found');
      }

      // Use repository instead of direct Supabase call
      await ref.read(timeTableRepositoryProvider).updateBonusAmount(
        shiftRequestId: shiftRequestId,
        bonusAmount: newBonus.toDouble(),
      );

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Update the card in parent's state by returning the new bonus amount
      if (mounted) {
        Navigator.of(context).pop({'updated': true, 'bonus_amount': newBonus, 'shift_request_id': shiftRequestId});
      }

    } catch (e) {
      // Close loading dialog if open
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
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
    // Extract salary information from card data
    final String salaryType = (widget.card['salary_type'] ?? 'hourly') as String;
    final String salaryAmountStr = (widget.card['salary_amount'] ?? '0') as String;
    final dynamic rawBasePay = widget.card['base_pay'] ?? '0';
    final dynamic rawBonusAmount = widget.card['bonus_amount'];

    // Parse numeric values
    final num salaryAmount = num.tryParse(salaryAmountStr.replaceAll(',', '')) ?? 0;
    final num basePay = (rawBasePay is String
        ? num.tryParse(rawBasePay.replaceAll(',', '')) ?? 0
        : rawBasePay ?? 0) as num;
    final num bonusAmount = (rawBonusAmount is String
        ? num.tryParse(rawBonusAmount) ?? 0
        : rawBonusAmount ?? 0) as num;

    // Helper function to format salary type display
    String getSalaryTypeDisplay() {
      if (salaryType == 'hourly') {
        return 'Hourly Rate';
      } else if (salaryType == 'monthly') {
        return 'Monthly Salary';
      }
      return salaryType;
    }

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
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                    border: Border.all(
                      color: TossColors.gray200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getSalaryTypeDisplay(),
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space1),
                          Text(
                            salaryAmount > 0
                                ? NumberFormat('#,###').format(salaryAmount.toInt())
                                : '0',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space3,
                          vertical: TossSpacing.space2,
                        ),
                        decoration: BoxDecoration(
                          color: salaryType == 'hourly'
                              ? TossColors.primary.withValues(alpha: 0.1)
                              : TossColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        ),
                        child: Text(
                          salaryType == 'hourly' ? 'Per Hour' : 'Per Month',
                          style: TossTextStyles.caption.copyWith(
                            color: salaryType == 'hourly'
                                ? TossColors.primary
                                : TossColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TossSpacing.space3),

                // Combined Payment Information Box with Blue Design
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: TossColors.info.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                    border: Border.all(
                      color: TossColors.info.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Text(
                        'Payment Details',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space3),

                      // Base Pay Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Base Pay',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            basePay != 0
                                ? NumberFormat('#,###').format(basePay.toInt())
                                : '0',
                            style: TossTextStyles.body.copyWith(
                              color: basePay < 0 ? TossColors.error : TossColors.gray700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TossSpacing.space2),

                      // Current Bonus Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Current Bonus',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            bonusAmount > 0
                                ? '+ ${NumberFormat('#,###').format(bonusAmount.toInt())}'
                                : '+ 0',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.info,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      // Divider
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
                        height: 1,
                        color: TossColors.info.withValues(alpha: 0.2),
                      ),

                      // Total Pay Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Pay',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            NumberFormat('#,###').format((basePay + bonusAmount).toInt()),
                            style: TossTextStyles.h3.copyWith(
                              color: (basePay + bonusAmount) < 0
                                  ? TossColors.error
                                  : TossColors.info,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TossSpacing.space5),

                // Divider
                Container(
                  height: 1,
                  color: TossColors.gray200,
                ),
                const SizedBox(height: TossSpacing.space5),

                // New Bonus Section Title
                Text(
                  'Set New Bonus',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'Enter a new bonus amount for this shift',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space3),

                // Bonus input field
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space4,
                    vertical: TossSpacing.space3,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.white,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                    border: Border.all(
                      color: TossColors.gray300,
                      width: 1.5,
                    ),
                  ),
                  child: TextField(
                    controller: bonusController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      ThousandSeparatorInputFormatter(),
                    ],
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      hintText: '0',
                      hintStyle: TossTextStyles.h3.copyWith(
                        color: TossColors.gray400,
                        fontWeight: FontWeight.w700,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onTap: () {
                      // Auto-scroll to make the input field visible when keyboard appears
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (scrollController.hasClients) {
                          scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      });
                    },
                  ),
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
            child: _buildBottomButton(
              'Confirm Bonus',
              TossColors.primary,
              Icons.check_circle_outline,
              () {
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

  Widget _buildBottomButton(
    String label,
    Color color,
    IconData icon,
    VoidCallback? onTap, {
    bool disabled = false,
  }) {
    final effectiveColor = disabled ? TossColors.gray300 : color;

    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          decoration: BoxDecoration(
            color: disabled ? TossColors.gray100 : effectiveColor,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: disabled ? TossColors.gray200 : effectiveColor,
              width: 0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: disabled
                    ? TossColors.gray400
                    : TossColors.white,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                label,
                style: TossTextStyles.body.copyWith(
                  color: disabled
                      ? TossColors.gray400
                      : TossColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
