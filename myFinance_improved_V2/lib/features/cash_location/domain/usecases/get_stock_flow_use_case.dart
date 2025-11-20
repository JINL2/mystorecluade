import '../entities/stock_flow.dart';
import '../repositories/cash_location_repository.dart';
import '../value_objects/stock_flow_params.dart';
import 'use_case.dart';

/// Use case for getting stock flow data
class GetStockFlowUseCase implements UseCase<StockFlowResponse, StockFlowParams> {
  final CashLocationRepository repository;

  GetStockFlowUseCase(this.repository);

  @override
  Future<StockFlowResponse> call(StockFlowParams params) async {
    return repository.getLocationStockFlow(
      companyId: params.companyId,
      storeId: params.storeId,
      cashLocationId: params.cashLocationId,
      offset: params.offset,
      limit: params.limit,
    );
  }
}
