import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_animations.dart';
import '../../widgets/toss/toss_primary_button.dart';
import '../../widgets/toss/toss_text_field.dart';
import '../../widgets/auth/storebase_auth_header.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../providers/enhanced_auth_provider.dart';
import '../../providers/app_state_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/auth_constants.dart';
import '../../../core/navigation/safe_navigation.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  
  late AnimationController _animationController;
  late AnimationController _passwordRevealController;
  late AnimationController _buttonPulseController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _passwordRevealAnimation;
  late Animation<double> _buttonPulseAnimation;
  
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _showPasswordField = false;
  bool _isEmailValid = false;

  @override
  void initState() {
    super.initState();
    
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
    
    _emailController.addListener(_onEmailChanged);
    
    _animationController.forward();
    
    _buttonPulseController.repeat(reverse: true);
  }
  
  void _onEmailChanged() {
    if (!mounted) return;
    
    final email = _emailController.text.trim();
    final isValidEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    
    if (isValidEmail != _isEmailValid) {
      if (mounted) {
        setState(() {
          _isEmailValid = isValidEmail;
        });
      }
      
      // Progressive disclosure: Show password field when email is valid
      if (isValidEmail && !_showPasswordField) {
        if (mounted) {
          setState(() {
            _showPasswordField = true;
          });
          _passwordRevealController.forward().then((_) {
            // Auto-focus password field with slight delay
            if (mounted) {
              Future.delayed(const Duration(milliseconds: AuthConstants.quickFeedbackAnimationMs), () {
                if (mounted) {
                  _passwordFocusNode.requestFocus();
                }
              });
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
                duration: const Duration(milliseconds: AuthConstants.standardTransitionAnimationMs),
                tween: Tween(begin: AuthConstants.fadeBegin, end: AuthConstants.fadeEnd),
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
          child: TossTextField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            hintText: AuthConstants.placeholderEmail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autocorrect: false,
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
                      borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
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
                color: TossColors.primary.withOpacity(AuthConstants.overlayOpacityMedium),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TossTextField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            hintText: AuthConstants.placeholderPassword,
            textInputAction: TextInputAction.done,
            obscureText: !_isPasswordVisible,
            onFieldSubmitted: (_) => _handleLogin(),
            suffixIcon: AnimatedSwitcher(
              duration: const Duration(milliseconds: AuthConstants.quickFeedbackAnimationMs),
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
            
            context.safeGo('/auth/forgot-password');
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
    final canLogin = _isEmailValid && _passwordController.text.isNotEmpty && _showPasswordField;
    
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
      child: TossPrimaryButton(
        text: _isLoading 
            ? 'Signing in...' 
            : AuthConstants.buttonSignIn,
        onPressed: _isLoading || !canLogin ? null : _handleLogin,
        isLoading: _isLoading,
        fullWidth: true,
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
            
            // Ensure animations are cancelled before navigation
            _animationController.stop();
            _passwordRevealController.stop();
            _buttonPulseController.stop();
            
            // Use router navigation for consistency
            context.safePush('/auth/signup');
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            AuthConstants.buttonCreateAccount,
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

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // STEP 1: Sign in and get user ID
      final enhancedAuth = ref.read(enhancedAuthProvider);
      await enhancedAuth.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      // STEP 2: IMMEDIATELY fetch user data BEFORE router can react
      // This is critical - we need the data BEFORE any navigation happens
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;
      
      if (userId == null) {
        throw Exception('Sign-in succeeded but no user ID found');
      }
      
      // Fetch user data and categories immediately after sign-in
      
      // STEP 3: Fetch companies and categories in parallel
      // Do this BEFORE showing success message to ensure data is ready
      List<dynamic> results;
      try {
        results = await Future.wait([
          supabase.rpc(
            'get_user_companies_and_stores',
            params: {'p_user_id': userId},
          ),
          supabase.rpc('get_categories_with_features'),
        ]);
      } catch (apiError) {
        rethrow;
      }
      
      final userResponse = results[0];
      final categoriesResponse = results[1];
      
      // Validate API response
      if (userResponse == null) {
        throw Exception('API returned null response');
      }
      
      // STEP 4: Save to app state IMMEDIATELY
      // Critical: Save data before any navigation or UI updates
      if (!mounted) return;
      
      await ref.read(appStateProvider.notifier).setUser(userResponse);
      await ref.read(appStateProvider.notifier).setCategoryFeatures(categoriesResponse);
      
      // Get company count for navigation decision
      final companyCount = userResponse is Map ? (userResponse['company_count'] ?? 0) : 0;
      
      // Note: Do NOT auto-select company/store for returning users
      // Let them keep their previous selections (persistence)
      
      // STEP 5: NOW show success message (data is already saved)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: TossColors.white, size: AuthConstants.iconSizeLarge),
                const SizedBox(width: TossSpacing.space2),
                Text('Welcome back to Storebase!'),
              ],
            ),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
            ),
          ),
        );
        
        // STEP 6: Navigate based on complete data
        // Data is already in app state, so router will see correct company count
        if (companyCount > 0) {
          context.safeGo('/');
        } else {
          context.safeGo('/onboarding/choose-role');
        }
      }
    } catch (e) {
      // Show professional error message
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
              borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
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
    // Convert technical errors to user-friendly messages
    if (error.contains('invalid-credentials') || error.contains('wrong-password')) {
      return 'Email or password is incorrect. Please try again.';
    } else if (error.contains('user-not-found')) {
      return 'No account found with this email address.';
    } else if (error.contains('too-many-requests')) {
      return 'Too many attempts. Please try again later.';
    } else if (error.contains('network')) {
      return 'Connection issue. Please check your internet and try again.';
    } else {
      return 'Unable to sign in. Please try again or contact support.';
    }
  }
}