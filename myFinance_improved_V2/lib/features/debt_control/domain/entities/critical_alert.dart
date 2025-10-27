import 'package:freezed_annotation/freezed_annotation.dart';

part 'critical_alert.freezed.dart';

/// Critical alert for debt control
@freezed
class CriticalAlert with _$CriticalAlert {
  const factory CriticalAlert({
    required String id,
    required String type,
    required String message,
    required int count,
    required String severity,
    @Default(false) bool isRead,
    DateTime? createdAt,
  }) = _CriticalAlert;

  const CriticalAlert._();

  /// Check if alert is critical
  bool get isCritical => severity == 'critical';

  /// Check if alert is warning
  bool get isWarning => severity == 'warning';

  /// Check if alert is info
  bool get isInfo => severity == 'info';

  /// Get alert priority (higher is more urgent)
  int get priority {
    switch (severity) {
      case 'critical':
        return 3;
      case 'warning':
        return 2;
      case 'info':
        return 1;
      default:
        return 0;
    }
  }
}
