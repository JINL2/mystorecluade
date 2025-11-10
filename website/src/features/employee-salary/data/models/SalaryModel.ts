/**
 * Salary Model
 * Data layer - DTO mapper for salary data
 */

import { SalaryRecord } from '../../domain/entities/SalaryRecord';
import { SalarySummary } from '../../domain/entities/SalarySummary';
import type { SalaryRawData, SalaryEmployeeRaw } from '../datasources/SalaryDataSource';

export class SalaryModel {
  /**
   * Convert raw employee data to SalaryRecord entity
   */
  static employeeFromSupabase(rawData: SalaryEmployeeRaw): SalaryRecord {
    const currencyInfo = rawData.currency_info || { currency_symbol: '$', currency_code: 'USD' };
    const salaryInfo = rawData.salary_info;
    const baseInfo = salaryInfo?.base_info || {};
    const deductions = salaryInfo?.deductions || {};
    const bonuses = salaryInfo?.bonuses || {};

    // Get store names from stores array
    const storeNames = rawData.stores?.map(s => s.store_name).join(', ') || 'N/A';

    // Calculate base salary based on type
    let baseSalary = 0;
    if (rawData.salary_type === 'hourly') {
      baseSalary = (baseInfo.worked_hours || 0) * (baseInfo.hourly_rate || 0);
    } else {
      baseSalary = baseInfo.monthly_salary || baseInfo.base_payment || 0;
    }

    return SalaryRecord.create({
      user_id: rawData.user_id,
      full_name: rawData.user_name,
      email: rawData.email,
      role_name: rawData.role_name || 'N/A',
      store_name: storeNames,
      base_salary: baseSalary,
      bonuses: bonuses.bonus_amount || 0,
      deductions: deductions.late_deduction_amount || 0,
      total_salary: salaryInfo?.total_payment || 0,
      currency_symbol: currencyInfo.currency_symbol,
      currency_code: currencyInfo.currency_code,
      payment_date: rawData.payment_date,
      status: rawData.status || 'pending',
    });
  }

  /**
   * Convert raw summary data to SalarySummary entity
   */
  static summaryFromSupabase(
    period: string,
    rawSummary: SalaryRawData['summary']
  ): SalarySummary {
    return SalarySummary.create({
      period,
      total_employees: rawSummary.total_employees || 0,
      total_salary: rawSummary.total_salary || 0,
      average_salary: rawSummary.average_salary || 0,
      total_bonuses: rawSummary.total_bonuses || 0,
      total_deductions: rawSummary.total_deductions || 0,
      currency_symbol: rawSummary.currency_symbol || '$',
    });
  }

  /**
   * Convert full salary data response
   */
  static fromSupabase(rawData: SalaryRawData): {
    records: SalaryRecord[];
    summary: SalarySummary;
  } {
    const records = (rawData.employees || []).map((emp) =>
      this.employeeFromSupabase(emp)
    );

    const summary = this.summaryFromSupabase(rawData.period, rawData.summary);

    return { records, summary };
  }
}
