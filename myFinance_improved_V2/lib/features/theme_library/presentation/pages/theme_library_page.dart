import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/debounced_button.dart';
import 'package:myfinance_improved/shared/widgets/common/employee_profile_avatar.dart';
import 'package:myfinance_improved/shared/widgets/common/enhanced_quantity_selector.dart';
import 'package:myfinance_improved/shared/widgets/common/safe_popup_menu.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_date_picker.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_empty_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_error_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_section_header.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_white_card.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_badge.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_bottom_sheet.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_button.dart' as toss_button;
import 'package:myfinance_improved/shared/widgets/toss/toss_button_1.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_card.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_card_safe.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_chip.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_dropdown.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_enhanced_text_field.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_icon_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_list_tile.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_modal.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_primary_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_refresh_indicator.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_search_field.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_secondary_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_selection_bottom_sheet.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_smart_action_bar.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_tab_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_text_field.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_time_picker.dart';

/// Theme Library Page
/// Visual showcase of all design system components
class ThemeLibraryPage extends StatefulWidget {
  const ThemeLibraryPage({super.key});

  @override
  State<ThemeLibraryPage> createState() => _ThemeLibraryPageState();
}

class _ThemeLibraryPageState extends State<ThemeLibraryPage> with SingleTickerProviderStateMixin {
  int _quantity = 5;
  late TabController _tabController;
  String? _selectedChip;
  String? _selectedDropdown;
  TimeOfDay? _selectedTime;
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textFieldController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      appBar: AppBar(
        title: const Text('Design Library'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(TossSpacing.paddingMD),
        children: [
          const _SectionHeader(title: 'Colors'),
          const _ColorsSection(),
          const SizedBox(height: TossSpacing.space8),

          const _SectionHeader(title: 'Typography'),
          const _TypographySection(),
          const SizedBox(height: TossSpacing.space8),

          const _SectionHeader(title: 'Spacing'),
          const _SpacingSection(),
          const SizedBox(height: TossSpacing.space8),

          const _SectionHeader(title: 'Border Radius'),
          const _BorderRadiusSection(),
          const SizedBox(height: TossSpacing.space8),

          const _SectionHeader(title: 'Buttons'),
          const _ButtonsSection(),
          const SizedBox(height: TossSpacing.space8),

          const _SectionHeader(title: 'Cards'),
          const _CardsSection(),
          const SizedBox(height: TossSpacing.space8),

          const _SectionHeader(title: 'Input Fields'),
          const _InputFieldsSection(),
          const SizedBox(height: TossSpacing.space8),

          const _SectionHeader(title: 'Toss Widgets'),
          _TossWidgetsSection(
            tabController: _tabController,
            selectedChip: _selectedChip,
            selectedDropdown: _selectedDropdown,
            selectedTime: _selectedTime,
            textFieldController: _textFieldController,
            searchController: _searchController,
            onChipChanged: (value) {
              setState(() {
                _selectedChip = value;
              });
            },
            onDropdownChanged: (value) {
              setState(() {
                _selectedDropdown = value;
              });
            },
            onTimeChanged: (value) {
              setState(() {
                _selectedTime = value;
              });
            },
          ),
          const SizedBox(height: TossSpacing.space8),

          const _SectionHeader(title: 'Common Widgets'),
          const _ComponentsSection(),
          const SizedBox(height: TossSpacing.space8),
        ],
      ),
    );
  }
}

/// Section Header Widget
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
      child: Text(
        title,
        style: TossTextStyles.h2.copyWith(
          color: TossColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Colors Section
class _ColorsSection extends StatelessWidget {
  const _ColorsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ColorGroup(
          title: 'Brand Colors',
          colors: [
            _ColorItem('Primary', TossColors.primary),
            _ColorItem('Primary Surface', TossColors.primarySurface),
          ],
        ),
        const SizedBox(height: TossSpacing.space4),
        _ColorGroup(
          title: 'Grayscale',
          colors: [
            _ColorItem('White', TossColors.white),
            _ColorItem('Gray 50', TossColors.gray50),
            _ColorItem('Gray 100', TossColors.gray100),
            _ColorItem('Gray 200', TossColors.gray200),
            _ColorItem('Gray 300', TossColors.gray300),
            _ColorItem('Gray 400', TossColors.gray400),
            _ColorItem('Gray 500', TossColors.gray500),
            _ColorItem('Gray 600', TossColors.gray600),
            _ColorItem('Gray 700', TossColors.gray700),
            _ColorItem('Gray 800', TossColors.gray800),
            _ColorItem('Gray 900', TossColors.gray900),
            _ColorItem('Black', TossColors.black),
          ],
        ),
        const SizedBox(height: TossSpacing.space4),
        _ColorGroup(
          title: 'Semantic Colors',
          colors: [
            _ColorItem('Success', TossColors.success),
            _ColorItem('Success Light', TossColors.successLight),
            _ColorItem('Error', TossColors.error),
            _ColorItem('Error Light', TossColors.errorLight),
            _ColorItem('Warning', TossColors.warning),
            _ColorItem('Warning Light', TossColors.warningLight),
            _ColorItem('Info', TossColors.info),
            _ColorItem('Info Light', TossColors.infoLight),
          ],
        ),
        const SizedBox(height: TossSpacing.space4),
        _ColorGroup(
          title: 'Financial Colors',
          colors: [
            _ColorItem('Profit', TossColors.profit),
            _ColorItem('Loss', TossColors.loss),
          ],
        ),
      ],
    );
  }
}

class _ColorGroup extends StatelessWidget {
  const _ColorGroup({
    required this.title,
    required this.colors,
  });

  final String title;
  final List<Widget> colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TossTextStyles.h4.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Wrap(
          spacing: TossSpacing.space2,
          runSpacing: TossSpacing.space2,
          children: colors,
        ),
      ],
    );
  }
}

class _ColorItem extends StatelessWidget {
  const _ColorItem(this.name, this.color);

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isLight = color.computeLuminance() > 0.5;

    return Container(
      width: 100,
      padding: const EdgeInsets.all(TossSpacing.space2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.border,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 18,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            name,
            style: TossTextStyles.caption.copyWith(
              color: isLight ? TossColors.textPrimary : TossColors.white,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Typography Section
class _TypographySection extends StatelessWidget {
  const _TypographySection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.card),
        border: Border.all(color: TossColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TypographyItem('Display - 32px/ExtraBold', 'Display Text', TossTextStyles.display),
          _TypographyItem('Headline Large - 28px/Bold', '\$12,480.32', TossTextStyles.headlineLarge),
          _TypographyItem('H1 - 28px/Bold', 'Page Title', TossTextStyles.h1),
          _TypographyItem('H2 - 24px/Bold', 'Section Header', TossTextStyles.h2),
          _TypographyItem('H3 - 20px/Semibold', 'Subsection', TossTextStyles.h3),
          _TypographyItem('H4 - 18px/Semibold', 'Card Title', TossTextStyles.h4),
          _TypographyItem('Title Large - 17px/Bold', 'People, Money', TossTextStyles.titleLarge),
          _TypographyItem('Title Medium - 15px/Bold', 'Today Revenue', TossTextStyles.titleMedium),
          _TypographyItem('Body Large - 14px/Regular', 'Body text, descriptions', TossTextStyles.bodyLarge),
          _TypographyItem('Body Medium - 14px/Semibold', 'Cash Ending', TossTextStyles.bodyMedium),
          _TypographyItem('Body - 14px/Regular', 'Default body text', TossTextStyles.body),
          _TypographyItem('Body Small - 13px/Semibold', '-3.2% vs Yesterday', TossTextStyles.bodySmall),
          _TypographyItem('Button - 14px/Semibold', 'Button Text', TossTextStyles.button),
          _TypographyItem('Label Large - 14px/Medium', 'Form Label', TossTextStyles.labelLarge),
          _TypographyItem('Label Medium - 12px/Semibold', 'Reconcile drawer', TossTextStyles.labelMedium),
          _TypographyItem('Label - 12px/Medium', 'UI Label', TossTextStyles.label),
          _TypographyItem('Label Small - 11px/Semibold', 'Attendance', TossTextStyles.labelSmall),
          _TypographyItem('Caption - 12px/Regular', 'Helper text', TossTextStyles.caption),
          _TypographyItem('Small - 11px/Regular', 'Tiny text', TossTextStyles.small),
          _TypographyItem('Amount - 20px/Semibold (Mono)', '₫1,234,567', TossTextStyles.amount),
        ],
      ),
    );
  }
}

/// Typography Item Helper Widget
class _TypographyItem extends StatelessWidget {
  const _TypographyItem(this.name, this.sample, this.style);

  final String name;
  final String sample;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(sample, style: style),
        ],
      ),
    );
  }
}

/// Spacing Section
class _SpacingSection extends StatelessWidget {
  const _SpacingSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.card),
        border: Border.all(color: TossColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SpacingItem('space0', TossSpacing.space0),
          _SpacingItem('space1 (4px)', TossSpacing.space1),
          _SpacingItem('space2 (8px)', TossSpacing.space2),
          _SpacingItem('space3 (12px)', TossSpacing.space3),
          _SpacingItem('space4 (16px)', TossSpacing.space4),
          _SpacingItem('space5 (20px)', TossSpacing.space5),
          _SpacingItem('space6 (24px)', TossSpacing.space6),
          _SpacingItem('space8 (32px)', TossSpacing.space8),
          _SpacingItem('space10 (40px)', TossSpacing.space10),
          _SpacingItem('space12 (48px)', TossSpacing.space12),
        ],
      ),
    );
  }
}

class _SpacingItem extends StatelessWidget {
  const _SpacingItem(this.name, this.value);

  final String name;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              name,
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            width: value,
            height: 24,
            decoration: BoxDecoration(
              color: TossColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              border: Border.all(color: TossColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

/// Border Radius Section
class _BorderRadiusSection extends StatelessWidget {
  const _BorderRadiusSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.card),
        border: Border.all(color: TossColors.border),
      ),
      child: Wrap(
        spacing: TossSpacing.space3,
        runSpacing: TossSpacing.space3,
        children: [
          _BorderRadiusItem('none', TossBorderRadius.none),
          _BorderRadiusItem('xs (4px)', TossBorderRadius.xs),
          _BorderRadiusItem('sm (6px)', TossBorderRadius.sm),
          _BorderRadiusItem('md (8px)', TossBorderRadius.md),
          _BorderRadiusItem('lg (12px)', TossBorderRadius.lg),
          _BorderRadiusItem('xl (16px)', TossBorderRadius.xl),
          _BorderRadiusItem('xxl (20px)', TossBorderRadius.xxl),
          _BorderRadiusItem('xxxl (24px)', TossBorderRadius.xxxl),
        ],
      ),
    );
  }
}

class _BorderRadiusItem extends StatelessWidget {
  const _BorderRadiusItem(this.name, this.radius);

  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: TossColors.primarySurface,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: TossColors.primary, width: 2),
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          name,
          style: TossTextStyles.caption.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Buttons Section
class _ButtonsSection extends StatelessWidget {
  const _ButtonsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.card),
        border: Border.all(color: TossColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {},
            child: const Text('Elevated Button'),
          ),
          const SizedBox(height: TossSpacing.space2),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Outlined Button'),
          ),
          const SizedBox(height: TossSpacing.space2),
          TextButton(
            onPressed: () {},
            child: const Text('Text Button'),
          ),
          const SizedBox(height: TossSpacing.space2),
          ElevatedButton(
            onPressed: null,
            child: const Text('Disabled Button'),
          ),
        ],
      ),
    );
  }
}

/// Cards Section
class _CardsSection extends StatelessWidget {
  const _CardsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(TossSpacing.paddingMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Card Title',
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'This is a standard card with border and no elevation. Perfect for clean, modern interfaces.',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        Container(
          padding: const EdgeInsets.all(TossSpacing.paddingMD),
          decoration: BoxDecoration(
            color: TossColors.primarySurface,
            borderRadius: BorderRadius.circular(TossBorderRadius.card),
            border: Border.all(color: TossColors.primary, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Highlighted Card',
                style: TossTextStyles.h4.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'A card with colored background for emphasis.',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Input Fields Section
class _InputFieldsSection extends StatelessWidget {
  const _InputFieldsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.card),
        border: Border.all(color: TossColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Default Input',
              hintText: 'Enter text here',
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Input with Helper',
              hintText: 'Enter text',
              helperText: 'This is helper text',
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Input with Error',
              hintText: 'Enter text',
              errorText: 'This field is required',
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Disabled Input',
              hintText: 'Cannot edit',
            ),
            enabled: false,
          ),
        ],
      ),
    );
  }
}

/// Components Section - All common widgets from /lib/shared/widgets/common
class _ComponentsSection extends StatefulWidget {
  const _ComponentsSection();

  @override
  State<_ComponentsSection> createState() => _ComponentsSectionState();
}

class _ComponentsSectionState extends State<_ComponentsSection> {
  int _quantity = 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Buttons
        _ComponentShowcase(
          name: 'DebouncedButton',
          description: 'Button with automatic duplicate click prevention',
          filename: 'debounced_button.dart',
          child: Wrap(
            spacing: TossSpacing.space2,
            runSpacing: TossSpacing.space2,
            children: [
              DebouncedElevatedButton(
                onPressed: () {},
                child: const Text('Elevated'),
              ),
              DebouncedOutlinedButton(
                onPressed: () {},
                child: const Text('Outlined'),
              ),
              DebouncedTextButton(
                onPressed: () {},
                child: const Text('Text'),
              ),
              DebouncedIconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite),
              ),
            ],
          ),
        ),

        // Avatars
        _ComponentShowcase(
          name: 'EmployeeProfileAvatar',
          description: 'Circular avatar with employee initials',
          filename: 'employee_profile_avatar.dart',
          child: Row(
            children: [
              const EmployeeProfileAvatar(
                name: 'John Doe',
                size: 40,
              ),
              const SizedBox(width: TossSpacing.space2),
              const EmployeeProfileAvatar(
                name: 'Sarah Smith',
                size: 40,
                showBorder: true,
                borderColor: TossColors.primary,
              ),
              const SizedBox(width: TossSpacing.space2),
              const EmployeeProfileAvatar(
                name: 'Mike Chen',
                size: 40,
              ),
            ],
          ),
        ),

        // Empty State
        _ComponentShowcase(
          name: 'TossEmptyView',
          description: 'Empty state view with message and icon',
          filename: 'toss_empty_view.dart',
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: const TossEmptyView(
              icon: Icon(
                Icons.inbox_outlined,
                size: 48,
                color: TossColors.gray400,
              ),
              title: 'No items found',
              description: 'Try adjusting your filters',
            ),
          ),
        ),

        // Loading State
        _ComponentShowcase(
          name: 'TossLoadingView',
          description: 'Loading state with circular progress indicator',
          filename: 'toss_loading_view.dart',
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: const TossLoadingView(),
          ),
        ),

        // Error State
        _ComponentShowcase(
          name: 'TossErrorView',
          description: 'Error state view with retry option',
          filename: 'toss_error_view.dart',
          child: Container(
            height: 320,
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: TossErrorView(
              error: Exception('Failed to load data'),
              onRetry: () {},
              title: 'Error',
            ),
          ),
        ),

        // Section Header
        _ComponentShowcase(
          name: 'TossSectionHeader',
          description: 'Section header with title and optional action',
          filename: 'toss_section_header.dart',
          child: TossSectionHeader(
            title: 'Recent Transactions',
            icon: Icons.receipt_long,
            trailing: TextButton(
              onPressed: () {},
              child: const Text('View All'),
            ),
          ),
        ),

        // White Card
        _ComponentShowcase(
          name: 'TossWhiteCard',
          description: 'White card container with border radius and shadow',
          filename: 'toss_white_card.dart',
          child: TossWhiteCard(
            padding: const EdgeInsets.all(TossSpacing.paddingMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Card Title',
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'This is a TossWhiteCard with shadow and border',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Components that require special context (dialogs, sheets, etc)
        _ComponentShowcase(
          name: 'EnhancedQuantitySelector',
          description: 'Quantity input with increment/decrement buttons, haptic feedback, and long-press support',
          filename: 'enhanced_quantity_selector.dart',
          child: EnhancedQuantitySelector(
            quantity: _quantity,
            onQuantityChanged: (value) {
              setState(() {
                _quantity = value;
              });
            },
          ),
        ),
        _ComponentShowcase(
          name: 'KeyboardToolbar',
          description: 'Toolbar above keyboard with Previous/Next/Done buttons for form navigation',
          filename: 'keyboard_toolbar_1.dart',
          child: Container(
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
        _ComponentShowcase(
          name: 'SafePopupMenu',
          description: 'Popup menu with safe boundary detection to prevent overflow',
          filename: 'safe_popup_menu.dart',
          child: Align(
            alignment: Alignment.centerLeft,
            child: SafePopupMenuButton<String>(
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
        ),
        _ComponentShowcase(
          name: 'StoreSelectorPopup',
          description: 'Popup for selecting store locations with search functionality',
          filename: 'store_selector_popup.dart',
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.store),
            label: const Text('Select Store'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.primary,
              foregroundColor: TossColors.white,
            ),
          ),
        ),
        _ComponentShowcase(
          name: 'TossAppBar',
          description: 'Toss-styled application bar with consistent design',
          filename: 'toss_app_bar_1.dart',
          child: Container(
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
            child: const TossAppBar1(
              title: 'App Bar Title',
            ),
          ),
        ),
        _ComponentShowcase(
          name: 'TossCalendarBottomSheet',
          description: 'Bottom sheet with calendar date picker',
          filename: 'toss_calendar_bottom_sheet.dart',
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.calendar_today),
            label: const Text('Show Calendar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.primary,
              foregroundColor: TossColors.white,
            ),
          ),
        ),
        _ComponentShowcase(
          name: 'TossConfirmCancelDialog',
          description: 'Dialog with confirm and cancel actions for user confirmation',
          filename: 'toss_confirm_cancel_dialog.dart',
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Show Dialog'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.primary,
              foregroundColor: TossColors.white,
            ),
          ),
        ),
        _ComponentShowcase(
          name: 'TossDatePicker',
          description: 'Date picker with Toss styling and Vietnamese locale support',
          filename: 'toss_date_picker.dart',
          child: TossDatePicker(
            date: DateTime.now(),
            placeholder: 'Select Date',
            onDateChanged: (date) {},
          ),
        ),
        _ComponentShowcase(
          name: 'TossScaffold',
          description: 'Scaffold with Toss design system styling (used as base for all pages)',
          filename: 'toss_scaffold.dart',
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.gray200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Base layout for all pages',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.textSecondary,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                Row(
                  children: [
                    Icon(Icons.check_circle, size: 16, color: TossColors.success),
                    const SizedBox(width: TossSpacing.space1),
                    Text(
                      'White background',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        _ComponentShowcase(
          name: 'TossSuccessErrorDialog',
          description: 'Dialog for showing success or error messages with custom actions',
          filename: 'toss_success_error_dialog.dart',
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.check_circle, size: 18),
                  label: const Text('Success'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TossColors.success,
                    foregroundColor: TossColors.white,
                  ),
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.error, size: 18),
                  label: const Text('Error'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TossColors.error,
                    foregroundColor: TossColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Toss Widgets Section - Specialized Toss design system widgets
class _TossWidgetsSection extends StatelessWidget {
  const _TossWidgetsSection({
    required this.tabController,
    required this.selectedChip,
    required this.selectedDropdown,
    required this.selectedTime,
    required this.textFieldController,
    required this.searchController,
    required this.onChipChanged,
    required this.onDropdownChanged,
    required this.onTimeChanged,
  });

  final TabController tabController;
  final String? selectedChip;
  final String? selectedDropdown;
  final TimeOfDay? selectedTime;
  final TextEditingController textFieldController;
  final TextEditingController searchController;
  final ValueChanged<String?> onChipChanged;
  final ValueChanged<String?> onDropdownChanged;
  final ValueChanged<TimeOfDay> onTimeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TossTabBar1
        _ComponentShowcase(
          name: 'TossTabBar1',
          description: 'Tab bar with Toss design system styling and underline indicator',
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
              controller: tabController,
              onTabChanged: (index) {},
            ),
          ),
        ),

        // TossButton1
        _ComponentShowcase(
          name: 'TossButton1',
          description: 'Unified button with primary/secondary variants and full customization',
          filename: 'toss_button_1.dart',
          child: Wrap(
            spacing: TossSpacing.space2,
            runSpacing: TossSpacing.space2,
            children: [
              TossButton1.primary(
                text: 'Primary',
                onPressed: () {},
              ),
              TossButton1.secondary(
                text: 'Secondary',
                onPressed: () {},
              ),
              TossButton1.primary(
                text: 'With Icon',
                leadingIcon: const Icon(Icons.add, size: 16),
                onPressed: () {},
              ),
              TossButton1.primary(
                text: 'Loading',
                isLoading: true,
                onPressed: () {},
              ),
              TossButton1.primary(
                text: 'Disabled',
                isEnabled: false,
                onPressed: () {},
              ),
            ],
          ),
        ),

        // TossChip
        _ComponentShowcase(
          name: 'TossChip & TossChipGroup',
          description: 'Filter chips with selection states and count badges',
          filename: 'toss_chip.dart',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Single Chips',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Wrap(
                spacing: TossSpacing.space2,
                runSpacing: TossSpacing.space2,
                children: [
                  TossChip(
                    label: 'Active',
                    isSelected: true,
                    onTap: () {},
                  ),
                  TossChip(
                    label: 'Inactive',
                    isSelected: false,
                    onTap: () {},
                  ),
                  TossChip(
                    label: 'With Icon',
                    icon: Icons.filter_list,
                    onTap: () {},
                  ),
                  TossChip(
                    label: 'Count',
                    showCount: true,
                    count: 5,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: TossSpacing.space3),
              Text(
                'Chip Group',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              TossChipGroup(
                items: const [
                  TossChipItem(value: 'all', label: 'All', count: 42),
                  TossChipItem(value: 'pending', label: 'Pending', count: 12, icon: Icons.pending),
                  TossChipItem(value: 'completed', label: 'Completed', count: 30, icon: Icons.check_circle),
                ],
                selectedValue: selectedChip,
                onChanged: onChipChanged,
              ),
            ],
          ),
        ),

        // TossBadge
        _ComponentShowcase(
          name: 'TossBadge & TossStatusBadge',
          description: 'Non-interactive badges for labels, statuses, and categories',
          filename: 'toss_badge.dart',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Basic Badges',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Wrap(
                spacing: TossSpacing.space2,
                runSpacing: TossSpacing.space2,
                children: const [
                  TossBadge(label: 'Default'),
                  TossBadge(
                    label: 'Custom',
                    backgroundColor: TossColors.primarySurface,
                    textColor: TossColors.primary,
                  ),
                  TossBadge(
                    label: 'With Icon',
                    icon: Icons.star,
                  ),
                ],
              ),
              const SizedBox(height: TossSpacing.space3),
              Text(
                'Status Badges',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Wrap(
                spacing: TossSpacing.space2,
                runSpacing: TossSpacing.space2,
                children: const [
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
                  TossStatusBadge(
                    label: 'Neutral',
                    status: BadgeStatus.neutral,
                  ),
                ],
              ),
            ],
          ),
        ),

        // TossTextField
        _ComponentShowcase(
          name: 'TossTextField',
          description: 'Text input field with label and validation support',
          filename: 'toss_text_field.dart',
          child: Column(
            children: [
              TossTextField(
                label: 'Username',
                hintText: 'Enter your username',
                controller: textFieldController,
              ),
              const SizedBox(height: TossSpacing.space3),
              TossTextField(
                label: 'Password',
                hintText: 'Enter password',
                obscureText: true,
                suffixIcon: const Icon(Icons.visibility_off),
              ),
            ],
          ),
        ),

        // TossSearchField
        _ComponentShowcase(
          name: 'TossSearchField',
          description: 'Search field with debounce and clear functionality',
          filename: 'toss_search_field.dart',
          child: TossSearchField(
            hintText: 'Search...',
            controller: searchController,
            prefixIcon: Icons.search,
            onChanged: (value) {},
          ),
        ),

        // TossDropdown
        _ComponentShowcase(
          name: 'TossDropdown',
          description: 'Dropdown with bottom sheet selection',
          filename: 'toss_dropdown.dart',
          child: TossDropdown<String>(
            label: 'Category',
            hint: 'Select a category',
            value: selectedDropdown,
            items: const [
              TossDropdownItem(value: 'food', label: 'Food & Drinks', subtitle: 'Meals and beverages'),
              TossDropdownItem(value: 'transport', label: 'Transportation', subtitle: 'Travel expenses'),
              TossDropdownItem(value: 'shopping', label: 'Shopping', subtitle: 'Retail purchases'),
            ],
            onChanged: onDropdownChanged,
          ),
        ),

        // TossTimePicker
        _ComponentShowcase(
          name: 'TossTimePicker',
          description: 'Wheel-style time picker with AM/PM support',
          filename: 'toss_time_picker.dart',
          child: TossTimePicker(
            time: selectedTime,
            placeholder: 'Select time',
            onTimeChanged: onTimeChanged,
          ),
        ),

        // TossIconButton
        _ComponentShowcase(
          name: 'TossIconButton',
          description: 'Icon buttons with factory methods for common actions',
          filename: 'toss_icon_button.dart',
          child: Wrap(
            spacing: TossSpacing.space2,
            runSpacing: TossSpacing.space2,
            children: [
              TossIconButton.close(onPressed: () {}),
              TossIconButton.back(onPressed: () {}),
              TossIconButton.add(onPressed: () {}),
              TossIconButton.edit(onPressed: () {}),
              TossIconButton.delete(onPressed: () {}),
              TossIconButton.settings(onPressed: () {}),
              TossIconButton.refresh(onPressed: () {}),
              TossIconButton.filter(onPressed: () {}),
              TossIconButton.search(onPressed: () {}),
            ],
          ),
        ),

        // TossCard
        _ComponentShowcase(
          name: 'TossCard',
          description: 'Card with micro-interactions and tap animations',
          filename: 'toss_card.dart',
          child: TossCard(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tappable Card',
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'Tap this card to see the animation effect',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),

        // TossListTile
        _ComponentShowcase(
          name: 'TossListTile',
          description: 'List tile with smooth animations and selection state',
          filename: 'toss_list_tile.dart',
          child: Column(
            children: [
              TossListTile(
                title: 'Default List Tile',
                subtitle: 'With subtitle text',
                leading: const Icon(Icons.person, color: TossColors.primary),
                trailing: const Icon(Icons.chevron_right, color: TossColors.gray400),
                onTap: () {},
              ),
              TossListTile(
                title: 'Selected Tile',
                subtitle: 'This tile is selected',
                leading: const Icon(Icons.check_circle, color: TossColors.primary),
                selected: true,
                onTap: () {},
              ),
            ],
          ),
        ),

        // TossModal
        _ComponentShowcase(
          name: 'TossModal, TossFormModal & TossConfirmationModal',
          description: 'Bottom sheet modals with animations and keyboard handling',
          filename: 'toss_modal.dart',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  TossModal.show(
                    context: context,
                    title: 'Basic Modal',
                    subtitle: 'This is a subtitle',
                    child: const Padding(
                      padding: EdgeInsets.all(TossSpacing.space4),
                      child: Text('This is the modal content. You can put any widget here.'),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
                icon: const Icon(Icons.info_outline, size: 18),
                label: const Text('Show Basic Modal'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TossColors.primary,
                  foregroundColor: TossColors.white,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              ElevatedButton.icon(
                onPressed: () {
                  TossFormModal.show(
                    context: context,
                    title: 'Form Modal',
                    subtitle: 'Fill in the details',
                    child: const Column(
                      children: [
                        TossTextField(
                          label: 'Name',
                          hintText: 'Enter name',
                        ),
                        SizedBox(height: TossSpacing.space3),
                        TossTextField(
                          label: 'Email',
                          hintText: 'Enter email',
                        ),
                      ],
                    ),
                    saveButtonText: 'Submit',
                    onSave: () => Navigator.pop(context),
                  );
                },
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Show Form Modal'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TossColors.success,
                  foregroundColor: TossColors.white,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              ElevatedButton.icon(
                onPressed: () {
                  TossConfirmationModal.show(
                    context: context,
                    title: 'Delete Item?',
                    message: 'Are you sure you want to delete this item? This action cannot be undone.',
                    icon: Icons.warning_rounded,
                    confirmText: 'Delete',
                    confirmColor: TossColors.error,
                  );
                },
                icon: const Icon(Icons.delete, size: 18),
                label: const Text('Show Confirmation'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TossColors.error,
                  foregroundColor: TossColors.white,
                ),
              ),
            ],
          ),
        ),

        // Additional Button Variants
        _ComponentShowcase(
          name: 'TossButton, TossPrimaryButton & TossSecondaryButton',
          description: 'Unified button system with primary and secondary variants',
          filename: 'toss_button.dart',
          child: Column(
            children: [
              Text(
                'TossButton (Unified)',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Wrap(
                spacing: TossSpacing.space2,
                runSpacing: TossSpacing.space2,
                children: [
                  toss_button.TossButton.primary(
                    text: 'Primary',
                    onPressed: () {},
                  ),
                  toss_button.TossButton.secondary(
                    text: 'Secondary',
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: TossSpacing.space3),
              Text(
                'Legacy Wrappers',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Wrap(
                spacing: TossSpacing.space2,
                runSpacing: TossSpacing.space2,
                children: [
                  TossPrimaryButton(
                    text: 'Primary',
                    onPressed: () {},
                  ),
                  TossSecondaryButton(
                    text: 'Secondary',
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),

        // TossCardSafe
        _ComponentShowcase(
          name: 'TossCardSafe',
          description: 'Memory-safe card variant without animations (ideal for lists)',
          filename: 'toss_card_safe.dart',
          child: TossCardSafe(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Safe Card',
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'No animations, perfect for database lists and heavy operations',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),

        // TossEnhancedTextField
        _ComponentShowcase(
          name: 'TossEnhancedTextField',
          description: 'Text field with keyboard toolbar and enhanced UX features',
          filename: 'toss_enhanced_text_field.dart',
          child: const TossTextField(
            label: 'Enhanced Field (Basic Demo)',
            hintText: 'Full version includes keyboard toolbar',
          ),
        ),

        // TossRefreshIndicator
        _ComponentShowcase(
          name: 'TossRefreshIndicator',
          description: 'Pull-to-refresh wrapper with Toss styling',
          filename: 'toss_refresh_indicator.dart',
          child: SizedBox(
            height: 100,
            child: TossRefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView(
                children: const [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(TossSpacing.space4),
                      child: Text('Pull down to refresh'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // TossBottomSheet
        _ComponentShowcase(
          name: 'TossBottomSheet',
          description: 'Simple bottom sheet with action items',
          filename: 'toss_bottom_sheet.dart',
          child: ElevatedButton.icon(
            onPressed: () {
              TossBottomSheet.show(
                context: context,
                title: 'Select Action',
                content: const Padding(
                  padding: EdgeInsets.all(TossSpacing.space4),
                  child: Text('Choose an option below'),
                ),
                actions: [
                  TossActionItem(
                    title: 'Option 1',
                    onTap: () => Navigator.pop(context),
                  ),
                  TossActionItem(
                    title: 'Option 2',
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              );
            },
            icon: const Icon(Icons.more_vert, size: 18),
            label: const Text('Show Bottom Sheet'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.primary,
              foregroundColor: TossColors.white,
            ),
          ),
        ),

        // TossSelectionBottomSheet
        _ComponentShowcase(
          name: 'TossSelectionBottomSheet',
          description: 'Selection bottom sheet with search and item selection',
          filename: 'toss_selection_bottom_sheet.dart',
          child: ElevatedButton.icon(
            onPressed: () {
              TossSelectionBottomSheet.show(
                context: context,
                title: 'Select Item',
                items: [
                  const TossSelectionItem(
                    id: '1',
                    title: 'Item 1',
                    subtitle: 'Description 1',
                    icon: Icons.star,
                  ),
                  const TossSelectionItem(
                    id: '2',
                    title: 'Item 2',
                    subtitle: 'Description 2',
                    icon: Icons.favorite,
                  ),
                ],
                onItemSelected: (item) {
                  Navigator.pop(context);
                },
              );
            },
            icon: const Icon(Icons.list, size: 18),
            label: const Text('Show Selection Sheet'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.success,
              foregroundColor: TossColors.white,
            ),
          ),
        ),

        // TossSmartActionBar - Note: Requires special scaffold setup
        _ComponentShowcase(
          name: 'TossSmartActionBar',
          description: 'Action bar that positions above keyboard (requires scaffold context)',
          filename: 'toss_smart_action_bar.dart',
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.gray200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TossSmartActionBar',
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'This widget requires special scaffold setup and is used in modal/form contexts. '
                  'It intelligently positions action buttons above the keyboard.',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.textSecondary,
                  ),
                ),
                const SizedBox(height: TossSpacing.space3),
                Text(
                  'Usage:',
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.textSecondary,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  'TossSmartActionBar(\n'
                  '  actions: [\n'
                  '    TossActionButton(\n'
                  '      label: "Save",\n'
                  '      icon: Icons.check,\n'
                  '      onTap: () {},\n'
                  '    ),\n'
                  '  ],\n'
                  ')',
                  style: TossTextStyles.caption.copyWith(
                    fontFamily: 'monospace',
                    color: TossColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Component showcase with visual example
class _ComponentShowcase extends StatelessWidget {
  const _ComponentShowcase({
    super.key,
    required this.name,
    required this.description,
    required this.filename,
    required this.child,
  });

  final String name;
  final String description;
  final String filename;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TossTextStyles.h4.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          description,
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          filename,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textTertiary,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        child,
        const SizedBox(height: TossSpacing.space4),
      ],
    );
  }
}

/// Component info (text-only, no visual example)
class _ComponentInfo extends StatelessWidget {
  const _ComponentInfo({
    required this.name,
    required this.description,
    required this.filename,
  });

  final String name;
  final String description;
  final String filename;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TossTextStyles.h4.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          description,
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          filename,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textTertiary,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
      ],
    );
  }
}

