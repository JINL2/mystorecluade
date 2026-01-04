/// Trade entity status - pure domain entity
/// Note: UI properties (color, icon) are in presentation/utils/trade_status_ui.dart
class TradeStatus {
  final String code;
  final String name;
  final String? description;
  final bool isInitial;
  final bool isFinal;
  final bool isCancelled;
  final bool isError;

  const TradeStatus({
    required this.code,
    required this.name,
    this.description,
    this.isInitial = false,
    this.isFinal = false,
    this.isCancelled = false,
    this.isError = false,
  });

  /// Create TradeStatus from code string
  factory TradeStatus.fromCode(String code, {String entityType = 'general'}) {
    return TradeStatus(
      code: code,
      name: _formatStatusName(code),
    );
  }

  static String _formatStatusName(String code) {
    // Convert snake_case to Title Case
    return code
        .split('_')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }
}

/// PI (Proforma Invoice) statuses
class PIStatus {
  static const String draft = 'draft';
  static const String sent = 'sent';
  static const String negotiating = 'negotiating';
  static const String accepted = 'accepted';
  static const String rejected = 'rejected';
  static const String expired = 'expired';
  static const String converted = 'converted';

  static List<String> get all =>
      [draft, sent, negotiating, accepted, rejected, expired, converted];
  static List<String> get active => [draft, sent, negotiating, accepted];
  static List<String> get final_ => [rejected, expired, converted];
}

/// PO (Purchase Order) statuses
class POStatus {
  static const String draft = 'draft';
  static const String confirmed = 'confirmed';
  static const String inProduction = 'in_production';
  static const String readyToShip = 'ready_to_ship';
  static const String partiallyShipped = 'partially_shipped';
  static const String shipped = 'shipped';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';

  static List<String> get all => [
        draft,
        confirmed,
        inProduction,
        readyToShip,
        partiallyShipped,
        shipped,
        completed,
        cancelled
      ];
  static List<String> get active =>
      [draft, confirmed, inProduction, readyToShip, partiallyShipped, shipped];
}

/// L/C (Letter of Credit) statuses
class LCStatus {
  static const String draft = 'draft';
  static const String pending = 'pending';
  static const String issued = 'issued';
  static const String advised = 'advised';
  static const String confirmed = 'confirmed';
  static const String amendmentRequested = 'amendment_requested';
  static const String amended = 'amended';
  static const String partiallyShipped = 'partially_shipped';
  static const String fullyShipped = 'fully_shipped';
  static const String documentsPresented = 'documents_presented';
  static const String underExamination = 'under_examination';
  static const String discrepancy = 'discrepancy';
  static const String accepted = 'accepted';
  static const String paymentPending = 'payment_pending';
  static const String paid = 'paid';
  static const String expired = 'expired';
  static const String cancelled = 'cancelled';

  static List<String> get all => [
        draft,
        pending,
        issued,
        advised,
        confirmed,
        amendmentRequested,
        amended,
        partiallyShipped,
        fullyShipped,
        documentsPresented,
        underExamination,
        discrepancy,
        accepted,
        paymentPending,
        paid,
        expired,
        cancelled
      ];
}

/// Shipment statuses
class ShipmentStatus {
  static const String draft = 'draft';
  static const String booked = 'booked';
  static const String atOriginPort = 'at_origin_port';
  static const String loaded = 'loaded';
  static const String departed = 'departed';
  static const String inTransit = 'in_transit';
  static const String atDestinationPort = 'at_destination_port';
  static const String customsClearance = 'customs_clearance';
  static const String outForDelivery = 'out_for_delivery';
  static const String delivered = 'delivered';
  static const String cancelled = 'cancelled';

  static List<String> get all => [
        draft,
        booked,
        atOriginPort,
        loaded,
        departed,
        inTransit,
        atDestinationPort,
        customsClearance,
        outForDelivery,
        delivered,
        cancelled
      ];
}

/// CI (Commercial Invoice) statuses
class CIStatus {
  static const String draft = 'draft';
  static const String finalized = 'finalized';
  static const String submitted = 'submitted';
  static const String underReview = 'under_review';
  static const String discrepancy = 'discrepancy';
  static const String discrepancyResolved = 'discrepancy_resolved';
  static const String accepted = 'accepted';
  static const String paymentPending = 'payment_pending';
  static const String paid = 'paid';
  static const String rejected = 'rejected';

  static List<String> get all => [
        draft,
        finalized,
        submitted,
        underReview,
        discrepancy,
        discrepancyResolved,
        accepted,
        paymentPending,
        paid,
        rejected
      ];
}

/// Payment statuses
class PaymentStatus {
  static const String pending = 'pending';
  static const String processing = 'processing';
  static const String partial = 'partial';
  static const String completed = 'completed';
  static const String failed = 'failed';
  static const String refunded = 'refunded';

  static List<String> get all =>
      [pending, processing, partial, completed, failed, refunded];
}
