/**
 * AccountMappingRepositoryImpl
 * Implementation of IAccountMappingRepository interface
 *
 * Following Clean Architecture:
 * - Uses Model for data transformation (DTO ↔ Entity)
 * - Delegates data access to DataSource
 */

import {
  IAccountMappingRepository,
  AccountMappingResult,
  CreateMappingResult,
  DeleteMappingResult,
} from '../../domain/repositories/IAccountMappingRepository';
import { AccountMappingDataSource } from '../datasources/AccountMappingDataSource';
import { AccountMappingModel } from '../models/AccountMappingModel';

export class AccountMappingRepositoryImpl implements IAccountMappingRepository {
  private dataSource: AccountMappingDataSource;

  constructor() {
    this.dataSource = new AccountMappingDataSource();
  }

  async getAccountMappings(companyId: string): Promise<AccountMappingResult> {
    try {
      const data = await this.dataSource.getAccountMappings(companyId);

      // Use Model to parse RPC response and transform to domain entities
      const { allMappings } = AccountMappingModel.parseRPCResponse(data);

      return {
        success: true,
        data: allMappings,
      };
    } catch (error) {
      console.error('Repository error fetching account mappings:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to fetch account mappings',
      };
    }
  }

  async createAccountMapping(
    myCompanyId: string,
    counterpartyCompanyId: string,
    myAccountId: string,
    linkedAccountId: string,
    direction: string,
    createdBy: string
  ): Promise<CreateMappingResult> {
    try {
      await this.dataSource.createAccountMapping(
        myCompanyId,
        counterpartyCompanyId,
        myAccountId,
        linkedAccountId,
        direction,
        createdBy
      );

      return {
        success: true,
        data: undefined,
      };
    } catch (error) {
      console.error('Repository error creating account mapping:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to create account mapping',
      };
    }
  }

  async getCompanyAccounts(companyId: string) {
    try {
      const data = await this.dataSource.getCompanyAccounts(companyId);

      // Use Model to extract accounts from RPC response
      const accounts = AccountMappingModel.extractAccounts(data);

      return {
        success: true,
        data: accounts,
      };
    } catch (error) {
      console.error('Repository error fetching company accounts:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to fetch company accounts',
      };
    }
  }

  async deleteAccountMapping(mappingId: string): Promise<DeleteMappingResult> {
    try {
      await this.dataSource.deleteAccountMapping(mappingId);

      return {
        success: true,
      };
    } catch (error) {
      console.error('Repository error deleting account mapping:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to delete account mapping',
      };
    }
  }
}
