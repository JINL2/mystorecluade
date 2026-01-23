/**
 * InventoryOptimizationPage Component
 * Inventory health dashboard with urgent and abnormal products
 */

import React from 'react';
import { useNavigate } from 'react-router-dom';
import { Navbar } from '@/shared/components/common/Navbar';
import type { InventoryOptimizationPageProps, InventoryStatus } from './InventoryOptimizationPage.types';
import styles from './InventoryOptimizationPage.module.css';

// Mock data for UI development
const mockHealth = {
  totalProducts: 156,
  healthyCount: 120,
  lowCount: 18,
  criticalCount: 8,
  stockoutCount: 5,
  overstockCount: 5,
};

const mockUrgentProducts = [
  { id: '1', name: 'Product A Premium', category: 'Electronics', currentStock: 2, minStock: 10, status: 'critical' as InventoryStatus },
  { id: '2', name: 'Product B Standard', category: 'Accessories', currentStock: 0, minStock: 5, status: 'stockout' as InventoryStatus },
  { id: '3', name: 'Product C Basic', category: 'Electronics', currentStock: 3, minStock: 8, status: 'critical' as InventoryStatus },
  { id: '4', name: 'Product D Lite', category: 'Home', currentStock: 5, minStock: 10, status: 'low' as InventoryStatus },
  { id: '5', name: 'Product E Pro', category: 'Electronics', currentStock: 0, minStock: 15, status: 'stockout' as InventoryStatus },
];

const mockAbnormalProducts = [
  { id: '6', name: 'Product F Mega', category: 'Electronics', currentStock: 150, maxStock: 50, status: 'overstock' as InventoryStatus },
  { id: '7', name: 'Product G Ultra', category: 'Accessories', currentStock: 200, maxStock: 80, status: 'overstock' as InventoryStatus },
  { id: '8', name: 'Product H Max', category: 'Home', currentStock: 85, maxStock: 30, status: 'overstock' as InventoryStatus },
];

const getStatusLabel = (status: InventoryStatus): string => {
  switch (status) {
    case 'healthy': return 'Healthy';
    case 'low': return 'Low Stock';
    case 'critical': return 'Critical';
    case 'stockout': return 'Stockout';
    case 'overstock': return 'Overstock';
    default: return status;
  }
};

export const InventoryOptimizationPage: React.FC<InventoryOptimizationPageProps> = () => {
  const navigate = useNavigate();

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
              <span className={styles.breadcrumbCurrent}>Inventory Health</span>
            </div>
            <h1 className={styles.title}>Inventory Health</h1>
            <p className={styles.subtitle}>Monitor stock levels and identify products needing attention</p>
          </div>

          {/* Health Summary */}
          <div className={styles.healthSummary}>
            <div className={`${styles.healthCard} ${styles.total}`}>
              <p className={styles.healthLabel}>Total</p>
              <p className={styles.healthValue}>{mockHealth.totalProducts}</p>
            </div>
            <div className={`${styles.healthCard} ${styles.healthy}`}>
              <p className={styles.healthLabel}>Healthy</p>
              <p className={styles.healthValue}>{mockHealth.healthyCount}</p>
            </div>
            <div className={`${styles.healthCard} ${styles.low}`}>
              <p className={styles.healthLabel}>Low Stock</p>
              <p className={styles.healthValue}>{mockHealth.lowCount}</p>
            </div>
            <div className={`${styles.healthCard} ${styles.critical}`}>
              <p className={styles.healthLabel}>Critical</p>
              <p className={styles.healthValue}>{mockHealth.criticalCount}</p>
            </div>
            <div className={`${styles.healthCard} ${styles.stockout}`}>
              <p className={styles.healthLabel}>Stockout</p>
              <p className={styles.healthValue}>{mockHealth.stockoutCount}</p>
            </div>
            <div className={`${styles.healthCard} ${styles.overstock}`}>
              <p className={styles.healthLabel}>Overstock</p>
              <p className={styles.healthValue}>{mockHealth.overstockCount}</p>
            </div>
          </div>

          {/* Content */}
          <div className={styles.content}>
            {/* Urgent Products */}
            <div className={styles.card}>
              <div className={styles.cardHeader}>
                <h2 className={styles.cardTitle}>Urgent Products</h2>
                <button className={styles.cardAction}>View All</button>
              </div>
              <ul className={styles.productList}>
                {mockUrgentProducts.map((product) => (
                  <li key={product.id} className={styles.productItem}>
                    <span className={`${styles.productStatus} ${styles[product.status]}`} />
                    <div className={styles.productInfo}>
                      <p className={styles.productName}>{product.name}</p>
                      <p className={styles.productCategory}>{product.category}</p>
                    </div>
                    <div className={styles.productStock}>
                      <p className={styles.stockValue}>{product.currentStock} / {product.minStock}</p>
                      <p className={styles.stockLabel}>Current / Min</p>
                    </div>
                    <span className={`${styles.statusBadge} ${styles[product.status]}`}>
                      {getStatusLabel(product.status)}
                    </span>
                  </li>
                ))}
              </ul>
            </div>

            {/* Abnormal Products (Overstock) */}
            <div className={styles.card}>
              <div className={styles.cardHeader}>
                <h2 className={styles.cardTitle}>Overstock Products</h2>
                <button className={styles.cardAction}>View All</button>
              </div>
              {mockAbnormalProducts.length > 0 ? (
                <ul className={styles.productList}>
                  {mockAbnormalProducts.map((product) => (
                    <li key={product.id} className={styles.productItem}>
                      <span className={`${styles.productStatus} ${styles[product.status]}`} />
                      <div className={styles.productInfo}>
                        <p className={styles.productName}>{product.name}</p>
                        <p className={styles.productCategory}>{product.category}</p>
                      </div>
                      <div className={styles.productStock}>
                        <p className={styles.stockValue}>{product.currentStock} / {product.maxStock}</p>
                        <p className={styles.stockLabel}>Current / Max</p>
                      </div>
                      <span className={`${styles.statusBadge} ${styles[product.status]}`}>
                        {getStatusLabel(product.status)}
                      </span>
                    </li>
                  ))}
                </ul>
              ) : (
                <div className={styles.emptyState}>
                  <svg className={styles.emptyIcon} viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12,2A10,10 0 0,1 22,12A10,10 0 0,1 12,22A10,10 0 0,1 2,12A10,10 0 0,1 12,2M12,4A8,8 0 0,0 4,12A8,8 0 0,0 12,20A8,8 0 0,0 20,12A8,8 0 0,0 12,4M11,16.5L6.5,12L7.91,10.59L11,13.67L16.59,8.09L18,9.5L11,16.5Z" />
                  </svg>
                  <p className={styles.emptyText}>No overstock products</p>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default InventoryOptimizationPage;
