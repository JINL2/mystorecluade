import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Shows profile popup menu with profile and logout options
void showProfileMenu({
  required BuildContext context,
  required Future<void> Function() onLogout,
}) {
  showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(
      MediaQuery.of(context).size.width - 200,
      80,
      16,
      0,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(TossSpacing.space3),
    ),
    color: TossColors.surface,
    elevation: 2,
    items: [
      PopupMenuItem<String>(
        value: 'profile',
        child: Row(
          children: [
            const Icon(
              Icons.person_outline,
              color: TossColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: TossSpacing.space3),
            Text(
              'My Profile',
              style: TossTextStyles.body,
            ),
          ],
        ),
      ),
      const PopupMenuDivider(),
      PopupMenuItem<String>(
        value: 'logout',
        child: Row(
          children: [
            const Icon(
              Icons.logout_rounded,
              color: TossColors.error,
              size: 20,
            ),
            const SizedBox(width: TossSpacing.space3),
            Text(
              'Logout',
              style: TossTextStyles.bodyError,
            ),
          ],
        ),
      ),
    ],
  ).then((value) async {
    if (value == 'logout') {
      await onLogout();
    } else if (value == 'profile') {
      if (context.mounted) {
        context.push('/my-page');
      }
    }
  });
}
