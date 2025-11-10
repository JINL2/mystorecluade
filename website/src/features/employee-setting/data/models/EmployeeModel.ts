/**
 * Employee Model
 * Data layer - DTO mapper for employee data
 */

import { Employee } from '../../domain/entities/Employee';
import { EmployeeStats } from '../../domain/entities/EmployeeStats';
import type { EmployeeRawData } from '../datasources/EmployeeDataSource';

export class EmployeeModel {
  /**
   * Convert raw Supabase data to domain entity
   */
  static fromSupabase(rawData: EmployeeRawData): Employee {
    // Get primary role and store (first in array)
    const roleIds = rawData.role_ids || [];
    const roleNames = rawData.role_names || [];

    // Parse stores JSONB array
    const stores = rawData.stores || [];
    const storeIds = stores.map(s => s.store_id);
    const storeNames = stores.map(s => s.store_name);

    const primaryRoleId = roleIds.length > 0 ? roleIds[0] : null;
    const primaryRoleName = roleNames.length > 0 ? roleNames[0] : 'No role assigned';
    const primaryStoreId = storeIds.length > 0 ? storeIds[0] : null;
    const primaryStoreName = storeNames.length > 0 ? storeNames[0] : 'No store assigned';

    // Get currency symbol from currency code
    const currencySymbolMap: Record<string, string> = {
      'KRW': '₩',
      'USD': '$',
      'EUR': '€',
      'JPY': '¥',
      'CNY': '¥',
    };
    const currencySymbol = rawData.currency_code ?
      currencySymbolMap[rawData.currency_code] || rawData.currency_code : '₩';

    return Employee.create({
      user_id: rawData.user_id,
      full_name: rawData.full_name,
      email: rawData.email,
      role_id: primaryRoleId,
      role_ids: roleIds,
      role_name: primaryRoleName,
      role_names: roleNames,
      store_id: primaryStoreId,
      store_ids: storeIds,
      store_name: primaryStoreName,
      store_names: storeNames,
      salary_amount: rawData.salary_amount || 0,
      currency_id: rawData.currency_id,
      currency_code: rawData.currency_code,
      currency_symbol: currencySymbol,
      user_role_id: null, // This field doesn't exist in RPC response
    });
  }

  /**
   * Calculate stats from employee list
   */
  static calculateStats(employees: Employee[]): EmployeeStats {
    const uniqueRoles = new Set<string>();
    const uniqueStores = new Set<string>();

    employees.forEach((emp) => {
      emp.roleIds.forEach((roleId) => {
        if (roleId) uniqueRoles.add(roleId);
      });
      emp.storeIds.forEach((storeId) => {
        if (storeId) uniqueStores.add(storeId);
      });
    });

    return EmployeeStats.create({
      total_employees: employees.length,
      total_roles: uniqueRoles.size,
      total_stores: uniqueStores.size,
    });
  }
}
