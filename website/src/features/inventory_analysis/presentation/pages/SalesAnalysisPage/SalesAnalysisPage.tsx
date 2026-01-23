/**
 * SalesAnalysisPage Component
 * Sales dashboard with BCG matrix and top products
 */

import React, { useState, useMemo, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { Navbar } from '@/shared/components/common/Navbar';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { LeftFilter } from '@/shared/components/common/LeftFilter';
import type { FilterSection } from '@/shared/components/common/LeftFilter/LeftFilter.types';
import { useAppState } from '@/app/providers/app_state_provider';
import { useSalesDashboard } from '../../hooks/useSalesDashboard';
import { useBcgMatrix } from '../../hooks/useBcgMatrix';
import { useSalesAnalytics } from '../../hooks/useSalesAnalytics';
import { useDrillDownAnalytics } from '../../hooks/useDrillDownAnalytics';
import { useBaseCurrency } from '../../hooks/useBaseCurrency';
import { BcgScatterChart } from '../../components/BcgScatterChart';
import { CategoryTrendChart } from '../../components/CategoryTrendChart';
import { useCategoryTrend } from '../../hooks/useCategoryTrend';
import type { SalesAnalysisPageProps } from './SalesAnalysisPage.types';
import type { BcgMatrixSuccess, BcgCategoryItem } from '../../../domain/entities/bcgMatrix';
import styles from './SalesAnalysisPage.module.css';

// Period filter options
type PeriodOption = 'today' | '7d' | 'this_month' | 'last_month' | '90d';

// Metric filter options
type MetricOption = 'revenue' | 'margin' | 'quantity';

const formatCurrencyWithSymbol = (value: number, symbol: string): string => {
  if (value >= 1000000000) {
    return `${symbol}${(value / 1000000000).toFixed(1)}B`;
  } else if (value >= 1000000) {
    return `${symbol}${(value / 1000000).toFixed(1)}M`;
  } else if (value >= 1000) {
    return `${symbol}${(value / 1000).toFixed(1)}K`;
  }
  return `${symbol}${value.toFixed(0)}`;
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

  // Filter states
  const [selectedPeriod, setSelectedPeriod] = useState<PeriodOption>('this_month');
  const [selectedMetric, setSelectedMetric] = useState<MetricOption>('revenue');

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

  // Filter sections configuration - using 'sort' type to match InventoryPage design
  const filterSections: FilterSection[] = useMemo(() => [
    {
      id: 'period',
      title: 'Period',
      type: 'sort' as const,
      defaultExpanded: true,
      options: [
        { value: 'today', label: 'Today' },
        { value: '7d', label: 'Past 7 Days' },
        { value: 'this_month', label: 'This Month' },
        { value: 'last_month', label: 'Last Month' },
        { value: '90d', label: 'Past 90 Days' },
      ],
      selectedValues: selectedPeriod,
      onSelect: (value: string) => setSelectedPeriod(value as PeriodOption),
    },
    {
      id: 'metric',
      title: 'Metric',
      type: 'sort' as const,
      defaultExpanded: true,
      options: [
        { value: 'revenue', label: 'Revenue' },
        { value: 'margin', label: 'Margin' },
        { value: 'quantity', label: 'Quantity' },
      ],
      selectedValues: selectedMetric,
      onSelect: (value: string) => setSelectedMetric(value as MetricOption),
    },
  ], [selectedPeriod, selectedMetric]);

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

  // Fetch top products data
  const { data: topProductsData, loading: topProductsLoading } = useSalesAnalytics(
    companyId,
    selectedStoreId || undefined,
    undefined,
    {
      dimension: 'product',
      metric: selectedMetric,
      topN: 3,
    }
  );

  // Fetch category data
  const { data: categoryData, loading: categoryLoading } = useDrillDownAnalytics(
    companyId,
    selectedStoreId || undefined
  );

  // Fetch base currency for formatting
  const { currencySymbol } = useBaseCurrency(companyId);

  // Fetch category trend data
  const {
    data: trendData,
    categories: trendCategories,
    selectedCategoryId: selectedTrendCategory,
    setSelectedCategoryId: setSelectedTrendCategory,
    loading: trendLoading,
  } = useCategoryTrend(companyId, selectedStoreId || undefined);

  // Currency formatter using dynamic symbol
  const formatCurrency = useCallback((value: number): string => {
    return formatCurrencyWithSymbol(value, currencySymbol);
  }, [currencySymbol]);

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

  // Get top categories for display
  const topCategories = useMemo(() => {
    if (!bcgData || !bcgData.success) {
      return [];
    }
    return getTopCategories(bcgData as BcgMatrixSuccess, 5);
  }, [bcgData]);

  // Get top products for display
  const topProducts = useMemo(() => {
    if (!topProductsData || !topProductsData.success) {
      return [];
    }
    return topProductsData.data.slice(0, 3);
  }, [topProductsData]);

  // Get top categories from drill down
  const topCategoriesDrillDown = useMemo(() => {
    if (!categoryData || !categoryData.success) {
      return [];
    }
    return [...categoryData.data]
      .sort((a, b) => b.totalRevenue - a.totalRevenue)
      .slice(0, 3);
  }, [categoryData]);

  // Navigate to Top Products page
  const handleViewAllProducts = useCallback(() => {
    navigate(`/analysis/sales-analysis/top-products?metric=${selectedMetric}`);
  }, [navigate, selectedMetric]);

  // Navigate to Category Analysis page
  const handleViewAllCategories = useCallback(() => {
    navigate('/analysis/sales-analysis/category-analysis');
  }, [navigate]);

  return (
    <>
      <Navbar activeItem="analysis" />
      <div className={styles.pageWrapper}>
        {/* Left Filter Sidebar - matching InventoryPage structure */}
        <div className={styles.sidebarWrapper}>
          <LeftFilter sections={filterSections} width={240} topOffset={64} />
        </div>

        {/* Main Content */}
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

          {/* First Row: BCG Matrix + Category Trend */}
          <div className={styles.contentGrid}>
            {/* BCG Matrix Scatter Chart */}
            <div className={styles.card}>
              <div className={styles.cardHeader}>
                <h2 className={styles.cardTitle}>BCG Matrix</h2>
              </div>
              {bcgData && bcgData.success ? (
                <BcgScatterChart
                  data={bcgData as BcgMatrixSuccess}
                  loading={bcgLoading}
                  currencySymbol={currencySymbol}
                />
              ) : bcgLoading ? (
                <div className={styles.loadingState}>Loading...</div>
              ) : (
                <div className={styles.emptyState}>
                  <p className={styles.emptyText}>No BCG data available</p>
                </div>
              )}
            </div>

            {/* Category Trend Chart */}
            <div className={styles.card}>
              <CategoryTrendChart
                data={trendData}
                categories={trendCategories}
                selectedCategoryId={selectedTrendCategory}
                onCategorySelect={setSelectedTrendCategory}
                loading={trendLoading}
                currencySymbol={currencySymbol}
              />
            </div>
          </div>

          {/* Second Row: Top Products + Category Analysis */}
          <div className={styles.secondaryGrid}>
            {/* Top Products */}
            <div className={styles.card}>
              <div className={styles.cardHeader}>
                <h2 className={styles.cardTitle}>
                  Top Products ({selectedMetric.charAt(0).toUpperCase() + selectedMetric.slice(1)})
                </h2>
                {topProducts.length > 0 && (
                  <button className={styles.cardAction} onClick={handleViewAllProducts}>
                    View All &gt;
                  </button>
                )}
              </div>
              <ul className={styles.productList}>
                {topProductsLoading ? (
                  <li className={styles.loadingItem}>Loading...</li>
                ) : topProducts.length === 0 ? (
                  <li className={styles.emptyItem}>No data available</li>
                ) : (
                  topProducts.map((product, index) => {
                    const maxValue = topProducts[0]?.totalRevenue || 1;
                    const value = selectedMetric === 'revenue' ? product.totalRevenue :
                                  selectedMetric === 'margin' ? product.totalMargin :
                                  product.totalQuantity;
                    const growth = selectedMetric === 'revenue' ? product.revenueGrowth :
                                   selectedMetric === 'margin' ? product.marginGrowth :
                                   product.quantityGrowth;
                    const shareRatio = maxValue > 0 ? product.totalRevenue / maxValue : 0;

                    return (
                      <li key={product.dimensionId} className={styles.productItemCard}>
                        <div className={styles.productItemHeader}>
                          <span className={`${styles.productRank} ${index < 3 ? styles.top3 : ''}`}>
                            {index + 1}
                          </span>
                          <span className={styles.productName}>{product.dimensionName}</span>
                          {growth !== null && (
                            <span className={`${styles.growthBadge} ${growth >= 0 ? styles.positive : styles.negative}`}>
                              {growth >= 0 ? '\u2191' : '\u2193'} {Math.abs(growth).toFixed(1)}%
                            </span>
                          )}
                        </div>
                        <div className={styles.productValueRow}>
                          <span className={styles.productValue}>
                            {selectedMetric === 'quantity'
                              ? formatNumber(value)
                              : formatCurrency(value)}
                          </span>
                          <div className={styles.progressBar}>
                            <div
                              className={styles.progressFill}
                              style={{ width: `${Math.min(100, shareRatio * 100)}%` }}
                            />
                          </div>
                        </div>
                      </li>
                    );
                  })
                )}
              </ul>
            </div>

            {/* Category Analysis */}
            <div className={styles.card}>
              <div className={styles.cardHeader}>
                <h2 className={styles.cardTitle}>
                  Category Analysis ({selectedMetric.charAt(0).toUpperCase() + selectedMetric.slice(1)})
                </h2>
                {topCategoriesDrillDown.length > 0 && (
                  <button className={styles.cardAction} onClick={handleViewAllCategories}>
                    View All &gt;
                  </button>
                )}
              </div>
              <ul className={styles.productList}>
                {categoryLoading ? (
                  <li className={styles.loadingItem}>Loading...</li>
                ) : topCategoriesDrillDown.length === 0 ? (
                  <li className={styles.emptyItem}>No data available</li>
                ) : (
                  topCategoriesDrillDown.map((category, index) => {
                    const maxRevenue = topCategoriesDrillDown[0]?.totalRevenue || 1;
                    const shareRatio = maxRevenue > 0 ? category.totalRevenue / maxRevenue : 0;

                    return (
                      <li key={category.itemId} className={styles.productItemCard}>
                        <div className={styles.productItemHeader}>
                          <span className={`${styles.productRank} ${index < 3 ? styles.top3 : ''}`}>
                            {index + 1}
                          </span>
                          <span className={styles.productName}>{category.itemName}</span>
                        </div>
                        <div className={styles.productValueRow}>
                          <span className={styles.productValue}>
                            {formatCurrency(category.totalRevenue)}
                          </span>
                          <div className={styles.progressBar}>
                            <div
                              className={styles.progressFill}
                              style={{ width: `${Math.min(100, shareRatio * 100)}%` }}
                            />
                          </div>
                        </div>
                        <div className={styles.productStats}>
                          {category.marginRate > 0 && (
                            <span className={styles.statItem}>
                              Margin {category.marginRate.toFixed(1)}%
                            </span>
                          )}
                          {category.totalQuantity > 0 && (
                            <span className={styles.statItem}>
                              {category.totalQuantity.toLocaleString()} sold
                            </span>
                          )}
                        </div>
                      </li>
                    );
                  })
                )}
              </ul>
            </div>
          </div>
        </div>
        </div>
      </div>
    </>
  );
};

export default SalesAnalysisPage;
