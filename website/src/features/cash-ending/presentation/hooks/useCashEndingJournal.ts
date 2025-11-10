/**
 * useCashEndingJournal Hook
 * Handles journal entry creation for Make Error and Foreign Currency Translation
 */

import { useState } from 'react';
import { supabaseService } from '@/core/services/supabase_service';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

interface JournalLine {
  account_id: string;
  description: string;
  debit: number;
  credit: number;
  cash?: {
    cash_location_id: string;
  };
}

interface CreateJournalParams {
  companyId: string;
  userId: string;
  storeId: string | null;
  cashLocationId: string;
  difference: number;
  type: 'error' | 'exchange';
}

export const useCashEndingJournal = () => {
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const createJournalEntry = async (params: CreateJournalParams): Promise<boolean> => {
    const { companyId, userId, storeId, cashLocationId, difference, type } = params;

    setIsLoading(true);
    setError(null);

    try {
      const supabase = supabaseService.getClient();
      if (!supabase) {
        throw new Error('Supabase client not available');
      }

      // Get current date in RPC format (UTC)
      const now = new Date();
      const dateStr = DateTimeUtils.toRpcFormat(now);

      // Create description based on type
      const description = type === 'error'
        ? `Make Error ${dateStr}`
        : `Exchange Rate Difference ${dateStr}`;

      // Get absolute difference
      const absDifference = Math.abs(difference);

      // Fixed account IDs from backup
      const cashAccountId = 'd4a7a16e-45a1-47fe-992b-ff807c8673f0';
      const errorAccountId = 'a45fac5d-010c-4b1b-92e9-ddcf8f3222bf';
      const exchangeRateAccountId = '80b311db-f548-46e3-9854-67c5ff6766e8';

      // Select appropriate account based on type
      const offsetAccountId = type === 'error' ? errorAccountId : exchangeRateAccountId;

      // Create journal lines based on difference direction
      const lines: JournalLine[] = [];

      if (difference > 0) {
        // Positive difference: debit cash, credit offset account
        lines.push({
          account_id: cashAccountId,
          description: description,
          debit: absDifference,
          credit: 0,
          cash: {
            cash_location_id: cashLocationId
          }
        });
        lines.push({
          account_id: offsetAccountId,
          description: description,
          debit: 0,
          credit: absDifference
        });
      } else {
        // Negative difference: credit cash, debit offset account
        lines.push({
          account_id: cashAccountId,
          description: description,
          debit: 0,
          credit: absDifference,
          cash: {
            cash_location_id: cashLocationId
          }
        });
        lines.push({
          account_id: offsetAccountId,
          description: description,
          debit: absDifference,
          credit: 0
        });
      }

      // Prepare RPC parameters
      const rpcParams = {
        p_base_amount: absDifference,
        p_company_id: companyId,
        p_created_by: userId,
        p_description: description,
        p_entry_date: dateStr,
        p_lines: lines,
        p_store_id: storeId
      };

      console.log('Calling insert_journal_with_everything with params:', rpcParams);

      // Call RPC
      const { data, error: rpcError } = await supabase
        .rpc('insert_journal_with_everything', rpcParams);

      if (rpcError) {
        console.error('RPC Error:', rpcError);
        throw new Error(rpcError.message || 'Failed to create journal entry');
      }

      console.log('Journal entry created successfully:', data);
      setIsLoading(false);
      return true;

    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'Unknown error occurred';
      console.error('Error in createJournalEntry:', err);
      setError(errorMessage);
      setIsLoading(false);
      return false;
    }
  };

  return {
    createJournalEntry,
    isLoading,
    error
  };
};
