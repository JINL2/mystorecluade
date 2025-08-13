import 'package:flutter/material.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../../../widgets/toss/toss_secondary_button.dart';
import '../../../widgets/toss/toss_dropdown.dart';

class EmployeeFilterCriteria {
  final String? department;
  final String? performanceRating;
  final String? workLocation;
  final String? employmentType;
  final String? employmentStatus;
  final RangeValues? salaryRange;
  final String? sortBy;
  final bool sortAscending;

  const EmployeeFilterCriteria({
    this.department,
    this.performanceRating,
    this.workLocation,
    this.employmentType,
    this.employmentStatus,
    this.salaryRange,
    this.sortBy,
    this.sortAscending = true,
  });

  EmployeeFilterCriteria copyWith({
    String? department,
    String? performanceRating,
    String? workLocation,
    String? employmentType,
    String? employmentStatus,
    RangeValues? salaryRange,
    String? sortBy,
    bool? sortAscending,
  }) {
    return EmployeeFilterCriteria(
      department: department ?? this.department,
      performanceRating: performanceRating ?? this.performanceRating,
      workLocation: workLocation ?? this.workLocation,
      employmentType: employmentType ?? this.employmentType,
      employmentStatus: employmentStatus ?? this.employmentStatus,
      salaryRange: salaryRange ?? this.salaryRange,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  bool get hasActiveFilters {
    return department != null ||
           performanceRating != null ||
           workLocation != null ||
           employmentType != null ||
           employmentStatus != null ||
           salaryRange != null;
  }

  int get activeFilterCount {
    int count = 0;
    if (department != null) count++;
    if (performanceRating != null) count++;
    if (workLocation != null) count++;
    if (employmentType != null) count++;
    if (employmentStatus != null) count++;
    if (salaryRange != null) count++;
    return count;
  }
}

class EmployeeFilterSheet extends StatefulWidget {
  final EmployeeFilterCriteria initialCriteria;
  final Function(EmployeeFilterCriteria) onApplyFilters;

  const EmployeeFilterSheet({
    super.key,
    required this.initialCriteria,
    required this.onApplyFilters,
  });

  @override
  State<EmployeeFilterSheet> createState() => _EmployeeFilterSheetState();
}

class _EmployeeFilterSheetState extends State<EmployeeFilterSheet> {
  late EmployeeFilterCriteria _criteria;
  RangeValues _salaryRange = const RangeValues(0, 200000);

  @override
  void initState() {
    super.initState();
    _criteria = widget.initialCriteria;
    if (_criteria.salaryRange != null) {
      _salaryRange = _criteria.salaryRange!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          Expanded(child: _buildContent()),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: TossSpacing.space4),
          
          // Title and clear button
          Row(
            children: [
              Text(
                'Filter Employees',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (_criteria.hasActiveFilters)
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Clear All',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: 'Department',
            child: TossDropdown<String>(
              label: 'Department',
              value: _criteria.department,
              items: const [
                TossDropdownItem(value: 'Engineering', label: 'Engineering'),
                TossDropdownItem(value: 'Marketing', label: 'Marketing'),
                TossDropdownItem(value: 'Sales', label: 'Sales'),
                TossDropdownItem(value: 'HR', label: 'Human Resources'),
                TossDropdownItem(value: 'Finance', label: 'Finance'),
                TossDropdownItem(value: 'Operations', label: 'Operations'),
                TossDropdownItem(value: 'General', label: 'General'),
              ],
              onChanged: (value) => _updateCriteria(department: value),
            ),
          ),
          
          _buildSection(
            title: 'Performance Rating',
            child: TossDropdown<String>(
              label: 'Performance Rating',
              value: _criteria.performanceRating,
              items: const [
                TossDropdownItem(value: 'A+', label: 'A+ - Exceptional'),
                TossDropdownItem(value: 'A', label: 'A - Excellent'),
                TossDropdownItem(value: 'B', label: 'B - Good'),
                TossDropdownItem(value: 'C', label: 'C - Satisfactory'),
                TossDropdownItem(value: 'Needs Improvement', label: 'Needs Improvement'),
              ],
              onChanged: (value) => _updateCriteria(performanceRating: value),
            ),
          ),
          
          _buildSection(
            title: 'Work Location',
            child: TossDropdown<String>(
              label: 'Work Location',
              value: _criteria.workLocation,
              items: const [
                TossDropdownItem(value: 'Office', label: 'Office'),
                TossDropdownItem(value: 'Remote', label: 'Remote'),
                TossDropdownItem(value: 'Hybrid', label: 'Hybrid'),
              ],
              onChanged: (value) => _updateCriteria(workLocation: value),
            ),
          ),
          
          _buildSection(
            title: 'Employment Type',
            child: TossDropdown<String>(
              label: 'Employment Type',
              value: _criteria.employmentType,
              items: const [
                TossDropdownItem(value: 'Full-time', label: 'Full-time'),
                TossDropdownItem(value: 'Part-time', label: 'Part-time'),
                TossDropdownItem(value: 'Contract', label: 'Contract'),
                TossDropdownItem(value: 'Intern', label: 'Intern'),
              ],
              onChanged: (value) => _updateCriteria(employmentType: value),
            ),
          ),
          
          _buildSection(
            title: 'Employment Status',
            child: TossDropdown<String>(
              label: 'Employment Status',
              value: _criteria.employmentStatus,
              items: const [
                TossDropdownItem(value: 'Active', label: 'Active'),
                TossDropdownItem(value: 'On Leave', label: 'On Leave'),
                TossDropdownItem(value: 'Terminated', label: 'Terminated'),
              ],
              onChanged: (value) => _updateCriteria(employmentStatus: value),
            ),
          ),
          
          _buildSection(
            title: 'Salary Range',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Salary: \$${_salaryRange.start.round().toString()} - \$${_salaryRange.end.round().toString()}',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray700,
                  ),
                ),
                SizedBox(height: TossSpacing.space2),
                RangeSlider(
                  values: _salaryRange,
                  min: 0,
                  max: 200000,
                  divisions: 20,
                  labels: RangeLabels(
                    '\$${_salaryRange.start.round()}',
                    '\$${_salaryRange.end.round()}',
                  ),
                  onChanged: (values) {
                    setState(() {
                      _salaryRange = values;
                    });
                    _updateCriteria(salaryRange: values);
                  },
                ),
              ],
            ),
          ),
          
          _buildSection(
            title: 'Sort By',
            child: Column(
              children: [
                TossDropdown<String>(
                  label: 'Sort By',
                  value: _criteria.sortBy,
                  items: const [
                    TossDropdownItem(value: 'name', label: 'Name'),
                    TossDropdownItem(value: 'salary', label: 'Salary'),
                    TossDropdownItem(value: 'department', label: 'Department'),
                    TossDropdownItem(value: 'hire_date', label: 'Hire Date'),
                    TossDropdownItem(value: 'performance', label: 'Performance'),
                  ],
                  onChanged: (value) => _updateCriteria(sortBy: value),
                ),
                SizedBox(height: TossSpacing.space2),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: Text(
                          'Ascending',
                          style: TossTextStyles.body,
                        ),
                        value: _criteria.sortAscending,
                        onChanged: (value) => _updateCriteria(
                          sortAscending: value ?? true,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: TossSpacing.space8),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: TossSpacing.space4),
        Text(
          title,
          style: TossTextStyles.labelLarge.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: TossSpacing.space2),
        child,
        SizedBox(height: TossSpacing.space3),
      ],
    );
  }

  Widget _buildActions() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Row(
        children: [
          Expanded(
            child: TossSecondaryButton(
              text: 'Reset',
              onPressed: _resetFilters,
            ),
          ),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: TossPrimaryButton(
              text: _criteria.hasActiveFilters 
                  ? 'Apply (${_criteria.activeFilterCount})'
                  : 'Apply',
              onPressed: _applyFilters,
            ),
          ),
        ],
      ),
    );
  }

  void _updateCriteria({
    String? department,
    String? performanceRating,
    String? workLocation,
    String? employmentType,
    String? employmentStatus,
    RangeValues? salaryRange,
    String? sortBy,
    bool? sortAscending,
  }) {
    setState(() {
      _criteria = _criteria.copyWith(
        department: department,
        performanceRating: performanceRating,
        workLocation: workLocation,
        employmentType: employmentType,
        employmentStatus: employmentStatus,
        salaryRange: salaryRange,
        sortBy: sortBy,
        sortAscending: sortAscending,
      );
    });
  }

  void _clearAllFilters() {
    setState(() {
      _criteria = const EmployeeFilterCriteria();
      _salaryRange = const RangeValues(0, 200000);
    });
  }

  void _resetFilters() {
    setState(() {
      _criteria = widget.initialCriteria;
      if (_criteria.salaryRange != null) {
        _salaryRange = _criteria.salaryRange!;
      }
    });
  }

  void _applyFilters() {
    widget.onApplyFilters(_criteria);
    Navigator.of(context).pop();
  }
}