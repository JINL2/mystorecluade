/**
 * BcgScatterChart Component
 * Scatter chart visualization for BCG Matrix matching Flutter app design
 */

import React, { useState, useMemo, useCallback } from 'react';
import type {
  BcgScatterChartProps,
  BcgChartDataPoint,
  XAxisMetric,
  DividerType,
} from './BcgScatterChart.types';
import type { BcgCategoryItem, BcgMatrixSuccess } from '../../../domain/entities/bcgMatrix';
import { BcgToggleButton } from './BcgToggleButton';
import styles from './BcgScatterChart.module.css';

// Quadrant colors matching Flutter app
const QUADRANT_COLORS = {
  star: '#00C896',        // Green (success)
  cash_cow: '#0064FF',    // Blue (primary)
  problem_child: '#FF9500', // Orange (warning)
  dog: '#FF5847',         // Red (error)
};

// Calculate median of array
const calculateMedian = (values: number[]): number => {
  if (values.length === 0) return 0;
  const sorted = [...values].sort((a, b) => a - b);
  const mid = Math.floor(sorted.length / 2);
  return sorted.length % 2 !== 0 ? sorted[mid] : (sorted[mid - 1] + sorted[mid]) / 2;
};

// Calculate mean of array
const calculateMean = (values: number[]): number => {
  if (values.length === 0) return 0;
  return values.reduce((sum, val) => sum + val, 0) / values.length;
};

// Prepare chart data points
const prepareChartData = (
  bcgData: BcgMatrixSuccess,
  xMetric: XAxisMetric,
  dividerType: DividerType
): { points: BcgChartDataPoint[]; xDivider: number; yDivider: number } => {
  // Get all categories
  const allCategories: BcgCategoryItem[] = [
    ...bcgData.star,
    ...bcgData.cashCow,
    ...bcgData.problemChild,
    ...bcgData.dog,
  ];

  // Sort by revenue and take top 50
  const topCategories = [...allCategories]
    .sort((a, b) => b.totalRevenue - a.totalRevenue)
    .slice(0, 50);

  if (topCategories.length === 0) {
    return { points: [], xDivider: 50, yDivider: 50 };
  }

  // Get X values based on metric
  const xValues = topCategories.map((cat) =>
    xMetric === 'revenue' ? cat.totalRevenue : cat.totalQuantity
  );
  const yValues = topCategories.map((cat) => cat.marginPercentile);

  // Calculate dividers
  const xDividerValue = dividerType === 'median'
    ? calculateMedian(xValues)
    : calculateMean(xValues);
  const yDividerValue = dividerType === 'median'
    ? calculateMedian(yValues)
    : calculateMean(yValues);

  // Get max values for normalization
  const maxX = Math.max(...xValues);
  const maxY = Math.max(...yValues);
  const minY = Math.min(...yValues);
  const yRange = maxY - minY || 1;

  // Normalize dividers to 0-100 range
  const xDividerNormalized = maxX > 0 ? (xDividerValue / maxX) * 100 : 50;
  const yDividerNormalized = yRange > 0 ? ((yDividerValue - minY) / yRange) * 100 : 50;

  // Create data points
  const points: BcgChartDataPoint[] = topCategories.map((cat) => {
    const xValue = xMetric === 'revenue' ? cat.totalRevenue : cat.totalQuantity;
    const yValue = cat.marginPercentile;

    // Normalize to 0-100 with clamping to 2-98
    const xNormalized = maxX > 0
      ? Math.min(98, Math.max(2, (xValue / maxX) * 100))
      : 50;
    const yNormalized = yRange > 0
      ? Math.min(98, Math.max(2, ((yValue - minY) / yRange) * 100))
      : 50;

    // Calculate radius based on revenue (8-18px)
    const radius = 8 + Math.min(10, cat.totalRevenue / 50000000);

    return {
      id: cat.categoryId,
      name: cat.categoryName,
      x: xNormalized,
      y: yNormalized,
      radius,
      quadrant: cat.quadrant,
      category: cat,
    };
  });

  return {
    points,
    xDivider: Math.min(98, Math.max(2, xDividerNormalized)),
    yDivider: Math.min(98, Math.max(2, yDividerNormalized)),
  };
};

export const BcgScatterChart: React.FC<BcgScatterChartProps> = ({
  data,
  loading = false,
  currencySymbol = '$',
  className = '',
}) => {
  const [xMetric, setXMetric] = useState<XAxisMetric>('revenue');
  const [dividerType, setDividerType] = useState<DividerType>('median');
  const [hoveredPoint, setHoveredPoint] = useState<BcgChartDataPoint | null>(null);

  // Prepare chart data
  const { points, xDivider, yDivider } = useMemo(() => {
    if (!data) {
      return { points: [], xDivider: 50, yDivider: 50 };
    }
    return prepareChartData(data, xMetric, dividerType);
  }, [data, xMetric, dividerType]);

  // Format currency for tooltip
  const formatCurrency = useCallback((value: number): string => {
    if (value >= 1000000000) {
      return `${currencySymbol}${(value / 1000000000).toFixed(1)}B`;
    } else if (value >= 1000000) {
      return `${currencySymbol}${(value / 1000000).toFixed(1)}M`;
    } else if (value >= 1000) {
      return `${currencySymbol}${(value / 1000).toFixed(1)}K`;
    }
    return `${currencySymbol}${value.toFixed(0)}`;
  }, [currencySymbol]);

  // Handle mouse events
  const handlePointMouseEnter = useCallback((point: BcgChartDataPoint) => {
    setHoveredPoint(point);
  }, []);

  const handlePointMouseLeave = useCallback(() => {
    setHoveredPoint(null);
  }, []);

  if (loading) {
    return (
      <div className={`${styles.chartContainer} ${className}`}>
        <div className={styles.loadingState}>Loading...</div>
      </div>
    );
  }

  return (
    <div className={`${styles.chartContainer} ${className}`}>
      {/* Toggle Buttons */}
      <div className={styles.toggleRow}>
        <BcgToggleButton
          options={[
            { value: 'revenue', label: 'Revenue' },
            { value: 'quantity', label: 'Qty' },
          ]}
          selectedValue={xMetric}
          onChange={(value) => setXMetric(value as XAxisMetric)}
        />
        <BcgToggleButton
          options={[
            { value: 'median', label: 'Median' },
            { value: 'mean', label: 'Mean' },
          ]}
          selectedValue={dividerType}
          onChange={(value) => setDividerType(value as DividerType)}
        />
      </div>

      {/* Chart Area */}
      <div className={styles.chartArea}>
        {/* Y-Axis Label */}
        <div className={styles.yAxisLabel}>Margin Rate</div>

        {/* Chart Content */}
        <div className={styles.chartContent}>
          {/* Y-Axis Ticks */}
          <div className={styles.yAxisTicks}>
            <span>100%</span>
            <span>75%</span>
            <span>50%</span>
            <span>25%</span>
            <span>0%</span>
          </div>

          {/* Main Chart */}
          <div className={styles.chartMain}>
            {/* Quadrant Backgrounds */}
            <div
              className={styles.quadrantBg}
              style={{
                left: 0,
                top: 0,
                width: `${xDivider}%`,
                height: `${100 - yDivider}%`,
                backgroundColor: 'rgba(255, 149, 0, 0.08)',
              }}
            >
              <span className={styles.quadrantLabel}>Problem Child</span>
            </div>
            <div
              className={styles.quadrantBg}
              style={{
                right: 0,
                top: 0,
                width: `${100 - xDivider}%`,
                height: `${100 - yDivider}%`,
                backgroundColor: 'rgba(0, 200, 150, 0.08)',
              }}
            >
              <span className={styles.quadrantLabel}>Star</span>
            </div>
            <div
              className={styles.quadrantBg}
              style={{
                left: 0,
                bottom: 0,
                width: `${xDivider}%`,
                height: `${yDivider}%`,
                backgroundColor: 'rgba(108, 117, 125, 0.08)',
              }}
            >
              <span className={styles.quadrantLabel}>Dog</span>
            </div>
            <div
              className={styles.quadrantBg}
              style={{
                right: 0,
                bottom: 0,
                width: `${100 - xDivider}%`,
                height: `${yDivider}%`,
                backgroundColor: 'rgba(0, 100, 255, 0.08)',
              }}
            >
              <span className={styles.quadrantLabel}>Cash Cow</span>
            </div>

            {/* Divider Lines */}
            <div
              className={styles.dividerLine}
              style={{
                left: `${xDivider}%`,
                top: 0,
                bottom: 0,
                width: '1px',
              }}
            />
            <div
              className={styles.dividerLine}
              style={{
                top: `${100 - yDivider}%`,
                left: 0,
                right: 0,
                height: '1px',
              }}
            />

            {/* Scatter Points */}
            {points.map((point) => (
              <div
                key={point.id}
                className={styles.scatterPoint}
                style={{
                  left: `${point.x}%`,
                  bottom: `${point.y}%`,
                  width: `${point.radius * 2}px`,
                  height: `${point.radius * 2}px`,
                  backgroundColor: QUADRANT_COLORS[point.quadrant],
                  transform: 'translate(-50%, 50%)',
                }}
                onMouseEnter={() => handlePointMouseEnter(point)}
                onMouseLeave={handlePointMouseLeave}
              />
            ))}

            {/* Tooltip */}
            {hoveredPoint && (
              <div
                className={styles.tooltip}
                style={{
                  left: `${hoveredPoint.x}%`,
                  bottom: `${hoveredPoint.y + 5}%`,
                }}
              >
                <div className={styles.tooltipName}>{hoveredPoint.name}</div>
                <div className={styles.tooltipRow}>
                  <span>Revenue:</span>
                  <span>{formatCurrency(hoveredPoint.category.totalRevenue)}</span>
                </div>
                <div className={styles.tooltipRow}>
                  <span>Margin:</span>
                  <span>{hoveredPoint.category.marginRatePct.toFixed(1)}%</span>
                </div>
                <div className={styles.tooltipRow}>
                  <span>Qty:</span>
                  <span>{hoveredPoint.category.totalQuantity.toLocaleString()}</span>
                </div>
              </div>
            )}
          </div>
        </div>

        {/* X-Axis Label */}
        <div className={styles.xAxisLabel}>
          {xMetric === 'revenue' ? 'Revenue' : 'Quantity'}
        </div>
      </div>
    </div>
  );
};

export default BcgScatterChart;
