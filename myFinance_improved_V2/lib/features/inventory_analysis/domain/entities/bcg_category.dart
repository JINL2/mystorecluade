import 'package:freezed_annotation/freezed_annotation.dart';

part 'bcg_category.freezed.dart';

/// BCG Matrix 분면 타입
enum BcgQuadrant {
  star,       // 높은 성장 + 높은 마진
  cashCow,    // 낮은 성장 + 높은 마진
  problemChild, // 높은 성장 + 낮은 마진
  dog,        // 낮은 성장 + 낮은 마진
}

/// BCG Matrix 카테고리 데이터
/// RPC: get_bcg_matrix 응답
@freezed
class BcgCategory with _$BcgCategory {
  const BcgCategory._();

  const factory BcgCategory({
    required String categoryId,
    required String categoryName,
    required num totalRevenue,
    required num marginRatePct,
    required int totalQuantity,
    required num salesVolumePercentile,
    required num marginPercentile,
    required String quadrant, // 'Star', 'Cash Cow', 'Problem Child', 'Dog'
  }) = _BcgCategory;

  /// quadrant 문자열을 enum으로 변환
  BcgQuadrant get quadrantType {
    return switch (quadrant) {
      'Star' => BcgQuadrant.star,
      'Cash Cow' => BcgQuadrant.cashCow,
      'Problem Child' => BcgQuadrant.problemChild,
      'Dog' => BcgQuadrant.dog,
      _ => BcgQuadrant.dog,
    };
  }

  /// 추천 전략
  String get strategy {
    return switch (quadrantType) {
      BcgQuadrant.star => '재고 확대, 프로모션 강화',
      BcgQuadrant.cashCow => '현재 전략 유지',
      BcgQuadrant.problemChild => '원가 절감 또는 가격 인상',
      BcgQuadrant.dog => '단종 또는 대체품 검토',
    };
  }

  /// 분면 한글명
  String get quadrantLabel {
    return switch (quadrantType) {
      BcgQuadrant.star => '스타',
      BcgQuadrant.cashCow => '캐시카우',
      BcgQuadrant.problemChild => '문제아',
      BcgQuadrant.dog => '개',
    };
  }
}

/// BCG Matrix 전체 데이터
@freezed
class BcgMatrix with _$BcgMatrix {
  const BcgMatrix._();

  const factory BcgMatrix({
    required List<BcgCategory> categories,
  }) = _BcgMatrix;

  /// 분면별 카테고리 필터
  List<BcgCategory> getByQuadrant(BcgQuadrant quadrant) {
    return categories.where((c) => c.quadrantType == quadrant).toList();
  }

  List<BcgCategory> get stars => getByQuadrant(BcgQuadrant.star);
  List<BcgCategory> get cashCows => getByQuadrant(BcgQuadrant.cashCow);
  List<BcgCategory> get problemChildren => getByQuadrant(BcgQuadrant.problemChild);
  List<BcgCategory> get dogs => getByQuadrant(BcgQuadrant.dog);
}
