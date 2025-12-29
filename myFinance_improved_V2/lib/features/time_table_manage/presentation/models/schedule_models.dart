/// Employee model for shift management
class Employee {
  final String id;
  final String name;
  final String avatarUrl;
  final String? email;
  final String? phone;

  Employee({
    String? id,
    required this.name,
    required this.avatarUrl,
    this.email,
    this.phone,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id']?.toString(),
      name: (json['name'] as String?) ?? '',
      avatarUrl: (json['avatar_url'] as String?) ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatar_url': avatarUrl,
        'email': email,
        'phone': phone,
      };
}

/// Shift data model for schedule management
class ShiftData {
  final String id;
  final String name;
  final String startTime;
  final String endTime;
  final int assignedCount;
  final int maxCapacity;
  final List<Employee> assignedEmployees;
  final List<Employee> applicants;
  final List<Employee> waitlist;

  ShiftData({
    String? id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.assignedCount,
    required this.maxCapacity,
    required this.assignedEmployees,
    required this.applicants,
    required this.waitlist,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  bool get isFull => assignedCount >= maxCapacity;
  int get availableSlots => maxCapacity - assignedCount;

  factory ShiftData.fromJson(Map<String, dynamic> json) {
    return ShiftData(
      id: json['id']?.toString(),
      name: (json['name'] as String?) ?? '',
      startTime: (json['start_time'] as String?) ?? '',
      endTime: (json['end_time'] as String?) ?? '',
      assignedCount: (json['assigned_count'] as int?) ?? 0,
      maxCapacity: (json['max_capacity'] as int?) ?? 0,
      assignedEmployees: (json['assigned_employees'] as List<dynamic>?)
              ?.map((e) => Employee.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      applicants: (json['applicants'] as List<dynamic>?)
              ?.map((e) => Employee.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      waitlist: (json['waitlist'] as List<dynamic>?)
              ?.map((e) => Employee.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'start_time': startTime,
        'end_time': endTime,
        'assigned_count': assignedCount,
        'max_capacity': maxCapacity,
        'assigned_employees': assignedEmployees.map((e) => e.toJson()).toList(),
        'applicants': applicants.map((e) => e.toJson()).toList(),
        'waitlist': waitlist.map((e) => e.toJson()).toList(),
      };

  ShiftData copyWith({
    String? id,
    String? name,
    String? startTime,
    String? endTime,
    int? assignedCount,
    int? maxCapacity,
    List<Employee>? assignedEmployees,
    List<Employee>? applicants,
    List<Employee>? waitlist,
  }) {
    return ShiftData(
      id: id ?? this.id,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      assignedCount: assignedCount ?? this.assignedCount,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      assignedEmployees: assignedEmployees ?? this.assignedEmployees,
      applicants: applicants ?? this.applicants,
      waitlist: waitlist ?? this.waitlist,
    );
  }
}

/// Day status for week picker
enum DayStatus {
  past,
  today,
  upcoming,
  future,
}

/// Registration status for week picker dots
enum RegistrationStatus {
  none,
  available,
  registered,
}

/// Week day data for week picker
class WeekDayData {
  final DateTime date;
  final DayStatus status;
  final RegistrationStatus registrationStatus;
  final bool hasShifts;

  WeekDayData({
    required this.date,
    required this.status,
    required this.registrationStatus,
    required this.hasShifts,
  });
}
