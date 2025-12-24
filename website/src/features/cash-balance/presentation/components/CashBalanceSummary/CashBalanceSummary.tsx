/**
 * CashBalanceSummary Component
 * Card-based view of cash location balances
 */

import React from 'react';
import type { CashBalanceSummaryProps } from './CashBalanceSummary.types';
import styles from './CashBalanceSummary.module.css';

const LocationIcons: Record<string, string> = {
  cash: '💵',
  vault: '🔐',
  bank: '🏦',
  digital_wallet: '📱',
};

export const CashBalanceSummary: React.FC<CashBalanceSummaryProps> = ({
  locations,
  formatCurrency,
}) => {
  if (locations.length === 0) {
    return (
      <div className={styles.emptyState}>
        <svg className={styles.emptyIcon} viewBox="0 0 24 24" fill="currentColor">
          <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
        </svg>
        <p className={styles.emptyText}>No cash locations found</p>
      </div>
    );
  }

  // Group locations by type
  const groupedLocations = locations.reduce((acc, loc) => {
    const type = loc.locationType;
    if (!acc[type]) acc[type] = [];
    acc[type].push(loc);
    return acc;
  }, {} as Record<string, typeof locations>);

  // Sort order for location types
  const typeOrder = ['cash', 'vault', 'bank', 'digital_wallet'];
  const sortedTypes = Object.keys(groupedLocations).sort(
    (a, b) => typeOrder.indexOf(a) - typeOrder.indexOf(b)
  );

  // Flatten back to sorted list
  const sortedLocations = sortedTypes.flatMap(type => groupedLocations[type]);

  const formatDate = (dateStr?: string): string => {
    if (!dateStr) return '';
    const date = new Date(dateStr);
    return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
  };

  // Mock change calculation (random for demo)
  const getRandomChange = () => {
    const change = Math.random() > 0.5 ? Math.random() * 1000000 : -Math.random() * 500000;
    return Math.round(change);
  };

  return (
    <div className={styles.summaryGrid}>
      {sortedLocations.map(location => {
        const change = getRandomChange();
        const isPositive = change >= 0;

        return (
          <div
            key={location.locationId}
            className={`${styles.locationCard} ${styles[location.locationType]}`}
          >
            {/* Currency Badge */}
            <span className={styles.currencyBadge}>{location.currencyCode}</span>

            {/* Header */}
            <div className={styles.locationHeader}>
              <div className={`${styles.locationIcon} ${styles[location.locationType]}`}>
                {LocationIcons[location.locationType] || '💰'}
              </div>
              <div className={styles.locationInfo}>
                <h3 className={styles.locationName}>{location.locationName}</h3>
                <p className={styles.locationType}>
                  {location.locationType.replace('_', ' ')}
                </p>
              </div>
            </div>

            {/* Balance */}
            <div className={styles.locationBalance}>
              {formatCurrency(location.currentBalance, location.currencyCode)}
            </div>

            {/* Change Indicator */}
            <div className={`${styles.locationChange} ${isPositive ? styles.positive : styles.negative}`}>
              <svg className={styles.changeIcon} viewBox="0 0 24 24" fill="currentColor">
                {isPositive ? (
                  <path d="M7 14l5-5 5 5z"/>
                ) : (
                  <path d="M7 10l5 5 5-5z"/>
                )}
              </svg>
              <span>
                {isPositive ? '+' : ''}{formatCurrency(Math.abs(change), location.currencyCode)} today
              </span>
            </div>

            {/* Last Updated */}
            {location.lastUpdated && (
              <div className={styles.lastUpdated}>
                Last updated: {formatDate(location.lastUpdated)}
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
};

export default CashBalanceSummary;
