import '../../domain/entities/purchase_order.dart';

/// Extension to convert Domain Enums to database values
/// This keeps database-specific logic in the Data Layer
extension OrderStatusDbMapper on OrderStatus {
  String get dbValue {
    switch (this) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.process:
        return 'process';
      case OrderStatus.complete:
        return 'complete';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }
}

extension ReceivingStatusDbMapper on ReceivingStatus {
  String get dbValue {
    switch (this) {
      case ReceivingStatus.pending:
        return 'pending';
      case ReceivingStatus.process:
        return 'process';
      case ReceivingStatus.complete:
        return 'complete';
    }
  }
}

extension POStatusDbMapper on POStatus {
  String get dbValue {
    switch (this) {
      case POStatus.pending:
        return 'pending';
      case POStatus.process:
        return 'process';
      case POStatus.complete:
        return 'complete';
      case POStatus.cancelled:
        return 'cancelled';
    }
  }
}
