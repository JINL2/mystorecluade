/**
 * useEmployees Hook
 * Presentation layer - Custom hook for employee data management
 */

import { useState, useEffect, useCallback } from 'react';
import { Employee } from '../../domain/entities/Employee';
import { EmployeeStats } from '../../domain/entities/EmployeeStats';
import { EmployeeRepositoryImpl } from '../../data/repositories/EmployeeRepositoryImpl';

export const useEmployees = (companyId: string) => {
  const [employees, setEmployees] = useState<Employee[]>([]);
  const [stats, setStats] = useState<EmployeeStats>(EmployeeStats.empty());
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [searchQuery, setSearchQuery] = useState('');
  const [storeFilter, setStoreFilter] = useState<string | null>(null);

  const repository = new EmployeeRepositoryImpl();

  const loadEmployees = useCallback(async () => {
    setLoading(true);
    setError(null);

    try {
      const result = await repository.getEmployees({
        companyId,
        storeId: storeFilter,
        searchQuery,
      });

      if (!result.success) {
        setError(result.error || 'Failed to load employees');
        setEmployees([]);
        setStats(EmployeeStats.empty());
        return;
      }

      setEmployees(result.employees || []);
      setStats(result.stats || EmployeeStats.empty());
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An unexpected error occurred');
      setEmployees([]);
      setStats(EmployeeStats.empty());
    } finally {
      setLoading(false);
    }
  }, [companyId, storeFilter, searchQuery]);

  useEffect(() => {
    if (companyId) {
      loadEmployees();
    }
  }, [companyId, storeFilter, searchQuery, loadEmployees]);

  const refresh = () => {
    loadEmployees();
  };

  const search = (query: string) => {
    setSearchQuery(query);
  };

  const filterByStore = (storeId: string | null) => {
    setStoreFilter(storeId);
  };

  return {
    employees,
    stats,
    loading,
    error,
    searchQuery,
    storeFilter,
    refresh,
    search,
    filterByStore,
  };
};
