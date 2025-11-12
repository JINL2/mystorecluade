/**
 * ICounterpartyRepository Interface
 */

import { Counterparty, CounterpartyTypeValue } from '../entities/Counterparty';

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

export interface DeleteCounterpartyResult {
  success: boolean;
  error?: string;
}

export interface ICounterpartyRepository {
  getCounterparties(companyId: string): Promise<CounterpartyResult>;
  createCounterparty(
    companyId: string,
    name: string,
    type: CounterpartyTypeValue,
    isInternal: boolean,
    linkedCompanyId: string | null,
    email: string | null,
    phone: string | null,
    notes: string | null
  ): Promise<CreateCounterpartyResult>;
  deleteCounterparty(counterpartyId: string, companyId: string): Promise<DeleteCounterpartyResult>;
}
