/**
 * CounterpartyDataSource
 * Data source for counterparty (supplier) operations (order context)
 */

import { supabaseService } from '@/core/services/supabase_service';

export interface CounterpartyDTO {
  counterparty_id: string;
  name: string;
  email?: string;
  phone?: string;
  address?: string;
  notes?: string;
}

export class CounterpartyDataSource {
  /**
   * Fetch suppliers (counterparties of type "Suppliers") for a company
   */
  async getSuppliers(companyId: string): Promise<CounterpartyDTO[]> {
    const { data, error } = await supabaseService
      .getClient()
      .from('counterparties')
      .select('counterparty_id, name, email, phone, address, notes')
      .eq('company_id', companyId)
      .eq('type', 'Suppliers')
      .eq('is_deleted', false)
      .order('name');

    if (error) {
      console.error('Error fetching counterparties:', error);
      throw new Error(error.message);
    }

    return data || [];
  }
}
