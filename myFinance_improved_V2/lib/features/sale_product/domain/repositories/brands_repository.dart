import '../entities/brand.dart';

/// Repository interface for brands
abstract class BrandsRepository {
  /// Get all active brands for a company
  Future<List<Brand>> getBrands({
    required String companyId,
  });
}
