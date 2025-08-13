import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../widgets/toss/toss_primary_button.dart';
import '../../providers/auth_provider.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    '회원가입',
                    style: TossTextStyles.h1.copyWith(
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  Text(
                    'MyFinance와 함께 시작하세요',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                  
                  const SizedBox(height: TossSpacing.space8),
                  
                  // Name Input
                  _buildNameField(),
                  
                  const SizedBox(height: TossSpacing.space4),
                  
                  // Email Input
                  _buildEmailField(),
                  
                  const SizedBox(height: TossSpacing.space4),
                  
                  // Password Input
                  _buildPasswordField(),
                  
                  const SizedBox(height: TossSpacing.space4),
                  
                  // Confirm Password Input
                  _buildConfirmPasswordField(),
                  
                  const SizedBox(height: TossSpacing.space6),
                  
                  // Terms Agreement
                  _buildTermsAgreement(),
                  
                  const SizedBox(height: TossSpacing.space8),
                  
                  // Signup Button
                  TossPrimaryButton(
                    text: '가입하기',
                    onPressed: (_isLoading || !_agreedToTerms) ? null : _handleSignup,
                    isLoading: _isLoading,
                  ),
                  
                  const SizedBox(height: TossSpacing.space4),
                  
                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '이미 계정이 있으신가요? ',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          '로그인',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이름',
          style: TossTextStyles.label.copyWith(
            color: TossColors.gray700,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        TextFormField(
          controller: _nameController,
          keyboardType: TextInputType.name,
          style: TossTextStyles.body,
          decoration: _inputDecoration(
            hintText: '이름을 입력하세요',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '이름을 입력해주세요';
            }
            if (value.length < 2) {
              return '이름은 최소 2자 이상이어야 합니다';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이메일',
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
          decoration: _inputDecoration(
            hintText: 'email@example.com',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '이메일을 입력해주세요';
            }
            if (!value.contains('@')) {
              return '올바른 이메일 형식이 아닙니다';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '비밀번호',
          style: TossTextStyles.label.copyWith(
            color: TossColors.gray700,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          style: TossTextStyles.body,
          decoration: _inputDecoration(
            hintText: '비밀번호를 입력하세요',
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
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '비밀번호를 입력해주세요';
            }
            if (value.length < 6) {
              return '비밀번호는 최소 6자 이상이어야 합니다';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '비밀번호 확인',
          style: TossTextStyles.label.copyWith(
            color: TossColors.gray700,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: !_isConfirmPasswordVisible,
          style: TossTextStyles.body,
          decoration: _inputDecoration(
            hintText: '비밀번호를 다시 입력하세요',
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: TossColors.gray500,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '비밀번호 확인을 입력해주세요';
            }
            if (value != _passwordController.text) {
              return '비밀번호가 일치하지 않습니다';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTermsAgreement() {
    return InkWell(
      onTap: () {
        setState(() {
          _agreedToTerms = !_agreedToTerms;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _agreedToTerms ? TossColors.primary : TossColors.gray100,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _agreedToTerms ? TossColors.primary : TossColors.gray300,
                width: 1.5,
              ),
            ),
            child: _agreedToTerms
                ? Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  )
                : null,
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'I agree to the ',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray700,
                    ),
                  ),
                  TextSpan(
                    text: 'Terms of Service',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: ' and ',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray700,
                    ),
                  ),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
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
      suffixIcon: suffixIcon,
    );
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('SignupPage: Starting signup process');
      print('SignupPage: Email=${_emailController.text.trim()}, Name=${_nameController.text.trim()}');
      
      await ref.read(authStateProvider.notifier).signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
      );
      
      print('SignupPage: Signup completed successfully');
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully! Please check your email to verify.'),
            backgroundColor: TossColors.success,
          ),
        );
        
        // Navigation will be handled automatically by GoRouter redirect
      }
    } catch (e) {
      print('SignupPage: Signup error: $e');
      
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