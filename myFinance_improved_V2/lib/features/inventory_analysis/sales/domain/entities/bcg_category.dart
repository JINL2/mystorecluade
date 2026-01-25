import 'package:freezed_annotation/freezed_annotation.dart';

part 'bcg_category.freezed.dart';

/// BCG Matrix Quadrant Type
enum BcgQuadrant {
  star,       // High growth + High margin
  cashCow,    // Low growth + High margin
  problemChild, // High growth + Low margin
  dog,        // Low growth + Low margin
}

/// BCG Matrix Category Data
/// RPC: inventory_analysis_get_bcg_matrix response
@freezed
class BcgCategory with _$BcgCategory {
  const BcgCategory._();

  const factory BcgCategory({
    required String categoryId,
    required String categoryName,
    required num totalRevenue,
    required num marginRatePct,
    required int totalQuantity,
    required num revenuePct, // Revenue percentage (매출 비율)
    required num salesVolumePercentile, // Quantity percentage (수량 비율)
    required num marginPercentile,
    required String quadrant, // 'Star', 'Cash Cow', 'Problem Child', 'Dog'
  }) = _BcgCategory;

  /// Convert quadrant string to enum
  /// Handles both lowercase ('star', 'cash_cow') and title case ('Star', 'Cash Cow')
  BcgQuadrant get quadrantType {
    return switch (quadrant.toLowerCase()) {
      'star' => BcgQuadrant.star,
      'cash_cow' => BcgQuadrant.cashCow,
      'problem_child' => BcgQuadrant.problemChild,
      'dog' => BcgQuadrant.dog,
      _ => BcgQuadrant.dog,
    };
  }

  /// Recommended Strategy
  String get strategy {
    return switch (quadrantType) {
      BcgQuadrant.star => 'Expand inventory, Strengthen promotions',
      BcgQuadrant.cashCow => 'Maintain current strategy',
      BcgQuadrant.problemChild => 'Reduce costs or increase prices',
      BcgQuadrant.dog => 'Consider discontinuation or alternatives',
    };
  }

  /// Quadrant Label
  String get quadrantLabel {
    return switch (quadrantType) {
      BcgQuadrant.star => 'Star',
      BcgQuadrant.cashCow => 'Cash Cow',
      BcgQuadrant.problemChild => 'Question Mark',
      BcgQuadrant.dog => 'Dog',
    };
  }
}

/// BCG Matrix Full Data
@freezed
class BcgMatrix with _$BcgMatrix {
  const BcgMatrix._();

  const factory BcgMatrix({
    required List<BcgCategory> categories,
  }) = _BcgMatrix;

  /// Filter categories by quadrant
  List<BcgCategory> getByQuadrant(BcgQuadrant quadrant) {
    return categories.where((c) => c.quadrantType == quadrant).toList();
  }

  List<BcgCategory> get stars => getByQuadrant(BcgQuadrant.star);
  List<BcgCategory> get cashCows => getByQuadrant(BcgQuadrant.cashCow);
  List<BcgCategory> get problemChildren => getByQuadrant(BcgQuadrant.problemChild);
  List<BcgCategory> get dogs => getByQuadrant(BcgQuadrant.dog);
}
