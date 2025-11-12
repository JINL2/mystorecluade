/**
 * Dashboard Validator
 * Domain layer - Validation rules for dashboard data
 *
 * Note: Dashboard feature currently has no user input to validate.
 * This file exists for architectural consistency and future extensibility.
 * Uses centralized message constants for consistent error messages.
 */

import type { DashboardData } from '../entities/DashboardData';
import { DashboardMessages } from '../constants/DashboardMessages';

export class DashboardValidator {
  /**
   * Validate dashboard data integrity
   * Ensures all required fields are present and valid
   */
  static validateDashboardData(data: Partial<DashboardData>): {
    isValid: boolean;
    errors: string[];
  } {
    const errors: string[] = [];

    // Validate revenue values are non-negative
    if (data.todayRevenue !== undefined && data.todayRevenue < 0) {
      errors.push(DashboardMessages.errors.negativeRevenue);
    }

    if (data.todayExpense !== undefined && data.todayExpense < 0) {
      errors.push(DashboardMessages.errors.negativeExpense);
    }

    if (data.thisMonthRevenue !== undefined && data.thisMonthRevenue < 0) {
      errors.push(DashboardMessages.errors.negativeMonthRevenue);
    }

    if (data.lastMonthRevenue !== undefined && data.lastMonthRevenue < 0) {
      errors.push(DashboardMessages.errors.negativeLastMonthRevenue);
    }

    // Validate currency object
    if (data.currency) {
      if (!data.currency.symbol || data.currency.symbol.trim() === '') {
        errors.push(DashboardMessages.errors.currencySymbolRequired);
      }
      if (!data.currency.currency_code || data.currency.currency_code.trim() === '') {
        errors.push(DashboardMessages.errors.currencyCodeRequired);
      }
    }

    // Validate expense breakdown percentages
    if (data.expenseBreakdown && data.expenseBreakdown.length > 0) {
      const totalPercentage = data.expenseBreakdown.reduce(
        (sum, item) => sum + item.percentage,
        0
      );

      // Allow small rounding errors (within 0.1%)
      if (Math.abs(totalPercentage - 100) > 0.1 && totalPercentage > 0) {
        errors.push(DashboardMessages.errors.expensePercentageInvalid);
      }

      // Validate individual expense items
      data.expenseBreakdown.forEach((item, index) => {
        if (!item.category || item.category.trim() === '') {
          errors.push(DashboardMessages.technical.expenseItemCategoryRequired(index));
        }
        if (item.amount < 0) {
          errors.push(DashboardMessages.technical.expenseItemNegative(index));
        }
        if (item.percentage < 0 || item.percentage > 100) {
          errors.push(DashboardMessages.technical.expenseItemPercentageInvalid(index));
        }
      });
    }

    // Validate recent transactions
    if (data.recentTransactions && data.recentTransactions.length > 0) {
      data.recentTransactions.forEach((transaction, index) => {
        if (!transaction.id || transaction.id.trim() === '') {
          errors.push(DashboardMessages.technical.transactionIdRequired(index));
        }
        if (!transaction.date) {
          errors.push(DashboardMessages.technical.transactionDateRequired(index));
        }
        if (!transaction.description || transaction.description.trim() === '') {
          errors.push(DashboardMessages.technical.transactionDescriptionRequired(index));
        }
        if (transaction.amount < 0) {
          errors.push(DashboardMessages.technical.transactionAmountNegative(index));
        }
        if (!['income', 'expense'].includes(transaction.type)) {
          errors.push(DashboardMessages.technical.transactionTypeInvalid(index));
        }
      });
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate date string format (ISO 8601)
   */
  static validateDateFormat(dateString: string): {
    isValid: boolean;
    error?: string;
  } {
    if (!dateString || dateString.trim() === '') {
      return {
        isValid: false,
        error: DashboardMessages.errors.dateRequired,
      };
    }

    const date = new Date(dateString);
    if (isNaN(date.getTime())) {
      return {
        isValid: false,
        error: DashboardMessages.errors.invalidDateFormat,
      };
    }

    return { isValid: true };
  }

  /**
   * Validate company ID format
   */
  static validateCompanyId(companyId: string): {
    isValid: boolean;
    error?: string;
  } {
    if (!companyId || companyId.trim() === '') {
      return {
        isValid: false,
        error: DashboardMessages.errors.companyIdRequired,
      };
    }

    // UUID format validation (basic)
    const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!uuidRegex.test(companyId)) {
      return {
        isValid: false,
        error: DashboardMessages.errors.invalidCompanyIdFormat,
      };
    }

    return { isValid: true };
  }
}
