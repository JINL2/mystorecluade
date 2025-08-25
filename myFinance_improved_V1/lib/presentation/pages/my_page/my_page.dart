import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_animations.dart';
import '../../../core/themes/toss_shadows.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/constants/ui_constants.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_profile_avatar.dart';
import '../../widgets/common/toss_white_card.dart';
import '../../widgets/common/toss_section_header.dart';
import '../../widgets/common/toss_empty_state_card.dart';
import '../../widgets/toss/toss_card.dart';
import '../../widgets/toss/toss_list_tile.dart';
import 'providers/user_profile_provider.dart';
import 'providers/dashboard_stats_provider.dart';
import 'widgets/edit_profile_sheet.dart';
import '../../../domain/entities/user_profile.dart';

/// Enhanced MyPage with real data integration and modern UI/UX
/// Features: Real user profiles, live stats, profile photo editing
class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> 
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late ScrollController _scrollController;
  late List<Animation<double>> _animations;
  
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _setupAnimations();
    _entryController.forward();
    
    // Load user profile and stats on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProfileProvider.notifier).refreshProfile();
      ref.read(dashboardStatsProvider.notifier).refreshStats();
    });
  }

  void _setupAnimations() {
    _entryController = AnimationController(
      duration: Duration(milliseconds: UIConstants.extendedAnimationMs),
      vsync: this,
    );

    // Enhanced staggered animations
    _animations = [
      // Header with bounce effect
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0.0, 0.3, curve: Curves.easeOutCubic),
        ),
      ),
      // Stats with elastic
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0.1, 0.4, curve: Curves.easeOutCubic),
        ),
      ),
      // Cards with scale
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic),
        ),
      ),
      // Timeline cascade
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final dashboardStats = ref.watch(dashboardStatsProvider);
    
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      body: RefreshIndicator(
        onRefresh: () async {
          HapticFeedback.lightImpact();
          await Future.wait([
            ref.read(userProfileProvider.notifier).refreshProfile(),
            ref.read(dashboardStatsProvider.notifier).refreshStats(),
          ]);
        },
        color: TossColors.primary,
        displacement: 80,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            // Modern App Bar with better visual hierarchy
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: TossColors.gray100.withOpacity(0.95),
              surfaceTintColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        TossColors.primary.withOpacity(0.08),
                        TossColors.gray100,
                      ],
                    ),
                  ),
                ),
              ),
              title: Text(
                'My Profile',
                style: TossTextStyles.h2.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: TossColors.gray200.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  context.pop();
                },
                color: TossColors.gray700,
              ),
              actions: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: TossColors.gray200.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.settings_outlined, size: 18),
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    // Navigate to settings
                  },
                  color: TossColors.gray700,
                ),
                SizedBox(width: TossSpacing.space3),
              ],
            ),
            
            // Enhanced Profile Header with real data
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _scrollController,
                builder: (context, child) {
                  final offset = _scrollController.hasClients
                      ? _scrollController.offset * 0.5
                      : 0.0;
                  return Transform.translate(
                    offset: Offset(0, -offset.clamp(0.0, 30.0)),
                    child: child,
                  );
                },
                child: FadeTransition(
                  opacity: _animations[0],
                  child: SlideTransition(
                    position: _animations[0].drive(
                      Tween(begin: const Offset(0, 0.2), end: Offset.zero),
                    ),
                    child: _buildModernProfileHeader(userProfile),
                  ),
                ),
              ),
            ),
            
            // Enhanced Quick Stats with real data
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _animations[1],
                child: SlideTransition(
                  position: _animations[1].drive(
                    Tween(begin: const Offset(0, 0.15), end: Offset.zero),
                  ),
                  child: _buildModernQuickStats(dashboardStats),
                ),
              ),
            ),
            
            // Enhanced Action Cards with better interactions
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _animations[2],
                child: ScaleTransition(
                  scale: _animations[2].drive(
                    Tween(begin: 0.85, end: 1.0),
                  ),
                  child: _buildEnhancedActionCards(),
                ),
              ),
            ),
            
            // Enhanced Activity Timeline with real data
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _animations[3],
                child: _buildModernActivityTimeline(dashboardStats),
              ),
            ),
            
            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernProfileHeader(UserProfileState userProfileState) {
    final profile = userProfileState.profile;
    final isLoading = userProfileState.isLoading;
    
    if (isLoading) {
      return Container(
        height: 140,
        margin: EdgeInsets.symmetric(
          horizontal: TossSpacing.space5,
          vertical: TossSpacing.space4,
        ),
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: CircularProgressIndicator(color: TossColors.primary),
        ),
      );
    }
    
    if (profile == null) {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: TossSpacing.space5,
          vertical: TossSpacing.space4,
        ),
        padding: EdgeInsets.all(TossSpacing.space6),
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          'Unable to load profile',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),
      );
    }
    
    return TossWhiteCard(
      padding: EdgeInsets.all(TossSpacing.space6),
      margin: EdgeInsets.symmetric(
        horizontal: TossSpacing.space5,
        vertical: TossSpacing.space4,
      ),
      borderRadius: 24,
      child: Row(
        children: [
          // Modern Avatar with profile image support
          _buildModernAvatar(profile),
          SizedBox(width: TossSpacing.space5),
          
          // User Info with real data
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.fullName,
                  style: TossTextStyles.h2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                    letterSpacing: -0.4,
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: TossSpacing.space1),
                if (profile.displayRole != 'User')
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      profile.displayRole,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.1,
                        fontSize: 11,
                      ),
                    ),
                  ),
                if (profile.displayRole != 'User') 
                  SizedBox(height: TossSpacing.space1),
                Text(
                  profile.displayCompany,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                    letterSpacing: -0.1,
                    fontSize: 13,
                  ),
                ),
                if (profile.displayStore != 'No Store Assigned')
                  Text(
                    profile.displayStore,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray400,
                      letterSpacing: -0.1,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          
          // Enhanced Edit Button with modern design
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                HapticFeedback.lightImpact();
                _showEditProfileSheet(profile);
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: TossColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: TossColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.edit_rounded,
                  color: TossColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernAvatar(UserProfile profile) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showEditProfileSheet(profile);
      },
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              TossColors.primary,
              TossColors.primary.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: TossColors.primary.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: TossColors.surface,
            ),
            child: ClipOval(
              child: profile.hasProfileImage
                  ? Image.network(
                      profile.profileImage!,
                      width: 84,
                      height: 84,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildAvatarFallback(profile);
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            color: TossColors.gray100,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: TossColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                    )
                  : _buildAvatarFallback(profile),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildAvatarFallback(UserProfile profile) {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            TossColors.primary.withOpacity(0.1),
            TossColors.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          profile.initials,
          style: TossTextStyles.h1.copyWith(
            color: TossColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 28,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildModernQuickStats(DashboardStats stats) {
    if (stats.isLoading) {
      return Container(
        height: 120,
        margin: EdgeInsets.symmetric(vertical: TossSpacing.space4),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
          itemCount: 4,
          itemBuilder: (context, index) => Container(
            width: 160,
            margin: EdgeInsets.only(right: TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: CircularProgressIndicator(color: TossColors.primary),
            ),
          ),
        ),
      );
    }

    if (stats.error != null) {
      return Container(
        height: 100,
        margin: EdgeInsets.symmetric(vertical: TossSpacing.space4),
        padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
        child: Container(
          decoration: BoxDecoration(
            color: TossColors.error.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: TossColors.error.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              'Unable to load stats',
              style: TossTextStyles.body.copyWith(
                color: TossColors.error,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      height: 130,
      margin: EdgeInsets.symmetric(vertical: TossSpacing.space4),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
        children: [
          _buildModernStatCard(
            'Total Balance',
            stats.totalBalance,
            stats.balanceChangeText,
            Icons.account_balance_wallet_rounded,
            TossColors.primary,
            isAmount: true,
          ),
          _buildModernStatCard(
            'Today',
            stats.todayTransactions.toDouble(),
            'Transactions',
            Icons.receipt_long_rounded,
            TossColors.success,
          ),
          _buildModernStatCard(
            'Reward Points',
            stats.totalPoints.toDouble(),
            'Earned',
            Icons.star_rounded,
            TossColors.warning,
          ),
          _buildModernStatCard(
            'Notifications',
            stats.newNotifications.toDouble(),
            'Unread',
            Icons.notifications_active_rounded,
            TossColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildModernStatCard(String title, double value, String subtitle, 
      IconData icon, Color color, {bool isAmount = false}) {
    return Container(
      width: 165,
      margin: EdgeInsets.only(right: TossSpacing.space4),
      padding: EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header row with icon and subtitle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  subtitle,
                  style: TossTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.1,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          
          // Value and title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Animated number counter
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: value),
                duration: Duration(milliseconds: UIConstants.numberCounterAnimationMs),
                curve: Curves.easeOutCubic,
                builder: (context, animatedValue, child) {
                  return Text(
                    isAmount 
                        ? '\$${animatedValue.toStringAsFixed(0)}' 
                        : animatedValue.toStringAsFixed(0),
                    style: TossTextStyles.h2.copyWith(
                      fontWeight: FontWeight.w700,
                      color: TossColors.gray900,
                      letterSpacing: -0.3,
                      fontSize: 24,
                    ),
                  );
                },
              ),
              SizedBox(height: 2),
              Text(
                title,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                  letterSpacing: -0.1,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedActionCards() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TossSectionHeader(
            title: 'Quick Actions',
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
          ),
          SizedBox(height: TossSpacing.space4),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: TossSpacing.space4,
            crossAxisSpacing: TossSpacing.space4,
            childAspectRatio: 1.6,
            children: [
              _buildEnhancedActionCard(
                'Personal Info',
                'Edit your profile',
                Icons.person_outline_rounded,
                TossColors.primary,
                'personal',
              ),
              _buildEnhancedActionCard(
                'Security',
                'Password & 2FA',
                Icons.shield_outlined,
                TossColors.success,
                'security',
              ),
              _buildEnhancedActionCard(
                'Preferences',
                'App settings',
                Icons.settings_outlined,
                TossColors.warning,
                'preferences',
              ),
              _buildEnhancedActionCard(
                'Payment',
                'Cards & accounts',
                Icons.credit_card_outlined,
                TossColors.error,
                'payment',
              ),
              _buildEnhancedActionCard(
                'Activity',
                'Login history',
                Icons.history_rounded,
                TossColors.gray600,
                'activity',
              ),
              _buildEnhancedActionCard(
                'Support',
                'Help & FAQ',
                Icons.help_outline_rounded,
                TossColors.primary,
                'support',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedActionCard(String title, String subtitle, 
      IconData icon, Color color, String id) {
    return TossCard(
      onTap: () {
        HapticFeedback.lightImpact();
        // Navigate based on id
        _handleActionCardTap(id);
      },
      padding: EdgeInsets.all(TossSpacing.space5),
      borderRadius: 16,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color.withOpacity(0.8),
                size: 22,
              ),
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          Flexible(
            child: Text(
              title,
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
                letterSpacing: -0.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 1),
          Flexible(
            child: Text(
              subtitle,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
                letterSpacing: -0.1,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
  
  void _handleActionCardTap(String id) {
    // Handle navigation based on action id
    switch (id) {
      case 'personal':
        // Navigate to personal info
        break;
      case 'security':
        // Navigate to security settings
        break;
      case 'preferences':
        // Navigate to preferences
        break;
      case 'payment':
        // Navigate to payment settings
        break;
      case 'activity':
        // Navigate to activity history
        break;
      case 'support':
        // Navigate to support
        break;
    }
  }

  Widget _buildModernActivityTimeline(DashboardStats stats) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TossSectionHeader(
            title: 'Recent Activity',
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            fontWeight: FontWeight.w700,
            trailing: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => HapticFeedback.lightImpact(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space3,
                    vertical: TossSpacing.space1,
                  ),
                  child: Text(
                    'View All',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.1,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: TossSpacing.space4),
          
          if (stats.isLoading)
            ...List.generate(3, (index) => _buildActivitySkeleton())
          else if (stats.recentActivities.isEmpty)
            _buildEmptyActivityState()
          else
            ...stats.recentActivities.take(5).map((activity) => 
              _buildModernActivityItem(activity)).toList(),
        ],
      ),
    );
  }

  Widget _buildModernActivityItem(RecentActivity activity) {
    final (icon, color) = _getActivityIconAndColor(activity.type);

    return Padding(
      padding: EdgeInsets.only(bottom: TossSpacing.space3),
      child: TossCard(
        onTap: () => HapticFeedback.lightImpact(),
        borderRadius: 20,
        padding: EdgeInsets.zero,
        child: TossListTile(
          title: activity.title,
          subtitle: activity.subtitle,
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          trailing: Container(
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space2,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              activity.timeAgo,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
                letterSpacing: -0.1,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          onTap: () => HapticFeedback.lightImpact(),
          showDivider: false,
          contentPadding: EdgeInsets.all(TossSpacing.space4),
        ),
      ),
    );
  }

  Widget _buildActivitySkeleton() {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: TossColors.gray200,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          SizedBox(width: TossSpacing.space4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: TossColors.gray200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  height: 14,
                  width: 120,
                  decoration: BoxDecoration(
                    color: TossColors.gray200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 12,
            width: 60,
            decoration: BoxDecoration(
              color: TossColors.gray200,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyActivityState() {
    return TossEmptyStateCard(
      message: 'No recent activity\nYour activity will appear here',
      icon: Icons.timeline_outlined,
      backgroundColor: TossColors.surface,
      padding: EdgeInsets.all(TossSpacing.space6),
    );
  }

  (IconData, Color) _getActivityIconAndColor(String type) {
    switch (type) {
      case 'transaction':
        return (Icons.receipt_long_rounded, TossColors.success);
      case 'manual':
        return (Icons.edit_note_rounded, TossColors.primary);
      case 'login':
        return (Icons.login_rounded, TossColors.warning);
      case 'profile':
        return (Icons.person_rounded, TossColors.primary);
      case 'achievement':
        return (Icons.emoji_events_rounded, TossColors.warning);
      default:
        return (Icons.info_rounded, TossColors.gray600);
    }
  }

  void _showEditProfileSheet(UserProfile profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditProfileSheet(profile: profile),
    );
  }
  
  @override
  void dispose() {
    _entryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}