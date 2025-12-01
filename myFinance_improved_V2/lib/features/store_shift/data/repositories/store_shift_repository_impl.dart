import '../../domain/entities/store_shift.dart';
import '../../domain/repositories/store_shift_repository.dart';
import '../datasources/store_shift_data_source.dart';
import '../models/store_shift_model.dart';

/// Store Shift Repository Implementation
///
/// Implements the repository interface defined in the domain layer.
/// This class:
/// - Delegates data operations to the data source
/// - Converts between models (data layer) and entities (domain layer)
/// - Handles business logic related to data transformation
class StoreShiftRepositoryImpl implements StoreShiftRepository {
  final StoreShiftDataSource _dataSource;

  StoreShiftRepositoryImpl(this._dataSource);

  @override
  Future<List<StoreShift>> getShiftsByStoreId(String storeId) async {
    final shiftsData = await _dataSource.getShiftsByStoreId(storeId);

    return shiftsData
        .map((json) => StoreShiftModel.fromJson(json).toEntity())
        .toList();
  }

  @override
  Future<StoreShift> createShift({
    required String storeId,
    required String shiftName,
    required String startTime,
    required String endTime,
    int? numberShift,
    bool? isCanOvertime,
    int? shiftBonus,
  }) async {
    final shiftData = await _dataSource.createShift(
      storeId: storeId,
      shiftName: shiftName,
      startTime: startTime,
      endTime: endTime,
      numberShift: numberShift,
      isCanOvertime: isCanOvertime,
      shiftBonus: shiftBonus,
    );

    // RPC returns {success, message, shift_id}, not full shift data
    // Create a minimal StoreShift with the returned shift_id
    return StoreShift(
      shiftId: shiftData['shift_id'] as String,
      shiftName: shiftName,
      startTime: startTime,
      endTime: endTime,
      shiftBonus: shiftBonus ?? 0,
      isActive: true,
      numberShift: numberShift ?? 1,
      isCanOvertime: isCanOvertime ?? true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<StoreShift> updateShift({
    required String shiftId,
    String? shiftName,
    String? startTime,
    String? endTime,
    int? numberShift,
    bool? isCanOvertime,
    int? shiftBonus,
  }) async {
    final shiftData = await _dataSource.updateShift(
      shiftId: shiftId,
      shiftName: shiftName,
      startTime: startTime,
      endTime: endTime,
      numberShift: numberShift,
      isCanOvertime: isCanOvertime,
      shiftBonus: shiftBonus,
    );

    return StoreShiftModel.fromJson(shiftData).toEntity();
  }

  @override
  Future<void> deleteShift(String shiftId) async {
    await _dataSource.deleteShift(shiftId);
  }

  @override
  Future<Map<String, dynamic>> getStoreById(String storeId) async {
    return await _dataSource.getStoreById(storeId);
  }

  @override
  Future<void> updateStoreLocation({
    required String storeId,
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    await _dataSource.updateStoreLocation(
      storeId: storeId,
      latitude: latitude,
      longitude: longitude,
      address: address,
    );
  }

  @override
  Future<void> updateOperationalSettings({
    required String storeId,
    int? huddleTime,
    int? paymentTime,
    int? allowedDistance,
  }) async {
    await _dataSource.updateOperationalSettings(
      storeId: storeId,
      huddleTime: huddleTime,
      paymentTime: paymentTime,
      allowedDistance: allowedDistance,
    );
  }
}
