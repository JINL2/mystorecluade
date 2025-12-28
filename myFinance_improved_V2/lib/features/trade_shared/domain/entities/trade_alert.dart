import 'package:flutter/material.dart';

/// Alert priority levels
enum AlertPriority {
  low,
  medium,
  high,
  urgent;

  Color get color {
    switch (this) {
      case AlertPriority.low:
        return const Color(0xFF6B7280); // Gray
      case AlertPriority.medium:
        return const Color(0xFF3B82F6); // Blue
      case AlertPriority.high:
        return const Color(0xFFF59E0B); // Orange
      case AlertPriority.urgent:
        return const Color(0xFFEF4444); // Red
    }
  }

  IconData get icon {
    switch (this) {
      case AlertPriority.low:
        return Icons.info_outline;
      case AlertPriority.medium:
        return Icons.notifications_outlined;
      case AlertPriority.high:
        return Icons.warning_amber_outlined;
      case AlertPriority.urgent:
        return Icons.error_outline;
    }
  }

  String get label {
    switch (this) {
      case AlertPriority.low:
        return 'Low';
      case AlertPriority.medium:
        return 'Medium';
      case AlertPriority.high:
        return 'High';
      case AlertPriority.urgent:
        return 'Urgent';
    }
  }

  static AlertPriority fromString(String value) {
    switch (value.toLowerCase()) {
      case 'low':
        return AlertPriority.low;
      case 'medium':
        return AlertPriority.medium;
      case 'high':
        return AlertPriority.high;
      case 'urgent':
        return AlertPriority.urgent;
      default:
        return AlertPriority.medium;
    }
  }
}

/// Alert types for trade system
enum TradeAlertType {
  lcExpiryWarning,
  lcExpired,
  shipmentDeadlineWarning,
  shipmentDeadlinePassed,
  presentationDeadlineWarning,
  presentationDeadlinePassed,
  paymentDueWarning,
  paymentDue,
  paymentReceived,
  documentMissing,
  documentExpiring,
  discrepancyFound,
  discrepancyResolved,
  statusChanged,
  amendmentReceived,
  actionRequired;

  String get code {
    switch (this) {
      case TradeAlertType.lcExpiryWarning:
        return 'lc_expiry_warning';
      case TradeAlertType.lcExpired:
        return 'lc_expired';
      case TradeAlertType.shipmentDeadlineWarning:
        return 'shipment_deadline_warning';
      case TradeAlertType.shipmentDeadlinePassed:
        return 'shipment_deadline_passed';
      case TradeAlertType.presentationDeadlineWarning:
        return 'presentation_deadline_warning';
      case TradeAlertType.presentationDeadlinePassed:
        return 'presentation_deadline_passed';
      case TradeAlertType.paymentDueWarning:
        return 'payment_due_warning';
      case TradeAlertType.paymentDue:
        return 'payment_due';
      case TradeAlertType.paymentReceived:
        return 'payment_received';
      case TradeAlertType.documentMissing:
        return 'document_missing';
      case TradeAlertType.documentExpiring:
        return 'document_expiring';
      case TradeAlertType.discrepancyFound:
        return 'discrepancy_found';
      case TradeAlertType.discrepancyResolved:
        return 'discrepancy_resolved';
      case TradeAlertType.statusChanged:
        return 'status_changed';
      case TradeAlertType.amendmentReceived:
        return 'amendment_received';
      case TradeAlertType.actionRequired:
        return 'action_required';
    }
  }

  IconData get icon {
    switch (this) {
      case TradeAlertType.lcExpiryWarning:
      case TradeAlertType.lcExpired:
        return Icons.event_busy;
      case TradeAlertType.shipmentDeadlineWarning:
      case TradeAlertType.shipmentDeadlinePassed:
        return Icons.local_shipping;
      case TradeAlertType.presentationDeadlineWarning:
      case TradeAlertType.presentationDeadlinePassed:
        return Icons.description;
      case TradeAlertType.paymentDueWarning:
      case TradeAlertType.paymentDue:
        return Icons.payment;
      case TradeAlertType.paymentReceived:
        return Icons.paid;
      case TradeAlertType.documentMissing:
      case TradeAlertType.documentExpiring:
        return Icons.folder_off;
      case TradeAlertType.discrepancyFound:
        return Icons.warning_amber;
      case TradeAlertType.discrepancyResolved:
        return Icons.check_circle;
      case TradeAlertType.statusChanged:
        return Icons.swap_horiz;
      case TradeAlertType.amendmentReceived:
        return Icons.edit_document;
      case TradeAlertType.actionRequired:
        return Icons.touch_app;
    }
  }

  String get label {
    switch (this) {
      case TradeAlertType.lcExpiryWarning:
        return 'L/C Expiry';
      case TradeAlertType.lcExpired:
        return 'L/C Expired';
      case TradeAlertType.shipmentDeadlineWarning:
        return 'Shipment Deadline';
      case TradeAlertType.shipmentDeadlinePassed:
        return 'Shipment Overdue';
      case TradeAlertType.presentationDeadlineWarning:
        return 'Presentation';
      case TradeAlertType.presentationDeadlinePassed:
        return 'Presentation Overdue';
      case TradeAlertType.paymentDueWarning:
        return 'Payment Due';
      case TradeAlertType.paymentDue:
        return 'Payment';
      case TradeAlertType.paymentReceived:
        return 'Payment Received';
      case TradeAlertType.documentMissing:
        return 'Document Missing';
      case TradeAlertType.documentExpiring:
        return 'Document Expiring';
      case TradeAlertType.discrepancyFound:
        return 'Discrepancy';
      case TradeAlertType.discrepancyResolved:
        return 'Resolved';
      case TradeAlertType.statusChanged:
        return 'Status Changed';
      case TradeAlertType.amendmentReceived:
        return 'Amendment';
      case TradeAlertType.actionRequired:
        return 'Action Required';
    }
  }

  static TradeAlertType? fromString(String value) {
    for (final type in TradeAlertType.values) {
      if (type.code == value) {
        return type;
      }
    }
    return null;
  }
}

/// Trade alert entity
class TradeAlert {
  final String id;
  final String companyId;
  final String entityType;
  final String entityId;
  final String? entityNumber;
  final TradeAlertType alertType;
  final String title;
  final String? message;
  final String? actionUrl;
  final DateTime? dueDate;
  final int? daysBeforeDue;
  final AlertPriority priority;
  final bool isRead;
  final bool isDismissed;
  final bool isResolved;
  final bool isSystemGenerated;
  final String? assignedTo;
  final DateTime createdAt;
  final DateTime? readAt;
  final DateTime? dismissedAt;
  final DateTime? resolvedAt;

  const TradeAlert({
    required this.id,
    required this.companyId,
    required this.entityType,
    required this.entityId,
    this.entityNumber,
    required this.alertType,
    required this.title,
    this.message,
    this.actionUrl,
    this.dueDate,
    this.daysBeforeDue,
    required this.priority,
    this.isRead = false,
    this.isDismissed = false,
    this.isResolved = false,
    this.isSystemGenerated = true,
    this.assignedTo,
    required this.createdAt,
    this.readAt,
    this.dismissedAt,
    this.resolvedAt,
  });

  /// Check if alert is overdue
  bool get isOverdue {
    if (dueDate == null) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  /// Get days remaining until due date
  int? get daysRemaining {
    if (dueDate == null) return null;
    return dueDate!.difference(DateTime.now()).inDays;
  }

  /// Check if alert needs attention
  bool get needsAttention => !isRead && !isDismissed && !isResolved;

  TradeAlert copyWith({
    String? id,
    String? companyId,
    String? entityType,
    String? entityId,
    String? entityNumber,
    TradeAlertType? alertType,
    String? title,
    String? message,
    String? actionUrl,
    DateTime? dueDate,
    int? daysBeforeDue,
    AlertPriority? priority,
    bool? isRead,
    bool? isDismissed,
    bool? isResolved,
    bool? isSystemGenerated,
    String? assignedTo,
    DateTime? createdAt,
    DateTime? readAt,
    DateTime? dismissedAt,
    DateTime? resolvedAt,
  }) {
    return TradeAlert(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      entityNumber: entityNumber ?? this.entityNumber,
      alertType: alertType ?? this.alertType,
      title: title ?? this.title,
      message: message ?? this.message,
      actionUrl: actionUrl ?? this.actionUrl,
      dueDate: dueDate ?? this.dueDate,
      daysBeforeDue: daysBeforeDue ?? this.daysBeforeDue,
      priority: priority ?? this.priority,
      isRead: isRead ?? this.isRead,
      isDismissed: isDismissed ?? this.isDismissed,
      isResolved: isResolved ?? this.isResolved,
      isSystemGenerated: isSystemGenerated ?? this.isSystemGenerated,
      assignedTo: assignedTo ?? this.assignedTo,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      dismissedAt: dismissedAt ?? this.dismissedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }
}
