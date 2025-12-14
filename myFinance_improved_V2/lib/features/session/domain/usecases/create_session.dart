import '../entities/inventory_session.dart';
import '../repositories/session_repository.dart';

/// Create a new inventory session via RPC
///
/// For counting: no shipmentId needed
/// For receiving: shipmentId is required
/// Matches RPC: inventory_create_session
class CreateSession {
  final SessionRepository _repository;

  CreateSession(this._repository);

  Future<CreateSessionResponse> call({
    required String companyId,
    required String storeId,
    required String userId,
    required String sessionType,
    String? sessionName,
    String? shipmentId,
  }) {
    return _repository.createSessionViaRpc(
      companyId: companyId,
      storeId: storeId,
      userId: userId,
      sessionType: sessionType,
      sessionName: sessionName,
      shipmentId: shipmentId,
    );
  }
}
