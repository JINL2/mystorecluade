/**
 * CounterpartyModel - DTO and Mapper
 * Handles conversion between database schema and domain entities
 */

import { Counterparty, CounterpartyTypeValue } from '../../domain/entities/Counterparty';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

/**
 * DTO - Data Transfer Object
 * Represents the shape of data after database mapping
 */
export interface CounterpartyDTO {
  counterpartyId: string;
  companyId: string;
  name: string;
  type: CounterpartyTypeValue;
  isInternal: boolean;
  linkedCompanyId: string | null;
  email: string | null;
  phone: string | null;
  notes: string | null;
  isDeleted: boolean;
  createdAt: Date;
}

/**
 * CounterpartyModel - Mapper class
 * Converts between database raw data and domain entities
 */
export class CounterpartyModel {
  /**
   * Convert raw database data to DTO
   * Handles snake_case to camelCase conversion and date parsing
   */
  static fromDatabase(data: any): CounterpartyDTO {
    return {
      counterpartyId: data.counterparty_id,
      companyId: data.company_id,
      name: data.name,
      type: data.type,
      isInternal: data.is_internal,
      linkedCompanyId: data.linked_company_id,
      email: data.email,
      phone: data.phone,
      notes: data.notes,
      isDeleted: data.is_deleted,
      createdAt: DateTimeUtils.toLocal(data.created_at),
    };
  }

  /**
   * Convert DTO to Domain Entity
   */
  static toEntity(dto: CounterpartyDTO): Counterparty {
    return new Counterparty(
      dto.counterpartyId,
      dto.companyId,
      dto.name,
      dto.type,
      dto.isInternal,
      dto.linkedCompanyId,
      dto.email,
      dto.phone,
      dto.notes,
      dto.isDeleted,
      dto.createdAt
    );
  }

  /**
   * Convert raw database data directly to Domain Entity
   * Convenience method that combines fromDatabase and toEntity
   */
  static fromDatabaseToEntity(data: any): Counterparty {
    const dto = this.fromDatabase(data);
    return this.toEntity(dto);
  }

  /**
   * Convert Domain Entity to database format
   * Used for updates and inserts
   */
  static toDatabase(counterparty: Counterparty): any {
    return {
      counterparty_id: counterparty.counterpartyId,
      company_id: counterparty.companyId,
      name: counterparty.name,
      type: counterparty.type,
      is_internal: counterparty.isInternal,
      linked_company_id: counterparty.linkedCompanyId,
      email: counterparty.email,
      phone: counterparty.phone,
      notes: counterparty.notes,
      is_deleted: counterparty.isDeleted,
      created_at: DateTimeUtils.toUtc(counterparty.createdAt),
    };
  }
}
