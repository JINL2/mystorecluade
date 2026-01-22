/**
 * SaveBankEndingUseCase
 * Business logic for saving bank ending entries
 */

import type { ICashEndingRepository } from '../repositories/ICashEndingRepository';
import type { CurrencyEntity } from '../entities/Currency';
import { CashEndingValidator } from '../validators/CashEndingValidator';

export interface SaveBankEndingParams {
  companyId: string;
  storeId: string;
  locationId: string;
  userId: string;
  currencies: CurrencyEntity[];
  bankAmounts: Record<string, number>;
}

export class SaveBankEndingUseCase {
  constructor(private readonly repository: ICashEndingRepository) {}

  async execute(params: SaveBankEndingParams): Promise<{ success: boolean; error?: string }> {
    const { companyId, storeId, locationId, userId, currencies, bankAmounts } = params;

    // Validation
    const errors = CashEndingValidator.validateSubmit({
      companyId,
      storeId,
      locationId,
      locationType: 'bank',
      denomQuantities: {},
      bankAmounts,
    });

    if (errors.length > 0) {
      return { success: false, error: errors[0].message };
    }

    // Execute save
    return this.repository.submitBankEnding({
      companyId,
      storeId,
      locationId,
      userId,
      currencies,
      bankAmounts,
    });
  }
}
