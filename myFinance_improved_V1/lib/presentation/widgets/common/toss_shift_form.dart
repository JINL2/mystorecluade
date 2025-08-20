import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_animations.dart';
import '../toss/toss_time_picker.dart';

/// A comprehensive shift form widget following Toss design principles
/// Features intuitive UX with clear state indication and validation
class TossShiftForm extends StatefulWidget {
  final String? initialShiftName;
  final TimeOfDay? initialStartTime;
  final TimeOfDay? initialEndTime;
  final Function(String shiftName, TimeOfDay startTime, TimeOfDay endTime) onSubmit;
  final VoidCallback? onCancel;
  final String submitButtonText;
  final bool isLoading;
  
  const TossShiftForm({
    super.key,
    this.initialShiftName,
    this.initialStartTime,
    this.initialEndTime,
    required this.onSubmit,
    this.onCancel,
    this.submitButtonText = 'Create',
    this.isLoading = false,
  });
  
  @override
  State<TossShiftForm> createState() => _TossShiftFormState();
}

class _TossShiftFormState extends State<TossShiftForm> 
    with TickerProviderStateMixin {
  late TextEditingController _shiftNameController;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  String? _validationError;
  
  late AnimationController _formAnimationController;
  late AnimationController _submitAnimationController;
  late Animation<double> _formSlideAnimation;
  late Animation<double> _submitScaleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _shiftNameController = TextEditingController(text: widget.initialShiftName ?? '');
    _selectedStartTime = widget.initialStartTime;
    _selectedEndTime = widget.initialEndTime;
    
    _formAnimationController = AnimationController(
      duration: TossAnimations.medium,
      vsync: this,
    );
    
    _submitAnimationController = AnimationController(
      duration: TossAnimations.quick,
      vsync: this,
    );
    
    _formSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _formAnimationController,
      curve: TossAnimations.enter,
    ));
    
    _submitScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _submitAnimationController,
      curve: TossAnimations.standard,
    ));
    
    _formAnimationController.forward();
    
    // Listen to text changes for validation
    _shiftNameController.addListener(_validateForm);
  }
  
  @override
  void dispose() {
    _shiftNameController.dispose();
    _formAnimationController.dispose();
    _submitAnimationController.dispose();
    super.dispose();
  }
  
  void _validateForm() {
    setState(() {
      _validationError = null;
      
      if (_shiftNameController.text.trim().isEmpty) {
        _validationError = 'Shift name is required';
        return;
      }
      
      if (_selectedStartTime == null) {
        _validationError = 'Start time is required';
        return;
      }
      
      if (_selectedEndTime == null) {
        _validationError = 'End time is required';
        return;
      }
      
      // Check if start time is not the same as end time
      if (_selectedStartTime == _selectedEndTime) {
        _validationError = 'Start and end times cannot be the same';
        return;
      }
    });
  }
  
  bool get _isFormValid {
    return _shiftNameController.text.trim().isNotEmpty &&
           _selectedStartTime != null &&
           _selectedEndTime != null &&
           _selectedStartTime != _selectedEndTime;
  }
  
  String _calculateDuration() {
    if (_selectedStartTime == null || _selectedEndTime == null) {
      return 'Select times to see duration';
    }
    
    try {
      var totalMinutes = (_selectedEndTime!.hour * 60 + _selectedEndTime!.minute) - 
                        (_selectedStartTime!.hour * 60 + _selectedStartTime!.minute);
      
      // Handle overnight shifts
      if (totalMinutes < 0) {
        totalMinutes += 24 * 60;
      }
      
      final hours = totalMinutes ~/ 60;
      final minutes = totalMinutes % 60;
      
      if (minutes == 0) {
        return '$hours hours';
      } else {
        return '$hours hours $minutes minutes';
      }
    } catch (e) {
      return 'Invalid duration';
    }
  }
  
  IconData _getShiftIcon() {
    if (_selectedStartTime == null) return Icons.schedule_outlined;
    
    final hour = _selectedStartTime!.hour;
    if (hour >= 5 && hour < 12) {
      return Icons.wb_sunny_outlined; // Morning
    } else if (hour >= 12 && hour < 17) {
      return Icons.wb_twilight_outlined; // Afternoon
    } else if (hour >= 17 && hour < 22) {
      return Icons.nightlight_outlined; // Evening
    } else {
      return Icons.nights_stay_outlined; // Night
    }
  }
  
  Color _getShiftColor() {
    if (_selectedStartTime == null) return TossColors.gray500;
    
    final hour = _selectedStartTime!.hour;
    if (hour >= 5 && hour < 12) {
      return TossColors.warning; // Morning - Orange
    } else if (hour >= 12 && hour < 17) {
      return TossColors.info; // Afternoon - Blue
    } else if (hour >= 17 && hour < 22) {
      return TossColors.primary; // Evening - Primary blue
    } else {
      return TossColors.gray700; // Night - Dark gray
    }
  }
  
  void _handleSubmit() {
    _validateForm();
    
    if (_isFormValid && !widget.isLoading) {
      _submitAnimationController.forward().then((_) {
        _submitAnimationController.reverse();
      });
      
      widget.onSubmit(
        _shiftNameController.text.trim(),
        _selectedStartTime!,
        _selectedEndTime!,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _formSlideAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _formSlideAnimation.value),
        child: Opacity(
          opacity: 1.0 - (_formSlideAnimation.value / 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shift Name Section
              _buildShiftNameSection(),
              
              const SizedBox(height: TossSpacing.space6),
              
              // Time Selection Section
              _buildTimeSelectionSection(),
              
              const SizedBox(height: TossSpacing.space5),
              
              // Duration and Preview Section
              if (_selectedStartTime != null && _selectedEndTime != null) ...[
                _buildDurationSection(),
                const SizedBox(height: TossSpacing.space5),
                _buildPreviewSection(),
                const SizedBox(height: TossSpacing.space6),
              ],
              
              // Validation Error
              if (_validationError != null) ...[
                _buildValidationError(),
                const SizedBox(height: TossSpacing.space4),
              ],
              
              // Action Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildShiftNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shift Name',
          style: TossTextStyles.bodyLarge.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        Container(
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: _shiftNameController.text.isNotEmpty 
                ? TossColors.primary.withOpacity(0.3)
                : TossColors.gray200,
              width: _shiftNameController.text.isNotEmpty ? 1.5 : 1,
            ),
          ),
          child: TextField(
            controller: _shiftNameController,
            style: TossTextStyles.bodyLarge.copyWith(
              color: TossColors.gray900,
            ),
            decoration: InputDecoration(
              hintText: 'e.g., Morning Shift, Night Shift',
              hintStyle: TossTextStyles.body.copyWith(
                color: TossColors.gray400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(TossSpacing.space4),
              prefixIcon: Icon(
                Icons.badge_outlined,
                color: _shiftNameController.text.isNotEmpty 
                  ? TossColors.primary
                  : TossColors.gray400,
                size: TossSpacing.iconSM,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildTimeSelectionSection() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: TossColors.primary.withOpacity(0.03),
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: TossColors.primary.withOpacity(0.1),
          width: TossSpacing.space1/4,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule,
                color: TossColors.primary,
                size: TossSpacing.iconSM,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Shift Hours',
                style: TossTextStyles.bodyLarge.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),
          
          // Start Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Start Time',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              TossSimpleTimePicker(
                time: _selectedStartTime,
                placeholder: 'Select start time',
                onTimeChanged: (time) {
                  setState(() {
                    _selectedStartTime = time;
                  });
                  _validateForm();
                },
                use24HourFormat: false,
              ),
            ],
          ),
          
          const SizedBox(height: TossSpacing.space4),
          
          // End Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'End Time',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              TossSimpleTimePicker(
                time: _selectedEndTime,
                placeholder: 'Select end time',
                onTimeChanged: (time) {
                  setState(() {
                    _selectedEndTime = time;
                  });
                  _validateForm();
                },
                use24HourFormat: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildDurationSection() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.success.withOpacity(0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.success.withOpacity(0.2),
          width: TossSpacing.space1/4,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.timer_outlined,
            color: TossColors.success,
            size: TossSpacing.iconSM,
          ),
          const SizedBox(width: TossSpacing.space3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Duration',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              const SizedBox(height: TossSpacing.space1/2),
              Text(
                _calculateDuration(),
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildPreviewSection() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getShiftColor().withOpacity(0.05),
            _getShiftColor().withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: _getShiftColor().withOpacity(0.2),
          width: TossSpacing.space1/4,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shift Preview',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          Row(
            children: [
              Container(
                width: TossSpacing.iconXL + TossSpacing.space2,
                height: TossSpacing.iconXL + TossSpacing.space2,
                decoration: BoxDecoration(
                  color: _getShiftColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                child: Icon(
                  _getShiftIcon(),
                  color: _getShiftColor(),
                  size: TossSpacing.iconMD,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _shiftNameController.text.isEmpty 
                        ? 'New Shift' 
                        : _shiftNameController.text,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Text(
                      '${_selectedStartTime!.format(context)} - ${_selectedEndTime!.format(context)}',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildValidationError() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.error.withOpacity(0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.error.withOpacity(0.2),
          width: TossSpacing.space1/4,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: TossColors.error,
            size: TossSpacing.iconSM,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              _validationError!,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButtons() {
    return Row(
      children: [
        // Cancel Button
        if (widget.onCancel != null)
          Expanded(
            child: TextButton(
              onPressed: widget.isLoading ? null : widget.onCancel,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
              ),
              child: Text(
                'Cancel',
                style: TossTextStyles.button.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ),
          ),
        
        if (widget.onCancel != null) const SizedBox(width: TossSpacing.space3),
        
        // Submit Button
        Expanded(
          flex: widget.onCancel != null ? 1 : 1,
          child: AnimatedBuilder(
            animation: _submitScaleAnimation,
            builder: (context, child) => Transform.scale(
              scale: _submitScaleAnimation.value,
              child: Container(
                width: double.infinity,
                height: TossSpacing.buttonHeightLG,
                decoration: BoxDecoration(
                  gradient: _isFormValid && !widget.isLoading
                    ? LinearGradient(
                        colors: [
                          TossColors.primary,
                          TossColors.primary.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                  color: !_isFormValid || widget.isLoading 
                    ? TossColors.gray200 
                    : null,
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  boxShadow: _isFormValid && !widget.isLoading
                    ? [
                        BoxShadow(
                          color: TossColors.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
                ),
                child: Material(
                  color: TossColors.transparent,
                  child: InkWell(
                    onTap: _isFormValid && !widget.isLoading ? _handleSubmit : null,
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    child: Center(
                      child: widget.isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                TossColors.gray500,
                              ),
                            ),
                          )
                        : Text(
                            widget.submitButtonText,
                            style: TossTextStyles.button.copyWith(
                              color: _isFormValid 
                                ? TossColors.white 
                                : TossColors.gray500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}