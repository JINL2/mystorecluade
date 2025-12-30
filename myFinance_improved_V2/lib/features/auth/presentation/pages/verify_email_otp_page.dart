import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/themes/index.dart';
import '../../../../shared/widgets/toss/toss_primary_button.dart';
import '../../../homepage/presentation/providers/homepage_providers.dart';
import '../providers/auth_service.dart';

/// Verify Email OTP Page
///
/// Page where users enter the 6-digit OTP code sent to their email after signup.
/// After verification, user's email is confirmed and they proceed to onboarding.
class VerifyEmailOtpPage extends ConsumerStatefulWidget {
  final String? email;

  const VerifyEmailOtpPage({
    super.key,
    this.email,
  });

  @override
  ConsumerState<VerifyEmailOtpPage> createState() => _VerifyEmailOtpPageState();
}

class _VerifyEmailOtpPageState extends ConsumerState<VerifyEmailOtpPage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (_) => FocusNode(),
  );

  bool _isLoading = false;
  bool _isResending = false;
  String? _errorMessage;
  bool _isSuccess = false;

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _otpCode {
    return _controllers.map((c) => c.text).join();
  }

  bool get _isOtpComplete {
    return _otpCode.length == 6;
  }

  Future<void> _handleVerifyOtp() async {
    if (!_isOtpComplete) {
      setState(() {
        _errorMessage = 'Please enter all 6 digits';
      });
      return;
    }

    if (widget.email == null) {
      setState(() {
        _errorMessage = 'Email not found. Please try again.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.verifySignupOtp(
        email: widget.email!,
        token: _otpCode,
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
              Text('Email verified successfully!'),
            ],
          ),
          backgroundColor: TossColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
        ),
      );

      // ✅ Fetch user companies data to populate AppState
      // This triggers the router to handle navigation automatically
      await ref.read(userCompaniesProvider.future);

      // Navigate to Complete Profile page after a short delay
      // User will enter their name and profile photo there
      // Note: Router will handle this automatically based on first_name being NULL
      await Future<void>.delayed(const Duration(seconds: 1));
      if (mounted) {
        context.go('/auth/complete-profile');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
        // Clear the OTP fields on error
        for (final controller in _controllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleResendOtp() async {
    if (widget.email == null) return;

    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.resendSignupOtp(email: widget.email!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: TossColors.white, size: 20),
                SizedBox(width: TossSpacing.space2),
                Text('Verification code sent'),
              ],
            ),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: TossColors.white, size: 20),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(e.toString().replaceFirst('Exception: ', '')),
                ),
              ],
            ),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1) {
      // Move to next field
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last digit entered, auto-submit
        _focusNodes[index].unfocus();
        _handleVerifyOtp();
      }
    } else if (value.isEmpty && index > 0) {
      // Move to previous field on delete
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isSuccess) {
      return _buildSuccessView();
    }

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
                child: Column(
                  children: [
                    const SizedBox(height: TossSpacing.space6),

                    // Email icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: TossColors.primarySurface,
                        borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                      ),
                      child: const Icon(
                        Icons.mark_email_read_outlined,
                        size: 40,
                        color: TossColors.primary,
                      ),
                    ),

                    const SizedBox(height: TossSpacing.space6),

                    // Title
                    Text(
                      'Verify your email',
                      style: TossTextStyles.h1.copyWith(
                        color: TossColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: TossSpacing.space2),

                    // Description
                    Text(
                      widget.email != null
                          ? 'We\'ve sent a 6-digit code to\n${widget.email}'
                          : 'Enter the 6-digit code sent to your email',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: TossSpacing.space8),

                    // OTP Input fields
                    _buildOtpFields(),

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

                    // Verify button
                    TossPrimaryButton(
                      text: _isLoading ? 'Verifying...' : 'Verify email',
                      onPressed: _isLoading || !_isOtpComplete
                          ? null
                          : _handleVerifyOtp,
                      isLoading: _isLoading,
                      fullWidth: true,
                    ),

                    const SizedBox(height: TossSpacing.space6),

                    // Resend code button
                    if (widget.email != null) ...[
                      TextButton(
                        onPressed: _isResending ? null : _handleResendOtp,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isResending)
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: TossColors.primary,
                                ),
                              )
                            else
                              const Icon(
                                Icons.refresh,
                                size: 18,
                                color: TossColors.primary,
                              ),
                            const SizedBox(width: TossSpacing.space2),
                            Text(
                              _isResending ? 'Sending...' : 'Resend code',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: TossSpacing.space4),

                    // Back to login
                    TextButton(
                      onPressed: () => context.go('/auth/login'),
                      child: Text(
                        'Back to sign in',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
                'Email verified!',
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
                'Your email has been successfully verified.\nLet\'s complete your profile!',
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
                    'Setting up your account...',
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
          onPressed: () => context.go('/auth/login'),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
    );
  }

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 48,
          height: 56,
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: TossTextStyles.h2.copyWith(
              color: TossColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: TossColors.gray100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                borderSide: const BorderSide(
                  color: TossColors.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                borderSide: const BorderSide(
                  color: TossColors.error,
                  width: 1,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: TossSpacing.space3,
              ),
            ),
            onChanged: (value) => _onOtpChanged(index, value),
          ),
        );
      }),
    );
  }
}
