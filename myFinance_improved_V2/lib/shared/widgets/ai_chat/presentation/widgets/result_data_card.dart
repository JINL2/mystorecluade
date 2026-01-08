import 'package:flutter/material.dart';

import '../../../../themes/toss_animations.dart';
import '../../../../themes/toss_border_radius.dart';
import '../../../../themes/toss_colors.dart';
import '../../../../themes/toss_spacing.dart';
import '../../../../themes/toss_text_styles.dart';

/// Collapsible card widget to display SQL query results
/// Shows a compact preview by default, expandable to see all data
class ResultDataCard extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final bool isLoading;

  const ResultDataCard({
    super.key,
    required this.data,
    this.isLoading = false,
  });

  @override
  State<ResultDataCard> createState() => _ResultDataCardState();
}

class _ResultDataCardState extends State<ResultDataCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: TossAnimations.normal,
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: TossAnimations.standard,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty && !widget.isLoading) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header - Always visible, tappable to expand/collapse
          InkWell(
            onTap: widget.data.isNotEmpty ? _toggleExpand : null,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space2 + 2,
              ),
              child: Row(
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space1),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                    ),
                    child: Icon(
                      Icons.dataset_outlined,
                      size: TossSpacing.iconXS,
                      color: TossColors.primary.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space2),

                  // Title & count
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'Data',
                          style: TossTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: TossColors.textPrimary,
                            fontSize: 12,
                          ),
                        ),
                        if (widget.data.isNotEmpty) ...[
                          const SizedBox(width: TossSpacing.space1),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: TossColors.primary,
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            ),
                            child: Text(
                              '${widget.data.length}',
                              style: TossTextStyles.caption.copyWith(
                                fontWeight: FontWeight.w600,
                                color: TossColors.white,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Loading indicator or expand icon
                  if (widget.isLoading)
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          TossColors.primary.withValues(alpha: 0.6),
                        ),
                      ),
                    )
                  else if (widget.data.isNotEmpty)
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: TossAnimations.normal,
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: TossSpacing.iconSM,
                        color: TossColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Expandable content
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              children: [
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(TossSpacing.space3),
                    child: Column(
                      children: widget.data.asMap().entries.map((entry) {
                        final index = entry.key;
                        final row = entry.value;
                        return _buildDataRow(index, row);
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(int index, Map<String, dynamic> row) {
    return Container(
      margin: EdgeInsets.only(top: index > 0 ? TossSpacing.space2 : 0),
      padding: const EdgeInsets.all(TossSpacing.space2),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.data.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: TossSpacing.space1),
              child: Text(
                '#${index + 1}',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          ...row.entries.map((e) => _buildKeyValue(e.key, e.value)),
        ],
      ),
    );
  }

  Widget _buildKeyValue(String key, dynamic value) {
    final displayKey = _formatKey(key);
    final displayValue = _formatValue(value);

    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space1 / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              displayKey,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            child: Text(
              displayValue,
              style: TossTextStyles.caption.copyWith(
                fontWeight: FontWeight.w500,
                color: TossColors.textPrimary,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatKey(String key) {
    return key
        .split('_')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1)}'
              : word,
        )
        .join(' ');
  }

  String _formatValue(dynamic value) {
    if (value == null) return '-';
    if (value is num) return _formatNumber(value);
    return value.toString();
  }

  String _formatNumber(num value) {
    if (value is int) {
      return value.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    } else {
      return value.toStringAsFixed(2).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    }
  }
}
