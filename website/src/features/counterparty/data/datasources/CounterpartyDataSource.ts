/**
 * CounterpartyDataSource
 * Handles direct database operations via Supabase
 */

import { supabaseService } from '@/core/services/supabase_service';
import { CounterpartyTypeValue } from '../../domain/entities/Counterparty';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

export class CounterpartyDataSource {
  async getCounterparties(companyId: string) {
    const supabase = supabaseService.getClient();
    const { data, error } = await supabase
      .from('counterparties')
      .select('counterparty_id, company_id, name, type, is_internal, linked_company_id, email, phone, notes, is_deleted, created_at')
      .eq('company_id', companyId)
      .eq('is_deleted', false)
      .order('name', { ascending: true });

    if (error) throw new Error(error.message);
    return data || [];
  }

  async createCounterparty(
    companyId: string,
    name: string,
    type: CounterpartyTypeValue,
    isInternal: boolean,
    linkedCompanyId: string | null,
    email: string | null,
    phone: string | null,
    notes: string | null
  ) {
    const supabase = supabaseService.getClient();
    const { data, error } = await supabase
      .from('counterparties')
      .insert({
        company_id: companyId,
        name,
        type,
        is_internal: isInternal,
        linked_company_id: linkedCompanyId,
        email,
        phone,
        notes,
        is_deleted: false,
      })
      .select()
      .single();

    if (error) throw new Error(error.message);
    return data;
  }

  async deleteCounterparty(counterpartyId: string, companyId: string) {
    const supabase = supabaseService.getClient();
    const { error } = await supabase
      .from('counterparties')
      .update({
        is_deleted: true,
        updated_at: DateTimeUtils.nowUtc(),
      })
      .eq('counterparty_id', counterpartyId)
      .eq('company_id', companyId);

    if (error) throw new Error(error.message);
    return true;
  }
}
