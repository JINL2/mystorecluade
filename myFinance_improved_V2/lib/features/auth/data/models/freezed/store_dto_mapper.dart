// lib/features/auth/data/models/freezed/store_dto_mapper.dart

import '../../../domain/entities/store_entity.dart';
import 'store_dto.dart';

/// StoreDto Mapper
///
/// Converts between StoreDto (Data Layer) and Store Entity (Domain Layer).
extension StoreDtoMapper on StoreDto {
  /// Convert DTO to Domain Entity
  Store toEntity() {
    return Store(
      id: storeId,
      name: storeName,
      companyId: companyId,
      storeCode: storeCode,
      address: storeAddress,
      phone: storePhone,
      huddleTimeMinutes: huddleTime,
      paymentTimeDays: paymentTime,
      allowedDistanceMeters: allowedDistance?.toDouble(),
      createdAt: DateTime.parse(createdAt),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }
}

/// Store Entity to DTO extension
extension StoreEntityMapper on Store {
  /// Convert Entity to DTO
  StoreDto toDto() {
    return StoreDto(
      storeId: id,
      storeName: name,
      companyId: companyId,
      storeCode: storeCode,
      storeAddress: address,
      storePhone: phone,
      huddleTime: huddleTimeMinutes,
      paymentTime: paymentTimeDays,
      allowedDistance: allowedDistanceMeters?.toInt(),
      createdAt: createdAt.toIso8601String(),
      updatedAt: updatedAt?.toIso8601String(),
    );
  }

  /// Convert Entity to insert map (without ID for DB auto-generation)
  Map<String, dynamic> toInsertMap() {
    final map = <String, dynamic>{
      'store_name': name,
      'company_id': companyId,
    };

    // Only include optional fields if not null/empty
    if (storeCode != null && storeCode!.isNotEmpty) {
      map['store_code'] = storeCode;
    }
    if (address != null && address!.isNotEmpty) {
      map['store_address'] = address;
    }
    if (phone != null && phone!.isNotEmpty) {
      map['store_phone'] = phone;
    }
    if (huddleTimeMinutes != null) {
      map['huddle_time'] = huddleTimeMinutes;
    }
    if (paymentTimeDays != null) {
      map['payment_time'] = paymentTimeDays;
    }
    if (allowedDistanceMeters != null) {
      map['allowed_distance'] = allowedDistanceMeters!.toInt();
    }

    return map;
  }
}
