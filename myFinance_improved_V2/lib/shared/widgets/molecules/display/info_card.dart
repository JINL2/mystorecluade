import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// 배경이 있는 정보 카드 위젯
///
/// 라벨-값 정보를 배경색과 함께 표시합니다.
/// PI, LC 등의 문서 정보 표시에 적합합니다.
///
/// ## 사용 예시
/// ```dart
/// // 기본 사용 (gray50 배경)
/// InfoCard(label: 'PI Number', value: 'PI-2024-001')
///
/// // 커스텀 배경색
/// InfoCard(
///   label: 'Amount',
///   value: '₫5,000,000',
///   backgroundColor: TossColors.primarySurface,
/// )
///
/// // 후행 위젯 추가
/// InfoCard(
///   label: 'Status',
///   value: 'Pending',
///   trailing: TossBadge(label: 'New', backgroundColor: TossColors.primary),
/// )
/// ```
class InfoCard extends StatelessWidget {
  /// 라벨 텍스트
  final String label;

  /// 값 텍스트
  final String value;

  /// 배경색 (기본: gray50)
  final Color? backgroundColor;

  /// 내부 패딩
  final EdgeInsets padding;

  /// 테두리 반경
  final double borderRadius;

  /// 라벨 텍스트 스타일
  final TextStyle? labelStyle;

  /// 값 텍스트 스타일
  final TextStyle? valueStyle;

  /// 후행 위젯 (아이콘, 뱃지 등)
  final Widget? trailing;

  /// 클릭 콜백
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.label,
    required this.value,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(TossSpacing.space4),
    this.borderRadius = TossBorderRadius.lg,
    this.labelStyle,
    this.valueStyle,
    this.trailing,
    this.onTap,
  });

  /// 강조 스타일 (primarySurface 배경)
  factory InfoCard.highlight({
    Key? key,
    required String label,
    required String value,
    EdgeInsets padding = const EdgeInsets.all(TossSpacing.space4),
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InfoCard(
      key: key,
      label: label,
      value: value,
      backgroundColor: TossColors.primarySurface,
      padding: padding,
      trailing: trailing,
      onTap: onTap,
    );
  }

  /// 성공 스타일 (successLight 배경)
  factory InfoCard.success({
    Key? key,
    required String label,
    required String value,
    EdgeInsets padding = const EdgeInsets.all(TossSpacing.space4),
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InfoCard(
      key: key,
      label: label,
      value: value,
      backgroundColor: TossColors.successLight,
      padding: padding,
      trailing: trailing,
      onTap: onTap,
    );
  }

  /// 에러 스타일 (errorLight 배경)
  factory InfoCard.error({
    Key? key,
    required String label,
    required String value,
    EdgeInsets padding = const EdgeInsets.all(TossSpacing.space4),
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InfoCard(
      key: key,
      label: label,
      value: value,
      backgroundColor: TossColors.errorLight,
      padding: padding,
      trailing: trailing,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? TossColors.gray50,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Label
                Text(
                  label,
                  style: labelStyle ??
                      TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                ),
                const SizedBox(height: TossSpacing.space1),
                // Value
                Text(
                  value,
                  style: valueStyle ??
                      TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: TossSpacing.space3),
            trailing!,
          ],
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }
}
