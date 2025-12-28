/// Work Schedule Template Entity
///
/// Represents a work schedule template for monthly (salary-based) employees.
/// Templates define regular working hours and days for employees.
/// This is a pure business entity with no dependencies on external frameworks.
class WorkScheduleTemplate {
  final String templateId;
  final String companyId;
  final String templateName;
  final String workStartTime; // HH:mm format (e.g., "09:00")
  final String workEndTime;   // HH:mm format (e.g., "18:00")
  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool friday;
  final bool saturday;
  final bool sunday;
  final bool isDefault;
  final int employeeCount;    // Number of employees using this template
  final DateTime createdAt;
  final DateTime updatedAt;

  const WorkScheduleTemplate({
    required this.templateId,
    required this.companyId,
    required this.templateName,
    required this.workStartTime,
    required this.workEndTime,
    this.monday = true,
    this.tuesday = true,
    this.wednesday = true,
    this.thursday = true,
    this.friday = true,
    this.saturday = false,
    this.sunday = false,
    this.isDefault = false,
    this.employeeCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a copy with optional field updates
  WorkScheduleTemplate copyWith({
    String? templateId,
    String? companyId,
    String? templateName,
    String? workStartTime,
    String? workEndTime,
    bool? monday,
    bool? tuesday,
    bool? wednesday,
    bool? thursday,
    bool? friday,
    bool? saturday,
    bool? sunday,
    bool? isDefault,
    int? employeeCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WorkScheduleTemplate(
      templateId: templateId ?? this.templateId,
      companyId: companyId ?? this.companyId,
      templateName: templateName ?? this.templateName,
      workStartTime: workStartTime ?? this.workStartTime,
      workEndTime: workEndTime ?? this.workEndTime,
      monday: monday ?? this.monday,
      tuesday: tuesday ?? this.tuesday,
      wednesday: wednesday ?? this.wednesday,
      thursday: thursday ?? this.thursday,
      friday: friday ?? this.friday,
      saturday: saturday ?? this.saturday,
      sunday: sunday ?? this.sunday,
      isDefault: isDefault ?? this.isDefault,
      employeeCount: employeeCount ?? this.employeeCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Returns list of working day indices (0=Sunday, 1=Monday, ..., 6=Saturday)
  List<int> get workingDayIndices {
    final indices = <int>[];
    if (sunday) indices.add(0);
    if (monday) indices.add(1);
    if (tuesday) indices.add(2);
    if (wednesday) indices.add(3);
    if (thursday) indices.add(4);
    if (friday) indices.add(5);
    if (saturday) indices.add(6);
    return indices;
  }

  /// Returns total working days per week
  int get workingDaysCount {
    int count = 0;
    if (monday) count++;
    if (tuesday) count++;
    if (wednesday) count++;
    if (thursday) count++;
    if (friday) count++;
    if (saturday) count++;
    if (sunday) count++;
    return count;
  }

  /// Returns formatted working days string (e.g., "Mon-Fri" or "Mon, Wed, Fri")
  String get workingDaysText {
    final days = <String>[];
    if (monday) days.add('Mon');
    if (tuesday) days.add('Tue');
    if (wednesday) days.add('Wed');
    if (thursday) days.add('Thu');
    if (friday) days.add('Fri');
    if (saturday) days.add('Sat');
    if (sunday) days.add('Sun');

    if (days.isEmpty) return 'No working days';
    if (days.length == 7) return 'Every day';

    // Check if consecutive weekdays (Mon-Fri)
    if (monday && tuesday && wednesday && thursday && friday && !saturday && !sunday) {
      return 'Mon-Fri';
    }

    // Check if consecutive (Mon-Sat)
    if (monday && tuesday && wednesday && thursday && friday && saturday && !sunday) {
      return 'Mon-Sat';
    }

    return days.join(', ');
  }

  /// Returns formatted time range string (e.g., "09:00 - 18:00")
  String get timeRangeText => '$workStartTime - $workEndTime';

  /// Returns true if today is a working day for this template
  bool get isTodayWorkingDay {
    final weekday = DateTime.now().weekday; // 1=Mon, 7=Sun
    switch (weekday) {
      case 1: return monday;
      case 2: return tuesday;
      case 3: return wednesday;
      case 4: return thursday;
      case 5: return friday;
      case 6: return saturday;
      case 7: return sunday;
      default: return false;
    }
  }

  /// Check if a specific date is a working day
  bool isWorkingDay(DateTime date) {
    final weekday = date.weekday; // 1=Mon, 7=Sun
    switch (weekday) {
      case 1: return monday;
      case 2: return tuesday;
      case 3: return wednesday;
      case 4: return thursday;
      case 5: return friday;
      case 6: return saturday;
      case 7: return sunday;
      default: return false;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WorkScheduleTemplate &&
        other.templateId == templateId &&
        other.companyId == companyId &&
        other.templateName == templateName &&
        other.workStartTime == workStartTime &&
        other.workEndTime == workEndTime &&
        other.monday == monday &&
        other.tuesday == tuesday &&
        other.wednesday == wednesday &&
        other.thursday == thursday &&
        other.friday == friday &&
        other.saturday == saturday &&
        other.sunday == sunday &&
        other.isDefault == isDefault &&
        other.employeeCount == employeeCount;
  }

  @override
  int get hashCode {
    return templateId.hashCode ^
        companyId.hashCode ^
        templateName.hashCode ^
        workStartTime.hashCode ^
        workEndTime.hashCode ^
        monday.hashCode ^
        tuesday.hashCode ^
        wednesday.hashCode ^
        thursday.hashCode ^
        friday.hashCode ^
        saturday.hashCode ^
        sunday.hashCode ^
        isDefault.hashCode ^
        employeeCount.hashCode;
  }

  @override
  String toString() {
    return 'WorkScheduleTemplate(templateId: $templateId, templateName: $templateName, '
        'workTime: $timeRangeText, days: $workingDaysText, '
        'isDefault: $isDefault, employeeCount: $employeeCount)';
  }
}
