import '../entities/fixed_asset.dart';

/// Fixed Asset Repository interface
/// 고정자산 레포지토리 인터페이스 (추상화)
abstract class FixedAssetRepository {
  /// 고정자산 목록 조회
  /// [companyId] - 회사 ID (필수)
  /// [storeId] - 매장 ID (null = 본사, empty = 전체, specific = 특정 매장)
  Future<List<FixedAsset>> getFixedAssets({
    required String companyId,
    String? storeId,
  });

  /// 고정자산 추가
  Future<String> createFixedAsset(FixedAsset asset, {required String timezone});

  /// 고정자산 수정
  Future<void> updateFixedAsset(FixedAsset asset, {required String timezone});

  /// 고정자산 삭제
  Future<void> deleteFixedAsset({
    required String assetId,
    required String companyId,
    required String timezone,
  });

  /// 회사 기본 통화 정보 조회 (currencyId, symbol 반환)
  Future<({String? currencyId, String symbol})> getBaseCurrencyInfo(
    String companyId,
  );
}
