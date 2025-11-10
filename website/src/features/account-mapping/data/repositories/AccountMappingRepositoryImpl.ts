/**
 * AccountMappingRepositoryImpl
 * Implementation of IAccountMappingRepository interface
 */

import {
  IAccountMappingRepository,
  AccountMappingResult,
  CreateMappingResult,
  UpdateMappingResult,
  DeleteMappingResult,
} from '../../domain/repositories/IAccountMappingRepository';
import { AccountMapping, AccountType } from '../../domain/entities/AccountMapping';
import { AccountMappingDataSource } from '../datasources/AccountMappingDataSource';

export class AccountMappingRepositoryImpl implements IAccountMappingRepository {
  private dataSource: AccountMappingDataSource;

  constructor() {
    this.dataSource = new AccountMappingDataSource();
  }

  async getAccountMappings(companyId: string): Promise<AccountMappingResult> {
    try {
      const data = await this.dataSource.getAccountMappings(companyId);

      const mappings = data.map(
        (item: any) =>
          new AccountMapping(
            item.mapping_id,
            item.company_id,
            item.account_code,
            item.account_name,
            item.account_type,
            item.description,
            item.is_active,
            new Date(item.created_at),
            item.is_read_only || false
          )
      );

      return {
        success: true,
        data: mappings,
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
    companyId: string,
    accountCode: string,
    accountName: string,
    accountType: AccountType,
    description: string | null
  ): Promise<CreateMappingResult> {
    try {
      const data = await this.dataSource.createAccountMapping(
        companyId,
        accountCode,
        accountName,
        accountType,
        description
      );

      const mapping = new AccountMapping(
        data.mapping_id,
        data.company_id,
        data.account_code,
        data.account_name,
        data.account_type,
        data.description,
        data.is_active,
        new Date(data.created_at),
        false
      );

      return {
        success: true,
        data: mapping,
      };
    } catch (error) {
      console.error('Repository error creating account mapping:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to create account mapping',
      };
    }
  }

  async updateAccountMapping(
    mappingId: string,
    accountCode: string,
    accountName: string,
    accountType: AccountType,
    description: string | null
  ): Promise<UpdateMappingResult> {
    try {
      await this.dataSource.updateAccountMapping(
        mappingId,
        accountCode,
        accountName,
        accountType,
        description
      );

      return {
        success: true,
      };
    } catch (error) {
      console.error('Repository error updating account mapping:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to update account mapping',
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
