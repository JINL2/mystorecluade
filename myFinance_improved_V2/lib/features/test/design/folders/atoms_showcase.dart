/// Atoms Showcase
///
/// Displays all atomic components from shared/widgets/atoms folder.
/// Components are loaded from showcase_registry.dart
///
/// To add a new atom component:
/// 1. Create the component in atoms/<category>/your_component.dart
/// 2. Add import and DemoItem in showcase_registry.dart → getAtomsDemos()
/// 3. Done! It will automatically appear here.
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/showcase_registry.dart';

class AtomsShowcase extends StatefulWidget {
  const AtomsShowcase({super.key});

  @override
  State<AtomsShowcase> createState() => _AtomsShowcaseState();
}

class _AtomsShowcaseState extends State<AtomsShowcase>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, List<DemoItem>> _demos;
  late List<String> _categories;

  @override
  void initState() {
    super.initState();
    _demos = getAtomsDemos();
    _categories = _demos.keys.toList();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: TossColors.white,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: TossColors.primary,
            unselectedLabelColor: TossColors.gray600,
            indicatorColor: TossColors.primary,
            tabs: _categories.map((cat) => Tab(text: cat)).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _categories.map((cat) {
              final items = _demos[cat] ?? [];
              return _DemoList(items: items);
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _DemoList extends StatelessWidget {
  final List<DemoItem> items;
  const _DemoList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text('No components yet', style: TossTextStyles.body.copyWith(color: TossColors.gray600)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(TossSpacing.space4),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: TossSpacing.space2),
      itemBuilder: (context, index) => _DemoCard(item: items[index]),
    );
  }
}

class _DemoCard extends StatelessWidget {
  final DemoItem item;
  const _DemoCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: TossTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: TossSpacing.space1),
                Text(item.description, style: TossTextStyles.caption.copyWith(color: TossColors.gray600)),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: item.builder(),
          ),
        ],
      ),
    );
  }
}
