/// Atoms Showcase
///
/// Displays all atomic components from shared/widgets/atoms folder.
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toss_button.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toss_icon_button.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toggle_button.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/toss_badge.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/toss_chip.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/info_row.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_empty_view.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_error_view.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_skeleton.dart';
import 'package:myfinance_improved/shared/widgets/atoms/inputs/toss_text_field.dart';
import 'package:myfinance_improved/shared/widgets/atoms/inputs/toss_search_field.dart';
import 'package:myfinance_improved/shared/widgets/atoms/layout/toss_section_header.dart';
import 'package:myfinance_improved/shared/widgets/atoms/layout/gray_divider_space.dart';
import 'package:myfinance_improved/shared/widgets/atoms/sheets/drag_handle.dart';
import 'package:myfinance_improved/shared/widgets/atoms/sheets/check_indicator.dart';
import 'package:myfinance_improved/shared/widgets/atoms/sheets/avatar_circle.dart';
import 'package:myfinance_improved/shared/widgets/atoms/sheets/icon_container.dart';

class AtomsShowcase extends StatefulWidget {
  const AtomsShowcase({super.key});

  @override
  State<AtomsShowcase> createState() => _AtomsShowcaseState();
}

class _AtomsShowcaseState extends State<AtomsShowcase>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = [
    'Buttons',
    'Display',
    'Feedback',
    'Inputs',
    'Layout',
    'Sheets',
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
            tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              _ButtonsTab(),
              _DisplayTab(),
              _FeedbackTab(),
              _InputsTab(),
              _LayoutTab(),
              _SheetsTab(),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== Buttons Tab ====================
class _ButtonsTab extends StatefulWidget {
  const _ButtonsTab();

  @override
  State<_ButtonsTab> createState() => _ButtonsTabState();
}

class _ButtonsTabState extends State<_ButtonsTab> {
  String _selectedToggle = 'week';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        _buildComponentCard(
          'TossButton',
          'Unified button component with multiple variants',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buttonRow('.primary', TossButton.primary(text: 'Save', onPressed: () {})),
              _buttonRow('.secondary', TossButton.secondary(text: 'Cancel', onPressed: () {})),
              _buttonRow('.outlined', TossButton.outlined(text: 'Edit', onPressed: () {})),
              _buttonRow('.outlinedGray', TossButton.outlinedGray(text: 'More', onPressed: () {})),
              _buttonRow('.textButton', TossButton.textButton(text: 'Learn more', onPressed: () {})),
              _buttonRow('.destructive', TossButton.destructive(text: 'Delete', onPressed: () {})),
              const SizedBox(height: TossSpacing.space3),
              const Text('With Icons', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: TossSpacing.space2),
              _buttonRow('trailingIcon:', TossButton.primary(
                text: 'Continue',
                trailingIcon: const Icon(Icons.arrow_forward),
                onPressed: () {},
              )),
              const SizedBox(height: TossSpacing.space2),
              const Text('Full Width', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: TossSpacing.space2),
              _buttonRow('fullWidth: true', TossButton.primary(
                text: 'Confirm',
                fullWidth: true,
                onPressed: () {},
              )),
              const SizedBox(height: TossSpacing.space2),
              const Text('States', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: TossSpacing.space2),
              _buttonRow('isLoading: true', TossButton.primary(
                text: 'Loading...',
                isLoading: true,
                onPressed: () {},
              )),
              _buttonRow('isEnabled: false', TossButton.primary(
                text: 'Disabled',
                isEnabled: false,
                onPressed: () {},
              )),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'TossIconButton',
          'Icon-only button with multiple variants and sizes',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Variants', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: TossSpacing.space2),
              Row(
                children: [
                  _labeledWidget('.ghost', TossIconButton.ghost(icon: Icons.arrow_back, onPressed: () {})),
                  const SizedBox(width: TossSpacing.space3),
                  _labeledWidget('.filled', TossIconButton.filled(icon: Icons.add, onPressed: () {})),
                  const SizedBox(width: TossSpacing.space3),
                  _labeledWidget('.outlined', TossIconButton.outlined(icon: Icons.edit, onPressed: () {})),
                  const SizedBox(width: TossSpacing.space3),
                  _labeledWidget('.danger', TossIconButton.danger(icon: Icons.delete, onPressed: () {})),
                ],
              ),
              const SizedBox(height: TossSpacing.space3),
              const Text('Sizes', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: TossSpacing.space2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _labeledWidget('small', TossIconButton.filled(
                    icon: Icons.add,
                    size: TossIconButtonSize.small,
                    onPressed: () {},
                  )),
                  const SizedBox(width: TossSpacing.space3),
                  _labeledWidget('medium', TossIconButton.filled(
                    icon: Icons.add,
                    size: TossIconButtonSize.medium,
                    onPressed: () {},
                  )),
                  const SizedBox(width: TossSpacing.space3),
                  _labeledWidget('large', TossIconButton.filled(
                    icon: Icons.add,
                    size: TossIconButtonSize.large,
                    onPressed: () {},
                  )),
                ],
              ),
              const SizedBox(height: TossSpacing.space3),
              const Text('Disabled State', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: TossSpacing.space2),
              Row(
                children: [
                  _labeledWidget('.ghost', TossIconButton.ghost(icon: Icons.close, isEnabled: false, onPressed: () {})),
                  const SizedBox(width: TossSpacing.space3),
                  _labeledWidget('.filled', TossIconButton.filled(icon: Icons.add, isEnabled: false, onPressed: () {})),
                  const SizedBox(width: TossSpacing.space3),
                  _labeledWidget('.outlined', TossIconButton.outlined(icon: Icons.edit, isEnabled: false, onPressed: () {})),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'ToggleButtonGroup',
          'Segmented toggle with compact/expanded layouts',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('layout: compact (default)', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: TossSpacing.space2),
              ToggleButtonGroup(
                items: const [
                  ToggleButtonItem(id: 'day', label: 'Day'),
                  ToggleButtonItem(id: 'week', label: 'Week'),
                  ToggleButtonItem(id: 'month', label: 'Month'),
                ],
                selectedId: _selectedToggle,
                onToggle: (id) {
                  setState(() => _selectedToggle = id);
                },
              ),
              const SizedBox(height: TossSpacing.space4),
              const Text('layout: expanded (full width)', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: TossSpacing.space2),
              ToggleButtonGroup(
                items: const [
                  ToggleButtonItem(id: 'day', label: 'Day'),
                  ToggleButtonItem(id: 'week', label: 'Week'),
                  ToggleButtonItem(id: 'month', label: 'Month'),
                ],
                selectedId: _selectedToggle,
                onToggle: (id) {
                  setState(() => _selectedToggle = id);
                },
                layout: ToggleButtonLayout.expanded,
              ),
              const SizedBox(height: TossSpacing.space4),
              const Text('With count', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: TossSpacing.space2),
              ToggleButtonGroup(
                items: const [
                  ToggleButtonItem(id: 'all', label: 'All', count: 24),
                  ToggleButtonItem(id: 'pending', label: 'Pending', count: 8),
                  ToggleButtonItem(id: 'done', label: 'Done', count: 16),
                ],
                selectedId: _selectedToggle == 'day' ? 'all' : _selectedToggle == 'week' ? 'pending' : 'done',
                onToggle: (id) {
                  setState(() => _selectedToggle = id == 'all' ? 'day' : id == 'pending' ? 'week' : 'month');
                },
                layout: ToggleButtonLayout.expanded,
              ),
              const SizedBox(height: TossSpacing.space4),
              const Text('With icons', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: TossSpacing.space2),
              ToggleButtonGroup(
                items: const [
                  ToggleButtonItem(id: 'all', label: 'All'),
                  ToggleButtonItem(id: 'group', label: 'Group', icon: Icons.people_outline),
                  ToggleButtonItem(id: 'external', label: 'External', icon: Icons.public),
                ],
                selectedId: _selectedToggle == 'day' ? 'all' : _selectedToggle == 'week' ? 'group' : 'external',
                onToggle: (id) {
                  setState(() => _selectedToggle = id == 'all' ? 'day' : id == 'group' ? 'week' : 'month');
                },
                layout: ToggleButtonLayout.expanded,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== Display Tab ====================
class _DisplayTab extends StatefulWidget {
  const _DisplayTab();

  @override
  State<_DisplayTab> createState() => _DisplayTabState();
}

class _DisplayTabState extends State<_DisplayTab> {
  String? _selectedChip;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        _buildComponentCard(
          'TossBadge',
          'Non-interactive badge for labels and statuses',
          Wrap(
            spacing: TossSpacing.space2,
            runSpacing: TossSpacing.space2,
            children: [
              const TossBadge(label: 'Default'),
              TossBadge(
                label: 'Custom',
                backgroundColor: TossColors.primarySurface,
                textColor: TossColors.primary,
              ),
              const TossBadge(
                label: 'With Icon',
                icon: Icons.star,
              ),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'TossStatusBadge',
          'Badge with predefined status styles',
          Wrap(
            spacing: TossSpacing.space2,
            runSpacing: TossSpacing.space2,
            children: const [
              TossStatusBadge(label: 'Success', status: BadgeStatus.success),
              TossStatusBadge(label: 'Warning', status: BadgeStatus.warning),
              TossStatusBadge(label: 'Error', status: BadgeStatus.error),
              TossStatusBadge(label: 'Info', status: BadgeStatus.info),
              TossStatusBadge(label: 'Neutral', status: BadgeStatus.neutral),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'SubscriptionBadge',
          'Badge for subscription plan types',
          Wrap(
            spacing: TossSpacing.space2,
            runSpacing: TossSpacing.space2,
            children: const [
              SubscriptionBadge(planType: 'free'),
              SubscriptionBadge(planType: 'basic'),
              SubscriptionBadge(planType: 'pro'),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'TossChip',
          'Interactive chip for filters and selections',
          Wrap(
            spacing: TossSpacing.space2,
            runSpacing: TossSpacing.space2,
            children: [
              TossChip(
                label: 'All',
                isSelected: _selectedChip == 'all',
                onTap: () => setState(() => _selectedChip = 'all'),
              ),
              TossChip(
                label: 'Active',
                isSelected: _selectedChip == 'active',
                onTap: () => setState(() => _selectedChip = 'active'),
              ),
              TossChip(
                label: 'Completed',
                isSelected: _selectedChip == 'completed',
                onTap: () => setState(() => _selectedChip = 'completed'),
                showCount: true,
                count: 12,
              ),
              TossChip(
                label: 'With Icon',
                icon: Icons.filter_list,
                isSelected: _selectedChip == 'icon',
                onTap: () => setState(() => _selectedChip = 'icon'),
              ),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'InfoRow',
          'Key-value row for displaying information',
          Column(
            children: [
              InfoRow(label: 'Name', value: 'John Doe'),
              const SizedBox(height: TossSpacing.space2),
              InfoRow(label: 'Email', value: 'john@example.com'),
              const SizedBox(height: TossSpacing.space2),
              InfoRow.fixed(label: 'Status', value: 'Active', labelWidth: 80),
              const SizedBox(height: TossSpacing.space2),
              InfoRow.between(label: 'Total', value: '₫1,234,000', isTotal: true),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== Feedback Tab ====================
class _FeedbackTab extends StatelessWidget {
  const _FeedbackTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        _buildComponentCard(
          'TossLoadingView',
          'Loading indicator with optional message',
          const SizedBox(
            height: 150,
            child: TossLoadingView(message: 'Loading data...'),
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'TossEmptyView',
          'Empty state with icon and message',
          SizedBox(
            height: 200,
            child: TossEmptyView(
              icon: const Icon(Icons.inbox_outlined, size: 48, color: TossColors.gray400),
              title: 'No items found',
              description: 'Try adjusting your filters',
            ),
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'TossErrorView',
          'Error state with retry option',
          SizedBox(
            height: 250,
            child: TossErrorView(
              error: Exception('Something went wrong'),
              title: 'Something went wrong',
              onRetry: () {},
            ),
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'TossSkeleton',
          'Skeleton loading placeholder',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TossSkeleton(width: 200, height: 20),
              const SizedBox(height: TossSpacing.space2),
              const TossSkeleton(width: 150, height: 16),
              const SizedBox(height: TossSpacing.space3),
              Row(
                children: const [
                  TossSkeleton(width: 48, height: 48, isCircle: true),
                  SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TossSkeleton(height: 16),
                        SizedBox(height: TossSpacing.space2),
                        TossSkeleton(width: 120, height: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== Inputs Tab ====================
class _InputsTab extends StatefulWidget {
  const _InputsTab();

  @override
  State<_InputsTab> createState() => _InputsTabState();
}

class _InputsTabState extends State<_InputsTab> {
  final _textController = TextEditingController();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        _buildComponentCard(
          'TossTextField',
          'Styled text field with label and hint',
          Column(
            children: [
              TossTextField(
                controller: _textController,
                label: 'Email',
                hintText: 'Enter your email',
              ),
              const SizedBox(height: TossSpacing.space3),
              TossTextField(
                controller: TextEditingController(),
                label: 'Password',
                hintText: 'Enter password',
                obscureText: true,
              ),
              const SizedBox(height: TossSpacing.space3),
              TossTextField(
                controller: TextEditingController(text: 'Invalid input'),
                label: 'With Error',
                hintText: 'Enter value',
                errorText: 'This field is required',
              ),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'TossSearchField',
          'Search input with clear button',
          TossSearchField(
            controller: _searchController,
            hintText: 'Search...',
            onChanged: (value) {},
          ),
        ),
      ],
    );
  }
}

// ==================== Layout Tab ====================
class _LayoutTab extends StatelessWidget {
  const _LayoutTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        _buildComponentCard(
          'TossSectionHeader',
          'Section header with optional trailing widget',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TossSectionHeader(title: 'Recent Transactions'),
              const SizedBox(height: TossSpacing.space3),
              TossSectionHeader(
                title: 'With Action',
                trailing: TextButton(
                  onPressed: () {},
                  child: const Text('See All'),
                ),
              ),
              const SizedBox(height: TossSpacing.space3),
              const TossSectionHeader(
                title: 'With Icon',
                icon: Icons.star,
              ),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'GrayDividerSpace',
          'Gray divider for separating sections',
          Container(
            color: TossColors.white,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  child: const Text('Section 1'),
                ),
                const GrayDividerSpace(),
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  child: const Text('Section 2'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ==================== Sheets Tab ====================
class _SheetsTab extends StatelessWidget {
  const _SheetsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        _buildComponentCard(
          'DragHandle',
          'Drag handle for bottom sheets',
          Center(
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              child: const DragHandle(),
            ),
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'CheckIndicator',
          'Animated check indicator for selections',
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CheckIndicator(isVisible: false),
              SizedBox(width: TossSpacing.space4),
              CheckIndicator(isVisible: true),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'AvatarCircle',
          'Avatar circle with image or fallback icon',
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AvatarCircle(),
              SizedBox(width: TossSpacing.space3),
              AvatarCircle(
                fallbackIcon: Icons.business,
              ),
              SizedBox(width: TossSpacing.space3),
              AvatarCircle(
                size: 48,
                isSelected: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'IconContainer',
          'Styled container for icons',
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconContainer(icon: Icons.account_balance_wallet),
              SizedBox(width: TossSpacing.space3),
              IconContainer(
                icon: Icons.credit_card,
                isSelected: true,
              ),
              SizedBox(width: TossSpacing.space3),
              IconContainer(
                icon: Icons.savings,
                size: 48,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== Helper ====================
Widget _buildComponentCard(String title, String description, Widget child) {
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
              Text(
                title,
                style: TossTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: TossSpacing.space1),
              Text(
                description,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: child,
        ),
      ],
    ),
  );
}

/// Helper to show widget with its variant/size label below
Widget _labeledWidget(String label, Widget widget) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      widget,
      const SizedBox(height: TossSpacing.space1),
      Text(
        label,
        style: TossTextStyles.caption.copyWith(
          color: TossColors.gray600,
          fontSize: 10,
          fontFamily: 'monospace',
        ),
      ),
    ],
  );
}

/// Helper to show button with label on the left
Widget _buttonRow(String label, Widget button) {
  return Padding(
    padding: const EdgeInsets.only(bottom: TossSpacing.space2),
    child: Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        Flexible(child: button),
      ],
    ),
  );
}
