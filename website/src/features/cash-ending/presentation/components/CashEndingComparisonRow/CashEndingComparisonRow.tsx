/**
 * CashEndingComparisonRow Component
 * Side-by-side comparison of expected balance vs actual cash
 */

import React from 'react';
import {
  LocationIcon,
  getLocationTypeFromName,
  getLocationIconBackground,
  getLocationIconColor,
  getLocationTypeBadgeBackground,
  getLocationTypeBadgeColor,
  getLocationTypeLabel,
} from '../LocationIcon';
import type { CashEndingComparisonRowProps } from './CashEndingComparisonRow.types';
import styles from './CashEndingComparisonRow.module.css';

export const CashEndingComparisonRow: React.FC<CashEndingComparisonRowProps> = ({
  cashEndingId,
  locationName,
  expectedBalance,
  actualBalance,
  status,
  formatCurrency,
}) => {
  const locationType = getLocationTypeFromName(locationName);
  const hasActual = actualBalance > 0 || status === 'completed';

  return (
    <div className={styles.comparisonRow}>
      {/* Balance Column */}
      <div className={styles.balanceCard}>
        <div className={styles.locationHeader}>
          <div
            className={styles.locationIconWrap}
            style={{
              background: getLocationIconBackground(locationType),
              color: getLocationIconColor(locationType),
            }}
          >
            <LocationIcon type={locationType} size={20} />
          </div>
          <div className={styles.locationDetails}>
            <div className={styles.locationName}>{locationName}</div>
            <div className={styles.locationType}>From Balance Sheet</div>
          </div>
          <div
            className={styles.locationTypeBadge}
            style={{
              backgroundColor: getLocationTypeBadgeBackground(locationType),
              color: getLocationTypeBadgeColor(locationType),
            }}
          >
            {getLocationTypeLabel(locationType)}
          </div>
        </div>
        <div className={styles.balanceAmount}>{formatCurrency(expectedBalance)}</div>
      </div>

      {/* Actual Column */}
      <div className={`${styles.actualCard} ${!hasActual ? styles.notSet : ''}`}>
        <div className={styles.locationHeader}>
          <div
            className={styles.locationIconWrap}
            style={{
              background: getLocationIconBackground(locationType),
              color: getLocationIconColor(locationType),
            }}
          >
            <LocationIcon type={locationType} size={20} />
          </div>
          <div className={styles.locationDetails}>
            <div className={styles.locationName}>{locationName}</div>
            <div className={`${styles.locationType} ${!hasActual ? styles.notSetLabel : ''}`}>
              {hasActual ? 'Not updated today' : 'NOT SET'}
            </div>
          </div>
          <div
            className={styles.locationTypeBadge}
            style={{
              backgroundColor: getLocationTypeBadgeBackground(locationType),
              color: getLocationTypeBadgeColor(locationType),
            }}
          >
            {getLocationTypeLabel(locationType)}
          </div>
        </div>
        <div className={`${styles.actualAmountDisplay} ${!hasActual ? styles.pending : ''}`}>
          {formatCurrency(actualBalance)}
        </div>
      </div>
    </div>
  );
};
