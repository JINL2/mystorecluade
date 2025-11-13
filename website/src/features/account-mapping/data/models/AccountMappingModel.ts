/**
 * AccountMappingModel
 * DTO (Data Transfer Object) + Mapper for AccountMapping
 *
 * Following Clean Architecture:
 * - Transforms data between DB format (snake_case) and Domain format (camelCase)
 * - Handles data serialization/deserialization
 * - Converts UTC timestamps from DB to local time for display
 * - Converts local time to UTC when saving to DB
 */

import { AccountMapping } from '../../domain/entities/AccountMapping';
import type { MappingDirection } from '../../domain/entities/AccountMapping';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

/**
 * Database row structure from Supabase RPC
 */
export interface AccountMappingDTO {
  mapping_id: string;
  my_company_id: string;
  my_account_name: string;
  my_account_code: string | null;
  my_category_tag: string;
  linked_company_id: string;
  linked_company_name: string;
  linked_account_name: string;
  linked_account_code: string | null;
  linked_category_tag: string;
  direction?: string;
  created_at: string;
}

/**
 * RPC response structure from get_account_mapping_page
 */
export interface AccountMappingRPCResponse {
  accounts?: any[];
  account_mappings?: AccountMappingDTO[];
  reverse_account_mappings?: AccountMappingDTO[];
}

export class AccountMappingModel {
  /**
   * Convert from database format (snake_case) to domain entity (camelCase)
   *
   * DB에서 받은 UTC 시간을 로컬 시간으로 변환합니다.
   */
  static fromJson(json: AccountMappingDTO, isReadOnly: boolean = false): AccountMapping {
    // Use toLocalSafe to handle null/undefined created_at
    const createdAt = DateTimeUtils.toLocalSafe(json.created_at) || new Date();

    return new AccountMapping(
      json.mapping_id,
      json.my_company_id,
      json.my_account_name,
      json.my_account_code || null,
      json.my_category_tag,
      json.linked_company_id,
      json.linked_company_name,
      json.linked_account_name,
      json.linked_account_code || null,
      json.linked_category_tag,
      (json.direction as MappingDirection) || 'outgoing',
      createdAt, // UTC → Local 변환 (null-safe)
      isReadOnly
    );
  }

  /**
   * Convert from domain entity to database format (for insert/update)
   *
   * 로컬 시간을 UTC로 변환하여 DB에 저장합니다.
   */
  static toJson(mapping: AccountMapping): AccountMappingDTO {
    return {
      mapping_id: mapping.mappingId,
      my_company_id: mapping.myCompanyId,
      my_account_name: mapping.myAccountName,
      my_account_code: mapping.myAccountCode,
      my_category_tag: mapping.myCategoryTag,
      linked_company_id: mapping.linkedCompanyId,
      linked_company_name: mapping.linkedCompanyName,
      linked_account_name: mapping.linkedAccountName,
      linked_account_code: mapping.linkedAccountCode,
      linked_category_tag: mapping.linkedCategoryTag,
      direction: mapping.direction,
      created_at: DateTimeUtils.toUtc(mapping.createdAt), // Local → UTC 변환
    };
  }

  /**
   * Convert array of DTOs to domain entities
   */
  static fromJsonArray(jsonArray: AccountMappingDTO[], isReadOnly: boolean = false): AccountMapping[] {
    return jsonArray.map((json) => this.fromJson(json, isReadOnly));
  }

  /**
   * Convert array of domain entities to DTOs
   */
  static toJsonArray(mappings: AccountMapping[]): AccountMappingDTO[] {
    return mappings.map((mapping) => this.toJson(mapping));
  }

  /**
   * Parse RPC response and extract account mappings
   */
  static parseRPCResponse(response: AccountMappingRPCResponse): {
    outgoingMappings: AccountMapping[];
    incomingMappings: AccountMapping[];
    allMappings: AccountMapping[];
  } {
    const accountMappings = response.account_mappings || [];
    const reverseAccountMappings = response.reverse_account_mappings || [];

    // Outgoing mappings (editable)
    const outgoingMappings = this.fromJsonArray(accountMappings, false);

    // Incoming mappings (read-only)
    const incomingMappings = this.fromJsonArray(reverseAccountMappings, true);

    // Combined
    const allMappings = [...outgoingMappings, ...incomingMappings];

    return {
      outgoingMappings,
      incomingMappings,
      allMappings,
    };
  }

  /**
   * Extract accounts from RPC response
   */
  static extractAccounts(response: AccountMappingRPCResponse): any[] {
    return response.accounts || [];
  }

  /**
   * Validate DTO structure (for type safety at runtime)
   */
  static isValidDTO(json: any): json is AccountMappingDTO {
    return (
      typeof json === 'object' &&
      json !== null &&
      typeof json.mapping_id === 'string' &&
      typeof json.my_company_id === 'string' &&
      typeof json.my_account_name === 'string' &&
      typeof json.linked_company_id === 'string' &&
      typeof json.linked_company_name === 'string' &&
      typeof json.linked_account_name === 'string' &&
      typeof json.created_at === 'string'
    );
  }
}
