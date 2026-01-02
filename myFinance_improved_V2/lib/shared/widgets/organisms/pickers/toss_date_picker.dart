import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';

/// Simple wheel-style date picker matching Toss design system
/// Clean three-column layout: Month | Day | Year
class TossSimpleWheelDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final String title;
  final DateTime firstDate;
  final DateTime lastDate;
  final void Function(DateTime?) onDateSelected;

  const TossSimpleWheelDatePicker({
    super.key,
    this.initialDate,
    this.title = 'Select date',
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
  });

  @override
  State<TossSimpleWheelDatePicker> createState() => _TossSimpleWheelDatePickerState();
}

class _TossSimpleWheelDatePickerState extends State<TossSimpleWheelDatePicker> {
  late DateTime _selectedDate;
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _dayController;
  late FixedExtentScrollController _yearController;

  final List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    
    // Initialize scroll controllers
    _monthController = FixedExtentScrollController(
      initialItem: _selectedDate.month - 1,
    );
    
    _dayController = FixedExtentScrollController(
      initialItem: _selectedDate.day - 1,
    );
    
    _yearController = FixedExtentScrollController(
      initialItem: _selectedDate.year - widget.firstDate.year,
    );
  }

  @override
  void dispose() {
    _monthController.dispose();
    _dayController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TossColors.transparent,
      insetPadding: const EdgeInsets.all(TossSpacing.space4),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildWheelPickers()),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Row(
        children: [
          Text(
            widget.title,
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray900,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => widget.onDateSelected(null),
            icon: const Icon(Icons.close, color: TossColors.gray400),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildWheelPickers() {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          // Selection background indicator
          Positioned(
            left: 0,
            right: 0,
            top: 80,
            height: 40,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space2),
              decoration: BoxDecoration(
                color: TossColors.primarySurface,
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                border: Border.all(
                  color: TossColors.primary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
          ),
          
          // Wheel pickers
          Row(
            children: [
              // Month picker
              Expanded(
                child: _buildTossWheelPicker(
                  controller: _monthController,
                  items: _months,
                  onSelectedItemChanged: (index) {
                    final newDate = DateTime(_selectedDate.year, index + 1, _selectedDate.day);
                    final daysInMonth = _getDaysInMonth(newDate.year, newDate.month);
                    final adjustedDay = _selectedDate.day > daysInMonth ? daysInMonth : _selectedDate.day;
                    
                    setState(() {
                      _selectedDate = DateTime(newDate.year, newDate.month, adjustedDay);
                    });
                    
                    // Update day controller if needed
                    if (_selectedDate.day != newDate.day) {
                      _dayController.animateToItem(
                        _selectedDate.day - 1,
                        duration: TossAnimations.normal,
                        curve: TossAnimations.standard,
                      );
                    }
                  },
                ),
              ),

              // Day picker
              Expanded(
                child: _buildTossWheelPicker(
                  controller: _dayController,
                  items: List.generate(
                    _getDaysInMonth(_selectedDate.year, _selectedDate.month),
                    (index) => (index + 1).toString(),
                  ),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, index + 1);
                    });
                  },
                ),
              ),
              
              // Year picker
              Expanded(
                child: _buildTossWheelPicker(
                  controller: _yearController,
                  items: List.generate(
                    widget.lastDate.year - widget.firstDate.year + 1,
                    (index) => (widget.firstDate.year + index).toString(),
                  ),
                  onSelectedItemChanged: (index) {
                    final newYear = widget.firstDate.year + index;
                    final daysInMonth = _getDaysInMonth(newYear, _selectedDate.month);
                    final adjustedDay = _selectedDate.day > daysInMonth ? daysInMonth : _selectedDate.day;
                    
                    setState(() {
                      _selectedDate = DateTime(newYear, _selectedDate.month, adjustedDay);
                    });
                    
                    // Update day controller if needed
                    if (_selectedDate.day != adjustedDay) {
                      _dayController.animateToItem(
                        adjustedDay - 1,
                        duration: TossAnimations.normal,
                        curve: TossAnimations.standard,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTossWheelPicker({
    required FixedExtentScrollController controller,
    required List<String> items,
    required void Function(int) onSelectedItemChanged,
  }) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        return false;
      },
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 40,
        perspective: 0.005,
        diameterRatio: 1.2,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onSelectedItemChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            if (index < 0 || index >= items.length) return null;
            
            final isSelected = controller.hasClients && 
                controller.selectedItem == index;
            
            return _buildPickerItem(items[index], isSelected);
          },
          childCount: items.length,
        ),
      ),
    );
  }

  Widget _buildPickerItem(String text, bool isSelected) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TossTextStyles.h4.copyWith(
          color: isSelected ? TossColors.primary : TossColors.gray600,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => widget.onDateSelected(null),
            child: Text(
              'Cancel',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          ElevatedButton(
            onPressed: () => widget.onDateSelected(_selectedDate),
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.primary,
              foregroundColor: TossColors.white,
              minimumSize: const Size(64, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
            ),
            child: Text(
              'OK',
              style: TossTextStyles.body.copyWith(
                color: TossColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Standard Date Picker Widget - Simple and Clean 2025 Design
/// Three-column wheel interface: Month | Day | Year
class TossDatePicker extends StatelessWidget {
  final DateTime? date;
  final String placeholder;
  final void Function(DateTime) onDateChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  
  const TossDatePicker({
    super.key,
    this.date,
    required this.placeholder,
    required this.onDateChanged,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () => _showSimpleDatePicker(context),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space3,
          ),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(
              color: TossColors.gray200,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  date != null 
                    ? _formatDate(date!)
                    : placeholder,
                  style: TossTextStyles.body.copyWith(
                    color: date != null 
                      ? TossColors.gray900 
                      : TossColors.gray400,
                  ),
                ),
              ),
              const Icon(
                Icons.calendar_today,
                color: TossColors.gray400,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showSimpleDatePicker(BuildContext context) async {
    final firstDate = this.firstDate ?? DateTime.now().subtract(const Duration(days: 365));
    final lastDate = this.lastDate ?? DateTime.now();
    
    await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return TossSimpleWheelDatePicker(
          initialDate: date,
          firstDate: firstDate,
          lastDate: lastDate,
          onDateSelected: (DateTime? selectedDate) {
            Navigator.of(context).pop();
            if (selectedDate != null) {
              onDateChanged(selectedDate);
            }
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}