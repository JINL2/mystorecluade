import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/toss/toss_primary_button.dart';
import '../providers/auth_service.dart';

/// Forgot Password Page
///
/// Allows users to request a password reset OTP code.
/// After submitting, navigates to verify OTP page.
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.sendPasswordOtp(
        email: _emailController.text.trim(),
      );

      if (!mounted) return;

      // Navigate to OTP verification page with email
      context.push(
        '/auth/verify-otp',
        extra: _emailController.text.trim(),
      );
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
    return Scaffold(
      backgroundColor: TossColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            _buildHeader(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space6,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: TossSpacing.space6),

                      // Title
                      Text(
                        'Forgot password?',
                        style: TossTextStyles.h1.copyWith(
                          color: TossColors.textPrimary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                        ),
                      ),

                      const SizedBox(height: TossSpacing.space2),

                      // Description
                      Text(
                        'Enter your email address and we\'ll send you a 6-digit code to reset your password.',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.textSecondary,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: TossSpacing.space8),

                      // Email field
                      _buildEmailField(),

                      // Error message
                      if (_errorMessage != null) ...[
                        const SizedBox(height: TossSpacing.space4),
                        Container(
                          padding: const EdgeInsets.all(TossSpacing.space3),
                          decoration: BoxDecoration(
                            color: TossColors.errorLight,
                            borderRadius: BorderRadius.circular(12),
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
                        text: _isLoading ? 'Sending...' : 'Send code',
                        onPressed: _isLoading ? null : _handleSendOtp,
                        isLoading: _isLoading,
                        fullWidth: true,
                      ),

                      const SizedBox(height: TossSpacing.space6),

                      // Back to login link
                      Center(
                        child: TextButton(
                          onPressed: () => context.pop(),
                          child: Text(
                            'Back to sign in',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(
          left: TossSpacing.space4,
          top: TossSpacing.space3,
        ),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: TossColors.textPrimary,
            size: 20,
          ),
          onPressed: () => context.pop(),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _handleSendOtp(),
      style: TossTextStyles.body.copyWith(
        color: TossColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email address',
        labelStyle: TossTextStyles.body.copyWith(
          color: TossColors.textSecondary,
        ),
        hintStyle: TossTextStyles.body.copyWith(
          color: TossColors.textTertiary,
        ),
        prefixIcon: const Icon(
          Icons.mail_outline_rounded,
          color: TossColors.textSecondary,
        ),
        filled: true,
        fillColor: TossColors.gray100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: TossColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
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
          return 'Please enter your email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }
}
