/**
 * Dashboard Model
 * Data layer - DTO mapper for dashboard data
 */

import { DashboardData } from '../../domain/entities/DashboardData';
import type { DashboardRawData } from '../datasources/DashboardDataSource';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

export class DashboardModel {
  /**
   * Convert raw Supabase data to domain entity
   * Converts UTC timestamps from DB to local time for display
   */
  static fromSupabase(rawData: DashboardRawData): DashboardData {
    // Transform journal entries to transaction format
    const transactions = (rawData.recent_transactions || []).map(journal => {
      // Determine transaction type based on account types in lines
      const hasIncomeAccount = journal.lines?.some(line => line.account_type === 'income');
      const hasExpenseAccount = journal.lines?.some(line => line.account_type === 'expense');

      // Use created_at for time display (UTC timestamp with time info)
      // If created_at is not available, fallback to entry_date
      const dateToUse = journal.created_at || journal.entry_date;

      return {
        id: journal.journal_id,
        date: DateTimeUtils.toLocal(dateToUse).toISOString(),
        description: journal.description || 'No description',
        amount: journal.total_amount || 0,
        type: (hasIncomeAccount ? 'income' : hasExpenseAccount ? 'expense' : 'income') as 'income' | 'expense',
      };
    });

    return DashboardData.create({
      today_revenue: rawData.today_revenue || 0,
      today_expense: rawData.today_expense || 0,
      this_month_revenue: rawData.this_month_revenue || 0,
      last_month_revenue: rawData.last_month_revenue || 0,
      currency: {
        symbol: rawData.currency?.symbol || '$',
        currency_code: rawData.currency?.currency_code || 'USD',
      },
      expense_breakdown: rawData.expense_breakdown || [],
      recent_transactions: transactions,
    });
  }
}
