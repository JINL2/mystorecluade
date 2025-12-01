/// Domain service for assessing debt risk and priority
///
/// This service contains pure business logic for:
/// - Risk categorization based on days outstanding
/// - Priority score calculation
/// - Suggested actions based on risk level
class DebtRiskAssessmentService {
  /// Assess risk category based on days outstanding
  ///
  /// Business Rules:
  /// - > 90 days: Critical risk
  /// - > 60 days: Needs attention
  /// - > 30 days: Watch required
  /// - Otherwise: Current/Normal
  String assessRiskCategory(int daysOutstanding) {
    if (daysOutstanding > 90) {
      return 'critical';
    } else if (daysOutstanding > 60) {
      return 'attention';
    } else if (daysOutstanding > 30) {
      return 'watch';
    } else {
      return 'current';
    }
  }

  /// Calculate priority score based on days outstanding and risk category
  ///
  /// Business Rules:
  /// - Base score starts from days outstanding
  /// - Additional weight added based on risk category
  double calculatePriorityScore(int daysOutstanding, String riskCategory) {
    double baseScore = daysOutstanding.toDouble();

    switch (riskCategory) {
      case 'critical':
        return 90.0 + (daysOutstanding / 10);
      case 'attention':
        return 60.0 + (daysOutstanding / 10);
      case 'watch':
        return 30.0 + (daysOutstanding / 10);
      default:
        return baseScore;
    }
  }

  /// Get suggested actions based on risk category
  ///
  /// Business Rules:
  /// - Critical: Escalate with call, legal action, payment plan
  /// - Attention: Follow up with call, email, payment plan
  /// - Watch: Send email reminder
  /// - Current: Monitor only
  List<String> getSuggestedActions(String riskCategory) {
    switch (riskCategory) {
      case 'critical':
        return ['call', 'legal', 'payment_plan'];
      case 'attention':
        return ['call', 'email', 'payment_plan'];
      case 'watch':
        return ['email', 'reminder'];
      default:
        return ['monitor'];
    }
  }

  /// Assess complete debt risk profile
  ///
  /// Returns a map containing:
  /// - riskCategory: The assessed risk level
  /// - priorityScore: Calculated priority score
  /// - suggestedActions: List of recommended actions
  Map<String, dynamic> assessDebtRisk(int daysOutstanding) {
    final riskCategory = assessRiskCategory(daysOutstanding);
    final priorityScore = calculatePriorityScore(daysOutstanding, riskCategory);
    final suggestedActions = getSuggestedActions(riskCategory);

    return {
      'riskCategory': riskCategory,
      'priorityScore': priorityScore,
      'suggestedActions': suggestedActions,
    };
  }
}
