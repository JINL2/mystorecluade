/**
 * InventoryAnalysisPage Component
 * Hub page showing 4 analysis summary cards
 */

import React, { useMemo, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { Navbar } from '@/shared/components/common/Navbar';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { useAppState } from '@/app/providers/app_state_provider';
import { useSalesDashboard } from '../../hooks/useSalesDashboard';
import { useInventoryHealth } from '../../hooks/useInventoryHealth';
import { useSupplyChainStatus } from '../../hooks/useSupplyChainStatus';
import { useDiscrepancyOverview } from '../../hooks/useDiscrepancyOverview';
import type { InventoryAnalysisPageProps } from './InventoryAnalysisPage.types';
import type { SalesDashboard } from '../../../domain/entities/salesDashboard';
import type { InventoryHealthDashboard } from '../../../domain/entities/inventoryHealthDashboard';
import type { SupplyChainStatus } from '../../../domain/entities/supplyChainStatus';
import type { DiscrepancyOverview } from '../../../domain/entities/discrepancyOverview';
import styles from './InventoryAnalysisPage.module.css';

// Helper to format currency
const formatCurrency = (value: number): string => {
  if (value >= 1000000000) {
    return `₫${(value / 1000000000).toFixed(1)}B`;
  }
  if (value >= 1000000) {
    return `₫${(value / 1000000).toFixed(1)}M`;
  }
  if (value >= 1000) {
    return `₫${(value / 1000).toFixed(1)}K`;
  }
  return `₫${value.toFixed(0)}`;
};

// Helper to format percentage with sign
const formatGrowth = (value: number): string => {
  const sign = value >= 0 ? '+' : '';
  return `${sign}${value.toFixed(1)}% growth`;
};

// Helper to determine status based on growth
const getGrowthStatus = (growthPct: number): 'good' | 'warning' | 'critical' => {
  if (growthPct >= 0) return 'good';
  if (growthPct >= -10) return 'warning';
  return 'critical';
};

// Transform sales dashboard data to card props
const transformSalesData = (data: SalesDashboard | null) => {
  if (!data) {
    return {
      status: 'insufficient' as const,
      statusText: 'Loading...',
      primaryMetric: '-',
      secondaryMetric: null,
    };
  }

  return {
    status: getGrowthStatus(data.growth.revenuePct),
    statusText: 'This month vs Last month',
    primaryMetric: formatGrowth(data.growth.revenuePct),
    secondaryMetric: `${formatCurrency(data.thisMonth.revenue)} revenue`,
  };
};

// Transform inventory health data to card props
const transformInventoryHealthData = (data: InventoryHealthDashboard | null) => {
  if (!data) {
    return {
      status: 'insufficient' as const,
      statusText: 'Loading...',
      primaryMetric: '-',
      secondaryMetric: null,
    };
  }

  const { health } = data;

  // Determine status based on abnormal rate
  let status: 'good' | 'warning' | 'critical' | 'insufficient' = 'good';
  if (health.abnormalRate >= 10) {
    status = 'critical';
  } else if (health.abnormalRate >= 5) {
    status = 'warning';
  }

  // Build status text
  const attentionCount = health.criticalCount + health.warningCount;
  const statusText = attentionCount > 0
    ? `${attentionCount} products need attention`
    : 'All products healthy';

  return {
    status,
    statusText,
    primaryMetric: `${health.stockoutRate.toFixed(1)}% stockout`,
    secondaryMetric: health.criticalCount > 0 ? `${health.criticalCount} critical` : null,
  };
};

// Transform supply chain data to card props
const transformSupplyChainData = (data: SupplyChainStatus | null) => {
  if (!data) {
    return {
      status: 'insufficient' as const,
      statusText: 'Loading...',
      primaryMetric: '-',
      secondaryMetric: null,
    };
  }

  const { urgentProducts } = data;

  // No risk products
  if (urgentProducts.length === 0) {
    return {
      status: 'good' as const,
      statusText: 'Supply chain normal',
      primaryMetric: 'No risk products',
      secondaryMetric: null,
    };
  }

  // Count by risk level
  const criticalCount = urgentProducts.filter(p => p.riskLevel === 'Critical').length;
  const warningCount = urgentProducts.filter(p => p.riskLevel === 'Warning').length;

  // Determine status
  const status = criticalCount > 0 ? 'critical' : 'warning';

  return {
    status: status as 'good' | 'warning' | 'critical',
    statusText: `${urgentProducts.length} products at risk`,
    primaryMetric: criticalCount > 0 ? `${criticalCount} critical` : `${warningCount} warning`,
    secondaryMetric: criticalCount > 0 && warningCount > 0 ? `${warningCount} warning` : null,
  };
};

// Transform discrepancy data to card props
const transformDiscrepancyData = (data: DiscrepancyOverview | null) => {
  if (!data) {
    return {
      status: 'insufficient' as const,
      statusText: 'Loading...',
      primaryMetric: '-',
      secondaryMetric: null,
    };
  }

  // Insufficient data case
  if (data.status === 'insufficient_data') {
    return {
      status: 'insufficient' as const,
      statusText: 'Insufficient data',
      primaryMetric: 'Need more data',
      secondaryMetric: null,
    };
  }

  // Success case
  const { cumulative, stores } = data;
  const storeCount = stores.length;

  // Format net value with sign
  const netValue = cumulative.netValue;
  const formattedNet = netValue < 0
    ? `-${formatCurrency(Math.abs(netValue))}`
    : `+${formatCurrency(netValue)}`;

  // Determine status based on net value
  let status: 'good' | 'warning' | 'critical' = 'good';
  if (netValue < -1000000) {
    status = 'critical';  // Loss over 1M
  } else if (netValue < 0) {
    status = 'warning';   // Any loss
  }

  // Count abnormal stores (stores with significant negative net value)
  const abnormalStores = stores.filter(s => s.netValue < -100000).length;

  return {
    status,
    statusText: `${storeCount} stores analyzed`,
    primaryMetric: formattedNet,
    secondaryMetric: abnormalStores > 0 ? `${abnormalStores} abnormal stores` : null,
  };
};

type StatusType = 'good' | 'warning' | 'critical' | 'insufficient';

interface SummaryCardProps {
  title: string;
  subtitle: string;
  primaryMetric: string;
  secondaryMetric: string | null;
  status: StatusType;
  iconType: 'sales' | 'optimization' | 'supplyChain' | 'discrepancy';
  onClick: () => void;
}

const SummaryCard: React.FC<SummaryCardProps> = ({
  title,
  subtitle,
  primaryMetric,
  secondaryMetric,
  status,
  iconType,
  onClick,
}) => {
  const getStatusLabel = (s: StatusType) => {
    switch (s) {
      case 'good':
        return 'Good';
      case 'warning':
        return 'Warning';
      case 'critical':
        return 'Critical';
      case 'insufficient':
        return 'No Data';
    }
  };

  const renderIcon = () => {
    switch (iconType) {
      case 'sales':
        return (
          <svg viewBox="0 0 24 24" fill="currentColor">
            <path d="M16,6L18.29,8.29L13.41,13.17L9.41,9.17L2,16.59L3.41,18L9.41,12L13.41,16L19.71,9.71L22,12V6H16Z" />
          </svg>
        );
      case 'optimization':
        return (
          <svg viewBox="0 0 24 24" fill="currentColor">
            <path d="M20,2H4C2.89,2 2,2.89 2,4V20C2,21.11 2.89,22 4,22H20C21.11,22 22,21.11 22,20V4C22,2.89 21.11,2 20,2M20,20H4V4H20V20M6,6H14V8H6V6M6,10H14V12H6V10M6,14H11V16H6V14Z" />
          </svg>
        );
      case 'supplyChain':
        return (
          <svg viewBox="0 0 24 24" fill="currentColor">
            <path d="M18,18.5A1.5,1.5 0 0,1 16.5,17A1.5,1.5 0 0,1 18,15.5A1.5,1.5 0 0,1 19.5,17A1.5,1.5 0 0,1 18,18.5M19.5,9.5L21.46,12H17V9.5M6,18.5A1.5,1.5 0 0,1 4.5,17A1.5,1.5 0 0,1 6,15.5A1.5,1.5 0 0,1 7.5,17A1.5,1.5 0 0,1 6,18.5M20,8H17V4H3C1.89,4 1,4.89 1,6V17H3A3,3 0 0,0 6,20A3,3 0 0,0 9,17H15A3,3 0 0,0 18,20A3,3 0 0,0 21,17H23V12L20,8Z" />
          </svg>
        );
      case 'discrepancy':
        return (
          <svg viewBox="0 0 24 24" fill="currentColor">
            <path d="M12,2L1,21H23M12,6L19.53,19H4.47M11,10V14H13V10M11,16V18H13V16" />
          </svg>
        );
    }
  };

  return (
    <div className={styles.summaryCard} onClick={onClick}>
      <div className={`${styles.cardIcon} ${styles[iconType]}`}>{renderIcon()}</div>
      <div className={styles.cardContent}>
        <div className={styles.cardHeader}>
          <h3 className={styles.cardTitle}>{title}</h3>
          <svg className={styles.cardArrow} width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
            <path d="M8.59,16.58L13.17,12L8.59,7.41L10,6L16,12L10,18L8.59,16.58Z" />
          </svg>
        </div>
        <p className={styles.cardSubtitle}>{subtitle}</p>
        <div className={styles.cardMetrics}>
          <span className={styles.primaryMetric}>{primaryMetric}</span>
          {secondaryMetric && <span className={styles.secondaryMetric}>{secondaryMetric}</span>}
          <span className={`${styles.statusBadge} ${styles[status]}`}>
            <span className={styles.statusDot} />
            {getStatusLabel(status)}
          </span>
        </div>
      </div>
    </div>
  );
};

export const InventoryAnalysisPage: React.FC<InventoryAnalysisPageProps> = () => {
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

  // Fetch sales dashboard data (with store filter)
  const { data: salesData, loading: salesLoading } = useSalesDashboard(companyId, selectedStoreId || undefined);

  // Fetch inventory health data (company-wide only)
  const { data: inventoryHealthData, loading: inventoryHealthLoading } = useInventoryHealth(companyId);

  // Fetch supply chain status (company-wide only)
  const { data: supplyChainData, loading: supplyChainLoading } = useSupplyChainStatus(companyId);

  // Fetch discrepancy overview (company-wide only)
  const { data: discrepancyData, loading: discrepancyLoading } = useDiscrepancyOverview(companyId);

  // Transform sales data for card display
  const salesCardData = useMemo(() => {
    if (salesLoading) {
      return {
        status: 'insufficient' as const,
        statusText: 'Loading...',
        primaryMetric: '-',
        secondaryMetric: null,
      };
    }
    return transformSalesData(salesData);
  }, [salesData, salesLoading]);

  // Transform inventory health data for card display
  const inventoryHealthCardData = useMemo(() => {
    if (inventoryHealthLoading) {
      return {
        status: 'insufficient' as const,
        statusText: 'Loading...',
        primaryMetric: '-',
        secondaryMetric: null,
      };
    }
    return transformInventoryHealthData(inventoryHealthData);
  }, [inventoryHealthData, inventoryHealthLoading]);

  // Transform supply chain data for card display
  const supplyChainCardData = useMemo(() => {
    if (supplyChainLoading) {
      return {
        status: 'insufficient' as const,
        statusText: 'Loading...',
        primaryMetric: '-',
        secondaryMetric: null,
      };
    }
    return transformSupplyChainData(supplyChainData);
  }, [supplyChainData, supplyChainLoading]);

  // Transform discrepancy data for card display
  const discrepancyCardData = useMemo(() => {
    if (discrepancyLoading) {
      return {
        status: 'insufficient' as const,
        statusText: 'Loading...',
        primaryMetric: '-',
        secondaryMetric: null,
      };
    }
    return transformDiscrepancyData(discrepancyData);
  }, [discrepancyData, discrepancyLoading]);

  const handleNavigate = (path: string) => {
    navigate(path);
  };

  return (
    <>
      <Navbar activeItem="analysis" />
      <div className={styles.pageLayout}>
        <div className={styles.container}>
          <div className={styles.header}>
            <h1 className={styles.title}>Inventory Analysis</h1>
            <p className={styles.subtitle}>Comprehensive analysis of sales, inventory, supply chain, and discrepancies</p>
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

          <div className={styles.cardsGrid}>
            {/* Sales Analysis Card - Real Data */}
            <SummaryCard
              title="Sales Analysis"
              subtitle={salesCardData.statusText}
              primaryMetric={salesCardData.primaryMetric}
              secondaryMetric={salesCardData.secondaryMetric}
              status={salesCardData.status}
              iconType="sales"
              onClick={() => handleNavigate('/analysis/inventory-analysis/sales')}
            />

            {/* Inventory Health Card - Real Data */}
            <SummaryCard
              title="Inventory Health"
              subtitle={inventoryHealthCardData.statusText}
              primaryMetric={inventoryHealthCardData.primaryMetric}
              secondaryMetric={inventoryHealthCardData.secondaryMetric}
              status={inventoryHealthCardData.status}
              iconType="optimization"
              onClick={() => handleNavigate('/analysis/inventory-analysis/optimization')}
            />

            {/* Supply Chain Card - Real Data */}
            <SummaryCard
              title="Supply Chain"
              subtitle={supplyChainCardData.statusText}
              primaryMetric={supplyChainCardData.primaryMetric}
              secondaryMetric={supplyChainCardData.secondaryMetric}
              status={supplyChainCardData.status}
              iconType="supplyChain"
              onClick={() => handleNavigate('/analysis/inventory-analysis/supply-chain')}
            />

            {/* Discrepancy Card - Real Data */}
            <SummaryCard
              title="Discrepancy"
              subtitle={discrepancyCardData.statusText}
              primaryMetric={discrepancyCardData.primaryMetric}
              secondaryMetric={discrepancyCardData.secondaryMetric}
              status={discrepancyCardData.status}
              iconType="discrepancy"
              onClick={() => handleNavigate('/analysis/inventory-analysis/discrepancy')}
            />
          </div>
        </div>
      </div>
    </>
  );
};

export default InventoryAnalysisPage;
