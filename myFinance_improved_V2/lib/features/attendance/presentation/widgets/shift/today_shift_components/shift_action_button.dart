import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../../domain/entities/shift_problem_info.dart';
import '../../../../domain/entities/shift_status.dart';

/// Action button for check-in/check-out/report
/// Extracted from today_shift_card.dart for better modularity
class ShiftActionButton extends StatelessWidget {
  final ShiftStatus status;
  final ShiftProblemInfo? problemInfo;
  final VoidCallback? onCheckIn;
  final VoidCallback? onCheckOut;
  final VoidCallback? onReportIssue;
  final bool isLoading;

  const ShiftActionButton({
    super.key,
    required this.status,
    this.problemInfo,
    this.onCheckIn,
    this.onCheckOut,
    this.onReportIssue,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (status == ShiftStatus.noShift) {
      return const SizedBox.shrink();
    }

    String buttonText;
    IconData buttonIcon;
    VoidCallback? onPressed;
    Color buttonColor;
    bool isOutlined = false;

    switch (status) {
      // 체크인 대기 상태 (파란 버튼)
      case ShiftStatus.upcoming:
      case ShiftStatus.undone:
        buttonText = 'Check-in';
        buttonIcon = Icons.login;
        onPressed = onCheckIn;
        buttonColor = TossColors.primary;
        break;
      // 체크인 완료, 체크아웃 대기 상태 (빨간 버튼)
      case ShiftStatus.onTime:
      case ShiftStatus.inProgress:
      case ShiftStatus.late:
        buttonText = 'Check-out';
        buttonIcon = Icons.logout;
        onPressed = onCheckOut;
        buttonColor = TossColors.error;
        break;
      // 완료된 시프트 - Report 버튼 표시
      case ShiftStatus.completed:
        // 이미 리포트한 경우 - 회색 비활성화 버튼
        if (problemInfo?.isReported == true) {
          buttonText = 'Report Done';
          buttonIcon = Icons.check_circle_outline;
          onPressed = null; // non-clickable
          buttonColor = TossColors.gray400;
          isOutlined = true;
        } else {
          buttonText = 'Report Issue';
          buttonIcon = Icons.flag_outlined;
          onPressed = onReportIssue;
          buttonColor = TossColors.warning;
          isOutlined = true;
        }
        break;
      case ShiftStatus.noShift:
        return const SizedBox.shrink();
    }

    // Outlined style for Report button
    if (isOutlined) {
      return TossButton.outlinedGray(
        text: buttonText,
        onPressed: isLoading ? null : onPressed,
        leadingIcon: Icon(buttonIcon, size: TossSpacing.iconMD),
        fullWidth: true,
        isLoading: isLoading,
      );
    }

    // Primary button for Check-in/Check-out
    if (buttonColor == TossColors.error) {
      return TossButton.destructive(
        text: buttonText,
        onPressed: isLoading ? null : onPressed,
        leadingIcon:
            Icon(buttonIcon, size: TossSpacing.iconMD, color: TossColors.white),
        fullWidth: true,
        isLoading: isLoading,
      );
    }

    return TossButton.primary(
      text: buttonText,
      onPressed: isLoading ? null : onPressed,
      leadingIcon:
          Icon(buttonIcon, size: TossSpacing.iconMD, color: TossColors.white),
      fullWidth: true,
      isLoading: isLoading,
    );
  }
}
