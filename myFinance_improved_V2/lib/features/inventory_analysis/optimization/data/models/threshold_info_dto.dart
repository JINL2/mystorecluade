import '../../domain/entities/threshold_info.dart';

/// ThresholdInfo DTO
/// RPC 응답에서 변환
class ThresholdInfoDto {
  final double criticalDays;
  final double warningDays;
  final String thresholdSource;
  final int sampleSize;

  const ThresholdInfoDto({
    required this.criticalDays,
    required this.warningDays,
    required this.thresholdSource,
    required this.sampleSize,
  });

  factory ThresholdInfoDto.fromJson(Map<String, dynamic> json) {
    return ThresholdInfoDto(
      criticalDays: (json['critical_days'] as num?)?.toDouble() ?? 7.0,
      warningDays: (json['warning_days'] as num?)?.toDouble() ?? 14.0,
      thresholdSource: json['threshold_source'] as String? ?? 'default',
      sampleSize: (json['sample_size'] as num?)?.toInt() ?? 0,
    );
  }

  ThresholdInfo toEntity() {
    return ThresholdInfo(
      criticalDays: criticalDays,
      warningDays: warningDays,
      source: thresholdSource,
      sampleSize: sampleSize,
    );
  }
}
