import '../../domain/entities/letter_of_credit.dart';
import '../../domain/repositories/lc_repository.dart';
import '../datasources/lc_remote_datasource.dart';

class LCRepositoryImpl implements LCRepository {
  final LCRemoteDatasource _datasource;

  LCRepositoryImpl(this._datasource);

  @override
  Future<PaginatedLCResponse> getList(LCListParams params) {
    return _datasource.getList(params);
  }

  @override
  Future<LetterOfCredit> getById(String lcId) {
    return _datasource.getById(lcId);
  }

  @override
  Future<LetterOfCredit> create(LCCreateParams params) {
    return _datasource.create(params);
  }

  @override
  Future<LetterOfCredit> update(
      String lcId, int version, Map<String, dynamic> updates) {
    return _datasource.update(lcId, version, updates);
  }

  @override
  Future<void> delete(String lcId) {
    return _datasource.delete(lcId);
  }

  @override
  Future<void> updateStatus(String lcId, LCStatus newStatus, {String? notes}) {
    return _datasource.updateStatus(lcId, newStatus, notes: notes);
  }

  @override
  Future<LCAmendment> addAmendment(String lcId, LCAmendmentCreateParams params) {
    return _datasource.addAmendment(lcId, params);
  }

  @override
  Future<void> updateAmendmentStatus(
      String amendmentId, LCAmendmentStatus status) {
    return _datasource.updateAmendmentStatus(amendmentId, status);
  }

  @override
  Future<void> recordUtilization(String lcId, double amount) {
    return _datasource.recordUtilization(lcId, amount);
  }

  @override
  Future<String> createFromPO(String poId, {Map<String, dynamic>? options}) {
    return _datasource.createFromPO(poId, options: options);
  }
}
