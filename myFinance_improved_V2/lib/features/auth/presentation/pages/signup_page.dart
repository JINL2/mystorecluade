import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

// Core - Constants & Navigation
import '../../../../core/constants/auth_constants.dart';
// Shared - Widgets
// Domain Layer - Exceptions
import '../../domain/exceptions/auth_exceptions.dart';
import '../../domain/exceptions/validation_exception.dart';
// Presentation - Providers
import '../providers/auth_service.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Signup Page - Clean Architecture Version
///
/// Migrated from V1 with Clean Architecture principles applied.
/// 100% UI/UX preserved from original implementation.
///
/// Features:
/// - Email/Password signup with validation
/// - Password confirmation with matching validation
/// - Password strength indicator (5 levels)
/// - Terms of Service agreement checkbox
/// - Real-time validation with check icons
/// - Fade + slide animations
///
/// Flow:
/// - After signup → Email OTP verification → Complete Profile (name/photo) → Choose Role
///
/// Architecture:
/// - Uses authServiceProvider (Clean Architecture)
/// - Follows Provider<Service> pattern for UI simplicity
/// - Leverages existing infrastructure (cache, synchronization)
class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Focus Nodes
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  // Animation
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // State
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _agreedToTerms = false;

  // Validation State
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _isPasswordMatch = false;
  int _passwordStrength = 0;

  // Touch State - track if field has been interacted with
  bool _emailTouched = false;
  bool _passwordTouched = false;
  bool _confirmPasswordTouched = false;

  @override
  void initState() {
    super.initState();

    // Initialize animations
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
    ),);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TossAnimations.standard,
    ),);

    // Add validation listeners
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validatePasswordMatch);

    // Add focus listeners to mark fields as touched when they lose focus
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus && !_emailTouched) {
        setState(() => _emailTouched = true);
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus && !_passwordTouched) {
        setState(() => _passwordTouched = true);
      }
    });
    _confirmPasswordFocusNode.addListener(() {
      if (!_confirmPasswordFocusNode.hasFocus && !_confirmPasswordTouched) {
        setState(() => _confirmPasswordTouched = true);
      }
    });

    // Start animation
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

    // Calculate password strength (5 criteria)
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

  @override
  void dispose() {
    _animationController.stop();
    _animationController.dispose();

    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Temporary TossScaffold implementation
    return Scaffold(
      backgroundColor: TossColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _buildAuthHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(TossSpacing.space5),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: TossSpacing.space2),

                          _buildWelcomeSection(),

                          const SizedBox(height: TossSpacing.space6),

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

  // Temporary StorebaseAuthHeader implementation
  Widget _buildAuthHeader() {
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
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/auth');
            }
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
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
          'Smart business start here',
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
            fontSize: AuthConstants.textSizeBodyLarge,
            height: AuthConstants.lineHeightStandard,
          ),
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
            if (!_emailTouched) return null;
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
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        TossTextField(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          hintText: 'Create a password',
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
            if (!_passwordTouched) return null;
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
            if (!_confirmPasswordTouched) return null;
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
            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            color: TossColors.gray200,
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: strengthProgress,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
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
          width: TossSpacing.iconMD2,
          height: TossSpacing.iconMD2,
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
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TossTextStyles.body.copyWith(
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
        _agreedToTerms;

    return _buildPrimaryButton(
      text: _isLoading ? 'Creating account...' : 'Create account',
      onPressed: _isLoading || !canSignup ? null : _handleSignup,
      isLoading: _isLoading,
      icon: null,
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
        TossButton.textButton(
          text: 'Sign in',
          onPressed: () {
            if (!mounted) return;

            _animationController.stop();

            // Navigate back to login using GoRouter
            context.go('/auth/login');
          },
          padding: EdgeInsets.zero,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }

  // ==========================================
  // Business Logic - Clean Architecture
  // ==========================================

  Future<void> _handleSignup() async {
    // Mark all fields as touched when user tries to submit
    setState(() {
      _emailTouched = true;
      _passwordTouched = true;
      _confirmPasswordTouched = true;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // ✅ Clean Architecture: Use authServiceProvider
      // Note: Name and profile image will be collected on Complete Profile page after OTP verification
      final authService = ref.read(authServiceProvider);

      await authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        TossToast.success(context, 'Account created! Please verify your email.');

        if (mounted) {
          // Small delay for smooth transition
          await Future.delayed(TossAnimations.normal);

          // Navigate to email verification page
          if (mounted) {
            // Stop animation for smooth transition
            _animationController.stop();

            // Navigate to verify email OTP page with email
            context.push(
              '/auth/verify-email',
              extra: _emailController.text.trim(),
            );
          }
        }
      }
    } on ValidationException catch (e) {
      // Handle validation errors
      if (mounted) {
        TossToast.error(context, e.message);
      }
    } on EmailAlreadyExistsException catch (e) {
      // Handle email already exists
      if (mounted) {
        TossToast.error(context, e.message);
      }
    } on WeakPasswordException catch (e) {
      // Handle weak password
      if (mounted) {
        TossToast.error(context, e.requirements.join(', '));
      }
    } on NetworkException {
      // Handle network errors
      if (mounted) {
        TossToast.error(context, 'Connection issue. Please check your internet and try again.');
      }
    } on AuthException catch (e) {
      // Handle other auth exceptions
      if (mounted) {
        TossToast.error(context, e.message);
      }
    } catch (e) {
      // Handle unexpected errors - show actual error message
      if (mounted) {
        // Extract meaningful error message
        String errorMessage = e.toString();
        if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.replaceFirst('Exception: ', '');
        }

        TossToast.error(context, errorMessage);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ==========================================
  // Temporary Widget Implementations
  // ==========================================
  // ✅ _buildTextField removed - using TossTextField from shared/widgets

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    Widget? icon,
  }) {
    return TossButton.primary(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      leadingIcon: icon,
      fullWidth: true,
      height: 48.0,
      fontWeight: FontWeight.w700,
    );
  }
}
