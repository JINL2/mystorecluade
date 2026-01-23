/**
 * BalanceSummaryModel
 * Handles JSON transformation between API and Domain Entity
 */

import { BalanceSummaryEntity, type BalanceSummaryData } from '../../domain/entities/BalanceSummary';

export class BalanceSummaryModel {
  /**
   * Convert API JSON response to Domain Entity
   */
  static fromJson(json: BalanceSummaryData): BalanceSummaryEntity {
    return new BalanceSummaryEntity(
      json.success,
      json.location_id,
      json.location_name,
      json.location_type,
      json.total_journal,
      json.total_real,
      json.difference,
      json.is_balanced,
      json.has_shortage,
      json.has_surplus,
      json.currency_symbol,
      json.currency_code,
      json.last_updated,
      json.error
    );
  }

  /**
   * Convert Domain Entity to API JSON format
   */
  static toJson(entity: BalanceSummaryEntity): BalanceSummaryData {
    return {
      success: entity.success,
      location_id: entity.locationId,
      location_name: entity.locationName,
      location_type: entity.locationType,
      total_journal: entity.totalJournal,
      total_real: entity.totalReal,
      difference: entity.difference,
      is_balanced: entity.isBalanced,
      has_shortage: entity.hasShortage,
      has_surplus: entity.hasSurplus,
      currency_symbol: entity.currencySymbol,
      currency_code: entity.currencyCode,
      last_updated: entity.lastUpdated,
      error: entity.error,
    };
  }
}
