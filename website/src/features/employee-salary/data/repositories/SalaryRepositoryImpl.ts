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

  async getSalaryData(companyId: string, month: string, storeId?: string | null): Promise<SalaryDataResult> {
    try {
      const result = await this.dataSource.getSalaryData(companyId, month, storeId);

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
    storeId: string | null = null,
    companyName: string = 'Company',
    storeName: string = 'AllStores'
  ): Promise<SalaryExportResult> {
    try {
      // Import ExcelJS dynamically
      const ExcelJS = await import('exceljs');

      // Call RPC to get shift records (pass storeId for filtering)
      const result = await this.dataSource.exportToExcel(companyId, month, storeId);

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

      // Process data for Excel - All columns as per RPC v2
      const processedData = data.map((row) => ({
        // Row type indicator
        is_summary: row.is_summary ? 'SUMMARY' : '',
        // User info
        user_id: row.user_id || '',
        first_name: row.first_name || '',
        last_name: row.last_name || '',
        user_name: row.user_name || '',
        user_email: row.user_email || '',
        // Bank info (new in v2)
        user_bank_name: row.user_bank_name || '',
        user_account_number: row.user_account_number || '',
        // Store info
        store_name: row.store_name || '',
        store_code: row.store_code || '',
        // Shift info
        shift_request_id: row.shift_request_id || '',
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
        // Hours
        scheduled_hours: row.scheduled_hours || 0,
        actual_worked_hours: row.actual_worked_hours || 0,
        paid_hours: row.paid_hours || 0,
        // Late info
        is_late: row.is_late ? 'Yes' : row.is_late === false ? 'No' : '',
        late_minutes: row.late_minutes || 0,
        late_deduction_krw: row.late_deduction_krw || 0,
        // Overtime info
        is_extratime: row.is_extratime ? 'Yes' : row.is_extratime === false ? 'No' : '',
        overtime_minutes: row.overtime_minutes || 0,
        overtime_amount: row.overtime_amount || 0,
        // Salary info
        salary_type: row.salary_type || '',
        salary_amount: row.salary_amount || 0,
        bonus_amount: row.bonus_amount || 0,
        total_salary_pay: row.total_salary_pay || 0,
        total_pay_with_bonus: row.total_pay_with_bonus || 0,
        // Status
        is_approved: row.is_approved ? 'Yes' : row.is_approved === false ? 'No' : '',
        is_problem: row.is_problem ? 'Yes' : row.is_problem === false ? 'No' : '',
        problem_type: row.problem_type || '',
        report_reason: row.report_reason || '',
        // Summary stats (new in v2) - only for summary rows
        total_shift_count: row.total_shift_count || '',
        late_count: row.late_count || '',
        extratime_count: row.extratime_count || '',
        problem_count: row.problem_count || '',
      }));

      // Create workbook and worksheet
      const workbook = new ExcelJS.Workbook();
      const worksheet = workbook.addWorksheet('Shift Records');

      // Define columns (updated for RPC v2)
      worksheet.columns = [
        { header: 'Row Type', key: 'is_summary', width: 10 },
        { header: 'User ID', key: 'user_id', width: 36 },
        { header: 'First Name', key: 'first_name', width: 15 },
        { header: 'Last Name', key: 'last_name', width: 15 },
        { header: 'User Name', key: 'user_name', width: 20 },
        { header: 'Email', key: 'user_email', width: 25 },
        { header: 'Store Name', key: 'store_name', width: 20 },
        { header: 'Store Code', key: 'store_code', width: 12 },
        { header: 'Shift ID', key: 'shift_request_id', width: 36 },
        { header: 'Date', key: 'request_date', width: 12 },
        { header: 'Shift Name', key: 'shift_name', width: 15 },
        { header: 'Start Time', key: 'start_time', width: 18 },
        { header: 'End Time', key: 'end_time', width: 18 },
        { header: 'Actual Start', key: 'actual_start_time', width: 18 },
        { header: 'Actual End', key: 'actual_end_time', width: 18 },
        { header: 'Confirm Start', key: 'confirm_start_time', width: 18 },
        { header: 'Confirm End', key: 'confirm_end_time', width: 18 },
        { header: 'Scheduled Hours', key: 'scheduled_hours', width: 14 },
        { header: 'Actual Hours', key: 'actual_worked_hours', width: 14 },
        { header: 'Paid Hours', key: 'paid_hours', width: 12 },
        { header: 'Is Late', key: 'is_late', width: 8 },
        { header: 'Late Minutes', key: 'late_minutes', width: 12 },
        { header: 'Late Deduction', key: 'late_deduction_krw', width: 14 },
        { header: 'Is Overtime', key: 'is_extratime', width: 10 },
        { header: 'OT Minutes', key: 'overtime_minutes', width: 12 },
        { header: 'OT Amount', key: 'overtime_amount', width: 12 },
        { header: 'Salary Type', key: 'salary_type', width: 12 },
        { header: 'Salary Amount', key: 'salary_amount', width: 14 },
        { header: 'Bonus', key: 'bonus_amount', width: 12 },
        { header: 'Total Pay', key: 'total_salary_pay', width: 14 },
        { header: 'Total w/ Bonus', key: 'total_pay_with_bonus', width: 14 },
        { header: 'Bank Name', key: 'user_bank_name', width: 20 },
        { header: 'Account Number', key: 'user_account_number', width: 20 },
        { header: 'Approved', key: 'is_approved', width: 10 },
        { header: 'Has Problem', key: 'is_problem', width: 10 },
        { header: 'Problem Type', key: 'problem_type', width: 15 },
        { header: 'Report Reason', key: 'report_reason', width: 20 },
        { header: 'Shift Count', key: 'total_shift_count', width: 12 },
        { header: 'Late Count', key: 'late_count', width: 10 },
        { header: 'OT Count', key: 'extratime_count', width: 10 },
        { header: 'Problem Count', key: 'problem_count', width: 12 },
      ];

      // Add data rows and track summary row indices
      const summaryRowIndices: number[] = [];
      processedData.forEach((row, index) => {
        const excelRow = worksheet.addRow(row);
        // Track summary rows (index + 2 because row 1 is header)
        if (row.is_summary === 'SUMMARY') {
          summaryRowIndices.push(index + 2);
        }
      });

      // Find the column index for "Total w/ Bonus" (1-based)
      const totalWithBonusColIndex = worksheet.columns.findIndex(
        (col) => col.key === 'total_pay_with_bonus'
      ) + 1;

      // Style header row
      const headerRow = worksheet.getRow(1);
      headerRow.font = {
        name: 'Arial',
        size: 11,
        bold: true,
      };
      headerRow.alignment = {
        vertical: 'middle',
        horizontal: 'center',
        wrapText: false,
      };
      headerRow.height = 25;

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

      // Style "Total w/ Bonus" header cell with highlight
      if (totalWithBonusColIndex > 0) {
        const totalBonusHeaderCell = headerRow.getCell(totalWithBonusColIndex);
        totalBonusHeaderCell.fill = {
          type: 'pattern',
          pattern: 'solid',
          fgColor: { argb: 'FF4472C4' }, // Blue background
        };
        totalBonusHeaderCell.font = {
          name: 'Arial',
          size: 11,
          bold: true,
          color: { argb: 'FFFFFFFF' }, // White text
        };
      }

      // Style "Total w/ Bonus" column cells (highlight entire column)
      if (totalWithBonusColIndex > 0) {
        for (let rowNum = 2; rowNum <= worksheet.rowCount; rowNum++) {
          const cell = worksheet.getRow(rowNum).getCell(totalWithBonusColIndex);
          cell.fill = {
            type: 'pattern',
            pattern: 'solid',
            fgColor: { argb: 'FFD6E3F8' }, // Light blue background
          };
          cell.font = {
            name: 'Arial',
            size: 10,
            bold: true,
          };
        }
      }

      // Style summary rows (employee totals)
      summaryRowIndices.forEach((rowNum) => {
        const row = worksheet.getRow(rowNum);
        row.height = 22;
        row.eachCell({ includeEmpty: false }, (cell, colNumber) => {
          cell.font = {
            name: 'Arial',
            size: 15,
            bold: true,
          };
          cell.fill = {
            type: 'pattern',
            pattern: 'solid',
            fgColor: { argb: 'FFFFF2CC' }, // Light yellow background
          };
          cell.border = {
            top: { style: 'thin', color: { argb: 'FFD4A500' } },
            bottom: { style: 'thin', color: { argb: 'FFD4A500' } },
          };
          // Extra highlight for Total w/ Bonus in summary rows
          if (colNumber === totalWithBonusColIndex) {
            cell.fill = {
              type: 'pattern',
              pattern: 'solid',
              fgColor: { argb: 'FF4472C4' }, // Blue background
            };
            cell.font = {
              name: 'Arial',
              size: 15,
              bold: true,
              color: { argb: 'FFFFFFFF' }, // White text
            };
          }
        });
      });

      // Auto-fit column widths based on content
      worksheet.columns.forEach((column) => {
        if (!column.eachCell) return;
        let maxLength = 0;
        column.eachCell({ includeEmpty: true }, (cell) => {
          const cellValue = cell.value ? cell.value.toString() : '';
          const cellLength = cellValue.length;
          if (cellLength > maxLength) {
            maxLength = cellLength;
          }
        });
        // Set width with padding, minimum 10, maximum 50
        column.width = Math.min(Math.max(maxLength + 2, 10), 50);
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
      return {
        success: false,
        error: error instanceof Error ? error.message : 'An unexpected error occurred',
      };
    }
  }
}
