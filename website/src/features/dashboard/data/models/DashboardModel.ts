/**
 * Dashboard Model
 * Data layer - DTO mapper for dashboard data
 */

import { DashboardData } from '../../domain/entities/DashboardData';
import type { DashboardRawData } from '../datasources/DashboardDataSource';

export class DashboardModel {
  /**
   * Convert raw Supabase data to domain entity
   */
  static fromSupabase(rawData: DashboardRawData): DashboardData {
    return DashboardData.create({
      today_revenue: rawData.today_revenue || 0,
      today_expense: rawData.today_expense || 0,
      this_month_revenue: rawData.this_month_revenue || 0,
      last_month_revenue: rawData.last_month_revenue || 0,
      currency: rawData.currency || { symbol: '$', currency_code: 'USD' },
      expense_breakdown: rawData.expense_breakdown || [],
      recent_transactions: rawData.recent_transactions || [],
    });
  }
}
