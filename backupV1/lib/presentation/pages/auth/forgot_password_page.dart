import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../widgets/toss/toss_primary_button.dart';
import '../../widgets/toss/toss_bottom_sheet.dart';
import '../../providers/auth_provider.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.background,
      appBar: AppBar(
        backgroundColor: TossColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: TossColors.gray900),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space5),
          child: _emailSent ? _buildSuccessView() : _buildFormView(),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Reset Password',
            style: TossTextStyles.h1.copyWith(
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          Text(
            'We\'ll send you a password reset link to your email',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
          
          const SizedBox(height: TossSpacing.space8),
          
          // Email Input
          _buildEmailField(),
          
          const SizedBox(height: TossSpacing.space3),
          
          // Info Box
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: TossColors.info,
                ),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    'Check your spam folder if you don\'t receive the email',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.info,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Send Button
          TossPrimaryButton(
            text: 'Send Reset Link',
            onPressed: _isLoading ? null : _handleSendResetLink,
            isLoading: _isLoading,
          ),
          
          const SizedBox(height: TossSpacing.space5),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: TossSpacing.space10),
        
        // Success Icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: TossColors.success.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_outline,
            size: 48,
            color: TossColors.success,
          ),
        ),
        
        const SizedBox(height: TossSpacing.space6),
        
        // Success Message
        Text(
          'Check your email',
          style: TossTextStyles.h2.copyWith(
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        Text(
          _emailController.text,
          style: TossTextStyles.body.copyWith(
            color: TossColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Text(
          'We sent a password reset link',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray600,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: TossSpacing.space8),
        
        // Resend Option
        TextButton(
          onPressed: _isLoading ? null : _handleResendEmail,
          child: Text(
            'Didn\'t receive the email?',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        
        const Spacer(),
        
        // Back to Login Button
        TossPrimaryButton(
          text: 'Back to Sign In',
          onPressed: () {
            context.go('/auth/login');
          },
        ),
        
        const SizedBox(height: TossSpacing.space5),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: TossTextStyles.label.copyWith(
            color: TossColors.gray700,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          style: TossTextStyles.body,
          decoration: InputDecoration(
            hintText: 'email@example.com',
            hintStyle: TossTextStyles.body.copyWith(
              color: TossColors.gray400,
            ),
            filled: true,
            fillColor: TossColors.gray50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: TossColors.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: TossColors.error,
                width: 1.5,
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
            if (!value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
      ],
    );
  }

  Future<void> _handleSendResetLink() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('ForgotPasswordPage: Starting password reset');
      print('ForgotPasswordPage: Email=${_emailController.text.trim()}');
      
      await ref.read(authStateProvider.notifier).resetPassword(
        _emailController.text.trim(),
      );
      
      print('ForgotPasswordPage: Password reset email sent successfully');
      
      setState(() {
        _emailSent = true;
      });
    } catch (e) {
      print('ForgotPasswordPage: Password reset error: $e');
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: TossColors.error,
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

  Future<void> _handleResendEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(authStateProvider.notifier).resetPassword(
        _emailController.text.trim(),
      );
      
      if (mounted) {
        // Show success message using TossBottomSheet
        TossBottomSheet.show(
          context: context,
          content: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: TossColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.email_outlined,
                  size: 32,
                  color: TossColors.success,
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'Email sent successfully',
                style: TossTextStyles.h3,
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'Please check your spam folder too',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: TossColors.error,
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
}