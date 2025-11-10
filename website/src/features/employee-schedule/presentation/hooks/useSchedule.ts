/**
 * useSchedule Hook
 * Presentation layer - Custom hook for schedule data management
 */

import { useState, useEffect, useCallback } from 'react';
import { ScheduleShift } from '../../domain/entities/ScheduleShift';
import { ScheduleAssignment } from '../../domain/entities/ScheduleAssignment';
import { ScheduleEmployee } from '../../domain/entities/ScheduleEmployee';
import { ScheduleRepositoryImpl } from '../../data/repositories/ScheduleRepositoryImpl';
import { ScheduleDataSource } from '../../data/datasources/ScheduleDataSource';

export const useSchedule = (companyId: string, storeId: string) => {
  // Get current week's start and end dates
  const getWeekRange = (date: Date = new Date()) => {
    const start = new Date(date);
    start.setDate(start.getDate() - start.getDay()); // Start on Sunday
    start.setHours(0, 0, 0, 0);

    const end = new Date(start);
    end.setDate(end.getDate() + 6); // End on Saturday
    end.setHours(23, 59, 59, 999);

    return {
      startDate: start.toISOString().split('T')[0],
      endDate: end.toISOString().split('T')[0],
    };
  };

  const [shifts, setShifts] = useState<ScheduleShift[]>([]);
  const [assignments, setAssignments] = useState<ScheduleAssignment[]>([]);
  const [employees, setEmployees] = useState<ScheduleEmployee[]>([]);
  const [loading, setLoading] = useState(true);
  const [loadingEmployees, setLoadingEmployees] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [currentWeek, setCurrentWeek] = useState(new Date());

  const repository = new ScheduleRepositoryImpl();
  const dataSource = new ScheduleDataSource();

  const loadScheduleData = useCallback(async () => {
    setLoading(true);
    setError(null);

    try {
      const { startDate, endDate } = getWeekRange(currentWeek);

      const result = await repository.getScheduleData(companyId, storeId, startDate, endDate);

      if (!result.success) {
        setError(result.error || 'Failed to load schedule data');
        setShifts([]);
        setAssignments([]);
        return;
      }

      setShifts(result.shifts || []);
      setAssignments(result.assignments || []);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An unexpected error occurred');
      setShifts([]);
      setAssignments([]);
    } finally {
      setLoading(false);
    }
  }, [companyId, storeId, currentWeek]);

  // Load employees for the store
  const loadEmployees = useCallback(async () => {
    setLoadingEmployees(true);

    try {
      const result = await dataSource.getEmployees(companyId, storeId);

      if (!result.success || !result.data) {
        console.error('Failed to load employees:', result.error);
        setEmployees([]);
        return;
      }

      // Convert raw data to ScheduleEmployee entities
      const employeeList = result.data.map(
        (emp) =>
          new ScheduleEmployee(
            emp.user_id,
            emp.full_name,
            emp.email,
            emp.role_ids || [],
            emp.role_names || [],
            emp.stores || [],
            emp.company_id,
            emp.company_name,
            emp.salary_id,
            emp.salary_amount,
            emp.salary_type,
            emp.bonus_amount,
            emp.currency_id,
            emp.currency_code,
            emp.account_id
          )
      );

      setEmployees(employeeList);
    } catch (err) {
      console.error('Error loading employees:', err);
      setEmployees([]);
    } finally {
      setLoadingEmployees(false);
    }
  }, [companyId, storeId]);

  useEffect(() => {
    if (companyId && storeId) {
      loadScheduleData();
      loadEmployees();
    }
  }, [companyId, storeId, currentWeek, loadScheduleData, loadEmployees]);

  const refresh = () => {
    loadScheduleData();
  };

  const goToPreviousWeek = () => {
    const newWeek = new Date(currentWeek);
    newWeek.setDate(newWeek.getDate() - 7);
    setCurrentWeek(newWeek);
  };

  const goToNextWeek = () => {
    const newWeek = new Date(currentWeek);
    newWeek.setDate(newWeek.getDate() + 7);
    setCurrentWeek(newWeek);
  };

  const goToCurrentWeek = () => {
    setCurrentWeek(new Date());
  };

  // Get assignments for a specific date
  const getAssignmentsForDate = (date: string): ScheduleAssignment[] => {
    return assignments.filter((a) => a.date === date);
  };

  // Get week days array
  const getWeekDays = (): string[] => {
    const { startDate } = getWeekRange(currentWeek);
    const days: string[] = [];
    const start = new Date(startDate);

    for (let i = 0; i < 7; i++) {
      const day = new Date(start);
      day.setDate(day.getDate() + i);
      days.push(day.toISOString().split('T')[0]);
    }

    return days;
  };

  // Create a new shift assignment
  const createAssignment = async (
    shiftId: string,
    employeeId: string,
    date: string
  ): Promise<{ success: boolean; error?: string }> => {
    try {
      const result = await dataSource.createAssignment(
        companyId,
        storeId,
        employeeId,
        shiftId,
        date
      );

      if (!result.success) {
        return {
          success: false,
          error: result.error || 'Failed to create assignment',
        };
      }

      // Refresh schedule data after successful creation
      await loadScheduleData();

      return { success: true };
    } catch (err) {
      return {
        success: false,
        error: err instanceof Error ? err.message : 'An unexpected error occurred',
      };
    }
  };

  return {
    shifts,
    assignments,
    employees,
    loading,
    loadingEmployees,
    error,
    currentWeek,
    refresh,
    goToPreviousWeek,
    goToNextWeek,
    goToCurrentWeek,
    getAssignmentsForDate,
    getWeekDays,
    createAssignment,
  };
};
