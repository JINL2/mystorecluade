/**
 * CashEndingDataSource
 * Handles all Supabase RPC calls for cash ending operations
 */

import { supabaseService } from '@/core/services/supabase_service';
import type { CashLocation } from '../../domain/entities/CashLocation';
import type { CurrencyWithExchangeRate } from '../../domain/entities/Currency';
import type { BalanceSummaryData } from '../../domain/entities/BalanceSummary';

// Account IDs for journal entries
export const ACCOUNT_IDS = {
  cash: 'd4a7a16e-45a1-47fe-992b-ff807c8673f0',
  errorAdjustment: 'a45fac5d-010c-4b1b-92e9-ddcf8f3222bf',
  foreignCurrencyTranslation: '80b311db-f548-46e3-9854-67c5ff6766e8',
} as const;

export interface SubmitCashEndingParams {
  companyId: string;
  storeId: string;
  locationId: string;
  entryType: string;
  currencies: CurrencyPayload[];
  recordDate: string;
  createdBy: string;
  description: string;
  vaultTransactionType: 'in' | 'out' | 'recount' | null;
}

export interface CurrencyPayload {
  currency_id: string;
  total_amount?: number;
  denominations?: { denomination_id: string; quantity: number }[];
}

export interface JournalLine {
  account_id: string;
  description: string;
  debit: number;
  credit: number;
  cash?: { cash_location_id: string };
}

export interface InsertJournalParams {
  baseAmount: number;
  companyId: string;
  createdBy: string;
  description: string;
  entryDateUtc: string;
  lines: JournalLine[];
  storeId: string;
}

export class CashEndingDataSource {
  /**
   * Get cash locations for a store
   */
  async getCashLocations(companyId: string, storeId: string): Promise<CashLocation[]> {
    const data = await supabaseService.rpc<CashLocation[]>('get_cash_locations_v2', {
      p_company_id: companyId,
      p_store_id: storeId,
    });
    return data || [];
  }

  /**
   * Get currencies with exchange rates
   */
  async getCurrencies(companyId: string, rateDate: string): Promise<CurrencyWithExchangeRate[]> {
    const data = await supabaseService.rpc<CurrencyWithExchangeRate[]>(
      'get_company_currencies_with_exchange_rates',
      {
        p_company_id: companyId,
        p_rate_date: rateDate,
      }
    );
    return data || [];
  }

  /**
   * Get balance summary for a location
   */
  async getBalanceSummary(locationId: string): Promise<BalanceSummaryData | null> {
    const data = await supabaseService.rpc<BalanceSummaryData>(
      'get_cash_location_balance_summary_v2_utc',
      { p_location_id: locationId }
    );
    return data && data.success ? data : null;
  }

  /**
   * Submit cash ending entry
   */
  async submitCashEnding(params: SubmitCashEndingParams): Promise<unknown> {
    return await supabaseService.rpc('insert_amount_multi_currency', {
      p_company_id: params.companyId,
      p_store_id: params.storeId,
      p_location_id: params.locationId,
      p_entry_type: params.entryType,
      p_currencies: params.currencies,
      p_record_date: params.recordDate,
      p_created_by: params.createdBy,
      p_description: params.description,
      p_vault_transaction_type: params.vaultTransactionType,
    });
  }

  /**
   * Insert journal entry for adjustment
   */
  async insertJournal(params: InsertJournalParams): Promise<unknown> {
    return await supabaseService.rpc('insert_journal_with_everything_utc', {
      p_base_amount: params.baseAmount,
      p_company_id: params.companyId,
      p_created_by: params.createdBy,
      p_description: params.description,
      p_entry_date_utc: params.entryDateUtc,
      p_lines: params.lines,
      p_counterparty_id: null,
      p_if_cash_location_id: null,
      p_store_id: params.storeId,
    });
  }
}

export const cashEndingDataSource = new CashEndingDataSource();
