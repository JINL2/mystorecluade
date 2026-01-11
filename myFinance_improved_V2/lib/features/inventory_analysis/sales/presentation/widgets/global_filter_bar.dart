import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../domain/entities/sales_analytics.dart';

/// Global Filter Bar Widget
/// Contains Store, TimeRange, and Metric filters at the top of the page
class GlobalFilterBar extends StatelessWidget {
  final TimeRange selectedTimeRange;
  final Metric selectedMetric;
  final ValueChanged<TimeRange> onTimeRangeChanged;
  final ValueChanged<Metric> onMetricChanged;

  const GlobalFilterBar({
    super.key,
    required this.selectedTimeRange,
    required this.selectedMetric,
    required this.onTimeRangeChanged,
    required this.onMetricChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(
          bottom: BorderSide(color: TossColors.gray200, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Range Chips
          _buildTimeRangeSelector(),
          const SizedBox(height: TossSpacing.space3),
          // Metric Toggle
          _buildMetricToggle(),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: TimeRange.values.where((r) => r != TimeRange.custom).map((range) {
          final isSelected = selectedTimeRange == range;
          return Padding(
            padding: const EdgeInsets.only(right: TossSpacing.space2),
            child: GestureDetector(
              onTap: () => onTimeRangeChanged(range),
              child: AnimatedContainer(
                duration: TossAnimations.fast,
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space3,
                  vertical: TossSpacing.space2,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? TossColors.primary : TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                ),
                child: Text(
                  range.label,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: isSelected ? TossColors.white : TossColors.gray700,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMetricToggle() {
    return Row(
      children: [
        Text(
          'Metric:',
          style: TossTextStyles.bodySmall.copyWith(
            color: TossColors.gray600,
          ),
        ),
        const SizedBox(width: TossSpacing.space3),
        Expanded(
          child: CupertinoSlidingSegmentedControl<Metric>(
            groupValue: selectedMetric,
            backgroundColor: TossColors.gray100,
            thumbColor: TossColors.white,
            children: const {
              Metric.revenue: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text('Revenue', style: TextStyle(fontSize: 13)),
              ),
              Metric.margin: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text('Margin', style: TextStyle(fontSize: 13)),
              ),
              Metric.quantity: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text('Quantity', style: TextStyle(fontSize: 13)),
              ),
            },
            onValueChanged: (value) {
              if (value != null) {
                onMetricChanged(value);
              }
            },
          ),
        ),
      ],
    );
  }
}
