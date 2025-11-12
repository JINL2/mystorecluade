/**
 * useSchedule Hook
 * Presentation layer - Custom hook for schedule data management
 */

import { useState, useEffect, useCallback } from 'react';
import { ScheduleShift } from '../../domain/entities/ScheduleShift';
import { ScheduleAssignment } from '../../domain/entities/ScheduleAssignment';
import { ScheduleEmployee } from '../../domain/entities/ScheduleEmployee';
import { ScheduleRepositoryImpl } from '../../data/repositories/ScheduleRepositoryImpl';
import { ScheduleValidator } from '../../domain/validators/ScheduleValidator';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

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
      startDate: DateTimeUtils.toDateOnly(start),
      endDate: DateTimeUtils.toDateOnly(end),
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
      const result = await repository.getEmployees(companyId, storeId);

      if (!result.success || !result.employees) {
        console.error('Failed to load employees:', result.error);
        setEmployees([]);
        return;
      }

      setEmployees(result.employees);
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
    date: string,
    approvedBy: string
  ): Promise<{ success: boolean; error?: string; fieldErrors?: Record<string, string> }> => {
    try {
      // 1. Validate using Domain Validator (검증 규칙 실행)
      const validationErrors = ScheduleValidator.validateAssignment({
        shiftId,
        employeeId,
        date,
      });

      if (validationErrors.length > 0) {
        const fieldErrors: Record<string, string> = {};
        validationErrors.forEach((err) => {
          fieldErrors[err.field] = err.message;
        });
        return {
          success: false,
          error: validationErrors[0].message, // Use first error as main error message
          fieldErrors,
        };
      }

      // 2. Call Repository (데이터 처리)
      const result = await repository.createAssignment(
        employeeId,
        shiftId,
        storeId,
        date,
        approvedBy
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
