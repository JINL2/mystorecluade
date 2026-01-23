/**
 * ScheduleShift Entity
 * Domain layer - Business object representing a work shift
 */

export class ScheduleShift {
  constructor(
    public readonly shiftId: string,
    public readonly shiftName: string,
    public readonly startTime: string,
    public readonly endTime: string,
    public readonly color: string
  ) {}

  /**
   * Get formatted time range
   */
  get timeRange(): string {
    return `${this.startTime} - ${this.endTime}`;
  }

  /**
   * Factory method to create ScheduleShift
   */
  static create(data: {
    shift_id: string;
    shift_name: string;
    start_time: string;
    end_time: string;
    color?: string;
  }): ScheduleShift {
    return new ScheduleShift(
      data.shift_id,
      data.shift_name,
      data.start_time,
      data.end_time,
      data.color || '#3B82F6'
    );
  }
}
