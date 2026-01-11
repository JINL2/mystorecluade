import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_card.dart';

import '../../../domain/entities/bcg_category.dart';
import '../bcg_matrix/index.dart';

/// BCG Matrix Section Widget for Sales Dashboard
/// Uses shared BCG components for visualization
class BcgMatrixSection extends StatefulWidget {
  final BcgMatrix bcgMatrix;

  const BcgMatrixSection({
    super.key,
    required this.bcgMatrix,
  });

  @override
  State<BcgMatrixSection> createState() => _BcgMatrixSectionState();
}

class _BcgMatrixSectionState extends State<BcgMatrixSection> {
  bool _useMean = false;

  @override
  Widget build(BuildContext context) {
    final chartData = BcgChartData.calculate(
      widget.bcgMatrix,
      useMean: _useMean,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with toggle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BCG Matrix',
                      style: TossTextStyles.h4.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Sales Volume × Margin Rate',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
              // Mean/Median Toggle
              BcgMeanMedianToggle(
                useMean: _useMean,
                onChanged: (value) => setState(() => _useMean = value),
              ),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space3),

        // Chart Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          child: TossCard(
            child: BcgScatterChart(
              chartData: chartData,
              height: 300,
            ),
          ),
        ),
        const SizedBox(height: TossSpacing.space3),

        // Legend
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          child: BcgLegend(
            bcgMatrix: widget.bcgMatrix,
            counts: chartData.quadrantCounts,
          ),
        ),
      ],
    );
  }
}
