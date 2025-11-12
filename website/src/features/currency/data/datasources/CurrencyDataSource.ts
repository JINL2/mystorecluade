import { supabaseService } from '@/core/services/supabase_service';
import { DateTimeUtils } from '@/core/utils/datetime-utils';
import { CurrencyModel } from '../models/CurrencyModel';
import { CurrencyTypeModel } from '../models/CurrencyTypeModel';

export class CurrencyDataSource {
  async getCurrencies(companyId: string) {
    const supabase = supabaseService.getClient();

    // Get base currency ID from companies table
    const { data: companyData, error: companyError } = await supabase
      .from('companies')
      .select('base_currency_id')
      .eq('company_id', companyId)
      .single();

    if (companyError) throw new Error(companyError.message);

    const baseCurrencyId = (companyData as any)?.base_currency_id || null;

    // Get company currencies
    const { data: companyCurrencies, error: companyCurrencyError } = await supabase
      .from('company_currency')
      .select('*')
      .eq('company_id', companyId)
      .eq('is_deleted', false)
      .order('created_at', { ascending: true });

    if (companyCurrencyError) throw new Error(companyCurrencyError.message);
    if (!companyCurrencies || companyCurrencies.length === 0) return [];

    // Get currency IDs
    const currencyIds = [...new Set((companyCurrencies as any[]).map((cc: any) => cc.currency_id))];

    // Get currency types
    const { data: currencyTypes, error: currencyTypeError } = await supabase
      .from('currency_types')
      .select('*')
      .in('currency_id', currencyIds);

    if (currencyTypeError) throw new Error(currencyTypeError.message);

    // Get latest exchange rates for each currency
    const exchangeRatesMap = new Map<string, number>();
    for (const currencyId of currencyIds) {
      const { data: latestRate, error } = await supabase
        .from('book_exchange_rates')
        .select('rate')
        .eq('company_id', companyId)
        .eq('from_currency_id', currencyId)
        .order('rate_date', { ascending: false })
        .limit(1)
        .maybeSingle();

      if (!error && latestRate) {
        exchangeRatesMap.set(currencyId, (latestRate as any).rate);
      }
    }

    // Map to DTO format using CurrencyModel
    return ((currencyTypes as any[]) || []).map((ct: any) => {
      const currencyData = {
        currency_id: ct.currency_id,
        company_id: companyId,
        code: ct.currency_code,
        symbol: ct.symbol || '',
        name: ct.currency_name || '',
        is_default: ct.currency_id === baseCurrencyId,
        exchange_rate: exchangeRatesMap.get(ct.currency_id) || 1.0
      };
      return CurrencyModel.fromDatabase(currencyData);
    });
  }

  async setDefaultCurrency(currencyId: string, companyId: string) {
    const supabase = supabaseService.getClient();

    const { error } = await supabase
      .from('companies')
      .update({ base_currency_id: currencyId } as any)
      .eq('company_id', companyId);

    if (error) throw new Error(error.message);
  }

  async updateExchangeRate(currencyId: string, companyId: string, newRate: number, userId: string) {
    const supabase = supabaseService.getClient();

    // Get base currency ID
    const { data: companyData, error: companyError } = await supabase
      .from('companies')
      .select('base_currency_id')
      .eq('company_id', companyId)
      .single();

    if (companyError) throw new Error(companyError.message);
    const baseCurrencyId = (companyData as any)?.base_currency_id;

    if (!baseCurrencyId) {
      throw new Error('Base currency not found for the company');
    }

    // Get current date (date-only, no timezone conversion)
    const rateDate = DateTimeUtils.toDateOnly(new Date());

    // Check if record exists
    const { data: existingRates, error: selectError } = await supabase
      .from('book_exchange_rates')
      .select('*')
      .eq('company_id', companyId)
      .eq('from_currency_id', currencyId);

    if (selectError && selectError.code !== 'PGRST116') {
      console.error('Error checking existing rates:', selectError);
    }

    if (existingRates && (existingRates as any[]).length > 0) {
      // Update existing record
      const { error: updateError } = await supabase
        .from('book_exchange_rates')
        .update({
          rate: newRate,
          rate_date: rateDate,
          updated_at: DateTimeUtils.nowUtc()
        } as any)
        .eq('company_id', companyId)
        .eq('from_currency_id', currencyId);

      if (updateError) throw new Error(updateError.message);
    } else {
      // Create new record
      const { error: insertError } = await supabase
        .from('book_exchange_rates')
        .insert({
          company_id: companyId,
          from_currency_id: currencyId,
          to_currency_id: baseCurrencyId,
          rate: newRate,
          rate_date: rateDate,
          created_by: userId
        } as any);

      if (insertError) throw new Error(insertError.message);
    }
  }

  async getAllCurrencyTypes() {
    const supabase = supabaseService.getClient();

    const { data, error } = await supabase
      .from('currency_types')
      .select('*')
      .order('currency_code', { ascending: true });

    if (error) throw new Error(error.message);

    // Map to DTO format using CurrencyTypeModel
    return ((data as any[]) || []).map((ct: any) =>
      CurrencyTypeModel.fromDatabase(ct)
    );
  }

  async addCurrency(currencyId: string, companyId: string, exchangeRate: number, userId: string) {
    const supabase = supabaseService.getClient();

    // Get base currency ID
    const { data: companyData, error: companyError } = await supabase
      .from('companies')
      .select('base_currency_id')
      .eq('company_id', companyId)
      .single();

    if (companyError) {
      throw new Error(companyError.message);
    }

    const baseCurrencyId = (companyData as any)?.base_currency_id;

    // Get current date (date-only, no timezone conversion)
    const rateDate = DateTimeUtils.toDateOnly(new Date());

    // First, add to company_currency table
    const { error: compCurrError } = await supabase
      .from('company_currency')
      .insert({
        company_id: companyId,
        currency_id: currencyId,
        is_deleted: false
      } as any)
      .select();

    if (compCurrError) {
      throw new Error(compCurrError.message);
    }

    // Then add to book_exchange_rates table (only if baseCurrencyId exists)
    if (baseCurrencyId) {
      const { error: bookRateError } = await supabase
        .from('book_exchange_rates')
        .insert({
          company_id: companyId,
          from_currency_id: currencyId,
          to_currency_id: baseCurrencyId,
          rate: exchangeRate,
          rate_date: rateDate,
          created_by: userId
        } as any);

      if (bookRateError) {
        // Don't throw as the main operation succeeded
      }
    }
  }

  async removeCurrency(currencyId: string, companyId: string) {
    const supabase = supabaseService.getClient();

    // Soft delete by setting is_deleted to true
    const { error } = await supabase
      .from('company_currency')
      .update({
        is_deleted: true,
        updated_at: DateTimeUtils.nowUtc()
      } as any)
      .eq('company_id', companyId)
      .eq('currency_id', currencyId);

    if (error) {
      throw new Error(error.message);
    }
  }
}
