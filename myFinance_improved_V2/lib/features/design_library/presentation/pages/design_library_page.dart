import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';

import 'sections/ai_widgets_section.dart';
import 'sections/calendar_widgets_page.dart';
import 'sections/core_widgets_page.dart';
import 'sections/domain_widgets_page.dart';
import 'sections/feedback_widgets_page.dart';
import 'sections/foundation_page.dart';
import 'sections/navigation_widgets_page.dart';
import 'sections/overlays_widgets_page.dart';
import 'sections/selectors_section.dart';
import 'sections/toss_extended_section.dart';

/// Design Library Page
/// Visual showcase of all design system components organized by folder structure
/// Matches: shared/widgets/{core, feedback, overlays, navigation, calendar, domain}
class DesignLibraryPage extends StatefulWidget {
  const DesignLibraryPage({super.key});

  @override
  State<DesignLibraryPage> createState() => _DesignLibraryPageState();
}

class _DesignLibraryPageState extends State<DesignLibraryPage> {
  int _selectedIndex = 0;

  // Navigation items matching folder structure
  static const List<_NavItem> _navItems = [
    _NavItem(
      icon: Icons.palette_outlined,
      activeIcon: Icons.palette,
      label: 'Foundation',
    ),
    _NavItem(
      icon: Icons.widgets_outlined,
      activeIcon: Icons.widgets,
      label: 'core',
    ),
    _NavItem(
      icon: Icons.feedback_outlined,
      activeIcon: Icons.feedback,
      label: 'feedback',
    ),
    _NavItem(
      icon: Icons.layers_outlined,
      activeIcon: Icons.layers,
      label: 'overlays',
    ),
    _NavItem(
      icon: Icons.menu_outlined,
      activeIcon: Icons.menu,
      label: 'navigation',
    ),
    _NavItem(
      icon: Icons.calendar_month_outlined,
      activeIcon: Icons.calendar_month,
      label: 'calendar',
    ),
    _NavItem(
      icon: Icons.business_outlined,
      activeIcon: Icons.business,
      label: 'domain',
    ),
    _NavItem(
      icon: Icons.smart_toy_outlined,
      activeIcon: Icons.smart_toy,
      label: 'AI',
    ),
    _NavItem(
      icon: Icons.check_box_outlined,
      activeIcon: Icons.check_box,
      label: 'selectors',
    ),
    _NavItem(
      icon: Icons.extension_outlined,
      activeIcon: Icons.extension,
      label: 'toss',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      appBar: AppBar(
        title: const Text('Design Library'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: TossColors.white,
        foregroundColor: TossColors.gray900,
      ),
      body: Column(
        children: [
          // Folder-based navigation tabs
          _buildNavigationBar(),

          // Divider
          Container(
            height: 1,
            color: TossColors.gray100,
          ),

          // Content area with IndexedStack for smooth transitions
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: const [
                FoundationPage(),
                CoreWidgetsPage(),
                FeedbackWidgetsPage(),
                OverlaysWidgetsPage(),
                NavigationWidgetsPage(),
                CalendarWidgetsPage(),
                DomainWidgetsPage(),
                AIWidgetsSection(),
                SelectorsSection(),
                TossExtendedSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      color: TossColors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: Row(
          children: List.generate(_navItems.length, (index) {
            final item = _navItems[index];
            final isSelected = _selectedIndex == index;

            return Padding(
              padding: EdgeInsets.only(
                right: index < _navItems.length - 1 ? TossSpacing.space2 : 0,
              ),
              child: _buildNavItem(item, isSelected, index),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildNavItem(_NavItem item, bool isSelected, int index) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space2,
          ),
          decoration: BoxDecoration(
            color: isSelected ? TossColors.primary : TossColors.gray50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? TossColors.primary : TossColors.gray200,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? item.activeIcon : item.icon,
                size: 18,
                color: isSelected ? TossColors.white : TossColors.gray600,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                item.label,
                style: TossTextStyles.caption.copyWith(
                  color: isSelected ? TossColors.white : TossColors.gray700,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
