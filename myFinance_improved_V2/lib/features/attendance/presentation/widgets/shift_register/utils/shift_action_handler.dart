import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/providers/app_state_provider.dart';
import '../../../../../../app/providers/auth_providers.dart';
import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../providers/attendance_providers.dart';
import '../controllers/shift_register_controller.dart';
import '../dialogs/shift_alerts.dart';
import 'shift_register_formatters.dart';

/// Handles shift registration and cancellation actions
class ShiftActionHandler {
  final BuildContext context;
  final WidgetRef ref;
  final ShiftRegisterController controller;

  ShiftActionHandler({
    required this.context,
    required this.ref,
    required this.controller,
  });

  /// Handle shift registration
  Future<void> handleRegisterShift() async {
    if (controller.selectedShift == null) return;

    final scaffoldContext = context;
    final allStoreShifts = controller.getAllStoreShifts();
    Map<String, dynamic>? selectedShiftDetail;

    // Find the selected shift details
    for (final shift in allStoreShifts) {
      final shiftId = shift['shift_id'] ?? shift['id'] ?? shift['store_shift_id'];
      if (shiftId?.toString() == controller.selectedShift) {
        selectedShiftDetail = shift;
        break;
      }
    }

    if (selectedShiftDetail == null) return;

    // Extract shift information
    final shiftName = selectedShiftDetail['shift_name'] ??
        selectedShiftDetail['name'] ??
        selectedShiftDetail['shift_type'] ??
        'Shift';
    final startTime = selectedShiftDetail['start_time'] ??
        selectedShiftDetail['shift_start_time'] ??
        selectedShiftDetail['default_start_time'] ??
        '--:--';
    final endTime = selectedShiftDetail['end_time'] ??
        selectedShiftDetail['shift_end_time'] ??
        selectedShiftDetail['default_end_time'] ??
        '--:--';

    final dateStr = '${controller.selectedDate.year}-${controller.selectedDate.month.toString().padLeft(2, '0')}-${controller.selectedDate.day.toString().padLeft(2, '0')}';
    final displayDate = '${controller.selectedDate.day} ${ShiftRegisterFormatters.getMonthName(controller.selectedDate.month)} ${controller.selectedDate.year}';

    await _showRegistrationConfirmationDialog(
      scaffoldContext,
      shiftName.toString(),
      startTime.toString(),
      endTime.toString(),
      displayDate,
      dateStr,
    );
  }

  Future<void> _showRegistrationConfirmationDialog(
    BuildContext scaffoldContext,
    String shiftName,
    String startTime,
    String endTime,
    String displayDate,
    String dateStr,
  ) async {
    await showDialog(
      context: scaffoldContext,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: TossColors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
              boxShadow: [
                BoxShadow(
                  color: TossColors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogHeader(shiftName, startTime, endTime, displayDate),
                _buildDialogButtons(dialogContext, scaffoldContext, dateStr),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogHeader(String shiftName, String startTime, String endTime, String displayDate) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: TossColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.event_available,
              color: TossColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
          Text(
            'Register Shift',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TossSpacing.space3),
          Text(
            'Do you want to register:',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TossSpacing.space3),
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: Column(
              children: [
                Text(
                  displayDate,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  shiftName,
                  style: TossTextStyles.h4.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  '$startTime - $endTime',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogButtons(BuildContext dialogContext, BuildContext scaffoldContext, String dateStr) {
    return Container(
      decoration: const BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
              ),
              child: Text(
                'Cancel',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            height: 48,
            color: TossColors.gray200,
          ),
          Expanded(
            child: TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _performRegistration(scaffoldContext, dateStr);
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
              ),
              child: Text(
                'OK',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _performRegistration(BuildContext scaffoldContext, String dateStr) async {
    final authStateAsync = ref.read(authStateProvider);
    final user = authStateAsync.value;
    if (user == null) return;

    try {
      final registerShiftRequest = ref.read(registerShiftRequestProvider);
      await registerShiftRequest(
        userId: user.id,
        shiftId: controller.selectedShift!,
        storeId: controller.selectedStoreId!,
        requestTime: '$dateStr 00:00:00',
        timezone: 'Asia/Seoul', // TODO: Get from user settings
      );

      final appState = ref.read(appStateProvider);
      final userData = appState.user as Map<String, dynamic>? ?? {};

      final firstName = userData['user_first_name'] ?? '';
      final lastName = userData['user_last_name'] ?? '';
      final fullName = '$firstName $lastName'.trim();

      final userName = fullName.isNotEmpty
          ? fullName
          : (user.userMetadata?['full_name'] as String?) ??
              (user.userMetadata?['name'] as String?) ??
              user.email?.split('@')[0] ??
              'Unknown';

      final profileImage = userData['profile_image'] ?? (user.userMetadata?['avatar_url'] as String?) ?? '';

      controller.updateLocalShiftStatusOptimistically(
        shiftId: controller.selectedShift!,
        userId: user.id,
        userName: userName,
        profileImage: profileImage.toString(),
        requestDate: dateStr,
      );

      controller.resetSelections();
      _showSuccessDialog(scaffoldContext);
    } catch (e) {
      await showDialog<bool>(
        context: scaffoldContext,
        barrierDismissible: true,
        builder: (errorContext) => TossDialog.error(
          title: 'Registration Failed',
          message: 'Failed to register shift: ${e.toString()}',
          primaryButtonText: 'OK',
        ),
      );
    }
  }

  void _showSuccessDialog(BuildContext scaffoldContext) {
    showDialog(
      context: scaffoldContext,
      barrierDismissible: true,
      builder: (BuildContext successContext) {
        return Dialog(
          backgroundColor: TossColors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
              boxShadow: [
                BoxShadow(
                  color: TossColors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space5),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: TossColors.success.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: TossColors.success,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space4),
                      Text(
                        'Success',
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      Text(
                        'Shift registered successfully',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.of(successContext).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                      minimumSize: const Size(double.infinity, 0),
                    ),
                    child: Text(
                      'OK',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Handle shift cancellation
  Future<void> handleCancelShifts() async {
    if (controller.selectedShift == null) return;

    final allStoreShifts = controller.getAllStoreShifts();
    final userShiftData = controller.getUserShiftData(controller.selectedDate);
    Map<String, dynamic>? selectedShiftDetail;

    for (final shift in allStoreShifts) {
      final shiftId = shift['shift_id'] ?? shift['id'] ?? shift['store_shift_id'];

      if (shiftId?.toString() == controller.selectedShift) {
        if (userShiftData != null) {
          selectedShiftDetail = {
            ...shift,
            'shift_request_id': userShiftData['shift_request_id'],
            'is_approved': userShiftData['is_approved'] ?? false,
          };
        }
        break;
      }
    }

    if (selectedShiftDetail == null) {
      if (userShiftData == null) {
        ShiftAlerts.showNotRegisteredAlert(context);
      }
      return;
    }

    if (selectedShiftDetail['is_approved'] == true) {
      ShiftAlerts.showApprovedShiftAlert(context);
    } else {
      await _showCancelConfirmationDialog([selectedShiftDetail]);
    }
  }

  Future<void> _showCancelConfirmationDialog(List<Map<String, dynamic>> shiftsToCancel) async {
    ShiftAlerts.showCancelConfirmationDialog(
      context,
      shiftsToCancel: shiftsToCancel,
      onConfirm: () async {
        context.pop();
        await _performCancellation(shiftsToCancel);
      },
    );
  }

  Future<void> _performCancellation(List<Map<String, dynamic>> shiftsToCancel) async {
    try {
      final authStateAsync = ref.read(authStateProvider);
      final user = authStateAsync.value;
      if (user == null) return;

      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => const TossLoadingView(),
      );

      for (final shift in shiftsToCancel) {
        final shiftId = shift['shift_id']?.toString() ??
            shift['id']?.toString() ??
            shift['store_shift_id']?.toString() ??
            '';
        final dateStr = '${controller.selectedDate.year}-${controller.selectedDate.month.toString().padLeft(2, '0')}-${controller.selectedDate.day.toString().padLeft(2, '0')}';

        if (shiftId.isNotEmpty) {
          final deleteShiftRequest = ref.read(deleteShiftRequestProvider);
          await deleteShiftRequest(
            userId: user.id,
            shiftId: shiftId,
            requestDate: dateStr,
            timezone: 'Asia/Seoul', // TODO: Get from user settings
          );

          controller.removeFromLocalShiftStatusOptimistically(
            shiftId: shiftId,
            userId: user.id,
            requestDate: dateStr,
          );
        }
      }

      if (context.mounted) context.pop();
      controller.resetSelections();
      _showCancellationSuccessDialog(shiftsToCancel.length);
    } catch (e) {
      if (context.mounted) context.pop();
      _showErrorDialog(e.toString());
    }
  }

  void _showCancellationSuccessDialog(int count) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: TossColors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
              boxShadow: [
                BoxShadow(
                  color: TossColors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space5),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: TossColors.success.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle_outline,
                          color: TossColors.success,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space4),
                      Text(
                        'Success',
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      Text(
                        'Successfully cancelled $count shift${count > 1 ? 's' : ''}.',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  color: TossColors.gray100,
                ),
                InkWell(
                  onTap: () => context.pop(),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: TossSpacing.space4,
                    ),
                    child: Center(
                      child: Text(
                        'OK',
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: TossColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to cancel shift: $error'),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text(
                'OK',
                style: TossTextStyles.body.copyWith(color: TossColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }
}
