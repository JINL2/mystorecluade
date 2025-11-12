import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Core - Theme System
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';

// Shared - Widgets
import '../../../../shared/widgets/toss/toss_text_field.dart';
import '../../../../shared/widgets/toss/toss_primary_button.dart';

// Core - Constants & Navigation
import '../../../../core/constants/auth_constants.dart';

// Presentation - Providers
import '../providers/auth_service.dart';

// Domain Layer - Exceptions
import '../../domain/exceptions/auth_exceptions.dart';
import '../../domain/exceptions/validation_exception.dart';

/// Signup Page - Clean Architecture Version
///
/// Migrated from V1 with Clean Architecture principles applied.
/// 100% UI/UX preserved from original implementation.
///
/// Features:
/// - Email/Password signup with validation
/// - First Name / Last Name fields
/// - Password confirmation with matching validation
/// - Password strength indicator (5 levels)
/// - Terms of Service agreement checkbox
/// - Real-time validation with check icons
/// - Fade + slide animations
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
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  // Focus Nodes
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();

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
  bool _isFirstNameValid = false;
  bool _isLastNameValid = false;
  int _passwordStrength = 0;

  // Touch State - track if field has been interacted with
  bool _emailTouched = false;
  bool _passwordTouched = false;
  bool _confirmPasswordTouched = false;
  bool _firstNameTouched = false;
  bool _lastNameTouched = false;

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
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TossAnimations.standard,
    ));

    // Add validation listeners
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validatePasswordMatch);
    _firstNameController.addListener(_validateFirstName);
    _lastNameController.addListener(_validateLastName);

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
    _firstNameFocusNode.addListener(() {
      if (!_firstNameFocusNode.hasFocus && !_firstNameTouched) {
        setState(() => _firstNameTouched = true);
      }
    });
    _lastNameFocusNode.addListener(() {
      if (!_lastNameFocusNode.hasFocus && !_lastNameTouched) {
        setState(() => _lastNameTouched = true);
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

  void _validateFirstName() {
    final firstName = _firstNameController.text.trim();
    final isValid = firstName.isNotEmpty;
    if (isValid != _isFirstNameValid) {
      setState(() {
        _isFirstNameValid = isValid;
      });
    }
  }

  void _validateLastName() {
    final lastName = _lastNameController.text.trim();
    final isValid = lastName.isNotEmpty;
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
                padding: EdgeInsets.all(TossSpacing.space5),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: TossSpacing.space4,
              top: TossSpacing.space3,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: TossColors.textPrimary,
                size: 20,
              ),
              onPressed: () {
                context.go('/auth/login');
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: TossSpacing.space5,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/app icon.png',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
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
            // First Name
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
                      if (!_firstNameTouched) return null;
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            // Last Name
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
                      if (!_lastNameTouched) return null;
                      if (value == null || value.trim().isEmpty) {
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
        _isFirstNameValid &&
        _isLastNameValid &&
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
        TextButton(
          onPressed: () {
            if (!mounted) return;

            _animationController.stop();

            // Navigate back to login using GoRouter
            context.go('/auth/login');
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

  // ==========================================
  // Business Logic - Clean Architecture
  // ==========================================

  Future<void> _handleSignup() async {
    // Mark all fields as touched when user tries to submit
    setState(() {
      _firstNameTouched = true;
      _lastNameTouched = true;
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
      final authService = ref.read(authServiceProvider);

      await authService.signUp(
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

          // Navigate to choose role page
          if (mounted) {
            // Stop animation for smooth transition
            _animationController.stop();

            // Navigate using safe navigation
            context.go('/onboarding/choose-role');
          }
        }
      }
    } on ValidationException catch (e) {
      // Handle validation errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: TossColors.white, size: 20),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    e.message,
                    style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w500),
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
    } on EmailAlreadyExistsException catch (e) {
      // Handle email already exists
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.email_outlined, color: TossColors.white, size: 20),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    e.message,
                    style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w500),
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
    } on WeakPasswordException catch (e) {
      // Handle weak password
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.lock_outline, color: TossColors.white, size: 20),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    e.requirements.join(', '),
                    style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } on NetworkException {
      // Handle network errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.wifi_off, color: TossColors.white, size: 20),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    'Connection issue. Please check your internet and try again.',
                    style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w500),
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
    } on AuthException catch (e) {
      // Handle other auth exceptions
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: TossColors.white, size: 20),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    e.message,
                    style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w500),
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
    } catch (e) {
      // Handle unexpected errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: TossColors.white, size: 20),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    'Unable to create account. Please try again or contact support.',
                    style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w500),
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
    return SizedBox(
      width: double.infinity,
      height: 48.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed == null ? TossColors.gray300 : TossColors.primary,
          foregroundColor: TossColors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space5,
            vertical: TossSpacing.space3,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(TossColors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon,
                    const SizedBox(width: TossSpacing.space2),
                  ],
                  Text(
                    text,
                    style: TossTextStyles.button.copyWith(
                      color: TossColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
