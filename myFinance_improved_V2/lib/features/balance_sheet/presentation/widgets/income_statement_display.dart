import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_spacing.dart';
import 'income_statement_display/income_statement_display_widgets.dart';

/// Income Statement Display Widget
/// Refactored: 595 lines → ~60 lines
class IncomeStatementDisplay extends StatelessWidget {
  final Map<String, dynamic> incomeStatementData;
  final String currencySymbol;
  final VoidCallback onEdit;

  const IncomeStatementDisplay({
    super.key,
    required this.incomeStatementData,
    required this.currencySymbol,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final data = incomeStatementData['data'] as List<dynamic>;
    final parameters =
        incomeStatementData['parameters'] as Map<String, dynamic>;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Header with Date Range info
              IncomeHeaderCard(
                parameters: parameters,
                onEdit: onEdit,
              ),

              // Income Statement Content
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space4,
                ),
                child: Column(
                  children: [
                    // Key Metrics Summary
                    KeyMetricsSummary(
                      data: data,
                      currencySymbol: currencySymbol,
                    ),
                    const SizedBox(height: TossSpacing.space6),

                    // Income Statement Sections
                    ...data.map<Widget>(
                      (section) => IncomeSection(
                        section: section as Map<String, dynamic>,
                        currencySymbol: currencySymbol,
                      ),
                    ),

                    // Bottom padding
                    const SizedBox(height: TossSpacing.space8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
