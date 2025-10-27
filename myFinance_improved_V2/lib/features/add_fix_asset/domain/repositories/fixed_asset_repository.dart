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

  /// 고정자산 단일 조회
  Future<FixedAsset?> getFixedAssetById(String assetId);

  /// 고정자산 추가
  Future<void> createFixedAsset(FixedAsset asset);

  /// 고정자산 수정
  Future<void> updateFixedAsset(FixedAsset asset);

  /// 고정자산 삭제
  Future<void> deleteFixedAsset(String assetId);

  /// 회사의 기본 통화 조회
  Future<String?> getCompanyBaseCurrency(String companyId);

  /// 통화 심볼 조회
  Future<String> getCurrencySymbol(String currencyId);
}
