/**
 * IAccountMappingRepository Interface
 * Repository interface for account mapping operations
 */

import { AccountMapping } from '../entities/AccountMapping';

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

export interface AccountOption {
  account_id: string;
  account_name: string;
  category_tag: string;
}

export interface CompanyOption {
  company_id: string;
  company_name: string;
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
    myCompanyId: string,
    counterpartyCompanyId: string,
    myAccountId: string,
    linkedAccountId: string,
    direction: string,
    createdBy: string
  ): Promise<CreateMappingResult>;

  /**
   * Delete an account mapping
   */
  deleteAccountMapping(mappingId: string): Promise<DeleteMappingResult>;

  /**
   * Get accounts for a company
   */
  getCompanyAccounts(companyId: string): Promise<{ success: boolean; data?: AccountOption[]; error?: string }>;
}
