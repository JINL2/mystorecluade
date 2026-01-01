import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/shift_card.dart';
import 'shift_info_card.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
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
              style: TossTextStyles.labelMedium.copyWith(
                color: TossColors.gray600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),

            // Count and avatars
            if (employees.isNotEmpty)
              IgnorePointer(
                child: AvatarStackInteract(
                  users: users,
                  title: label,
                  maxVisibleAvatars: 3,
                  avatarSize: 20,
                  showCount: true,
                  countTextFormat: '$count',
                ),
              )
            else
              Text(
                count.toString(),
                style: TossTextStyles.h4.copyWith(
                  color: TossColors.gray900,
                  fontSize: 15,
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
      width: 1,
      height: 40,
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
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 16),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Divider(height: 1, thickness: 1, color: TossColors.gray100),
          ),
          const SizedBox(height: 8),

          // User list
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 8, bottom: 32),
              itemCount: users.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                thickness: 1,
                color: TossColors.gray50,
                indent: 68,
              ),
              itemBuilder: (context, index) {
                final user = users[index];
                // Get corresponding card if available
                final card = index < cards.length ? cards[index] : null;
                final canTap = card != null && onEmployeeTap != null;

                return GestureDetector(
                  onTap: canTap ? () => onEmployeeTap!(card) : null,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: TossColors.gray200,
                          backgroundImage: user.avatarUrl != null
                              ? NetworkImage(user.avatarUrl!)
                              : null,
                          onBackgroundImageError: (_, __) {},
                          child: user.avatarUrl == null
                              ? const Icon(Icons.person, size: 20, color: TossColors.gray500)
                              : null,
                        ),
                        const SizedBox(width: 12),

                        // Name
                        Expanded(
                          child: Text(
                            user.name,
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        // Chevron icon for navigation hint
                        if (canTap)
                          const Icon(
                            Icons.chevron_right,
                            color: TossColors.gray400,
                            size: 20,
                          ),
                      ],
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
