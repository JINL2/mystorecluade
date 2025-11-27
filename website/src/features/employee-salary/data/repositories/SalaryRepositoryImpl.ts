/**
 * Salary Repository Implementation
 * Data layer - Implements ISalaryRepository interface
 */

import type {
  ISalaryRepository,
  SalaryDataResult,
  SalaryExportResult,
} from '../../domain/repositories/ISalaryRepository';
import { SalaryDataSource } from '../datasources/SalaryDataSource';
import { SalaryModel } from '../models/SalaryModel';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

export class SalaryRepositoryImpl implements ISalaryRepository {
  private dataSource: SalaryDataSource;

  constructor() {
    this.dataSource = new SalaryDataSource();
  }

  async getSalaryData(companyId: string, month: string): Promise<SalaryDataResult> {
    try {
      const result = await this.dataSource.getSalaryData(companyId, month);

      if (!result.success || !result.data) {
        return {
          success: false,
          error: result.error || 'Failed to fetch salary data',
        };
      }

      const { records, summary } = SalaryModel.fromSupabase(result.data);

      return {
        success: true,
        records,
        summary,
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'An unexpected error occurred',
      };
    }
  }

  async exportToExcel(
    companyId: string,
    month: string,
    _storeId: string | null = null, // TODO: Use storeId for filtering in future
    companyName: string = 'Company',
    storeName: string = 'AllStores'
  ): Promise<SalaryExportResult> {
    try {
      // Import ExcelJS dynamically
      const ExcelJS = await import('exceljs');

      // Call RPC to get shift records
      const result = await this.dataSource.exportToExcel(companyId, month);

      if (!result.success || !result.data) {
        return {
          success: false,
          error: result.error || 'Failed to export salary data',
        };
      }

      const data = result.data as any[];

      if (!data || data.length === 0) {
        return {
          success: false,
          error: 'No data available for export in the selected period',
        };
      }

      console.log(`Excel export data received: ${data.length} shift records`);

      // Process data for Excel - All 31 columns as per RPC
      const processedData = data.map((row) => ({
        shift_request_id: row.shift_request_id || '',
        user_id: row.user_id || '',
        first_name: row.first_name || '',
        last_name: row.last_name || '',
        user_name: row.user_name || '',
        user_email: row.user_email || '',
        store_name: row.store_name || '',
        store_code: row.store_code || '',
        request_date: row.request_date
          ? DateTimeUtils.formatDateOnly(DateTimeUtils.toLocal(row.request_date))
          : '',
        shift_name: row.shift_name || '',
        start_time: row.start_time
          ? DateTimeUtils.format(DateTimeUtils.toLocal(row.start_time))
          : '',
        end_time: row.end_time
          ? DateTimeUtils.format(DateTimeUtils.toLocal(row.end_time))
          : '',
        actual_start_time: row.actual_start_time
          ? DateTimeUtils.format(DateTimeUtils.toLocal(row.actual_start_time))
          : '',
        actual_end_time: row.actual_end_time
          ? DateTimeUtils.format(DateTimeUtils.toLocal(row.actual_end_time))
          : '',
        confirm_start_time: row.confirm_start_time
          ? DateTimeUtils.format(DateTimeUtils.toLocal(row.confirm_start_time))
          : '',
        confirm_end_time: row.confirm_end_time
          ? DateTimeUtils.format(DateTimeUtils.toLocal(row.confirm_end_time))
          : '',
        scheduled_hours: row.scheduled_hours || 0,
        actual_worked_hours: row.actual_worked_hours || 0,
        paid_hours: row.paid_hours || 0,
        is_late: row.is_late ? 'Yes' : 'No',
        late_minutes: row.late_minutes || 0,
        late_deduction_krw: row.late_deduction_krw || 0,
        is_extratime: row.is_extratime ? 'Yes' : 'No',
        overtime_minutes: row.overtime_minutes || 0,
        overtime_amount: row.overtime_amount || 0,
        salary_type: row.salary_type || '',
        salary_amount: row.salary_amount || 0,
        bonus_amount: row.bonus_amount || 0,
        total_salary_pay: row.total_salary_pay || 0,
        total_pay_with_bonus: row.total_pay_with_bonus || 0,
        is_approved: row.is_approved ? 'Yes' : 'No',
        is_problem: row.is_problem ? 'Yes' : 'No',
        problem_type: row.problem_type || '',
        report_reason: row.report_reason || '',
      }));

      // Create workbook and worksheet
      const workbook = new ExcelJS.Workbook();
      const worksheet = workbook.addWorksheet('Shift Records');

      // Define columns
      worksheet.columns = [
        { header: 'shift_request_id', key: 'shift_request_id', width: 36 },
        { header: 'user_id', key: 'user_id', width: 36 },
        { header: 'first_name', key: 'first_name', width: 15 },
        { header: 'last_name', key: 'last_name', width: 15 },
        { header: 'user_name', key: 'user_name', width: 20 },
        { header: 'user_email', key: 'user_email', width: 25 },
        { header: 'store_name', key: 'store_name', width: 20 },
        { header: 'store_code', key: 'store_code', width: 12 },
        { header: 'request_date', key: 'request_date', width: 12 },
        { header: 'shift_name', key: 'shift_name', width: 15 },
        { header: 'start_time', key: 'start_time', width: 18 },
        { header: 'end_time', key: 'end_time', width: 18 },
        { header: 'actual_start_time', key: 'actual_start_time', width: 18 },
        { header: 'actual_end_time', key: 'actual_end_time', width: 18 },
        { header: 'confirm_start_time', key: 'confirm_start_time', width: 18 },
        { header: 'confirm_end_time', key: 'confirm_end_time', width: 18 },
        { header: 'scheduled_hours', key: 'scheduled_hours', width: 14 },
        { header: 'actual_worked_hours', key: 'actual_worked_hours', width: 16 },
        { header: 'paid_hours', key: 'paid_hours', width: 12 },
        { header: 'is_late', key: 'is_late', width: 8 },
        { header: 'late_minutes', key: 'late_minutes', width: 12 },
        { header: 'late_deduction_krw', key: 'late_deduction_krw', width: 16 },
        { header: 'is_extratime', key: 'is_extratime', width: 10 },
        { header: 'overtime_minutes', key: 'overtime_minutes', width: 15 },
        { header: 'overtime_amount', key: 'overtime_amount', width: 15 },
        { header: 'salary_type', key: 'salary_type', width: 12 },
        { header: 'salary_amount', key: 'salary_amount', width: 15 },
        { header: 'bonus_amount', key: 'bonus_amount', width: 15 },
        { header: 'total_salary_pay', key: 'total_salary_pay', width: 16 },
        { header: 'total_pay_with_bonus', key: 'total_pay_with_bonus', width: 18 },
        { header: 'is_approved', key: 'is_approved', width: 12 },
        { header: 'is_problem', key: 'is_problem', width: 12 },
        { header: 'problem_type', key: 'problem_type', width: 15 },
        { header: 'report_reason', key: 'report_reason', width: 20 },
      ];

      // Add data rows
      processedData.forEach((row) => {
        worksheet.addRow(row);
      });

      // Style header row
      const headerRow = worksheet.getRow(1);
      headerRow.font = {
        name: 'Arial',
        size: 18,
        bold: true,
      };
      headerRow.alignment = {
        vertical: 'middle',
        horizontal: 'center',
        wrapText: false,
      };
      headerRow.height = 30;

      // Add thick bottom border to header cells
      headerRow.eachCell({ includeEmpty: false }, (cell) => {
        cell.border = {
          bottom: { style: 'thick', color: { argb: 'FF000000' } },
        };
        cell.fill = {
          type: 'pattern',
          pattern: 'solid',
          fgColor: { argb: 'FFF2F2F2' },
        };
      });

      // Generate filename
      const cleanName = (str: string) =>
        str.replace(/[^a-zA-Z0-9가-힣\s-]/g, '').replace(/\s+/g, '_');
      const filename = `ShiftRecords_${cleanName(companyName)}_${cleanName(storeName)}_${month}.xlsx`;

      // Generate Excel file as buffer
      const buffer = await workbook.xlsx.writeBuffer();
      const blob = new Blob([buffer], {
        type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      });

      return {
        success: true,
        blob,
        filename,
        recordCount: data.length,
      };
    } catch (error) {
      console.error('Export to Excel error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'An unexpected error occurred',
      };
    }
  }
}
