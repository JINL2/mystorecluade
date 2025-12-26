import 'package:flutter/material.dart';

/// Trade entity status with display information
class TradeStatus {
  final String code;
  final String name;
  final String? description;
  final bool isInitial;
  final bool isFinal;
  final bool isCancelled;
  final bool isError;
  final Color color;
  final IconData icon;

  const TradeStatus({
    required this.code,
    required this.name,
    this.description,
    this.isInitial = false,
    this.isFinal = false,
    this.isCancelled = false,
    this.isError = false,
    required this.color,
    required this.icon,
  });

  /// Get status color based on status type
  static Color getStatusColor(String status) {
    final normalizedStatus = status.toLowerCase();

    // Final/Success states
    if (normalizedStatus.contains('paid') ||
        normalizedStatus.contains('completed') ||
        normalizedStatus.contains('delivered') ||
        normalizedStatus.contains('accepted') ||
        normalizedStatus.contains('converted')) {
      return const Color(0xFF22C55E); // Green
    }

    // Error/Urgent states
    if (normalizedStatus.contains('rejected') ||
        normalizedStatus.contains('cancelled') ||
        normalizedStatus.contains('expired') ||
        normalizedStatus.contains('discrepancy') ||
        normalizedStatus.contains('failed')) {
      return const Color(0xFFEF4444); // Red
    }

    // Warning states
    if (normalizedStatus.contains('pending') ||
        normalizedStatus.contains('waiting') ||
        normalizedStatus.contains('negotiating') ||
        normalizedStatus.contains('amendment') ||
        normalizedStatus.contains('examination') ||
        normalizedStatus.contains('review')) {
      return const Color(0xFFF59E0B); // Orange
    }

    // In Progress states
    if (normalizedStatus.contains('sent') ||
        normalizedStatus.contains('confirmed') ||
        normalizedStatus.contains('issued') ||
        normalizedStatus.contains('advised') ||
        normalizedStatus.contains('production') ||
        normalizedStatus.contains('transit') ||
        normalizedStatus.contains('shipped') ||
        normalizedStatus.contains('submitted') ||
        normalizedStatus.contains('booked') ||
        normalizedStatus.contains('loaded') ||
        normalizedStatus.contains('departed')) {
      return const Color(0xFF3B82F6); // Blue
    }

    // Draft/Initial states
    if (normalizedStatus.contains('draft')) {
      return const Color(0xFF6B7280); // Gray
    }

    // Default
    return const Color(0xFF6B7280); // Gray
  }

  /// Get status icon based on status type
  static IconData getStatusIcon(String status) {
    final normalizedStatus = status.toLowerCase();

    if (normalizedStatus.contains('draft')) {
      return Icons.edit_note;
    }
    if (normalizedStatus.contains('sent')) {
      return Icons.send;
    }
    if (normalizedStatus.contains('accepted') || normalizedStatus.contains('confirmed')) {
      return Icons.check_circle;
    }
    if (normalizedStatus.contains('rejected') || normalizedStatus.contains('cancelled')) {
      return Icons.cancel;
    }
    if (normalizedStatus.contains('expired')) {
      return Icons.timer_off;
    }
    if (normalizedStatus.contains('pending') || normalizedStatus.contains('waiting')) {
      return Icons.hourglass_empty;
    }
    if (normalizedStatus.contains('shipped') || normalizedStatus.contains('transit')) {
      return Icons.local_shipping;
    }
    if (normalizedStatus.contains('delivered')) {
      return Icons.inventory;
    }
    if (normalizedStatus.contains('paid')) {
      return Icons.paid;
    }
    if (normalizedStatus.contains('discrepancy')) {
      return Icons.warning_amber;
    }
    if (normalizedStatus.contains('production')) {
      return Icons.precision_manufacturing;
    }
    if (normalizedStatus.contains('examination') || normalizedStatus.contains('review')) {
      return Icons.search;
    }
    if (normalizedStatus.contains('document')) {
      return Icons.description;
    }

    return Icons.circle;
  }

  /// Create TradeStatus from code string
  factory TradeStatus.fromCode(String code, {String entityType = 'general'}) {
    return TradeStatus(
      code: code,
      name: _formatStatusName(code),
      color: getStatusColor(code),
      icon: getStatusIcon(code),
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

  static List<String> get all => [draft, sent, negotiating, accepted, rejected, expired, converted];
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
        draft, confirmed, inProduction, readyToShip,
        partiallyShipped, shipped, completed, cancelled
      ];
  static List<String> get active => [draft, confirmed, inProduction, readyToShip, partiallyShipped, shipped];
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
        draft, pending, issued, advised, confirmed, amendmentRequested, amended,
        partiallyShipped, fullyShipped, documentsPresented, underExamination,
        discrepancy, accepted, paymentPending, paid, expired, cancelled
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
        draft, booked, atOriginPort, loaded, departed, inTransit,
        atDestinationPort, customsClearance, outForDelivery, delivered, cancelled
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
        draft, finalized, submitted, underReview, discrepancy,
        discrepancyResolved, accepted, paymentPending, paid, rejected
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

  static List<String> get all => [pending, processing, partial, completed, failed, refunded];
}
