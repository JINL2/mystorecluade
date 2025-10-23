/// Approval Level Enum
/// 
/// Defines transaction approval levels for use case validation
enum ApprovalLevel {
  none,
  basic,
  manager,
  supervisor,
  admin,
  executive;

  /// Display name for UI
  String get displayName {
    switch (this) {
      case ApprovalLevel.none:
        return 'No Approval Required';
      case ApprovalLevel.basic:
        return 'Basic Approval';
      case ApprovalLevel.manager:
        return 'Manager Approval';
      case ApprovalLevel.supervisor:
        return 'Supervisor Approval';
      case ApprovalLevel.admin:
        return 'Admin Approval';
      case ApprovalLevel.executive:
        return 'Executive Approval';
    }
  }

  /// Create from string value
  static ApprovalLevel fromString(String value) {
    switch (value.toLowerCase()) {
      case 'none':
        return ApprovalLevel.none;
      case 'basic':
        return ApprovalLevel.basic;
      case 'manager':
        return ApprovalLevel.manager;
      case 'supervisor':
        return ApprovalLevel.supervisor;
      case 'admin':
        return ApprovalLevel.admin;
      case 'executive':
        return ApprovalLevel.executive;
      default:
        return ApprovalLevel.none;
    }
  }

  /// Convert to string value
  String toValue() {
    return name;
  }
}