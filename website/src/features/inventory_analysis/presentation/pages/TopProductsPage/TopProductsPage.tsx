/**
 * TopProductsPage Component
 * Web-optimized table layout for products
 */

import React, { useState, useMemo, useCallback } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { Navbar } from '@/shared/components/common/Navbar';
import { useAppState } from '@/app/providers/app_state_provider';
import { useSalesAnalytics } from '../../hooks/useSalesAnalytics';
import { useBaseCurrency } from '../../hooks/useBaseCurrency';
import type { TopProductsPageProps } from './TopProductsPage.types';
import type { SalesAnalyticsItem, SalesMetric } from '../../../domain/entities/salesAnalytics';
import styles from './TopProductsPage.module.css';

// Get metric value based on selected metric
const getMetricValue = (item: SalesAnalyticsItem, metric: SalesMetric): number => {
  switch (metric) {
    case 'revenue':
      return item.totalRevenue;
    case 'margin':
      return item.totalMargin;
    case 'quantity':
      return item.totalQuantity;
    default:
      return item.totalRevenue;
  }
};

// Get growth value based on selected metric
const getGrowthValue = (item: SalesAnalyticsItem, metric: SalesMetric): number | null => {
  switch (metric) {
    case 'revenue':
      return item.revenueGrowth;
    case 'margin':
      return item.marginGrowth;
    case 'quantity':
      return item.quantityGrowth;
    default:
      return item.revenueGrowth;
  }
};

// Format currency value
const formatCurrency = (value: number, symbol: string): string => {
  if (value >= 1000000000) {
    return `${symbol}${(value / 1000000000).toFixed(1)}B`;
  } else if (value >= 1000000) {
    return `${symbol}${(value / 1000000).toFixed(1)}M`;
  } else if (value >= 1000) {
    return `${symbol}${(value / 1000).toFixed(1)}K`;
  }
  return `${symbol}${value.toFixed(0)}`;
};

// Format number value
const formatNumber = (value: number): string => {
  if (value >= 1000000) {
    return `${(value / 1000000).toFixed(1)}M`;
  } else if (value >= 1000) {
    return `${(value / 1000).toFixed(1)}K`;
  }
  return value.toFixed(0);
};

// Get rank class
const getRankClass = (rank: number): string => {
  switch (rank) {
    case 1:
      return styles.rank1;
    case 2:
      return styles.rank2;
    case 3:
      return styles.rank3;
    default:
      return styles.rankOther;
  }
};

// Get progress fill class
const getProgressFillClass = (rank: number): string => {
  switch (rank) {
    case 1:
      return styles.fill1;
    case 2:
      return styles.fill2;
    case 3:
      return styles.fill3;
    default:
      return styles.fillOther;
  }
};

export const TopProductsPage: React.FC<TopProductsPageProps> = () => {
  const navigate = useNavigate();
  const [searchParams, setSearchParams] = useSearchParams();
  const metricParam = searchParams.get('metric') as SalesMetric | null;
  const metric: SalesMetric = metricParam || 'revenue';

  const { currentCompany, currentStore } = useAppState();
  const companyId = currentCompany?.company_id;
  const storeId = currentStore?.store_id || undefined;

  const [searchQuery, setSearchQuery] = useState('');

  // Fetch top products data
  const { data: salesData, loading } = useSalesAnalytics(
    companyId,
    storeId,
    undefined,
    {
      dimension: 'product',
      metric,
      topN: 100,
    }
  );

  // Get currency symbol
  const { currencySymbol } = useBaseCurrency(companyId);

  // Filter products by search
  const filteredProducts = useMemo(() => {
    if (!salesData || !salesData.success) return [];

    const products = salesData.data;
    if (!searchQuery) return products;

    const query = searchQuery.toLowerCase();
    return products.filter((product) =>
      product.dimensionName.toLowerCase().includes(query)
    );
  }, [salesData, searchQuery]);

  // Get max value for progress bar
  const maxValue = useMemo(() => {
    if (filteredProducts.length === 0) return 1;
    return getMetricValue(filteredProducts[0], metric);
  }, [filteredProducts, metric]);

  // Format value based on metric
  const formatValue = useCallback(
    (value: number): string => {
      if (metric === 'quantity') {
        return formatNumber(value);
      }
      return formatCurrency(value, currencySymbol);
    },
    [metric, currencySymbol]
  );

  // Handle search input
  const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setSearchQuery(e.target.value);
  };

  // Handle metric change
  const handleMetricChange = (newMetric: SalesMetric) => {
    setSearchParams({ metric: newMetric });
  };

  // Get metric label
  const getMetricLabel = (m: SalesMetric): string => {
    switch (m) {
      case 'revenue':
        return 'Revenue';
      case 'margin':
        return 'Margin';
      case 'quantity':
        return 'Quantity';
      default:
        return 'Revenue';
    }
  };

  return (
    <>
      <Navbar activeItem="analysis" />
      <div className={styles.pageWrapper}>
        <div className={styles.pageLayout}>
          <div className={styles.mainContent}>
            <div className={styles.container}>
              {/* Header */}
              <div className={styles.header}>
                <div className={styles.breadcrumb}>
                  <a
                    href="/analysis/sales-analysis"
                    className={styles.breadcrumbLink}
                    onClick={(e) => {
                      e.preventDefault();
                      navigate('/analysis/sales-analysis');
                    }}
                  >
                    Sales Analysis
                  </a>
                  <span className={styles.breadcrumbSeparator}>/</span>
                  <span className={styles.breadcrumbCurrent}>Top Products</span>
                </div>
                <h1 className={styles.title}>Top Products</h1>
                <p className={styles.subtitle}>
                  Product performance ranking by {getMetricLabel(metric).toLowerCase()}
                </p>
              </div>

              {/* Controls Bar */}
              <div className={styles.controlsBar}>
                <div className={styles.controlsLeft}>
                  {/* Search Bar */}
                  <div className={styles.searchBar}>
                    <svg
                      className={styles.searchIcon}
                      width="20"
                      height="20"
                      viewBox="0 0 24 24"
                      fill="currentColor"
                    >
                      <path d="M9.5,3A6.5,6.5 0 0,1 16,9.5C16,11.11 15.41,12.59 14.44,13.73L14.71,14H15.5L20.5,19L19,20.5L14,15.5V14.71L13.73,14.44C12.59,15.41 11.11,16 9.5,16A6.5,6.5 0 0,1 3,9.5A6.5,6.5 0 0,1 9.5,3M9.5,5C7,5 5,7 5,9.5C5,12 7,14 9.5,14C12,14 14,12 14,9.5C14,7 12,5 9.5,5Z" />
                    </svg>
                    <input
                      type="text"
                      className={styles.searchInput}
                      placeholder="Search products..."
                      value={searchQuery}
                      onChange={handleSearchChange}
                    />
                  </div>

                  {/* Metric Tabs */}
                  <div className={styles.metricTabs}>
                    {(['revenue', 'margin', 'quantity'] as SalesMetric[]).map((m) => (
                      <button
                        key={m}
                        className={`${styles.metricTab} ${metric === m ? styles.active : ''}`}
                        onClick={() => handleMetricChange(m)}
                      >
                        {getMetricLabel(m)}
                      </button>
                    ))}
                  </div>
                </div>
              </div>

              {/* Info Bar */}
              <div className={styles.infoBar}>
                <div className={styles.infoLeft}>
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M3,13H5V11H3V13M3,17H5V15H3V17M3,9H5V7H3V9M7,13H21V11H7V13M7,17H21V15H7V17M7,7V9H21V7H7Z" />
                  </svg>
                  <span>Sorted by {getMetricLabel(metric)}</span>
                </div>
                <span className={styles.infoCount}>{filteredProducts.length} products</span>
              </div>

              {/* Content Card with Table */}
              <div className={styles.contentCard}>
                {loading ? (
                  <div className={styles.loadingState}>
                    <div className={styles.spinner} />
                    <span className={styles.loadingText}>Loading products...</span>
                  </div>
                ) : filteredProducts.length === 0 ? (
                  <div className={styles.emptyState}>
                    <svg
                      width="48"
                      height="48"
                      viewBox="0 0 24 24"
                      fill="currentColor"
                      className={styles.emptyIcon}
                    >
                      <path d="M15.5,12C18,12 20,14 20,16.5C20,17.38 19.75,18.21 19.31,18.9L22.39,22L21,23.39L17.88,20.32C17.19,20.75 16.37,21 15.5,21C13,21 11,19 11,16.5C11,14 13,12 15.5,12M15.5,14A2.5,2.5 0 0,0 13,16.5A2.5,2.5 0 0,0 15.5,19A2.5,2.5 0 0,0 18,16.5A2.5,2.5 0 0,0 15.5,14M5,3H19C20.1,3 21,3.9 21,5V13.35C20.36,12.77 19.57,12.33 18.68,12.11L19,12V5H5V19H9.29C9.58,19.75 10,20.42 10.54,21H5C3.9,21 3,20.1 3,19V5C3,3.9 3.9,3 5,3Z" />
                    </svg>
                    <p className={styles.emptyText}>No products found</p>
                    {searchQuery && (
                      <p className={styles.emptyHint}>Try a different search term</p>
                    )}
                  </div>
                ) : (
                  <table className={styles.productTable}>
                    <thead>
                      <tr>
                        <th className={styles.colRank}>Rank</th>
                        <th className={styles.colProduct}>Product</th>
                        <th className={styles.colValue}>{getMetricLabel(metric)}</th>
                        <th className={styles.colGrowth}>Growth</th>
                        <th className={styles.colShare}>Share</th>
                      </tr>
                    </thead>
                    <tbody>
                      {filteredProducts.map((product, index) => {
                        const rank = index + 1;
                        const value = getMetricValue(product, metric);
                        const growth = getGrowthValue(product, metric);
                        const shareRatio = maxValue > 0 ? value / maxValue : 0;
                        const sharePercent = (shareRatio * 100).toFixed(1);

                        return (
                          <tr key={product.dimensionId}>
                            <td className={styles.rankCell}>
                              <span className={`${styles.rankBadge} ${getRankClass(rank)}`}>
                                {rank}
                              </span>
                            </td>
                            <td className={styles.productCell}>{product.dimensionName}</td>
                            <td className={styles.valueCell}>{formatValue(value)}</td>
                            <td className={styles.growthCell}>
                              {growth !== null && (
                                <span
                                  className={`${styles.growthBadge} ${
                                    growth >= 0 ? styles.positive : styles.negative
                                  }`}
                                >
                                  {growth >= 0 ? '\u2191' : '\u2193'}{' '}
                                  {Math.abs(growth).toFixed(1)}%
                                </span>
                              )}
                            </td>
                            <td className={styles.shareCell}>
                              <div className={styles.progressContainer}>
                                <div className={styles.progressBar}>
                                  <div
                                    className={`${styles.progressFill} ${getProgressFillClass(rank)}`}
                                    style={{ width: `${Math.min(100, shareRatio * 100)}%` }}
                                  />
                                </div>
                                <span className={styles.sharePercent}>{sharePercent}%</span>
                              </div>
                            </td>
                          </tr>
                        );
                      })}
                    </tbody>
                  </table>
                )}
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default TopProductsPage;
