import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Core - Constants
import '../../../../core/constants/auth_constants.dart';
// Shared - Theme System
import '../../../../shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
// Auth Providers
import '../providers/auth_service.dart';
import '../../../homepage/presentation/providers/homepage_providers.dart';

/// Auth Welcome Page - 2025 Modern Design
///
/// Clean, minimal landing page for authentication.
/// - Large centered logo
/// - Social login buttons (Google, Apple)
/// - Links to email sign-in and sign-up
///
/// Navigation:
/// - "Continue with Google" → Google OAuth (TODO)
/// - "Continue with Apple" → Apple OAuth (TODO)
/// - "Sign in with email" → /auth/login
/// - "Create account" → /auth/signup
class AuthWelcomePage extends ConsumerStatefulWidget {
  const AuthWelcomePage({super.key});

  @override
  ConsumerState<AuthWelcomePage> createState() => _AuthWelcomePageState();
}

class _AuthWelcomePageState extends ConsumerState<AuthWelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Loading states
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: TossAnimations.normal,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TossAnimations.standard,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TossAnimations.standard,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4 * 2),
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Logo Section
                  _buildLogoSection(),

                  const Spacer(flex: 2),

                  // Social Login Buttons
                  _buildSocialLoginButtons(),

                  const SizedBox(height: TossSpacing.space5),

                  // Email Sign In Link
                  _buildEmailSignInButton(),

                  const Spacer(flex: 1),

                  // Sign Up Section
                  _buildSignupSection(),

                  const SizedBox(height: TossSpacing.space8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Large App Logo
        ClipRRect(
          borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
          child: Image.asset(
            'assets/images/app icon.png',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(height: TossSpacing.space5),

        // App Name
        Text(
          'Storebase',
          style: TossTextStyles.h1.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 32,
            letterSpacing: -0.8,
          ),
        ),

        const SizedBox(height: TossSpacing.space2),

        // Tagline
        Text(
          'All your business needs,\non a smarter base.',
          textAlign: TextAlign.center,
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLoginButtons() {
    return Column(
      children: [
        // Google Sign In Button
        _buildSocialButton(
          onPressed: _isGoogleLoading || _isAppleLoading ? null : _handleGoogleSignIn,
          icon: _isGoogleLoading
              ? TossLoadingView.inline(size: 22, color: TossColors.gray500)
              : _buildGoogleIcon(),
          label: _isGoogleLoading ? 'Signing in...' : 'Continue with Google',
          backgroundColor: TossColors.white,
          textColor: TossColors.textPrimary,
          borderColor: TossColors.gray300,
        ),

        const SizedBox(height: TossSpacing.space3),

        // Apple Sign In Button
        _buildSocialButton(
          onPressed: _isAppleLoading || _isGoogleLoading ? null : _handleAppleSignIn,
          icon: _isAppleLoading
              ? TossLoadingView.inline(size: 24, color: TossColors.white)
              : const Icon(
                  Icons.apple,
                  size: TossSpacing.iconLG,
                  color: TossColors.white,
                ),
          label: _isAppleLoading ? 'Signing in...' : 'Continue with Apple',
          backgroundColor: TossColors.black,
          textColor: TossColors.white,
          borderColor: TossColors.black,
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required VoidCallback? onPressed,
    required Widget icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required Color borderColor,
  }) {
    return TossButton.outlined(
      text: label,
      onPressed: onPressed,
      leadingIcon: icon,
      fullWidth: true,
      height: TossSpacing.icon3XL,
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderColor: borderColor,
    );
  }

  Widget _buildEmailSignInButton() {
    return TossButton.textButton(
      text: 'Sign in with email',
      onPressed: () => context.push('/auth/login'),
      leadingIcon: const Icon(Icons.mail_outline_rounded, size: TossSpacing.iconMD),
      fontWeight: FontWeight.w600,
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
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
        TossButton.textButton(
          text: 'Create account',
          onPressed: () => context.push('/auth/signup'),
          padding: EdgeInsets.zero,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }

  Widget _buildGoogleIcon() {
    return Image.asset(
      'assets/images/google_logo.png',
      width: 22,
      height: 22,
    );
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isGoogleLoading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithGoogle();

      // Load user data
      await ref.read(userCompaniesProvider.future);

      // 🔧 FCM token registration is now handled automatically by ProductionTokenService
      // via onAuthStateChange listener - no manual call needed

      // Show success message
      if (!mounted) return;

      TossToast.success(context, 'Welcome to Storebase!');
    } catch (e) {
      // Handle Google Sign-In errors
      if (mounted) {
        final errorMessage = e.toString().contains('cancelled')
            ? 'Google Sign-In was cancelled'
            : 'Unable to sign in with Google. Please try again.';

        TossToast.error(context, errorMessage);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() {
      _isAppleLoading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithApple();

      // Load user data
      await ref.read(userCompaniesProvider.future);

      // 🔧 FCM token registration is now handled automatically by ProductionTokenService
      // via onAuthStateChange listener - no manual call needed

      // Show success message
      if (!mounted) return;

      TossToast.success(context, 'Welcome to Storebase!');
    } catch (e) {
      // Handle Apple Sign-In errors
      if (mounted) {
        final errorMessage = e.toString().contains('cancelled')
            ? 'Apple Sign-In was cancelled'
            : 'Unable to sign in with Apple. Please try again.';

        TossToast.error(context, errorMessage);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAppleLoading = false;
        });
      }
    }
  }
}

