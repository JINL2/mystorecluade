/**
 * Income Statement Model
 * Data layer - DTO (Data Transfer Object) + Mapper
 *
 * Converts RPC responses to Domain Entities
 * Following ARCHITECTURE.md pattern: models handle data transformation
 */

import type {
  MonthlyIncomeStatementData,
  TwelveMonthIncomeStatementData,
  IncomeStatementSection,
  IncomeStatementSubcategory,
  IncomeStatementAccount,
} from '../../domain/entities/IncomeStatementData';

export class IncomeStatementModel {
  /**
   * Convert RPC response to Monthly Income Statement Domain Entity
   * Handles data transformation from database format to domain format
   *
   * @param rpcData - Raw data from get_income_statement_v2 RPC
   * @returns MonthlyIncomeStatementData domain entity
   */
  static fromMonthlyRpcResponse(rpcData: any): MonthlyIncomeStatementData {
    // Validate RPC response format
    if (!Array.isArray(rpcData)) {
      console.error('❌ [Model] Invalid RPC response format: expected array, got', typeof rpcData);
      throw new Error('Invalid monthly income statement data format');
    }

    if (rpcData.length === 0) {
      console.warn('⚠️ [Model] Empty RPC response received');
      return [];
    }

    try {
      const mappedData = rpcData.map((section: any, index: number): IncomeStatementSection => {
        // Validate section structure
        if (!section || typeof section !== 'object') {
          console.warn(`⚠️ [Model] Invalid section at index ${index}:`, section);
          return {
            section: 'Unknown Section',
            section_total: 0,
            subcategories: [],
          };
        }

        return {
          section: section.section || `Unknown Section ${index + 1}`,
          section_total: this.parseNumber(section.section_total, 0),
          subcategories: this.mapSubcategories(section.subcategories || []),
        };
      });

      console.log('✅ [Model] Successfully mapped monthly income statement data');
      return mappedData;
    } catch (error) {
      console.error('❌ [Model] Error mapping monthly RPC response:', error);
      throw new Error('Failed to map monthly income statement data');
    }
  }

  /**
   * Convert RPC response to 12-Month Income Statement Domain Entity
   * Handles data transformation from database format to domain format
   *
   * @param rpcData - Raw data from get_income_statement_monthly RPC
   * @returns TwelveMonthIncomeStatementData domain entity
   */
  static from12MonthRpcResponse(rpcData: any): TwelveMonthIncomeStatementData {
    // Validate RPC response structure
    if (!rpcData || typeof rpcData !== 'object') {
      console.error('❌ [Model] Invalid 12-month RPC response format:', typeof rpcData);
      throw new Error('Invalid 12-month income statement data format');
    }

    if (!rpcData.sections || !Array.isArray(rpcData.sections)) {
      console.error('❌ [Model] Missing or invalid sections in 12-month data');
      throw new Error('Invalid 12-month income statement data: missing sections');
    }

    if (!rpcData.months || !Array.isArray(rpcData.months)) {
      console.error('❌ [Model] Missing or invalid months in 12-month data');
      throw new Error('Invalid 12-month income statement data: missing months');
    }

    try {
      const mappedData: TwelveMonthIncomeStatementData = {
        summary: {
          period_info: {
            // v2 uses start_time/end_time instead of start_date/end_date
            start_date: rpcData.summary?.period_info?.start_time || rpcData.summary?.period_info?.start_date || '',
            end_date: rpcData.summary?.period_info?.end_time || rpcData.summary?.period_info?.end_date || '',
            store_scope: rpcData.summary?.period_info?.store_scope || 'all_stores',
            timezone: rpcData.summary?.period_info?.timezone || '',
          },
        },
        months: rpcData.months,
        sections: rpcData.sections.map((section: any, index: number): IncomeStatementSection => {
          if (!section || typeof section !== 'object') {
            console.warn(`⚠️ [Model] Invalid section at index ${index}:`, section);
            return {
              section: 'Unknown Section',
              section_total: 0,
              section_monthly_totals: {},
              subcategories: [],
            };
          }

          return {
            section: section.section || `Unknown Section ${index + 1}`,
            section_total: this.parseNumber(section.section_total, 0),
            section_monthly_totals: section.section_monthly_totals || {},
            subcategories: this.mapSubcategories(section.subcategories || []),
          };
        }),
      };

      console.log('✅ [Model] Successfully mapped 12-month income statement data');
      return mappedData;
    } catch (error) {
      console.error('❌ [Model] Error mapping 12-month RPC response:', error);
      throw new Error('Failed to map 12-month income statement data');
    }
  }

  /**
   * Map subcategories from RPC response
   * Private helper method for mapping subcategory data
   *
   * @param subcategories - Raw subcategories data
   * @returns Mapped IncomeStatementSubcategory array
   */
  private static mapSubcategories(subcategories: any[]): IncomeStatementSubcategory[] {
    if (!Array.isArray(subcategories)) {
      console.warn('⚠️ [Model] Invalid subcategories format, expected array');
      return [];
    }

    return subcategories.map((sub: any, index: number): IncomeStatementSubcategory => {
      if (!sub || typeof sub !== 'object') {
        console.warn(`⚠️ [Model] Invalid subcategory at index ${index}:`, sub);
        return {
          subcategory: '',
          subcategory_total: 0,
          accounts: [],
        };
      }

      return {
        subcategory: sub.subcategory || '',
        subcategory_total: this.parseNumber(sub.subcategory_total, 0),
        subcategory_monthly_totals: sub.subcategory_monthly_totals || {},
        accounts: this.mapAccounts(sub.accounts || []),
      };
    });
  }

  /**
   * Map accounts from RPC response
   * Private helper method for mapping account data
   *
   * @param accounts - Raw accounts data
   * @returns Mapped IncomeStatementAccount array
   */
  private static mapAccounts(accounts: any[]): IncomeStatementAccount[] {
    if (!Array.isArray(accounts)) {
      console.warn('⚠️ [Model] Invalid accounts format, expected array');
      return [];
    }

    return accounts.map((acc: any, index: number): IncomeStatementAccount => {
      if (!acc || typeof acc !== 'object') {
        console.warn(`⚠️ [Model] Invalid account at index ${index}:`, acc);
        return {
          account_name: 'Unknown Account',
          net_amount: 0,
        };
      }

      return {
        account_name: acc.account_name || `Unknown Account ${index + 1}`,
        net_amount: this.parseNumber(acc.net_amount, 0),
        monthly_amounts: acc.monthly_amounts || {},
        total: this.parseNumber(acc.total, this.parseNumber(acc.net_amount, 0)),
      };
    });
  }

  /**
   * Safely parse number values
   * Handles null, undefined, and invalid number values
   *
   * @param value - Value to parse
   * @param defaultValue - Default value if parsing fails
   * @returns Parsed number or default value
   */
  private static parseNumber(value: any, defaultValue: number = 0): number {
    if (value === null || value === undefined) {
      return defaultValue;
    }

    if (typeof value === 'number') {
      return isNaN(value) ? defaultValue : value;
    }

    if (typeof value === 'string') {
      const parsed = parseFloat(value);
      return isNaN(parsed) ? defaultValue : parsed;
    }

    return defaultValue;
  }

  /**
   * Validate mapped data structure (for debugging/testing)
   * Performs basic validation on mapped domain entities
   *
   * @param data - Mapped domain entity
   * @param type - Type of data ('monthly' or '12month')
   * @returns true if valid, false otherwise
   */
  static validateMappedData(data: MonthlyIncomeStatementData | TwelveMonthIncomeStatementData, type: 'monthly' | '12month'): boolean {
    if (!data) {
      console.error('❌ [Model] Validation failed: data is null or undefined');
      return false;
    }

    if (type === 'monthly') {
      const monthlyData = data as MonthlyIncomeStatementData;
      if (!Array.isArray(monthlyData)) {
        console.error('❌ [Model] Validation failed: monthly data is not an array');
        return false;
      }
      console.log('✅ [Model] Monthly data validation passed');
      return true;
    } else {
      const twelveMonthData = data as TwelveMonthIncomeStatementData;
      if (!twelveMonthData.sections || !Array.isArray(twelveMonthData.sections)) {
        console.error('❌ [Model] Validation failed: 12-month data missing sections array');
        return false;
      }
      if (!twelveMonthData.months || !Array.isArray(twelveMonthData.months)) {
        console.error('❌ [Model] Validation failed: 12-month data missing months array');
        return false;
      }
      console.log('✅ [Model] 12-month data validation passed');
      return true;
    }
  }
}
