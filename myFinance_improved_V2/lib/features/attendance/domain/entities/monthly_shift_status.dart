/// Monthly Shift Status Entity
///
/// Represents shift status for the month from RPC: get_monthly_shift_status_manager
///
/// Note: This wraps the raw RPC response for backward compatibility
/// while providing type-safe accessors for common fields.
class MonthlyShiftStatus {
  final Map<String, dynamic> _data;

  MonthlyShiftStatus(this._data);

  /// Create from JSON (from RPC: get_monthly_shift_status_manager)
  factory MonthlyShiftStatus.fromJson(Map<String, dynamic> json) {
    return MonthlyShiftStatus(Map<String, dynamic>.from(json));
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => Map<String, dynamic>.from(_data);

  /// Access underlying data (for backward compatibility)
  dynamic operator [](String key) => _data[key];

  /// Set underlying data (for backward compatibility)
  void operator []=(String key, dynamic value) => _data[key] = value;

  /// Request date
  String get requestDate => _data['request_date'] as String? ?? '';

  /// Shift ID (tries multiple possible field names)
  String get shiftId =>
      (_data['shift_id'] ?? _data['id'] ?? _data['store_shift_id'])?.toString() ?? '';

  /// Shift name
  String? get shiftName => _data['shift_name'] as String?;

  /// Shift type
  String? get shiftType => _data['shift_type'] as String?;

  /// Pending employees list
  List<Map<String, dynamic>> get pendingEmployees {
    if (_data['pending_employees'] == null) return [];
    final list = _data['pending_employees'] as List;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  /// Approved employees list
  List<Map<String, dynamic>> get approvedEmployees {
    if (_data['approved_employees'] == null) return [];
    final list = _data['approved_employees'] as List;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  /// Total employees count
  int get totalEmployees => pendingEmployees.length + approvedEmployees.length;

  /// Has any employees
  bool get hasEmployees => totalEmployees > 0;

  @override
  String toString() => 'MonthlyShiftStatus(date: $requestDate, shift: $shiftId, total: $totalEmployees)';
}
