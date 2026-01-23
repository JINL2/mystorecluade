/**
 * WeekNavigator Component
 * Navigation controls for week-based schedule view
 */

import React from 'react';
import { TossButton } from '@/shared/components/toss/TossButton';
import type { WeekNavigatorProps } from './WeekNavigator.types';
import styles from './WeekNavigator.module.css';

export const WeekNavigator: React.FC<WeekNavigatorProps> = ({
  weekDisplay,
  onPreviousWeek,
  onNextWeek,
  onCurrentWeek,
}) => {
  return (
    <div className={styles.weekNavigator}>
      <TossButton variant="outline" size="sm" onClick={onPreviousWeek}>
        ◀ Previous Week
      </TossButton>
      <div className={styles.weekDisplay}>{weekDisplay}</div>
      <TossButton variant="outline" size="sm" onClick={onNextWeek}>
        Next Week ▶
      </TossButton>
      <TossButton variant="outline" size="sm" onClick={onCurrentWeek}>
        This Week
      </TossButton>
    </div>
  );
};

export default WeekNavigator;
