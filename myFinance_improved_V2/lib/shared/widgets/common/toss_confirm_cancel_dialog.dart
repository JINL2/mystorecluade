import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';

/// Confirm/Cancel Dialog - 사용자에게 작업 확인을 요청하는 다이얼로그
///
/// 기본 디자인 구조 (Auto Mapping 스타일):
/// - Dialog 위젯 사용 (AlertDialog 대신)
/// - 제목: 18sp, 굵게, 중앙 정렬
/// - 메시지: 15sp, 중앙 정렬, line height 1.5
/// - 커스텀 컨텐츠: 메시지 아래 표시 (예: Difference Amount)
/// - 버튼: 가로 배치, 좌측 Cancel (테두리), 우측 OK (색상 버튼)
/// - 모든 요소는 변수로 커스터마이징 가능
///
/// 주요 사용 사례:
/// - Auto Mapping 확인 (Exchange Rate Differences, Error)
/// - 삭제 확인 (Delete Account, Delete Item 등)
/// - 중요한 작업 확인 (Submit, Publish 등)
/// - 변경 사항 저장 확인
class TossConfirmCancelDialog extends StatelessWidget {
  /// 다이얼로그 제목 (기본: 18sp, 굵게, 중앙 정렬)
  final String title;

  /// 다이얼로그 메시지 (기본: 15sp, 중앙 정렬, line height 1.5)
  final String? message;

  /// 확인 버튼 텍스트 (기본값: 'OK')
  final String confirmButtonText;

  /// 취소 버튼 텍스트 (기본값: 'Cancel')
  final String cancelButtonText;

  /// 확인 버튼 클릭 시 콜백
  final VoidCallback? onConfirm;

  /// 취소 버튼 클릭 시 콜백
  final VoidCallback? onCancel;

  /// 위험한 작업 여부 (true일 경우 확인 버튼이 빨간색)
  final bool isDangerousAction;

  /// 확인 버튼 배경색 (커스텀, 기본: primary 또는 error)
  final Color? confirmButtonColor;

  /// 취소 버튼 테두리 색상 (커스텀, 기본: gray300)
  final Color? cancelButtonBorderColor;

  /// 확인 버튼 텍스트 색상 (커스텀, 기본: white)
  final Color? confirmButtonTextColor;

  /// 취소 버튼 텍스트 색상 (커스텀, 기본: gray700)
  final Color? cancelButtonTextColor;

  /// 제목 텍스트 스타일 (커스텀, 기본: h3, 18sp, 굵게)
  final TextStyle? titleStyle;

  /// 메시지 텍스트 스타일 (커스텀, 기본: body, 15sp, line height 1.5)
  final TextStyle? messageStyle;

  /// 제목 텍스트 정렬 (기본: center)
  final TextAlign titleAlign;

  /// 메시지 텍스트 정렬 (기본: center)
  final TextAlign messageAlign;

  /// 다이얼로그 배경색 (기본: white)
  final Color backgroundColor;

  /// 다이얼로그 모서리 둥글기 (기본: TossBorderRadius.lg)
  final double? borderRadius;

  /// 커스텀 위젯 (메시지 아래에 표시, 예: Difference Amount)
  final Widget? customContent;

  /// 다이얼로그를 닫을 수 있는지 여부
  final bool barrierDismissible;

  /// 다이얼로그 패딩 (기본: all space5)
  final EdgeInsets? contentPadding;

  /// 버튼 세로 패딩 (기본: space3)
  final double? buttonVerticalPadding;

  const TossConfirmCancelDialog({
    super.key,
    required this.title,
    this.message,
    this.confirmButtonText = 'OK',
    this.cancelButtonText = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.isDangerousAction = false,
    this.confirmButtonColor,
    this.cancelButtonBorderColor,
    this.confirmButtonTextColor,
    this.cancelButtonTextColor,
    this.titleStyle,
    this.messageStyle,
    this.titleAlign = TextAlign.center,
    this.messageAlign = TextAlign.center,
    this.backgroundColor = TossColors.white,
    this.borderRadius,
    this.customContent,
    this.barrierDismissible = true,
    this.contentPadding,
    this.buttonVerticalPadding,
  });

  /// Factory constructor for delete confirmation
  factory TossConfirmCancelDialog.delete({
    required String title,
    String? message,
    String confirmButtonText = 'Delete',
    String cancelButtonText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return TossConfirmCancelDialog(
      title: title,
      message: message ?? 'Are you sure you want to delete this? This action cannot be undone.',
      confirmButtonText: confirmButtonText,
      cancelButtonText: cancelButtonText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      isDangerousAction: true,
    );
  }

  /// Factory constructor for save confirmation
  factory TossConfirmCancelDialog.save({
    required String title,
    String? message,
    String confirmButtonText = 'Save',
    String cancelButtonText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return TossConfirmCancelDialog(
      title: title,
      message: message ?? 'Do you want to save your changes?',
      confirmButtonText: confirmButtonText,
      cancelButtonText: cancelButtonText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      isDangerousAction: false,
    );
  }

  /// Factory constructor for discard confirmation
  factory TossConfirmCancelDialog.discard({
    required String title,
    String? message,
    String confirmButtonText = 'Discard',
    String cancelButtonText = 'Keep',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return TossConfirmCancelDialog(
      title: title,
      message: message ?? 'Are you sure you want to discard your changes?',
      confirmButtonText: confirmButtonText,
      cancelButtonText: cancelButtonText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      isDangerousAction: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 기본 디자인 구조 (Auto Mapping 스타일):
    // - Dialog 위젯 사용
    // - Container로 감싸서 패딩과 스타일 적용
    // - Column으로 제목, 메시지, 커스텀 컨텐츠, 버튼 배치
    // - 버튼은 Row로 가로 배치 (Cancel 좌측, OK 우측)

    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? TossBorderRadius.lg),
      ),
      child: Container(
        padding: contentPadding ?? EdgeInsets.all(TossSpacing.space5),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius ?? TossBorderRadius.lg),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title - 기본: 18sp, 굵게, 중앙 정렬
            Text(
              title,
              style: titleStyle ?? TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              textAlign: titleAlign,
            ),

            if (message != null) ...[
              SizedBox(height: TossSpacing.space5),

              // Message - 기본: 15sp, 중앙 정렬, line height 1.5
              Text(
                message!,
                style: messageStyle ?? TossTextStyles.body.copyWith(
                  fontSize: 15,
                  height: 1.5,
                  color: TossColors.black87,
                ),
                textAlign: messageAlign,
              ),
            ],

            // Custom Content (예: Difference Amount)
            if (customContent != null) ...[
              SizedBox(height: TossSpacing.space4),
              customContent!,
            ],

            SizedBox(height: TossSpacing.space5),

            // Buttons - 가로 배치
            Row(
              children: [
                // Cancel Button - 테두리 스타일
                Expanded(
                  child: TextButton(
                    onPressed: onCancel ?? () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: buttonVerticalPadding ?? TossSpacing.space3,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        side: BorderSide(
                          color: cancelButtonBorderColor ?? TossColors.gray300,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      cancelButtonText,
                      style: TossTextStyles.body.copyWith(
                        color: cancelButtonTextColor ?? TossColors.gray700,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: TossSpacing.space3),

                // Confirm Button - 색상 버튼 (기본: primary, 위험한 작업: error)
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm ?? () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmButtonColor ?? (isDangerousAction ? TossColors.error : Theme.of(context).colorScheme.primary),
                      foregroundColor: confirmButtonTextColor ?? TossColors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: buttonVerticalPadding ?? TossSpacing.space3,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      confirmButtonText,
                      style: TossTextStyles.body.copyWith(
                        color: confirmButtonTextColor ?? TossColors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Show confirm/cancel dialog
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    String? message,
    String confirmButtonText = 'OK',
    String cancelButtonText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDangerousAction = false,
    Color? confirmButtonColor,
    Color? cancelButtonBorderColor,
    Widget? customContent,
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => TossConfirmCancelDialog(
        title: title,
        message: message,
        confirmButtonText: confirmButtonText,
        cancelButtonText: cancelButtonText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDangerousAction: isDangerousAction,
        confirmButtonColor: confirmButtonColor,
        cancelButtonBorderColor: cancelButtonBorderColor,
        customContent: customContent,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  /// Show delete confirmation dialog
  static Future<bool?> showDelete({
    required BuildContext context,
    required String title,
    String? message,
    String confirmButtonText = 'Delete',
    String cancelButtonText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => TossConfirmCancelDialog.delete(
        title: title,
        message: message,
        confirmButtonText: confirmButtonText,
        cancelButtonText: cancelButtonText,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  /// Show save confirmation dialog
  static Future<bool?> showSave({
    required BuildContext context,
    required String title,
    String? message,
    String confirmButtonText = 'Save',
    String cancelButtonText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => TossConfirmCancelDialog.save(
        title: title,
        message: message,
        confirmButtonText: confirmButtonText,
        cancelButtonText: cancelButtonText,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  /// Show discard confirmation dialog
  static Future<bool?> showDiscard({
    required BuildContext context,
    required String title,
    String? message,
    String confirmButtonText = 'Discard',
    String cancelButtonText = 'Keep',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => TossConfirmCancelDialog.discard(
        title: title,
        message: message,
        confirmButtonText: confirmButtonText,
        cancelButtonText: cancelButtonText,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }
}
