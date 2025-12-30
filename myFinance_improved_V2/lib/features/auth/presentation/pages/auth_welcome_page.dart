import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Core - Constants
import '../../../../core/constants/auth_constants.dart';
// Shared - Theme System
import '../../../../shared/themes/index.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(TossColors.gray500),
                  ),
                )
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
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(TossColors.white),
                  ),
                )
              : const Icon(
                  Icons.apple,
                  size: 24,
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
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(color: borderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: TossSpacing.space3),
            Text(
              label,
              style: TossTextStyles.body.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailSignInButton() {
    return TextButton(
      onPressed: () {
        context.push('/auth/login');
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mail_outline_rounded,
            size: 20,
            color: TossColors.primary,
          ),
          const SizedBox(width: TossSpacing.space2),
          Text(
            'Sign in with email',
            style: TossTextStyles.body.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
            context.push('/auth/signup');
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(
                Icons.check_circle,
                color: TossColors.white,
                size: 20,
              ),
              SizedBox(width: TossSpacing.space2),
              Text('Welcome to Storebase!'),
            ],
          ),
          backgroundColor: TossColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Handle Google Sign-In errors
      if (mounted) {
        final errorMessage = e.toString().contains('cancelled')
            ? 'Google Sign-In was cancelled'
            : 'Unable to sign in with Google. Please try again.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: TossColors.white, size: 20),
                const SizedBox(width: TossSpacing.space2),
                Expanded(child: Text(errorMessage)),
              ],
            ),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
            ),
            duration: const Duration(seconds: 4),
          ),
        );
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(
                Icons.check_circle,
                color: TossColors.white,
                size: 20,
              ),
              SizedBox(width: TossSpacing.space2),
              Text('Welcome to Storebase!'),
            ],
          ),
          backgroundColor: TossColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Handle Apple Sign-In errors
      if (mounted) {
        final errorMessage = e.toString().contains('cancelled')
            ? 'Apple Sign-In was cancelled'
            : 'Unable to sign in with Apple. Please try again.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: TossColors.white, size: 20),
                const SizedBox(width: TossSpacing.space2),
                Expanded(child: Text(errorMessage)),
              ],
            ),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
            ),
            duration: const Duration(seconds: 4),
          ),
        );
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

