import '../../domain/entities/monthly_shift_status.dart';
import 'daily_shift_data_model.dart';

/// Monthly Shift Status Model (DTO + Mapper)
///
/// Data Transfer Object for MonthlyShiftStatus entity with JSON serialization.
class MonthlyShiftStatusModel {
  final String month;
  final List<DailyShiftDataModel> dailyShifts;
  final Map<String, int> statistics;

  const MonthlyShiftStatusModel({
    required this.month,
    required this.dailyShifts,
    this.statistics = const {},
  });

  /// Create from JSON
  factory MonthlyShiftStatusModel.fromJson(Map<String, dynamic> json) {
    return MonthlyShiftStatusModel(
      month: json['month'] as String? ?? '',
      dailyShifts: (json['daily_shifts'] as List<dynamic>?)
              ?.map((e) =>
                  DailyShiftDataModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      statistics: (json['statistics'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value as int),
          ) ??
          {},
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'daily_shifts': dailyShifts.map((d) => d.toJson()).toList(),
      'statistics': statistics,
    };
  }

  /// Map to Domain Entity
  MonthlyShiftStatus toEntity() {
    return MonthlyShiftStatus(
      month: month,
      dailyShifts: dailyShifts.map((d) => d.toEntity()).toList(),
      statistics: statistics,
    );
  }

  /// Create from Domain Entity
  factory MonthlyShiftStatusModel.fromEntity(MonthlyShiftStatus entity) {
    return MonthlyShiftStatusModel(
      month: entity.month,
      dailyShifts: entity.dailyShifts
          .map((d) => DailyShiftDataModel.fromEntity(d))
          .toList(),
      statistics: entity.statistics,
    );
  }
}
