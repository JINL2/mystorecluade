/// Problem Details Entity
///
/// Contains detailed problem information with types and minutes.
/// v5: New entity for structured problem tracking.
class ProblemDetails {
  /// Whether employee was late
  final bool hasLate;

  /// Whether employee worked overtime
  final bool hasOvertime;

  /// Whether employee reported an issue
  final bool hasReported;

  /// Whether employee didn't check out
  final bool hasNoCheckout;

  /// Whether employee was absent
  final bool hasAbsence;

  /// Whether employee left early
  final bool hasEarlyLeave;

  /// Whether there's a location issue
  final bool hasLocationIssue;

  /// Whether late affects payroll
  final bool hasPayrollLate;

  /// Whether overtime affects payroll
  final bool hasPayrollOvertime;

  /// Whether early leave affects payroll
  final bool hasPayrollEarlyLeave;

  /// Total number of problems
  final int problemCount;

  /// Whether all problems are solved
  final bool isSolved;

  /// When problems were detected
  final DateTime? detectedAt;

  /// Individual problem items
  final List<ProblemItem> problems;

  const ProblemDetails({
    this.hasLate = false,
    this.hasOvertime = false,
    this.hasReported = false,
    this.hasNoCheckout = false,
    this.hasAbsence = false,
    this.hasEarlyLeave = false,
    this.hasLocationIssue = false,
    this.hasPayrollLate = false,
    this.hasPayrollOvertime = false,
    this.hasPayrollEarlyLeave = false,
    this.problemCount = 0,
    this.isSolved = false,
    this.detectedAt,
    this.problems = const [],
  });

  /// Check if there are any active problems
  bool get hasAnyProblem => problemCount > 0 && !isSolved;

  /// Get unsolved problem items
  List<ProblemItem> get unsolvedProblems =>
      problems.where((p) => !p.isSolved).toList();

  /// Check if ALL problems are fully solved (including reported)
  /// A shift is "solved" only when ALL problem items are solved
  /// Don't rely on DB's isSolved alone - check actual problems array
  bool get isFullySolved {
    // No problems = nothing to solve
    if (problems.isEmpty) return true;

    // Check if ALL problems are solved
    return problems.every((p) => p.isSolved);
  }

  /// Check if there's any problem (not solved)
  bool get hasProblem => problemCount > 0 && !isSolved;

  /// Get late minutes from problems array
  int get lateMinutes {
    final lateProblem = problems.firstWhere(
      (p) => p.type == 'late',
      orElse: () => const ProblemItem(type: ''),
    );
    return lateProblem.actualMinutes ?? 0;
  }

  /// Get overtime minutes from problems array
  int get overtimeMinutes {
    final overtimeProblem = problems.firstWhere(
      (p) => p.type == 'overtime',
      orElse: () => const ProblemItem(type: ''),
    );
    return overtimeProblem.actualMinutes ?? 0;
  }

  /// Get checkin distance from problems array (location issue)
  int? get checkinDistance {
    final locationProblem = problems.firstWhere(
      (p) => p.type == 'location_issue',
      orElse: () => const ProblemItem(type: ''),
    );
    return locationProblem.actualMinutes; // actualMinutes stores distance for location issues
  }
}

/// Individual Problem Item
///
/// Represents a single problem entry with type and details.
/// Types: "late", "overtime", "reported", "no_checkout", "early_leave", etc.
class ProblemItem {
  /// Problem type (late, overtime, reported, no_checkout, early_leave, etc.)
  final String type;

  /// Actual minutes (for late/overtime)
  final int? actualMinutes;

  /// Payroll-adjusted minutes (for late/overtime)
  final int? payrollMinutes;

  /// Whether payroll was adjusted for this problem
  final bool isPayrollAdjusted;

  /// Reason (for reported type)
  final String? reason;

  /// When reported (for reported type)
  final DateTime? reportedAt;

  /// Whether this problem is solved
  final bool isSolved;

  const ProblemItem({
    required this.type,
    this.actualMinutes,
    this.payrollMinutes,
    this.isPayrollAdjusted = false,
    this.reason,
    this.reportedAt,
    this.isSolved = false,
  });

  /// Check if this is a late problem
  bool get isLate => type == 'late';

  /// Check if this is an overtime problem
  bool get isOvertime => type == 'overtime';

  /// Check if this is a reported problem
  bool get isReported => type == 'reported';

  /// Check if this is a no-checkout problem
  bool get isNoCheckout => type == 'no_checkout';

  /// Check if this is an early leave problem
  bool get isEarlyLeave => type == 'early_leave';

  /// Get display name for the problem type
  String get displayName {
    switch (type) {
      case 'late':
        return 'Late';
      case 'overtime':
        return 'Overtime';
      case 'reported':
        return 'Reported';
      case 'no_checkout':
        return 'No Checkout';
      case 'invalid_checkin':
        return 'Invalid Check-in';
      case 'early_leave':
        return 'Early Leave';
      case 'absence':
        return 'Absent';
      case 'location_issue':
        return 'Location Issue';
      default:
        return type;
    }
  }
}
