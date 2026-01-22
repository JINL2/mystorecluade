/**
 * DiscrepancyPage Component
 * Inventory discrepancy analysis with store-level breakdown
 */

import React from 'react';
import { useNavigate } from 'react-router-dom';
import { Navbar } from '@/shared/components/common/Navbar';
import type { DiscrepancyPageProps, StoreDiscrepancy, DiscrepancyStatus } from './DiscrepancyPage.types';
import styles from './DiscrepancyPage.module.css';

// Mock data for UI development
const mockOverview = {
  status: 'ok' as const,
  totalIncreaseValue: 15420,
  totalDecreaseValue: 28350,
  netValue: -12930,
  totalStores: 5,
  totalEvents: 156,
  stores: [
    { storeId: '1', storeName: 'Downtown Store', totalEvents: 45, increaseCount: 12, decreaseCount: 33, increaseValue: 3200, decreaseValue: 8500, netValue: -5300, status: 'abnormal' as DiscrepancyStatus },
    { storeId: '2', storeName: 'Mall Location', totalEvents: 38, increaseCount: 15, decreaseCount: 23, increaseValue: 4800, decreaseValue: 6200, netValue: -1400, status: 'warning' as DiscrepancyStatus },
    { storeId: '3', storeName: 'Airport Branch', totalEvents: 32, increaseCount: 10, decreaseCount: 22, increaseValue: 2900, decreaseValue: 5800, netValue: -2900, status: 'warning' as DiscrepancyStatus },
    { storeId: '4', storeName: 'Suburb Outlet', totalEvents: 25, increaseCount: 14, decreaseCount: 11, increaseValue: 2520, decreaseValue: 4350, netValue: -1830, status: 'normal' as DiscrepancyStatus },
    { storeId: '5', storeName: 'Central Hub', totalEvents: 16, increaseCount: 9, decreaseCount: 7, increaseValue: 2000, decreaseValue: 3500, netValue: -1500, status: 'normal' as DiscrepancyStatus },
  ] as StoreDiscrepancy[],
};

const formatCurrency = (value: number): string => {
  const absValue = Math.abs(value);
  if (absValue >= 1000000) {
    return `$${(value / 1000000).toFixed(1)}M`;
  }
  if (absValue >= 1000) {
    return `$${(value / 1000).toFixed(1)}K`;
  }
  return `$${value.toFixed(0)}`;
};

const getStatusLabel = (status: DiscrepancyStatus): string => {
  switch (status) {
    case 'abnormal': return 'Anomaly';
    case 'warning': return 'Warning';
    case 'normal': return 'Normal';
    default: return status;
  }
};

const getAnalysisStatus = (netValue: number, decreaseValue: number): string => {
  if (decreaseValue === 0) return 'insufficient';
  const ratio = (netValue / decreaseValue) * 100;
  if (ratio < -10) return 'critical';
  if (ratio < -5) return 'warning';
  return 'good';
};

const getAnalysisStatusLabel = (status: string): string => {
  switch (status) {
    case 'critical': return 'Critical Loss';
    case 'warning': return 'Needs Attention';
    case 'good': return 'Healthy';
    case 'insufficient': return 'Insufficient Data';
    default: return status;
  }
};

export const DiscrepancyPage: React.FC<DiscrepancyPageProps> = () => {
  const navigate = useNavigate();

  const netRatio = mockOverview.totalDecreaseValue !== 0
    ? (mockOverview.netValue / mockOverview.totalDecreaseValue) * 100
    : null;
  const analysisStatus = getAnalysisStatus(mockOverview.netValue, mockOverview.totalDecreaseValue);
  const abnormalCount = mockOverview.stores.filter(s => s.status === 'abnormal').length;

  return (
    <>
      <Navbar activeItem="analysis" />
      <div className={styles.pageLayout}>
        <div className={styles.container}>
          {/* Header */}
          <div className={styles.header}>
            <div className={styles.breadcrumb}>
              <a href="/analysis/inventory-analysis" className={styles.breadcrumbLink} onClick={(e) => { e.preventDefault(); navigate('/analysis/inventory-analysis'); }}>
                Inventory Analysis
              </a>
              <span className={styles.breadcrumbSeparator}>/</span>
              <span className={styles.breadcrumbCurrent}>Discrepancy</span>
            </div>
            <h1 className={styles.title}>Inventory Discrepancy</h1>
            <p className={styles.subtitle}>Track and analyze inventory adjustments and losses across stores</p>
          </div>

          {mockOverview.status === 'ok' ? (
            <>
              {/* Overview Summary */}
              <div className={styles.overviewSummary}>
                <div className={styles.summaryCard}>
                  <p className={styles.summaryLabel}>Total Events</p>
                  <p className={`${styles.summaryValue} ${styles.neutral}`}>{mockOverview.totalEvents}</p>
                  <p className={styles.summarySubtext}>{mockOverview.totalStores} stores</p>
                </div>
                <div className={styles.summaryCard}>
                  <p className={styles.summaryLabel}>Increase Value</p>
                  <p className={`${styles.summaryValue} ${styles.positive}`}>+{formatCurrency(mockOverview.totalIncreaseValue)}</p>
                  <p className={styles.summarySubtext}>Found inventory</p>
                </div>
                <div className={styles.summaryCard}>
                  <p className={styles.summaryLabel}>Decrease Value</p>
                  <p className={`${styles.summaryValue} ${styles.negative}`}>-{formatCurrency(mockOverview.totalDecreaseValue)}</p>
                  <p className={styles.summarySubtext}>Lost inventory</p>
                </div>
                <div className={styles.summaryCard}>
                  <p className={styles.summaryLabel}>Abnormal Stores</p>
                  <p className={`${styles.summaryValue} ${abnormalCount > 0 ? styles.negative : styles.neutral}`}>{abnormalCount}</p>
                  <p className={styles.summarySubtext}>Statistical anomalies</p>
                </div>
              </div>

              {/* Net Value Card */}
              <div className={styles.netValueCard}>
                <div className={styles.netValueInfo}>
                  <p className={styles.netValueLabel}>Net Inventory Impact</p>
                  <p className={`${styles.netValueAmount} ${mockOverview.netValue >= 0 ? styles.positive : styles.negative}`}>
                    {mockOverview.netValue >= 0 ? '+' : ''}{formatCurrency(mockOverview.netValue)}
                  </p>
                  {netRatio !== null && (
                    <p className={styles.netValueRatio}>
                      {netRatio.toFixed(1)}% of total decrease value
                    </p>
                  )}
                </div>
                <span className={`${styles.statusBadgeLarge} ${styles[analysisStatus]}`}>
                  {getAnalysisStatusLabel(analysisStatus)}
                </span>
              </div>

              {/* Store Breakdown */}
              <div className={styles.content}>
                <div className={styles.card}>
                  <div className={styles.cardHeader}>
                    <h2 className={styles.cardTitle}>Store Breakdown</h2>
                    <button className={styles.cardAction}>Export Report</button>
                  </div>

                  {mockOverview.stores.length > 0 ? (
                    <ul className={styles.storeList}>
                      {mockOverview.stores.map((store) => (
                        <li key={store.storeId} className={styles.storeItem}>
                          <span className={`${styles.storeStatus} ${styles[store.status]}`} />
                          <div className={styles.storeInfo}>
                            <p className={styles.storeName}>{store.storeName}</p>
                            <p className={styles.storeEvents}>{store.totalEvents} events</p>
                          </div>
                          <div className={styles.storeMetrics}>
                            <div className={styles.metricItem}>
                              <p className={`${styles.metricValue} ${styles.positive}`}>+{formatCurrency(store.increaseValue)}</p>
                              <p className={styles.metricLabel}>Increase</p>
                            </div>
                            <div className={styles.metricItem}>
                              <p className={`${styles.metricValue} ${styles.negative}`}>-{formatCurrency(store.decreaseValue)}</p>
                              <p className={styles.metricLabel}>Decrease</p>
                            </div>
                            <div className={styles.metricItem}>
                              <p className={`${styles.metricValue} ${store.netValue >= 0 ? styles.positive : styles.negative}`}>
                                {store.netValue >= 0 ? '+' : ''}{formatCurrency(store.netValue)}
                              </p>
                              <p className={styles.metricLabel}>Net</p>
                            </div>
                          </div>
                          <span className={`${styles.statusBadge} ${styles[store.status]}`}>
                            {getStatusLabel(store.status)}
                          </span>
                        </li>
                      ))}
                    </ul>
                  ) : (
                    <div className={styles.emptyState}>
                      <svg className={styles.emptyIcon} viewBox="0 0 24 24" fill="currentColor">
                        <path d="M12,2A10,10 0 0,1 22,12A10,10 0 0,1 12,22A10,10 0 0,1 2,12A10,10 0 0,1 12,2M12,4A8,8 0 0,0 4,12A8,8 0 0,0 12,20A8,8 0 0,0 20,12A8,8 0 0,0 12,4M11,16.5L6.5,12L7.91,10.59L11,13.67L16.59,8.09L18,9.5L11,16.5Z" />
                      </svg>
                      <p className={styles.emptyTitle}>No Discrepancies</p>
                      <p className={styles.emptyText}>All stores have clean inventory records</p>
                    </div>
                  )}
                </div>
              </div>
            </>
          ) : (
            <div className={styles.insufficientState}>
              <svg className={styles.insufficientIcon} viewBox="0 0 24 24" fill="currentColor">
                <path d="M13,13H11V7H13M13,17H11V15H13M12,2A10,10 0 0,0 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2Z"/>
              </svg>
              <p className={styles.insufficientTitle}>Insufficient Data</p>
              <p className={styles.insufficientText}>
                Not enough inventory adjustment records to perform statistical analysis.<br />
                Continue recording inventory changes to enable discrepancy detection.
              </p>
            </div>
          )}
        </div>
      </div>
    </>
  );
};

export default DiscrepancyPage;
