/**
 * CounterpartyModel
 * DTO and Mapper for Counterparty entity (order context)
 */

import { CounterpartyDTO } from '../datasources/CounterpartyDataSource';

/**
 * Counterparty entity for order context
 */
export interface Counterparty {
  counterparty_id: string;
  name: string;
  email?: string;
  phone?: string;
  address?: string;
  notes?: string;
}

export class CounterpartyModel {
  /**
   * Convert CounterpartyDTO to Counterparty entity
   */
  static fromJson(dto: CounterpartyDTO): Counterparty {
    return {
      counterparty_id: dto.counterparty_id,
      name: dto.name,
      email: dto.email,
      phone: dto.phone,
      address: dto.address,
      notes: dto.notes,
    };
  }

  /**
   * Batch convert multiple counterparties
   */
  static fromJsonArray(dtoArray: CounterpartyDTO[]): Counterparty[] {
    return dtoArray.map((dto) => CounterpartyModel.fromJson(dto));
  }

  /**
   * Convert Counterparty entity to DTO (for create/update operations)
   */
  static toJson(entity: Counterparty): CounterpartyDTO {
    return {
      counterparty_id: entity.counterparty_id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      address: entity.address,
      notes: entity.notes,
    };
  }
}
