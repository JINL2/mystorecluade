import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Core - Themes
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';

// Core - Navigation

// App - Providers

// Auth - Services (Clean Architecture)

/// Choose Role Page - Clean Architecture Version
///
/// Simple page for users to choose their role after signup:
/// - Create Business (start a new company)
/// - Join Business (have a business code)
///
/// Features:
/// - Clean, card-based UI
/// - Help dialog explaining options
/// - Sign in option for existing users (with logout)
/// - Navigation lock to prevent double-tap
///
/// Architecture:
/// - Minimal business logic (mostly UI)
/// - Uses appStateProvider for state clearing
/// - Uses safe navigation for routing
class ChooseRolePage extends ConsumerStatefulWidget {
  const ChooseRolePage({super.key});

  @override
  ConsumerState<ChooseRolePage> createState() => _ChooseRolePageState();
}

class _ChooseRolePageState extends ConsumerState<ChooseRolePage> {
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _isNavigating = false;
  }

  @override
  Widget build(BuildContext context) {
    // Temporary TossScaffold implementation
    return Scaffold(
      backgroundColor: TossColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Storebase Logo
              Row(
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
                      color: TossColors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Text(
                    'Storebase',
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TossColors.textPrimary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Welcome Message
              Text(
                'Welcome to Storebase! 🎉',
                style: TossTextStyles.h1.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TossColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: TossSpacing.space4),

              Text(
                'How would you like to get started?',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 60),

              // Create Business Card
              _buildActionCard(
                context: context,
                title: 'Create Business',
                subtitle: 'I want to start a new business',
                icon: Icons.business,
                color: TossColors.primary,
                onTap: () => _navigateToPage('/onboarding/create-business'),
              ),

              const SizedBox(height: 20),

              // Join Business Card
              _buildActionCard(
                context: context,
                title: 'Join Business',
                subtitle: 'I have a business code',
                icon: Icons.group_add,
                color: TossColors.success,
                onTap: () => _navigateToPage('/onboarding/join-business'),
              ),

              const SizedBox(height: 60),

              // Help Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.help_outline,
                    color: TossColors.textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Text(
                    'Not sure which to choose?',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      _showHelpDialog(context);
                    },
                    child: Text(
                      'Learn more',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // Navigation Logic
  // ==========================================

  void _navigateToPage(String route) {
    if (_isNavigating || !mounted) return;

    setState(() {
      _isNavigating = true;
    });

    // Use safeGo instead of safePush to avoid navigation stack issues
    context.go(route);

    // Reset navigation state after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
      }
    });
  }

  // ==========================================
  // UI Components
  // ==========================================

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space6),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: TossColors.gray200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: TossColors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TossTextStyles.h3.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TossColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                color: TossColors.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Getting Started'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Choose "Create Business" if you\'re starting a new company'),
            SizedBox(height: TossSpacing.space2),
            Text('• Choose "Join Business" if you have a business code from your employer'),
            SizedBox(height: TossSpacing.space2),
            Text('• You can always change this later in settings'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
