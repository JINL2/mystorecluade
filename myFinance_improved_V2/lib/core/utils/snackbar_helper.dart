import 'package:flutter/material.dart';

import '../../../shared/themes/toss_colors.dart';
import '../../../shared/themes/toss_spacing.dart';
import '../../../shared/widgets/atoms/feedback/toss_loading_view.dart';
import '../constants/duration_constants.dart';

/// 공통 SnackBar 표시 유틸리티
///
/// 앱 전체에서 일관된 SnackBar UI를 제공합니다.
/// create_company_sheet.dart, create_store_sheet.dart 등에서 중복되는
/// SnackBar 로직을 이 헬퍼로 통합합니다.
class SnackBarHelper {
  SnackBarHelper._();

  /// 로딩 상태 SnackBar 표시
  ///
  /// [context] BuildContext
  /// [message] 표시할 메시지 (예: 'Creating company...')
  static void showLoading(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const TossLoadingView.inline(size: 20, color: TossColors.white),
            const SizedBox(width: TossSpacing.space3),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: DurationConstants.snackBarLoading,
      ),
    );
  }

  /// 에러 SnackBar 표시
  ///
  /// [context] BuildContext
  /// [message] 에러 메시지
  /// [onRetry] 재시도 콜백 (옵션)
  static void showError(
    BuildContext context,
    String message, {
    VoidCallback? onRetry,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: TossColors.white),
            const SizedBox(width: TossSpacing.space3),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: TossColors.error,
        duration: DurationConstants.snackBarError,
        action: onRetry != null
            ? SnackBarAction(
                label: 'Retry',
                textColor: TossColors.white,
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }

  /// 성공 SnackBar 표시
  ///
  /// [context] BuildContext
  /// [message] 성공 메시지
  /// [action] 추가 액션 (예: 'Share Code')
  static void showSuccess(
    BuildContext context,
    String message, {
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: TossColors.white),
            const SizedBox(width: TossSpacing.space3),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: TossColors.success,
        duration: DurationConstants.snackBarSuccess,
        action: action,
      ),
    );
  }

  /// 정보 SnackBar 표시
  ///
  /// [context] BuildContext
  /// [message] 정보 메시지
  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: TossColors.white),
            const SizedBox(width: TossSpacing.space3),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: TossColors.primary,
        duration: DurationConstants.snackBarInfo,
      ),
    );
  }

  /// 현재 SnackBar 숨기기
  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  /// 현재 SnackBar 숨기고 새 SnackBar 표시
  ///
  /// 로딩 → 에러/성공 전환 시 사용
  static void hideAndShowError(
    BuildContext context,
    String message, {
    VoidCallback? onRetry,
  }) {
    hide(context);
    showError(context, message, onRetry: onRetry);
  }

  /// 현재 SnackBar 숨기고 성공 SnackBar 표시
  static void hideAndShowSuccess(
    BuildContext context,
    String message, {
    SnackBarAction? action,
  }) {
    hide(context);
    showSuccess(context, message, action: action);
  }
}
