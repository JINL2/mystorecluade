import 'package:flutter_test/flutter_test.dart';
import 'package:myfinance_improved/features/time_table_manage/domain/value_objects/create_shift_params.dart';

/// Unit tests for CreateShiftParams validation
///
/// These tests ensure business rules are enforced correctly.
/// Tests cover:
/// - Bounds checking (targetCount, tags)
/// - Date validation (past/future limits)
/// - Time validation (duration limits)
/// - Edge cases (empty strings, null values)
void main() {
  group('CreateShiftParams Validation', () {
    // Helper to create valid params
    CreateShiftParams createValidParams() {
      return CreateShiftParams(
        storeId: 'store123',
        shiftDate: '2025-06-15',
        planStartTime: DateTime(2025, 6, 15, 9, 0),
        planEndTime: DateTime(2025, 6, 15, 18, 0),
        targetCount: 5,
        tags: ['morning', 'busy'],
      );
    }

    group('Valid Cases', () {
      test('Valid params should pass validation', () {
        final params = createValidParams();

        expect(params.isValid, true);
        expect(params.validationErrors, isEmpty);
      });

      test('Minimum duration (30 minutes) should be valid', () {
        final params = CreateShiftParams(
          storeId: 'store123',
          shiftDate: '2025-06-15',
          planStartTime: DateTime(2025, 6, 15, 9, 0),
          planEndTime: DateTime(2025, 6, 15, 9, 30),
          targetCount: 1,
        );

        expect(params.isValid, true);
      });

      test('Maximum targetCount (100) should be valid', () {
        final params = createValidParams().copyWith(targetCount: 100);

        expect(params.isValid, true);
      });

      test('Maximum tags (20) should be valid', () {
        final params = createValidParams().copyWith(
          tags: List.generate(20, (i) => 'tag$i'),
        );

        expect(params.isValid, true);
      });
    });

    group('Invalid Target Count', () {
      test('Zero targetCount should be invalid', () {
        final params = createValidParams().copyWith(targetCount: 0);

        expect(params.isValid, false);
        expect(
          params.validationErrors,
          contains('Target count must be greater than 0'),
        );
      });

      test('Negative targetCount should be invalid', () {
        final params = createValidParams().copyWith(targetCount: -1);

        expect(params.isValid, false);
        expect(
          params.validationErrors,
          contains('Target count must be greater than 0'),
        );
      });

      test('targetCount over 100 should be invalid', () {
        final params = createValidParams().copyWith(targetCount: 101);

        expect(params.isValid, false);
        expect(
          params.validationErrors,
          contains('Target count cannot exceed 100 employees'),
        );
      });

      test('Extremely large targetCount should be rejected', () {
        final params = createValidParams().copyWith(targetCount: 1000000);

        expect(params.isValid, false);
      });
    });

    group('Invalid Shift Duration', () {
      test('Duration less than 30 minutes should be invalid', () {
        final params = CreateShiftParams(
          storeId: 'store123',
          shiftDate: '2025-06-15',
          planStartTime: DateTime(2025, 6, 15, 9, 0),
          planEndTime: DateTime(2025, 6, 15, 9, 29),
          targetCount: 1,
        );

        expect(params.isValid, false);
        expect(
          params.validationErrors,
          contains('Shift duration must be at least 30 minutes'),
        );
      });

      test('Duration over 24 hours should be invalid', () {
        final params = CreateShiftParams(
          storeId: 'store123',
          shiftDate: '2025-06-15',
          planStartTime: DateTime(2025, 6, 15, 9, 0),
          planEndTime: DateTime(2025, 6, 16, 10, 0), // 25 hours later
          targetCount: 1,
        );

        expect(params.isValid, false);
        expect(
          params.validationErrors,
          contains('Shift duration cannot exceed 24 hours'),
        );
      });

      test('End time before start time should be invalid', () {
        final params = CreateShiftParams(
          storeId: 'store123',
          shiftDate: '2025-06-15',
          planStartTime: DateTime(2025, 6, 15, 18, 0),
          planEndTime: DateTime(2025, 6, 15, 9, 0),
          targetCount: 1,
        );

        expect(params.isValid, false);
        expect(
          params.validationErrors,
          contains('End time must be after start time'),
        );
      });
    });

    group('Invalid Date Range', () {
      test('Date too far in past (over 90 days) should be invalid', () {
        final pastDate = DateTime.now().subtract(const Duration(days: 100));
        final dateStr =
            '${pastDate.year}-${pastDate.month.toString().padLeft(2, '0')}-${pastDate.day.toString().padLeft(2, '0')}';

        final params = CreateShiftParams(
          storeId: 'store123',
          shiftDate: dateStr,
          planStartTime: pastDate.add(const Duration(hours: 9)),
          planEndTime: pastDate.add(const Duration(hours: 18)),
          targetCount: 1,
        );

        expect(params.isValid, false);
        expect(
          params.validationErrors,
          contains('Shift date must be within 3 months ago to 1 year ahead'),
        );
      });

      test('Date too far in future (over 365 days) should be invalid', () {
        final futureDate = DateTime.now().add(const Duration(days: 400));
        final dateStr =
            '${futureDate.year}-${futureDate.month.toString().padLeft(2, '0')}-${futureDate.day.toString().padLeft(2, '0')}';

        final params = CreateShiftParams(
          storeId: 'store123',
          shiftDate: dateStr,
          planStartTime: futureDate.add(const Duration(hours: 9)),
          planEndTime: futureDate.add(const Duration(hours: 18)),
          targetCount: 1,
        );

        expect(params.isValid, false);
        expect(
          params.validationErrors,
          contains('Shift date must be within 3 months ago to 1 year ahead'),
        );
      });
    });

    group('Invalid Tags', () {
      test('More than 20 tags should be invalid', () {
        final params = createValidParams().copyWith(
          tags: List.generate(21, (i) => 'tag$i'),
        );

        expect(params.isValid, false);
        expect(
          params.validationErrors,
          contains('Cannot add more than 20 tags'),
        );
      });

      test('Empty tag should be invalid', () {
        final params = createValidParams().copyWith(
          tags: ['valid', '', 'another'],
        );

        expect(params.isValid, false);
        expect(
          params.validationErrors,
          contains('Tag 2 cannot be empty'),
        );
      });

      test('Tag over 100 characters should be invalid', () {
        final params = createValidParams().copyWith(
          tags: ['valid', 'a' * 101],
        );

        expect(params.isValid, false);
        expect(
          params.validationErrors,
          contains('Tag 2 is too long (max 100 characters)'),
        );
      });
    });

    group('Empty Required Fields', () {
      test('Empty storeId should be invalid', () {
        final params = createValidParams().copyWith(storeId: '');

        expect(params.isValid, false);
        expect(
          params.validationErrors,
          contains('Store ID is required'),
        );
      });

      test('Empty shiftDate should be invalid', () {
        final params = createValidParams().copyWith(shiftDate: '');

        expect(params.isValid, false);
        expect(
          params.validationErrors,
          contains('Shift date is required'),
        );
      });
    });

    group('Edge Cases', () {
      test('Exact 24 hour duration should be valid', () {
        final params = CreateShiftParams(
          storeId: 'store123',
          shiftDate: '2025-06-15',
          planStartTime: DateTime(2025, 6, 15, 0, 0),
          planEndTime: DateTime(2025, 6, 16, 0, 0),
          targetCount: 1,
        );

        expect(params.isValid, true);
      });

      test('Boundary date (89 days ago) should be valid', () {
        final pastDate = DateTime.now().subtract(const Duration(days: 89));
        final dateStr =
            '${pastDate.year}-${pastDate.month.toString().padLeft(2, '0')}-${pastDate.day.toString().padLeft(2, '0')}';

        final params = CreateShiftParams(
          storeId: 'store123',
          shiftDate: dateStr,
          planStartTime: pastDate.add(const Duration(hours: 9)),
          planEndTime: pastDate.add(const Duration(hours: 18)),
          targetCount: 1,
        );

        expect(params.isValid, true);
      });

      test('Boundary date (364 days ahead) should be valid', () {
        final futureDate = DateTime.now().add(const Duration(days: 364));
        final dateStr =
            '${futureDate.year}-${futureDate.month.toString().padLeft(2, '0')}-${futureDate.day.toString().padLeft(2, '0')}';

        final params = CreateShiftParams(
          storeId: 'store123',
          shiftDate: dateStr,
          planStartTime: futureDate.add(const Duration(hours: 9)),
          planEndTime: futureDate.add(const Duration(hours: 18)),
          targetCount: 1,
        );

        expect(params.isValid, true);
      });
    });

    group('toJson Conversion', () {
      test('Should convert to correct JSON structure', () {
        final params = createValidParams();
        final json = params.toJson();

        expect(json['p_store_id'], 'store123');
        expect(json['p_shift_date'], '2025-06-15');
        expect(json['p_target_count'], 5);
        expect(json['p_tags'], ['morning', 'busy']);
        expect(json, contains('p_plan_start_time'));
        expect(json, contains('p_plan_end_time'));
      });

      test('Should include shift name when provided', () {
        final params = createValidParams().copyWith(shiftName: 'Morning Shift');
        final json = params.toJson();

        expect(json['p_shift_name'], 'Morning Shift');
      });

      test('Should not include shift name when null', () {
        final params = createValidParams();
        final json = params.toJson();

        expect(json.containsKey('p_shift_name'), false);
      });
    });
  });
}

/// Extension to make copyWith work with immutable CreateShiftParams
/// (In real code, consider using Freezed for CreateShiftParams too)
extension CreateShiftParamsCopyWith on CreateShiftParams {
  CreateShiftParams copyWith({
    String? storeId,
    String? shiftDate,
    DateTime? planStartTime,
    DateTime? planEndTime,
    int? targetCount,
    List<String>? tags,
    String? shiftName,
  }) {
    return CreateShiftParams(
      storeId: storeId ?? this.storeId,
      shiftDate: shiftDate ?? this.shiftDate,
      planStartTime: planStartTime ?? this.planStartTime,
      planEndTime: planEndTime ?? this.planEndTime,
      targetCount: targetCount ?? this.targetCount,
      tags: tags ?? this.tags,
      shiftName: shiftName ?? this.shiftName,
    );
  }
}
