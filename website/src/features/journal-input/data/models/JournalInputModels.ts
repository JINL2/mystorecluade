/**
 * JournalInputModels
 * DTO Models and Mappers for Journal Input feature
 * Handles conversion between API responses and Domain entities
 */

import type {
  Account,
  CashLocation,
  Counterparty,
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
 */
export class CashLocationModel {
  /**
   * Convert API response to CashLocation entity
   */
  static fromJson(json: any): CashLocation {
    return {
      locationId: json.id,
      locationName: json.name,
      locationType: json.type,
      storeId: json.storeId,
      isCompanyWide: json.isCompanyWide,
    };
  }

  /**
   * Convert CashLocation entity to API format
   */
  static toJson(location: CashLocation): any {
    return {
      id: location.locationId,
      name: location.locationName,
      type: location.locationType,
      storeId: location.storeId,
      isCompanyWide: location.isCompanyWide,
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
