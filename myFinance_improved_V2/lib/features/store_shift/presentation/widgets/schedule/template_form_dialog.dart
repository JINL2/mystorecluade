import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/work_schedule_template.dart';
import '../../providers/store_shift_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Template Form Dialog
///
/// Bottom sheet dialog for creating or editing work schedule templates.
class TemplateFormDialog extends ConsumerStatefulWidget {
  final WorkScheduleTemplate? template;

  const TemplateFormDialog({super.key, this.template});

  bool get isEditing => template != null;

  @override
  ConsumerState<TemplateFormDialog> createState() => _TemplateFormDialogState();
}

class _TemplateFormDialogState extends ConsumerState<TemplateFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  late bool _monday;
  late bool _tuesday;
  late bool _wednesday;
  late bool _thursday;
  late bool _friday;
  late bool _saturday;
  late bool _sunday;
  late bool _isDefault;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    final template = widget.template;

    _nameController = TextEditingController(
      text: template?.templateName ?? '',
    );

    _startTime = _parseTimeOfDay(template?.workStartTime) ??
        const TimeOfDay(hour: 9, minute: 0);
    _endTime = _parseTimeOfDay(template?.workEndTime) ??
        const TimeOfDay(hour: 18, minute: 0);

    _monday = template?.monday ?? true;
    _tuesday = template?.tuesday ?? true;
    _wednesday = template?.wednesday ?? true;
    _thursday = template?.thursday ?? true;
    _friday = template?.friday ?? true;
    _saturday = template?.saturday ?? false;
    _sunday = template?.sunday ?? false;
    _isDefault = template?.isDefault ?? false;
  }

  TimeOfDay? _parseTimeOfDay(String? timeString) {
    if (timeString == null) return null;
    try {
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    } catch (_) {}
    return null;
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final initialTime = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final Map<String, dynamic> result;

      if (widget.isEditing) {
        result = await ref.read(updateWorkScheduleTemplateProvider)(
          templateId: widget.template!.templateId,
          templateName: _nameController.text.trim(),
          workStartTime: _formatTimeOfDay(_startTime),
          workEndTime: _formatTimeOfDay(_endTime),
          monday: _monday,
          tuesday: _tuesday,
          wednesday: _wednesday,
          thursday: _thursday,
          friday: _friday,
          saturday: _saturday,
          sunday: _sunday,
          isDefault: _isDefault,
        );
      } else {
        result = await ref.read(createWorkScheduleTemplateProvider)(
          templateName: _nameController.text.trim(),
          workStartTime: _formatTimeOfDay(_startTime),
          workEndTime: _formatTimeOfDay(_endTime),
          monday: _monday,
          tuesday: _tuesday,
          wednesday: _wednesday,
          thursday: _thursday,
          friday: _friday,
          saturday: _saturday,
          sunday: _sunday,
          isDefault: _isDefault,
        );
      }

      if (mounted) {
        Navigator.pop(context);

        if (result['success'] == true) {
          TossToast.success(
            context,
            widget.isEditing
                ? 'Template updated successfully'
                : 'Template created successfully',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        TossToast.error(context, 'Error: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.bottomSheet),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: TossSpacing.iconXL,
                      height: TossSpacing.space1,
                      decoration: BoxDecoration(
                        color: TossColors.gray300,
                        borderRadius: BorderRadius.circular(TossSpacing.space1 / 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space4),

                  // Title
                  Text(
                    widget.isEditing ? 'Edit Template' : 'Create Template',
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: TossFontWeight.bold,
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space5),

                  // Template Name
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Template Name',
                      hintText: 'e.g., Standard Office Hours',
                      prefixIcon: const Icon(LucideIcons.tag),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a template name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: TossSpacing.space4),

                  // Time Range
                  Text(
                    'Working Hours',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: TossFontWeight.semibold,
                      color: TossColors.gray700,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTimeButton(
                          context,
                          'Start',
                          _startTime,
                          () => _selectTime(context, true),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space3,
                        ),
                        child: Text(
                          'to',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildTimeButton(
                          context,
                          'End',
                          _endTime,
                          () => _selectTime(context, false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TossSpacing.space4),

                  // Working Days
                  Text(
                    'Working Days',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: TossFontWeight.semibold,
                      color: TossColors.gray700,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  _buildDaySelector(),
                  const SizedBox(height: TossSpacing.space4),

                  // Default checkbox
                  CheckboxListTile(
                    value: _isDefault,
                    onChanged: (value) {
                      HapticFeedback.selectionClick();
                      setState(() => _isDefault = value ?? false);
                    },
                    title: Text(
                      'Set as default template',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray700,
                      ),
                    ),
                    subtitle: Text(
                      'New monthly employees will use this template',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: TossSpacing.space5),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: TossButton.primary(
                      text: widget.isEditing ? 'Save Changes' : 'Create Template',
                      onPressed: _isLoading ? null : _save,
                      isLoading: _isLoading,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeButton(
    BuildContext context,
    String label,
    TimeOfDay time,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: TossColors.gray300),
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.clock,
              size: TossSpacing.iconSM,
              color: TossColors.gray500,
            ),
            const SizedBox(width: TossSpacing.space2),
            Text(
              time.format(context),
              style: TossTextStyles.bodyLarge.copyWith(
                fontWeight: TossFontWeight.semibold,
                color: TossColors.gray900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySelector() {
    final days = [
      ('Mon', _monday, (bool v) => setState(() => _monday = v)),
      ('Tue', _tuesday, (bool v) => setState(() => _tuesday = v)),
      ('Wed', _wednesday, (bool v) => setState(() => _wednesday = v)),
      ('Thu', _thursday, (bool v) => setState(() => _thursday = v)),
      ('Fri', _friday, (bool v) => setState(() => _friday = v)),
      ('Sat', _saturday, (bool v) => setState(() => _saturday = v)),
      ('Sun', _sunday, (bool v) => setState(() => _sunday = v)),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: days.map((day) {
        final isActive = day.$2;
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            day.$3(!isActive);
          },
          child: Container(
            width: TossSpacing.buttonHeightMD + TossSpacing.space1,
            height: TossSpacing.buttonHeightMD + TossSpacing.space1,
            decoration: BoxDecoration(
              color: isActive ? TossColors.primary : TossColors.gray100,
              borderRadius: BorderRadius.circular(TossBorderRadius.buttonLarge),
            ),
            child: Center(
              child: Text(
                day.$1,
                style: TossTextStyles.label.copyWith(
                  color: isActive ? TossColors.white : TossColors.gray500,
                  fontWeight: isActive ? TossFontWeight.semibold : TossFontWeight.regular,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
