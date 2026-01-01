import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../../auth/di/auth_providers.dart';
import '../widgets/common_widgets.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class PrivacySecurityPage extends ConsumerStatefulWidget {
  const PrivacySecurityPage({super.key});

  @override
  ConsumerState<PrivacySecurityPage> createState() => _PrivacySecurityPageState();
}

class _PrivacySecurityPageState extends ConsumerState<PrivacySecurityPage> {
  bool _showChangePassword = false;
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: const TossAppBar(
        title: 'Privacy & Security',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TossSpacing.screenPaddingMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Security Settings
            Text(
              'Security Settings',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
              ),
            ),
            const SizedBox(height: TossSpacing.space4),

            TossWhiteCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildSecurityItem(
                    Icons.lock_outline,
                    'Change Password',
                    'Update your account password',
                    () => _toggleChangePassword(),
                  ),
                  const CommonDivider(),
                  _buildSecurityItem(
                    Icons.security_outlined,
                    'Two-Factor Authentication',
                    'Add an extra layer of security',
                    () => _showComingSoon('Two-Factor Authentication'),
                  ),
                  const CommonDivider(),
                  _buildSecurityItem(
                    Icons.devices_outlined,
                    'Active Sessions',
                    'Manage your signed-in devices',
                    () => _showComingSoon('Active Sessions'),
                  ),
                ],
              ),
            ),

            // Change Password Form (Expandable)
            if (_showChangePassword) ...[
              const SizedBox(height: TossSpacing.space6),
              _buildChangePasswordForm(),
            ],

            const SizedBox(height: TossSpacing.space8),

            // Support
            Text(
              'Support',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
              ),
            ),
            const SizedBox(height: TossSpacing.space4),

            TossWhiteCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildSecurityItem(
                    Icons.help_outline,
                    'Privacy Policy',
                    'Read our privacy policy',
                    () => _showComingSoon('Privacy Policy'),
                  ),
                  const CommonDivider(),
                  _buildSecurityItem(
                    Icons.description_outlined,
                    'Terms of Service',
                    'Read our terms of service',
                    () => _showComingSoon('Terms of Service'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (isDestructive ? TossColors.error : TossColors.gray500).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDestructive ? TossColors.error : TossColors.gray700,
              ),
            ),
            const SizedBox(width: TossSpacing.space4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? TossColors.error : TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    subtitle,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: TossColors.gray400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangePasswordForm() {
    return TossWhiteCard(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Change Password',
              style: TossTextStyles.h4.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
              ),
            ),
            const SizedBox(height: TossSpacing.space4),

            TossTextField(
              controller: _currentPasswordController,
              label: 'Current Password',
              hintText: 'Enter current password',
              obscureText: _obscureCurrentPassword,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your current password';
                }
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureCurrentPassword ? Icons.visibility : Icons.visibility_off,
                  color: TossColors.gray600,
                ),
                onPressed: () {
                  setState(() {
                    _obscureCurrentPassword = !_obscureCurrentPassword;
                  });
                },
              ),
            ),
            const SizedBox(height: TossSpacing.space4),

            TossTextField(
              controller: _newPasswordController,
              label: 'New Password',
              hintText: 'Enter new password',
              obscureText: _obscureNewPassword,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a new password';
                }
                if (value!.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                  color: TossColors.gray600,
                ),
                onPressed: () {
                  setState(() {
                    _obscureNewPassword = !_obscureNewPassword;
                  });
                },
              ),
            ),
            const SizedBox(height: TossSpacing.space4),

            TossTextField(
              controller: _confirmPasswordController,
              label: 'Confirm New Password',
              hintText: 'Confirm new password',
              obscureText: _obscureConfirmPassword,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please confirm your new password';
                }
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                  color: TossColors.gray600,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),

            const SizedBox(height: TossSpacing.space6),

            Row(
              children: [
                Expanded(
                  child: TossButton.secondary(
                    text: 'Cancel',
                    onPressed: _toggleChangePassword,
                    fullWidth: true,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: TossButton.primary(
                    text: 'Update Password',
                    onPressed: _isLoading ? null : _changePassword,
                    isLoading: _isLoading,
                    fullWidth: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _toggleChangePassword() {
    setState(() {
      _showChangePassword = !_showChangePassword;
      if (!_showChangePassword) {
        // Clear form when hiding
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      }
    });
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authDataSource = ref.read(authDataSourceProvider);
      await authDataSource.updatePassword(
        newPassword: _newPasswordController.text,
      );

      if (mounted) {
        HapticFeedback.lightImpact();

        // Show success dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Password Updated!',
            message: 'Your password has been updated successfully',
            primaryButtonText: 'Done',
            onPrimaryPressed: () => context.pop(),
          ),
        );

        _toggleChangePassword();
      }
    } catch (e) {
      if (mounted) {
        // Show error dialog
        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Password Update Failed',
            message: 'Failed to update password: $e',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => context.pop(),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showComingSoon(String feature) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon'),
        backgroundColor: TossColors.primary,
      ),
    );
  }
}
