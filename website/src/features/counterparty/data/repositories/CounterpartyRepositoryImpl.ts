/**
 * CounterpartyRepositoryImpl
 */

import {
  ICounterpartyRepository,
  CounterpartyResult,
  CreateCounterpartyResult,
  UpdateCounterpartyResult,
  DeleteCounterpartyResult,
} from '../../domain/repositories/ICounterpartyRepository';
import { Counterparty, CounterpartyType } from '../../domain/entities/Counterparty';
import { CounterpartyDataSource } from '../datasources/CounterpartyDataSource';

export class CounterpartyRepositoryImpl implements ICounterpartyRepository {
  private dataSource = new CounterpartyDataSource();

  async getCounterparties(companyId: string): Promise<CounterpartyResult> {
    try {
      const data = await this.dataSource.getCounterparties(companyId);
      const counterparties = data.map(
        (item: any) =>
          new Counterparty(
            item.counterparty_id,
            item.company_id,
            item.name,
            item.type,
            item.contact,
            item.email,
            item.phone,
            item.address,
            item.is_active,
            new Date(item.created_at)
          )
      );
      return { success: true, data: counterparties };
    } catch (error) {
      return { success: false, error: error instanceof Error ? error.message : 'Failed to fetch' };
    }
  }

  async createCounterparty(
    companyId: string,
    name: string,
    type: CounterpartyType,
    contact: string | null,
    email: string | null,
    phone: string | null,
    address: string | null
  ): Promise<CreateCounterpartyResult> {
    try {
      const data = await this.dataSource.createCounterparty(companyId, name, type, contact, email, phone, address);
      const counterparty = new Counterparty(
        data.counterparty_id,
        data.company_id,
        data.name,
        data.type,
        data.contact,
        data.email,
        data.phone,
        data.address,
        data.is_active,
        new Date(data.created_at)
      );
      return { success: true, data: counterparty };
    } catch (error) {
      return { success: false, error: error instanceof Error ? error.message : 'Failed to create' };
    }
  }

  async updateCounterparty(
    counterpartyId: string,
    name: string,
    contact: string | null,
    email: string | null,
    phone: string | null,
    address: string | null
  ): Promise<UpdateCounterpartyResult> {
    try {
      await this.dataSource.updateCounterparty(counterpartyId, name, contact, email, phone, address);
      return { success: true };
    } catch (error) {
      return { success: false, error: error instanceof Error ? error.message : 'Failed to update' };
    }
  }

  async deleteCounterparty(counterpartyId: string): Promise<DeleteCounterpartyResult> {
    try {
      await this.dataSource.deleteCounterparty(counterpartyId);
      return { success: true };
    } catch (error) {
      return { success: false, error: error instanceof Error ? error.message : 'Failed to delete' };
    }
  }
}
