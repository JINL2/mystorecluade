import 'shift_metadata_item.dart';

/// Shift Metadata Entity
///
/// Contains metadata information about shift configurations for a store.
class ShiftMetadata {
  final List<ShiftMetadataItem> shifts;
  final DateTime? lastUpdated;

  const ShiftMetadata({
    required this.shifts,
    this.lastUpdated,
  });

  /// Get all active shifts
  List<ShiftMetadataItem> get activeShifts =>
      shifts.where((shift) => shift.isActive).toList();

  /// Get all shift names (for tags/selection)
  List<String> get shiftNames =>
      shifts.map((shift) => shift.shiftName).toList();

  /// Get active shift names only
  List<String> get activeShiftNames =>
      activeShifts.map((shift) => shift.shiftName).toList();

  /// Check if metadata has any shifts
  bool get hasShifts => shifts.isNotEmpty;

  /// Get shift count
  int get shiftCount => shifts.length;

  /// Get active shift count
  int get activeShiftCount => activeShifts.length;

  /// Find shift by ID
  ShiftMetadataItem? findShiftById(String shiftId) {
    try {
      return shifts.firstWhere((shift) => shift.shiftId == shiftId);
    } catch (e) {
      return null;
    }
  }

  /// Copy with method for immutability
  ShiftMetadata copyWith({
    List<ShiftMetadataItem>? shifts,
    DateTime? lastUpdated,
  }) {
    return ShiftMetadata(
      shifts: shifts ?? this.shifts,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() =>
      'ShiftMetadata(shifts: $shiftCount, active: $activeShiftCount, lastUpdated: $lastUpdated)';
}
