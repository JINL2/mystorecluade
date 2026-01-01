import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Label-Value 정보 행 표시 위젯
///
/// 프로젝트 전체에서 175회 이상 사용되는 `_buildInfoRow`, `_buildDetailRow` 패턴을 통합합니다.
///
/// ## 사용 예시
/// ```dart
/// // 고정 라벨 너비 (가장 흔한 패턴)
/// InfoRow.fixed(label: 'Name', value: 'John Doe')
/// InfoRow.fixed(label: 'Email', value: 'john@example.com', labelWidth: 100)
///
/// // 양쪽 정렬 (spaceBetween) - 금액 표시에 적합
/// InfoRow.between(label: 'Total', value: '₫1,234,000')
///
/// // 변경값 표시 (취소선 + 새 값)
/// InfoRow.between(
///   label: 'Base Pay',
///   value: '₫500,000',
///   originalValue: '₫450,000',
/// )
/// ```
class InfoRow extends StatelessWidget {
  /// 라벨 텍스트
  final String label;

  /// 값 텍스트
  final String value;

  /// 원래 값 (변경 전 값 - 취소선으로 표시)
  final String? originalValue;

  /// 라벨 고정 너비 (null = spaceBetween 레이아웃)
  final double? labelWidth;

  /// 수직 정렬
  final CrossAxisAlignment crossAxisAlignment;

  /// 라벨 텍스트 스타일
  final TextStyle? labelStyle;

  /// 값 텍스트 스타일
  final TextStyle? valueStyle;

  /// 값 텍스트 색상 (valueStyle보다 우선)
  final Color? valueColor;

  /// 빈 값일 때 이탤릭 + gray 스타일 적용
  final bool showEmptyStyle;

  /// 합계/강조 행 여부 (굵은 스타일 적용)
  final bool isTotal;

  /// 행 패딩
  final EdgeInsets padding;

  /// 후행 위젯 (아이콘, 버튼 등)
  final Widget? trailing;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.originalValue,
    this.labelWidth,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.labelStyle,
    this.valueStyle,
    this.valueColor,
    this.showEmptyStyle = false,
    this.isTotal = false,
    this.padding = EdgeInsets.zero,
    this.trailing,
  });

  /// 고정 라벨 너비 패턴 (기본 80px)
  ///
  /// ```dart
  /// InfoRow.fixed(label: 'Name', value: 'John Doe')
  /// InfoRow.fixed(label: 'Status', value: 'Active', labelWidth: 100)
  /// ```
  factory InfoRow.fixed({
    Key? key,
    required String label,
    required String value,
    double labelWidth = 80,
    Color? valueColor,
    bool showEmptyStyle = false,
    EdgeInsets padding = EdgeInsets.zero,
    Widget? trailing,
  }) {
    return InfoRow(
      key: key,
      label: label,
      value: value,
      labelWidth: labelWidth,
      valueColor: valueColor,
      showEmptyStyle: showEmptyStyle,
      padding: padding,
      trailing: trailing,
    );
  }

  /// SpaceBetween 정렬 패턴 (금액, 요약 정보에 적합)
  ///
  /// ```dart
  /// InfoRow.between(label: 'Total', value: '₫1,234,000')
  /// InfoRow.between(
  ///   label: 'Base Pay',
  ///   value: '₫500,000',
  ///   originalValue: '₫450,000', // 취소선으로 표시
  /// )
  /// ```
  factory InfoRow.between({
    Key? key,
    required String label,
    required String value,
    String? originalValue,
    TextStyle? labelStyle,
    TextStyle? valueStyle,
    Color? valueColor,
    bool isTotal = false,
    EdgeInsets padding = EdgeInsets.zero,
    Widget? trailing,
  }) {
    return InfoRow(
      key: key,
      label: label,
      value: value,
      originalValue: originalValue,
      labelWidth: null, // triggers spaceBetween
      labelStyle: labelStyle,
      valueStyle: valueStyle,
      valueColor: valueColor,
      isTotal: isTotal,
      padding: padding,
      trailing: trailing,
    );
  }

  bool get _hasChange => originalValue != null;

  bool get _isEmpty => value.isEmpty || value == '-' || value == 'N/A';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: labelWidth != null
            ? MainAxisAlignment.start
            : MainAxisAlignment.spaceBetween,
        children: [
          // Label
          if (labelWidth != null)
            SizedBox(
              width: labelWidth,
              child: _buildLabel(),
            )
          else
            _buildLabel(),

          // Value with optional trailing
          if (labelWidth != null)
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildValue()),
                  if (trailing != null) ...[
                    const SizedBox(width: TossSpacing.space2),
                    trailing!,
                  ],
                ],
              ),
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildValue(),
                if (trailing != null) ...[
                  const SizedBox(width: TossSpacing.space2),
                  trailing!,
                ],
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildLabel() {
    final style = labelStyle ??
        (isTotal
            ? TossTextStyles.bodyMedium.copyWith(color: TossColors.gray900)
            : TossTextStyles.body.copyWith(color: TossColors.gray600));

    return Text(label, style: style);
  }

  Widget _buildValue() {
    // Empty style handling
    if (showEmptyStyle && _isEmpty) {
      return Text(
        value.isEmpty ? '-' : value,
        style: TossTextStyles.body.copyWith(
          color: TossColors.gray400,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    // Change display (original → new)
    if (_hasChange) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Original value (strikethrough)
          Text(
            originalValue!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray400,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          // New value (primary color)
          Text(
            value,
            style: _getValueStyle().copyWith(
              color: valueColor ?? TossColors.primary,
            ),
          ),
        ],
      );
    }

    // Normal value display
    return Text(
      value,
      style: _getValueStyle(),
    );
  }

  TextStyle _getValueStyle() {
    if (valueStyle != null) return valueStyle!;

    final baseStyle = isTotal
        ? TossTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700)
        : TossTextStyles.body.copyWith(fontWeight: FontWeight.w600);

    return baseStyle.copyWith(
      color: valueColor ??
          (isTotal ? TossColors.primary : TossColors.gray900),
    );
  }
}
