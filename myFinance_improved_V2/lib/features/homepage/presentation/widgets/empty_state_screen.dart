import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';

/// Empty state screen for users without companies
///
/// Shown when:
/// - New user hasn't created/joined a company yet
/// - User's companies were all deleted
/// - Database query returns no companies
class EmptyStateScreen extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? onRetry;

  const EmptyStateScreen({
    super.key,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.gray100,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(TossSpacing.space6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.business_outlined,
                    size: 60,
                    color: TossColors.primary,
                  ),
                ),

                const SizedBox(height: TossSpacing.space6),

                // Title
                Text(
                  'No Company Found',
                  style: TossTextStyles.h1.copyWith(
                    color: TossColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: TossSpacing.space3),

                // Description
                Text(
                  errorMessage ??
                  'You need to create or join a company to get started.',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: TossSpacing.space8),

                // Action buttons
                Column(
                  children: [
                    // Create Company Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.go('/onboarding/create-business');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TossColors.primary,
                          foregroundColor: TossColors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: TossSpacing.space4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Create Company',
                          style: TossTextStyles.bodyLarge.copyWith(
                            color: TossColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: TossSpacing.space3),

                    // Join Company Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          context.go('/onboarding/join-business');
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: TossColors.primary,
                          padding: const EdgeInsets.symmetric(
                            vertical: TossSpacing.space4,
                          ),
                          side: BorderSide(
                            color: TossColors.primary,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                        ),
                        child: Text(
                          'Join Existing Company',
                          style: TossTextStyles.bodyLarge.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    if (onRetry != null) ...[
                      const SizedBox(height: TossSpacing.space3),

                      // Retry Button
                      TextButton(
                        onPressed: onRetry,
                        child: Text(
                          'Retry',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: TossSpacing.space8),

                // Logout option
                TextButton.icon(
                  onPressed: () {
                    // Show logout confirmation
                    _showLogoutDialog(context);
                  },
                  icon: Icon(
                    Icons.logout_rounded,
                    size: 20,
                    color: TossColors.textTertiary,
                  ),
                  label: Text(
                    'Logout',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: TossColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          ),
          title: Text(
            'Logout',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TossTextStyles.body.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Cancel',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // Trigger logout - navigate to login
                context.go('/auth/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TossColors.error,
                foregroundColor: TossColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
              ),
              child: Text(
                'Logout',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
