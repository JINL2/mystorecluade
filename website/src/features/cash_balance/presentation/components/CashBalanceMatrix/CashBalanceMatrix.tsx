/**
 * CashBalanceMatrix Component
 * Spreadsheet-style view of cash balances by date and location
 */

import React, { useMemo } from 'react';
import type { CashBalanceMatrixProps } from './CashBalanceMatrix.types';
import styles from './CashBalanceMatrix.module.css';

export const CashBalanceMatrix: React.FC<CashBalanceMatrixProps> = ({
  locations,
  entries,
  dates,
  formatCurrency,
}) => {
  // Build a lookup map for entries: date|locationId -> { in, out }
  const entryMap = useMemo(() => {
    const map = new Map<string, { in: number; out: number }>();

    entries.forEach(entry => {
      const key = `${entry.date}|${entry.locationId}`;
      const existing = map.get(key) || { in: 0, out: 0 };
      existing.in += entry.inAmount;
      existing.out += entry.outAmount;
      map.set(key, existing);
    });

    return map;
  }, [entries]);

  // Calculate totals per location
  const locationTotals = useMemo(() => {
    const totals = new Map<string, { in: number; out: number }>();

    locations.forEach(loc => {
      totals.set(loc.locationId, { in: 0, out: 0 });
    });

    entries.forEach(entry => {
      const existing = totals.get(entry.locationId) || { in: 0, out: 0 };
      existing.in += entry.inAmount;
      existing.out += entry.outAmount;
      totals.set(entry.locationId, existing);
    });

    return totals;
  }, [locations, entries]);

  const formatDate = (dateStr: string): string => {
    const date = new Date(dateStr);
    return `${date.getMonth() + 1}/${date.getDate()}`;
  };

  const renderAmountCell = (inAmount: number, outAmount: number, currencyCode: string) => {
    if (inAmount === 0 && outAmount === 0) {
      return <span className={styles.emptyCell}>-</span>;
    }

    return (
      <div className={styles.amountCell}>
        {inAmount > 0 && (
          <span className={styles.amountIn}>
            {formatCurrency(inAmount, currencyCode)}
          </span>
        )}
        {outAmount > 0 && (
          <span className={styles.amountOut}>
            -{formatCurrency(outAmount, currencyCode)}
          </span>
        )}
      </div>
    );
  };

  return (
    <div className={styles.matrixContainer}>
      <table className={styles.matrixTable}>
        <thead>
          <tr>
            <th>DATE</th>
            {locations.map(loc => (
              <th key={loc.locationId}>
                <div className={styles.columnHeader}>
                  <span className={styles.columnName}>{loc.locationName}</span>
                  <span className={styles.columnCurrency}>{loc.currencyCode}</span>
                </div>
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {dates.map(date => (
            <tr key={date}>
              <td className={styles.dateCell}>{formatDate(date)}</td>
              {locations.map(loc => {
                const key = `${date}|${loc.locationId}`;
                const entry = entryMap.get(key) || { in: 0, out: 0 };
                return (
                  <td key={loc.locationId}>
                    {renderAmountCell(entry.in, entry.out, loc.currencyCode)}
                  </td>
                );
              })}
            </tr>
          ))}
          {/* Total Row */}
          <tr className={styles.totalRow}>
            <td>TOTAL</td>
            {locations.map(loc => {
              const totals = locationTotals.get(loc.locationId) || { in: 0, out: 0 };
              return (
                <td key={loc.locationId}>
                  {renderAmountCell(totals.in, totals.out, loc.currencyCode)}
                </td>
              );
            })}
          </tr>
        </tbody>
      </table>
    </div>
  );
};

export default CashBalanceMatrix;
