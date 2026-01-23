/**
 * SupplyChainPage Component
 * Supply chain risk analysis with Error Integral methodology
 */

import React from 'react';
import { useNavigate } from 'react-router-dom';
import { Navbar } from '@/shared/components/common/Navbar';
import type { SupplyChainPageProps, SupplyChainProduct, RiskLevel } from './SupplyChainPage.types';
import styles from './SupplyChainPage.module.css';

// Mock data for UI development
const mockProducts: SupplyChainProduct[] = [
  { id: '1', name: 'Premium Widget A', category: 'Electronics', shortageDays: 15, avgShortagePerDay: 8.5, totalShortage: 128, errorIntegral: 127.5, riskLevel: 'critical' },
  { id: '2', name: 'Standard Component B', category: 'Hardware', shortageDays: 12, avgShortagePerDay: 6.2, totalShortage: 74, errorIntegral: 74.4, riskLevel: 'critical' },
  { id: '3', name: 'Basic Part C', category: 'Accessories', shortageDays: 8, avgShortagePerDay: 5.0, totalShortage: 40, errorIntegral: 40.0, riskLevel: 'warning' },
  { id: '4', name: 'Module D Pro', category: 'Electronics', shortageDays: 6, avgShortagePerDay: 4.3, totalShortage: 26, errorIntegral: 25.8, riskLevel: 'warning' },
  { id: '5', name: 'Connector E Plus', category: 'Hardware', shortageDays: 4, avgShortagePerDay: 3.0, totalShortage: 12, errorIntegral: 12.0, riskLevel: 'normal' },
];

const getRiskLabel = (level: RiskLevel): string => {
  switch (level) {
    case 'critical': return 'Critical';
    case 'warning': return 'Warning';
    case 'normal': return 'Normal';
    default: return level;
  }
};

const getRankClass = (index: number): string => {
  if (index === 0) return styles.rank1;
  if (index === 1) return styles.rank2;
  if (index === 2) return styles.rank3;
  return styles.rankOther;
};

export const SupplyChainPage: React.FC<SupplyChainPageProps> = () => {
  const navigate = useNavigate();

  const criticalCount = mockProducts.filter(p => p.riskLevel === 'critical').length;
  const warningCount = mockProducts.filter(p => p.riskLevel === 'warning').length;
  const overallStatus = criticalCount > 0 ? 'critical' : warningCount > 0 ? 'warning' : 'good';

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
              <span className={styles.breadcrumbCurrent}>Supply Chain</span>
            </div>
            <h1 className={styles.title}>Supply Chain Risk</h1>
            <p className={styles.subtitle}>Identify products with recurring shortage issues using Error Integral analysis</p>
          </div>

          {/* Status Summary */}
          <div className={styles.statusSummary}>
            <div className={`${styles.statusCard} ${styles.overall}`}>
              <p className={styles.statusLabel}>Total Risk Products</p>
              <p className={styles.statusValue}>{mockProducts.length}</p>
            </div>
            <div className={`${styles.statusCard} ${styles.critical}`}>
              <p className={styles.statusLabel}>Critical</p>
              <p className={styles.statusValue}>{criticalCount}</p>
              <p className={styles.statusText}>Immediate action needed</p>
            </div>
            <div className={`${styles.statusCard} ${styles.warning}`}>
              <p className={styles.statusLabel}>Warning</p>
              <p className={styles.statusValue}>{warningCount}</p>
              <p className={styles.statusText}>Monitor closely</p>
            </div>
          </div>

          {/* Content */}
          <div className={styles.content}>
            <div className={styles.card}>
              <div className={styles.cardHeader}>
                <h2 className={styles.cardTitle}>Risk Products by Error Integral</h2>
                <button className={styles.cardAction}>Export</button>
              </div>

              {/* Info Banner */}
              <div className={styles.infoBanner}>
                <svg className={styles.infoIcon} viewBox="0 0 24 24" fill="currentColor">
                  <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/>
                </svg>
                <p className={styles.infoText}>
                  <span className={styles.infoFormula}>Error Integral = Shortage Days × Avg. Shortage Per Day</span>
                  <br />
                  Higher values indicate more severe and persistent supply chain issues.
                </p>
              </div>

              {mockProducts.length > 0 ? (
                <ul className={styles.productList}>
                  {mockProducts.map((product, index) => (
                    <li key={product.id} className={styles.productItem}>
                      <span className={`${styles.productRank} ${getRankClass(index)}`}>
                        {index + 1}
                      </span>
                      <div className={styles.productInfo}>
                        <p className={styles.productName}>{product.name}</p>
                        <p className={styles.productCategory}>{product.category}</p>
                      </div>
                      <div className={styles.productMetrics}>
                        <div className={styles.metricItem}>
                          <p className={styles.metricValue}>{product.shortageDays}</p>
                          <p className={styles.metricLabel}>Days</p>
                        </div>
                        <div className={styles.metricItem}>
                          <p className={styles.metricValue}>{product.avgShortagePerDay.toFixed(1)}</p>
                          <p className={styles.metricLabel}>Avg/Day</p>
                        </div>
                        <div className={styles.metricItem}>
                          <p className={styles.metricValue}>{product.errorIntegral.toFixed(1)}</p>
                          <p className={styles.metricLabel}>Error Integral</p>
                        </div>
                      </div>
                      <span className={`${styles.riskBadge} ${styles[product.riskLevel]}`}>
                        {getRiskLabel(product.riskLevel)}
                      </span>
                    </li>
                  ))}
                </ul>
              ) : (
                <div className={styles.emptyState}>
                  <svg className={styles.emptyIcon} viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12,2A10,10 0 0,1 22,12A10,10 0 0,1 12,22A10,10 0 0,1 2,12A10,10 0 0,1 12,2M12,4A8,8 0 0,0 4,12A8,8 0 0,0 12,20A8,8 0 0,0 20,12A8,8 0 0,0 12,4M11,16.5L6.5,12L7.91,10.59L11,13.67L16.59,8.09L18,9.5L11,16.5Z" />
                  </svg>
                  <p className={styles.emptyTitle}>No Supply Chain Issues</p>
                  <p className={styles.emptyText}>All products have healthy supply levels</p>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default SupplyChainPage;
