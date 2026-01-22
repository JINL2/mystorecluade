/**
 * SaveCashEndingUseCase
 * Business logic for saving cash/vault ending entries
 */

import type { ICashEndingRepository } from '../repositories/ICashEndingRepository';
import type { CurrencyEntity } from '../entities/Currency';
import { CashEndingValidator } from '../validators/CashEndingValidator';
import type { LocationType } from '../entities/CashLocation';

export interface SaveCashEndingParams {
  companyId: string;
  storeId: string;
  locationId: string;
  locationType: LocationType;
  userId: string;
  currencies: CurrencyEntity[];
  denomQuantities: Record<string, number>;
  vaultTransactionType?: 'in' | 'out' | 'recount';
}

export class SaveCashEndingUseCase {
  constructor(private readonly repository: ICashEndingRepository) {}

  async execute(params: SaveCashEndingParams): Promise<{ success: boolean; error?: string }> {
    const {
      companyId,
      storeId,
      locationId,
      locationType,
      userId,
      currencies,
      denomQuantities,
      vaultTransactionType,
    } = params;

    // Validation
    const errors = CashEndingValidator.validateSubmit({
      companyId,
      storeId,
      locationId,
      locationType,
      denomQuantities,
      bankAmounts: {},
    });

    if (errors.length > 0) {
      return { success: false, error: errors[0].message };
    }

    // Execute save
    return this.repository.submitCashVaultEnding({
      companyId,
      storeId,
      locationId,
      locationType: locationType as 'cash' | 'vault',
      userId,
      currencies,
      denomQuantities,
      vaultTransactionType,
    });
  }
}
