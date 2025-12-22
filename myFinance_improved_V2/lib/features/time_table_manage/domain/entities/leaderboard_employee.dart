/// Data model for leaderboard employee
class LeaderboardEmployee {
  final int rank;
  final String name;
  final String subtitle;
  final String? avatarUrl;
  final int score; // Main display score (changes based on selected criteria)
  final double? change; // Optional - only shown if RPC provides historical data
  final bool isPositive;

  // Employee info for detail page
  final String? visitorId; // User ID for data fetching
  final String? role; // Employee role/position (e.g., "Shift leader", "Staff")
  final String? storeName; // Store name where employee works

  // Individual scores for different ranking criteria
  final double finalScore; // Overall reliability score
  final double lateRate; // Late rate percentage
  final double lateRateScore; // Late rate score (0-100)
  final int totalApplications; // Total shift applications
  final double applicationsScore; // Applications score (0-100)
  final double avgLateMinutes; // Average late minutes
  final double lateMinutesScore; // Late minutes score (0-100)
  final double fillRate; // Fill rate percentage
  final double fillRateScore; // Fill rate score (0-100)
  final int lateCount; // Number of late shifts
  // Salary fields for payroll calculation
  final double salaryAmount; // Salary amount from user_salaries
  final String? salaryType; // 'hourly' or 'monthly'
  final int completedShifts; // Number of completed shifts for payroll calc

  const LeaderboardEmployee({
    required this.rank,
    required this.name,
    required this.subtitle,
    this.avatarUrl,
    required this.score,
    this.change, // Optional
    required this.isPositive,
    this.visitorId,
    this.role,
    this.storeName,
    this.finalScore = 0,
    this.lateRate = 0,
    this.lateRateScore = 0,
    this.totalApplications = 0,
    this.applicationsScore = 0,
    this.avgLateMinutes = 0,
    this.lateMinutesScore = 0,
    this.fillRate = 0,
    this.fillRateScore = 0,
    this.lateCount = 0,
    this.salaryAmount = 0,
    this.salaryType,
    this.completedShifts = 0,
  });

  /// Create a copy with updated rank and score for different criteria
  LeaderboardEmployee copyWith({
    int? rank,
    String? name,
    String? subtitle,
    String? avatarUrl,
    int? score,
    double? change,
    bool? isPositive,
    String? visitorId,
    String? role,
    String? storeName,
    double? finalScore,
    double? lateRate,
    double? lateRateScore,
    int? totalApplications,
    double? applicationsScore,
    double? avgLateMinutes,
    double? lateMinutesScore,
    double? fillRate,
    double? fillRateScore,
    int? lateCount,
    double? salaryAmount,
    String? salaryType,
    int? completedShifts,
  }) {
    return LeaderboardEmployee(
      rank: rank ?? this.rank,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      score: score ?? this.score,
      change: change ?? this.change,
      isPositive: isPositive ?? this.isPositive,
      visitorId: visitorId ?? this.visitorId,
      role: role ?? this.role,
      storeName: storeName ?? this.storeName,
      finalScore: finalScore ?? this.finalScore,
      lateRate: lateRate ?? this.lateRate,
      lateRateScore: lateRateScore ?? this.lateRateScore,
      totalApplications: totalApplications ?? this.totalApplications,
      applicationsScore: applicationsScore ?? this.applicationsScore,
      avgLateMinutes: avgLateMinutes ?? this.avgLateMinutes,
      lateMinutesScore: lateMinutesScore ?? this.lateMinutesScore,
      fillRate: fillRate ?? this.fillRate,
      fillRateScore: fillRateScore ?? this.fillRateScore,
      lateCount: lateCount ?? this.lateCount,
      salaryAmount: salaryAmount ?? this.salaryAmount,
      salaryType: salaryType ?? this.salaryType,
      completedShifts: completedShifts ?? this.completedShifts,
    );
  }
}
