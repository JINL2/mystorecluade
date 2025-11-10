/**
 * JournalInputRepositoryImpl
 * Implementation of IJournalInputRepository interface
 */

import {
  IJournalInputRepository,
  Account,
  CashLocation,
  Counterparty,
  JournalSubmitResult,
} from '../../domain/repositories/IJournalInputRepository';
import { JournalEntry } from '../../domain/entities/JournalEntry';
import { JournalInputDataSource } from '../datasources/JournalInputDataSource';

export class JournalInputRepositoryImpl implements IJournalInputRepository {
  private dataSource: JournalInputDataSource;

  constructor() {
    this.dataSource = new JournalInputDataSource();
  }

  async getAccounts(companyId: string): Promise<Account[]> {
    try {
      const data = await this.dataSource.getAccounts();
      return data.map((item: any) => ({
        accountId: item.id,
        accountName: item.name,
        categoryTag: item.categoryTag,
        accountType: item.type,
        expenseNature: item.expenseNature,
      }));
    } catch (error) {
      console.error('Repository error fetching accounts:', error);
      return [];
    }
  }

  async getCashLocations(
    companyId: string,
    storeId?: string | null
  ): Promise<CashLocation[]> {
    try {
      const data = await this.dataSource.getCashLocations(companyId, storeId);
      return data.map((item: any) => ({
        locationId: item.id,
        locationName: item.name,
        locationType: item.type,
        storeId: item.storeId,
        isCompanyWide: item.isCompanyWide,
      }));
    } catch (error) {
      console.error('Repository error fetching cash locations:', error);
      return [];
    }
  }

  async getCounterparties(companyId: string): Promise<Counterparty[]> {
    try {
      const data = await this.dataSource.getCounterparties(companyId);
      return data.map((item: any) => ({
        counterpartyId: item.id,
        counterpartyName: item.name,
        type: item.type,
        isInternal: item.isInternal,
        email: item.email,
        phone: item.phone,
      }));
    } catch (error) {
      console.error('Repository error fetching counterparties:', error);
      return [];
    }
  }

  async submitJournalEntry(
    entry: JournalEntry,
    createdBy: string,
    description?: string
  ): Promise<JournalSubmitResult> {
    try {
      const result = await this.dataSource.submitJournalEntry({
        companyId: entry.companyId,
        storeId: entry.storeId,
        date: entry.date,
        createdBy: createdBy,
        description: description || `Journal entry for ${entry.date}`,
        transactionLines: entry.transactionLines.map((line) => ({
          isDebit: line.isDebit,
          accountId: line.accountId,
          amount: line.amount,
          description: line.description,
          cashLocationId: line.cashLocationId,
          counterpartyId: line.counterpartyId,
          counterpartyStoreId: line.counterpartyStoreId,
          debtCategory: line.debtCategory,
        })),
      });

      return {
        success: true,
        journalId: result?.journal_id,
      };
    } catch (error) {
      console.error('Repository error submitting journal entry:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to submit journal entry',
      };
    }
  }
}
