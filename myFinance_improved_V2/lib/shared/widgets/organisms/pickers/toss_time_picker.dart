import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Simple wheel-style time picker matching Toss design system
/// Clean three-column layout: Hour | Minute | AM/PM
class TossSimpleWheelTimePicker extends StatefulWidget {
  final TimeOfDay? initialTime;
  final String title;
  final bool use24HourFormat;
  final void Function(TimeOfDay?) onTimeSelected;

  const TossSimpleWheelTimePicker({
    super.key,
    this.initialTime,
    this.title = 'Select time',
    this.use24HourFormat = false,
    required this.onTimeSelected,
  });

  @override
  State<TossSimpleWheelTimePicker> createState() => _TossSimpleWheelTimePickerState();
}

class _TossSimpleWheelTimePickerState extends State<TossSimpleWheelTimePicker> {
  late TimeOfDay _selectedTime;
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _periodController;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime ?? TimeOfDay.now();
    

    // Initialize scroll controllers with correct positions
    int hourIndex;
    if (widget.use24HourFormat) {
      hourIndex = _selectedTime.hour;
    } else {
      // For 12-hour format: 
      // hourOfPeriod returns 0 for 12 AM/PM, 1-11 for other hours
      // Our list shows 1,2,3...12 (indices 0,1,2...11)
      // So for hourOfPeriod=0 (12 o'clock), we want index 11 (showing "12")
      // For hourOfPeriod=1-11, we want index 0-10 (showing "1"-"11")
      hourIndex = _selectedTime.hourOfPeriod == 0 ? 11 : _selectedTime.hourOfPeriod - 1;
    }
    
    _hourController = FixedExtentScrollController(
      initialItem: hourIndex,
    );
    
    _minuteController = FixedExtentScrollController(
      initialItem: _selectedTime.minute,
    );
    
    if (!widget.use24HourFormat) {
      _periodController = FixedExtentScrollController(
        initialItem: _selectedTime.period == DayPeriod.am ? 0 : 1,
      );
    }
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    if (!widget.use24HourFormat) {
      _periodController.dispose();
    }
    super.dispose();
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
            onPressed: () => widget.onTimeSelected(null),
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
        alignment: Alignment.center,
        children: [

          // Selection background indicator - centered
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                height: 40,
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
          ),
          
          // Wheel pickers
          Row(
            children: [
              // Hour picker
              Expanded(
                child: _buildTossWheelPicker(
                  controller: _hourController,
                  items: List.generate(
                    widget.use24HourFormat ? 24 : 12,
                    (index) => widget.use24HourFormat 
                        ? index.toString().padLeft(2, '0') 
                        : (index + 1).toString(),
                  ),
                  onSelectedItemChanged: (index) {
                    int hour;
                    if (widget.use24HourFormat) {
                      hour = index;
                    } else {
                      // For 12-hour format:
                      // index 0-10 represents hours 1-11
                      // index 11 represents hour 12
                      int displayHour = index + 1; // This gives us 1-12
                      
                      if (_selectedTime.period == DayPeriod.pm) {
                        // PM times: 12 PM = 12, 1 PM = 13, ... 11 PM = 23
                        hour = displayHour == 12 ? 12 : displayHour + 12;
                      } else {
                        // AM times: 12 AM = 0, 1 AM = 1, ... 11 AM = 11
                        hour = displayHour == 12 ? 0 : displayHour;
                      }
                    }
                    setState(() {
                      _selectedTime = _selectedTime.replacing(hour: hour);
                    });
                  },
                ),
              ),
              
              // Minute picker
              Expanded(
                child: _buildTossWheelPicker(
                  controller: _minuteController,
                  items: List.generate(
                    60,
                    (index) => index.toString().padLeft(2, '0'),
                  ),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedTime = _selectedTime.replacing(minute: index);
                    });
                  },
                ),
              ),
              
              // AM/PM picker (only for 12-hour format)
              if (!widget.use24HourFormat)
                Expanded(
                  child: _buildTossWheelPicker(
                    controller: _periodController,
                    items: ['AM', 'PM'],
                    onSelectedItemChanged: (index) {
                      final newPeriod = index == 0 ? DayPeriod.am : DayPeriod.pm;
                      
                      // Get current display hour (1-12)
                      int currentHour = _selectedTime.hour;
                      int displayHour;
                      
                      if (currentHour == 0) {
                        displayHour = 12; // 12 AM
                      } else if (currentHour > 12) {
                        displayHour = currentHour - 12; // PM hours
                      } else if (currentHour == 12) {
                        displayHour = 12; // 12 PM
                      } else {
                        displayHour = currentHour; // AM hours 1-11
                      }
                      
                      // Calculate new hour based on new period
                      int newHour;
                      if (newPeriod == DayPeriod.pm) {
                        // Converting to PM
                        newHour = displayHour == 12 ? 12 : displayHour + 12;
                      } else {
                        // Converting to AM
                        newHour = displayHour == 12 ? 0 : displayHour;
                      }
                      
                      setState(() {
                        _selectedTime = TimeOfDay(hour: newHour, minute: _selectedTime.minute);
                      });
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
            onPressed: () => widget.onTimeSelected(null),
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
            onPressed: () => widget.onTimeSelected(_selectedTime),
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

/// Standard Time Picker Widget - Simple and Clean 2025 Design
/// Three-column wheel interface: Hour | Minute | AM/PM
class TossTimePicker extends StatelessWidget {
  final TimeOfDay? time;
  final String placeholder;
  final void Function(TimeOfDay) onTimeChanged;
  final bool use24HourFormat;
  
  const TossTimePicker({
    super.key,
    this.time,
    required this.placeholder,
    required this.onTimeChanged,
    this.use24HourFormat = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () => _showSimpleTimePicker(context),
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
                  time != null 
                    ? _formatTime(time!, use24HourFormat)
                    : placeholder,
                  style: TossTextStyles.body.copyWith(
                    color: time != null 
                      ? TossColors.gray900 
                      : TossColors.gray400,
                  ),
                ),
              ),
              const Icon(
                Icons.access_time,
                color: TossColors.gray400,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showSimpleTimePicker(BuildContext context) async {
    await showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return TossSimpleWheelTimePicker(
          initialTime: time,
          use24HourFormat: use24HourFormat,
          onTimeSelected: (TimeOfDay? selectedTime) {
            Navigator.of(context).pop();
            if (selectedTime != null) {
              onTimeChanged(selectedTime);
            }
          },
        );
      },
    );
  }

  String _formatTime(TimeOfDay time, bool use24Hour) {
    if (use24Hour) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return '${hour.toString()}:${time.minute.toString().padLeft(2, '0')} $period';
    }
  }
}