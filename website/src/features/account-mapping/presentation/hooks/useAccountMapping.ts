/**
 * useAccountMapping Hook
 * Custom hook for account mapping management
 */

import { useState, useEffect, useCallback } from 'react';
import { AccountMapping, AccountType } from '../../domain/entities/AccountMapping';
import { AccountMappingRepositoryImpl } from '../../data/repositories/AccountMappingRepositoryImpl';

export const useAccountMapping = (companyId: string) => {
  const [mappings, setMappings] = useState<AccountMapping[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const repository = new AccountMappingRepositoryImpl();

  const loadMappings = useCallback(async () => {
    if (!companyId) {
      setMappings([]);
      setLoading(false);
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const result = await repository.getAccountMappings(companyId);

      if (!result.success) {
        setError(result.error || 'Failed to load account mappings');
        setMappings([]);
        return;
      }

      setMappings(result.data || []);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An unexpected error occurred');
      setMappings([]);
    } finally {
      setLoading(false);
    }
  }, [companyId]);

  useEffect(() => {
    loadMappings();
  }, [loadMappings]);

  const createMapping = useCallback(
    async (
      accountCode: string,
      accountName: string,
      accountType: AccountType,
      description: string | null
    ) => {
      if (!companyId) {
        return { success: false, error: 'Company ID is required' };
      }

      try {
        const result = await repository.createAccountMapping(
          companyId,
          accountCode,
          accountName,
          accountType,
          description
        );

        if (result.success) {
          await loadMappings();
        }

        return result;
      } catch (err) {
        return {
          success: false,
          error: err instanceof Error ? err.message : 'Failed to create mapping',
        };
      }
    },
    [companyId, loadMappings]
  );

  const updateMapping = useCallback(
    async (
      mappingId: string,
      accountCode: string,
      accountName: string,
      accountType: AccountType,
      description: string | null
    ) => {
      try {
        const result = await repository.updateAccountMapping(
          mappingId,
          accountCode,
          accountName,
          accountType,
          description
        );

        if (result.success) {
          await loadMappings();
        }

        return result;
      } catch (err) {
        return {
          success: false,
          error: err instanceof Error ? err.message : 'Failed to update mapping',
        };
      }
    },
    [loadMappings]
  );

  const deleteMapping = useCallback(
    async (mappingId: string) => {
      try {
        const result = await repository.deleteAccountMapping(mappingId);

        if (result.success) {
          await loadMappings();
        }

        return result;
      } catch (err) {
        return {
          success: false,
          error: err instanceof Error ? err.message : 'Failed to delete mapping',
        };
      }
    },
    [loadMappings]
  );

  const refresh = useCallback(() => {
    loadMappings();
  }, [loadMappings]);

  return {
    mappings,
    loading,
    error,
    createMapping,
    updateMapping,
    deleteMapping,
    refresh,
  };
};
