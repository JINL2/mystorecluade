/**
 * JournalInputDataSource
 * Data source for journal input operations
 */

import { supabaseService } from '@/core/services/supabase_service';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

export class JournalInputDataSource {
  /**
   * Get chart of accounts
   * Note: get_accounts function doesn't require company_id parameter
   */
  async getAccounts() {
    const supabase = supabaseService.getClient();

    const { data, error } = await supabase.rpc('get_accounts');

    if (error) {
      console.error('Error fetching accounts:', error);
      throw new Error(error.message);
    }

    return data || [];
  }

  /**
   * Get cash locations for company and store
   */
  async getCashLocations(companyId: string, storeId?: string | null) {
    const supabase = supabaseService.getClient();

    const rpcParams: any = { p_company_id: companyId };
    if (storeId) {
      rpcParams.p_store_id = storeId;
    }

    const { data, error } = await supabase.rpc('get_cash_locations', rpcParams);

    if (error) {
      console.error('Error fetching cash locations:', error);
      throw new Error(error.message);
    }

    return data || [];
  }

  /**
   * Get counterparties for company
   */
  async getCounterparties(companyId: string) {
    const supabase = supabaseService.getClient();

    const { data, error } = await supabase.rpc('get_counterparties', {
      p_company_id: companyId,
    });

    if (error) {
      console.error('Error fetching counterparties:', error);
      throw new Error(error.message);
    }

    return data || [];
  }

  /**
   * Submit journal entry
   */
  async submitJournalEntry(params: {
    companyId: string;
    storeId: string | null;
    date: string;
    createdBy: string;
    description: string;
    transactionLines: Array<{
      isDebit: boolean;
      accountId: string;
      amount: number;
      description: string;
      cashLocationId?: string | null;
      counterpartyId?: string | null;
      counterpartyStoreId?: string | null;
      debtCategory?: string | null;
    }>;
  }) {
    const supabase = supabaseService.getClient();

    // Calculate total amount (debits should equal credits)
    const totalAmount = params.transactionLines
      .filter(line => line.isDebit)
      .reduce((sum, line) => sum + line.amount, 0);

    // Transform transaction lines to the format expected by insert_journal_with_everything
    const lines = params.transactionLines.map(line => {
      const transformedLine: any = {
        account_id: line.accountId,
        description: line.description,
      };

      // Add debit or credit
      if (line.isDebit) {
        transformedLine.debit = line.amount;
      } else {
        transformedLine.credit = line.amount;
      }

      // Add cash location if present
      if (line.cashLocationId) {
        transformedLine.cash = {
          cash_location_id: line.cashLocationId,
        };
      }

      // Add debt information if counterparty is present
      if (line.counterpartyId) {
        transformedLine.debt = {
          counterparty_id: line.counterpartyId,
          direction: line.isDebit ? 'receivable' : 'payable',
          category: line.debtCategory || 'trade',
          linkedCounterparty_store_id: line.counterpartyStoreId,
        };
      }

      return transformedLine;
    });

    // Convert date string (yyyy-MM-dd) to Date object at start of day in local timezone
    // then convert to UTC for database storage
    const entryDate = new Date(params.date + 'T00:00:00');
    const utcEntryDate = DateTimeUtils.toRpcFormat(entryDate);

    const { data, error } = await supabase.rpc('insert_journal_with_everything', {
      p_base_amount: totalAmount,
      p_company_id: params.companyId,
      p_created_by: params.createdBy,
      p_description: params.description,
      p_entry_date: utcEntryDate,
      p_lines: lines,
      p_store_id: params.storeId,
    });

    if (error) {
      console.error('Error submitting journal entry:', error);
      throw new Error(error.message);
    }

    return { journal_id: data };
  }
}
