import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/templates/toss_scaffold.dart';

import 'atomic/atoms_page.dart';
import 'atomic/molecules_page.dart';
import 'atomic/organisms_page.dart';
import 'sections/foundation_page.dart';

/// Atomic Design Library Page
///
/// Atomic Design 구조로 정리된 디자인 시스템:
/// - Foundation: Design Tokens (Colors, Typography, Spacing)
/// - Atoms: 가장 작은 UI 단위 (Button, Badge, Input)
/// - Molecules: Atoms의 조합 (Dropdown, Toggle Group, ListTile)
/// - Organisms: 복잡한 컴포넌트 (Dialog, BottomSheet, Picker)
class AtomicDesignLibraryPage extends StatefulWidget {
  const AtomicDesignLibraryPage({super.key});

  @override
  State<AtomicDesignLibraryPage> createState() => _AtomicDesignLibraryPageState();
}

class _AtomicDesignLibraryPageState extends State<AtomicDesignLibraryPage> {
  int _selectedIndex = 0;

  static const List<_NavItem> _navItems = [
    _NavItem(
      icon: Icons.palette_outlined,
      activeIcon: Icons.palette,
      label: 'Foundation',
      color: TossColors.gray600,
    ),
    _NavItem(
      icon: Icons.circle_outlined,
      activeIcon: Icons.circle,
      label: 'Atoms',
      color: TossColors.primary,
    ),
    _NavItem(
      icon: Icons.interests_outlined,
      activeIcon: Icons.interests,
      label: 'Molecules',
      color: TossColors.success,
    ),
    _NavItem(
      icon: Icons.widgets_outlined,
      activeIcon: Icons.widgets,
      label: 'Organisms',
      color: TossColors.warning,
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
          // Atomic Design Navigation
          _buildNavigationBar(),

          // Divider
          Container(height: 1, color: TossColors.gray100),

          // Content
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: const [
                FoundationPage(),
                AtomsPage(),
                MoleculesPage(),
                OrganismsPage(),
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
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      child: Row(
        children: List.generate(_navItems.length, (index) {
          final item = _navItems[index];
          final isSelected = _selectedIndex == index;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index < _navItems.length - 1 ? TossSpacing.space2 : 0,
              ),
              child: _buildNavItem(item, isSelected, index),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNavItem(_NavItem item, bool isSelected, int index) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space2,
            vertical: TossSpacing.space3,
          ),
          decoration: BoxDecoration(
            color: isSelected ? item.color.withValues(alpha: 0.1) : TossColors.gray50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? item.color : TossColors.gray200,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? item.activeIcon : item.icon,
                size: 24,
                color: isSelected ? item.color : TossColors.gray500,
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: TossTextStyles.small.copyWith(
                  color: isSelected ? item.color : TossColors.gray600,
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
  final Color color;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.color,
  });
}
