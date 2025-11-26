/**
 * WeekNavigator Component Types
 */

export interface WeekNavigatorProps {
  /**
   * Display text for current week range
   */
  weekDisplay: string;

  /**
   * Navigate to previous week
   */
  onPreviousWeek: () => void;

  /**
   * Navigate to next week
   */
  onNextWeek: () => void;

  /**
   * Navigate to current week
   */
  onCurrentWeek: () => void;
}
