import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../widgets/toss/toss_primary_button.dart';
import '../../widgets/toss/toss_text_field.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space5),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: TossSpacing.space8),
                
                // Title with Toss style
                Text(
                  'Welcome back!',
                  style: TossTextStyles.h1.copyWith(
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(height: TossSpacing.space3),
                Text(
                  'Sign in to your account',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                
                const SizedBox(height: TossSpacing.space10),
                
                // Email Input
                _buildEmailField(),
                
                const SizedBox(height: TossSpacing.space4),
                
                // Password Input
                _buildPasswordField(),
                
                const SizedBox(height: TossSpacing.space3),
                
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.push('/auth/forgot-password');
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Forgot password?',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Login Button
                TossPrimaryButton(
                  text: 'Sign In',
                  onPressed: _isLoading ? null : _handleLogin,
                  isLoading: _isLoading,
                ),
                
                const SizedBox(height: TossSpacing.space4),
                
                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.push('/auth/signup');
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Sign Up',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: TossSpacing.space2),
                
                const SizedBox(height: TossSpacing.space3),
              ],
            ),
          ),
        ),
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

  Widget _buildPasswordField() {
    return TossTextField(
      label: 'Password',
      hintText: 'Enter your password',
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      suffixIcon: IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          color: TossColors.gray500,
        ),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(authStateProvider.notifier).signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      // Navigation will be handled automatically by GoRouter redirect
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