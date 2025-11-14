/**
 * CounterpartyRepositoryImpl
 * Repository implementation for counterparty operations (order context)
 */

import { CounterpartyDataSource } from '../datasources/CounterpartyDataSource';
import { CounterpartyModel, Counterparty } from '../models/CounterpartyModel';

export interface CounterpartyResult {
  success: boolean;
  data?: Counterparty[];
  error?: string;
}

export class CounterpartyRepositoryImpl {
  private dataSource: CounterpartyDataSource;

  constructor() {
    this.dataSource = new CounterpartyDataSource();
  }

  /**
   * Get suppliers (counterparties) for a company
   */
  async getSuppliers(companyId: string): Promise<CounterpartyResult> {
    try {
      const rawData = await this.dataSource.getSuppliers(companyId);

      // Convert DTOs to entities
      const counterparties = CounterpartyModel.fromJsonArray(rawData);

      return {
        success: true,
        data: counterparties,
      };
    } catch (error) {
      console.error('Repository error fetching counterparties:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to fetch suppliers',
      };
    }
  }

  /**
   * Search counterparties by name
   */
  searchByName(counterparties: Counterparty[], searchTerm: string): Counterparty[] {
    if (!searchTerm || searchTerm.length < 1) {
      return counterparties;
    }

    const lowerSearchTerm = searchTerm.toLowerCase();

    return counterparties.filter((counterparty) => {
      const name = (counterparty.name || '').toLowerCase();
      return name.includes(lowerSearchTerm);
    });
  }

  /**
   * Get counterparty by ID
   */
  getById(counterparties: Counterparty[], id: string): Counterparty | null {
    return counterparties.find((c) => c.counterparty_id === id) || null;
  }
}
