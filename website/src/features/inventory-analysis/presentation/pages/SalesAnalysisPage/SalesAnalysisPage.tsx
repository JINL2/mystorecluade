/**
 * SalesAnalysisPage Component
 * Sales dashboard with BCG matrix and top products
 */

import React, { useMemo, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { Navbar } from '@/shared/components/common/Navbar';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { useAppState } from '@/app/providers/app_state_provider';
import { useSalesDashboard } from '../../hooks/useSalesDashboard';
import { useBcgMatrix } from '../../hooks/useBcgMatrix';
import type { SalesAnalysisPageProps } from './SalesAnalysisPage.types';
import type { BcgMatrixSuccess, BcgCategoryItem } from '../../../domain/entities/bcgMatrix';
import styles from './SalesAnalysisPage.module.css';

const formatCurrency = (value: number): string => {
  if (value >= 1000000000) {
    return `₫${(value / 1000000000).toFixed(1)}B`;
  } else if (value >= 1000000) {
    return `₫${(value / 1000000).toFixed(1)}M`;
  } else if (value >= 1000) {
    return `₫${(value / 1000).toFixed(1)}K`;
  }
  return `₫${value.toFixed(0)}`;
};

const formatNumber = (value: number): string => {
  return value.toLocaleString();
};

// Get top categories from BCG matrix by revenue
const getTopCategories = (bcgData: BcgMatrixSuccess, limit: number = 5): BcgCategoryItem[] => {
  const allCategories = [
    ...bcgData.star,
    ...bcgData.cashCow,
    ...bcgData.problemChild,
    ...bcgData.dog,
  ];
  return allCategories
    .sort((a, b) => b.totalRevenue - a.totalRevenue)
    .slice(0, limit);
};

export const SalesAnalysisPage: React.FC<SalesAnalysisPageProps> = () => {
  const navigate = useNavigate();
  const { currentCompany, currentStore, setCurrentStore } = useAppState();
  const companyId = currentCompany?.company_id;
  const stores = currentCompany?.stores || [];
  const selectedStoreId = currentStore?.store_id || null;

  // Handle store selection
  const handleStoreSelect = useCallback((storeId: string | null) => {
    if (!storeId) {
      setCurrentStore(null);
    } else {
      const store = stores.find(s => s.store_id === storeId);
      if (store) {
        setCurrentStore(store);
      }
    }
  }, [stores, setCurrentStore]);

  // Fetch sales dashboard data
  const { data: salesData, loading: salesLoading } = useSalesDashboard(
    companyId,
    selectedStoreId || undefined
  );

  // Fetch BCG matrix data
  const { data: bcgData, loading: bcgLoading } = useBcgMatrix(
    companyId,
    selectedStoreId || undefined
  );

  // Transform sales data for summary cards
  const summaryData = useMemo(() => {
    if (!salesData) {
      return {
        revenue: { value: 0, change: 0 },
        margin: { value: 0, change: 0 },
        marginRate: { value: 0, change: 0 },
        quantity: { value: 0, change: 0 },
      };
    }

    const { thisMonth, growth } = salesData;

    return {
      revenue: { value: thisMonth.revenue, change: growth.revenuePct },
      margin: { value: thisMonth.margin, change: growth.marginPct },
      marginRate: {
        value: thisMonth.revenue > 0 ? (thisMonth.margin / thisMonth.revenue) * 100 : 0,
        change: growth.marginPct - growth.revenuePct, // Approximate margin rate change
      },
      quantity: { value: thisMonth.quantity, change: growth.quantityPct },
    };
  }, [salesData]);

  // Transform BCG data for display
  const bcgCounts = useMemo(() => {
    if (!bcgData || !bcgData.success) {
      return { star: 0, cashCow: 0, problemChild: 0, dog: 0 };
    }

    const data = bcgData as BcgMatrixSuccess;
    return {
      star: data.star.length,
      cashCow: data.cashCow.length,
      problemChild: data.problemChild.length,
      dog: data.dog.length,
    };
  }, [bcgData]);

  // Get top categories for display
  const topCategories = useMemo(() => {
    if (!bcgData || !bcgData.success) {
      return [];
    }
    return getTopCategories(bcgData as BcgMatrixSuccess, 5);
  }, [bcgData]);

  const isLoading = salesLoading || bcgLoading;

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
              <span className={styles.breadcrumbCurrent}>Sales Analysis</span>
            </div>
            <h1 className={styles.title}>Sales Analysis</h1>
            <p className={styles.subtitle}>Revenue, margin, and product performance analysis</p>
          </div>

          {/* Store Selector */}
          <div className={styles.storeSelector}>
            <StoreSelector
              stores={stores}
              selectedStoreId={selectedStoreId}
              onStoreSelect={handleStoreSelect}
              companyId={companyId}
              showAllStoresOption={true}
              allStoresLabel="All Stores"
            />
          </div>

          {/* Summary Cards */}
          <div className={styles.summarySection}>
            <div className={styles.summaryCard}>
              <p className={styles.summaryLabel}>Revenue</p>
              <p className={styles.summaryValue}>
                {salesLoading ? '-' : formatCurrency(summaryData.revenue.value)}
              </p>
              <span className={`${styles.summaryChange} ${summaryData.revenue.change >= 0 ? styles.positive : styles.negative}`}>
                {summaryData.revenue.change >= 0 ? '↑' : '↓'} {Math.abs(summaryData.revenue.change).toFixed(1)}%
              </span>
            </div>
            <div className={styles.summaryCard}>
              <p className={styles.summaryLabel}>Margin</p>
              <p className={styles.summaryValue}>
                {salesLoading ? '-' : formatCurrency(summaryData.margin.value)}
              </p>
              <span className={`${styles.summaryChange} ${summaryData.margin.change >= 0 ? styles.positive : styles.negative}`}>
                {summaryData.margin.change >= 0 ? '↑' : '↓'} {Math.abs(summaryData.margin.change).toFixed(1)}%
              </span>
            </div>
            <div className={styles.summaryCard}>
              <p className={styles.summaryLabel}>Margin Rate</p>
              <p className={styles.summaryValue}>
                {salesLoading ? '-' : `${summaryData.marginRate.value.toFixed(1)}%`}
              </p>
              <span className={`${styles.summaryChange} ${summaryData.marginRate.change >= 0 ? styles.positive : styles.negative}`}>
                {summaryData.marginRate.change >= 0 ? '↑' : '↓'} {Math.abs(summaryData.marginRate.change).toFixed(1)}%
              </span>
            </div>
            <div className={styles.summaryCard}>
              <p className={styles.summaryLabel}>Quantity Sold</p>
              <p className={styles.summaryValue}>
                {salesLoading ? '-' : formatNumber(summaryData.quantity.value)}
              </p>
              <span className={`${styles.summaryChange} ${summaryData.quantity.change >= 0 ? styles.positive : styles.negative}`}>
                {summaryData.quantity.change >= 0 ? '↑' : '↓'} {Math.abs(summaryData.quantity.change).toFixed(1)}%
              </span>
            </div>
          </div>

          {/* Content Grid */}
          <div className={styles.contentGrid}>
            {/* BCG Matrix */}
            <div className={styles.card}>
              <div className={styles.cardHeader}>
                <h2 className={styles.cardTitle}>BCG Matrix</h2>
                <button className={styles.cardAction}>View Details</button>
              </div>
              <div className={styles.bcgMatrix}>
                <span className={styles.bcgAxisY}>Market Growth ↑</span>
                <span className={styles.bcgAxisX}>Market Share →</span>

                <div className={`${styles.bcgQuadrant} ${styles.problemChild}`}>
                  <span className={styles.bcgQuadrantLabel}>Problem Child</span>
                  <span className={styles.bcgQuadrantCount}>
                    {bcgLoading ? '-' : bcgCounts.problemChild}
                  </span>
                </div>
                <div className={`${styles.bcgQuadrant} ${styles.star}`}>
                  <span className={styles.bcgQuadrantLabel}>Star</span>
                  <span className={styles.bcgQuadrantCount}>
                    {bcgLoading ? '-' : bcgCounts.star}
                  </span>
                </div>
                <div className={`${styles.bcgQuadrant} ${styles.dog}`}>
                  <span className={styles.bcgQuadrantLabel}>Dog</span>
                  <span className={styles.bcgQuadrantCount}>
                    {bcgLoading ? '-' : bcgCounts.dog}
                  </span>
                </div>
                <div className={`${styles.bcgQuadrant} ${styles.cashCow}`}>
                  <span className={styles.bcgQuadrantLabel}>Cash Cow</span>
                  <span className={styles.bcgQuadrantCount}>
                    {bcgLoading ? '-' : bcgCounts.cashCow}
                  </span>
                </div>
              </div>
            </div>

            {/* Top Categories */}
            <div className={styles.card}>
              <div className={styles.cardHeader}>
                <h2 className={styles.cardTitle}>Top Categories</h2>
                <button className={styles.cardAction}>View All</button>
              </div>
              <ul className={styles.productList}>
                {bcgLoading ? (
                  <li className={styles.loadingItem}>Loading...</li>
                ) : topCategories.length === 0 ? (
                  <li className={styles.emptyItem}>No data available</li>
                ) : (
                  topCategories.map((category, index) => (
                    <li key={category.categoryId} className={styles.productItem}>
                      <span className={`${styles.productRank} ${index < 3 ? styles.top3 : ''}`}>
                        {index + 1}
                      </span>
                      <div className={styles.productInfo}>
                        <p className={styles.productName}>{category.categoryName}</p>
                        <p className={styles.productCategory}>
                          {category.quadrant === 'star' && '⭐ Star'}
                          {category.quadrant === 'cash_cow' && '🐄 Cash Cow'}
                          {category.quadrant === 'problem_child' && '❓ Problem Child'}
                          {category.quadrant === 'dog' && '🐕 Dog'}
                        </p>
                      </div>
                      <div className={styles.productMetrics}>
                        <p className={styles.productRevenue}>{formatCurrency(category.totalRevenue)}</p>
                        <p className={styles.productMargin}>{category.marginRatePct.toFixed(1)}% margin</p>
                      </div>
                    </li>
                  ))
                )}
              </ul>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default SalesAnalysisPage;
