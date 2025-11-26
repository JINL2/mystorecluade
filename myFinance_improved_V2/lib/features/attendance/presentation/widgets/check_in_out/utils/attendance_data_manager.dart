import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../app/providers/app_state_provider.dart';
import '../../../../../../app/providers/auth_providers.dart';
import '../../../../../../core/utils/datetime_utils.dart';
import '../../../../domain/entities/scan_result.dart';
import '../../../../domain/entities/shift_card.dart';
import '../../../../domain/entities/shift_overview.dart';
import '../../../../domain/usecases/determine_shift_status.dart';
import '../../../../domain/usecases/update_shift_card_after_scan.dart';
import '../../../../domain/value_objects/month_bounds.dart';
import '../../../providers/attendance_providers.dart';

/// Mixin for managing attendance data fetching and caching
///
/// ✅ Clean Architecture: Uses Domain entities for caching
/// Converts to Map only when needed for backward compatibility with existing UI widgets
mixin AttendanceDataManager<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  // Cache for monthly overview data - key is "yyyy-MM" format
  final Map<String, ShiftOverview> monthlyOverviewCache = {};

  // Cache for monthly cards data - key is "yyyy-MM" format
  final Map<String, List<ShiftCard>> monthlyCardsCache = {};

  // Track which months have been loaded
  final Set<String> loadedMonths = {};

  // ALL shift cards data accumulated across all loaded months
  List<Map<String, dynamic>> allShiftCardsData = [];

  // Current displayed month overview
  // ⚠️ TECHNICAL DEBT: Should be ShiftOverview? but kept as Map for backward compatibility with UI
  // TODO: Refactor consuming widgets to use ShiftOverview entity directly
  Map<String, dynamic>? shiftOverviewData;

  String? currentDisplayedMonth;
  bool isLoading = true;
  String? errorMessage;
  bool isWorking = false;
  bool hasShiftToday = false;
  String shiftStatus = 'off_duty'; // 'off_duty', 'scheduled', 'working', 'finished'

  /// Fetch data for a specific month with caching
  Future<void> fetchMonthData(DateTime targetDate, {bool forceRefresh = false}) async {
    // Create month key for tracking (yyyy-MM format)
    final monthKey = '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}';

    // Check if we already have cached data for this month
    bool hasOverview = monthlyOverviewCache.containsKey(monthKey);
    bool hasCards = monthlyCardsCache.containsKey(monthKey);

    // If we already have data for this month and not force refreshing, just update the display from cache
    if (hasOverview && hasCards && !forceRefresh) {
      setState(() {
        // ✅ Convert cached entity to Map for backward compatibility
        final cachedOverview = monthlyOverviewCache[monthKey]!;
        shiftOverviewData = _shiftOverviewToMap(cachedOverview);
        currentDisplayedMonth = monthKey;

        // Rebuild allShiftCardsData from cached entities
        allShiftCardsData.clear();
        for (final cachedMonth in monthlyCardsCache.keys) {
          final cardsForMonth = monthlyCardsCache[cachedMonth]!;
          allShiftCardsData.addAll(cardsForMonth.map((card) => card.toJson()));
        }

        // Sort all cards by date (descending)
        allShiftCardsData.sort((a, b) {
          final dateA = a['request_date']?.toString() ?? '';
          final dateB = b['request_date']?.toString() ?? '';
          return dateB.compareTo(dateA);
        });

        isLoading = false;
      });
      return;
    }

    // Need to fetch data for this month
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Get required data from providers
      final authStateAsync = ref.read(authStateProvider);
      final user = authStateAsync.value;
      final appState = ref.read(appStateProvider);

      // Get Use Cases
      final getShiftOverview = ref.read(getShiftOverviewProvider);
      final getUserShiftCards = ref.read(getUserShiftCardsProvider);

      final userId = user?.id;
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      if (userId == null || companyId.isEmpty || storeId.isEmpty) {
        setState(() {
          isLoading = false;
          errorMessage = 'Please select a company and store';
        });
        return;
      }

      // IMPORTANT: RPC functions require UTC timestamp with last moment of month
      // Use MonthBounds Value Object for month boundary calculation
      final monthBounds = MonthBounds.fromDate(targetDate);
      final requestTime = monthBounds.lastMomentUtcFormatted; // "yyyy-MM-dd HH:mm:ss" in UTC
      final timezone = DateTimeUtils.getLocalTimezone(); // User's local timezone

      // Call both APIs in parallel using Use Cases
      // Both user_shift_overview_v3 and user_shift_cards_v3 now use TIMESTAMPTZ + timezone
      final results = await Future.wait<dynamic>([
        getShiftOverview(
          requestTime: requestTime, // user_shift_overview_v3 uses TIMESTAMPTZ + timezone
          userId: userId,
          companyId: companyId,
          storeId: storeId,
          timezone: timezone,
        ),
        getUserShiftCards(
          requestTime: requestTime, // user_shift_cards_v3 uses TIMESTAMPTZ + timezone
          userId: userId,
          companyId: companyId,
          storeId: storeId,
          timezone: timezone,
        ),
      ]);

      // ✅ Clean Architecture: Keep entities in cache
      final overviewEntity = results[0] as ShiftOverview;
      final cardsEntityList = results[1] as List<ShiftCard>;

      // Cache the entities directly (Clean Architecture compliant)
      monthlyOverviewCache[monthKey] = overviewEntity;
      monthlyCardsCache[monthKey] = cardsEntityList;

      // Mark this month as loaded
      loadedMonths.add(monthKey);

      // Rebuild allShiftCardsData from ALL cached months
      setState(() {
        // Clear and rebuild allShiftCardsData from all cached entities
        allShiftCardsData.clear();

        // Add cards from all cached months (convert entities to Maps for backward compatibility)
        for (final cachedMonth in monthlyCardsCache.keys) {
          final monthCards = monthlyCardsCache[cachedMonth]!;
          allShiftCardsData.addAll(monthCards.map((card) => card.toJson()));
        }

        // Sort all cards by date
        allShiftCardsData.sort((a, b) {
          final dateA = (a['request_date'] ?? '') as String;
          final dateB = (b['request_date'] ?? '') as String;
          return dateB.compareTo(dateA); // Descending order
        });

        // ✅ Convert entity to Map for backward compatibility
        shiftOverviewData = _shiftOverviewToMap(overviewEntity);
        currentDisplayedMonth = monthKey;
        isLoading = false;

        // Check shift status (only relevant for current month)
        if (monthKey == '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}') {
          // Use DetermineShiftStatus Use Case for business logic
          final determineStatus = DetermineShiftStatus();
          final today = DateTime.now();
          final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

          // Check if user has shift today
          hasShiftToday = cardsEntityList.any((card) => card.requestDate == todayStr);

          // Determine shift status using Use Case
          final statusEnum = determineStatus(
            shiftCards: cardsEntityList,
            targetDate: today,
          );

          // Convert enum to string for backward compatibility
          shiftStatus = statusEnum.value;
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading data: ${e.toString()}';
      });
    }
  }

  /// Update local state after QR scan (check-in/out)
  ///
  /// ✅ Clean Architecture: Uses Domain entities (ScanResult, ShiftCard)
  void updateLocalStateAfterQRScan(Map<String, dynamic> scanResultMap) {
    // ✅ Convert Map to Domain entity
    final scanResult = ScanResult.fromJson(scanResultMap);

    // Get UseCase from provider
    final updateShiftCardUseCase = ref.read(updateShiftCardAfterScanProvider);

    // Find the existing shift card for the scan date
    final existingCardIndex = allShiftCardsData.indexWhere((card) {
      return card['request_date'] == scanResult.requestDate;
    });

    if (existingCardIndex != -1) {
      // Update existing card using UseCase business logic
      final existingCardMap = allShiftCardsData[existingCardIndex];

      // Convert Map to ShiftCard entity
      final existingCardEntity = ShiftCard.fromJson(existingCardMap);

      // ✅ Apply business logic through UseCase with typed parameters
      final updatedCardEntity = updateShiftCardUseCase(
        card: existingCardEntity,
        action: scanResult.action,
        timestamp: scanResult.timestamp,
      );

      // Convert back to JSON for backward compatibility
      allShiftCardsData[existingCardIndex] = updatedCardEntity.toJson();
    } else {
      // Create new card if it doesn't exist (shouldn't happen normally)
      // ✅ Use UseCase with ScanResult entity
      final newCardEntity = updateShiftCardUseCase.createFromScanResult(scanResult);

      allShiftCardsData.add(newCardEntity.toJson());
    }
  }

  /// Update monthly overview statistics after QR scan
  void updateMonthlyOverviewStats(Map<String, dynamic> scanResult) {
    // This can be expanded to update:
    // - Total hours worked
    // - Overtime calculations
    // - Late deductions
    // - etc.
  }

  /// Adjust center date to show first available shift data
  void adjustCenterDateForAvailableData(
    String monthKey,
    DateTime centerDate,
    DateTime Function(DateTime) onCenterDateChanged,
  ) {
    // Find the first date with shift data in this month
    final monthShifts = allShiftCardsData.where((card) {
      final date = card['request_date']?.toString() ?? '';
      return date.startsWith(monthKey);
    }).toList();

    if (monthShifts.isNotEmpty) {
      // Sort by date to find the earliest shift
      monthShifts.sort((a, b) {
        final dateA = a['request_date']?.toString() ?? '';
        final dateB = b['request_date']?.toString() ?? '';
        return dateA.compareTo(dateB);
      });

      // Parse the first shift date
      final firstShiftDateStr = monthShifts.first['request_date'];

      if (firstShiftDateStr != null) {
        final parts = firstShiftDateStr.toString().split('-');
        if (parts.length == 3) {
          final firstShiftDate = DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );

          // Adjust center date to show the week containing the first shift
          // If first shift is early in month (days 1-3), center on day 4
          // Otherwise center on the first shift date
          DateTime newCenterDate;
          if (firstShiftDate.day <= 3) {
            newCenterDate = DateTime(firstShiftDate.year, firstShiftDate.month, 4);
          } else {
            newCenterDate = firstShiftDate;
          }

          onCenterDateChanged(newCenterDate);
        }
      }
    }
  }

  // ========================================
  // Private Helper Methods
  // ========================================

  /// Convert ShiftOverview entity to Map for backward compatibility
  ///
  /// ⚠️ TEMPORARY: This method exists only for backward compatibility with existing UI
  /// TODO: Refactor UI widgets to accept ShiftOverview entity directly
  Map<String, dynamic> _shiftOverviewToMap(ShiftOverview overview) {
    return {
      'request_month': overview.requestMonth,
      'actual_work_days': overview.actualWorkDays,
      'actual_work_hours': overview.actualWorkHours,
      'estimated_salary': overview.estimatedSalary,
      'currency_symbol': overview.currencySymbol,
      'salary_amount': overview.salaryAmount,
      'salary_type': overview.salaryType,
      'late_deduction_total': overview.lateDeductionTotal,
      'overtime_total': overview.overtimeTotal,
      'salary_stores': overview.salaryStores.map((store) => {
        'store_id': store.storeId,
        'store_name': store.storeName,
        'estimated_salary': store.estimatedSalary,
      }).toList(),
    };
  }
}
