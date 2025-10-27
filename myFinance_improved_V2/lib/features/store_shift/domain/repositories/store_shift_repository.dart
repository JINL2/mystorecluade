import '../entities/store_shift.dart';

/// Store Shift Repository Interface
///
/// Defines the contract for store shift data operations.
/// This is an abstraction that allows the domain layer to remain
/// independent of data layer implementation details.
abstract class StoreShiftRepository {
  /// Fetch all shifts for a specific store
  ///
  /// Parameters:
  /// - [storeId]: The ID of the store
  ///
  /// Returns a list of [StoreShift] entities
  /// Throws an exception if the operation fails
  Future<List<StoreShift>> getShiftsByStoreId(String storeId);

  /// Create a new shift
  ///
  /// Parameters:
  /// - [storeId]: The ID of the store
  /// - [shiftName]: Name of the shift
  /// - [startTime]: Start time in HH:mm format
  /// - [endTime]: End time in HH:mm format
  /// - [shiftBonus]: Bonus amount for this shift
  ///
  /// Returns the created [StoreShift] entity
  /// Throws an exception if the operation fails
  Future<StoreShift> createShift({
    required String storeId,
    required String shiftName,
    required String startTime,
    required String endTime,
    required int shiftBonus,
  });

  /// Update an existing shift
  ///
  /// Parameters:
  /// - [shiftId]: The ID of the shift to update
  /// - [shiftName]: Updated name (optional)
  /// - [startTime]: Updated start time (optional)
  /// - [endTime]: Updated end time (optional)
  /// - [shiftBonus]: Updated bonus amount (optional)
  ///
  /// Returns the updated [StoreShift] entity
  /// Throws an exception if the operation fails
  Future<StoreShift> updateShift({
    required String shiftId,
    String? shiftName,
    String? startTime,
    String? endTime,
    int? shiftBonus,
  });

  /// Delete a shift (soft delete by setting is_active to false)
  ///
  /// Parameters:
  /// - [shiftId]: The ID of the shift to delete
  ///
  /// Throws an exception if the operation fails
  Future<void> deleteShift(String shiftId);

  /// Get detailed store information by ID
  ///
  /// Parameters:
  /// - [storeId]: The ID of the store
  ///
  /// Returns a Map containing store details
  /// Throws an exception if the operation fails
  Future<Map<String, dynamic>> getStoreById(String storeId);

  /// Update store location
  ///
  /// Parameters:
  /// - [storeId]: The ID of the store
  /// - [latitude]: Latitude coordinate
  /// - [longitude]: Longitude coordinate
  /// - [address]: Store address
  ///
  /// Throws an exception if the operation fails
  Future<void> updateStoreLocation({
    required String storeId,
    required double latitude,
    required double longitude,
    required String address,
  });
}
