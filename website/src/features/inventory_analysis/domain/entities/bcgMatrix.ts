/**
 * BCG Matrix V2 Entity
 * Domain entity for RPC response mapping
 */

// BCG Quadrant types
export type BcgQuadrant = 'star' | 'cash_cow' | 'problem_child' | 'dog';

// Category item in BCG Matrix
export interface BcgCategoryItem {
  categoryId: string;
  categoryName: string;
  totalRevenue: number;
  totalQuantity: number;
  totalMargin: number;
  marginRatePct: number;        // Margin rate percentage
  revenuePct: number;           // Revenue share percentage
  salesVolumePercentile: number;
  marginPercentile: number;
  quadrant: BcgQuadrant;
}

// Success response
export interface BcgMatrixSuccess {
  success: true;
  timezone: string;
  star: BcgCategoryItem[];
  cashCow: BcgCategoryItem[];
  problemChild: BcgCategoryItem[];
  dog: BcgCategoryItem[];
}

// Error response
export interface BcgMatrixError {
  success: false;
  error: string;
  detail: string;
}

// Union type for all responses
export type BcgMatrix = BcgMatrixSuccess | BcgMatrixError;

/**
 * Maps a single category item from RPC response
 */
function mapCategoryItem(item: Record<string, unknown>): BcgCategoryItem {
  return {
    categoryId: String(item.category_id ?? ''),
    categoryName: String(item.category_name ?? ''),
    totalRevenue: Number(item.total_revenue ?? 0),
    totalQuantity: Number(item.total_quantity ?? 0),
    totalMargin: Number(item.total_margin ?? 0),
    marginRatePct: Number(item.margin_rate_pct ?? 0),
    revenuePct: Number(item.revenue_pct ?? 0),
    salesVolumePercentile: Number(item.sales_volume_percentile ?? 0),
    marginPercentile: Number(item.margin_percentile ?? 0),
    quadrant: (item.quadrant as BcgQuadrant) ?? 'dog',
  };
}

/**
 * Maps RPC response to domain entity
 */
export function mapBcgMatrixFromRpc(data: Record<string, unknown>): BcgMatrix {
  const success = data.success as boolean;

  if (!success) {
    return {
      success: false,
      error: String(data.error ?? 'Unknown error'),
      detail: String(data.detail ?? ''),
    };
  }

  const starData = data.star as Array<Record<string, unknown>> | null;
  const cashCowData = data.cash_cow as Array<Record<string, unknown>> | null;
  const problemChildData = data.problem_child as Array<Record<string, unknown>> | null;
  const dogData = data.dog as Array<Record<string, unknown>> | null;

  return {
    success: true,
    timezone: String(data.timezone ?? ''),
    star: (starData ?? []).map(mapCategoryItem),
    cashCow: (cashCowData ?? []).map(mapCategoryItem),
    problemChild: (problemChildData ?? []).map(mapCategoryItem),
    dog: (dogData ?? []).map(mapCategoryItem),
  };
}

/**
 * Helper to get all categories from BCG Matrix
 */
export function getAllCategories(matrix: BcgMatrixSuccess): BcgCategoryItem[] {
  return [...matrix.star, ...matrix.cashCow, ...matrix.problemChild, ...matrix.dog];
}

/**
 * Helper to get category count by quadrant
 */
export function getQuadrantCounts(matrix: BcgMatrixSuccess): Record<BcgQuadrant, number> {
  return {
    star: matrix.star.length,
    cash_cow: matrix.cashCow.length,
    problem_child: matrix.problemChild.length,
    dog: matrix.dog.length,
  };
}
