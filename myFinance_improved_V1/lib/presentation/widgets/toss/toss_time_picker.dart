import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_animations.dart';
import '../../../core/themes/toss_shadows.dart';
import '../../../core/constants/ui_constants.dart';

/// Toss-style time picker with digital and analog display
class TossTimePicker extends StatefulWidget {
  final TimeOfDay? initialTime;
  final Function(TimeOfDay) onTimeSelected;
  final String? title;
  final bool use24HourFormat;
  
  const TossTimePicker({
    super.key,
    this.initialTime,
    required this.onTimeSelected,
    this.title,
    this.use24HourFormat = false,
  });
  
  /// Show the time picker as a modal bottom sheet
  static Future<TimeOfDay?> show({
    required BuildContext context,
    TimeOfDay? initialTime,
    String? title,
    bool use24HourFormat = false,
  }) async {
    return showModalBottomSheet<TimeOfDay>(
      context: context,
      backgroundColor: TossColors.transparent,
      barrierColor: Colors.black54, // Standard barrier color to prevent double barriers
      isScrollControlled: true,
      builder: (context) => TossTimePicker(
        initialTime: initialTime,
        title: title,
        use24HourFormat: use24HourFormat,
        onTimeSelected: (time) {
          // The onTimeSelected callback is handled in the OK button
          // This is just for the widget's internal callback mechanism
        },
      ),
    );
  }
  
  @override
  State<TossTimePicker> createState() => _TossTimePickerState();
}

class _TossTimePickerState extends State<TossTimePicker> 
    with TickerProviderStateMixin {
  late TimeOfDay _selectedTime;
  late AnimationController _animationController;
  late AnimationController _selectionAnimationController;
  late Animation<double> _scaleAnimation;
  
  // Selection mode: hour or minute
  bool _isSelectingHour = true;
  
  // Text controllers for keyboard input
  late TextEditingController _hourController;
  late TextEditingController _minuteController;
  
  // For analog clock interaction
  double? _angle;
  bool _isDragging = false;
  
  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime ?? TimeOfDay.now();
    
    _animationController = AnimationController(
      duration: TossAnimations.medium,
      vsync: this,
    );
    
    _selectionAnimationController = AnimationController(
      duration: TossAnimations.quick,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: UIConstants.timePickerScaleStart,
      end: UIConstants.timePickerScaleEnd,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TossAnimations.enter,
    ));
    
    _hourController = TextEditingController(
      text: _formatHour(_selectedTime.hour).padLeft(2, '0'),
    );
    _minuteController = TextEditingController(
      text: _selectedTime.minute.toString().padLeft(2, '0'),
    );
    
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _selectionAnimationController.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }
  
  String _formatHour(int hour) {
    if (widget.use24HourFormat) {
      return hour.toString();
    }
    if (hour == 0) return '12';
    if (hour > 12) return (hour - 12).toString();
    return hour.toString();
  }
  
  bool get _isPM => _selectedTime.hour >= 12;
  
  void _togglePeriod() {
    setState(() {
      final newHour = _isPM 
        ? _selectedTime.hour - 12
        : _selectedTime.hour + 12;
      _selectedTime = _selectedTime.replacing(
        hour: newHour.clamp(0, 23),
      );
      _updateTextControllers();
    });
    
    _selectionAnimationController.forward().then((_) {
      _selectionAnimationController.reverse();
    });
  }
  
  void _updateTextControllers() {
    _hourController.text = _formatHour(_selectedTime.hour).padLeft(2, '0');
    _minuteController.text = _selectedTime.minute.toString().padLeft(2, '0');
  }
  
  void _selectHour() {
    if (!_isSelectingHour) {
      setState(() {
        _isSelectingHour = true;
      });
      _selectionAnimationController.forward().then((_) {
        _selectionAnimationController.reverse();
      });
      HapticFeedback.lightImpact();
    }
  }
  
  void _selectMinute() {
    if (_isSelectingHour) {
      setState(() {
        _isSelectingHour = false;
      });
      _selectionAnimationController.forward().then((_) {
        _selectionAnimationController.reverse();
      });
      HapticFeedback.lightImpact();
    }
  }
  
  void _incrementHour() {
    setState(() {
      int newHour = _selectedTime.hour + 1;
      if (widget.use24HourFormat) {
        newHour = newHour % 24;
      } else {
        if (newHour > 23) newHour = 0;
      }
      _selectedTime = _selectedTime.replacing(hour: newHour);
      _updateTextControllers();
    });
    HapticFeedback.selectionClick();
  }
  
  void _decrementHour() {
    setState(() {
      int newHour = _selectedTime.hour - 1;
      if (newHour < 0) {
        newHour = 23; // Always wrap to 23 (11 PM)
      }
      _selectedTime = _selectedTime.replacing(hour: newHour);
      _updateTextControllers();
    });
    HapticFeedback.selectionClick();
  }
  
  void _incrementMinute() {
    setState(() {
      int newMinute = (_selectedTime.minute + 1) % 60;
      _selectedTime = _selectedTime.replacing(minute: newMinute);
      _updateTextControllers();
    });
    HapticFeedback.selectionClick();
  }
  
  void _decrementMinute() {
    setState(() {
      int newMinute = _selectedTime.minute - 1;
      if (newMinute < 0) newMinute = 59;
      _selectedTime = _selectedTime.replacing(minute: newMinute);
      _updateTextControllers();
    });
    HapticFeedback.selectionClick();
  }
  
  void _updateTimeFromAngle(double angle) {
    // Convert angle to time value
    // Angle is from -π to π, with 0 at the top
    double normalizedAngle = angle < 0 ? angle + 2 * math.pi : angle;
    
    if (_isSelectingHour) {
      // For hours: 12 positions on the clock face
      // Convert angle to clock position (0-11, where 0 is at the top for 12 o'clock)
      int clockPosition = ((normalizedAngle / (2 * math.pi)) * 12).round() % 12;
      
      // Convert clock position to actual hour
      int hour;
      if (widget.use24HourFormat) {
        // In 24-hour format, directly use the position
        hour = clockPosition == 0 ? 0 : clockPosition;
        if (_isPM && hour < 12) {
          hour += 12;
        }
      } else {
        // In 12-hour format
        // Clock position 0 represents 12 o'clock
        hour = clockPosition == 0 ? 12 : clockPosition;
        
        // Adjust for AM/PM
        if (_isPM && hour != 12) {
          hour += 12;
        } else if (!_isPM && hour == 12) {
          hour = 0;
        }
      }
      
      setState(() {
        _selectedTime = _selectedTime.replacing(hour: hour.clamp(0, 23));
        _updateTextControllers();
      });
      
      // Haptic feedback for better interaction
      HapticFeedback.selectionClick();
    } else {
      // For minutes: 60 positions
      int minute = ((normalizedAngle / (2 * math.pi)) * 60).round() % 60;
      setState(() {
        _selectedTime = _selectedTime.replacing(minute: minute);
        _updateTextControllers();
      });
      
      // Light haptic feedback for minute changes
      if (minute % 5 == 0) {
        HapticFeedback.selectionClick();
      }
    }
  }
  
  void _handlePanStart(DragStartDetails details, Size size) {
    setState(() {
      _isDragging = true;
    });
    _handlePanUpdate(DragUpdateDetails(
      globalPosition: details.globalPosition,
      localPosition: details.localPosition,
    ), size);
  }
  
  void _handlePanUpdate(DragUpdateDetails details, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final position = details.localPosition;
    final angle = math.atan2(
      position.dy - center.dy,
      position.dx - center.dx,
    ) + math.pi / 2; // Adjust so 0 is at the top
    
    _updateTimeFromAngle(angle);
  }
  
  void _handlePanEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });
    HapticFeedback.lightImpact();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: Container(
          height: MediaQuery.of(context).size.height * UIConstants.timePickerHeightRatio,
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(TossBorderRadius.xxl),
              topRight: Radius.circular(TossBorderRadius.xxl),
            ),
            boxShadow: TossShadows.bottomSheet,
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: TossSpacing.space3),
                width: TossSpacing.iconXL,
                height: TossSpacing.space1,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                ),
              ),
              
              // Title
              Padding(
                padding: EdgeInsets.all(TossSpacing.space5),
                child: Text(
                  widget.title ?? 'Select time',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                  ),
                ),
              ),
              
              // Digital time display
              _buildDigitalDisplay(),
              
              SizedBox(height: TossSpacing.space6),
              
              // Analog clock
              Expanded(
                child: _buildAnalogClock(),
              ),
              
              // Keyboard input option
              _buildKeyboardInput(),
              
              // Action buttons
              _buildActionButtons(),
              
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDigitalDisplay() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hour selector with up/down arrows
          Column(
            children: [
              // Hour up arrow
              if (_isSelectingHour)
                GestureDetector(
                  onTap: _incrementHour,
                  child: Container(
                    padding: EdgeInsets.all(TossSpacing.space2),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      color: TossColors.primary,
                      size: TossSpacing.iconMD,
                    ),
                  ),
                )
              else
                SizedBox(height: TossSpacing.iconMD + TossSpacing.space4),
              
              // Hour display
              GestureDetector(
                onTap: _selectHour,
                child: AnimatedContainer(
                  duration: TossAnimations.normal,
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space6,
                    vertical: TossSpacing.space4,
                  ),
                  decoration: BoxDecoration(
                    color: _isSelectingHour 
                      ? TossColors.primary 
                      : TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  ),
                  child: Text(
                    _formatHour(_selectedTime.hour).padLeft(2, '0'),
                    style: TossTextStyles.display.copyWith(
                      color: _isSelectingHour 
                        ? TossColors.white 
                        : TossColors.gray900,
                      fontSize: UIConstants.timePickerDisplayFontSize,
                    ),
                  ),
                ),
              ),
              
              // Hour down arrow
              if (_isSelectingHour)
                GestureDetector(
                  onTap: _decrementHour,
                  child: Container(
                    padding: EdgeInsets.all(TossSpacing.space2),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: TossColors.primary,
                      size: TossSpacing.iconMD,
                    ),
                  ),
                )
              else
                SizedBox(height: TossSpacing.iconMD + TossSpacing.space4),
            ],
          ),
          
          // Separator
          Padding(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3),
            child: Column(
              children: [
                Container(
                  width: TossSpacing.space1,
                  height: TossSpacing.space1,
                  decoration: BoxDecoration(
                    color: TossColors.gray600,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: TossSpacing.space2),
                Container(
                  width: TossSpacing.space1,
                  height: TossSpacing.space1,
                  decoration: BoxDecoration(
                    color: TossColors.gray600,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          
          // Minute selector with up/down arrows
          Column(
            children: [
              // Minute up arrow
              if (!_isSelectingHour)
                GestureDetector(
                  onTap: _incrementMinute,
                  child: Container(
                    padding: EdgeInsets.all(TossSpacing.space2),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      color: TossColors.primary,
                      size: TossSpacing.iconMD,
                    ),
                  ),
                )
              else
                SizedBox(height: TossSpacing.iconMD + TossSpacing.space4),
              
              // Minute display
              GestureDetector(
                onTap: _selectMinute,
                child: AnimatedContainer(
                  duration: TossAnimations.normal,
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space6,
                    vertical: TossSpacing.space4,
                  ),
                  decoration: BoxDecoration(
                    color: !_isSelectingHour 
                      ? TossColors.primary 
                      : TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  ),
                  child: Text(
                    _selectedTime.minute.toString().padLeft(2, '0'),
                    style: TossTextStyles.display.copyWith(
                      color: !_isSelectingHour 
                        ? TossColors.white 
                        : TossColors.gray900,
                      fontSize: UIConstants.timePickerDisplayFontSize,
                    ),
                  ),
                ),
              ),
              
              // Minute down arrow
              if (!_isSelectingHour)
                GestureDetector(
                  onTap: _decrementMinute,
                  child: Container(
                    padding: EdgeInsets.all(TossSpacing.space2),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: TossColors.primary,
                      size: TossSpacing.iconMD,
                    ),
                  ),
                )
              else
                SizedBox(height: TossSpacing.iconMD + TossSpacing.space4),
            ],
          ),
          
          if (!widget.use24HourFormat) ...[
            SizedBox(width: TossSpacing.space5),
            // AM/PM toggle
            GestureDetector(
              onTap: _togglePeriod,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: TossColors.gray300,
                    width: TossSpacing.space1/4,
                  ),
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: TossAnimations.normal,
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space4,
                        vertical: TossSpacing.space3,
                      ),
                      decoration: BoxDecoration(
                        color: !_isPM 
                          ? TossColors.primary.withOpacity(0.1)
                          : TossColors.transparent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(TossBorderRadius.lg),
                          topRight: Radius.circular(TossBorderRadius.lg),
                        ),
                      ),
                      child: Text(
                        'AM',
                        style: TossTextStyles.labelLarge.copyWith(
                          color: !_isPM 
                            ? TossColors.primary
                            : TossColors.gray500,
                          fontWeight: !_isPM ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: TossAnimations.normal,
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space4,
                        vertical: TossSpacing.space3,
                      ),
                      decoration: BoxDecoration(
                        color: _isPM 
                          ? TossColors.primary.withOpacity(0.1)
                          : TossColors.transparent,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(TossBorderRadius.lg),
                          bottomRight: Radius.circular(TossBorderRadius.lg),
                        ),
                      ),
                      child: Text(
                        'PM',
                        style: TossTextStyles.labelLarge.copyWith(
                          color: _isPM 
                            ? TossColors.primary
                            : TossColors.gray500,
                          fontWeight: _isPM ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildAnalogClock() {
    return Padding(
      padding: EdgeInsets.all(TossSpacing.space6),
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onTapDown: (details) {
                // Allow direct tap on clock face to select time
                _handlePanUpdate(DragUpdateDetails(
                  globalPosition: details.globalPosition,
                  localPosition: details.localPosition,
                ), constraints.biggest);
                
                // Auto-switch to minute selection after selecting hour
                if (_isSelectingHour) {
                  Future.delayed(TossAnimations.normal, () {
                    _selectMinute();
                  });
                }
              },
              onPanStart: (details) => _handlePanStart(details, constraints.biggest),
              onPanUpdate: (details) => _handlePanUpdate(details, constraints.biggest),
              onPanEnd: _handlePanEnd,
              child: CustomPaint(
                painter: _ClockPainter(
                  selectedTime: _selectedTime,
                  isSelectingHour: _isSelectingHour,
                  isDragging: _isDragging,
                  use24HourFormat: widget.use24HourFormat,
                ),
                child: Container(),
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildKeyboardInput() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space5,
        vertical: TossSpacing.space3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.keyboard_outlined,
            size: TossSpacing.iconMD,
            color: TossColors.gray600,
          ),
          SizedBox(width: TossSpacing.space2),
          Text(
            'Keyboard input',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space5,
        vertical: TossSpacing.space4,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: TossColors.gray200,
            width: TossSpacing.space1/4,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space6,
                vertical: TossSpacing.space3,
              ),
            ),
            child: Text(
              'Cancel',
              style: TossTextStyles.button.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ),
          
          // OK button
          TextButton(
            onPressed: () {
              // Call the callback if provided (for direct widget usage)
              widget.onTimeSelected(_selectedTime);
              // Return the selected time via Navigator (for static show method)
              Navigator.pop(context, _selectedTime);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space6,
                vertical: TossSpacing.space3,
              ),
            ),
            child: Text(
              'OK',
              style: TossTextStyles.button.copyWith(
                color: TossColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the analog clock
class _ClockPainter extends CustomPainter {
  final TimeOfDay selectedTime;
  final bool isSelectingHour;
  final bool isDragging;
  final bool use24HourFormat;
  
  _ClockPainter({
    required this.selectedTime,
    required this.isSelectingHour,
    required this.isDragging,
    required this.use24HourFormat,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    
    // Draw clock circle
    final circlePaint = Paint()
      ..color = TossColors.gray50
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, circlePaint);
    
    // Draw clock border
    final borderPaint = Paint()
      ..color = TossColors.gray200
      ..style = PaintingStyle.stroke
      ..strokeWidth = TossSpacing.space1/4;
    canvas.drawCircle(center, radius, borderPaint);
    
    // Draw hour numbers
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    for (int i = 1; i <= 12; i++) {
      final angle = (i * 30 - 90) * math.pi / 180;
      final numberRadius = radius * UIConstants.clockNumberRadiusRatio;
      final x = center.dx + numberRadius * math.cos(angle);
      final y = center.dy + numberRadius * math.sin(angle);
      
      textPainter.text = TextSpan(
        text: i.toString(),
        style: TossTextStyles.body.copyWith(
          color: isSelectingHour 
            ? TossColors.gray900
            : TossColors.gray400,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }
    
    // Draw minute marks
    if (!isSelectingHour) {
      for (int i = 0; i < 60; i++) {
        if (i % 5 != 0) {
          final angle = (i * 6 - 90) * math.pi / 180;
          final markRadius = radius * UIConstants.clockMinuteMarkRadiusRatio;
          final x = center.dx + markRadius * math.cos(angle);
          final y = center.dy + markRadius * math.sin(angle);
          
          canvas.drawCircle(
            Offset(x, y),
            TossSpacing.space1/4,
            Paint()..color = TossColors.gray300,
          );
        }
      }
    }
    
    // Draw selection hand
    final handPaint = Paint()
      ..color = TossColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = TossSpacing.space1 * UIConstants.clockHandStrokeMultiplier
      ..strokeCap = StrokeCap.round;
    
    double handAngle;
    double handLength;
    
    if (isSelectingHour) {
      int displayHour = selectedTime.hourOfPeriod;
      if (displayHour == 0) displayHour = 12;
      handAngle = (displayHour * 30 - 90) * math.pi / 180;
      handLength = radius * UIConstants.clockHourHandRatio;
    } else {
      handAngle = (selectedTime.minute * 6 - 90) * math.pi / 180;
      handLength = radius * UIConstants.clockMinuteHandRatio;
    }
    
    final handEnd = Offset(
      center.dx + handLength * math.cos(handAngle),
      center.dy + handLength * math.sin(handAngle),
    );
    
    canvas.drawLine(center, handEnd, handPaint);
    
    // Draw center dot
    canvas.drawCircle(
      center,
      TossSpacing.space1 * UIConstants.clockCenterDotMultiplier,
      Paint()..color = TossColors.primary,
    );
    
    // Draw selection indicator
    canvas.drawCircle(
      handEnd,
      isDragging ? TossSpacing.space1 * UIConstants.clockSelectionDraggingMultiplier : TossSpacing.space1 * UIConstants.clockSelectionNormalMultiplier,
      Paint()..color = TossColors.primary,
    );
  }
  
  @override
  bool shouldRepaint(_ClockPainter oldDelegate) {
    return oldDelegate.selectedTime != selectedTime ||
           oldDelegate.isSelectingHour != isSelectingHour ||
           oldDelegate.isDragging != isDragging;
  }
}

/// Simple time picker for inline use with improved UX
class TossSimpleTimePicker extends StatefulWidget {
  final TimeOfDay? time;
  final Function(TimeOfDay) onTimeChanged;
  final bool use24HourFormat;
  final bool enabled;
  final String? placeholder;
  final bool showDefaultTime;
  
  const TossSimpleTimePicker({
    super.key,
    this.time,
    required this.onTimeChanged,
    this.use24HourFormat = false,
    this.enabled = true,
    this.placeholder,
    this.showDefaultTime = false,
  });
  
  @override
  State<TossSimpleTimePicker> createState() => _TossSimpleTimePickerState();
}

class _TossSimpleTimePickerState extends State<TossSimpleTimePicker> {
  @override
  Widget build(BuildContext context) {
    // Determine if we should show time or placeholder
    final bool hasSelectedTime = widget.time != null;
    final String displayText = hasSelectedTime 
        ? _formatTime(widget.time!, widget.use24HourFormat)
        : (widget.placeholder ?? 'Select time');
    
    return GestureDetector(
      onTap: widget.enabled ? () async {
        final selectedTime = await TossTimePicker.show(
          context: context,
          initialTime: widget.time ?? (widget.showDefaultTime ? TimeOfDay.now() : const TimeOfDay(hour: 9, minute: 0)),
          use24HourFormat: widget.use24HourFormat,
        );
        if (selectedTime != null) {
          widget.onTimeChanged(selectedTime);
        }
      } : null,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space4,
        ),
        decoration: BoxDecoration(
          color: widget.enabled 
              ? (hasSelectedTime ? TossColors.primary.withOpacity(0.05) : TossColors.gray50)
              : TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: hasSelectedTime 
                ? TossColors.primary.withOpacity(0.3)
                : TossColors.gray200,
            width: hasSelectedTime ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: TossSpacing.iconXL,
              height: TossSpacing.iconXL,
              decoration: BoxDecoration(
                color: hasSelectedTime 
                    ? TossColors.primary.withOpacity(0.1)
                    : TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                Icons.access_time_outlined,
                size: TossSpacing.iconSM,
                color: hasSelectedTime 
                    ? TossColors.primary
                    : TossColors.gray500,
              ),
            ),
            SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasSelectedTime ? 'Selected time' : 'Time',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space1/2),
                  Text(
                    displayText,
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: hasSelectedTime 
                          ? TossColors.gray900 
                          : TossColors.gray500,
                      fontWeight: hasSelectedTime 
                          ? FontWeight.w600 
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: hasSelectedTime 
                  ? TossColors.primary 
                  : TossColors.gray400,
              size: TossSpacing.iconMD,
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatTime(TimeOfDay time, bool use24Hour) {
    if (use24Hour) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
    return time.format(context);
  }
}