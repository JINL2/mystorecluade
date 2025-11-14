/**
 * Database Types
 * Type definitions for Supabase RPC functions and database operations
 *
 * This file provides type safety for Supabase operations.
 * Update these types when database schema changes.
 */

/**
 * Supabase RPC function parameter types
 */
export interface RPCParams {
  get_account_mapping_page: {
    Args: {
      p_company_id: string;
    };
    Returns: {
      accounts?: AccountRecord[];
      account_mappings?: AccountMappingRecord[];
      reverse_account_mappings?: AccountMappingRecord[];
    };
  };

  insert_account_mapping_with_company: {
    Args: {
      p_my_company_id: string;
      p_counterparty_company_id: string;
      p_my_account_id: string;
      p_linked_account_id: string;
      p_direction: string;
      p_created_by: string;
    };
    Returns: any;
  };
}

/**
 * Database table record types
 */
export interface AccountMappingRecord {
  mapping_id: string;
  my_company_id: string;
  my_account_name: string;
  my_account_code: string | null;
  my_category_tag: string;
  linked_company_id: string;
  linked_company_name: string;
  linked_account_name: string;
  linked_account_code: string | null;
  linked_category_tag: string;
  direction?: string;
  created_at: string;
  is_deleted?: boolean;
}

export interface AccountRecord {
  account_id: string;
  account_name: string;
  account_code: string | null;
  category_tag: string;
  company_id: string;
}

export interface CompanyRecord {
  company_id: string;
  company_name: string;
  tax_id: string | null;
  address: string | null;
}

/**
 * Supabase Client type with RPC support
 */
export interface TypedSupabaseClient {
  rpc<T extends keyof RPCParams>(
    fn: T,
    args: RPCParams[T]['Args']
  ): Promise<{
    data: RPCParams[T]['Returns'] | null;
    error: { message: string; details?: string; hint?: string; code?: string } | null;
  }>;

  from(table: string): any;
  auth: any;
}

/**
 * Type guard for RPC response
 */
export function isRPCError(
  error: any
): error is { message: string; details?: string; hint?: string; code?: string } {
  return error !== null && typeof error === 'object' && 'message' in error;
}
