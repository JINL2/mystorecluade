/**
 * JournalInputModels
 * DTO Models and Mappers for Journal Input feature
 * Handles conversion between API responses and Domain entities
 */

import type {
  Account,
  CashLocation,
  Counterparty,
  TransactionTemplate,
} from '../../domain/repositories/IJournalInputRepository';

/**
 * AccountModel - Maps between API response and Account entity
 */
export class AccountModel {
  /**
   * Convert API response to Account entity
   */
  static fromJson(json: any): Account {
    return {
      accountId: json.id,
      accountName: json.name,
      categoryTag: json.categoryTag,
      accountType: json.type,
      expenseNature: json.expenseNature,
    };
  }

  /**
   * Convert Account entity to API format
   */
  static toJson(account: Account): any {
    return {
      id: account.accountId,
      name: account.accountName,
      categoryTag: account.categoryTag,
      type: account.accountType,
      expenseNature: account.expenseNature,
    };
  }
}

/**
 * CashLocationModel - Maps between API response and CashLocation entity
 * Updated for get_cash_locations_v2 RPC response
 */
export class CashLocationModel {
  /**
   * Convert API response to CashLocation entity
   * Supports both v1 (id, name, type) and v2 (cash_location_id, location_name, location_type) formats
   */
  static fromJson(json: any): CashLocation {
    return {
      locationId: json.cash_location_id || json.id,
      locationName: json.location_name || json.name,
      locationType: json.location_type || json.type,
      storeId: json.store_id || json.storeId,
      isCompanyWide: json.is_company_wide ?? json.isCompanyWide ?? false,
    };
  }

  /**
   * Convert CashLocation entity to API format
   */
  static toJson(location: CashLocation): any {
    return {
      cash_location_id: location.locationId,
      location_name: location.locationName,
      location_type: location.locationType,
      store_id: location.storeId,
      is_company_wide: location.isCompanyWide,
    };
  }
}

/**
 * CounterpartyModel - Maps between API response and Counterparty entity
 */
export class CounterpartyModel {
  /**
   * Convert API response to Counterparty entity
   */
  static fromJson(json: any): Counterparty {
    return {
      counterpartyId: json.counterparty_id || json.id,
      counterpartyName: json.name,
      type: json.type,
      isInternal: json.is_internal ?? json.isInternal ?? false,
      email: json.email,
      phone: json.phone,
      linkedCompanyId: json.linked_company_id || json.linkedCompanyId || null,
    };
  }

  /**
   * Convert Counterparty entity to API format
   */
  static toJson(counterparty: Counterparty): any {
    return {
      id: counterparty.counterpartyId,
      name: counterparty.counterpartyName,
      type: counterparty.type,
      isInternal: counterparty.isInternal,
      email: counterparty.email,
      phone: counterparty.phone,
      linkedCompanyId: counterparty.linkedCompanyId,
    };
  }
}

/**
 * TransactionTemplateModel - Maps between API response and TransactionTemplate entity
 */
export class TransactionTemplateModel {
  /**
   * Convert API response to TransactionTemplate entity
   */
  static fromJson(json: any): TransactionTemplate {
    return {
      templateId: json.template_id,
      name: json.name,
      description: json.template_description,
      data: json.data,
      tags: json.tags,
      visibilityLevel: json.visibility_level || 'public',
      requiredAttachment: json.required_attachment ?? false,
      counterpartyId: json.counterparty_id,
      counterpartyCashLocationId: json.counterparty_cash_location_id,
      createdAtUtc: json.created_at_utc,
    };
  }

  /**
   * Convert TransactionTemplate entity to API format
   */
  static toJson(template: TransactionTemplate): any {
    return {
      template_id: template.templateId,
      name: template.name,
      template_description: template.description,
      data: template.data,
      tags: template.tags,
      visibility_level: template.visibilityLevel,
      required_attachment: template.requiredAttachment,
      counterparty_id: template.counterpartyId,
      counterparty_cash_location_id: template.counterpartyCashLocationId,
      created_at_utc: template.createdAtUtc,
    };
  }
}
