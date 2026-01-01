import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/themes/index.dart';
import '../providers/auth_service.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Reset Password Page
///
/// Page where users enter their new password after verifying
/// their OTP code. User is authenticated via OTP verification
/// before reaching this page.
class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;
  bool _isSuccess = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.updatePassword(
        newPassword: _passwordController.text,
      );

      if (!mounted) return;

      setState(() {
        _isSuccess = true;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: TossColors.white, size: 20),
              SizedBox(width: TossSpacing.space2),
              Text('Password updated successfully!'),
            ],
          ),
          backgroundColor: TossColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
        ),
      );

      // Navigate to login after a short delay
      await Future<void>.delayed(const Duration(seconds: 2));
      if (mounted) {
        context.go('/auth/login');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSuccess) {
      return _buildSuccessView();
    }

    return Scaffold(
      backgroundColor: TossColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space6,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: TossSpacing.space10),

                // Lock icon
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: TossColors.primarySurface,
                      borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                    ),
                    child: const Icon(
                      Icons.lock_reset_rounded,
                      size: 40,
                      color: TossColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: TossSpacing.space6),

                // Title
                Center(
                  child: Text(
                    'Set new password',
                    style: TossTextStyles.h1.copyWith(
                      color: TossColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: TossSpacing.space2),

                // Description
                Center(
                  child: Text(
                    'Your new password must be different from\npreviously used passwords.',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: TossSpacing.space8),

                // Password field
                _buildPasswordField(),

                const SizedBox(height: TossSpacing.space4),

                // Confirm password field
                _buildConfirmPasswordField(),

                // Password requirements
                const SizedBox(height: TossSpacing.space4),
                _buildPasswordRequirements(),

                // Error message
                if (_errorMessage != null) ...[
                  const SizedBox(height: TossSpacing.space4),
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: TossColors.errorLight,
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: TossColors.error,
                          size: 20,
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: TossSpacing.space8),

                // Submit button
                TossPrimaryButton(
                  text: _isLoading ? 'Updating...' : 'Reset password',
                  onPressed: _isLoading ? null : _handleResetPassword,
                  isLoading: _isLoading,
                  fullWidth: true,
                ),

                const SizedBox(height: TossSpacing.space6),

                // Back to login link
                Center(
                  child: TextButton(
                    onPressed: () => context.go('/auth/login'),
                    child: Text(
                      'Back to sign in',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: TossSpacing.space8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Scaffold(
      backgroundColor: TossColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space6,
          ),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Success icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: TossColors.successLight,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 40,
                  color: TossColors.success,
                ),
              ),

              const SizedBox(height: TossSpacing.space6),

              // Title
              Text(
                'Password updated!',
                style: TossTextStyles.h1.copyWith(
                  color: TossColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: TossSpacing.space3),

              // Description
              Text(
                'Your password has been successfully updated.\nYou can now sign in with your new password.',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),

              // Redirecting indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: TossColors.primary,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Text(
                    'Redirecting to sign in...',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textTertiary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: TossSpacing.space8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.next,
      style: TossTextStyles.body.copyWith(
        color: TossColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: 'New password',
        hintText: 'Enter your new password',
        labelStyle: TossTextStyles.body.copyWith(
          color: TossColors.textSecondary,
        ),
        hintStyle: TossTextStyles.body.copyWith(
          color: TossColors.textTertiary,
        ),
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          color: TossColors.textSecondary,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: TossColors.textSecondary,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        filled: true,
        fillColor: TossColors.gray100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          borderSide: const BorderSide(
            color: TossColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          borderSide: const BorderSide(
            color: TossColors.error,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space4,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your new password';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        if (!RegExp(r'[A-Z]').hasMatch(value)) {
          return 'Password must contain at least one uppercase letter';
        }
        if (!RegExp(r'[a-z]').hasMatch(value)) {
          return 'Password must contain at least one lowercase letter';
        }
        if (!RegExp(r'[0-9]').hasMatch(value)) {
          return 'Password must contain at least one number';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _handleResetPassword(),
      style: TossTextStyles.body.copyWith(
        color: TossColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: 'Confirm password',
        hintText: 'Re-enter your new password',
        labelStyle: TossTextStyles.body.copyWith(
          color: TossColors.textSecondary,
        ),
        hintStyle: TossTextStyles.body.copyWith(
          color: TossColors.textTertiary,
        ),
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          color: TossColors.textSecondary,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
            color: TossColors.textSecondary,
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
        filled: true,
        fillColor: TossColors.gray100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          borderSide: const BorderSide(
            color: TossColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          borderSide: const BorderSide(
            color: TossColors.error,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space4,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordRequirements() {
    final password = _passwordController.text;

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password requirements:',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          _buildRequirement('At least 8 characters', password.length >= 8),
          _buildRequirement('One uppercase letter', RegExp(r'[A-Z]').hasMatch(password)),
          _buildRequirement('One lowercase letter', RegExp(r'[a-z]').hasMatch(password)),
          _buildRequirement('One number', RegExp(r'[0-9]').hasMatch(password)),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(top: TossSpacing.space1),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isMet ? TossColors.success : TossColors.textTertiary,
          ),
          const SizedBox(width: TossSpacing.space2),
          Text(
            text,
            style: TossTextStyles.caption.copyWith(
              color: isMet ? TossColors.success : TossColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
