import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import '../models/counter_party_models.dart' as models;
import '../models/counter_party_models.dart' show CounterPartyType, CounterPartySortOption;
import '../providers/counter_party_providers.dart';

class CounterPartyFilter extends ConsumerStatefulWidget {
  const CounterPartyFilter({super.key});

  @override
  ConsumerState<CounterPartyFilter> createState() => _CounterPartyFilterState();
}

class _CounterPartyFilterState extends ConsumerState<CounterPartyFilter> {
  late models.CounterPartyFilter _filter;
  final List<CounterPartyType> _selectedTypes = [];
  CounterPartySortOption _sortBy = CounterPartySortOption.name;
  bool _ascending = true;
  bool? _isInternal;

  @override
  void initState() {
    super.initState();
    _filter = ref.read(counterPartyFilterProvider);
    _selectedTypes.addAll(_filter.types ?? []);
    _sortBy = _filter.sortBy;
    _ascending = _filter.ascending;
    _isInternal = _filter.isInternal;
  }

  void _applyFilter() {
    final newFilter = models.CounterPartyFilter(
      types: _selectedTypes.isEmpty ? null : List.from(_selectedTypes),
      sortBy: _sortBy,
      ascending: _ascending,
      isInternal: _isInternal,
    );
    ref.read(counterPartyFilterProvider.notifier).state = newFilter;
    Navigator.of(context).pop();
  }

  void _resetFilter() {
    setState(() {
      _selectedTypes.clear();
      _sortBy = CounterPartySortOption.name;
      _ascending = true;
      _isInternal = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toss-style minimal handle
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 12, bottom: 20),
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Clean content with Toss spacing
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type section - Visual chips with icons
                Row(
                  children: [
                    Icon(Icons.category_outlined, size: 18, color: TossColors.gray600),
                    SizedBox(width: 6),
                    Text(
                      'Filter by Type',
                      style: TossTextStyles.labelLarge.copyWith(
                        color: TossColors.gray700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                // Type grid - 3x2 modern cards
                Column(
                  children: [
                    Row(
                      children: [
                        _buildTypeCard(CounterPartyType.myCompany, Icons.business, const Color(0xFF007AFF)),
                        SizedBox(width: 8),
                        _buildTypeCard(CounterPartyType.teamMember, Icons.group, const Color(0xFF34C759)),
                        SizedBox(width: 8),
                        _buildTypeCard(CounterPartyType.supplier, Icons.local_shipping, const Color(0xFF5856D6)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        _buildTypeCard(CounterPartyType.employee, Icons.badge, const Color(0xFFFF9500)),
                        SizedBox(width: 8),
                        _buildTypeCard(CounterPartyType.customer, Icons.people, const Color(0xFFFF3B30)),
                        SizedBox(width: 8),
                        _buildTypeCard(CounterPartyType.other, Icons.category, const Color(0xFF8E8E93)),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 24),

                // Category section - Simple toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.business_center_outlined, size: 18, color: TossColors.gray600),
                        SizedBox(width: 6),
                        Text(
                          'Category',
                          style: TossTextStyles.labelLarge.copyWith(
                            color: TossColors.gray700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    // Toss-style segmented control
                    Container(
                      decoration: BoxDecoration(
                        color: TossColors.gray100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildSegmentButton('All', _isInternal == null, () => setState(() => _isInternal = null)),
                          _buildSegmentButton('Internal', _isInternal == true, () => setState(() => _isInternal = true)),
                          _buildSegmentButton('External', _isInternal == false, () => setState(() => _isInternal = false)),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                // Sort section - Clean dropdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.sort_outlined, size: 18, color: TossColors.gray600),
                        SizedBox(width: 6),
                        Text(
                          'Sort By',
                          style: TossTextStyles.labelLarge.copyWith(
                            color: TossColors.gray700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Sort field selector
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: TossColors.gray50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: TossColors.gray200),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<CounterPartySortOption>(
                              value: _sortBy,
                              isDense: true,
                              icon: Icon(Icons.arrow_drop_down, size: 20, color: TossColors.gray600),
                              style: TossTextStyles.body.copyWith(color: TossColors.gray900),
                              items: CounterPartySortOption.values.map((option) {
                                return DropdownMenuItem(
                                  value: option,
                                  child: Text(option.displayName, style: TossTextStyles.bodySmall),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) setState(() => _sortBy = value);
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        // Direction toggle
                        GestureDetector(
                          onTap: () => setState(() => _ascending = !_ascending),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: TossColors.gray50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: TossColors.gray200),
                            ),
                            child: Icon(
                              _ascending ? Icons.arrow_upward : Icons.arrow_downward,
                              size: 20,
                              color: TossColors.gray700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 32),
              ],
            ),
          ),

          // Bottom actions - Toss style with safe area
          Container(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: TossColors.gray100),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Reset button - subtle with icon
                  Expanded(
                    child: TextButton(
                      onPressed: _resetFilter,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: TossColors.gray50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh, size: 18, color: TossColors.gray600),
                          SizedBox(width: 6),
                          Text(
                            'Reset',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Apply button - primary with icon
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _applyFilter,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TossColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, size: 18, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            'Apply Filters',
                            style: TossTextStyles.body.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCard(CounterPartyType type, IconData icon, Color color) {
    final isSelected = _selectedTypes.contains(type);
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedTypes.remove(type);
            } else {
              _selectedTypes.add(type);
            }
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: 64,
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.08) : TossColors.gray50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? color : TossColors.gray200,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: color.withOpacity(0.12),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ] : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: isSelected ? color : TossColors.gray500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                type.displayName,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? color : TossColors.gray600,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ] : [],
        ),
        child: Text(
          label,
          style: TossTextStyles.bodySmall.copyWith(
            color: isSelected ? TossColors.gray900 : TossColors.gray500,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}