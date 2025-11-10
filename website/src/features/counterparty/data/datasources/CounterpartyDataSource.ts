/**
 * CounterpartyDataSource
 */

import { supabaseService } from '@/core/services/supabase_service';
import { CounterpartyType } from '../../domain/entities/Counterparty';

export class CounterpartyDataSource {
  async getCounterparties(companyId: string) {
    const supabase = supabaseService.getClient();
    const { data, error } = await supabase.rpc('get_counterparties', { p_company_id: companyId });
    if (error) throw new Error(error.message);
    return data || [];
  }

  async createCounterparty(
    companyId: string,
    name: string,
    type: CounterpartyType,
    contact: string | null,
    email: string | null,
    phone: string | null,
    address: string | null
  ) {
    const supabase = supabaseService.getClient();
    const { data, error } = await supabase.rpc('create_counterparty', {
      p_company_id: companyId,
      p_name: name,
      p_type: type,
      p_contact: contact,
      p_email: email,
      p_phone: phone,
      p_address: address,
    });
    if (error) throw new Error(error.message);
    return data;
  }

  async updateCounterparty(
    counterpartyId: string,
    name: string,
    contact: string | null,
    email: string | null,
    phone: string | null,
    address: string | null
  ) {
    const supabase = supabaseService.getClient();
    const { data, error } = await supabase.rpc('update_counterparty', {
      p_counterparty_id: counterpartyId,
      p_name: name,
      p_contact: contact,
      p_email: email,
      p_phone: phone,
      p_address: address,
    });
    if (error) throw new Error(error.message);
    return data;
  }

  async deleteCounterparty(counterpartyId: string) {
    const supabase = supabaseService.getClient();
    const { data, error } = await supabase.rpc('delete_counterparty', {
      p_counterparty_id: counterpartyId,
    });
    if (error) throw new Error(error.message);
    return data;
  }
}
