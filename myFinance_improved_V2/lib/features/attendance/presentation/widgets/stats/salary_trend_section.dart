import 'package:flutter/material.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_white_card.dart';

/// Salary trend chart section with interactive line graph
class SalaryTrendSection extends StatefulWidget {
  final List<double> weeklyData; // Salary data for each week
  final List<String> weekLabels;
  final String footerNote;
  final String Function(double)? valueFormatter; // Format value to display

  const SalaryTrendSection({
    super.key,
    required this.weeklyData,
    this.weekLabels = const ['W1', 'W2', 'W3', 'W4', 'W5'],
    required this.footerNote,
    this.valueFormatter,
  });

  @override
  State<SalaryTrendSection> createState() => _SalaryTrendSectionState();
}

class _SalaryTrendSectionState extends State<SalaryTrendSection> {
  int? _selectedIndex;

  String _formatValue(double value) {
    if (widget.valueFormatter != null) {
      return widget.valueFormatter!(value);
    }
    // Default formatter
    return '${value.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        )}đ';
  }

  @override
  Widget build(BuildContext context) {
    // Get selected or last value
    final displayValue = _selectedIndex != null
        ? widget.weeklyData[_selectedIndex!]
        : widget.weeklyData.last;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          'Salary Trend (Last 5 Weeks)',
          style: TossTextStyles.bodyMedium.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: TossColors.gray900,
          ),
        ),

        const SizedBox(height: 12),

        // Chart card
        TossWhiteCard(
          padding: const EdgeInsets.all(10),
          showBorder: false,
          child: Column(
            children: [
              // Chart area with gesture detector
              SizedBox(
                height: 100,
                child: GestureDetector(
                  onTapDown: (details) {
                    _handleTap(details.localPosition);
                  },
                  onPanUpdate: (details) {
                    _handleTap(details.localPosition);
                  },
                  onPanEnd: (_) {
                    // Optionally clear selection after drag ends
                    // setState(() => _selectedIndex = null);
                  },
                  child: CustomPaint(
                    painter: _TrendLinePainter(
                      weeklyData: widget.weeklyData,
                      selectedIndex: _selectedIndex,
                      selectedValue: _formatValue(displayValue),
                    ),
                    child: Container(),
                  ),
                ),
              ),

              const SizedBox(height: 2),

              // Week labels
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(widget.weekLabels.length, (index) {
                    final isSelected = _selectedIndex == index;
                    return Text(
                      widget.weekLabels[index],
                      style: TossTextStyles.caption.copyWith(
                        fontSize: 10,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? TossColors.primary : TossColors.gray600,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Footer note
        Text(
          widget.footerNote,
          style: TossTextStyles.caption.copyWith(
            fontSize: 11,
            color: TossColors.gray600,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  void _handleTap(Offset position) {
    // Calculate which data point was tapped
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    // Get chart width (subtract card padding and horizontal padding)
    const cardPadding = 8.0;
    const horizontalPadding = 8.0;
    final chartWidth = box.size.width - (cardPadding * 2) - (horizontalPadding * 2);
    final stepX = chartWidth / (widget.weeklyData.length - 1);

    // Find nearest data point
    int nearestIndex = 0;
    double minDistance = double.infinity;

    for (int i = 0; i < widget.weeklyData.length; i++) {
      final pointX = cardPadding + horizontalPadding + (i * stepX);
      final distance = (position.dx - pointX).abs();

      if (distance < minDistance) {
        minDistance = distance;
        nearestIndex = i;
      }
    }

    setState(() {
      _selectedIndex = nearestIndex;
    });
  }
}

/// Custom painter for interactive trend line chart
class _TrendLinePainter extends CustomPainter {
  final List<double> weeklyData;
  final int? selectedIndex;
  final String selectedValue;

  _TrendLinePainter({
    required this.weeklyData,
    this.selectedIndex,
    required this.selectedValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (weeklyData.isEmpty) return;

    // Add horizontal padding to prevent label cutoff
    const horizontalPadding = 8.0;
    final chartWidth = size.width - (horizontalPadding * 2);

    // Normalize data to 0-1 range
    final minValue = weeklyData.reduce((a, b) => a < b ? a : b);
    final maxValue = weeklyData.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue;

    List<double> normalizedData = weeklyData.map((value) {
      if (range == 0) return 0.5; // All values same, center them
      return 0.2 + ((value - minValue) / range) * 0.6; // Use 20-80% of height
    }).toList();

    // Grid lines
    final gridPaint = Paint()
      ..color = TossColors.gray100
      ..strokeWidth = 1;

    // Draw 3 horizontal grid lines
    for (int i = 1; i <= 3; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(
        Offset(horizontalPadding, y),
        Offset(size.width - horizontalPadding, y),
        gridPaint,
      );
    }

    // Line paint
    final linePaint = Paint()
      ..color = TossColors.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Build path
    final path = Path();
    final stepX = chartWidth / (weeklyData.length - 1);

    for (int i = 0; i < normalizedData.length; i++) {
      final x = horizontalPadding + (i * stepX);
      final y = size.height - (normalizedData[i] * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Draw line
    canvas.drawPath(path, linePaint);

    // Draw data points
    final pointPaint = Paint()
      ..color = TossColors.primary
      ..style = PaintingStyle.fill;

    for (int i = 0; i < normalizedData.length; i++) {
      final x = horizontalPadding + (i * stepX);
      final y = size.height - (normalizedData[i] * size.height);

      // Draw point (larger if selected)
      final isSelected = selectedIndex == i;
      canvas.drawCircle(
        Offset(x, y),
        isSelected ? 5 : 3,
        pointPaint,
      );

      // Draw white inner circle for selected point
      if (isSelected) {
        canvas.drawCircle(
          Offset(x, y),
          3,
          Paint()
            ..color = TossColors.white
            ..style = PaintingStyle.fill,
        );
      }
    }

    // Draw value label above selected point (or last point by default)
    final displayIndex = selectedIndex ?? (weeklyData.length - 1);
    final selectedX = horizontalPadding + (displayIndex * stepX);
    final selectedY = size.height - (normalizedData[displayIndex] * size.height);

    final textPainter = TextPainter(
      text: TextSpan(
        text: selectedValue,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: TossColors.gray900,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Position label above the dot (centered horizontally)
    var labelX = selectedX - (textPainter.width / 2);
    final labelY = selectedY - textPainter.height - 8; // 8px above the dot

    // Add extra padding for label bounds
    const labelPadding = 4.0;
    final labelWidth = textPainter.width + 8; // including background padding

    // Keep label within bounds (don't overflow edges)
    final minX = horizontalPadding + labelPadding;
    final maxX = size.width - horizontalPadding - labelWidth - labelPadding;

    // Clamp label position to stay within bounds
    labelX = labelX.clamp(minX, maxX);

    // Draw background for label
    final labelBgPaint = Paint()
      ..color = TossColors.white
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          labelX - 4,
          labelY - 2,
          textPainter.width + 8,
          textPainter.height + 4,
        ),
        const Radius.circular(4),
      ),
      labelBgPaint,
    );

    // Draw text
    textPainter.paint(canvas, Offset(labelX, labelY));

    // Draw vertical highlight line at selected point
    if (selectedIndex != null) {
      final highlightPaint = Paint()
        ..color = TossColors.gray200
        ..strokeWidth = 1;

      canvas.drawLine(
        Offset(selectedX, selectedY + 8),
        Offset(selectedX, size.height - 8),
        highlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TrendLinePainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.weeklyData != weeklyData;
  }
}
