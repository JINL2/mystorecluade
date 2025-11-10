/**
 * DateTime utility for consistent timezone handling across the website
 *
 * 핵심 원칙:
 * - DB에는 항상 UTC로 저장
 * - 화면에는 항상 로컬 시간으로 표시
 * - 날짜만 필요한 경우 타임존 변환 안 함
 *
 * 사용 예시:
 * ```typescript
 * // 저장
 * await supabase.insert({
 *   created_at: DateTimeUtils.toUtc(new Date())
 * });
 *
 * // 읽기
 * const data = await supabase.select();
 * const createdAt = DateTimeUtils.toLocal(data.created_at);
 * ```
 */
export class DateTimeUtils {
  /**
   * Converts Date to UTC ISO8601 string for database storage
   *
   * @param date - Local Date object
   * @returns UTC ISO8601 string (e.g., "2025-01-15T05:30:00.000Z")
   *
   * @example
   * const now = new Date(); // 2025-01-15 14:30:00 (KST +9)
   * DateTimeUtils.toUtc(now); // "2025-01-15T05:30:00.000Z" (UTC)
   */
  static toUtc(date: Date): string {
    return date.toISOString();
  }

  /**
   * Returns current time as UTC ISO8601 string
   *
   * @returns Current UTC timestamp
   *
   * @example
   * await supabase.insert({
   *   created_at: DateTimeUtils.nowUtc()
   * });
   */
  static nowUtc(): string {
    return new Date().toISOString();
  }

  /**
   * Converts UTC string from database to local Date object
   *
   * Handles both:
   * - ISO 8601 with timezone: "2025-01-15T05:30:00.000Z"
   * - Timestamp without timezone: "2025-10-27 17:54:41.715" (treats as UTC)
   *
   * @param utcString - UTC timestamp string
   * @returns Local Date object
   *
   * @example
   * const utcString1 = "2025-01-15T05:30:00.000Z"; // ISO 8601 UTC
   * const utcString2 = "2025-10-27 17:54:41.715"; // timestamp without timezone
   * const local1 = DateTimeUtils.toLocal(utcString1);
   * const local2 = DateTimeUtils.toLocal(utcString2);
   * // Both converted to local time correctly
   */
  static toLocal(utcString: string): Date {
    // If string doesn't contain timezone info (no Z, +, or -), add Z to force UTC parsing
    if (
      !utcString.includes('Z') &&
      !utcString.includes('+') &&
      !utcString.includes('-', utcString.length - 6)
    ) {
      // Replace space with T for ISO 8601 format, then add Z
      const isoFormat = utcString.replace(' ', 'T');
      return new Date(`${isoFormat}Z`);
    }
    return new Date(utcString);
  }

  /**
   * Safely converts UTC string to local Date object (null-safe version)
   *
   * Handles both:
   * - ISO 8601 with timezone: "2025-01-15T05:30:00.000Z"
   * - Timestamp without timezone: "2025-10-27 17:54:41.715" (treats as UTC)
   *
   * Returns null if:
   * - Input is null or undefined
   * - Input is empty string
   * - Parsing fails
   *
   * @param utcString - UTC timestamp string (nullable)
   * @returns Local Date object or null
   *
   * @example
   * const date = DateTimeUtils.toLocalSafe(json.updated_at);
   * if (date) {
   *   console.log('Updated:', DateTimeUtils.format(date));
   * }
   */
  static toLocalSafe(utcString?: string | null): Date | null {
    if (!utcString || utcString.trim() === '') return null;
    try {
      return this.toLocal(utcString);
    } catch (error) {
      console.error('Failed to parse date:', utcString, error);
      return null;
    }
  }

  /**
   * Converts Date to date-only string (yyyy-MM-dd)
   *
   * 중요: 타임존 변환을 하지 않습니다!
   * 날짜만 필요한 경우 사용하세요 (예: 생일, 계약일)
   *
   * @param date - Date object
   * @returns Date string in yyyy-MM-dd format
   *
   * @example
   * const birthday = new Date(1990, 4, 15); // May 15, 1990
   * DateTimeUtils.toDateOnly(birthday); // "1990-05-15"
   *
   * // ❌ 이렇게 하면 날짜가 바뀔 수 있음:
   * birthday.toISOString().split('T')[0];
   *
   * // ✅ 이렇게 해야 함:
   * DateTimeUtils.toDateOnly(birthday);
   */
  static toDateOnly(date: Date): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  /**
   * Converts Date to Supabase RPC format (yyyy-MM-dd HH:mm:ss in UTC)
   *
   * Supabase의 일부 RPC 함수는 특정 포맷을 요구합니다.
   * 이 함수는 UTC로 변환 후 RPC 포맷으로 변환합니다.
   *
   * @param date - Local Date object
   * @returns UTC timestamp in Supabase RPC format
   *
   * @example
   * const now = new Date(); // 2025-01-15 14:30:00 (KST +9)
   * DateTimeUtils.toRpcFormat(now); // "2025-01-15 05:30:00" (UTC)
   *
   * await supabase.rpc('insert_cashier_amount_lines', {
   *   p_created_at: DateTimeUtils.toRpcFormat(new Date())
   * });
   */
  static toRpcFormat(date: Date): string {
    const utcString = date.toISOString();
    // Convert "2025-01-15T05:30:00.000Z" to "2025-01-15 05:30:00"
    return utcString.replace('T', ' ').split('.')[0];
  }

  /**
   * Formats Date for display on screen (yyyy-MM-dd HH:mm)
   *
   * 로컬 시간으로 표시됩니다.
   *
   * @param date - Local Date object
   * @returns Formatted string
   *
   * @example
   * const utcString = "2025-01-15T05:30:00.000Z"; // from DB
   * const local = DateTimeUtils.toLocal(utcString);
   * console.log(DateTimeUtils.format(local));
   * // Korea: "2025-01-15 14:30"
   * // Vietnam: "2025-01-15 12:30"
   */
  static format(date: Date): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    return `${year}-${month}-${day} ${hours}:${minutes}`;
  }

  /**
   * Formats Date with custom Intl.DateTimeFormat options
   *
   * @param date - Date object
   * @param options - Intl.DateTimeFormat options
   * @param locale - Locale string (default: 'ko-KR')
   * @returns Formatted string
   *
   * @example
   * const now = new Date();
   * DateTimeUtils.formatCustom(now, { dateStyle: 'long' }); // "2025년 1월 15일"
   * DateTimeUtils.formatCustom(now, { timeStyle: 'short' }); // "오후 2:30"
   * DateTimeUtils.formatCustom(now, { dateStyle: 'medium', timeStyle: 'short' }, 'en-US');
   * // "Jan 15, 2025, 2:30 PM"
   */
  static formatCustom(
    date: Date,
    options: Intl.DateTimeFormatOptions = {},
    locale: string = 'ko-KR'
  ): string {
    return new Intl.DateTimeFormat(locale, options).format(date);
  }

  /**
   * Formats date-only display (yyyy-MM-dd)
   *
   * @param date - Date object
   * @returns Date string
   *
   * @example
   * const date = new Date();
   * DateTimeUtils.formatDateOnly(date); // "2025-01-15"
   */
  static formatDateOnly(date: Date): string {
    return this.toDateOnly(date);
  }

  /**
   * Formats time-only display (HH:mm)
   *
   * @param date - Date object
   * @returns Time string
   *
   * @example
   * const time = new Date();
   * DateTimeUtils.formatTimeOnly(time); // "14:30"
   */
  static formatTimeOnly(date: Date): string {
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    return `${hours}:${minutes}`;
  }

  /**
   * Formats date with relative time (e.g., "2 hours ago", "yesterday")
   *
   * @param date - Date object
   * @param locale - Locale string (default: 'ko-KR')
   * @returns Relative time string
   *
   * @example
   * const now = new Date();
   * const twoHoursAgo = new Date(now.getTime() - 2 * 60 * 60 * 1000);
   * DateTimeUtils.formatRelative(twoHoursAgo); // "2시간 전"
   * DateTimeUtils.formatRelative(twoHoursAgo, 'en-US'); // "2 hours ago"
   */
  static formatRelative(date: Date, locale: string = 'ko-KR'): string {
    const now = new Date();
    const diffMs = now.getTime() - date.getTime();
    const diffSec = Math.floor(diffMs / 1000);
    const diffMin = Math.floor(diffSec / 60);
    const diffHour = Math.floor(diffMin / 60);
    const diffDay = Math.floor(diffHour / 24);

    const rtf = new Intl.RelativeTimeFormat(locale, { numeric: 'auto' });

    if (diffSec < 60) {
      return rtf.format(-diffSec, 'second');
    } else if (diffMin < 60) {
      return rtf.format(-diffMin, 'minute');
    } else if (diffHour < 24) {
      return rtf.format(-diffHour, 'hour');
    } else if (diffDay < 30) {
      return rtf.format(-diffDay, 'day');
    } else {
      return this.format(date);
    }
  }

  /**
   * Checks if two dates are on the same day (ignores time)
   *
   * @param date1 - First date
   * @param date2 - Second date
   * @returns True if same day
   *
   * @example
   * const date1 = new Date('2025-01-15 10:00:00');
   * const date2 = new Date('2025-01-15 20:00:00');
   * DateTimeUtils.isSameDay(date1, date2); // true
   */
  static isSameDay(date1: Date, date2: Date): boolean {
    return (
      date1.getFullYear() === date2.getFullYear() &&
      date1.getMonth() === date2.getMonth() &&
      date1.getDate() === date2.getDate()
    );
  }

  /**
   * Adds days to a date
   *
   * @param date - Base date
   * @param days - Number of days to add (can be negative)
   * @returns New date
   *
   * @example
   * const today = new Date('2025-01-15');
   * const tomorrow = DateTimeUtils.addDays(today, 1); // 2025-01-16
   * const yesterday = DateTimeUtils.addDays(today, -1); // 2025-01-14
   */
  static addDays(date: Date, days: number): Date {
    const result = new Date(date);
    result.setDate(result.getDate() + days);
    return result;
  }

  /**
   * Gets start of day (00:00:00.000)
   *
   * @param date - Date object
   * @returns Date at start of day
   *
   * @example
   * const now = new Date('2025-01-15 14:30:00');
   * DateTimeUtils.startOfDay(now); // 2025-01-15 00:00:00
   */
  static startOfDay(date: Date): Date {
    const result = new Date(date);
    result.setHours(0, 0, 0, 0);
    return result;
  }

  /**
   * Gets end of day (23:59:59.999)
   *
   * @param date - Date object
   * @returns Date at end of day
   *
   * @example
   * const now = new Date('2025-01-15 14:30:00');
   * DateTimeUtils.endOfDay(now); // 2025-01-15 23:59:59.999
   */
  static endOfDay(date: Date): Date {
    const result = new Date(date);
    result.setHours(23, 59, 59, 999);
    return result;
  }

  /**
   * Formats date for dashboard transactions (Nov 1, 12:00 AM)
   *
   * @param dateString - Date string (ISO or any format parseable by Date)
   * @returns Formatted string (e.g., "Nov 1, 12:00 AM")
   *
   * @example
   * DateTimeUtils.formatTransactionDate("2025-01-15T14:30:00.000Z");
   * // "Jan 15, 2:30 PM"
   */
  static formatTransactionDate(dateString: string): string {
    try {
      const date = new Date(dateString);

      // Check if date is valid
      if (isNaN(date.getTime())) {
        return 'Invalid Date';
      }

      // Format: Nov 1, 12:00 AM
      const options: Intl.DateTimeFormatOptions = {
        month: 'short',
        day: 'numeric',
        hour: 'numeric',
        minute: '2-digit',
        hour12: true,
      };

      return date.toLocaleString('en-US', options);
    } catch (error) {
      console.error('Date formatting error:', error);
      return 'Invalid Date';
    }
  }
}
