import { Store } from '../../domain/entities/Store';

/**
 * StoreModel - DTO Mapper
 * Supabase DTO ↔ Domain Entity 변환 담당
 *
 * Clean Architecture Data Layer:
 * - fromJson: DB DTO → Domain Entity
 * - toJson: Domain Entity → DB DTO
 */
export class StoreModel {
  /**
   * Supabase DTO를 Domain Entity로 변환
   * @param dto - Supabase stores 테이블 row
   */
  static fromJson(dto: any): Store {
    return new Store(
      dto.store_id,
      dto.company_id,
      dto.store_name,
      dto.store_address,
      dto.store_phone,
      !dto.is_deleted,
      dto.huddle_time,
      dto.payment_time,
      dto.allowed_distance
    );
  }

  /**
   * Domain Entity를 Supabase DTO로 변환
   * @param entity - Store domain entity
   */
  static toJson(entity: Store) {
    return {
      store_id: entity.storeId,
      company_id: entity.companyId,
      store_name: entity.storeName,
      store_address: entity.address,
      store_phone: entity.phone,
      is_deleted: !entity.isActive,
      huddle_time: entity.huddleTime,
      payment_time: entity.paymentTime,
      allowed_distance: entity.allowedDistance
    };
  }

  /**
   * 생성용 DTO 준비 (ID 제외)
   */
  static toCreateJson(
    companyId: string,
    storeName: string,
    address: string | null,
    phone: string | null
  ) {
    return {
      company_id: companyId,
      store_name: storeName,
      store_address: address || null,
      store_phone: phone || null,
      is_deleted: false
    };
  }
}
