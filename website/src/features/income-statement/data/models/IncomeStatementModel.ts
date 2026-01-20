/**
 * Income Statement Model
 * Data layer - DTO (Data Transfer Object) + Mapper
 *
 * Converts RPC responses to Domain Entities
 * Following ARCHITECTURE.md pattern:
 * - Model handles DTO mapping (server response → domain entity)
 * - snake_case → camelCase conversion
 * - No direct entity construction in repository
 */

import {
  MonthlyIncomeStatementData,
  TwelveMonthIncomeStatementData,
  IncomeStatementSection,
  IncomeStatementSubcategory,
  IncomeStatementAccount,
  PeriodInfo,
} from '../../domain/entities/IncomeStatementData';

/**
 * Raw RPC response types (snake_case from server)
 */
interface RpcAccount {
  account_name: string;
  net_amount: number | string | null;
  monthly_amounts?: Record<string, number>;
  total?: number | string | null;
}

interface RpcSubcategory {
  subcategory: string;
  subcategory_total: number | string | null;
  subcategory_monthly_totals?: Record<string, number>;
  accounts?: RpcAccount[];
}

interface RpcSection {
  section: string;
  section_total: number | string | null;
  section_monthly_totals?: Record<string, number>;
  subcategories?: RpcSubcategory[];
}

interface Rpc12MonthResponse {
  summary?: {
    period_info?: {
      start_time?: string;
      end_time?: string;
      start_date?: string;
      end_date?: string;
      store_scope?: 'all_stores' | 'single_store';
      store_name?: string;
      timezone?: string;
    };
  };
  months: string[];
  sections: RpcSection[];
}

export class IncomeStatementModel {
  /**
   * Convert RPC response to Monthly Income Statement Domain Entity
   */
  static fromMonthlyRpcResponse(
    rpcData: RpcSection[],
    currencySymbol: string = '$'
  ): MonthlyIncomeStatementData {
    if (!Array.isArray(rpcData)) {
      console.error('❌ [Model] Invalid RPC response format: expected array');
      throw new Error('Invalid monthly income statement data format');
    }

    if (rpcData.length === 0) {
      console.warn('⚠️ [Model] Empty RPC response received');
      return new MonthlyIncomeStatementData([], currencySymbol);
    }

    const sections = rpcData.map((section, index) =>
      this.mapSection(section, index)
    );

    console.log('✅ [Model] Successfully mapped monthly income statement data');
    return new MonthlyIncomeStatementData(sections, currencySymbol);
  }

  /**
   * Convert RPC response to 12-Month Income Statement Domain Entity
   */
  static from12MonthRpcResponse(
    rpcData: Rpc12MonthResponse,
    currencySymbol: string = '$'
  ): TwelveMonthIncomeStatementData {
    if (!rpcData || typeof rpcData !== 'object') {
      console.error('❌ [Model] Invalid 12-month RPC response format');
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

    const sections = rpcData.sections.map((section, index) =>
      this.mapSection(section, index)
    );

    const periodInfo: PeriodInfo = {
      startDate:
        rpcData.summary?.period_info?.start_time ||
        rpcData.summary?.period_info?.start_date ||
        '',
      endDate:
        rpcData.summary?.period_info?.end_time ||
        rpcData.summary?.period_info?.end_date ||
        '',
      storeScope: rpcData.summary?.period_info?.store_scope || 'all_stores',
      storeName: rpcData.summary?.period_info?.store_name,
      timezone: rpcData.summary?.period_info?.timezone,
    };

    console.log('✅ [Model] Successfully mapped 12-month income statement data');
    return new TwelveMonthIncomeStatementData(
      sections,
      rpcData.months,
      periodInfo,
      currencySymbol
    );
  }

  /**
   * Map RPC section to domain Section
   */
  private static mapSection(section: RpcSection, index: number): IncomeStatementSection {
    if (!section || typeof section !== 'object') {
      console.warn(`⚠️ [Model] Invalid section at index ${index}`);
      return new IncomeStatementSection(
        'Unknown Section',
        0,
        [],
        {}
      );
    }

    const subcategories = (section.subcategories || []).map((sub, subIndex) =>
      this.mapSubcategory(sub, subIndex)
    );

    return new IncomeStatementSection(
      section.section || `Unknown Section ${index + 1}`,
      this.parseNumber(section.section_total),
      subcategories,
      section.section_monthly_totals || {}
    );
  }

  /**
   * Map RPC subcategory to domain Subcategory
   */
  private static mapSubcategory(
    sub: RpcSubcategory,
    index: number
  ): IncomeStatementSubcategory {
    if (!sub || typeof sub !== 'object') {
      console.warn(`⚠️ [Model] Invalid subcategory at index ${index}`);
      return new IncomeStatementSubcategory('', 0, [], {});
    }

    const accounts = (sub.accounts || []).map((acc, accIndex) =>
      this.mapAccount(acc, accIndex)
    );

    return new IncomeStatementSubcategory(
      sub.subcategory || '',
      this.parseNumber(sub.subcategory_total),
      accounts,
      sub.subcategory_monthly_totals || {}
    );
  }

  /**
   * Map RPC account to domain Account
   */
  private static mapAccount(acc: RpcAccount, index: number): IncomeStatementAccount {
    if (!acc || typeof acc !== 'object') {
      console.warn(`⚠️ [Model] Invalid account at index ${index}`);
      return new IncomeStatementAccount('Unknown Account', 0, {}, 0);
    }

    const netAmount = this.parseNumber(acc.net_amount);

    return new IncomeStatementAccount(
      acc.account_name || `Unknown Account ${index + 1}`,
      netAmount,
      acc.monthly_amounts || {},
      this.parseNumber(acc.total, netAmount)
    );
  }

  /**
   * Safely parse number values
   */
  private static parseNumber(
    value: number | string | null | undefined,
    defaultValue: number = 0
  ): number {
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
   */
  static validateMappedData(
    data: MonthlyIncomeStatementData | TwelveMonthIncomeStatementData
  ): boolean {
    if (!data) {
      console.error('❌ [Model] Validation failed: data is null or undefined');
      return false;
    }

    if (data instanceof MonthlyIncomeStatementData) {
      if (!data.sections || !Array.isArray(data.sections)) {
        console.error('❌ [Model] Validation failed: monthly data missing sections');
        return false;
      }
      console.log('✅ [Model] Monthly data validation passed');
      return true;
    }

    if (data instanceof TwelveMonthIncomeStatementData) {
      if (!data.sections || !Array.isArray(data.sections)) {
        console.error('❌ [Model] Validation failed: 12-month data missing sections');
        return false;
      }
      if (!data.months || !Array.isArray(data.months)) {
        console.error('❌ [Model] Validation failed: 12-month data missing months');
        return false;
      }
      console.log('✅ [Model] 12-month data validation passed');
      return true;
    }

    console.error('❌ [Model] Validation failed: unknown data type');
    return false;
  }
}
