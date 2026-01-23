/**
 * ScheduleAssignment Entity
 * Domain layer - Business object representing employee schedule assignment
 */

import { ScheduleShift } from './ScheduleShift';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

export type AssignmentStatus = 'scheduled' | 'confirmed' | 'absent';

export class ScheduleAssignment {
  constructor(
    public readonly assignmentId: string,
    public readonly userId: string,
    public readonly fullName: string,
    public readonly date: string,
    public readonly shift: ScheduleShift,
    public readonly status: AssignmentStatus = 'scheduled',
    public readonly isApproved: boolean = false
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
    const today = DateTimeUtils.toDateOnly(new Date());
    return this.date === today;
  }

  /**
   * Get approval status for display
   * approved = blue dot, pending = yellow dot
   */
  get approvalStatus(): 'approved' | 'pending' {
    return this.isApproved ? 'approved' : 'pending';
  }

  /**
   * Create a copy with updated properties
   */
  copyWith(updates: Partial<{
    assignmentId: string;
    userId: string;
    fullName: string;
    date: string;
    shift: ScheduleShift;
    status: AssignmentStatus;
    isApproved: boolean;
  }>): ScheduleAssignment {
    return new ScheduleAssignment(
      updates.assignmentId ?? this.assignmentId,
      updates.userId ?? this.userId,
      updates.fullName ?? this.fullName,
      updates.date ?? this.date,
      updates.shift ?? this.shift,
      updates.status ?? this.status,
      updates.isApproved ?? this.isApproved
    );
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
    status?: AssignmentStatus;
    is_approved?: boolean;
  }): ScheduleAssignment {
    return new ScheduleAssignment(
      data.assignment_id,
      data.user_id,
      data.full_name,
      data.date,
      data.shift,
      data.status || 'scheduled',
      data.is_approved ?? false
    );
  }
}
