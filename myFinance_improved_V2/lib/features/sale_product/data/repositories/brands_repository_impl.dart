import '../../domain/entities/brand.dart';
import '../../domain/repositories/brands_repository.dart';
import '../datasources/brands_remote_datasource.dart';

/// Implementation of BrandsRepository
class BrandsRepositoryImpl implements BrandsRepository {
  final BrandsRemoteDataSource _dataSource;

  BrandsRepositoryImpl(this._dataSource);

  @override
  Future<List<Brand>> getBrands({required String companyId}) async {
    final response = await _dataSource.getBrands(companyId: companyId);

    return response
        .map(
          (json) => Brand(
            id: json['brand_id']?.toString() ?? '',
            name: json['brand_name']?.toString() ?? '',
          ),
        )
        .where((b) => b.name.isNotEmpty)
        .toList();
  }
}
