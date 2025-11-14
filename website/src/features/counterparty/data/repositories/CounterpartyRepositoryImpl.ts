/**
 * CounterpartyRepositoryImpl
 */

import {
  ICounterpartyRepository,
  CounterpartyResult,
  CreateCounterpartyResult,
  DeleteCounterpartyResult,
} from '../../domain/repositories/ICounterpartyRepository';
import { CounterpartyTypeValue } from '../../domain/entities/Counterparty';
import { CounterpartyDataSource } from '../datasources/CounterpartyDataSource';
import { CounterpartyModel } from '../models/CounterpartyModel';

export class CounterpartyRepositoryImpl implements ICounterpartyRepository {
  private dataSource = new CounterpartyDataSource();

  async getCounterparties(companyId: string): Promise<CounterpartyResult> {
    try {
      const data = await this.dataSource.getCounterparties(companyId);
      const counterparties = data.map((item: any) =>
        CounterpartyModel.fromDatabaseToEntity(item)
      );
      return { success: true, data: counterparties };
    } catch (error) {
      return { success: false, error: error instanceof Error ? error.message : 'Failed to fetch' };
    }
  }

  async createCounterparty(
    companyId: string,
    name: string,
    type: CounterpartyTypeValue,
    isInternal: boolean,
    linkedCompanyId: string | null,
    email: string | null,
    phone: string | null,
    notes: string | null
  ): Promise<CreateCounterpartyResult> {
    try {
      const data = await this.dataSource.createCounterparty(
        companyId,
        name,
        type,
        isInternal,
        linkedCompanyId,
        email,
        phone,
        notes
      );
      const counterparty = CounterpartyModel.fromDatabaseToEntity(data);
      return { success: true, data: counterparty };
    } catch (error) {
      return { success: false, error: error instanceof Error ? error.message : 'Failed to create' };
    }
  }

  async deleteCounterparty(counterpartyId: string, companyId: string): Promise<DeleteCounterpartyResult> {
    try {
      await this.dataSource.deleteCounterparty(counterpartyId, companyId);
      return { success: true };
    } catch (error) {
      return { success: false, error: error instanceof Error ? error.message : 'Failed to delete' };
    }
  }
}
