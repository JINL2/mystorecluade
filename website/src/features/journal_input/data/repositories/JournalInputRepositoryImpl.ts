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
  AccountMapping,
  CounterpartyStore,
  TransactionTemplate,
} from '../../domain/repositories/IJournalInputRepository';
import { JournalEntry } from '../../domain/entities/JournalEntry';
import { JournalInputDataSource } from '../datasources/JournalInputDataSource';
import {
  AccountModel,
  CashLocationModel,
  CounterpartyModel,
  TransactionTemplateModel,
} from '../models/JournalInputModels';

export class JournalInputRepositoryImpl implements IJournalInputRepository {
  private dataSource: JournalInputDataSource;

  constructor() {
    this.dataSource = new JournalInputDataSource();
  }

  async getAccounts(_companyId: string): Promise<Account[]> {
    try {
      const data = await this.dataSource.getAccounts();
      return data.map(AccountModel.fromJson);
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
      return data.map(CashLocationModel.fromJson);
    } catch (error) {
      console.error('Repository error fetching cash locations:', error);
      return [];
    }
  }

  async getCounterparties(companyId: string): Promise<Counterparty[]> {
    try {
      const data = await this.dataSource.getCounterparties(companyId);
      console.log('Raw counterparty data from datasource:', data);
      const mapped = data.map(CounterpartyModel.fromJson);
      console.log('Mapped counterparty data:', mapped);
      return mapped;
    } catch (error) {
      console.error('Repository error fetching counterparties:', error);
      return [];
    }
  }

  async checkAccountMapping(
    companyId: string,
    counterpartyId: string,
    accountId: string
  ): Promise<AccountMapping | null> {
    try {
      const data = await this.dataSource.checkAccountMapping({
        companyId,
        counterpartyId,
        accountId,
      });

      if (!data) return null;

      return {
        myAccountId: data.my_account_id,
        linkedAccountId: data.linked_account_id,
        direction: data.direction,
      };
    } catch (error) {
      console.error('Repository error checking account mapping:', error);
      return null;
    }
  }

  async getCounterpartyStores(linkedCompanyId: string): Promise<CounterpartyStore[]> {
    try {
      const data = await this.dataSource.getCounterpartyStores(linkedCompanyId);
      return data.map((store) => ({
        storeId: store.store_id,
        storeName: store.store_name,
      }));
    } catch (error) {
      console.error('Repository error fetching counterparty stores:', error);
      return [];
    }
  }

  async getTransactionTemplates(
    companyId: string,
    storeId: string,
    userId: string
  ): Promise<TransactionTemplate[]> {
    try {
      const data = await this.dataSource.getTransactionTemplates(companyId, storeId, userId);
      return data.map(TransactionTemplateModel.fromJson);
    } catch (error) {
      console.error('Repository error fetching transaction templates:', error);
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
          // New debt fields
          interestRate: line.interestRate,
          interestAccountId: line.interestAccountId,
          interestDueDay: line.interestDueDay,
          issueDate: line.issueDate,
          dueDate: line.dueDate,
          debtDescription: line.debtDescription,
          linkedCompanyId: line.linkedCompanyId,
          counterpartyCashLocationId: line.counterpartyCashLocationId,
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
