/**
 * useAccountMapping Hook
 * Custom hook for account mapping management
 *
 * Following Clean Architecture:
 * - Executes validation using domain validators
 * - Calls repository for data operations
 */

import { useState, useEffect, useCallback } from 'react';
import { AccountMapping } from '../../domain/entities/AccountMapping';
import { AccountMappingRepositoryImpl } from '../../data/repositories/AccountMappingRepositoryImpl';
import { AccountMappingValidator } from '../../domain/validators/AccountMappingValidator';

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
      counterpartyCompanyId: string,
      myAccountId: string,
      linkedAccountId: string,
      direction: string,
      createdBy: string
    ) => {
      // Step 1: Execute validation using domain validator
      const validationErrors = AccountMappingValidator.validateCreateMapping({
        myCompanyId: companyId,
        counterpartyCompanyId,
        myAccountId,
        linkedAccountId,
        direction,
        createdBy,
      });

      if (validationErrors.length > 0) {
        const errorMessage = validationErrors.map((e) => e.message).join(', ');
        return { success: false, error: errorMessage };
      }

      // Step 2: Call repository for data operation
      try {
        const result = await repository.createAccountMapping(
          companyId,
          counterpartyCompanyId,
          myAccountId,
          linkedAccountId,
          direction,
          createdBy
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

  const getCompanyAccounts = useCallback(
    async (targetCompanyId: string) => {
      try {
        return await repository.getCompanyAccounts(targetCompanyId);
      } catch (err) {
        return {
          success: false,
          error: err instanceof Error ? err.message : 'Failed to fetch company accounts',
        };
      }
    },
    []
  );

  const deleteMapping = useCallback(
    async (mappingId: string) => {
      // Step 1: Execute validation using domain validator
      const validationError = AccountMappingValidator.validateDeleteMapping(mappingId);

      if (validationError) {
        return { success: false, error: validationError.message };
      }

      // Step 2: Call repository for data operation
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
    getCompanyAccounts,
    deleteMapping,
    refresh,
  };
};
