/**
 * useInventoryMetadata Hook
 * Fetches inventory metadata (categories, brands, product types, units) through Repository
 */

import { useState, useEffect } from 'react';
import { InventoryRepositoryImpl } from '../../data/repositories/InventoryRepositoryImpl';
import type { InventoryMetadata } from '../../domain/entities/InventoryMetadata';

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

  const repository = new InventoryRepositoryImpl();

  const fetchMetadata = async () => {
    try {
      setLoading(true);
      setError(null);

      // Call repository to get metadata
      const result = await repository.getMetadata(companyId, storeId);

      if (result.success && result.data) {
        setMetadata(result.data);
      } else {
        setError(result.error || 'Failed to load metadata');
      }
    } catch (err) {
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
