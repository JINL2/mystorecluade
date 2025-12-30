/// Dashboard overview statistics
class DashboardSummary {
  final DashboardOverview overview;
  final Map<String, Map<String, int>> byStatus;
  final DashboardAlertSummary alerts;
  final List<RecentActivity> recentActivities;

  const DashboardSummary({
    required this.overview,
    required this.byStatus,
    required this.alerts,
    required this.recentActivities,
  });

  factory DashboardSummary.empty() => DashboardSummary(
        overview: DashboardOverview.empty(),
        byStatus: const {},
        alerts: DashboardAlertSummary.empty(),
        recentActivities: const [],
      );
}

/// Overview counts and totals
class DashboardOverview {
  // Document counts
  final int totalPICount;
  final int totalPOCount;
  final int totalLCCount;
  final int totalShipmentCount;
  final int totalCICount;

  // Active/status counts
  final int activePOs;
  final int activeLCs;
  final int activeLCCount; // Alias for activeLCs
  final int pendingShipments;
  final int inTransitCount;
  final int pendingPayments;

  // Amount totals
  final double totalTradeVolume;
  final double totalLCValue;
  final double totalReceived;
  final double pendingPaymentAmount;
  final String currency;

  const DashboardOverview({
    this.totalPICount = 0,
    this.totalPOCount = 0,
    this.totalLCCount = 0,
    this.totalShipmentCount = 0,
    this.totalCICount = 0,
    required this.activePOs,
    required this.activeLCs,
    int? activeLCCount,
    required this.pendingShipments,
    int? inTransitCount,
    required this.pendingPayments,
    double? totalTradeVolume,
    required this.totalLCValue,
    required this.totalReceived,
    double? pendingPaymentAmount,
    this.currency = 'USD',
  })  : activeLCCount = activeLCCount ?? activeLCs,
        inTransitCount = inTransitCount ?? pendingShipments,
        totalTradeVolume = totalTradeVolume ?? totalLCValue,
        pendingPaymentAmount = pendingPaymentAmount ?? 0;

  factory DashboardOverview.empty() => const DashboardOverview(
        totalPICount: 0,
        totalPOCount: 0,
        totalLCCount: 0,
        totalShipmentCount: 0,
        totalCICount: 0,
        activePOs: 0,
        activeLCs: 0,
        pendingShipments: 0,
        pendingPayments: 0,
        totalLCValue: 0,
        totalReceived: 0,
      );

  /// Calculate outstanding amount
  double get outstanding => totalLCValue - totalReceived;

  /// Calculate collection rate
  double get collectionRate =>
      totalLCValue > 0 ? (totalReceived / totalLCValue) * 100 : 0;
}

/// Alert summary counts
class DashboardAlertSummary {
  final int expiringLCs;
  final int overdueShipments;
  final int pendingDocuments;
  final int discrepancies;
  final int paymentsDue;

  const DashboardAlertSummary({
    required this.expiringLCs,
    required this.overdueShipments,
    required this.pendingDocuments,
    required this.discrepancies,
    required this.paymentsDue,
  });

  factory DashboardAlertSummary.empty() => const DashboardAlertSummary(
        expiringLCs: 0,
        overdueShipments: 0,
        pendingDocuments: 0,
        discrepancies: 0,
        paymentsDue: 0,
      );

  /// Total alert count
  int get total =>
      expiringLCs + overdueShipments + pendingDocuments + discrepancies + paymentsDue;

  /// Check if there are urgent alerts
  bool get hasUrgent => expiringLCs > 0 || overdueShipments > 0 || discrepancies > 0;
}

/// Recent activity timeline event
class RecentActivity {
  final String id;
  final String entityType;
  final String entityId;
  final String? entityNumber;
  final String action;
  final String? actionDetail;
  final String? previousStatus;
  final String? newStatus;
  final String? userId;
  final String? userName;
  final DateTime createdAt;

  const RecentActivity({
    required this.id,
    required this.entityType,
    required this.entityId,
    this.entityNumber,
    required this.action,
    this.actionDetail,
    this.previousStatus,
    this.newStatus,
    this.userId,
    this.userName,
    required this.createdAt,
  });

  /// Get display title for activity
  String get displayTitle {
    final entity = entityNumber ?? entityId.substring(0, 8);

    switch (action) {
      case 'created':
        return '$entityType $entity created';
      case 'updated':
        return '$entityType $entity updated';
      case 'status_changed':
        if (newStatus != null) {
          return '$entityType $entity → ${_formatStatus(newStatus!)}';
        }
        return '$entityType $entity status changed';
      case 'submitted':
        return '$entityType $entity submitted';
      case 'approved':
        return '$entityType $entity approved';
      case 'rejected':
        return '$entityType $entity rejected';
      case 'document_uploaded':
        return 'Document uploaded to $entity';
      default:
        return '$action: $entity';
    }
  }

  String _formatStatus(String status) {
    return status
        .split('_')
        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');
  }

  /// Get relative time string
  String get relativeTime {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${createdAt.month}/${createdAt.day}';
    }
  }

  /// Get description for timeline display
  String get description => actionDetail ?? displayTitle;

  /// Get performed by user name
  String? get performedBy => userName;
}
