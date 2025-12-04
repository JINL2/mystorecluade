/// Reliability Score Entity
///
/// Represents store health metrics from get_reliability_score RPC.
/// Contains shift summary, understaffed shifts, and employee reliability data.
class ReliabilityScore {
  final String companyId;
  final String? periodStart;
  final String? periodEnd;
  final ShiftSummary shiftSummary;
  final UnderstaffedShifts understaffedShifts;
  final List<EmployeeReliability> employees;

  const ReliabilityScore({
    required this.companyId,
    this.periodStart,
    this.periodEnd,
    required this.shiftSummary,
    required this.understaffedShifts,
    required this.employees,
  });

  /// Get employees sorted by reliability score (highest first)
  List<EmployeeReliability> get topReliability {
    final sorted = List<EmployeeReliability>.from(employees);
    sorted.sort((a, b) => b.finalScore.compareTo(a.finalScore));
    return sorted.take(3).toList();
  }

  /// Get employees that need attention (lowest reliability scores)
  List<EmployeeReliability> get needsAttention {
    final sorted = List<EmployeeReliability>.from(employees);
    sorted.sort((a, b) => a.finalScore.compareTo(b.finalScore));
    // Filter only those with reliability below threshold (e.g., 80%)
    return sorted.where((e) => e.finalScore < 80).take(3).toList();
  }
}

/// Shift summary data for different time periods
class ShiftSummary {
  final PeriodStats today;
  final PeriodStats yesterday;
  final PeriodStats thisMonth;
  final PeriodStats lastMonth;
  final PeriodStats twoMonthsAgo;

  const ShiftSummary({
    required this.today,
    required this.yesterday,
    required this.thisMonth,
    required this.lastMonth,
    required this.twoMonthsAgo,
  });

  /// Calculate on-time rate for this month
  /// On-time = total shifts - late shifts
  double get onTimeRate {
    if (thisMonth.totalShifts == 0) return 1.0;
    final onTime = thisMonth.totalShifts - thisMonth.lateCount;
    return onTime / thisMonth.totalShifts;
  }

  /// Get late shift change (this month vs last month)
  int get lateShiftsChange => thisMonth.lateCount - lastMonth.lateCount;

  /// Get overtime change (this month vs last month)
  double get overtimeChange =>
      thisMonth.overtimeAmountSum - lastMonth.overtimeAmountSum;

  /// Get problem solved rate for this month
  double get problemSolvedRate {
    if (thisMonth.problemCount == 0) return 1.0;
    return thisMonth.problemSolvedCount / thisMonth.problemCount;
  }
}

/// Statistics for a single time period
class PeriodStats {
  final int totalShifts;
  final int lateCount;
  final int overtimeCount;
  final double overtimeAmountSum;
  final int problemCount;
  final int problemSolvedCount;

  const PeriodStats({
    required this.totalShifts,
    required this.lateCount,
    required this.overtimeCount,
    required this.overtimeAmountSum,
    required this.problemCount,
    required this.problemSolvedCount,
  });

  /// Empty period stats
  static const empty = PeriodStats(
    totalShifts: 0,
    lateCount: 0,
    overtimeCount: 0,
    overtimeAmountSum: 0.0,
    problemCount: 0,
    problemSolvedCount: 0,
  );
}

/// Understaffed shifts count for different time periods
class UnderstaffedShifts {
  final int today;
  final int yesterday;
  final int thisMonth;
  final int lastMonth;
  final int twoMonthsAgo;

  const UnderstaffedShifts({
    required this.today,
    required this.yesterday,
    required this.thisMonth,
    required this.lastMonth,
    required this.twoMonthsAgo,
  });

  /// Get understaffed change (this month vs last month)
  int get monthlyChange => thisMonth - lastMonth;

  /// Empty understaffed shifts
  static const empty = UnderstaffedShifts(
    today: 0,
    yesterday: 0,
    thisMonth: 0,
    lastMonth: 0,
    twoMonthsAgo: 0,
  );
}

/// Employee reliability data
class EmployeeReliability {
  final String userId;
  final String userName;
  final String? profileImage;
  final int totalApplications;
  final int approvedShifts;
  final int completedShifts;
  final int lateCount;
  final double lateRate;
  final double onTimeRate;
  final double avgLateMinutes;
  final double reliability;
  final double finalScore;

  const EmployeeReliability({
    required this.userId,
    required this.userName,
    this.profileImage,
    required this.totalApplications,
    required this.approvedShifts,
    required this.completedShifts,
    required this.lateCount,
    required this.lateRate,
    required this.onTimeRate,
    required this.avgLateMinutes,
    required this.reliability,
    required this.finalScore,
  });

  /// Get employee name for display
  String get employeeName => userName;

  /// Get avatar URL for display
  String? get avatarUrl => profileImage;

  /// Get reliability score as int for display (rounded)
  int get reliabilityScore => finalScore.round();

  /// Get subtitle for leaderboard display
  String get subtitle {
    if (lateCount > 0 && completedShifts > 0) {
      return 'Late on $lateCount of last $completedShifts shifts';
    }
    if (onTimeRate >= 100 && completedShifts > 0) {
      return '100% on-time · 0 missed shifts this month';
    }
    if (completedShifts > 0) {
      final onTimeShifts = completedShifts - lateCount;
      return 'On-time for $onTimeShifts of last $completedShifts shifts';
    }
    return 'No shifts completed yet';
  }
}
