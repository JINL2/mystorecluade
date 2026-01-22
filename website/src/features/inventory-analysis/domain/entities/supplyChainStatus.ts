/**
 * Supply Chain Status Entity
 * Domain entity for RPC response mapping
 */

// Urgent product with supply chain risk
export interface UrgentSupplyChainProduct {
  productName: string;
  delayDays: number;
  avgShortage: number;
  totalShortage: number;
  errorIntegral: number;
  riskLevel: 'Critical' | 'Warning';
}

// Main supply chain status entity
export interface SupplyChainStatus {
  urgentProducts: UrgentSupplyChainProduct[];
}

/**
 * Maps RPC response to domain entity
 */
export function mapSupplyChainStatusFromRpc(data: Record<string, unknown>): SupplyChainStatus {
  const urgentProductsData = data.urgent_products as Array<Record<string, unknown>> | null | undefined;

  return {
    urgentProducts: (urgentProductsData ?? []).map((prod) => ({
      productName: String(prod.product_name ?? ''),
      delayDays: Number(prod.delay_days ?? 0),
      avgShortage: Number(prod.avg_shortage ?? 0),
      totalShortage: Number(prod.total_shortage ?? 0),
      errorIntegral: Number(prod.error_integral ?? 0),
      riskLevel: (prod.risk_level === 'Critical' ? 'Critical' : 'Warning') as 'Critical' | 'Warning',
    })),
  };
}
