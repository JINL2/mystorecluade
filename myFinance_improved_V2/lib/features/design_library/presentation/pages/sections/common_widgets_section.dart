import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/employee_profile_avatar.dart';
import 'package:myfinance_improved/shared/widgets/molecules/menus/safe_popup_menu.dart';
import 'package:myfinance_improved/shared/widgets/molecules/navigation/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/organisms/pickers/toss_date_picker.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_empty_view.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_error_view.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/atoms/layout/toss_section_header.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_white_card.dart';
import 'package:myfinance_improved/shared/widgets/molecules/display/avatar_stack_interact.dart';
import 'package:myfinance_improved/shared/widgets/organisms/dialogs/toss_info_dialog.dart';
import 'package:myfinance_improved/shared/widgets/organisms/dialogs/toss_confirm_cancel_dialog.dart';
import 'package:myfinance_improved/shared/widgets/organisms/dialogs/toss_success_error_dialog.dart';
import 'package:myfinance_improved/shared/widgets/atoms/layout/gray_divider_space.dart';
import 'package:myfinance_improved/shared/widgets/molecules/buttons/toss_fab.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toss_primary_button.dart';

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

        // TossConfirmCancelDialog
        _ComponentShowcase(
          name: 'TossConfirmCancelDialog',
          description: 'Confirm/Cancel dialog for user action confirmation (delete, save, discard)',
          filename: 'toss_confirm_cancel_dialog.dart',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: TossSpacing.space2,
                runSpacing: TossSpacing.space2,
                children: [
                  TossPrimaryButton(
                    text: 'Confirm Dialog',
                    onPressed: () {
                      TossConfirmCancelDialog.show(
                        context: context,
                        title: 'Confirm Action',
                        message: 'Are you sure you want to proceed with this action?',
                        confirmButtonText: 'Confirm',
                        cancelButtonText: 'Cancel',
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      TossConfirmCancelDialog.showDelete(
                        context: context,
                        title: 'Delete Item',
                        message: 'This action cannot be undone.',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TossColors.error,
                    ),
                    child: const Text('Delete Dialog'),
                  ),
                ],
              ),
            ],
          ),
        ),

        // TossDialog (Success/Error)
        _ComponentShowcase(
          name: 'TossDialog',
          description: 'Success/Error result dialog with icon and message',
          filename: 'toss_success_error_dialog.dart',
          child: Wrap(
            spacing: TossSpacing.space2,
            runSpacing: TossSpacing.space2,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => TossDialog.success(
                      title: 'Success!',
                      message: 'Your changes have been saved successfully.',
                      primaryButtonText: 'OK',
                      onPrimaryPressed: () => Navigator.pop(context),
                    ),
                  );
                },
                icon: const Icon(Icons.check_circle, size: 16),
                label: const Text('Success'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TossColors.success,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => TossDialog.error(
                      title: 'Error',
                      message: 'Something went wrong. Please try again.',
                      primaryButtonText: 'OK',
                      onPrimaryPressed: () => Navigator.pop(context),
                    ),
                  );
                },
                icon: const Icon(Icons.error, size: 16),
                label: const Text('Error'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TossColors.error,
                ),
              ),
            ],
          ),
        ),

        // GrayDividerSpace
        _ComponentShowcase(
          name: 'GrayDividerSpace & GrayVerticalDivider',
          description: 'Full-width horizontal divider and vertical divider for section separation',
          filename: 'gray_divider_space.dart',
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(TossSpacing.space3),
                color: TossColors.white,
                child: const Text('Section 1'),
              ),
              const GrayDividerSpace(height: 12),
              Container(
                padding: const EdgeInsets.all(TossSpacing.space3),
                color: TossColors.white,
                child: const Text('Section 2'),
              ),
              const SizedBox(height: TossSpacing.space3),
              Container(
                padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Metric 1'),
                    GrayVerticalDivider(height: 20),
                    Text('Metric 2'),
                    GrayVerticalDivider(height: 20),
                    Text('Metric 3'),
                  ],
                ),
              ),
            ],
          ),
        ),

        // TossFAB
        _ComponentShowcase(
          name: 'TossFAB',
          description: 'Floating action button with Toss styling',
          filename: 'toss_fab.dart',
          child: Row(
            children: [
              TossFAB(
                onPressed: () {},
                icon: Icons.add,
              ),
              const SizedBox(width: TossSpacing.space3),
              TossFAB(
                onPressed: () {},
                icon: Icons.edit,
                size: 44,
                iconSize: 20,
              ),
            ],
          ),
        ),

        // TossFAB.expandable
        _ComponentShowcase(
          name: 'TossFAB.expandable',
          description: 'Expandable FAB with multiple action buttons',
          filename: 'toss_fab.dart',
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Text('Tap the FAB to expand'),
                ),
                Positioned(
                  right: TossSpacing.space4,
                  bottom: TossSpacing.space4,
                  child: TossFAB.expandable(
                    actions: [
                      TossFABAction(
                        icon: Icons.receipt,
                        label: 'New Invoice',
                        onPressed: () {},
                      ),
                      TossFABAction(
                        icon: Icons.shopping_cart,
                        label: 'New Order',
                        onPressed: () {},
                      ),
                      TossFABAction(
                        icon: Icons.person_add,
                        label: 'New Customer',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Exchange Rate Calculator & Keyboard Toolbar (Documentation only)
        _ComponentShowcase(
          name: 'ExchangeRateCalculator',
          description: 'Currency converter widget with numberpad input (requires Riverpod)',
          filename: 'exchange_rate_calculator.dart',
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.primarySurface,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.primary.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.currency_exchange, color: TossColors.primary, size: 20),
                    const SizedBox(width: TossSpacing.space2),
                    Text(
                      'Exchange Rate Calculator',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'Converts foreign currency to base currency using Riverpod providers.',
                  style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'Usage: Used in JournalInput for multi-currency transactions.',
                  style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
                ),
              ],
            ),
          ),
        ),

        // KeyboardToolbar1
        _ComponentShowcase(
          name: 'KeyboardToolbar1',
          description: 'Keyboard accessory toolbar with done button and custom actions',
          filename: 'keyboard_toolbar_1.dart',
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.keyboard, color: TossColors.gray600, size: 20),
                    const SizedBox(width: TossSpacing.space2),
                    Text(
                      'Keyboard Toolbar',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'Toolbar that appears above the keyboard with Done button and optional actions.',
                  style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
                ),
              ],
            ),
          ),
        ),

        // CachedProductImage
        _ComponentShowcase(
          name: 'CachedProductImage',
          description: 'Network image with caching and placeholder support',
          filename: 'cached_product_image.dart',
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.image, color: TossColors.gray600, size: 20),
                    const SizedBox(width: TossSpacing.space2),
                    Text(
                      'Cached Product Image',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'Displays product images with network caching, loading placeholders, and error handling.',
                  style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
                ),
                const SizedBox(height: TossSpacing.space2),
                Row(
                  children: [
                    // Placeholder example
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: TossColors.gray200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.inventory_2, color: TossColors.gray400),
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Text(
                      'Placeholder shown\nwhile loading',
                      style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
                    ),
                  ],
                ),
              ],
            ),
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
