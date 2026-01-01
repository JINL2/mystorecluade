import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/molecules/inputs/toss_quantity_stepper.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toss_secondary_button.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toss_primary_button.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toggle_button.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_expandable_card.dart';
import 'package:myfinance_improved/shared/widgets/atoms/inputs/toss_text_field.dart';
import 'package:myfinance_improved/shared/widgets/atoms/inputs/toss_search_field.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/toss_card.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/toss_badge.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/toss_chip.dart';
import 'package:myfinance_improved/shared/widgets/molecules/inputs/toss_dropdown.dart';

/// Toss Widgets Section - Interactive demos of shared/widgets/toss/
class TossExtendedSection extends StatefulWidget {
  const TossExtendedSection({super.key});

  @override
  State<TossExtendedSection> createState() => _TossExtendedSectionState();
}

class _TossExtendedSectionState extends State<TossExtendedSection> {
  // State for interactive demos
  int _stepperValue = 5;
  String _toggleSelectedId = 'week';
  bool _switchValue = false;
  bool _expandedCard = false;
  String _textFieldValue = '';
  String _searchValue = '';
  String? _selectedDropdown;
  final Set<String> _selectedChips = {'Option 1'};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Toss Widgets', 'shared/widgets/toss/'),
          _buildInfoBanner('Tap to interact with each widget'),
          const SizedBox(height: TossSpacing.space4),

          // ══════════════════════════════════════════════════════════════
          // BUTTONS
          // ══════════════════════════════════════════════════════════════
          _buildSubSectionTitle('Buttons'),

          _ComponentShowcase(
            name: 'TossPrimaryButton',
            filename: 'toss_primary_button.dart',
            child: Wrap(
              spacing: TossSpacing.space2,
              runSpacing: TossSpacing.space2,
              children: [
                TossPrimaryButton(
                  text: 'Primary',
                  onPressed: () => _showSnackBar('Primary tapped!'),
                ),
                TossPrimaryButton(
                  text: 'With Icon',
                  leadingIcon: const Icon(Icons.add, size: 16, color: TossColors.white),
                  onPressed: () => _showSnackBar('Icon button tapped!'),
                ),
                const TossPrimaryButton(
                  text: 'Disabled',
                  onPressed: null,
                ),
              ],
            ),
          ),

          _ComponentShowcase(
            name: 'TossSecondaryButton',
            filename: 'toss_secondary_button.dart',
            child: Wrap(
              spacing: TossSpacing.space2,
              runSpacing: TossSpacing.space2,
              children: [
                TossSecondaryButton(
                  text: 'Cancel',
                  onPressed: () => _showSnackBar('Cancel tapped!'),
                ),
                TossSecondaryButton(
                  text: 'With Icon',
                  leadingIcon: const Icon(Icons.close, size: 16),
                  onPressed: () => _showSnackBar('Close tapped!'),
                ),
                const TossSecondaryButton(
                  text: 'Disabled',
                  onPressed: null,
                ),
              ],
            ),
          ),

          // ══════════════════════════════════════════════════════════════
          // INPUTS
          // ══════════════════════════════════════════════════════════════
          _buildSubSectionTitle('Inputs'),

          _ComponentShowcase(
            name: 'TossTextField',
            filename: 'toss_text_field.dart',
            child: Column(
              children: [
                TossTextField(
                  label: 'Email',
                  hintText: 'Enter your email',
                  onChanged: (v) => setState(() => _textFieldValue = v),
                ),
                if (_textFieldValue.isNotEmpty) ...[
                  const SizedBox(height: TossSpacing.space2),
                  Text(
                    'Value: $_textFieldValue',
                    style: TossTextStyles.caption.copyWith(color: TossColors.primary),
                  ),
                ],
              ],
            ),
          ),

          _ComponentShowcase(
            name: 'TossSearchField',
            filename: 'toss_search_field.dart',
            child: Column(
              children: [
                TossSearchField(
                  hintText: 'Search items...',
                  onChanged: (v) => setState(() => _searchValue = v),
                ),
                if (_searchValue.isNotEmpty) ...[
                  const SizedBox(height: TossSpacing.space2),
                  Text(
                    'Searching: "$_searchValue"',
                    style: TossTextStyles.caption.copyWith(color: TossColors.primary),
                  ),
                ],
              ],
            ),
          ),

          _ComponentShowcase(
            name: 'TossQuantityStepper',
            filename: 'toss_quantity_stepper.dart',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: TossQuantityStepper(
                    initialValue: _stepperValue,
                    onChanged: (v) => setState(() => _stepperValue = v),
                    minValue: 0,
                    maxValue: 100,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'Value: $_stepperValue',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          _ComponentShowcase(
            name: 'TossDropdown',
            filename: 'toss_dropdown.dart',
            child: TossDropdown<String>(
              label: 'Select Fruit',
              value: _selectedDropdown,
              items: const [
                TossDropdownItem(value: 'apple', label: 'Apple', subtitle: 'Fresh red apple'),
                TossDropdownItem(value: 'banana', label: 'Banana', subtitle: 'Organic banana'),
                TossDropdownItem(value: 'cherry', label: 'Cherry', subtitle: 'Sweet cherries'),
                TossDropdownItem(value: 'date', label: 'Date', subtitle: 'Middle eastern dates'),
              ],
              onChanged: (v) => setState(() => _selectedDropdown = v),
              hint: 'Choose a fruit',
            ),
          ),

          // ══════════════════════════════════════════════════════════════
          // TOGGLES & SWITCHES
          // ══════════════════════════════════════════════════════════════
          _buildSubSectionTitle('Toggles'),

          _ComponentShowcase(
            name: 'ToggleButtonGroup',
            filename: 'toggle_button.dart',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ToggleButtonGroup(
                  items: const [
                    ToggleButtonItem(id: 'week', label: 'Week'),
                    ToggleButtonItem(id: 'month', label: 'Month'),
                    ToggleButtonItem(id: 'year', label: 'Year'),
                  ],
                  selectedId: _toggleSelectedId,
                  onToggle: (id) => setState(() => _toggleSelectedId = id),
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'Selected: $_toggleSelectedId',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          _ComponentShowcase(
            name: 'Switch (Flutter)',
            filename: 'flutter:material',
            child: Row(
              children: [
                Switch(
                  value: _switchValue,
                  onChanged: (v) => setState(() => _switchValue = v),
                  activeColor: TossColors.primary,
                ),
                const SizedBox(width: TossSpacing.space3),
                Text(
                  _switchValue ? 'ON' : 'OFF',
                  style: TossTextStyles.body.copyWith(
                    color: _switchValue ? TossColors.success : TossColors.gray500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // ══════════════════════════════════════════════════════════════
          // CARDS
          // ══════════════════════════════════════════════════════════════
          _buildSubSectionTitle('Cards'),

          _ComponentShowcase(
            name: 'TossCard',
            filename: 'toss_card.dart',
            child: TossCard(
              child: Padding(
                padding: const EdgeInsets.all(TossSpacing.space4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Simple Card', style: TossTextStyles.h4),
                    const SizedBox(height: TossSpacing.space2),
                    Text(
                      'This is a basic TossCard with content inside.',
                      style: TossTextStyles.body.copyWith(color: TossColors.gray600),
                    ),
                  ],
                ),
              ),
            ),
          ),

          _ComponentShowcase(
            name: 'TossExpandableCard',
            filename: 'toss_expandable_card.dart',
            child: TossExpandableCard(
              title: 'Expandable Card (Tap to expand)',
              isExpanded: _expandedCard,
              onToggle: () => setState(() => _expandedCard = !_expandedCard),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hidden Content',
                    style: TossTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: TossSpacing.space2),
                  Text(
                    'This content is revealed when the card is expanded. '
                    'You can put any widget here.',
                    style: TossTextStyles.body.copyWith(color: TossColors.gray600),
                  ),
                ],
              ),
            ),
          ),

          // ══════════════════════════════════════════════════════════════
          // BADGES & CHIPS
          // ══════════════════════════════════════════════════════════════
          _buildSubSectionTitle('Badges & Chips'),

          _ComponentShowcase(
            name: 'TossStatusBadge',
            filename: 'toss_badge.dart',
            child: Wrap(
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

          _ComponentShowcase(
            name: 'TossChip',
            filename: 'toss_chip.dart',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: TossSpacing.space2,
                  runSpacing: TossSpacing.space2,
                  children: ['Option 1', 'Option 2', 'Option 3'].map((option) {
                    final isSelected = _selectedChips.contains(option);
                    return TossChip(
                      label: option,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedChips.remove(option);
                          } else {
                            _selectedChips.add(option);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                if (_selectedChips.isNotEmpty) ...[
                  const SizedBox(height: TossSpacing.space2),
                  Text(
                    'Selected: ${_selectedChips.join(", ")}',
                    style: TossTextStyles.caption.copyWith(color: TossColors.primary),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: TossSpacing.space6),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildSectionTitle(String title, String path) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.bold,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            path,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textTertiary,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: TossSpacing.space4, bottom: TossSpacing.space3),
      child: Text(
        title,
        style: TossTextStyles.h4.copyWith(
          fontWeight: FontWeight.w600,
          color: TossColors.gray800,
        ),
      ),
    );
  }

  Widget _buildInfoBanner(String text) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.primarySurface,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.touch_app, color: TossColors.primary, size: 20),
          const SizedBox(width: TossSpacing.space3),
          Text(
            text,
            style: TossTextStyles.caption.copyWith(color: TossColors.primary),
          ),
        ],
      ),
    );
  }
}

/// Component showcase with visual example
class _ComponentShowcase extends StatelessWidget {
  const _ComponentShowcase({
    required this.name,
    required this.filename,
    required this.child,
  });

  final String name;
  final String filename;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                name,
                style: TossTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                filename,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textTertiary,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.gray200),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
