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

    const { data, error } = await supabase
      .from('counterparties')
      .select('counterparty_id, name, type, is_internal, linked_company_id, email, phone')
      .eq('company_id', companyId)
      .order('name');

    if (error) {
      console.error('Error fetching counterparties:', error);
      throw new Error(error.message);
    }

    return data || [];
  }

  /**
   * Check account mapping for internal transactions
   * Used to validate that internal counterparty has proper account mapping
   */
  async checkAccountMapping(params: {
    companyId: string;
    counterpartyId: string;
    accountId: string;
  }) {
    const supabase = supabaseService.getClient();

    const { data, error } = await supabase
      .from('account_mappings')
      .select('my_account_id, linked_account_id, direction')
      .eq('my_company_id', params.companyId)
      .eq('counterparty_id', params.counterpartyId)
      .eq('my_account_id', params.accountId)
      .maybeSingle();

    if (error) {
      console.error('Error checking account mapping:', error);
      return null;
    }

    return data;
  }

  /**
   * Get stores for a counterparty's linked company
   * Used when counterparty is internal and has linkedCompanyId
   */
  async getCounterpartyStores(linkedCompanyId: string) {
    const supabase = supabaseService.getClient();

    const { data, error } = await supabase
      .from('stores')
      .select('store_id, store_name')
      .eq('company_id', linkedCompanyId)
      .order('store_name');

    if (error) {
      console.error('Error fetching counterparty stores:', error);
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
    date: string | Date;
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
      // New debt fields for P_LINES_ALIGNMENT_SUMMARY.md
      interestRate?: number | null;
      interestAccountId?: string | null;
      interestDueDay?: number | null;
      issueDate?: string | null;
      dueDate?: string | null;
      debtDescription?: string | null;
      linkedCompanyId?: string | null;
      counterpartyCashLocationId?: string | null;
    }>;
  }) {
    const supabase = supabaseService.getClient();

    // Calculate total amount (debits should equal credits)
    const totalAmount = params.transactionLines
      .filter(line => line.isDebit)
      .reduce((sum, line) => sum + line.amount, 0);

    // Transform transaction lines to the format expected by insert_journal_with_everything
    // Following P_LINES_ALIGNMENT_SUMMARY.md specification
    const lines = params.transactionLines.map(line => {
      const transformedLine: any = {
        account_id: line.accountId,
        description: line.description,
        // Always send both debit and credit as strings (one will be '0')
        debit: line.isDebit ? line.amount.toString() : '0',
        credit: !line.isDebit ? line.amount.toString() : '0',
      };

      // Add cash object if cash location is present
      if (line.cashLocationId) {
        transformedLine.cash = {
          cash_location_id: line.cashLocationId,
        };
      }

      // Add debt object if counterparty is present
      // Must include all required fields per P_LINES_ALIGNMENT_SUMMARY.md
      if (line.counterpartyId) {
        const now = new Date();
        const issueDate = line.issueDate ? new Date(line.issueDate) : now;
        const dueDate = line.dueDate ? new Date(line.dueDate) : new Date(now.getTime() + 30 * 24 * 60 * 60 * 1000); // +30 days

        transformedLine.debt = {
          counterparty_id: line.counterpartyId,
          direction: line.isDebit ? 'receivable' : 'payable',
          category: line.debtCategory || 'other',
          original_amount: line.amount.toString(),
          interest_rate: (line.interestRate || 0).toString(),
          interest_account_id: line.interestAccountId || '',
          interest_due_day: line.interestDueDay || 0,
          issue_date: issueDate.toISOString().split('T')[0],
          due_date: dueDate.toISOString().split('T')[0],
          description: line.debtDescription || '',
          linkedCounterparty_store_id: line.counterpartyStoreId || '',
          linkedCounterparty_companyId: line.linkedCompanyId || '',
        };
      }

      return transformedLine;
    });

    // Convert date (string or Date) to UTC RPC format
    // Use DateTimeUtils.toRpcFormat() for consistent timezone handling
    let dateWithTime: Date;

    if (params.date instanceof Date) {
      // Already a Date object with time components
      dateWithTime = params.date;
    } else {
      // Convert date string (yyyy-MM-dd) to Date with current time
      const now = new Date();
      const [year, month, day] = params.date.split('-').map(Number);
      dateWithTime = new Date(year, month - 1, day, now.getHours(), now.getMinutes(), now.getSeconds());
    }

    const utcEntryDate = DateTimeUtils.toRpcFormat(dateWithTime);

    // Extract main counterparty_id (first counterparty found in transaction lines)
    // Used for linking journal entry to primary counterparty
    const mainCounterpartyId = params.transactionLines.find(line => line.counterpartyId)?.counterpartyId || null;

    // Extract counterparty's cash_location_id for mirror journal creation
    // Used for creating mirror journal in linked company
    // Only relevant when counterparty has linkedCompanyId
    // IMPORTANT: Use counterpartyCashLocationId (NOT cashLocationId)
    const counterpartyWithLinkedCompany = params.transactionLines.find(
      line => line.counterpartyId && line.linkedCompanyId
    );
    const counterpartyStoreCashLocationId = counterpartyWithLinkedCompany?.counterpartyCashLocationId || null;

    const { data, error } = await supabase.rpc('insert_journal_with_everything', {
      p_base_amount: totalAmount,
      p_company_id: params.companyId,
      p_created_by: params.createdBy,
      p_description: params.description,
      p_entry_date: utcEntryDate,
      p_lines: lines,
      p_store_id: params.storeId,
      p_counterparty_id: mainCounterpartyId,
      p_if_cash_location_id: counterpartyStoreCashLocationId,
    });

    if (error) {
      console.error('Error submitting journal entry:', error);
      throw new Error(error.message);
    }

    return { journal_id: data };
  }
}
