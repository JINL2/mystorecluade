import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../themes/toss_border_radius.dart';
import '../../../themes/toss_colors.dart';
import '../../../themes/toss_spacing.dart';
import '../../atoms/layout/gray_divider_space.dart';

/// TossScheduleSkeleton - Attendance My Schedule 탭 전용 스켈레톤
///
/// 실제 UI 구조와 일치하는 스켈레톤:
/// 1. Today's Shift 카드 (큰 카드 + 버튼)
/// 2. Gray Divider
/// 3. Week Navigation + Week Dates Picker
/// 4. Shift List
class TossScheduleSkeleton extends StatelessWidget {
  final bool showStoreSelector;
  final bool enableShimmer;

  const TossScheduleSkeleton({
    super.key,
    this.showStoreSelector = false,
    this.enableShimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: enableShimmer,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: TossSpacing.space4),

            // Store Selector (optional)
            if (showStoreSelector) _buildStoreSelector(),

            // Section 1: Today's Shift Card (white background)
            _buildTodayShiftSection(),

            // Gray Divider
            const GrayDividerSpace(),

            // Section 2: Week Navigation + Calendar + Shifts
            _buildCalendarSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreSelector() {
    return Container(
      color: TossColors.white,
      padding: const EdgeInsets.fromLTRB(
        TossSpacing.space4,
        TossSpacing.space3,
        TossSpacing.space4,
        0,
      ),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
      ),
    );
  }

  Widget _buildTodayShiftSection() {
    return Container(
      color: TossColors.white,
      padding: const EdgeInsets.only(
        left: TossSpacing.space4,
        right: TossSpacing.space4,
        top: TossSpacing.space4,
        bottom: TossSpacing.space2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section label
          const Bone.text(words: 2),
          const SizedBox(height: TossSpacing.space3),

          // Today's Shift Card
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(color: TossColors.gray200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shift name + time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Bone.text(words: 2),
                    Bone.text(words: 2),
                  ],
                ),
                const SizedBox(height: TossSpacing.space2),

                // Status badge
                Container(
                  width: 80,
                  height: 24,
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.full),
                  ),
                ),
                const SizedBox(height: TossSpacing.space4),

                // Check-in button
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      color: TossColors.white,
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Week Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Arrow button
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                ),
              ),
              // Week label
              const Bone.text(words: 3),
              // Arrow button
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),

          // Week Dates Picker (7 circles)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) => _buildDateCircle()),
          ),
          const SizedBox(height: TossSpacing.space4),

          // "Shifts for" label
          const Bone.text(words: 4),
          const SizedBox(height: TossSpacing.space3),

          // Shift cards for selected date
          _buildShiftCard(),
          const SizedBox(height: TossSpacing.space2),
          _buildShiftCard(),
        ],
      ),
    );
  }

  Widget _buildDateCircle() {
    return Column(
      children: [
        // Day name
        Container(
          width: 24,
          height: 12,
          decoration: BoxDecoration(
            color: TossColors.gray100,
            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        // Date circle
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: TossColors.gray100,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildShiftCard() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray100),
      ),
      child: Row(
        children: [
          // Time column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 14,
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 40,
                height: 14,
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
            ],
          ),
          const SizedBox(width: TossSpacing.space3),
          // Divider
          Container(
            width: 1,
            height: 32,
            color: TossColors.gray200,
          ),
          const SizedBox(width: TossSpacing.space3),
          // Shift info
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone.text(words: 2),
                SizedBox(height: 4),
                Bone.text(words: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
