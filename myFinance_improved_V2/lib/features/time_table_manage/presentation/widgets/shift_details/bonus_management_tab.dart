import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/input_formatters.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../domain/entities/shift_card.dart';
import '../../providers/time_table_providers.dart';
import 'bonus_confirmation_dialog.dart';

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
    // Extract salary information from card data
    final String salaryType = widget.card.salaryType ?? 'hourly';
    final String salaryAmountStr = widget.card.salaryAmount ?? '0';
    final num bonusAmount = widget.card.bonusAmount ?? 0;

    // Parse salary amount
    final num salaryAmount = num.tryParse(salaryAmountStr.replaceAll(',', '')) ?? 0;

    // Calculate paid hours and base pay
    num paidHours = 0;
    num basePay = 0;

    if (salaryType == 'hourly') {
      // Get time data - prefer confirm times, fallback to actual times
      final String? confirmStartStr = widget.card.confirmedStartTime?.toIso8601String();
      final String? confirmEndStr = widget.card.confirmedEndTime?.toIso8601String();
      final String? actualStartStr = widget.card.actualStartTime?.toIso8601String();
      final String? actualEndStr = widget.card.actualEndTime?.toIso8601String();
      final String requestDate = widget.card.requestDate;

      String? startTimeStr;
      String? endTimeStr;

      // Priority: confirm times > actual times
      if (confirmStartStr != null && confirmStartStr.isNotEmpty && confirmStartStr != '--:--') {
        startTimeStr = confirmStartStr;
      } else if (actualStartStr != null && actualStartStr.isNotEmpty) {
        startTimeStr = actualStartStr;
      }

      if (confirmEndStr != null && confirmEndStr.isNotEmpty && confirmEndStr != '--:--') {
        endTimeStr = confirmEndStr;
      } else if (actualEndStr != null && actualEndStr.isNotEmpty) {
        endTimeStr = actualEndStr;
      }

      // Calculate hours if both start and end times are available
      if (startTimeStr != null && endTimeStr != null && requestDate.isNotEmpty) {
        try {
          DateTime? startLocal;
          DateTime? endLocal;

          // Check if the time string is already a full timestamp or just time
          if (startTimeStr.contains('T') || startTimeStr.contains(' ')) {
            // Already a full timestamp (e.g., "2025-10-30T16:00:00.000")
            startLocal = DateTime.parse(startTimeStr);
            endLocal = DateTime.parse(endTimeStr);
          } else {
            // Just time (HH:mm or HH:mm:ss), need to add date
            final startParts = startTimeStr.split(':');
            final endParts = endTimeStr.split(':');

            if (startParts.length >= 2 && endParts.length >= 2) {
              // Create UTC DateTime and convert to local
              final startUtc = DateTime.parse('${requestDate}T${startTimeStr.length == 5 ? '$startTimeStr:00' : startTimeStr}Z');
              final endUtc = DateTime.parse('${requestDate}T${endTimeStr.length == 5 ? '$endTimeStr:00' : endTimeStr}Z');

              startLocal = startUtc.toLocal();
              endLocal = endUtc.toLocal();
            } else {
              startLocal = null;
              endLocal = null;
            }
          }

          if (startLocal != null && endLocal != null) {
            // Calculate duration in hours
            final duration = endLocal.difference(startLocal);
            paidHours = duration.inMinutes / 60.0;

            // Calculate base pay
            basePay = salaryAmount * paidHours;
          }
        } catch (e) {
          // Silently handle error - paidHours and basePay remain 0
        }
      }
    } else if (salaryType == 'monthly') {
      // For monthly salary, base pay is the monthly amount
      basePay = salaryAmount;
    }

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
                  child: Column(
                    children: [
                      Row(
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
                      // Show worked hours for hourly employees
                      if (salaryType == 'hourly' && paidHours > 0) ...[
                        const SizedBox(height: TossSpacing.space2),
                        Container(
                          padding: const EdgeInsets.all(TossSpacing.space2),
                          decoration: BoxDecoration(
                            color: TossColors.white,
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 14,
                                color: TossColors.gray600,
                              ),
                              const SizedBox(width: TossSpacing.space1),
                              Text(
                                'Worked: ${paidHours.toStringAsFixed(1)} hours',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
