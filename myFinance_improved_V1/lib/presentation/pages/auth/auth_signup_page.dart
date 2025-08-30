import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_animations.dart';
import '../../widgets/toss/toss_primary_button.dart';
import '../../widgets/toss/toss_text_field.dart';
import '../../widgets/auth/storebase_auth_header.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../providers/auth_provider.dart';
import '../../../core/constants/auth_constants.dart';
import '../../../core/navigation/safe_navigation.dart';

class AuthSignupPage extends ConsumerStatefulWidget {
  const AuthSignupPage({super.key});

  @override
  ConsumerState<AuthSignupPage> createState() => _AuthSignupPageState();
}

class _AuthSignupPageState extends ConsumerState<AuthSignupPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _agreedToTerms = false;
  
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _isPasswordMatch = false;
  bool _isFirstNameValid = false;
  bool _isLastNameValid = false;
  int _passwordStrength = 0;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: TossAnimations.normal,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: AuthConstants.fadeBegin,
      end: AuthConstants.fadeEnd,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TossAnimations.standard,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TossAnimations.standard,
    ));
    
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validatePasswordMatch);
    _firstNameController.addListener(_validateFirstName);
    _lastNameController.addListener(_validateLastName);
    
    _animationController.forward();
  }
  
  void _validateEmail() {
    final email = _emailController.text.trim();
    final isValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    if (isValid != _isEmailValid) {
      setState(() {
        _isEmailValid = isValid;
      });
    }
  }
  
  void _validatePassword() {
    final password = _passwordController.text;
    int strength = 0;
    
    if (password.length >= AuthConstants.strongPasswordLength) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    
    setState(() {
      _passwordStrength = strength;
      _isPasswordValid = password.length >= AuthConstants.passwordMinLength;
    });
    
    if (_confirmPasswordController.text.isNotEmpty) {
      _validatePasswordMatch();
    }
  }
  
  void _validatePasswordMatch() {
    final match = _passwordController.text == _confirmPasswordController.text &&
                  _confirmPasswordController.text.isNotEmpty;
    if (match != _isPasswordMatch) {
      setState(() {
        _isPasswordMatch = match;
      });
    }
  }
  
  void _validateFirstName() {
    final firstName = _firstNameController.text.trim();
    final isValid = firstName.length >= AuthConstants.nameMinLength;
    if (isValid != _isFirstNameValid) {
      setState(() {
        _isFirstNameValid = isValid;
      });
    }
  }
  
  void _validateLastName() {
    final lastName = _lastNameController.text.trim();
    final isValid = lastName.length >= AuthConstants.nameMinLength;
    if (isValid != _isLastNameValid) {
      setState(() {
        _isLastNameValid = isValid;
      });
    }
  }
  
  @override
  void dispose() {
    _animationController.stop();
    _animationController.dispose();
    
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.background,
      resizeToAvoidBottomInset: true, // Ensure keyboard handling
      body: SafeArea(
        child: Column(
          children: [
            const StorebaseAuthHeader(),
            
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(TossSpacing.space5),
                child: Form(
                  key: _formKey,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: TossSpacing.space4),
                          
                          _buildWelcomeSection(),
                          
                          const SizedBox(height: TossSpacing.space6),
                          
                          _buildNameFields(),
                          
                          const SizedBox(height: TossSpacing.space4),
                          
                          _buildEmailField(),
                          
                          const SizedBox(height: TossSpacing.space4),
                          
                          _buildPasswordField(),
                          
                          const SizedBox(height: TossSpacing.space4),
                          
                          _buildConfirmPasswordField(),
                          
                          const SizedBox(height: TossSpacing.space3),
                          
                          if (_passwordController.text.isNotEmpty)
                            _buildPasswordStrengthIndicator(),
                          
                          const SizedBox(height: TossSpacing.space4),
                          
                          _buildTermsCheckbox(),
                          
                          const SizedBox(height: TossSpacing.space6),
                          
                          _buildCreateAccountButton(),
                          
                          const SizedBox(height: TossSpacing.space4),
                          
                          _buildSignInLink(),
                          
                          const SizedBox(height: TossSpacing.space4),
                          
                          _buildTrustIndicators(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create your account',
          style: TossTextStyles.h1.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Text(
          'Join thousands of businesses using Storebase',
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
            fontSize: AuthConstants.textSizeBodyLarge,
            height: AuthConstants.lineHeightStandard,
          ),
        ),
      ],
    );
  }

  Widget _buildNameFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Name',
          style: TossTextStyles.label.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'First Name',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (_isFirstNameValid) ...[
                        const SizedBox(width: TossSpacing.space1),
                        Icon(
                          Icons.check_circle,
                          size: AuthConstants.iconSizeTiny,
                          color: TossColors.success,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  TossTextField(
                    controller: _firstNameController,
                    focusNode: _firstNameFocusNode,
                    hintText: AuthConstants.placeholderFirstName,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _lastNameFocusNode.requestFocus(),
                    validator: (value) {
                      if (value == null || value.trim().length < 2) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Last Name',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (_isLastNameValid) ...[
                        const SizedBox(width: TossSpacing.space1),
                        Icon(
                          Icons.check_circle,
                          size: AuthConstants.iconSizeTiny,
                          color: TossColors.success,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  TossTextField(
                    controller: _lastNameController,
                    focusNode: _lastNameFocusNode,
                    hintText: AuthConstants.placeholderLastName,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _emailFocusNode.requestFocus(),
                    validator: (value) {
                      if (value == null || value.trim().length < 2) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AuthConstants.labelBusinessEmail,
              style: TossTextStyles.label.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_isEmailValid) ...[
              const SizedBox(width: TossSpacing.space2),
              Icon(
                Icons.check_circle,
                size: 16,
                color: TossColors.success,
              ),
            ],
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        TossTextField(
          controller: _emailController,
          focusNode: _emailFocusNode,
          hintText: AuthConstants.placeholderEmail,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AuthConstants.errorEmailRequired;
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return AuthConstants.errorEmailInvalid;
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
        Row(
          children: [
            Text(
              AuthConstants.labelPassword,
              style: TossTextStyles.label.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_isPasswordValid) ...[
              const SizedBox(width: TossSpacing.space2),
              Icon(
                Icons.check_circle,
                size: 16,
                color: TossColors.success,
              ),
            ],
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        TossTextField(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          hintText: AuthConstants.placeholderPassword,
          obscureText: !_isPasswordVisible,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _confirmPasswordFocusNode.requestFocus(),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              color: TossColors.textTertiary,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AuthConstants.errorPasswordRequired;
            }
            if (value.length < 6) {
              return AuthConstants.errorPasswordMinLength;
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
        Row(
          children: [
            Text(
              AuthConstants.labelConfirmPassword,
              style: TossTextStyles.label.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_isPasswordMatch) ...[
              const SizedBox(width: TossSpacing.space2),
              Icon(
                Icons.check_circle,
                size: 16,
                color: TossColors.success,
              ),
            ],
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        TossTextField(
          controller: _confirmPasswordController,
          focusNode: _confirmPasswordFocusNode,
          hintText: AuthConstants.placeholderConfirmPassword,
          obscureText: !_isConfirmPasswordVisible,
          textInputAction: TextInputAction.done,
          suffixIcon: IconButton(
            icon: Icon(
              _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
              color: TossColors.textTertiary,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AuthConstants.errorPasswordRequired;
            }
            if (value != _passwordController.text) {
              return AuthConstants.errorPasswordMismatch;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    Color strengthColor;
    String strengthText;
    double strengthProgress = _passwordStrength / 5;
    
    if (_passwordStrength <= 1) {
      strengthColor = TossColors.error;
      strengthText = 'Weak';
    } else if (_passwordStrength <= 2) {
      strengthColor = TossColors.warning;
      strengthText = 'Fair';
    } else if (_passwordStrength <= 3) {
      strengthColor = TossColors.warning;
      strengthText = 'Good';
    } else if (_passwordStrength <= 4) {
      strengthColor = TossColors.success;
      strengthText = 'Strong';
    } else {
      strengthColor = TossColors.success;
      strengthText = 'Very Strong';
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.security,
              size: 14,
              color: strengthColor,
            ),
            const SizedBox(width: TossSpacing.space1),
            Text(
              'Password strength: $strengthText',
              style: TossTextStyles.caption.copyWith(
                color: strengthColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TossBorderRadius.micro),
            color: TossColors.gray200,
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: strengthProgress,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(TossBorderRadius.micro),
                color: strengthColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _agreedToTerms,
            onChanged: (value) {
              setState(() {
                _agreedToTerms = value ?? false;
              });
            },
            activeColor: TossColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _agreedToTerms = !_agreedToTerms;
              });
            },
            child: RichText(
              text: TextSpan(
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textSecondary,
                ),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateAccountButton() {
    final canSignup = _isEmailValid && 
                      _isPasswordValid && 
                      _isPasswordMatch && 
                      _isFirstNameValid && 
                      _isLastNameValid && 
                      _agreedToTerms;
    
    return TossPrimaryButton(
      text: _isLoading ? 'Creating account...' : 'Create account',
      onPressed: _isLoading || !canSignup ? null : _handleSignup,
      isLoading: _isLoading,
      fullWidth: true,
      leadingIcon: _isLoading 
          ? null 
          : Icon(
              Icons.person_add,
              size: 18,
              color: TossColors.white,
            ),
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () async {
            // Stop animation for smooth transition
            _animationController.stop();
            
            await Future.delayed(Duration.zero);
            
            if (!mounted) return;
            
            if (context.canPop()) {
              context.safePop();
            } else {
              context.safeGo('/auth/login');
            }
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Sign in',
            style: TossTextStyles.body.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrustIndicators() {
    return Center(
      child: Wrap(
        spacing: TossSpacing.space3,
        children: [
          _buildTrustBadge(Icons.security, '256-bit SSL'),
          _buildTrustBadge(Icons.privacy_tip, 'GDPR Compliant'),
          _buildTrustBadge(Icons.verified_user, 'Secure'),
        ],
      ),
    );
  }

  Widget _buildTrustBadge(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: TossColors.borderLight,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: TossColors.success,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textSecondary,
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
          ),
        ],
      ),
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
      await ref.read(authStateProvider.notifier).signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: TossColors.white, size: 20),
                const SizedBox(width: TossSpacing.space2),
                const Text('Account created successfully!'),
              ],
            ),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
          ),
        );
        
        if (mounted) {
          // Small delay for smooth transition
          await Future.delayed(const Duration(milliseconds: 200));
          
          // Navigate directly to choose role page
          if (mounted) {
            // Stop animation for smooth transition
            _animationController.stop();
            
            context.safeGo('/onboarding/choose-role');
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: TossColors.white, size: 20),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    _getErrorMessage(e.toString()),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            duration: const Duration(seconds: 4),
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

  String _getErrorMessage(String error) {
    if (error.contains('email already') || error.contains('already registered')) {
      return 'An account with this email already exists';
    } else if (error.contains('invalid email')) {
      return 'Please enter a valid email address';
    } else if (error.contains('weak password')) {
      return 'Please choose a stronger password';
    } else if (error.contains('network')) {
      return 'Connection issue. Please check your internet and try again';
    } else {
      return 'Unable to create account. Please try again';
    }
  }
}