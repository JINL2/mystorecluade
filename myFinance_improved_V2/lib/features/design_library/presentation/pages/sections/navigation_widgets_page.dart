import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

// Navigation
import 'package:myfinance_improved/shared/widgets/molecules/navigation/index.dart';
import 'package:myfinance_improved/shared/widgets/molecules/buttons/toss_fab.dart';
import 'package:myfinance_improved/shared/widgets/molecules/buttons/toss_speed_dial.dart';

import '../component_showcase.dart';

/// Navigation Widgets Page - App bars, Tabs, FABs
class NavigationWidgetsPage extends StatefulWidget {
  const NavigationWidgetsPage({super.key});

  @override
  State<NavigationWidgetsPage> createState() => _NavigationWidgetsPageState();
}

class _NavigationWidgetsPageState extends State<NavigationWidgetsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      children: [
        // Section: App Bars
        _buildSectionHeader('App Bars', Icons.web_asset),

        // TossAppBar1
        ComponentShowcase(
          name: 'TossAppBar1',
          filename: 'toss_app_bar_1.dart',
          child: Container(
            height: 56,
            decoration: const BoxDecoration(
              color: TossColors.white,
              border: Border(bottom: BorderSide(color: TossColors.gray200)),
            ),
            child: const TossAppBar1(title: 'App Bar Title'),
          ),
        ),

        // Section: Tabs
        _buildSectionHeader('Tabs', Icons.tab),

        // TossTabBar1
        ComponentShowcase(
          name: 'TossTabBar1',
          filename: 'toss_tab_bar_1.dart',
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.gray200),
            ),
            child: TossTabBar1(
              tabs: const ['Cash', 'Bank', 'Vault'],
              controller: _tabController,
              onTabChanged: (index) {},
            ),
          ),
        ),

        // Section: FABs
        _buildSectionHeader('Floating Action Buttons', Icons.add_circle),

        // TossFAB
        ComponentShowcase(
          name: 'TossFAB',
          filename: 'toss_fab.dart',
          child: Row(
            children: [
              TossFAB(
                icon: Icons.add,
                onPressed: () {},
              ),
              const SizedBox(width: TossSpacing.space4),
              TossFAB(
                icon: Icons.edit,
                onPressed: () {},
                backgroundColor: TossColors.success,
              ),
            ],
          ),
        ),

        // TossSpeedDial
        ComponentShowcase(
          name: 'TossSpeedDial',
          filename: 'toss_speed_dial.dart',
          child: Row(
            children: [
              Text('Expandable FAB:', style: TossTextStyles.body),
              const SizedBox(width: TossSpacing.space3),
              TossSpeedDial(
                actions: [
                  TossSpeedDialAction(icon: Icons.add, label: 'Add Product', onPressed: () {}),
                  TossSpeedDialAction(icon: Icons.download, label: 'Stock In', onPressed: () {}),
                  TossSpeedDialAction(icon: Icons.upload, label: 'Stock Out', onPressed: () {}),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: TossSpacing.space8),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: TossSpacing.space4, bottom: TossSpacing.space2),
      child: Row(
        children: [
          Icon(icon, size: 20, color: TossColors.primary),
          const SizedBox(width: TossSpacing.space2),
          Text(
            title,
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
        ],
      ),
    );
  }
}
