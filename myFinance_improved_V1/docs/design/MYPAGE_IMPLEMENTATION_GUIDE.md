# 🚀 MyPage Implementation Guide
## Complete Technical Blueprint with Code Examples

**Version**: 1.0.0  
**Created**: 2025-01-17  
**Design Spec**: [MYPAGE_DESIGN_SPEC.md](./MYPAGE_DESIGN_SPEC.md)

---

## 📁 File Structure

```
lib/presentation/pages/my_page/
├── my_page.dart                          # Main page widget
├── models/
│   ├── user_profile_model.dart          # User profile data model
│   ├── user_profile_model.freezed.dart  # Generated freezed code
│   ├── user_profile_model.g.dart        # Generated JSON serialization
│   ├── quick_stats_model.dart           # Stats data model
│   └── activity_model.dart              # Activity timeline model
├── providers/
│   ├── my_page_providers.dart           # All providers for the page
│   └── user_preferences_provider.dart   # User preferences state
├── widgets/
│   ├── profile_header.dart              # Animated profile header
│   ├── quick_stats_section.dart         # Stats cards with animations
│   ├── action_cards_grid.dart           # Navigation cards grid
│   ├── activity_timeline.dart           # Recent activity list
│   ├── profile_avatar.dart              # Animated avatar component
│   └── animated_stat_card.dart          # Individual stat card
└── animations/
    ├── page_entry_animation.dart        # Page entry sequence
    ├── card_tap_animation.dart          # Card interaction animations
    └── profile_animations.dart          # Profile-specific animations
```

---

## 🛣️ Routing Configuration

### 1. Update app_router.dart
```dart
// lib/presentation/app/app_router.dart

import '../pages/my_page/my_page.dart';

// Add to routes array after line ~150
GoRoute(
  path: 'myPage',
  name: 'myPage',
  pageBuilder: (context, state) => CustomTransitionPage(
    key: state.pageKey,
    child: const MyPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Toss-style slide and fade transition
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOutCubic;
      
      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );
      var offsetAnimation = animation.drive(tween);
      
      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
    transitionDuration: TossAnimations.medium, // 250ms
  ),
),
```

### 2. Navigation Integration
```dart
// Add navigation from HomePage or BottomNav
// lib/presentation/widgets/common/app_bottom_nav.dart

class AppBottomNav extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      items: [
        // ... existing items
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'My Page',
        ),
      ],
      onTap: (index) {
        switch (index) {
          // ... existing cases
          case 4: // Assuming it's the 5th item
            context.go('/myPage');
            break;
        }
      },
    );
  }
}
```

---

## 🎨 Component Implementation

### 1. Main Page Structure
```dart
// lib/presentation/pages/my_page/my_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance/core/themes/toss_colors.dart';
import 'package:myfinance/core/themes/toss_spacing.dart';
import 'package:myfinance/core/themes/toss_animations.dart';
import 'providers/my_page_providers.dart';
import 'widgets/profile_header.dart';
import 'widgets/quick_stats_section.dart';
import 'widgets/action_cards_grid.dart';
import 'widgets/activity_timeline.dart';

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
      duration: const Duration(milliseconds: 600),
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
    final userProfile = ref.watch(userProfileProvider);
    
    return Scaffold(
      backgroundColor: TossColors.gray100,
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.refresh(userProfileProvider.future);
          await ref.refresh(quickStatsProvider.future);
          await ref.refresh(recentActivityProvider.future);
        },
        color: TossColors.primary,
        child: CustomScrollView(
          slivers: [
            // Animated App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: TossColors.gray100,
              surfaceTintColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        TossColors.primary.withOpacity(0.1),
                        TossColors.gray100,
                      ],
                    ),
                  ),
                ),
              ),
              title: Text(
                'My Page',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.textPrimary,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => context.push('/settings'),
                  color: TossColors.textSecondary,
                ),
              ],
            ),
            
            // Profile Header
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _animations[0],
                child: SlideTransition(
                  position: _animations[0].drive(
                    Tween(begin: const Offset(0, 0.2), end: Offset.zero),
                  ),
                  child: ProfileHeader(
                    userProfile: userProfile,
                  ),
                ),
              ),
            ),
            
            // Quick Stats
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _animations[1],
                child: SlideTransition(
                  position: _animations[1].drive(
                    Tween(begin: const Offset(0, 0.2), end: Offset.zero),
                  ),
                  child: const QuickStatsSection(),
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
                  child: const ActionCardsGrid(),
                ),
              ),
            ),
            
            // Activity Timeline
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _animations[3],
                child: const ActivityTimeline(),
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

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }
}
```

### 2. Profile Header Component
```dart
// lib/presentation/pages/my_page/widgets/profile_header.dart

class ProfileHeader extends ConsumerWidget {
  final AsyncValue<UserProfile> userProfile;

  const ProfileHeader({
    super.key,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space5),
      margin: EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: TossShadows.card,
      ),
      child: userProfile.when(
        data: (profile) => Row(
          children: [
            // Animated Avatar
            Hero(
              tag: 'profile_avatar',
              child: ProfileAvatar(
                imageUrl: profile.avatarUrl,
                size: 80,
                onTap: () => _showAvatarOptions(context),
              ),
            ),
            SizedBox(width: TossSpacing.space4),
            
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.displayName,
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: FontWeight.w700,
                      color: TossColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space1),
                  Text(
                    profile.role,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space1),
                  Text(
                    profile.company,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Edit Button
            TossIconButton(
              icon: Icons.edit_outlined,
              onPressed: () => _navigateToEditProfile(context),
              size: 20,
            ),
          ],
        ),
        loading: () => const ShimmerProfileHeader(),
        error: (error, stack) => ErrorWidget(error),
      ),
    );
  }

  void _showAvatarOptions(BuildContext context) {
    TossBottomSheet.show(
      context: context,
      child: AvatarOptionsSheet(),
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    context.push('/myPage/edit');
  }
}
```

### 3. Animated Avatar Component
```dart
// lib/presentation/pages/my_page/widgets/profile_avatar.dart

class ProfileAvatar extends StatefulWidget {
  final String? imageUrl;
  final double size;
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.size = 80,
    this.onTap,
  });

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: TossAnimations.quick,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: TossColors.surface,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: TossColors.primary.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: widget.imageUrl != null
                    ? Image.network(
                        widget.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildDefaultAvatar(),
                      )
                    : _buildDefaultAvatar(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: TossColors.primary.withOpacity(0.1),
      child: Icon(
        Icons.person,
        size: widget.size * 0.5,
        color: TossColors.primary,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

---

## 📊 State Management

### Provider Setup
```dart
// lib/presentation/pages/my_page/providers/my_page_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile_model.dart';
import '../models/quick_stats_model.dart';
import '../models/activity_model.dart';

// User Profile Provider
final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  final user = ref.watch(authProvider);
  if (user == null) throw Exception('User not authenticated');
  
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUserProfile(user.id);
});

// Quick Stats Provider (Auto-refresh every 30 seconds)
final quickStatsProvider = StreamProvider<QuickStats>((ref) {
  final user = ref.watch(authProvider);
  if (user == null) return Stream.empty();
  
  return Stream.periodic(
    const Duration(seconds: 30),
    (_) async* {
      final repository = ref.watch(statsRepositoryProvider);
      yield await repository.getQuickStats(user.id);
    },
  ).asyncExpand((future) => future);
});

// Recent Activity Provider
final recentActivityProvider = FutureProvider<List<Activity>>((ref) async {
  final user = ref.watch(authProvider);
  if (user == null) return [];
  
  final repository = ref.watch(activityRepositoryProvider);
  return repository.getRecentActivity(
    userId: user.id,
    limit: 10,
  );
});

// User Preferences Provider
final userPreferencesProvider = StateNotifierProvider<UserPreferencesNotifier, UserPreferences>((ref) {
  return UserPreferencesNotifier(ref);
});

class UserPreferencesNotifier extends StateNotifier<UserPreferences> {
  final Ref ref;
  
  UserPreferencesNotifier(this.ref) : super(UserPreferences.defaults());
  
  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    state = UserPreferences(
      theme: prefs.getString('theme') ?? 'light',
      language: prefs.getString('language') ?? 'en',
      notifications: prefs.getBool('notifications') ?? true,
      biometrics: prefs.getBool('biometrics') ?? false,
    );
  }
  
  Future<void> updatePreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    
    switch (key) {
      case 'theme':
        await prefs.setString(key, value);
        state = state.copyWith(theme: value);
        break;
      case 'language':
        await prefs.setString(key, value);
        state = state.copyWith(language: value);
        break;
      case 'notifications':
        await prefs.setBool(key, value);
        state = state.copyWith(notifications: value);
        break;
      case 'biometrics':
        await prefs.setBool(key, value);
        state = state.copyWith(biometrics: value);
        break;
    }
  }
}
```

---

## 🎯 Animation Sequences

### Page Entry Animation Controller
```dart
// lib/presentation/pages/my_page/animations/page_entry_animation.dart

class PageEntryAnimation {
  static const Duration totalDuration = Duration(milliseconds: 600);
  
  static List<Interval> intervals = [
    const Interval(0.0, 0.3, curve: Curves.easeOutCubic),   // Header
    const Interval(0.15, 0.45, curve: Curves.easeOutCubic), // Stats
    const Interval(0.3, 0.6, curve: Curves.easeOutCubic),   // Cards
    const Interval(0.45, 0.75, curve: Curves.easeOutCubic), // Timeline
  ];
  
  static Widget buildAnimatedSection({
    required Widget child,
    required Animation<double> animation,
    required int index,
  }) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: intervals[index],
    );
    
    return FadeTransition(
      opacity: curvedAnimation,
      child: SlideTransition(
        position: curvedAnimation.drive(
          Tween(
            begin: const Offset(0, 0.2),
            end: Offset.zero,
          ),
        ),
        child: child,
      ),
    );
  }
}
```

### Card Tap Animation
```dart
// lib/presentation/pages/my_page/animations/card_tap_animation.dart

class AnimatedActionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;

  const AnimatedActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.onTap,
  });

  @override
  State<AnimatedActionCard> createState() => _AnimatedActionCardState();
}

class _AnimatedActionCardState extends State<AnimatedActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: TossAnimations.quick,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _shadowAnimation = Tween<double>(
      begin: 4.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        Future.delayed(TossAnimations.quick, widget.onTap);
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              color: TossColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_shadowAnimation.value / 100),
                  blurRadius: _shadowAnimation.value * 2,
                  offset: Offset(0, _shadowAnimation.value),
                ),
              ],
            ),
            child: child,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  widget.icon,
                  color: widget.iconColor,
                  size: 24,
                ),
              ),
              SizedBox(height: TossSpacing.space3),
              Text(
                widget.title,
                style: TossTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: TossSpacing.space1),
              Text(
                widget.subtitle,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

---

## 🔄 Data Models

### User Profile Model
```dart
// lib/presentation/pages/my_page/models/user_profile_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    required String displayName,
    String? avatarUrl,
    required String role,
    required String company,
    required String store,
    @Default(false) bool emailVerified,
    DateTime? lastLogin,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
```

### Quick Stats Model
```dart
// lib/presentation/pages/my_page/models/quick_stats_model.dart

@freezed
class QuickStats with _$QuickStats {
  const factory QuickStats({
    required double currentBalance,
    required double balanceChange,
    required int todayTransactions,
    required int transactionChange,
    required int achievementPoints,
    required int pendingNotifications,
    DateTime? lastUpdated,
  }) = _QuickStats;

  factory QuickStats.fromJson(Map<String, dynamic> json) =>
      _$QuickStatsFromJson(json);
}
```

---

## 🧪 Testing Strategy

### Unit Tests
```dart
// test/pages/my_page/providers/my_page_providers_test.dart

void main() {
  group('MyPage Providers', () {
    test('userProfileProvider returns correct data', () async {
      final container = ProviderContainer(
        overrides: [
          userRepositoryProvider.overrideWithValue(mockUserRepository),
        ],
      );
      
      final profile = await container.read(userProfileProvider.future);
      expect(profile.displayName, 'Test User');
    });
    
    test('quickStatsProvider updates periodically', () async {
      // Test stream updates
    });
  });
}
```

### Widget Tests
```dart
// test/pages/my_page/widgets/profile_header_test.dart

void main() {
  testWidgets('ProfileHeader displays user information', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: ProfileHeader(
            userProfile: AsyncValue.data(mockUserProfile),
          ),
        ),
      ),
    );
    
    expect(find.text('Test User'), findsOneWidget);
    expect(find.byType(ProfileAvatar), findsOneWidget);
  });
}
```

---

## 📝 Implementation Checklist

### Phase 1: Setup (Day 1-2)
- [ ] Create folder structure
- [ ] Set up routing in app_router.dart
- [ ] Create basic page scaffold
- [ ] Set up providers
- [ ] Create data models

### Phase 2: Core Components (Day 3-5)
- [ ] Implement ProfileHeader widget
- [ ] Create ProfileAvatar with animations
- [ ] Build QuickStatsSection
- [ ] Implement ActionCardsGrid
- [ ] Create ActivityTimeline

### Phase 3: Animations (Day 6-7)
- [ ] Add page entry animations
- [ ] Implement card tap animations
- [ ] Add avatar interactions
- [ ] Create loading skeletons
- [ ] Add pull-to-refresh

### Phase 4: Integration (Day 8-9)
- [ ] Connect to Supabase
- [ ] Implement data fetching
- [ ] Add error handling
- [ ] Set up caching
- [ ] Test navigation

### Phase 5: Polish (Day 10)
- [ ] Performance optimization
- [ ] Accessibility improvements
- [ ] Final animations tuning
- [ ] Testing & QA
- [ ] Documentation

---

## 🎯 Success Metrics

- ✅ Page loads < 1 second
- ✅ Animations run at 60fps
- ✅ Zero console errors
- ✅ 100% Toss design compliance
- ✅ Accessibility score > 95%
- ✅ All interactions < 100ms response

---

**Ready for Implementation!**  
Start with Phase 1 and follow the structured approach for best results.