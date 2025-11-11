/**
 * AccountMappingDataSource
 * Data source for account mapping operations
 */

import { supabaseService } from '@/core/services/supabase_service';
import { AccountType } from '../../domain/entities/AccountMapping';

export class AccountMappingDataSource {
  async getAccountMappings(companyId: string) {
    const supabase = supabaseService.getClient();

    const { data, error } = await (supabase as any).rpc('get_account_mapping_page', {
      p_company_id: companyId,
    });

    if (error) {
      console.error('Error fetching account mappings:', error);
      throw new Error(error.message);
    }

    return data || [];
  }

  async createAccountMapping(
    companyId: string,
    accountCode: string,
    accountName: string,
    accountType: AccountType,
    description: string | null
  ) {
    const supabase = supabaseService.getClient();

    const { data, error } = await (supabase as any).rpc('create_account_mapping', {
      p_company_id: companyId,
      p_account_code: accountCode,
      p_account_name: accountName,
      p_account_type: accountType,
      p_description: description,
    });

    if (error) {
      console.error('Error creating account mapping:', error);
      throw new Error(error.message);
    }

    return data;
  }

  async updateAccountMapping(
    mappingId: string,
    accountCode: string,
    accountName: string,
    accountType: AccountType,
    description: string | null
  ) {
    const supabase = supabaseService.getClient();

    const { data, error } = await (supabase as any).rpc('update_account_mapping', {
      p_mapping_id: mappingId,
      p_account_code: accountCode,
      p_account_name: accountName,
      p_account_type: accountType,
      p_description: description,
    });

    if (error) {
      console.error('Error updating account mapping:', error);
      throw new Error(error.message);
    }

    return data;
  }

  async deleteAccountMapping(mappingId: string) {
    const supabase = supabaseService.getClient();

    const { data, error } = await (supabase as any).rpc('delete_account_mapping', {
      p_mapping_id: mappingId,
    });

    if (error) {
      console.error('Error deleting account mapping:', error);
      throw new Error(error.message);
    }

    return data;
  }
}
