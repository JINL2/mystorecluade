import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
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
import 'package:myfinance_improved/shared/widgets/common/toss_speed_dial.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_primary_button.dart';

import '../component_showcase.dart';

/// Common Widgets Page - widgets/common folder
class CommonWidgetsPage extends StatelessWidget {
  const CommonWidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      children: [
        // EmployeeProfileAvatar
        ComponentShowcase(
          name: 'EmployeeProfileAvatar',
          filename: 'employee_profile_avatar.dart',
          child: Row(
            children: const [
              EmployeeProfileAvatar(name: 'John Doe', size: 40),
              SizedBox(width: TossSpacing.space2),
              EmployeeProfileAvatar(name: 'Sarah Smith', size: 40, showBorder: true, borderColor: TossColors.primary),
              SizedBox(width: TossSpacing.space2),
              EmployeeProfileAvatar(name: 'Mike Chen', size: 40),
            ],
          ),
        ),

        // AvatarStackInteract
        ComponentShowcase(
          name: 'AvatarStackInteract',
          filename: 'avatar_stack_interact.dart',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              AvatarStackInteract(
                users: [
                  AvatarUser(id: '1', name: 'John Doe', subtitle: 'Manager'),
                  AvatarUser(id: '2', name: 'Jane Smith', subtitle: 'Staff'),
                  AvatarUser(id: '3', name: 'Mike Johnson', subtitle: 'Supervisor'),
                ],
                title: 'Team Members',
                countTextFormat: '{count} members',
              ),
              SizedBox(height: TossSpacing.space3),
              AvatarStackInteract(
                users: [
                  AvatarUser(id: '1', name: 'User 1'),
                  AvatarUser(id: '2', name: 'User 2'),
                  AvatarUser(id: '3', name: 'User 3'),
                  AvatarUser(id: '4', name: 'User 4'),
                  AvatarUser(id: '5', name: 'User 5'),
                  AvatarUser(id: '6', name: 'User 6'),
                ],
                title: 'Large Group',
                countTextFormat: '{count} users',
              ),
            ],
          ),
        ),

        // TossEmptyView
        ComponentShowcase(
          name: 'TossEmptyView',
          filename: 'toss_empty_view.dart',
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: const TossEmptyView(
              icon: Icon(Icons.inbox_outlined, size: 48, color: TossColors.gray400),
              title: 'No items found',
              description: 'Try adjusting your filters',
            ),
          ),
        ),

        // TossLoadingView
        ComponentShowcase(
          name: 'TossLoadingView',
          filename: 'toss_loading_view.dart',
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: const TossLoadingView(),
          ),
        ),

        // TossErrorView
        ComponentShowcase(
          name: 'TossErrorView',
          filename: 'toss_error_view.dart',
          child: Container(
            height: 300,
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

        // TossSectionHeader
        ComponentShowcase(
          name: 'TossSectionHeader',
          filename: 'toss_section_header.dart',
          child: TossSectionHeader(
            title: 'Recent Transactions',
            icon: Icons.receipt_long,
            trailing: TextButton(onPressed: () {}, child: const Text('View All')),
          ),
        ),

        // TossWhiteCard
        ComponentShowcase(
          name: 'TossWhiteCard',
          filename: 'toss_white_card.dart',
          child: TossWhiteCard(
            padding: const EdgeInsets.all(TossSpacing.paddingMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Card Title', style: TossTextStyles.h4.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: TossSpacing.space2),
                Text('White card with shadow and border', style: TossTextStyles.body.copyWith(color: TossColors.textSecondary)),
              ],
            ),
          ),
        ),

        // TossAppBar
        ComponentShowcase(
          name: 'TossAppBar1',
          filename: 'toss_app_bar_1.dart',
          child: Container(
            height: 56,
            decoration: const BoxDecoration(
              color: TossColors.white,
              border: Border(bottom: BorderSide(color: TossColors.gray200)),
            ),
            child: const TossAppBar1(title: 'App Bar Title'),
          ),
        ),

        // TossDatePicker
        ComponentShowcase(
          name: 'TossDatePicker',
          filename: 'toss_date_picker.dart',
          child: TossDatePicker(
            date: DateTime.now(),
            placeholder: 'Select Date',
            onDateChanged: (date) {},
          ),
        ),

        // SafePopupMenu
        ComponentShowcase(
          name: 'SafePopupMenuButton',
          filename: 'safe_popup_menu.dart',
          child: Align(
            alignment: Alignment.centerLeft,
            child: SafePopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: TossColors.gray700),
              onSelected: (value) {},
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 20), SizedBox(width: 12), Text('Edit')])),
                PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, size: 20, color: TossColors.error), SizedBox(width: 12), Text('Delete', style: TextStyle(color: TossColors.error))])),
              ],
            ),
          ),
        ),

        // TossInfoDialog
        ComponentShowcase(
          name: 'TossInfoDialog',
          filename: 'toss_info_dialog.dart',
          child: TossPrimaryButton(
            text: 'Show Info Dialog',
            onPressed: () {
              TossInfoDialog.show(
                context: context,
                title: 'What is an SKU?',
                bulletPoints: [
                  'An SKU is a unique code to identify items.',
                  'You can enter your own or auto-generate.',
                  'SKUs help find items quickly.',
                ],
              );
            },
          ),
        ),

        // TossSpeedDial
        ComponentShowcase(
          name: 'TossSpeedDial',
          filename: 'toss_speed_dial.dart',
          child: Row(
            children: [
              Text('Expandable FAB:', style: TossTextStyles.body),
              const SizedBox(width: TossSpacing.space3),
              TossSpeedDial(
                actions: [
                  TossSpeedDialAction(icon: Icons.add, label: 'Add Product', onPressed: () {}),
                  TossSpeedDialAction(icon: Icons.download, label: 'Stock In', onPressed: () {}),
                  TossSpeedDialAction(icon: Icons.upload, label: 'Stock Out', onPressed: () {}),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: TossSpacing.space8),
      ],
    );
  }
}
