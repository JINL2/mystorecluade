/**
 * ScheduleAssignment Entity
 * Domain layer - Business object representing employee schedule assignment
 */

import { ScheduleShift } from './ScheduleShift';

export class ScheduleAssignment {
  constructor(
    public readonly assignmentId: string,
    public readonly userId: string,
    public readonly fullName: string,
    public readonly date: string,
    public readonly shift: ScheduleShift,
    public readonly status: 'scheduled' | 'confirmed' | 'absent' = 'scheduled'
  ) {}

  /**
   * Get formatted date
   */
  get formattedDate(): string {
    return new Date(this.date).toLocaleDateString('en-US', {
      weekday: 'short',
      month: 'short',
      day: 'numeric',
    });
  }

  /**
   * Check if assignment is today
   */
  get isToday(): boolean {
    const today = new Date().toISOString().split('T')[0];
    return this.date === today;
  }

  /**
   * Factory method to create ScheduleAssignment
   */
  static create(data: {
    assignment_id: string;
    user_id: string;
    full_name: string;
    date: string;
    shift: ScheduleShift;
    status?: 'scheduled' | 'confirmed' | 'absent';
  }): ScheduleAssignment {
    return new ScheduleAssignment(
      data.assignment_id,
      data.user_id,
      data.full_name,
      data.date,
      data.shift,
      data.status || 'scheduled'
    );
  }
}
