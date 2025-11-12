/**
 * useCounterparty Hook
 * Feature-specific business logic execution (Validation + Repository)
 */

import { useState, useEffect, useCallback } from 'react';
import { Counterparty, CounterpartyTypeValue } from '../../domain/entities/Counterparty';
import { CounterpartyRepositoryImpl } from '../../data/repositories/CounterpartyRepositoryImpl';
import { CounterpartyValidator } from '../../domain/validators/CounterpartyValidator';

export const useCounterparty = (companyId: string) => {
  const [counterparties, setCounterparties] = useState<Counterparty[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const repository = new CounterpartyRepositoryImpl();

  const loadCounterparties = useCallback(async () => {
    if (!companyId) {
      setCounterparties([]);
      setLoading(false);
      return;
    }
    setLoading(true);
    setError(null);
    try {
      const result = await repository.getCounterparties(companyId);
      if (!result.success) {
        setError(result.error || 'Failed to load');
        setCounterparties([]);
        return;
      }
      setCounterparties(result.data || []);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Error occurred');
      setCounterparties([]);
    } finally {
      setLoading(false);
    }
  }, [companyId]);

  useEffect(() => {
    loadCounterparties();
  }, [loadCounterparties]);

  const createCounterparty = useCallback(
    async (
      name: string,
      type: CounterpartyTypeValue,
      isInternal: boolean,
      linkedCompanyId: string | null,
      email: string | null,
      phone: string | null,
      notes: string | null
    ) => {
      // 1. Check company ID
      if (!companyId) {
        return { success: false, error: 'Company ID required' };
      }

      // 2. Validate input data (Validator 호출 - 검증 실행)
      const validationErrors = CounterpartyValidator.validateCreate({
        name,
        type,
        isInternal,
        linkedCompanyId,
        email,
        phone,
        notes,
      });

      if (validationErrors.length > 0) {
        return {
          success: false,
          error: validationErrors[0].message,
        };
      }

      // 3. Execute repository operation (Repository 호출 - 데이터 처리)
      const result = await repository.createCounterparty(
        companyId,
        name,
        type,
        isInternal,
        linkedCompanyId,
        email,
        phone,
        notes
      );

      // 4. Reload data if successful
      if (result.success) {
        await loadCounterparties();
      }

      return result;
    },
    [companyId, loadCounterparties]
  );

  const deleteCounterparty = useCallback(
    async (counterpartyId: string) => {
      if (!companyId) return { success: false, error: 'Company ID required' };
      const result = await repository.deleteCounterparty(counterpartyId, companyId);
      if (result.success) await loadCounterparties();
      return result;
    },
    [companyId, loadCounterparties]
  );

  return { counterparties, loading, error, createCounterparty, deleteCounterparty, refresh: loadCounterparties };
};
