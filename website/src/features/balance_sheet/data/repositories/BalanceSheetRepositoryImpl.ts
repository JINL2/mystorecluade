/**
 * BalanceSheetRepositoryImpl
 * Implementation of IBalanceSheetRepository interface
 *
 * Following Clean Architecture:
 * - Repository orchestrates data flow
 * - Model handles DTO mapping (server response → domain entity)
 * - No direct entity construction in repository
 */

import {
  IBalanceSheetRepository,
  BalanceSheetResult,
} from '../../domain/repositories/IBalanceSheetRepository';
import { BalanceSheetDataSource } from '../datasources/BalanceSheetDataSource';
import { BalanceSheetModel } from '../models/BalanceSheetModel';

export class BalanceSheetRepositoryImpl implements IBalanceSheetRepository {
  private dataSource: BalanceSheetDataSource;

  constructor() {
    this.dataSource = new BalanceSheetDataSource();
  }

  async getBalanceSheet(companyId: string, storeId: string | null): Promise<BalanceSheetResult> {
    try {
      // Fetch currency symbol and balance sheet data in parallel
      const [currencySymbol, rows] = await Promise.all([
        this.dataSource.getBaseCurrencySymbol(companyId),
        this.dataSource.getBalanceSheet(companyId, storeId),
      ]);

      // Validate response structure
      if (!BalanceSheetModel.isValidV3Response(rows)) {
        return {
          success: false,
          error: 'Invalid balance sheet data structure',
        };
      }

      // Use Model to map V3 response to domain entity with dynamic currency
      const balanceSheetData = BalanceSheetModel.fromV3Response(rows, currencySymbol);

      return {
        success: true,
        data: balanceSheetData,
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to fetch balance sheet',
      };
    }
  }
}
