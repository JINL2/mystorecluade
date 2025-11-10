/**
 * useCounterparties Hook
 * Manages counterparty (supplier) data for orders
 */

import { useState, useEffect } from 'react';
import { supabaseService } from '@/core/services/supabase_service';

export interface Counterparty {
  counterparty_id: string;
  name: string;
  email?: string;
  phone?: string;
  address?: string;
  notes?: string;
}

export const useCounterparties = (companyId: string | null) => {
  const [counterparties, setCounterparties] = useState<Counterparty[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (companyId) {
      fetchCounterparties();
    } else {
      setCounterparties([]);
    }
  }, [companyId]);

  const fetchCounterparties = async () => {
    if (!companyId) return;

    setLoading(true);
    setError(null);

    try {
      const { data, error: fetchError } = await supabaseService
        .getClient()
        .from('counterparties')
        .select('counterparty_id, name, email, phone, address, notes')
        .eq('company_id', companyId)
        .eq('type', 'Suppliers')
        .eq('is_deleted', false)
        .order('name');

      if (fetchError) throw fetchError;

      setCounterparties(data || []);
    } catch (err) {
      console.error('Error fetching counterparties:', err);
      setError(err instanceof Error ? err.message : 'Failed to fetch suppliers');
      setCounterparties([]);
    } finally {
      setLoading(false);
    }
  };

  return { counterparties, loading, error, refresh: fetchCounterparties };
};
