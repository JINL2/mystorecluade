/**
 * CategoryDetail Entity
 * Domain entity for category detail RPC response
 */

// Category summary info
export interface CategorySummary {
  categoryName: string;
  totalRevenue: number;
  totalMargin: number;
  avgMarginRate: number;
  totalQuantity: number;
}

// Top brand item
export interface TopBrandItem {
  brandName: string;
  revenue: number;
  avgMarginRate: number;
  quantity: number;
}

// Problem product item
export type IssueType = 'overstock' | 'understock' | 'slow_moving' | 'low_margin';

export interface ProblemProductItem {
  productName: string;
  currentStock: number;
  reorderPoint95: number;
  daysOfInventory: number;
  issueType: IssueType;
}

// Main CategoryDetail entity
export interface CategoryDetail {
  category: CategorySummary;
  topBrands: TopBrandItem[];
  problemProducts: ProblemProductItem[];
}

// RPC response types
interface CategoryRpcData {
  category_name: string;
  total_revenue: number;
  total_margin: number;
  avg_margin_rate: number;
  total_quantity: number;
}

interface TopBrandRpcData {
  brand_name: string;
  revenue: number;
  avg_margin_rate: number;
  quantity: number;
}

interface ProblemProductRpcData {
  product_name: string;
  current_stock: number;
  reorder_point_95: number;
  days_of_inventory: number;
  issue_type: string;
}

interface CategoryDetailRpcResponse {
  category: CategoryRpcData;
  top_brands: TopBrandRpcData[];
  problem_products: ProblemProductRpcData[];
}

/**
 * Map RPC response to domain entity
 */
export function mapCategoryDetailFromRpc(data: unknown): CategoryDetail {
  const response = data as CategoryDetailRpcResponse;

  return {
    category: {
      categoryName: response.category?.category_name ?? '',
      totalRevenue: response.category?.total_revenue ?? 0,
      totalMargin: response.category?.total_margin ?? 0,
      avgMarginRate: response.category?.avg_margin_rate ?? 0,
      totalQuantity: response.category?.total_quantity ?? 0,
    },
    topBrands: (response.top_brands ?? []).map((brand) => ({
      brandName: brand.brand_name ?? '',
      revenue: brand.revenue ?? 0,
      avgMarginRate: brand.avg_margin_rate ?? 0,
      quantity: brand.quantity ?? 0,
    })),
    problemProducts: (response.problem_products ?? []).map((product) => ({
      productName: product.product_name ?? '',
      currentStock: product.current_stock ?? 0,
      reorderPoint95: product.reorder_point_95 ?? 0,
      daysOfInventory: product.days_of_inventory ?? 0,
      issueType: (product.issue_type ?? 'slow_moving') as IssueType,
    })),
  };
}
