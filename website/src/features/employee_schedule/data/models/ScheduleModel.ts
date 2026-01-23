/**
 * Schedule Model
 * Data layer - DTO mapper for schedule data
 */

import { ScheduleShift } from '../../domain/entities/ScheduleShift';
import { ScheduleAssignment } from '../../domain/entities/ScheduleAssignment';
import { DateTimeUtils } from '@/core/utils/datetime-utils';
import type {
  ScheduleRawData,
  ScheduleShiftRaw,
  ScheduleDayData,
} from '../datasources/ScheduleDataSource';

export class ScheduleModel {
  /**
   * Convert raw shift data to ScheduleShift entity
   */
  static shiftFromSupabase(rawData: ScheduleShiftRaw): ScheduleShift {
    return ScheduleShift.create({
      shift_id: rawData.shift_id,
      shift_name: rawData.shift_name,
      start_time: rawData.start_time,
      end_time: rawData.end_time,
      color: rawData.color,
    });
  }

  /**
   * Convert full schedule data response
   * The RPC returns schedule as: date -> shifts -> employees[]
   * We need to flatten this into individual assignments
   */
  static fromSupabase(rawData: ScheduleRawData): {
    shifts: ScheduleShift[];
    assignments: ScheduleAssignment[];
  } {
    // Convert shifts
    const shifts = (rawData.shifts || []).map((shift) => this.shiftFromSupabase(shift));

    // Create a map of shift details for quick lookup
    const shiftMap = new Map(
      (rawData.shifts || []).map((shift) => [
        shift.shift_id,
        {
          shift_name: shift.shift_name,
          start_time: shift.start_time,
          end_time: shift.end_time,
        },
      ])
    );

    // Flatten the nested schedule structure into individual assignments
    const assignments: ScheduleAssignment[] = [];

    console.group('🔄 ScheduleModel.fromSupabase - Processing schedule');
    console.log('Raw schedule data:', rawData.schedule);

    (rawData.schedule || []).forEach((dayData: ScheduleDayData) => {
      console.log(`Day: ${dayData.date}, shifts count: ${dayData.shifts?.length}`);
      dayData.shifts.forEach((shiftInDay) => {
        console.log(`  Shift: ${shiftInDay.shift_name}, employees:`, shiftInDay.employees);
        // Get shift details from the shift map
        const shiftDetails = shiftMap.get(shiftInDay.shift_id);

        if (!shiftDetails) {
          console.warn(`Shift ${shiftInDay.shift_id} not found in shifts list`);
          return;
        }

        // Create an assignment for each employee in this shift
        shiftInDay.employees.forEach((employee) => {
          const shift = ScheduleShift.create({
            shift_id: shiftInDay.shift_id,
            shift_name: shiftInDay.shift_name,
            start_time: shiftDetails.start_time,
            end_time: shiftDetails.end_time,
            color: undefined, // Color not provided in nested structure
          });

          // Convert UTC date from DB to local time (yyyy-MM-dd format)
          const localDate = DateTimeUtils.toLocalSafe(dayData.date);
          const dateString = localDate ? DateTimeUtils.toDateOnly(localDate) : dayData.date;

          const assignment = ScheduleAssignment.create({
            assignment_id: `${dateString}-${shiftInDay.shift_id}-${employee.user_id}`,
            user_id: employee.user_id,
            full_name: employee.user_name,
            date: dateString,
            shift,
            status: employee.status || 'scheduled',
            is_approved: employee.is_approved ?? false,
          });

          assignments.push(assignment);
        });
      });
    });

    console.log('Total assignments created:', assignments.length);
    console.groupEnd();

    return { shifts, assignments };
  }
}
