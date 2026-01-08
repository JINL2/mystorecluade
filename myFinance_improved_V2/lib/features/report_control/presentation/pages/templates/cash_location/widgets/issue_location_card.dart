// lib/features/report_control/presentation/pages/templates/cash_location/widgets/issue_location_card.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/index.dart';
import '../domain/entities/cash_location_report.dart';

/// Issue Location Card
///
/// Minimalist Toss-style design:
/// - All icons are GRAY (no colored icons)
/// - Color only used for: difference amount + issue badge
/// - White-dominant, clean, modern UI
class IssueLocationCard extends StatelessWidget {
  final CashLocationIssue issue;

  const IssueLocationCard({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space2),
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.buttonLarge),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Location name + type badge
          Row(
            children: [
              _buildLocationIcon(),
              SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Text(
                  issue.locationName,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: TossFontWeight.semibold,
                    color: TossColors.gray900,
                  ),
                ),
              ),
              _buildTypeBadge(),
            ],
          ),

          SizedBox(height: TossSpacing.space2_5),

          // Amounts row
          _buildAmountsRow(),

          // Last entry info (if available)
          if (issue.lastEntry != null) ...[
            SizedBox(height: TossSpacing.space2_5),
            _buildLastEntryInfo(),
          ],
        ],
      ),
    );
  }

  /// Location icon - ALL GRAY (no colors)
  Widget _buildLocationIcon() {
    IconData icon;

    switch (issue.locationType.toLowerCase()) {
      case 'vault':
        icon = LucideIcons.lock;
        break;
      case 'bank':
        icon = LucideIcons.landmark;
        break;
      case 'cash':
      default:
        icon = LucideIcons.wallet;
        break;
    }

    // Gray icon - no color variation
    return Container(
      width: TossDimensions.avatarSM,
      height: TossDimensions.avatarSM,
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Icon(icon, size: TossSpacing.iconXS, color: TossColors.gray600),
    );
  }

  /// Issue badge - ONLY place with color (besides difference)
  Widget _buildTypeBadge() {
    final isShortage = issue.issueType != 'surplus';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.badgePaddingHorizontalXS, vertical: TossSpacing.badgePaddingVerticalXS),
      decoration: BoxDecoration(
        color: isShortage ? TossColors.errorLight : TossColors.warningLight,
        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
      ),
      child: Text(
        isShortage ? 'Shortage' : 'Surplus',
        style: TossTextStyles.labelSmall.copyWith(
          fontWeight: TossFontWeight.semibold,
          color: isShortage ? TossColors.error : TossColors.warning,
        ),
      ),
    );
  }

  Widget _buildAmountsRow() {
    // Only difference has color
    final isShortage = issue.issueType != 'surplus';
    final diffColor = isShortage ? TossColors.error : TossColors.warning;

    return Row(
      children: [
        // Book - gray text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Book',
                style: TossTextStyles.labelSmall.copyWith(
                  color: TossColors.gray500,
                ),
              ),
              SizedBox(height: TossSpacing.space0_5),
              Text(
                issue.bookFormatted,
                style: TossTextStyles.bodySmall.copyWith(
                  fontWeight: TossFontWeight.medium,
                  color: TossColors.gray700,
                ),
              ),
            ],
          ),
        ),
        // Actual - gray text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Actual',
                style: TossTextStyles.labelSmall.copyWith(
                  color: TossColors.gray500,
                ),
              ),
              SizedBox(height: TossSpacing.space0_5),
              Text(
                issue.actualFormatted,
                style: TossTextStyles.bodySmall.copyWith(
                  fontWeight: TossFontWeight.medium,
                  color: TossColors.gray700,
                ),
              ),
            ],
          ),
        ),
        // Difference - COLORED (the main indicator)
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Diff',
              style: TossTextStyles.labelSmall.copyWith(
                color: TossColors.gray500,
              ),
            ),
            SizedBox(height: TossSpacing.space0_5),
            Text(
              issue.differenceFormatted,
              style: TossTextStyles.bodySmall.copyWith(
                fontWeight: TossFontWeight.semibold,
                color: diffColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLastEntryInfo() {
    final entry = issue.lastEntry!;

    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - gray
          Row(
            children: [
              Icon(
                LucideIcons.history,
                size: TossSpacing.iconXS2,
                color: TossColors.gray500,
              ),
              SizedBox(width: TossSpacing.space1),
              Text(
                'Last Entry',
                style: TossTextStyles.labelSmall.copyWith(
                  fontWeight: TossFontWeight.medium,
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space2),

          // Employee info - all gray
          Row(
            children: [
              // Employee avatar - GRAY
              Container(
                width: TossDimensions.avatarXS,
                height: TossDimensions.avatarXS,
                decoration: BoxDecoration(
                  color: TossColors.gray200,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    entry.employeeName.isNotEmpty
                        ? entry.employeeName[0].toUpperCase()
                        : '?',
                    style: TossTextStyles.labelSmall.copyWith(
                      fontWeight: TossFontWeight.semibold,
                      color: TossColors.gray600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.employeeName,
                      style: TossTextStyles.bodySmall.copyWith(
                        fontWeight: TossFontWeight.semibold,
                        color: TossColors.gray800,
                      ),
                    ),
                    Text(
                      '${entry.entryDate} • ${entry.entryTime}',
                      style: TossTextStyles.labelSmall.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
              // Amount - gray (not colored)
              Text(
                entry.formattedAmount,
                style: TossTextStyles.bodySmall.copyWith(
                  fontWeight: TossFontWeight.medium,
                  color: TossColors.gray700,
                ),
              ),
            ],
          ),

          // Description
          if (entry.description != null && entry.description!.isNotEmpty) ...[
            SizedBox(height: TossSpacing.space1_5),
            Text(
              entry.description!,
              style: TossTextStyles.labelSmall.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
