// lib/presentation/pages/delegate_role/delegate_role_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../providers/delegate_role_provider.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/toss/toss_button.dart';
import 'widgets/user_role_card.dart';
import 'widgets/role_filter_panel.dart';
import 'widgets/user_search_bar.dart';
import 'widgets/role_update_bottom_sheet.dart';
import 'widgets/user_loading_shimmer.dart';

class DelegateRolePage extends ConsumerStatefulWidget {
  const DelegateRolePage({super.key});

  static const String routeName = 'delegateRole';
  static const String routePath = '/delegateRole';

  @override
  ConsumerState<DelegateRolePage> createState() => _DelegateRolePageState();
}

class _DelegateRolePageState extends ConsumerState<DelegateRolePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isFilterPanelOpen = true;

  void _toggleFilterPanel() {
    setState(() {
      _isFilterPanelOpen = !_isFilterPanelOpen;
    });
  }

  void _showRoleUpdateSheet(BuildContext context, UserRoleInfo user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RoleUpdateBottomSheet(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;
    
    if (companyId.isEmpty) {
      return _buildNoCompanyState();
    }

    final usersAsync = ref.watch(filteredUserRolesWithMultiSelectProvider(companyId));
    final isTablet = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: TossColors.gray50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 60,
        title: Text(
          'Delegate Role',
          style: TossTextStyles.h2.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: TossColors.gray900, size: 22),
          onPressed: () => context.go('/'),
        ),
        actions: [
          if (!isTablet)
            IconButton(
              icon: Icon(
                Icons.filter_list,
                color: TossColors.gray700,
                size: 24,
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar Container
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: TossColors.gray100,
                  width: 1,
                ),
              ),
            ),
            padding: EdgeInsets.fromLTRB(
              TossSpacing.space4,
              TossSpacing.space3,
              TossSpacing.space4,
              TossSpacing.space3,
            ),
            child: const UserSearchBar(),
          ),
          
          // Main Content
          Expanded(
            child: Row(
              children: [
                // Filter Panel (Desktop/Tablet)
                if (isTablet && _isFilterPanelOpen)
                  SizedBox(
                    width: 280,
                    child: Container(
                      color: TossColors.gray50,
                      child: const RoleFilterPanel(),
                    ),
                  ),
                
                // User List
                Expanded(
                  child: Container(
                    color: TossColors.background,
                    child: usersAsync.when(
                      data: (users) {
                        if (users.isEmpty) {
                          return _buildEmptyState();
                        }
                        return _buildUserList(users);
                      },
                      loading: () => const UserLoadingShimmer(),
                      error: (error, stack) {
                        print('Delegate Role Error: $error');
                        print('Stack trace: $stack');
                        return _buildErrorState(error);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      
      // Mobile Filter Drawer (Right side)
      endDrawer: !isTablet 
        ? Drawer(
            child: Container(
              color: TossColors.background,
              child: const RoleFilterPanel(isMobile: true),
            ),
          )
        : null,
    );
  }

  Widget _buildUserList(List<UserRoleInfo> users) {
    return ListView.builder(
      padding: EdgeInsets.all(TossSpacing.space4),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Padding(
          padding: EdgeInsets.only(bottom: TossSpacing.space3),
          child: UserRoleCard(
            user: user,
            onTap: () => _showRoleUpdateSheet(context, user),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final searchQuery = ref.watch(userSearchProvider);
    final selectedRoleIds = ref.watch(selectedRoleFiltersProvider);
    final selectedStoreIds = ref.watch(selectedStoreFiltersProvider);
    final hasFilters = searchQuery.isNotEmpty || selectedRoleIds.isNotEmpty || selectedStoreIds.isNotEmpty;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasFilters ? Icons.search_off : Icons.people_outline,
              size: 64,
              color: TossColors.gray400,
            ),
            SizedBox(height: TossSpacing.space4),
            Text(
              hasFilters ? 'No users match your filters' : 'No users found',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray700,
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              hasFilters 
                ? 'Try adjusting your search or filters'
                : 'All users in this company will appear here',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasFilters) ...[
              SizedBox(height: TossSpacing.space6),
              TextButton(
                onPressed: () {
                  ref.read(userSearchProvider.notifier).clear();
                  ref.read(selectedRoleFiltersProvider.notifier).clearFilters();
                  ref.read(selectedStoreFiltersProvider.notifier).clearFilters();
                },
                child: Text(
                  'Clear Filters',
                  style: TossTextStyles.labelLarge.copyWith(
                    color: TossColors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNoCompanyState() {
    return Scaffold(
      backgroundColor: TossColors.gray50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Delegate Role',
          style: TossTextStyles.h2.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: TossColors.gray900, size: 22),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.business_outlined,
                size: 64,
                color: TossColors.gray400,
              ),
              SizedBox(height: TossSpacing.space4),
              Text(
                'No company selected',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.gray700,
                ),
              ),
              SizedBox(height: TossSpacing.space2),
              Text(
                'Please select a company from the homepage first',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: TossSpacing.space6),
              TossButton(
                text: 'Go to Homepage',
                onPressed: () {
                  context.go('/');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: TossColors.error,
            ),
            SizedBox(height: TossSpacing.space4),
            Text(
              'Unable to load users',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              'Please check your internet connection and try again',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: TossSpacing.space6),
            ElevatedButton.icon(
              onPressed: () {
                final companyId = ref.read(appStateProvider).companyChoosen;
                if (companyId.isNotEmpty) {
                  ref.invalidate(companyUserRolesProvider(companyId));
                }
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TossColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space6,
                  vertical: TossSpacing.space3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}