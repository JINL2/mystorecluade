import '../../domain/entities/proforma_invoice.dart';
import '../../domain/repositories/pi_repository.dart';
import '../datasources/pi_remote_datasource.dart';

class PIRepositoryImpl implements PIRepository {
  final PIRemoteDatasource _datasource;

  PIRepositoryImpl(this._datasource);

  @override
  Future<PaginatedList<PIListItem>> getList(PIListParams params) async {
    final response = await _datasource.getList(params);
    return PaginatedList(
      items: response.data.map((m) => m.toListItem()).toList(),
      totalCount: response.totalCount,
      page: response.page,
      pageSize: response.pageSize,
      hasMore: response.hasMore,
    );
  }

  @override
  Future<ProformaInvoice> getById(String piId) async {
    final model = await _datasource.getById(piId);
    return model.toEntity();
  }

  @override
  Future<ProformaInvoice> create(PICreateParams params) async {
    final model = await _datasource.create(params);
    return model.toEntity();
  }

  @override
  Future<ProformaInvoice> update(String piId, PICreateParams params) async {
    final model = await _datasource.update(piId, params);
    return model.toEntity();
  }

  @override
  Future<void> delete(String piId) async {
    await _datasource.delete(piId);
  }

  @override
  Future<void> send(String piId) async {
    await _datasource.send(piId);
  }

  @override
  Future<void> accept(String piId) async {
    await _datasource.accept(piId);
  }

  @override
  Future<void> reject(String piId, String? reason) async {
    await _datasource.reject(piId, reason);
  }

  @override
  Future<String> convertToPO(String piId) async {
    return await _datasource.convertToPO(piId);
  }

  @override
  Future<ProformaInvoice> duplicate(String piId) async {
    final model = await _datasource.duplicate(piId);
    return model.toEntity();
  }

  @override
  Future<String> generateNumber(String companyId) async {
    return await _datasource.generateNumber(companyId);
  }
}
