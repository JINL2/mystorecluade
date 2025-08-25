import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import '../models/counter_party_models.dart' as models;
import '../models/counter_party_models.dart' show CounterPartyType, CounterPartySortOption;
import '../constants/counter_party_colors.dart';
import '../providers/counter_party_providers.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../../../widgets/toss/toss_secondary_button.dart';
import '../../../widgets/toss/toss_chip.dart';

class CounterPartyFilter extends ConsumerStatefulWidget {
  const CounterPartyFilter({super.key});

  @override
  ConsumerState<CounterPartyFilter> createState() => _CounterPartyFilterState();
}

class _CounterPartyFilterState extends ConsumerState<CounterPartyFilter> {
  late models.CounterPartyFilter _filter;
  final List<CounterPartyType> _selectedTypes = [];
  bool? _isInternal;

  @override
  void initState() {
    super.initState();
    _filter = ref.read(counterPartyFilterProvider);
    _selectedTypes.addAll(_filter.types ?? []);
    _isInternal = _filter.isInternal;
  }

  void _applyFilter() {
    final newFilter = _filter.copyWith(
      types: _selectedTypes.isEmpty ? null : List.from(_selectedTypes),
      isInternal: _isInternal,
    );
    ref.read(counterPartyFilterProvider.notifier).state = newFilter;
    Navigator.of(context).pop();
  }

  void _resetFilter() {
    setState(() {
      _selectedTypes.clear();
      _isInternal = null;
    });
  }

  void _toggleType(CounterPartyType type) {
    setState(() {
      if (_selectedTypes.contains(type)) {
        _selectedTypes.remove(type);
      } else {
        _selectedTypes.add(type);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xl),
          topRight: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toss-style handle
          Center(
            child: Container(
              margin: EdgeInsets.only(top: TossSpacing.space3, bottom: TossSpacing.space4),
              width: TossSpacing.space12,
              height: TossSpacing.space1,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossSpacing.space1),
              ),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
            child: Text(
              'Filter by Type',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(height: TossSpacing.space4),

          // Scrollable Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type chips
                  _buildTypeChips(),
                  
                  SizedBox(height: TossSpacing.space5),
                  
                  // Category section
                  _buildCategorySection(),
                  
                  SizedBox(height: TossSpacing.space6),
                ],
              ),
            ),
          ),

          // Fixed Action buttons at bottom
          Container(
            padding: EdgeInsets.fromLTRB(
              TossSpacing.space5,
              TossSpacing.space3,
              TossSpacing.space5,
              TossSpacing.space5,
            ),
            decoration: BoxDecoration(
              color: TossColors.surface,
              border: Border(
                top: BorderSide(
                  color: TossColors.gray100,
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: _buildActionButtons(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChips() {
    final types = [
      {'type': CounterPartyType.myCompany, 'icon': Icons.business, 'label': 'My Company'},
      {'type': CounterPartyType.teamMember, 'icon': Icons.group, 'label': 'Team Member'},
      {'type': CounterPartyType.supplier, 'icon': Icons.local_shipping, 'label': 'Suppliers'},
      {'type': CounterPartyType.employee, 'icon': Icons.badge, 'label': 'Employees'},
      {'type': CounterPartyType.customer, 'icon': Icons.people, 'label': 'Customers'},
      {'type': CounterPartyType.other, 'icon': Icons.category, 'label': 'Others'},
    ];

    return Wrap(
      spacing: TossSpacing.space2,
      runSpacing: TossSpacing.space2,
      children: types.map((typeData) {
        final type = typeData['type'] as CounterPartyType;
        final icon = typeData['icon'] as IconData;
        final label = typeData['label'] as String;
        final isSelected = _selectedTypes.contains(type);
        
        return TossChip(
          label: label,
          icon: icon,
          isSelected: isSelected,
          onTap: () => _toggleType(type),
        );
      }).toList(),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: TossTextStyles.labelLarge.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: TossSpacing.space3),
        Row(
          children: [
            Expanded(
              child: TossChip(
                label: 'All',
                isSelected: _isInternal == null,
                onTap: () => setState(() => _isInternal = null),
              ),
            ),
            SizedBox(width: TossSpacing.space2),
            Expanded(
              child: TossChip(
                label: 'Internal',
                isSelected: _isInternal == true,
                onTap: () => setState(() => _isInternal = true),
              ),
            ),
            SizedBox(width: TossSpacing.space2),
            Expanded(
              child: TossChip(
                label: 'External',
                isSelected: _isInternal == false,
                onTap: () => setState(() => _isInternal = false),
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: TossSecondaryButton(
            text: 'Reset',
            onPressed: _resetFilter,
            fullWidth: true,
          ),
        ),
        SizedBox(width: TossSpacing.space3),
        Expanded(
          flex: 2,
          child: TossPrimaryButton(
            text: 'Apply Filters',
            onPressed: _applyFilter,
            fullWidth: true,
            leadingIcon: Icon(
              Icons.check,
              size: TossSpacing.iconXS,
              color: TossColors.textInverse,
            ),
          ),
        ),
      ],
    );
  }
}