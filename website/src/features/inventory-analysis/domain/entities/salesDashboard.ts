/**
 * Sales Dashboard Domain Entities
 * RPC: get_sales_dashboard
 */

export interface SalesMonthData {
  revenue: number;
  cost: number;
  margin: number;
  marginRate: number;
  quantity: number;
}

export interface SalesGrowth {
  revenuePct: number;
  marginPct: number;
  quantityPct: number;
}

export interface SalesDashboard {
  thisMonth: SalesMonthData;
  lastMonth: SalesMonthData;
  growth: SalesGrowth;
}

/**
 * Map RPC response to domain entity
 */
export function mapSalesDashboardFromRpc(data: Record<string, unknown>): SalesDashboard {
  const thisMonth = data.this_month as Record<string, unknown> | undefined;
  const lastMonth = data.last_month as Record<string, unknown> | undefined;
  const growth = data.growth as Record<string, unknown> | undefined;

  return {
    thisMonth: {
      revenue: Number(thisMonth?.revenue ?? 0),
      cost: Number(thisMonth?.cost ?? 0),
      margin: Number(thisMonth?.margin ?? 0),
      marginRate: Number(thisMonth?.margin_rate ?? 0),
      quantity: Number(thisMonth?.quantity ?? 0),
    },
    lastMonth: {
      revenue: Number(lastMonth?.revenue ?? 0),
      cost: Number(lastMonth?.cost ?? 0),
      margin: Number(lastMonth?.margin ?? 0),
      marginRate: Number(lastMonth?.margin_rate ?? 0),
      quantity: Number(lastMonth?.quantity ?? 0),
    },
    growth: {
      revenuePct: Number(growth?.revenue_pct ?? 0),
      marginPct: Number(growth?.margin_pct ?? 0),
      quantityPct: Number(growth?.quantity_pct ?? 0),
    },
  };
}
