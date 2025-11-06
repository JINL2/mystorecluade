/**
 * OverviewCard Component
 * Displays financial metric overview card with icon and change indicator
 */

import React from 'react';
import type { OverviewCardProps } from './OverviewCard.types';
import styles from './OverviewCard.module.css';

export const OverviewCard: React.FC<OverviewCardProps> = ({
  title,
  value,
  icon,
  changePercentage,
  isPositive = true,
  loading = false,
}) => {
  const renderChangeIndicator = () => {
    if (changePercentage === undefined || changePercentage === null) return null;

    const changeClass = isPositive ? styles.positive : styles.negative;
    const arrow = isPositive ? '↑' : '↓';

    return (
      <div className={`${styles.change} ${changeClass}`}>
        <span className={styles.arrow}>{arrow}</span>
        <span>{Math.abs(changePercentage).toFixed(1)}%</span>
      </div>
    );
  };

  if (loading) {
    return (
      <div className={styles.card}>
        <div className={styles.header}>
          <div className={styles.iconWrapper}>{icon}</div>
          <div className={styles.title}>{title}</div>
        </div>
        <div className={styles.value}>
          <div className={styles.skeleton}></div>
        </div>
      </div>
    );
  }

  return (
    <div className={styles.card}>
      <div className={styles.header}>
        <div className={styles.iconWrapper}>{icon}</div>
        <div className={styles.title}>{title}</div>
      </div>
      <div className={styles.value}>{value}</div>
      {renderChangeIndicator()}
    </div>
  );
};

export default OverviewCard;
