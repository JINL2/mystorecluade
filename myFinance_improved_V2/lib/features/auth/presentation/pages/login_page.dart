import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Shared - Theme System ✅
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_animations.dart';

// Core - Constants ✅
import '../../../../core/constants/auth_constants.dart';

// Core - Infrastructure Services ✅
import '../../../../core/notifications/services/production_token_service.dart';

// App-level Providers ✅

// Widgets (from V1 - should be reused)
// TODO: Verify these widgets exist in V2 or copy from V1
// import '../../../../presentation/widgets/toss/toss_primary_button.dart';
// import '../../../../presentation/widgets/toss/toss_text_field.dart';
// import '../../../../presentation/widgets/auth/storebase_auth_header.dart';
// import '../../../../presentation/widgets/common/toss_scaffold.dart';

// Clean Architecture - Auth Feature Providers
import '../providers/auth_service.dart';

// Homepage Providers
import '../../../homepage/presentation/providers/homepage_providers.dart';

// Domain Layer - Exceptions
import '../../domain/exceptions/auth_exceptions.dart';
import '../../domain/exceptions/validation_exception.dart';

/// Login Page - Clean Architecture Implementation
///
/// Migrated from V1 with the following changes:
/// - Uses AuthService (Clean Architecture) instead of EnhancedAuthProvider
/// - Maintains 100% UI/UX compatibility
/// - All animations preserved
/// - Progressive disclosure pattern preserved
/// - Error handling preserved
///
/// Dependencies:
/// - AuthService (Clean Architecture)
/// - App State Provider (V1 legacy - temporary)
/// - FCM Token Service (V1 legacy - temporary)
/// - Auth Data Cache (V1 legacy - temporary)
/// - State Synchronizer (V1 legacy - temporary)
///
/// TODO for full Clean Architecture:
/// - Migrate App State Provider
/// - Migrate FCM Token Service
/// - Migrate Auth Data Cache
/// - Migrate State Synchronizer
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with TickerProviderStateMixin {
  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  // Animation Controllers
  late AnimationController _animationController;
  late AnimationController _passwordRevealController;
  late AnimationController _buttonPulseController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _passwordRevealAnimation;
  late Animation<double> _buttonPulseAnimation;

  // State
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _showPasswordField = false;
  bool _isEmailValid = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _animationController = AnimationController(
      duration: TossAnimations.normal,
      vsync: this,
    );

    _passwordRevealController = AnimationController(
      duration: const Duration(milliseconds: AuthConstants.passwordRevealAnimationMs),
      vsync: this,
    );

    _buttonPulseController = AnimationController(
      duration: const Duration(milliseconds: AuthConstants.buttonPulseAnimationMs),
      vsync: this,
    );

    // Setup animations
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

    _passwordRevealAnimation = Tween<double>(
      begin: AuthConstants.fadeBegin,
      end: AuthConstants.fadeEnd,
    ).animate(CurvedAnimation(
      parent: _passwordRevealController,
      curve: Curves.easeOutCubic,
    ));

    _buttonPulseAnimation = Tween<double>(
      begin: AuthConstants.pulseScaleBegin,
      end: AuthConstants.pulseScaleEnd,
    ).animate(CurvedAnimation(
      parent: _buttonPulseController,
      curve: Curves.easeInOut,
    ));

    // Setup listeners
    _emailController.addListener(_onEmailChanged);

    // Start animations
    _animationController.forward();
    _buttonPulseController.repeat(reverse: true);
  }

  void _onEmailChanged() {
    if (!mounted) return;

    final email = _emailController.text.trim();
    final isValidEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

    // Update both email validity and password field visibility in single setState
    if (isValidEmail != _isEmailValid || (isValidEmail && !_showPasswordField)) {
      if (mounted) {
        setState(() {
          _isEmailValid = isValidEmail;
          if (isValidEmail && !_showPasswordField) {
            _showPasswordField = true;
          }
        });

        // Handle password field animation and focus after state is set
        if (isValidEmail && _showPasswordField) {
          _passwordRevealController.forward().then((_) {
            // Auto-focus password field with slight delay
            if (mounted) {
              Future.delayed(
                const Duration(milliseconds: AuthConstants.quickFeedbackAnimationMs),
                () {
                  if (mounted) {
                    _passwordFocusNode.requestFocus();
                  }
                },
              );
            }
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _passwordRevealController.dispose();
    _buttonPulseController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with TossScaffold when widget is available
    return Scaffold(
      backgroundColor: TossColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // TODO: Replace with StorebaseAuthHeader when available
            _buildTemporaryHeader(),

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
                          const SizedBox(height: TossSpacing.space6),

                          _buildWelcomeSection(),

                          const SizedBox(height: TossSpacing.space8),

                          _buildEnhancedEmailField(),

                          AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOutCubic,
                            height: _showPasswordField ? null : 0,
                            child: _showPasswordField
                                ? Column(
                                    children: [
                                      const SizedBox(height: TossSpacing.space4),
                                      SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(0, -0.3),
                                          end: Offset.zero,
                                        ).animate(_passwordRevealAnimation),
                                        child: FadeTransition(
                                          opacity: _passwordRevealAnimation,
                                          child: _buildEnhancedPasswordField(),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ),

                          const SizedBox(height: TossSpacing.space3),

                          _buildForgotPasswordSection(),

                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),

                          AnimatedBuilder(
                            animation: _buttonPulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _showPasswordField && _isEmailValid
                                    ? _buttonPulseAnimation.value
                                    : 1.0,
                                child: _buildEnhancedLoginButton(),
                              );
                            },
                          ),

                          const SizedBox(height: TossSpacing.space4),

                          _buildSignupSection(),

                          const SizedBox(height: TossSpacing.space4),

                          _buildTrustIndicators(),

                          const SizedBox(height: TossSpacing.space8),
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

  // TODO: Temporary header until StorebaseAuthHeader widget is available
  Widget _buildTemporaryHeader() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space5),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: TossColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.store,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Storebase',
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.bold,
              color: TossColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back!',
          style: TossTextStyles.h1.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Text(
          'Sign in to your business command center',
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
            fontSize: AuthConstants.textSizeBodyLarge,
            height: AuthConstants.lineHeightStandard,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedEmailField() {
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
              TweenAnimationBuilder<double>(
                duration: const Duration(
                  milliseconds: AuthConstants.standardTransitionAnimationMs,
                ),
                tween: Tween(
                  begin: AuthConstants.fadeBegin,
                  end: AuthConstants.fadeEnd,
                ),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Icon(
                      Icons.check_circle,
                      size: AuthConstants.iconSizeStandard,
                      color: TossColors.success,
                    ),
                  );
                },
              ),
            ],
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
            boxShadow: _isEmailValid
                ? [
                    BoxShadow(
                      color: TossColors.success.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: _buildTextField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            hintText: AuthConstants.placeholderEmail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
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
        ),
      ],
    );
  }

  Widget _buildEnhancedPasswordField() {
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
            const SizedBox(width: TossSpacing.space2),
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        AuthConstants.borderRadiusStandard,
                      ),
                      border: Border.all(
                        color: TossColors.success.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.security,
                          size: 12,
                          color: TossColors.success,
                        ),
                        const SizedBox(width: TossSpacing.space1),
                        Text(
                          'Secure',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.success,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
            boxShadow: [
              BoxShadow(
                color: TossColors.primary.withOpacity(
                  AuthConstants.overlayOpacityMedium,
                ),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: _buildTextField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            hintText: AuthConstants.placeholderPassword,
            textInputAction: TextInputAction.done,
            obscureText: !_isPasswordVisible,
            onFieldSubmitted: (_) => _handleLogin(),
            suffixIcon: AnimatedSwitcher(
              duration: const Duration(
                milliseconds: AuthConstants.quickFeedbackAnimationMs,
              ),
              child: IconButton(
                key: ValueKey(_isPasswordVisible),
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: TossColors.textTertiary,
                  size: AuthConstants.iconSizeLarge,
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
                return AuthConstants.errorPasswordRequired;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  // TODO: Replace with TossTextField when widget is available
  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool obscureText = false,
    bool autocorrect = true,
    Widget? suffixIcon,
    void Function(String)? onFieldSubmitted,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      autocorrect: autocorrect,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      style: TossTextStyles.body,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TossTextStyles.body.copyWith(color: TossColors.textTertiary),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: TossColors.white,
        contentPadding: EdgeInsets.all(TossSpacing.space4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
          borderSide: BorderSide(color: TossColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
          borderSide: BorderSide(color: TossColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
          borderSide: BorderSide(color: TossColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
          borderSide: BorderSide(color: TossColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
          borderSide: BorderSide(color: TossColors.error, width: 2),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Trust indicator
        Row(
          children: [
            Icon(
              Icons.security_rounded,
              size: AuthConstants.iconSizeStandard,
              color: TossColors.success,
            ),
            const SizedBox(width: TossSpacing.space1),
            Text(
              AuthConstants.helperSecureLogin,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.success,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        // Forgot password
        TextButton(
          onPressed: () {
            // Stop animations before navigation
            _animationController.stop();
            _passwordRevealController.stop();
            _buttonPulseController.stop();

            // TODO: Navigate to forgot password page
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Forgot password page not yet implemented'),
              ),
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Forgot password?',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedLoginButton() {
    final canLogin = _isEmailValid &&
        _passwordController.text.isNotEmpty &&
        _showPasswordField;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
        boxShadow: canLogin
            ? [
                BoxShadow(
                  color: TossColors.primary.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: TossColors.primary.withOpacity(0.1),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ]
            : null,
      ),
      child: _buildPrimaryButton(
        text: _isLoading ? 'Signing in...' : AuthConstants.buttonSignIn,
        onPressed: _isLoading || !canLogin ? null : _handleLogin,
        isLoading: _isLoading,
        leadingIcon: _isLoading
            ? null
            : Icon(
                Icons.lock_rounded,
                size: AuthConstants.iconSizeMedium,
                color: TossColors.white,
              ),
      ),
    );
  }

  // TODO: Replace with TossPrimaryButton when widget is available
  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    Widget? leadingIcon,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: TossColors.primary,
          disabledBackgroundColor: TossColors.gray300,
          foregroundColor: TossColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(TossColors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leadingIcon != null) ...[
                    leadingIcon,
                    const SizedBox(width: 8),
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

  Widget _buildSignupSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'New to Storebase? ',
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () {
            // Navigate to signup page
            context.go('/auth/signup');
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Create account',
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
        spacing: TossSpacing.space4,
        children: [
          _buildTrustBadge(Icons.verified_user, 'Bank-level Security'),
          _buildTrustBadge(Icons.privacy_tip, 'GDPR Compliant'),
          _buildTrustBadge(Icons.cloud_done, 'Reliable Platform'),
        ],
      ),
    );
  }

  Widget _buildTrustBadge(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(AuthConstants.borderRadiusXL),
        border: Border.all(
          color: TossColors.borderLight,
          width: AuthConstants.borderWidthThin,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AuthConstants.iconSizeSmall,
            color: TossColors.success,
          ),
          const SizedBox(width: TossSpacing.space1),
          Text(
            text,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textSecondary,
              fontWeight: FontWeight.w500,
              fontSize: AuthConstants.textSizeMini,
            ),
          ),
        ],
      ),
    );
  }

  /// Handle login with Clean Architecture
  ///
  /// Changes from legacy:
  /// - Uses AuthService instead of EnhancedAuthProvider
  /// - All other logic preserved (FCM, App State, Navigation)
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // ✅ CLEAN ARCHITECTURE: Use AuthService
      final authService = ref.read(authServiceProvider);
      await authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      debugPrint('🔵 [Login] Sign-in successful, loading user data...');

      // ✅ Load user data immediately after login
      // This ensures AppState is populated before GoRouter redirect
      await ref.read(userCompaniesProvider.future);

      debugPrint('🔵 [Login] User data loaded, waiting for GoRouter auto-redirect...');

      // Register FCM token (optional, non-blocking)
      final productionTokenService = ProductionTokenService();
      productionTokenService.registerTokenForLogin().catchError((e) {
        if (kDebugMode) {
          debugPrint('⚠️ FCM token registration failed: $e');
        }
      });

      // Show success message
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: TossColors.white,
                size: AuthConstants.iconSizeLarge,
              ),
              const SizedBox(width: TossSpacing.space2),
              const Text('Welcome back to Storebase!'),
            ],
          ),
          backgroundColor: TossColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AuthConstants.borderRadiusStandard),
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      // That's it! GoRouter will automatically redirect based on:
      // - isAuthenticatedProvider (true)
      // - appState.user company count
      //
      // No manual navigation needed!
    } on ValidationException catch (e) {
      // Handle validation errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    e.message,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AuthConstants.borderRadiusStandard),
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } on InvalidCredentialsException catch (e) {
      // Handle invalid credentials
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    e.message,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AuthConstants.borderRadiusStandard),
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } on EmailNotVerifiedException catch (e) {
      // Handle email not verified
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.email_outlined, color: Colors.white, size: 20),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    e.message,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: TossColors.warning,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AuthConstants.borderRadiusStandard),
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
                const Icon(Icons.wifi_off, color: Colors.white, size: 20),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    'Connection issue. Please check your internet and try again.',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AuthConstants.borderRadiusStandard),
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
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    e.message,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AuthConstants.borderRadiusStandard),
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
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    'Unable to sign in. Please try again or contact support.',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AuthConstants.borderRadiusStandard),
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

}
