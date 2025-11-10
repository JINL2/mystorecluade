import { supabaseService } from '@/core/services/supabase_service';
export class CurrencyDataSource {
  async getCurrencies(companyId: string) {
    const { data, error } = await supabaseService.getClient().rpc('get_currencies', { p_company_id: companyId });
    if (error) throw new Error(error.message);
    return data || [];
  }
  async setDefaultCurrency(currencyId: string) {
    const { error } = await supabaseService.getClient().rpc('set_default_currency', { p_currency_id: currencyId });
    if (error) throw new Error(error.message);
  }
}
