/**
 * InventoryOptimizationPage Types
 */

export interface InventoryOptimizationPageProps {
  // Add props as needed
}

export type InventoryStatus = 'healthy' | 'low' | 'critical' | 'stockout' | 'overstock';

export interface InventoryProduct {
  productId: string;
  productName: string;
  categoryName: string;
  currentStock: number;
  minStock: number;
  maxStock: number;
  status: InventoryStatus;
  daysUntilStockout: number | null;
}

export interface InventoryHealth {
  totalProducts: number;
  healthyCount: number;
  lowCount: number;
  criticalCount: number;
  stockoutCount: number;
  overstockCount: number;
  stockoutRate: number;
  abnormalCount: number;
}
