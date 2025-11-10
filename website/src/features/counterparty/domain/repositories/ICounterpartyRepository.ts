/**
 * ICounterpartyRepository Interface
 */

import { Counterparty, CounterpartyType } from '../entities/Counterparty';

export interface CounterpartyResult {
  success: boolean;
  data?: Counterparty[];
  error?: string;
}

export interface CreateCounterpartyResult {
  success: boolean;
  data?: Counterparty;
  error?: string;
}

export interface UpdateCounterpartyResult {
  success: boolean;
  error?: string;
}

export interface DeleteCounterpartyResult {
  success: boolean;
  error?: string;
}

export interface ICounterpartyRepository {
  getCounterparties(companyId: string): Promise<CounterpartyResult>;
  createCounterparty(
    companyId: string,
    name: string,
    type: CounterpartyType,
    contact: string | null,
    email: string | null,
    phone: string | null,
    address: string | null
  ): Promise<CreateCounterpartyResult>;
  updateCounterparty(
    counterpartyId: string,
    name: string,
    contact: string | null,
    email: string | null,
    phone: string | null,
    address: string | null
  ): Promise<UpdateCounterpartyResult>;
  deleteCounterparty(counterpartyId: string): Promise<DeleteCounterpartyResult>;
}
