/**
 * CashLocationModel
 * Handles JSON transformation between API and Domain Entity
 */

import { CashLocationEntity, type CashLocation } from '../../domain/entities/CashLocation';

export class CashLocationModel {
  /**
   * Convert API JSON response to Domain Entity
   */
  static fromJson(json: CashLocation): CashLocationEntity {
    return new CashLocationEntity(
      json.cash_location_id,
      json.location_name,
      json.location_type,
      json.store_id,
      json.store_name,
      json.company_id,
      json.is_active,
      json.created_at,
      json.updated_at
    );
  }

  /**
   * Convert Domain Entity to API JSON format
   */
  static toJson(entity: CashLocationEntity): CashLocation {
    return {
      cash_location_id: entity.cashLocationId,
      location_name: entity.locationName,
      location_type: entity.locationType,
      store_id: entity.storeId,
      store_name: entity.storeName,
      company_id: entity.companyId,
      is_active: entity.isActive,
      created_at: entity.createdAt,
      updated_at: entity.updatedAt,
    };
  }
}
