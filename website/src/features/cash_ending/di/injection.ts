/**
 * Cash Ending DI Container
 * Dependency Injection container for Cash Ending feature
 *
 * This file handles the wiring of implementations to interfaces,
 * following Clean Architecture principles.
 */

// Repositories
import { CashEndingRepository, cashEndingRepository } from '../data/repositories/CashEndingRepositoryImpl';
import { JournalRepositoryImpl, journalRepository } from '../data/repositories/JournalRepositoryImpl';
import type { ICashEndingRepository } from '../domain/repositories/ICashEndingRepository';
import type { IJournalRepository } from '../domain/repositories/IJournalRepository';

// UseCases
import { CreateErrorAdjustmentUseCase } from '../domain/usecases/CreateErrorAdjustmentUseCase';
import { CreateForeignCurrencyTranslationUseCase } from '../domain/usecases/CreateForeignCurrencyTranslationUseCase';
import { SaveCashEndingUseCase } from '../domain/usecases/SaveCashEndingUseCase';
import { SaveBankEndingUseCase } from '../domain/usecases/SaveBankEndingUseCase';
import { GetBalanceSummaryUseCase } from '../domain/usecases/GetBalanceSummaryUseCase';

// ============================================================================
// REPOSITORIES (Singleton instances)
// ============================================================================

export const getCashEndingRepository = (): ICashEndingRepository => {
  return cashEndingRepository;
};

export const getJournalRepository = (): IJournalRepository => {
  return journalRepository;
};

// ============================================================================
// USE CASES (Factory functions - create new instance each time)
// ============================================================================

export const createErrorAdjustmentUseCase = (): CreateErrorAdjustmentUseCase => {
  return new CreateErrorAdjustmentUseCase(getJournalRepository());
};

export const createForeignCurrencyTranslationUseCase = (): CreateForeignCurrencyTranslationUseCase => {
  return new CreateForeignCurrencyTranslationUseCase(getJournalRepository());
};

export const createSaveCashEndingUseCase = (): SaveCashEndingUseCase => {
  return new SaveCashEndingUseCase(getCashEndingRepository());
};

export const createSaveBankEndingUseCase = (): SaveBankEndingUseCase => {
  return new SaveBankEndingUseCase(getCashEndingRepository());
};

export const createGetBalanceSummaryUseCase = (): GetBalanceSummaryUseCase => {
  return new GetBalanceSummaryUseCase(getCashEndingRepository());
};

// ============================================================================
// CONTAINER (All dependencies in one object)
// ============================================================================

export interface CashEndingContainer {
  // Repositories
  cashEndingRepository: ICashEndingRepository;
  journalRepository: IJournalRepository;

  // UseCases
  createErrorAdjustmentUseCase: CreateErrorAdjustmentUseCase;
  createForeignCurrencyTranslationUseCase: CreateForeignCurrencyTranslationUseCase;
  saveCashEndingUseCase: SaveCashEndingUseCase;
  saveBankEndingUseCase: SaveBankEndingUseCase;
  getBalanceSummaryUseCase: GetBalanceSummaryUseCase;
}

/**
 * Create the DI container with all dependencies
 */
export const createCashEndingContainer = (): CashEndingContainer => {
  const cashEndingRepo = getCashEndingRepository();
  const journalRepo = getJournalRepository();

  return {
    // Repositories
    cashEndingRepository: cashEndingRepo,
    journalRepository: journalRepo,

    // UseCases
    createErrorAdjustmentUseCase: new CreateErrorAdjustmentUseCase(journalRepo),
    createForeignCurrencyTranslationUseCase: new CreateForeignCurrencyTranslationUseCase(journalRepo),
    saveCashEndingUseCase: new SaveCashEndingUseCase(cashEndingRepo),
    saveBankEndingUseCase: new SaveBankEndingUseCase(cashEndingRepo),
    getBalanceSummaryUseCase: new GetBalanceSummaryUseCase(cashEndingRepo),
  };
};

// Default container instance (singleton)
let containerInstance: CashEndingContainer | null = null;

export const getCashEndingContainer = (): CashEndingContainer => {
  if (!containerInstance) {
    containerInstance = createCashEndingContainer();
  }
  return containerInstance;
};

// Re-export for convenience
export { CashEndingRepository, JournalRepositoryImpl };
