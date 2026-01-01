import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// 아이콘이 포함된 정보 행 위젯
///
/// 아이콘 + 라벨 + 값 형태의 정보를 표시합니다.
/// 히스토리 헤더, 상세 정보 섹션에 적합합니다.
///
/// ## 사용 예시
/// ```dart
/// // 기본 사용
/// IconInfoRow(
///   icon: Icons.store_outlined,
///   label: 'Store',
///   value: 'Main Branch',
/// )
///
/// // 커스텀 아이콘 색상
/// IconInfoRow(
///   icon: Icons.calendar_today,
///   label: 'Date',
///   value: '2024-01-15',
///   iconColor: TossColors.primary,
/// )
///
/// // 액션 버튼 포함
/// IconInfoRow(
///   icon: Icons.phone_outlined,
///   label: 'Phone',
///   value: '+84 123 456 789',
///   trailing: IconButton(
///     icon: Icon(Icons.copy),
///     onPressed: () => copyToClipboard(),
///   ),
/// )
/// ```
class IconInfoRow extends StatelessWidget {
  /// 아이콘
  final IconData icon;

  /// 라벨 텍스트
  final String label;

  /// 값 텍스트
  final String value;

  /// 아이콘 색상
  final Color? iconColor;

  /// 아이콘 크기
  final double iconSize;

  /// 라벨 텍스트 스타일
  final TextStyle? labelStyle;

  /// 값 텍스트 스타일
  final TextStyle? valueStyle;

  /// 후행 위젯 (버튼, 아이콘 등)
  final Widget? trailing;

  /// 행 패딩
  final EdgeInsets padding;

  /// 클릭 콜백
  final VoidCallback? onTap;

  const IconInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.iconSize = TossSpacing.iconMD,
    this.labelStyle,
    this.valueStyle,
    this.trailing,
    this.padding = EdgeInsets.zero,
    this.onTap,
  });

  /// 컴팩트 스타일 (작은 아이콘, 한 줄)
  factory IconInfoRow.compact({
    Key? key,
    required IconData icon,
    required String label,
    required String value,
    Color? iconColor,
    Widget? trailing,
    EdgeInsets padding = EdgeInsets.zero,
    VoidCallback? onTap,
  }) {
    return IconInfoRow(
      key: key,
      icon: icon,
      label: label,
      value: value,
      iconColor: iconColor,
      iconSize: TossSpacing.iconSM,
      trailing: trailing,
      padding: padding,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Icon(
            icon,
            size: iconSize,
            color: iconColor ?? TossColors.gray500,
          ),
          const SizedBox(width: TossSpacing.space3),

          // Label + Value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: labelStyle ??
                      TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                ),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  value,
                  style: valueStyle ??
                      TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),

          // Trailing
          if (trailing != null) trailing!,
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}
