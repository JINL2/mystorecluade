import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../widgets/toss/toss_text_field.dart';
import '../../widgets/toss/toss_primary_button.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_empty_state_card.dart';
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
    return TossScaffold(
      backgroundColor: TossColors.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: TossColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: TossColors.gray900),
          onPressed: () => Navigator.of(context).pop(), // Direct navigation
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(TossSpacing.space5),
          child: _emailSent ? _buildSuccessView() : _buildFormView(),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 
                     MediaQuery.of(context).padding.top - 
                     MediaQuery.of(context).padding.bottom - 
                     56, // AppBar height
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                
                _buildEmailField(),
                
                const SizedBox(height: TossSpacing.space3),
                
                TossEmptyStateCard(
                  message: 'Check your spam folder if you don\'t receive the email',
                  icon: Icons.info_outline,
                  backgroundColor: TossColors.info.withValues(alpha: 0.1),
                  textColor: TossColors.info,
                ),
              ],
            ),
            
            Column(
              children: [
                const SizedBox(height: TossSpacing.space8),
                TossPrimaryButton(
                  text: 'Send Reset Link',
                  onPressed: _isLoading ? null : _handleSendResetLink,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: TossSpacing.space5),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - 
                   MediaQuery.of(context).padding.top - 
                   MediaQuery.of(context).padding.bottom - 
                   56, // AppBar height
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: TossSpacing.space10),
              
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
            ],
          ),
          
          Column(
            children: [
              const SizedBox(height: TossSpacing.space8),
              TossPrimaryButton(
                text: 'Back to Sign In',
                onPressed: () {
                  // Direct navigation back - bypasses router issues
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: TossSpacing.space5),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TossTextField(
      label: 'Email',
      hintText: 'email@example.com',
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!value.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
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
      await ref.read(authStateProvider.notifier).resetPassword(
        _emailController.text.trim(),
      );
      
      setState(() {
        _emailSent = true;
      });
    } catch (e) {
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