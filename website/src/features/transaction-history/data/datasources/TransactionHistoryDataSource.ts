/**
 * TransactionHistoryDataSource
 * Data source for transaction history operations
 */

import { supabaseService } from '@/core/services/supabase_service';

export interface TransactionHistoryParams {
  companyId: string;
  storeId?: string | null;
  startDate?: string | null;
  endDate?: string | null;
  accountId?: string | null;
  accountIds?: string | null; // comma-separated UUIDs
  journalType?: string | null;
  counterpartyId?: string | null;
  createdBy?: string | null;
  cashLocationId?: string | null;
  limit?: number;
  offset?: number;
}

export interface EmployeeInfo {
  userId: string;
  fullName: string;
}

export class TransactionHistoryDataSource {
  async getTransactions(
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string,
    accountId?: string | null
  ) {
    return this.getTransactionsUtc({
      companyId,
      storeId,
      startDate: startDate || null,
      endDate: endDate || null,
      accountId,
    });
  }

  async getTransactionsUtc(params: TransactionHistoryParams) {
    const supabase = supabaseService.getClient();

    const rpcParams: Record<string, any> = {
      p_company_id: params.companyId,
      p_store_id: params.storeId ?? null,
      p_date_from: params.startDate ?? null,
      p_date_to: params.endDate ?? null,
      p_account_id: params.accountId ?? null,
      p_account_ids: params.accountIds ?? null,
      p_journal_type: params.journalType ?? null,
      p_counterparty_id: params.counterpartyId ?? null,
      p_created_by: params.createdBy ?? null,
      p_cash_location_id: params.cashLocationId ?? null,
      p_limit: params.limit ?? 100,
      p_offset: params.offset ?? 0,
    };

    const { data, error } = await supabase.rpc('get_transaction_history_utc', rpcParams);

    if (error) {
      console.error('Error fetching transaction history:', error);
      throw new Error(error.message);
    }

    return data || [];
  }

  async getEmployees(companyId: string): Promise<EmployeeInfo[]> {
    const supabase = supabaseService.getClient();

    const { data, error } = await supabase.rpc('get_employee_info', {
      p_company_id: companyId,
    });

    if (error) {
      console.error('Error fetching employee info:', error);
      throw new Error(error.message);
    }

    // Map to simplified EmployeeInfo structure
    return (data || []).map((emp: any) => ({
      userId: emp.user_id,
      fullName: emp.full_name,
    }));
  }
}
