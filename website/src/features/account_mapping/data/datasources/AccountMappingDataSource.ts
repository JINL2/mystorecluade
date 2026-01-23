/**
 * AccountMappingDataSource
 * Data source for account mapping operations
 *
 * Following Clean Architecture:
 * - Handles direct database access via Supabase
 * - Returns raw data (will be transformed by Model layer)
 * - Uses typed RPC calls for type safety
 */

import { supabaseService } from '@/core/services/supabase_service';
import type { AccountMappingRPCResponse } from '../models/AccountMappingModel';
import type { TypedSupabaseClient } from '@/core/types/database.types';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

export class AccountMappingDataSource {
  async getAccountMappings(companyId: string): Promise<AccountMappingRPCResponse> {
    const supabase = supabaseService.getClient() as unknown as TypedSupabaseClient;

    const { data, error } = await supabase.rpc('get_account_mapping_page', {
      p_company_id: companyId,
    });

    if (error) {
      console.error('Error fetching account mappings:', error);
      throw new Error(error.message);
    }

    return (data || {}) as AccountMappingRPCResponse;
  }

  async createAccountMapping(
    myCompanyId: string,
    counterpartyCompanyId: string,
    myAccountId: string,
    linkedAccountId: string,
    direction: string,
    createdBy: string
  ) {
    const supabase = supabaseService.getClient() as unknown as TypedSupabaseClient;

    const { data, error } = await supabase.rpc('insert_account_mapping_with_company', {
      p_my_company_id: myCompanyId,
      p_counterparty_company_id: counterpartyCompanyId,
      p_my_account_id: myAccountId,
      p_linked_account_id: linkedAccountId,
      p_direction: direction,
      p_created_by: createdBy,
    });

    if (error) {
      console.error('Error creating account mapping:', error);
      throw new Error(error.message);
    }

    return data;
  }

  async deleteAccountMapping(mappingId: string) {
    const supabase = supabaseService.getClient();

    const { error } = await supabase
      .from('account_mappings')
      .update({
        is_deleted: true,
        updated_at: DateTimeUtils.nowUtc()
      })
      .eq('mapping_id', mappingId);

    if (error) {
      console.error('Error deleting account mapping:', error);
      throw new Error(error.message);
    }
  }

  async getCompanyAccounts(companyId: string): Promise<AccountMappingRPCResponse> {
    const supabase = supabaseService.getClient() as unknown as TypedSupabaseClient;

    const { data, error } = await supabase.rpc('get_account_mapping_page', {
      p_company_id: companyId,
    });

    if (error) {
      console.error('Error fetching company accounts:', error);
      throw new Error(error.message);
    }

    return (data || {}) as AccountMappingRPCResponse;
  }
}
