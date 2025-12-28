import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/work_schedule_template.dart';

/// Work Schedule Template Model (DTO + Mapper)
///
/// This model handles:
/// 1. Data Transfer Object (DTO) - serialization/deserialization
/// 2. Mapper - conversion between Model and Entity
///
/// JSON structure from RPC 'get_work_schedule_templates':
/// {
///   "template_id": "uuid",
///   "company_id": "uuid",
///   "template_name": "Full-time",
///   "work_start_time": "09:00:00",
///   "work_end_time": "18:00:00",
///   "monday": true,
///   "tuesday": true,
///   "wednesday": true,
///   "thursday": true,
///   "friday": true,
///   "saturday": false,
///   "sunday": false,
///   "is_default": true,
///   "employee_count": 5,
///   "created_at_utc": "2025-12-28T10:00:00+00:00",
///   "updated_at_utc": "2025-12-28T10:00:00+00:00"
/// }
class WorkScheduleTemplateModel extends WorkScheduleTemplate {
  const WorkScheduleTemplateModel({
    required super.templateId,
    required super.companyId,
    required super.templateName,
    required super.workStartTime,
    required super.workEndTime,
    super.monday = true,
    super.tuesday = true,
    super.wednesday = true,
    super.thursday = true,
    super.friday = true,
    super.saturday = false,
    super.sunday = false,
    super.isDefault = false,
    super.employeeCount = 0,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create model from JSON (from Supabase RPC response)
  factory WorkScheduleTemplateModel.fromJson(Map<String, dynamic> json) {
    // Parse time fields - remove seconds if present (e.g., "09:00:00" -> "09:00")
    final startTime = _parseTimeString(json['work_start_time'] as String? ?? '09:00');
    final endTime = _parseTimeString(json['work_end_time'] as String? ?? '18:00');

    // Parse timestamps - RPC returns created_at_utc and updated_at_utc
    final createdAtValue = json['created_at_utc'] as String?;
    final updatedAtValue = json['updated_at_utc'] as String?;

    return WorkScheduleTemplateModel(
      templateId: json['template_id'] as String,
      companyId: json['company_id'] as String,
      templateName: json['template_name'] as String? ?? 'Unnamed Template',
      workStartTime: startTime,
      workEndTime: endTime,
      monday: json['monday'] as bool? ?? true,
      tuesday: json['tuesday'] as bool? ?? true,
      wednesday: json['wednesday'] as bool? ?? true,
      thursday: json['thursday'] as bool? ?? true,
      friday: json['friday'] as bool? ?? true,
      saturday: json['saturday'] as bool? ?? false,
      sunday: json['sunday'] as bool? ?? false,
      isDefault: json['is_default'] as bool? ?? false,
      employeeCount: (json['employee_count'] as int?) ?? 0,
      createdAt: createdAtValue != null
          ? DateTimeUtils.toLocal(createdAtValue)
          : DateTime.now(),
      updatedAt: updatedAtValue != null
          ? DateTimeUtils.toLocal(updatedAtValue)
          : DateTime.now(),
    );
  }

  /// Parse time string and return in HH:mm format
  /// Handles various formats: "09:00:00", "09:00", "09:00:00+09:00"
  static String _parseTimeString(String timeString) {
    try {
      // Remove timezone offset if present
      String cleanedTime = timeString;
      if (timeString.contains('+') || timeString.contains('-')) {
        final plusIndex = timeString.indexOf('+');
        final minusIndex = timeString.lastIndexOf('-');
        final offsetIndex = plusIndex != -1 ? plusIndex : minusIndex;
        if (offsetIndex > 0) {
          cleanedTime = timeString.substring(0, offsetIndex);
        }
      }

      // Extract HH:mm from HH:mm:ss
      final parts = cleanedTime.split(':');
      if (parts.length >= 2) {
        return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
      }

      return cleanedTime;
    } catch (e) {
      return timeString;
    }
  }

  /// Convert model to JSON (for Supabase create/update operations)
  Map<String, dynamic> toJson() {
    return {
      'template_id': templateId,
      'company_id': companyId,
      'template_name': templateName,
      'work_start_time': workStartTime,
      'work_end_time': workEndTime,
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday,
      'sunday': sunday,
      'is_default': isDefault,
    };
  }

  /// Convert to RPC parameters for create_work_schedule_template
  Map<String, dynamic> toCreateParams(String companyId) {
    return {
      'p_company_id': companyId,
      'p_template_name': templateName,
      'p_work_start_time': workStartTime,
      'p_work_end_time': workEndTime,
      'p_monday': monday,
      'p_tuesday': tuesday,
      'p_wednesday': wednesday,
      'p_thursday': thursday,
      'p_friday': friday,
      'p_saturday': saturday,
      'p_sunday': sunday,
      'p_is_default': isDefault,
    };
  }

  /// Convert to RPC parameters for update_work_schedule_template
  Map<String, dynamic> toUpdateParams() {
    return {
      'p_template_id': templateId,
      'p_template_name': templateName,
      'p_work_start_time': workStartTime,
      'p_work_end_time': workEndTime,
      'p_monday': monday,
      'p_tuesday': tuesday,
      'p_wednesday': wednesday,
      'p_thursday': thursday,
      'p_friday': friday,
      'p_saturday': saturday,
      'p_sunday': sunday,
      'p_is_default': isDefault,
    };
  }

  /// Convert model to entity (domain layer)
  WorkScheduleTemplate toEntity() {
    return WorkScheduleTemplate(
      templateId: templateId,
      companyId: companyId,
      templateName: templateName,
      workStartTime: workStartTime,
      workEndTime: workEndTime,
      monday: monday,
      tuesday: tuesday,
      wednesday: wednesday,
      thursday: thursday,
      friday: friday,
      saturday: saturday,
      sunday: sunday,
      isDefault: isDefault,
      employeeCount: employeeCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create model from entity (domain layer)
  factory WorkScheduleTemplateModel.fromEntity(WorkScheduleTemplate entity) {
    return WorkScheduleTemplateModel(
      templateId: entity.templateId,
      companyId: entity.companyId,
      templateName: entity.templateName,
      workStartTime: entity.workStartTime,
      workEndTime: entity.workEndTime,
      monday: entity.monday,
      tuesday: entity.tuesday,
      wednesday: entity.wednesday,
      thursday: entity.thursday,
      friday: entity.friday,
      saturday: entity.saturday,
      sunday: entity.sunday,
      isDefault: entity.isDefault,
      employeeCount: entity.employeeCount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
