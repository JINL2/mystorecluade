/**
 * JournalDate Value Object
 * Handles date formatting and conversion for journal entries
 * This keeps date logic within the domain layer
 */

export class JournalDate {
  /**
   * Get today's date in yyyy-MM-dd format
   */
  static today(): string {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  /**
   * Convert Date object to yyyy-MM-dd format
   */
  static toDateOnly(date: Date): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  /**
   * Convert date string (yyyy-MM-dd) to RPC format for database storage
   *
   * 중요: 날짜만 다루는 경우 타임존 변환을 하지 않습니다!
   * "2025-01-15" → "2025-01-15 00:00:00" (UTC)
   *
   * 이렇게 하면 전 세계 어디서든 동일한 날짜가 DB에 저장됩니다.
   *
   * @param dateString - Date in yyyy-MM-dd format
   * @returns UTC timestamp in RPC format (yyyy-MM-dd HH:mm:ss)
   */
  static toRpcFormat(dateString: string): string {
    // Parse date components (avoid timezone issues)
    const [year, month, day] = dateString.split('-').map(Number);

    // Create Date object in UTC (not local time!)
    const utcDate = new Date(Date.UTC(year, month - 1, day, 0, 0, 0, 0));

    // Convert to RPC format: "yyyy-MM-dd HH:mm:ss" in UTC
    const isoString = utcDate.toISOString();
    return isoString.replace('T', ' ').split('.')[0];
  }

  /**
   * Validate date string format (yyyy-MM-dd)
   */
  static isValid(dateString: string): boolean {
    if (!dateString || dateString.trim() === '') {
      return false;
    }

    const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
    if (!dateRegex.test(dateString)) {
      return false;
    }

    const date = new Date(dateString);
    return !isNaN(date.getTime());
  }

  /**
   * Format date for display (e.g., "January 15, 2025")
   */
  static formatDisplay(dateString: string): string {
    const date = new Date(dateString);
    return new Intl.DateTimeFormat('en-US', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    }).format(date);
  }

  /**
   * Format date for Korean display (e.g., "2025년 1월 15일")
   */
  static formatDisplayKo(dateString: string): string {
    const date = new Date(dateString);
    return new Intl.DateTimeFormat('ko-KR', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    }).format(date);
  }
}
