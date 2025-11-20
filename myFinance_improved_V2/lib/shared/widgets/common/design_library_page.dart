// lib/shared/widgets/common/design_library_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../themes/toss_border_radius.dart';
import '../../themes/toss_colors.dart';
import '../../themes/toss_spacing.dart';
import '../../themes/toss_text_styles.dart';
import '../toss/toss_badge.dart';
import '../toss/toss_bottom_sheet.dart';
import '../toss/toss_button.dart' as toss_button;
import '../toss/toss_chip.dart';
import '../toss/toss_icon_button.dart';
import '../toss/toss_list_tile.dart';
import '../toss/toss_search_field.dart';
import '../toss/toss_tab_bar_1.dart';
import '../toss/toss_text_field.dart';
import 'debounced_button.dart';
import 'employee_profile_avatar.dart';
import 'enhanced_quantity_selector.dart';
import 'keyboard_toolbar_1.dart';
import 'safe_popup_menu.dart';
import 'toss_app_bar_1.dart';
import 'toss_date_picker.dart';
import 'toss_empty_view.dart';
import 'toss_error_view.dart';
import 'toss_loading_view.dart';
import 'toss_section_header.dart';
import 'toss_white_card.dart';

/// Design Library Page
///
/// Showcases all common components in a visual gallery
class DesignLibraryPage extends ConsumerStatefulWidget {
  const DesignLibraryPage({super.key});

  @override
  ConsumerState<DesignLibraryPage> createState() => _DesignLibraryPageState();
}

class _DesignLibraryPageState extends ConsumerState<DesignLibraryPage> with SingleTickerProviderStateMixin {
  final TextEditingController _textFieldController = TextEditingController(text: 'Sample text');
  String? _selectedChip = 'all';
  int _quantity = 5;
  DateTime? _selectedDate = DateTime.now();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: TossColors.gray900),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Design Library',
          style: TossTextStyles.h3.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFFFFFFF),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(TossSpacing.space5),
          child: Container(
            color: const Color(0xFFFFFFFF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Colors Section
                _buildSectionTitle('Colors'),
                const SizedBox(height: TossSpacing.space4),
                _buildColorsSection(),

                const SizedBox(height: TossSpacing.space8),

                // Components Section
                _buildSectionTitle('Components'),
                const SizedBox(height: TossSpacing.space4),
                _buildComponentsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TossTextStyles.h2.copyWith(
        color: TossColors.gray900,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildColorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand Colors
        Text(
          'Brand Colors',
          style: TossTextStyles.h4.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        Row(
          children: [
            _buildColorCard('Primary', TossColors.primary),
            const SizedBox(width: TossSpacing.space3),
            _buildColorCard('Primary Surf..', TossColors.primarySurface),
          ],
        ),

        const SizedBox(height: TossSpacing.space6),

        // Grayscale
        Text(
          'Grayscale',
          style: TossTextStyles.h4.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: TossSpacing.space3),

        // Row 1: White, Gray 50, Gray 100
        Row(
          children: [
            _buildColorCard('White', TossColors.white),
            const SizedBox(width: TossSpacing.space3),
            _buildColorCard('Gray 50', TossColors.gray50),
            const SizedBox(width: TossSpacing.space3),
            _buildColorCard('Gray 100', TossColors.gray100),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),

        // Row 2: Gray 200, Gray 300, Gray 400
        Row(
          children: [
            _buildColorCard('Gray 200', TossColors.gray200),
            const SizedBox(width: TossSpacing.space3),
            _buildColorCard('Gray 300', TossColors.gray300),
            const SizedBox(width: TossSpacing.space3),
            _buildColorCard('Gray 400', TossColors.gray400),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),

        // Row 3: Gray 500, Gray 600, Gray 700
        Row(
          children: [
            _buildColorCard('Gray 500', TossColors.gray500),
            const SizedBox(width: TossSpacing.space3),
            _buildColorCard('Gray 600', TossColors.gray600),
            const SizedBox(width: TossSpacing.space3),
            _buildColorCard('Gray 700', TossColors.gray700),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),

        // Row 4: Gray 800, Gray 900, Black
        Row(
          children: [
            _buildColorCard('Gray 800', TossColors.gray800),
            const SizedBox(width: TossSpacing.space3),
            _buildColorCard('Gray 900', TossColors.gray900),
            const SizedBox(width: TossSpacing.space3),
            _buildColorCard('Black', TossColors.black),
          ],
        ),

        const SizedBox(height: TossSpacing.space6),

        // Semantic Colors
        Text(
          'Semantic Colors',
          style: TossTextStyles.h4.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        Row(
          children: [
            _buildColorCard('Success', TossColors.success),
            const SizedBox(width: TossSpacing.space3),
            _buildColorCard('Success Light', TossColors.successLight),
            const SizedBox(width: TossSpacing.space3),
            _buildColorCard('Error', TossColors.error),
          ],
        ),
      ],
    );
  }

  Widget _buildColorCard(String name, Color color) {
    final isLight = color.computeLuminance() > 0.5;

    return Expanded(
      child: Container(
        height: 27,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(TossSpacing.space2),
        child: Text(
          name,
          style: TossTextStyles.caption.copyWith(
            color: isLight ? TossColors.gray900 : TossColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 8,
          ),
        ),
      ),
    );
  }

  Widget _buildComponentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header with Trailing
        _buildComponentShowcase(
          'TossSectionHeader',
          'Section header with title and optional trailing widget',
          'toss_section_header.dart',
          TossSectionHeader(
            title: 'Recent Transactions',
            icon: Icons.receipt_long,
            trailing: Text(
              'View All',
              style: TossTextStyles.body.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // TossWhiteCard
        _buildComponentShowcase(
          'TossWhiteCard',
          'White card container with border radius and shadow',
          'toss_white_card.dart',
          TossWhiteCard(
            child: Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Title',
                    style: TossTextStyles.h4.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space2),
                  Text(
                    'This is a TossWhiteCard with shadow and border',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // TossButton Variants
        _buildComponentShowcase(
          'TossButton',
          'Unified button component with multiple variants',
          'toss_button.dart',
          Column(
            children: [
              toss_button.TossButton.primary(
                text: 'Primary Button',
                onPressed: () {},
              ),
              const SizedBox(height: TossSpacing.space2),
              toss_button.TossButton.secondary(
                text: 'Secondary Button',
                onPressed: () {},
              ),
            ],
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // TossTextField
        _buildComponentShowcase(
          'TossTextField',
          'Text input field with Toss styling',
          'toss_text_field.dart',
          TossTextField(
            label: 'Label',
            hintText: 'Enter text here',
            controller: _textFieldController,
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // TossChip and TossChipGroup
        _buildComponentShowcase(
          'TossChip / TossChipGroup',
          'Chip for filters and selections',
          'toss_chip.dart',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Single Chips:',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Wrap(
                spacing: TossSpacing.space2,
                runSpacing: TossSpacing.space2,
                children: [
                  TossChip(
                    label: 'Selected',
                    isSelected: true,
                    onTap: () {},
                  ),
                  TossChip(
                    label: 'Unselected',
                    isSelected: false,
                    onTap: () {},
                  ),
                  TossChip(
                    label: 'With Icon',
                    icon: Icons.star,
                    isSelected: false,
                    onTap: () {},
                  ),
                  TossChip(
                    label: 'With Count',
                    showCount: true,
                    count: 5,
                    isSelected: false,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'Chip Group:',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              TossChipGroup(
                items: const [
                  TossChipItem(value: 'all', label: 'All', count: 10),
                  TossChipItem(value: 'pending', label: 'Pending', count: 3),
                  TossChipItem(value: 'completed', label: 'Completed', count: 7),
                ],
                selectedValue: _selectedChip,
                onChanged: (value) {
                  setState(() {
                    _selectedChip = value;
                  });
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // TossBadge
        _buildComponentShowcase(
          'TossBadge / TossStatusBadge',
          'Non-interactive badge for labels and statuses',
          'toss_badge.dart',
          const Wrap(
            spacing: TossSpacing.space2,
            runSpacing: TossSpacing.space2,
            children: [
              TossBadge(label: 'Default'),
              TossStatusBadge(
                label: 'Success',
                status: BadgeStatus.success,
                icon: Icons.check_circle,
              ),
              TossStatusBadge(
                label: 'Warning',
                status: BadgeStatus.warning,
                icon: Icons.warning,
              ),
              TossStatusBadge(
                label: 'Error',
                status: BadgeStatus.error,
                icon: Icons.error,
              ),
              TossStatusBadge(
                label: 'Info',
                status: BadgeStatus.info,
                icon: Icons.info,
              ),
            ],
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // TossTabBar1
        _buildComponentShowcase(
          'TossTabBar1',
          'Tab bar component with underline indicator',
          'toss_tab_bar_1.dart',
          Column(
            children: [
              TossTabBar1(
                tabs: const ['Cash', 'Bank', 'Vault'],
                controller: _tabController,
              ),
              SizedBox(
                height: 100,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Center(
                      child: Text(
                        'Cash Tab Content',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Bank Tab Content',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Vault Tab Content',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // KeyboardToolbar1 (Preview)
        _buildComponentShowcase(
          'KeyboardToolbar1',
          'Toolbar above keyboard with Previous/Next/Done buttons',
          'keyboard_toolbar_1.dart',
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: TossColors.gray200,
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: TossSpacing.space2),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_up),
                  iconSize: 24,
                  color: TossColors.gray700,
                  onPressed: null,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
                const SizedBox(width: TossSpacing.space1),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  iconSize: 24,
                  color: TossColors.gray700,
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: TossColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: TossSpacing.space2),
              ],
            ),
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // SafePopupMenu
        _buildComponentShowcase(
          'SafePopupMenu',
          'Popup menu with safe boundary detection to prevent overflow',
          'safe_popup_menu.dart',
          SafePopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: TossColors.gray700),
            onSelected: (value) {},
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 20),
                    SizedBox(width: 12),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: TossColors.error),
                    SizedBox(width: 12),
                    Text('Delete', style: TextStyle(color: TossColors.error)),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // TossAppBar1 (Preview)
        _buildComponentShowcase(
          'TossAppBar1',
          'Styled application bar with persistent design',
          'toss_app_bar_1.dart',
          Container(
            height: 56,
            decoration: const BoxDecoration(
              color: TossColors.white,
              border: Border(
                bottom: BorderSide(
                  color: TossColors.gray200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: TossColors.gray900),
                  onPressed: () {},
                ),
                Expanded(
                  child: Text(
                    'App Bar Title',
                    textAlign: TextAlign.center,
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: TossColors.gray900),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // EnhancedQuantitySelector
        _buildComponentShowcase(
          'EnhancedQuantitySelector',
          'Quantity input with increment/decrement buttons, haptic feedback, and long-press support',
          'enhanced_quantity_selector.dart',
          EnhancedQuantitySelector(
            quantity: _quantity,
            onQuantityChanged: (value) {
              setState(() {
                _quantity = value;
              });
            },
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // DebouncedButton
        _buildComponentShowcase(
          'DebouncedButton',
          'Button with automatic duplicate click prevention',
          'debounced_button.dart',
          DebouncedElevatedButton(
            onPressed: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space3,
              ),
              child: const Text(
                'Click Me',
                style: TextStyle(
                  color: TossColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // EmployeeProfileAvatar
        _buildComponentShowcase(
          'EmployeeProfileAvatar',
          'Circular avatar with employee initials',
          'employee_profile_avatar.dart',
          const Row(
            children: [
              EmployeeProfileAvatar(
                name: 'John Doe',
                size: 48,
              ),
              SizedBox(width: TossSpacing.space3),
              EmployeeProfileAvatar(
                name: 'Jane Smith',
                size: 40,
              ),
              SizedBox(width: TossSpacing.space3),
              EmployeeProfileAvatar(
                name: 'Bob Wilson',
                size: 32,
              ),
            ],
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // TossEmptyView
        _buildComponentShowcase(
          'TossEmptyView',
          'Empty state view with message and icon',
          'toss_empty_view.dart',
          const SizedBox(
            height: 200,
            child: TossEmptyView(
              title: 'No items found',
              description: 'There are no items to display',
            ),
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // TossLoadingView
        _buildComponentShowcase(
          'TossLoadingView',
          'Loading state with circular progress indicator',
          'toss_loading_view.dart',
          const SizedBox(
            height: 100,
            child: TossLoadingView(),
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // TossErrorView
        _buildComponentShowcase(
          'TossErrorView',
          'Error state view with retry option',
          'toss_error_view.dart',
          SizedBox(
            height: 320,
            child: TossErrorView(
              error: 'Network connection failed',
              title: 'Unable to load data',
              onRetry: () {},
            ),
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // TossDatePicker
        _buildComponentShowcase(
          'TossDatePicker',
          'Date picker with Toss styling',
          'toss_date_picker.dart',
          TossDatePicker(
            date: _selectedDate,
            placeholder: 'Select Date',
            onDateChanged: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // KeyboardToolbar1 (Note: Shows above keyboard in actual usage)
        _buildComponentShowcase(
          'KeyboardToolbar1',
          'Toolbar above keyboard with Previous/Next/Done buttons',
          'keyboard_toolbar_1.dart',
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              border: Border.all(
                color: TossColors.gray200,
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: TossSpacing.space2),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_up),
                  iconSize: 24,
                  color: TossColors.gray300,
                  onPressed: null,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
                const SizedBox(width: TossSpacing.space1),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  iconSize: 24,
                  color: TossColors.gray700,
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: TossColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: TossSpacing.space2),
              ],
            ),
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // TossAppBar1 Preview
        _buildComponentShowcase(
          'TossAppBar1',
          'Toss-styled application bar with consistent design',
          'toss_app_bar_1.dart',
          Container(
            height: 56,
            decoration: const BoxDecoration(
              color: TossColors.white,
              border: Border(
                bottom: BorderSide(
                  color: TossColors.gray200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: TossColors.gray900),
                  onPressed: () {},
                ),
                Expanded(
                  child: Text(
                    'App Bar Title',
                    textAlign: TextAlign.center,
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: TossColors.gray900),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // TossIconButton
        _buildComponentShowcase(
          'TossIconButton',
          'Icon button with Toss styling',
          'toss_icon_button.dart',
          Wrap(
            spacing: TossSpacing.space2,
            children: [
              TossIconButton(
                icon: Icons.favorite,
                onPressed: () {},
              ),
              TossIconButton.close(
                onPressed: () {},
              ),
              TossIconButton.delete(
                onPressed: () {},
              ),
              TossIconButton.settings(
                onPressed: () {},
              ),
              TossIconButton.add(
                onPressed: () {},
              ),
            ],
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // TossSearchField
        _buildComponentShowcase(
          'TossSearchField',
          'Search input field with search icon',
          'toss_search_field.dart',
          const TossSearchField(
            hintText: 'Search...',
            prefixIcon: Icons.search,
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // TossListTile
        _buildComponentShowcase(
          'TossListTile',
          'List tile with Toss styling',
          'toss_list_tile.dart',
          Column(
            children: [
              TossListTile(
                leading: const Icon(Icons.person),
                title: 'John Doe',
                subtitle: 'Manager',
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const SizedBox(height: TossSpacing.space2),
              TossListTile(
                leading: const Icon(Icons.store),
                title: 'Store Location',
                subtitle: '123 Main Street',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComponentShowcase(
    String name,
    String description,
    String filename,
    Widget component,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Component metadata
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: const BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.lg),
                topRight: Radius.circular(TossBorderRadius.lg),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  description,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  filename,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray400,
                    fontFamily: 'monospace',
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          // Actual component preview
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              minHeight: 80,
            ),
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: const BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(TossBorderRadius.lg),
                bottomRight: Radius.circular(TossBorderRadius.lg),
              ),
            ),
            child: component,
          ),
        ],
      ),
    );
  }
}
