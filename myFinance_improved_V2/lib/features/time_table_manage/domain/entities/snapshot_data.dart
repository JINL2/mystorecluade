import 'shift_card.dart';

/// Snapshot Metric Data
class SnapshotMetric {
  final int count;
  final List<Map<String, dynamic>> employees;
  /// List of ShiftCards for navigation to detail page
  final List<ShiftCard> cards;

  SnapshotMetric({
    required this.count,
    required this.employees,
    this.cards = const [],
  });
}

/// Snapshot Data (for Active shifts)
class SnapshotData {
  final SnapshotMetric onTime;
  final SnapshotMetric late;
  final SnapshotMetric notCheckedIn;

  SnapshotData({
    required this.onTime,
    required this.late,
    required this.notCheckedIn,
  });
}

/// Staff Member (for Upcoming shifts)
class StaffMember {
  final String name;
  final String? avatarUrl;

  StaffMember({
    required this.name,
    this.avatarUrl,
  });
}
