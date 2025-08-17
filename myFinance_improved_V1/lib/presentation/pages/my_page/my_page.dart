import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_animations.dart';
import '../../../core/themes/toss_shadows.dart';
import '../../../core/constants/ui_constants.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/common/toss_profile_avatar.dart';
import '../../widgets/common/toss_subscription_card.dart';
import 'package:go_router/go_router.dart';
import 'providers/user_profile_provider.dart';
import '../../../domain/entities/user_profile.dart';
import 'widgets/edit_profile_sheet.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> 
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _entryController.forward();
  }

  void _setupAnimations() {
    _entryController = AnimationController(
      duration: TossAnimations.slower,
      vsync: this,
    );

    // Staggered animations for different sections
    _animations = [
      // Header animation
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0.0, 0.3, curve: Curves.easeOutCubic),
        ),
      ),
      // Stats animation
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0.15, 0.45, curve: Curves.easeOutCubic),
        ),
      ),
      // Cards animation
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0.3, 0.6, curve: Curves.easeOutCubic),
        ),
      ),
      // Timeline animation
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0.45, 0.75, curve: Curves.easeOutCubic),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final profileError = ref.watch(profileErrorProvider);
    
    // Show error snackbar if there's an error
    if (profileError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $profileError'),
            backgroundColor: TossColors.error,
            action: SnackBarAction(
              label: 'Retry',
              textColor: TossColors.surface,
              onPressed: () {
                ref.read(userProfileProvider.notifier).refreshProfile();
              },
            ),
          ),
        );
        ref.read(userProfileProvider.notifier).clearError();
      });
    }
    
    return Scaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar(
        title: 'My Page',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
          color: TossColors.gray700,
        ),
        secondaryActionIcon: Icons.settings_outlined,
        onSecondaryAction: () {
          HapticFeedback.lightImpact();
          // Navigate to settings
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          HapticFeedback.lightImpact();
          await ref.read(userProfileProvider.notifier).refreshProfile();
        },
        color: TossColors.primary,
        child: CustomScrollView(
          slivers: [
            // Profile Header
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _animations[0],
                child: SlideTransition(
                  position: _animations[0].drive(
                    Tween(begin: const Offset(0, 0.2), end: Offset.zero),
                  ),
                  child: _buildProfileHeader(),
                ),
              ),
            ),
            
            // Subscription Status
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _animations[1],
                child: SlideTransition(
                  position: _animations[1].drive(
                    Tween(begin: const Offset(0, 0.2), end: Offset.zero),
                  ),
                  child: _buildSubscriptionSection(),
                ),
              ),
            ),
            
            // Action Cards Grid
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _animations[2],
                child: ScaleTransition(
                  scale: _animations[2].drive(
                    Tween(begin: 0.9, end: 1.0),
                  ),
                  child: _buildActionCards(),
                ),
              ),
            ),
            
            // Settings List
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _animations[3],
                child: _buildSettingsList(),
              ),
            ),
            
            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: TossSpacing.space10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final profileState = ref.watch(userProfileProvider);
    final profile = profileState.profile;
    
    if (profileState.isLoading) {
      return Container(
        padding: EdgeInsets.all(TossSpacing.space5),
        margin: EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.circular(UIConstants.borderRadiusLarge),
          boxShadow: TossShadows.card,
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space5),
      margin: EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(UIConstants.borderRadiusLarge),
        boxShadow: TossShadows.card,
      ),
      child: Row(
        children: [
          // Avatar
          TossProfileAvatarVariants.large(
            imageUrl: profile?.profileImage,
            initials: profile?.initials ?? 'U',
            onTap: () {
              HapticFeedback.lightImpact();
              _showEditProfileSheet();
            },
          ),
          SizedBox(width: TossSpacing.space4),
          
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile?.fullName ?? 'Loading...',
                  style: TossTextStyles.h2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: TossSpacing.space1),
                Text(
                  profile?.displayRole ?? 'User',
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.1,
                  ),
                ),
                SizedBox(height: TossSpacing.space1),
                Row(
                  children: [
                    Icon(
                      Icons.store,
                      size: 14,
                      color: TossColors.gray500,
                    ),
                    SizedBox(width: TossSpacing.space1),
                    Expanded(
                      child: Text(
                        '${profile?.displayCompany ?? "No Company"} - ${profile?.displayStore ?? "No Store"}',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Edit Button
          Container(
            width: UIConstants.profileEditIconSize,
            height: UIConstants.profileEditIconSize,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(UIConstants.borderRadiusSmall),
            ),
            child: IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                HapticFeedback.lightImpact();
                _showEditProfileSheet();
              },
              color: TossColors.gray600,
              iconSize: UIConstants.profileEditIconInnerSize,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildActionCards() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.textPrimary,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: TossSpacing.space3,
            crossAxisSpacing: TossSpacing.space3,
            childAspectRatio: UIConstants.quickActionsAspectRatio,
            children: [
              _buildActionCard(
                'Personal Info',
                'Edit your profile',
                Icons.person_outline,
                TossColors.primary,
                () {},
              ),
              _buildActionCard(
                'Security',
                'Password & 2FA',
                Icons.security,
                TossColors.success,
                () {},
              ),
              _buildActionCard(
                'Preferences',
                'App settings',
                Icons.settings,
                TossColors.warning,
                () {},
              ),
              _buildActionCard(
                'Payment',
                'Cards & accounts',
                Icons.credit_card,
                TossColors.error,
                () {},
              ),
              _buildActionCard(
                'Activity',
                'Login history',
                Icons.history,
                TossColors.textSecondary,
                () {},
              ),
              _buildActionCard(
                'Support',
                'Help & FAQ',
                Icons.help_outline,
                TossColors.primary,
                () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, 
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
          boxShadow: TossShadows.card,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: UIConstants.featureIconContainerSize,
              height: UIConstants.featureIconContainerSize,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(UIConstants.borderRadiusSmall),
              ),
              child: Icon(icon, color: color, size: UIConstants.featureIconSize),
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              title,
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionSection() {
    final profile = ref.watch(currentUserProfileProvider);
    
    if (profile?.isSubscriptionActive == true) {
      return TossSubscriptionCardVariants.active(
        planName: profile?.subscriptionPlan ?? UIConstants.planFree,
        planDescription: 'Store Management ${profile?.subscriptionPlan ?? "Basic"}',
        expiresAt: profile?.subscriptionExpiresAt ?? DateTime.now().add(const Duration(days: 30)),
        onManageTap: () {
          HapticFeedback.lightImpact();
          // Navigate to subscription management
        },
      );
    } else {
      return TossSubscriptionCardVariants.inactive(
        planName: profile?.subscriptionPlan ?? UIConstants.planFree,
        planDescription: 'Store Management Basic',
        expiresAt: profile?.subscriptionExpiresAt,
        onManageTap: () {
          HapticFeedback.lightImpact();
          // Navigate to subscription management
        },
      );
    }
  }

  Widget _buildSettingsList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.textPrimary,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          _buildSettingsItem(
            'Store Configuration',
            'Business hours, locations',
            Icons.store,
            () {},
          ),
          _buildSettingsItem(
            'Financial Settings',
            'Currency, tax rates',
            Icons.attach_money,
            () {},
          ),
          _buildSettingsItem(
            'Employee Management',
            'Roles, permissions',
            Icons.people,
            () {},
          ),
          _buildSettingsItem(
            'Notifications',
            'Alerts, reminders',
            Icons.notifications_outlined,
            () {},
          ),
          _buildSettingsItem(
            'Data & Privacy',
            'Backup, security',
            Icons.security,
            () {},
          ),
          _buildSettingsItem(
            'Help & Support',
            'FAQ, contact us',
            Icons.help_outline,
            () {},
          ),
          _buildSettingsItem(
            'About',
            'Version 1.2.0',
            Icons.info_outline,
            () {},
            showArrow: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool showArrow = true,
  }) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: TossSpacing.space3,
            horizontal: TossSpacing.space1,
          ),
          child: Row(
            children: [
              Container(
                width: UIConstants.featureIconContainerSize,
                height: UIConstants.featureIconContainerSize,
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(UIConstants.borderRadiusSmall),
                ),
                child: Icon(
                  icon,
                  size: UIConstants.iconSizeMedium,
                  color: TossColors.gray600,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w500,
                        color: TossColors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (showArrow)
                Icon(
                  Icons.chevron_right,
                  size: UIConstants.iconSizeMedium,
                  color: TossColors.gray400,
                ),
            ],
          ),
        ),
      ),
    );
  }

  
  void _showEditProfileSheet() {
    final profile = ref.read(currentUserProfileProvider);
    if (profile == null) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: EditProfileSheet(profile: profile),
      ),
    );
  }
  
  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }
}