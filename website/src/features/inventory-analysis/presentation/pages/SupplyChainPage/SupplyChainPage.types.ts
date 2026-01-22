/**
 * SupplyChainPage Types
 * Types for supply chain risk analysis page
 */

export type RiskLevel = 'critical' | 'warning' | 'normal';

export interface SupplyChainProduct {
  id: string;
  name: string;
  category: string;
  shortageDays: number;
  avgShortagePerDay: number;
  totalShortage: number;
  errorIntegral: number;
  riskLevel: RiskLevel;
}

export interface SupplyChainStatus {
  urgentProducts: SupplyChainProduct[];
  criticalCount: number;
  warningCount: number;
  status: 'critical' | 'warning' | 'good';
}

export interface SupplyChainPageProps {
  className?: string;
}
