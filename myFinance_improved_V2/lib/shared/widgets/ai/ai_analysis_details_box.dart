import 'package:flutter/material.dart';

import '../../themes/toss_animations.dart';
import '../../themes/toss_border_radius.dart';
import '../../themes/toss_colors.dart';
import '../../themes/toss_spacing.dart';
import '../../themes/toss_text_styles.dart';

/// AI analysis details box for attachment OCR results (collapsible)
///
/// Displays AI-analyzed OCR text from attachments in a numbered list.
/// Initially collapsed, tap to expand.
///
/// Example:
/// ```dart
/// if (attachments.any((a) => a.hasOcr))
///   AiAnalysisDetailsBox(
///     items: attachments
///       .where((a) => a.hasOcr)
///       .map((a) => a.ocrText!)
///       .toList(),
///   ),
/// ```
class AiAnalysisDetailsBox extends StatefulWidget {
  /// List of OCR text items to display
  final List<String> items;

  /// Optional title (default: 'AI Analysis Details')
  final String? title;

  /// Optional icon to display before the title
  final IconData icon;

  /// Initially expanded (default: false)
  final bool initiallyExpanded;

  const AiAnalysisDetailsBox({
    super.key,
    required this.items,
    this.title,
    this.icon = Icons.auto_awesome,
    this.initiallyExpanded = false,
  });

  @override
  State<AiAnalysisDetailsBox> createState() => _AiAnalysisDetailsBoxState();
}

class _AiAnalysisDetailsBoxState extends State<AiAnalysisDetailsBox> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    final displayTitle = widget.title ?? 'AI Analysis Details';

    return Container(
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header (tappable)
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            child: Padding(
              padding: const EdgeInsets.all(TossSpacing.space3),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    size: 14,
                    color: Colors.amber.shade700,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      '$displayTitle (${widget.items.length})',
                      style: TossTextStyles.caption.copyWith(
                        color: Colors.amber.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 18,
                    color: Colors.amber.shade600,
                  ),
                ],
              ),
            ),
          ),
          // Expandable content
          AnimatedCrossFade(
            duration: TossAnimations.normal,
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        TossSpacing.space3,
        0,
        TossSpacing.space3,
        TossSpacing.space3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            color: Colors.amber.shade200,
          ),
          const SizedBox(height: TossSpacing.space2),
          ...widget.items.asMap().entries.map((entry) {
            final index = entry.key;
            final text = entry.value;
            return _buildOcrItem(
              index,
              text,
              isLast: index == widget.items.length - 1,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOcrItem(int index, String text, {required bool isLast}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : TossSpacing.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number badge
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(TossBorderRadius.full),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TossTextStyles.caption.copyWith(
                  color: Colors.amber.shade800,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          // OCR text
          Expanded(
            child: Text(
              text,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
