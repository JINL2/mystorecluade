import '../../../domain/entities/bcg_category.dart';

/// X-axis mode for BCG chart
enum BcgXAxisMode {
  revenue, // Revenue percentage (매출 비율)
  quantity, // Quantity percentage (수량 비율)
}

/// Data class for BCG chart calculations
class BcgChartData {
  final double minMargin;
  final double maxMargin;
  final double marginRange;
  final double maxX;
  final double medianMargin;
  final double medianX;
  final double medianXValue;
  final double medianY;
  final Map<String, int> quadrantCounts;
  final List<BcgSpotData> spotData;
  final BcgXAxisMode xAxisMode;

  const BcgChartData({
    required this.minMargin,
    required this.maxMargin,
    required this.marginRange,
    required this.maxX,
    required this.medianMargin,
    required this.medianX,
    required this.medianXValue,
    required this.medianY,
    required this.quadrantCounts,
    required this.spotData,
    this.xAxisMode = BcgXAxisMode.revenue,
  });

  factory BcgChartData.empty() => const BcgChartData(
        minMargin: 0,
        maxMargin: 100,
        marginRange: 100,
        maxX: 100,
        medianMargin: 50,
        medianX: 50,
        medianXValue: 50,
        medianY: 50,
        quadrantCounts: {'star': 0, 'cash_cow': 0, 'problem_child': 0, 'dog': 0},
        spotData: [],
      );

  /// X-axis label based on mode
  String get xAxisLabel => xAxisMode == BcgXAxisMode.revenue ? 'Revenue' : 'Sales Volume';

  /// Calculate BCG chart data from BcgMatrix
  /// Phase 4 Optimization: Limit to top 50 categories for performance
  factory BcgChartData.calculate(
    BcgMatrix bcgMatrix, {
    bool useMean = false,
    BcgXAxisMode xAxisMode = BcgXAxisMode.revenue,
    int maxCategories = 50,
  }) {
    if (bcgMatrix.categories.isEmpty) {
      return BcgChartData.empty();
    }

    // Phase 4: Limit categories to top N by revenue for performance
    final sortedCategories = List<BcgCategory>.from(bcgMatrix.categories)
      ..sort((a, b) => b.totalRevenue.compareTo(a.totalRevenue));
    final limitedCategories = sortedCategories.take(maxCategories).toList();

    final margins =
        limitedCategories.map((c) => c.marginPercentile.toDouble()).toList();

    // X-axis values based on mode (using limited categories)
    final xValues = limitedCategories.map((c) {
      return xAxisMode == BcgXAxisMode.revenue
          ? c.revenuePct.toDouble()
          : c.salesVolumePercentile.toDouble();
    }).toList();

    // Y-axis: Margin range with padding
    final minMarginData = margins.reduce((a, b) => a < b ? a : b);
    final maxMarginData = margins.reduce((a, b) => a > b ? a : b);
    final marginPadding =
        ((maxMarginData - minMarginData) * 0.15).clamp(2.0, 10.0);
    final minMargin = (minMarginData - marginPadding).clamp(0.0, 100.0);
    final maxMargin = (maxMarginData + marginPadding).clamp(0.0, 100.0);
    final marginRange = maxMargin - minMargin;

    // X-axis: Range
    final maxXValue = xValues.reduce((a, b) => a > b ? a : b);
    final maxX = (maxXValue * 1.1).clamp(10.0, 100.0);

    // Calculate divider value (mean or median)
    double dividerMargin;
    double dividerX;

    if (useMean) {
      dividerMargin = margins.reduce((a, b) => a + b) / margins.length;
      dividerX = xValues.reduce((a, b) => a + b) / xValues.length;
    } else {
      final sortedMargins = [...margins]..sort();
      dividerMargin = sortedMargins[sortedMargins.length ~/ 2];
      final sortedX = [...xValues]..sort();
      dividerX = sortedX[sortedX.length ~/ 2];
    }

    final dividerY =
        ((dividerMargin - minMargin) / marginRange * 100).clamp(0.0, 100.0);
    final dividerXPos = (dividerX / maxX * 100).clamp(0.0, 100.0);

    // Create spot data (using limited categories)
    final spotData = limitedCategories.map((cat) {
      final xDataValue = xAxisMode == BcgXAxisMode.revenue
          ? cat.revenuePct.toDouble()
          : cat.salesVolumePercentile.toDouble();
      final xValue = (xDataValue / maxX * 100).clamp(2.0, 98.0);
      final yValue =
          ((cat.marginPercentile - minMargin) / marginRange * 100).clamp(2.0, 98.0);

      final isHighX = xDataValue >= dividerX;
      final isHighMargin = cat.marginPercentile >= dividerMargin;

      String calculatedQuadrant;
      if (isHighMargin && isHighX) {
        calculatedQuadrant = 'star';
      } else if (isHighMargin && !isHighX) {
        calculatedQuadrant = 'problem_child';
      } else if (!isHighMargin && isHighX) {
        calculatedQuadrant = 'cash_cow';
      } else {
        calculatedQuadrant = 'dog';
      }

      return BcgSpotData(
        category: cat,
        xValue: xValue,
        yValue: yValue,
        quadrant: calculatedQuadrant,
      );
    }).toList();

    // Count by quadrant
    final quadrantCounts = {
      'star': spotData.where((d) => d.quadrant == 'star').length,
      'cash_cow': spotData.where((d) => d.quadrant == 'cash_cow').length,
      'problem_child': spotData.where((d) => d.quadrant == 'problem_child').length,
      'dog': spotData.where((d) => d.quadrant == 'dog').length,
    };

    return BcgChartData(
      minMargin: minMargin,
      maxMargin: maxMargin,
      marginRange: marginRange,
      maxX: maxX,
      medianMargin: dividerMargin,
      medianX: dividerXPos,
      medianXValue: dividerX,
      medianY: dividerY,
      quadrantCounts: quadrantCounts,
      spotData: spotData,
      xAxisMode: xAxisMode,
    );
  }
}

/// Data class for individual BCG spot
class BcgSpotData {
  final BcgCategory category;
  final double xValue;
  final double yValue;
  final String quadrant;

  const BcgSpotData({
    required this.category,
    required this.xValue,
    required this.yValue,
    required this.quadrant,
  });
}
