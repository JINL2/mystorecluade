import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/navigation/safe_navigation.dart';

/// MyFinance branded header for authentication pages
/// Provides consistent branding across all auth flows
class MyFinanceAuthHeader extends StatelessWidget {
  final bool showBackButton;
  final VoidCallback? onBack;
  final bool centerLogo;

  const MyFinanceAuthHeader({
    super.key,
    this.showBackButton = false,
    this.onBack,
    this.centerLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      decoration: BoxDecoration(
        color: TossColors.background,
        border: Border(
          bottom: BorderSide(
            color: TossColors.borderLight,
            width: 0.5,
          ),
        ),
      ),
      child: centerLogo 
        ? _buildCenteredLogo()
        : _buildLeftAlignedHeader(context),
    );
  }

  Widget _buildLeftAlignedHeader(BuildContext context) {
    return Row(
      children: [
        // Back button if requested
        if (showBackButton) ...[
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: TossColors.textPrimary,
              size: 20,
            ),
            onPressed: onBack ?? () {
              // Simple, safe back navigation
              if (context.mounted && context.canPop()) {
                context.safePop();
              } else if (context.mounted) {
                // If no route to pop, go to choose role
                context.safeGo('/onboarding/choose-role');
              }
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
        ],
        
        // MyFinance logo - horizontal version for auth
        SvgPicture.asset(
          'assets/images/logo_myfinance_horizontal.svg',
          height: 28,
          // Fallback in case SVG fails
          placeholderBuilder: (context) => Container(
            height: 28,
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.primary,
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Simple fallback "$" icon
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: TossColors.white,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                  ),
                  child: Center(
                    child: Text(
                      '\$',
                      style: TextStyle(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'MyFinance',
                  style: TextStyle(
                    color: TossColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const Spacer(),
        
        // Optional help/info button
        _buildHelpButton(context),
      ],
    );
  }

  Widget _buildCenteredLogo() {
    return Center(
      child: SvgPicture.asset(
        'assets/images/logo_myfinance_horizontal.svg',
        height: 32,
        // Fallback for centered version
        placeholderBuilder: (context) => Container(
          height: 32,
          padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          decoration: BoxDecoration(
            color: TossColors.primary,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: TossColors.white,
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Center(
                  child: Text(
                    '\$',
                    style: TextStyle(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'MyFinance',
                style: TextStyle(
                  color: TossColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.help_outline,
        color: TossColors.textTertiary,
        size: 20,
      ),
      onPressed: () {
        // Show help bottom sheet or navigate to help page
        showModalBottomSheet(
          context: context,
          backgroundColor: TossColors.transparent,
          builder: (context) => Container(
            decoration: BoxDecoration(
              color: TossColors.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: EdgeInsets.all(TossSpacing.space5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: TossColors.gray300,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                  ),
                ),
                const SizedBox(height: TossSpacing.space4),
                
                // Help content
                Row(
                  children: [
                    Icon(
                      Icons.support_agent,
                      color: TossColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: TossSpacing.space3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Need help?',
                            style: TextStyle(
                              color: TossColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space1),
                          Text(
                            'Contact our support team for assistance with your account',
                            style: TextStyle(
                              color: TossColors.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: TossSpacing.space4),
                
                // Support actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Navigate to contact page or open email
                          if (context.mounted) {
                            context.safePop();
                          }
                          // Add contact action here
                        },
                        icon: Icon(Icons.email_outlined, size: 18),
                        label: Text('Email Support'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: TossColors.primary,
                          side: BorderSide(color: TossColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space3),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to FAQ or help center
                          if (context.mounted) {
                            context.safePop();
                          }
                          // Add FAQ navigation here
                        },
                        icon: Icon(Icons.help_center_outlined, size: 18),
                        label: Text('Help Center'),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: TossSpacing.space2),
              ],
            ),
          ),
        );
      },
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 32,
        minHeight: 32,
      ),
    );
  }
}

/// Welcome screen specific header with larger logo presence
class MyFinanceWelcomeHeader extends StatelessWidget {
  const MyFinanceWelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(TossSpacing.space6),
      child: Column(
        children: [
          // Large icon for brand recognition
          SvgPicture.asset(
            'assets/images/logo_myfinance_icon.svg',
            width: 80,
            height: 80,
            // Fallback for large icon
            placeholderBuilder: (context) => Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: TossColors.primary,
                borderRadius: BorderRadius.circular(TossBorderRadius.xl),
              ),
              child: Center(
                child: Text(
                  '\$',
                  style: TextStyle(
                    color: TossColors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 32,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: TossSpacing.space4),
          
          // Wordmark
          Text(
            'MyFinance',
            style: TextStyle(
              color: TossColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 32,
              letterSpacing: -0.8,
            ),
          ),
          
          const SizedBox(height: TossSpacing.space2),
          
          // Tagline
          Text(
            'Your personal finance manager',
            style: TextStyle(
              color: TossColors.textSecondary,
              fontWeight: FontWeight.w500,
              fontSize: 18,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}