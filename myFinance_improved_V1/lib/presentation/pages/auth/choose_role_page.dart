import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../../core/navigation/safe_navigation.dart';

/// Simple, robust Choose Role page without complex layouts
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
    return TossScaffold(
      backgroundColor: TossColors.background,
      resizeToAvoidBottomInset: true, // Ensure keyboard handling
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: TossColors.primary,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
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
              
              const SizedBox(height: 40),
              
              Text(
                'Welcome to Storebase! 🎉',
                style: TossTextStyles.h1.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TossColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              Text(
                'How would you like to get started?',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 60),
              
              _buildActionCard(
                context: context,
                title: 'Create Business',
                subtitle: 'I want to start a new business',
                icon: Icons.business,
                color: TossColors.primary,
                onTap: () => _navigateToPage('/onboarding/create-business'),
              ),
              
              const SizedBox(height: 20),
              
              _buildActionCard(
                context: context,
                title: 'Join Business',
                subtitle: 'I have a business code',
                icon: Icons.group_add,
                color: TossColors.success,
                onTap: () => _navigateToPage('/onboarding/join-business'),
              ),
              
              const SizedBox(height: 60),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.help_outline,
                    color: TossColors.textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
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
              
              // Sign in option for existing users
              const Divider(color: TossColors.gray200),
              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () async {
                      // Sign out first to clear authentication, then navigate to login
                      try {
                        final supabase = Supabase.instance.client;
                        await supabase.auth.signOut();
                        
                        // Clear app state
                        await ref.read(appStateProvider.notifier).clearData();
                        
                        // Now navigate to login page
                        if (context.mounted) {
                          context.safeGo('/auth/login');
                        }
                      } catch (e) {
                        // If sign out fails, still try to navigate
                        if (context.mounted) {
                          context.safeGo('/auth/login');
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Go to Sign In',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  
  void _navigateToPage(String route) {
    if (_isNavigating || !mounted) return;
    
    setState(() {
      _isNavigating = true;
    });
    
    context.safePush(route).whenComplete(() {
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
      }
    });
  }
  
  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
            border: Border.all(
              color: TossColors.gray200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
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
            SizedBox(height: 8),
            Text('• Choose "Join Business" if you have a business code from your employer'),
            SizedBox(height: 8),
            Text('• You can always change this later in settings'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}