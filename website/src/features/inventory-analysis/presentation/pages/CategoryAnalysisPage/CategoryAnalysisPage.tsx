/**
 * CategoryAnalysisPage Component
 * Web-optimized table layout with drill-down navigation
 */

import React, { useState, useMemo, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { Navbar } from '@/shared/components/common/Navbar';
import { useAppState } from '@/app/providers/app_state_provider';
import { useDrillDownAnalytics } from '../../hooks/useDrillDownAnalytics';
import { useBaseCurrency } from '../../hooks/useBaseCurrency';
import type { CategoryAnalysisPageProps } from './CategoryAnalysisPage.types';
import type { DrillDownItem } from '../../../domain/entities/drillDownAnalytics';
import styles from './CategoryAnalysisPage.module.css';

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

// Get level label
const getLevelLabel = (level: string): string => {
  switch (level) {
    case 'category':
      return 'Categories';
    case 'brand':
      return 'Brands';
    case 'product':
      return 'Products';
    default:
      return 'Items';
  }
};

export const CategoryAnalysisPage: React.FC<CategoryAnalysisPageProps> = () => {
  const navigate = useNavigate();
  const { currentCompany, currentStore } = useAppState();
  const companyId = currentCompany?.company_id;
  const storeId = currentStore?.store_id || undefined;

  const [searchQuery, setSearchQuery] = useState('');

  // Fetch drill down data
  const {
    data: drillDownData,
    loading,
    drillDown,
    currentLevel,
    breadcrumbs,
  } = useDrillDownAnalytics(companyId, storeId);

  // Get currency symbol
  const { currencySymbol } = useBaseCurrency(companyId);

  // Check if can drill down
  const canDrillDown = currentLevel !== 'product';

  // Filter and sort items by search and revenue
  const filteredItems = useMemo(() => {
    if (!drillDownData || !drillDownData.success) return [];

    let items = [...drillDownData.data].sort((a, b) => b.totalRevenue - a.totalRevenue);

    if (searchQuery) {
      const query = searchQuery.toLowerCase();
      items = items.filter((item) =>
        item.itemName.toLowerCase().includes(query)
      );
    }

    return items;
  }, [drillDownData, searchQuery]);

  // Get max revenue for progress bar
  const maxRevenue = useMemo(() => {
    if (filteredItems.length === 0) return 1;
    return filteredItems[0].totalRevenue;
  }, [filteredItems]);

  // Handle search input
  const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setSearchQuery(e.target.value);
  };

  // Handle breadcrumb click
  const handleBreadcrumbClick = useCallback((index: number) => {
    if (index === 0) {
      window.location.reload();
    }
  }, []);

  // Handle item click for drill down
  const handleItemClick = useCallback((item: DrillDownItem) => {
    if (item.hasChildren && canDrillDown) {
      setSearchQuery('');
      drillDown(item.itemId);
    }
  }, [canDrillDown, drillDown]);

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
                  <span className={styles.breadcrumbCurrent}>Category Analysis</span>
                </div>
                <h1 className={styles.title}>Category Analysis</h1>
                <p className={styles.subtitle}>
                  Drill down from categories to brands and products
                </p>
              </div>

              {/* Level Breadcrumbs */}
              <div className={styles.levelBreadcrumbs}>
                {breadcrumbs.map((crumb, index) => (
                  <React.Fragment key={index}>
                    {index > 0 && <span className={styles.levelSeparator}>/</span>}
                    <button
                      className={`${styles.levelItem} ${index === breadcrumbs.length - 1 ? styles.active : ''}`}
                      onClick={() => handleBreadcrumbClick(index)}
                      disabled={index === breadcrumbs.length - 1}
                    >
                      {crumb.label}
                    </button>
                  </React.Fragment>
                ))}
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
                      placeholder={`Search ${getLevelLabel(currentLevel).toLowerCase()}...`}
                      value={searchQuery}
                      onChange={handleSearchChange}
                    />
                  </div>
                </div>
              </div>

              {/* Info Bar */}
              <div className={styles.infoBar}>
                <div className={styles.infoLeft}>
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                    {canDrillDown ? (
                      <path d="M10,9A1,1 0 0,1 11,8A1,1 0 0,1 12,9V13.47L13.21,13.6L18.15,15.79C18.68,16.03 19,16.56 19,17.14V21.5C18.97,22.32 18.32,22.97 17.5,23H11C10.62,23 10.26,22.85 10,22.57L5.1,18.37L5.84,17.6C6.03,17.39 6.3,17.28 6.58,17.28H6.8L10,19V9M11,5A4,4 0 0,1 15,9C15,10.5 14.2,11.77 13,12.46V11.24C13.61,10.69 14,9.89 14,9A3,3 0 0,0 11,6A3,3 0 0,0 8,9C8,9.89 8.39,10.69 9,11.24V12.46C7.8,11.77 7,10.5 7,9A4,4 0 0,1 11,5Z" />
                    ) : (
                      <path d="M12,2A10,10 0 0,1 22,12A10,10 0 0,1 12,22A10,10 0 0,1 2,12A10,10 0 0,1 12,2M12,4A8,8 0 0,0 4,12A8,8 0 0,0 12,20A8,8 0 0,0 20,12A8,8 0 0,0 12,4M11,16.5L6.5,12L7.91,10.59L11,13.67L16.59,8.09L18,9.5L11,16.5Z" />
                    )}
                  </svg>
                  <span>
                    {canDrillDown
                      ? `Click to drill down into ${currentLevel === 'category' ? 'brands' : 'products'}`
                      : 'Lowest level (products)'}
                  </span>
                </div>
                <span className={styles.infoCount}>{filteredItems.length} items</span>
              </div>

              {/* Content Card with Table */}
              <div className={styles.contentCard}>
                {loading ? (
                  <div className={styles.loadingState}>
                    <div className={styles.spinner} />
                    <span className={styles.loadingText}>Loading...</span>
                  </div>
                ) : filteredItems.length === 0 ? (
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
                    <p className={styles.emptyText}>No {getLevelLabel(currentLevel).toLowerCase()} found</p>
                    {searchQuery && (
                      <p className={styles.emptyHint}>Try a different search term</p>
                    )}
                  </div>
                ) : (
                  <table className={styles.categoryTable}>
                    <thead>
                      <tr>
                        <th className={styles.colRank}>Rank</th>
                        <th className={styles.colCategory}>{getLevelLabel(currentLevel).slice(0, -1)}</th>
                        <th className={styles.colRevenue}>Revenue</th>
                        <th className={styles.colMargin}>Margin</th>
                        <th className={styles.colQuantity}>Quantity</th>
                        <th className={styles.colShare}>Share</th>
                        {canDrillDown && <th className={styles.colAction}></th>}
                      </tr>
                    </thead>
                    <tbody>
                      {filteredItems.map((item, index) => {
                        const rank = index + 1;
                        const shareRatio = maxRevenue > 0 ? item.totalRevenue / maxRevenue : 0;
                        const sharePercent = (shareRatio * 100).toFixed(1);
                        const isClickable = item.hasChildren && canDrillDown;

                        return (
                          <tr
                            key={item.itemId}
                            className={isClickable ? styles.clickable : ''}
                            onClick={() => isClickable && handleItemClick(item)}
                          >
                            <td className={styles.rankCell}>
                              <span className={`${styles.rankBadge} ${getRankClass(rank)}`}>
                                {rank}
                              </span>
                            </td>
                            <td className={styles.categoryCell}>{item.itemName}</td>
                            <td className={styles.revenueCell}>
                              {formatCurrency(item.totalRevenue, currencySymbol)}
                            </td>
                            <td className={styles.marginCell}>
                              {item.marginRate > 0 && (
                                <span className={styles.marginBadge}>
                                  {item.marginRate.toFixed(1)}%
                                </span>
                              )}
                            </td>
                            <td className={styles.quantityCell}>
                              {item.totalQuantity > 0 ? item.totalQuantity.toLocaleString() : '-'}
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
                            {canDrillDown && (
                              <td className={styles.actionCell}>
                                {isClickable && (
                                  <svg
                                    className={styles.chevronIcon}
                                    width="20"
                                    height="20"
                                    viewBox="0 0 24 24"
                                    fill="currentColor"
                                  >
                                    <path d="M8.59,16.58L13.17,12L8.59,7.41L10,6L16,12L10,18L8.59,16.58Z" />
                                  </svg>
                                )}
                              </td>
                            )}
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

export default CategoryAnalysisPage;
