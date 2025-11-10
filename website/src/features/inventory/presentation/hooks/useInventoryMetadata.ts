/**
 * useInventoryMetadata Hook
 * Fetches inventory metadata (categories, brands, product types, units) from Supabase RPC
 */

import { useState, useEffect } from 'react';
import { supabaseService } from '@/core/services/supabase_service';
import type { InventoryMetadata, InventoryMetadataResponse } from '../../domain/entities/InventoryMetadata';

interface UseInventoryMetadataResult {
  metadata: InventoryMetadata | null;
  loading: boolean;
  error: string | null;
  refresh: () => Promise<void>;
}

export const useInventoryMetadata = (companyId: string, storeId?: string): UseInventoryMetadataResult => {
  const [metadata, setMetadata] = useState<InventoryMetadata | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  const fetchMetadata = async () => {
    try {
      setLoading(true);
      setError(null);

      const supabase = supabaseService.getClient();

      // Call the get_inventory_metadata RPC function
      const { data, error: rpcError } = await supabase
        .rpc('get_inventory_metadata', {
          p_company_id: companyId,
          p_store_id: storeId || null,
        });

      if (rpcError) {
        console.error('Error calling get_inventory_metadata:', rpcError);
        setError(rpcError.message);
        return;
      }

      const response = data as InventoryMetadataResponse;

      if (response && response.success && response.data) {
        console.log('📦 Metadata loaded:', {
          categories: response.data.categories?.length || 0,
          brands: response.data.brands?.length || 0,
          units: response.data.units?.length || 0,
          unitsData: response.data.units,
        });
        setMetadata(response.data);
      } else {
        setError('Invalid metadata response format');
      }
    } catch (err) {
      console.error('Error fetching inventory metadata:', err);
      setError(err instanceof Error ? err.message : 'Unknown error');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (companyId) {
      fetchMetadata();
    }
  }, [companyId, storeId]);

  return {
    metadata,
    loading,
    error,
    refresh: fetchMetadata,
  };
};
