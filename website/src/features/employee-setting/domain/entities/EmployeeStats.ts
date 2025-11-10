/**
 * EmployeeStats Entity
 * Domain layer - Statistics about employees
 */

export class EmployeeStats {
  constructor(
    public readonly totalEmployees: number,
    public readonly totalRoles: number,
    public readonly totalStores: number
  ) {}

  /**
   * Factory method to create EmployeeStats
   */
  static create(data: {
    total_employees: number;
    total_roles: number;
    total_stores: number;
  }): EmployeeStats {
    return new EmployeeStats(
      data.total_employees || 0,
      data.total_roles || 0,
      data.total_stores || 0
    );
  }

  /**
   * Create empty stats
   */
  static empty(): EmployeeStats {
    return new EmployeeStats(0, 0, 0);
  }
}
