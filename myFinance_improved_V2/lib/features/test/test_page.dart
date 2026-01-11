/// Test Page with Tabs
///
/// Main test page with multiple tabs including:
/// - Template Mapping Test
/// - Design System Showcase
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import 'test_template_mapping_page.dart';
import 'design/design_showcase_page.dart';

class TestPage extends ConsumerStatefulWidget {
  const TestPage({super.key});

  @override
  ConsumerState<TestPage> createState() => _TestPageState();
}

class _TestPageState extends ConsumerState<TestPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<_TabItem> _tabs = [
    _TabItem(
      label: 'Template',
      icon: Icons.description_outlined,
    ),
    _TabItem(
      label: 'Design',
      icon: Icons.palette_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: TossColors.primary,
          unselectedLabelColor: TossColors.gray600,
          indicatorColor: TossColors.primary,
          tabs: _tabs
              .map((tab) => Tab(
                    icon: Icon(tab.icon, size: 20),
                    text: tab.label,
                  ))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        // Disable swipe to prevent accidental navigation
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          // Template tab - the original page content without its AppBar
          _TemplateMappingContent(),
          // Design tab
          DesignShowcasePage(),
        ],
      ),
    );
  }
}

/// Content widget that embeds TestTemplateMapppingPage content
class _TemplateMappingContent extends ConsumerStatefulWidget {
  const _TemplateMappingContent();

  @override
  ConsumerState<_TemplateMappingContent> createState() => _TemplateMappingContentState();
}

class _TemplateMappingContentState extends ConsumerState<_TemplateMappingContent> {
  @override
  Widget build(BuildContext context) {
    // Simply use the existing page - it has its own scaffold but won't show nested app bars
    // because TabBarView handles the content properly
    return const TestTemplateMapppingPage();
  }
}

class _TabItem {
  final String label;
  final IconData icon;

  _TabItem({
    required this.label,
    required this.icon,
  });
}
