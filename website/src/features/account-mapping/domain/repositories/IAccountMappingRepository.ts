/**
 * IAccountMappingRepository Interface
 * Repository interface for account mapping operations
 */

import { AccountMapping, AccountType } from '../entities/AccountMapping';

export interface AccountMappingResult {
  success: boolean;
  data?: AccountMapping[];
  error?: string;
}

export interface CreateMappingResult {
  success: boolean;
  data?: AccountMapping;
  error?: string;
}

export interface UpdateMappingResult {
  success: boolean;
  error?: string;
}

export interface DeleteMappingResult {
  success: boolean;
  error?: string;
}

export interface IAccountMappingRepository {
  /**
   * Get all account mappings for a company
   */
  getAccountMappings(companyId: string): Promise<AccountMappingResult>;

  /**
   * Create a new account mapping
   */
  createAccountMapping(
    companyId: string,
    accountCode: string,
    accountName: string,
    accountType: AccountType,
    description: string | null
  ): Promise<CreateMappingResult>;

  /**
   * Update an existing account mapping
   */
  updateAccountMapping(
    mappingId: string,
    accountCode: string,
    accountName: string,
    accountType: AccountType,
    description: string | null
  ): Promise<UpdateMappingResult>;

  /**
   * Delete an account mapping
   */
  deleteAccountMapping(mappingId: string): Promise<DeleteMappingResult>;
}
