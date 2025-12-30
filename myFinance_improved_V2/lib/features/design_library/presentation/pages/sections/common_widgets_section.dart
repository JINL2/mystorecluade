import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/common/employee_profile_avatar.dart';
import 'package:myfinance_improved/shared/widgets/common/safe_popup_menu.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_date_picker.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_empty_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_error_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_section_header.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_white_card.dart';
import 'package:myfinance_improved/shared/widgets/common/avatar_stack_interact.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_info_dialog.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_primary_button.dart';

/// Common Widgets Section - Showcases widgets from /lib/shared/widgets/common
class CommonWidgetsSection extends StatefulWidget {
  const CommonWidgetsSection({super.key});

  @override
  State<CommonWidgetsSection> createState() => _CommonWidgetsSectionState();
}

class _CommonWidgetsSectionState extends State<CommonWidgetsSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatars
        _ComponentShowcase(
          name: 'EmployeeProfileAvatar',
          description: 'Circular avatar with employee initials',
          filename: 'employee_profile_avatar.dart',
          child: Row(
            children: const [
              EmployeeProfileAvatar(
                name: 'John Doe',
                size: 40,
              ),
              SizedBox(width: TossSpacing.space2),
              EmployeeProfileAvatar(
                name: 'Sarah Smith',
                size: 40,
                showBorder: true,
                borderColor: TossColors.primary,
              ),
              SizedBox(width: TossSpacing.space2),
              EmployeeProfileAvatar(
                name: 'Mike Chen',
                size: 40,
              ),
            ],
          ),
        ),

        // AvatarStackInteract
        _ComponentShowcase(
          name: 'AvatarStackInteract',
          description: 'Interactive avatar stack with bottom sheet showing user list',
          filename: 'avatar_stack_interact.dart',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '3 Users:',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              const AvatarStackInteract(
                users: [
                  AvatarUser(
                    id: '1',
                    name: 'John Doe',
                    avatarUrl: 'https://i.pravatar.cc/150?img=12',
                    subtitle: 'Manager',
                  ),
                  AvatarUser(
                    id: '2',
                    name: 'Jane Smith',
                    avatarUrl: 'https://i.pravatar.cc/150?img=5',
                    subtitle: 'Staff',
                  ),
                  AvatarUser(
                    id: '3',
                    name: 'Mike Johnson',
                    avatarUrl: 'https://i.pravatar.cc/150?img=33',
                    subtitle: 'Supervisor',
                  ),
                ],
                title: 'Applied Users',
                subtitle: 'Morning Shift - Downtown Store',
                countTextFormat: '{count} applied',
              ),
            ],
          ),
        ),

        // TossInfoDialog
        _ComponentShowcase(
          name: 'TossInfoDialog',
          description: 'Simple informational dialog with bullet points for help content',
          filename: 'toss_info_dialog.dart',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shows a dialog with title and bullet points. Perfect for help/info modals.',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textTertiary,
                ),
              ),
              const SizedBox(height: TossSpacing.space3),
              TossPrimaryButton(
                text: 'Show Info Dialog',
                onPressed: () {
                  TossInfoDialog.show(
                    context: context,
                    title: 'What is an SKU?',
                    bulletPoints: [
                      'An SKU (Stock Keeping Unit) is a unique code used to identify an item.',
                      'You can enter your own or have Storebase generate one for you.',
                      'SKUs help you find items quickly and perform bulk actions in your inventory.',
                    ],
                  );
                },
              ),
            ],
          ),
        ),

        // Empty State
        _ComponentShowcase(
          name: 'TossEmptyView',
          description: 'Empty state view with message and icon',
          filename: 'toss_empty_view.dart',
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: const TossEmptyView(
              icon: Icon(
                Icons.inbox_outlined,
                size: 48,
                color: TossColors.gray400,
              ),
              title: 'No items found',
              description: 'Try adjusting your filters',
            ),
          ),
        ),

        // Loading State
        _ComponentShowcase(
          name: 'TossLoadingView',
          description: 'Loading state with circular progress indicator',
          filename: 'toss_loading_view.dart',
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: const TossLoadingView(),
          ),
        ),

        // Error State
        _ComponentShowcase(
          name: 'TossErrorView',
          description: 'Error state view with retry option',
          filename: 'toss_error_view.dart',
          child: Container(
            height: 320,
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: TossErrorView(
              error: Exception('Failed to load data'),
              onRetry: () {},
              title: 'Error',
            ),
          ),
        ),

        // Section Header
        _ComponentShowcase(
          name: 'TossSectionHeader',
          description: 'Section header with title and optional action',
          filename: 'toss_section_header.dart',
          child: TossSectionHeader(
            title: 'Recent Transactions',
            icon: Icons.receipt_long,
            trailing: TextButton(
              onPressed: () {},
              child: const Text('View All'),
            ),
          ),
        ),

        // White Card
        _ComponentShowcase(
          name: 'TossWhiteCard',
          description: 'White card container with border radius and shadow',
          filename: 'toss_white_card.dart',
          child: TossWhiteCard(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Card Title',
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'This is a TossWhiteCard with shadow and border',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),

        // SafePopupMenu
        _ComponentShowcase(
          name: 'SafePopupMenu',
          description: 'Popup menu with safe boundary detection to prevent overflow',
          filename: 'safe_popup_menu.dart',
          child: Align(
            alignment: Alignment.centerLeft,
            child: SafePopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: TossColors.gray700),
              onSelected: (value) {},
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 12),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: TossColors.error),
                      SizedBox(width: 12),
                      Text('Delete', style: TextStyle(color: TossColors.error)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // TossAppBar
        _ComponentShowcase(
          name: 'TossAppBar',
          description: 'Toss-styled application bar with consistent design',
          filename: 'toss_app_bar_1.dart',
          child: Container(
            height: 56,
            decoration: const BoxDecoration(
              color: TossColors.white,
              border: Border(
                bottom: BorderSide(
                  color: TossColors.gray200,
                  width: 1,
                ),
              ),
            ),
            child: const TossAppBar1(
              title: 'App Bar Title',
            ),
          ),
        ),

        // TossDatePicker
        _ComponentShowcase(
          name: 'TossDatePicker',
          description: 'Date picker with Toss styling and Vietnamese locale support',
          filename: 'toss_date_picker.dart',
          child: TossDatePicker(
            date: DateTime.now(),
            placeholder: 'Select Date',
            onDateChanged: (date) {},
          ),
        ),
      ],
    );
  }
}

/// Component showcase with visual example
class _ComponentShowcase extends StatelessWidget {
  const _ComponentShowcase({
    required this.name,
    required this.description,
    required this.filename,
    required this.child,
  });

  final String name;
  final String description;
  final String filename;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TossTextStyles.h4.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          description,
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          filename,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textTertiary,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        child,
        const SizedBox(height: TossSpacing.space4),
      ],
    );
  }
}
