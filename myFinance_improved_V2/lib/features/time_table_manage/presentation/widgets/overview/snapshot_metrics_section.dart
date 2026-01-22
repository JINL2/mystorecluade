import 'package:flutter/material.dart';

import '../../../../../shared/themes/index.dart';
import '../../../domain/entities/shift_card.dart';
import 'shift_info_card.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/toss_bottom_sheet.dart';

/// Snapshot Metrics Section
///
/// Displays metrics for active shifts:
/// - On-time employees with avatars
/// - Late employees with avatars
/// - Not checked in employees with avatars
class SnapshotMetricsSection extends StatelessWidget {
  final SnapshotData data;
  /// Callback when an employee is tapped in the bottom sheet
  final void Function(ShiftCard card)? onEmployeeTap;

  const SnapshotMetricsSection({
    super.key,
    required this.data,
    this.onEmployeeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          // On-time metric
          _buildMetricItem(
            context: context,
            label: 'On-time',
            count: data.onTime.count,
            employees: data.onTime.employees,
            cards: data.onTime.cards,
          ),

          // Divider
          _buildDivider(),

          // Late metric
          _buildMetricItem(
            context: context,
            label: 'Late',
            count: data.late.count,
            employees: data.late.employees,
            cards: data.late.cards,
          ),

          // Divider
          _buildDivider(),

          // Not checked in metric
          _buildMetricItem(
            context: context,
            label: 'Not checked in',
            count: data.notCheckedIn.count,
            employees: data.notCheckedIn.employees,
            cards: data.notCheckedIn.cards,
          ),
        ],
    );
  }

  /// Build a single metric item
  Widget _buildMetricItem({
    required BuildContext context,
    required String label,
    required int count,
    required List<Map<String, dynamic>> employees,
    required List<ShiftCard> cards,
  }) {
    final users = employees
        .map(
          (emp) => AvatarUser(
            id: (emp['user_name'] as String?) ?? '',
            name: (emp['user_name'] as String?) ?? 'Unknown',
            avatarUrl: emp['profile_image'] as String?,
          ),
        )
        .toList();

    return Expanded(
      child: GestureDetector(
        onTap: employees.isNotEmpty
            ? () {
                // Show bottom sheet for entire metric area
                TossBottomSheet.showWithBuilder<void>(
                  context: context,
                  isScrollControlled: true,
                  heightFactor: 0.75,
                  builder: (sheetContext) => _MetricBottomSheet(
                    title: label,
                    users: users,
                    cards: cards,
                    onEmployeeTap: onEmployeeTap != null
                        ? (card) {
                            Navigator.of(sheetContext).pop();
                            onEmployeeTap!(card);
                          }
                        : null,
                  ),
                );
              }
            : null,
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            Text(
              label,
              style: TossTextStyles.small.copyWith(
                color: TossColors.gray600,
              ),
            ),
            const SizedBox(height: TossSpacing.space1),

            // Count and avatars
            if (employees.isNotEmpty)
              IgnorePointer(
                child: AvatarStackInteract(
                  users: users,
                  title: label,
                  maxVisibleAvatars: 3,
                  avatarSize: TossDimensions.avatarXXS,
                  showCount: true,
                  countTextFormat: '$count',
                ),
              )
            else
              Text(
                count.toString(),
                style: TossTextStyles.titleMedium.copyWith(
                  color: TossColors.gray900,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build vertical divider
  Widget _buildDivider() {
    return Container(
      width: TossDimensions.dividerThickness,
      height: TossDimensions.dividerHeightLG,
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space2),
      color: TossColors.gray200,
    );
  }
}

/// Bottom sheet widget for metric details
class _MetricBottomSheet extends StatelessWidget {
  final String title;
  final List<AvatarUser> users;
  final List<ShiftCard> cards;
  final void Function(ShiftCard card)? onEmployeeTap;

  const _MetricBottomSheet({
    required this.title,
    required this.users,
    this.cards = const [],
    this.onEmployeeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: TossDimensions.dragHandleWidth - 4, // 36px
            height: TossDimensions.dragHandleHeight,
            margin: EdgeInsets.only(
              top: TossSpacing.space3,
              bottom: TossSpacing.space4,
            ),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.dragHandle),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
                fontWeight: TossFontWeight.semibold,
              ),
            ),
          ),

          const SizedBox(height: TossSpacing.space3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space8),
            child: Divider(height: TossDimensions.dividerThickness, thickness: TossDimensions.dividerThickness, color: TossColors.gray100),
          ),
          const SizedBox(height: TossSpacing.space2),

          // User list
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: TossSpacing.space2, bottom: TossSpacing.space8),
              itemCount: users.length,
              separatorBuilder: (context, index) => Divider(
                height: TossDimensions.dividerThickness,
                thickness: TossDimensions.dividerThickness,
                color: TossColors.gray50,
                indent: TossDimensions.avatarLG + TossSpacing.space4 + TossSpacing.space3, // avatar + padding + gap
              ),
              itemBuilder: (context, index) {
                final user = users[index];
                // Get corresponding card if available
                final card = index < cards.length ? cards[index] : null;
                final canTap = card != null && onEmployeeTap != null;

                return Material(
                  color: TossColors.transparent,
                  child: InkWell(
                    onTap: canTap ? () => onEmployeeTap!(card) : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space5,
                        vertical: TossSpacing.space3,
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          EmployeeProfileAvatar(
                            imageUrl: user.avatarUrl,
                            name: user.name,
                            size: TossDimensions.avatarLG,
                          ),
                          const SizedBox(width: TossSpacing.space3),

                          // Name
                          Expanded(
                            child: Text(
                              user.name,
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                                fontWeight: TossFontWeight.semibold,
                              ),
                            ),
                          ),

                          // Chevron icon for navigation hint
                          if (canTap)
                            Icon(
                              Icons.chevron_right,
                              color: TossColors.gray400,
                              size: TossSpacing.iconMD,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
