/**
 * CategoryTrendChart Component
 * Line chart showing category revenue trends over time
 */

import React, { useCallback, useMemo } from 'react';
import type { CategoryTrendChartProps, TrendDataPoint } from './CategoryTrendChart.types';
import styles from './CategoryTrendChart.module.css';

// Format currency value
const formatCurrency = (value: number, symbol: string): string => {
  if (value >= 1000000000) {
    return `${symbol}${(value / 1000000000).toFixed(1)}B`;
  } else if (value >= 1000000) {
    return `${symbol}${(value / 1000000).toFixed(1)}M`;
  } else if (value >= 1000) {
    return `${symbol}${(value / 1000).toFixed(1)}K`;
  }
  return `${symbol}${value.toFixed(0)}`;
};

// Format date for display
const formatDate = (dateStr: string): string => {
  const date = new Date(dateStr);
  return `${date.getMonth() + 1}/${date.getDate()}`;
};

// Simple Line Chart using CSS positioning (no SVG distortion)
const LineChart: React.FC<{
  data: TrendDataPoint[];
  currencySymbol: string;
}> = ({ data, currencySymbol }) => {
  const chartData = useMemo(() => {
    if (data.length === 0) return null;

    const values = data.map(d => d.value);
    const maxValue = Math.max(...values);
    const minValue = Math.min(...values);
    const range = maxValue - minValue || 1;

    // Calculate percentage positions
    const points = data.map((d, i) => {
      const xPercent = (i / Math.max(1, data.length - 1)) * 100;
      const yPercent = ((d.value - minValue) / range) * 100; // 0 = bottom, 100 = top
      return { xPercent, yPercent, ...d };
    });

    return { points, maxValue, minValue };
  }, [data]);

  if (!chartData || data.length === 0) {
    return null;
  }

  // Get X-axis label points (show ~5 labels)
  const xLabelPoints = chartData.points.filter((_, i) =>
    i % Math.max(1, Math.floor(data.length / 5)) === 0 || i === data.length - 1
  );

  // Build SVG path using percentage coordinates
  const buildPath = () => {
    return chartData.points.map((p, i) =>
      `${i === 0 ? 'M' : 'L'} ${p.xPercent} ${100 - p.yPercent}`
    ).join(' ');
  };

  const buildAreaPath = () => {
    const linePath = buildPath();
    const lastX = chartData.points[chartData.points.length - 1].xPercent;
    const firstX = chartData.points[0].xPercent;
    return `${linePath} L ${lastX} 100 L ${firstX} 100 Z`;
  };

  return (
    <div className={styles.chartWrapper}>
      {/* Y-axis labels */}
      <div className={styles.yAxisLabels}>
        <span>{formatCurrency(chartData.maxValue, currencySymbol)}</span>
        <span>{formatCurrency((chartData.maxValue + chartData.minValue) / 2, currencySymbol)}</span>
        <span>{formatCurrency(chartData.minValue, currencySymbol)}</span>
      </div>

      {/* Chart area */}
      <div className={styles.chartMain}>
        {/* Grid lines */}
        <div className={styles.gridLines}>
          <div className={styles.gridLine} />
          <div className={styles.gridLine} />
          <div className={styles.gridLine} />
        </div>

        {/* Chart content with fixed aspect ratio container */}
        <div className={styles.chartContent}>
          {/* SVG for line and area only */}
          <svg
            className={styles.chartSvg}
            viewBox="0 0 100 100"
            preserveAspectRatio="none"
          >
            {/* Area fill */}
            <path d={buildAreaPath()} fill="url(#categoryTrendGradient)" />

            {/* Line */}
            <path
              d={buildPath()}
              fill="none"
              stroke="#0064FF"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
              vectorEffect="non-scaling-stroke"
            />

            {/* Gradient definition */}
            <defs>
              <linearGradient id="categoryTrendGradient" x1="0%" y1="0%" x2="0%" y2="100%">
                <stop offset="0%" stopColor="#0064FF" stopOpacity="0.15" />
                <stop offset="100%" stopColor="#0064FF" stopOpacity="0.02" />
              </linearGradient>
            </defs>
          </svg>

          {/* Data points as absolutely positioned divs (won't distort) */}
          {chartData.points.map((point, i) => (
            <div
              key={i}
              className={styles.dataPoint}
              style={{
                left: `${point.xPercent}%`,
                bottom: `${point.yPercent}%`,
              }}
            />
          ))}
        </div>

        {/* X-axis labels */}
        <div className={styles.xAxisLabels}>
          {xLabelPoints.map((point, i) => (
            <span key={i} style={{ left: `${point.xPercent}%` }}>
              {formatDate(point.date)}
            </span>
          ))}
        </div>
      </div>
    </div>
  );
};

export const CategoryTrendChart: React.FC<CategoryTrendChartProps> = ({
  data,
  categories,
  selectedCategoryId,
  onCategorySelect,
  loading = false,
  currencySymbol = '$',
  className = '',
}) => {
  const handleChipClick = useCallback((categoryId: string | null) => {
    onCategorySelect(categoryId);
  }, [onCategorySelect]);

  // Get selected category name
  const selectedCategoryName = useMemo(() => {
    if (!selectedCategoryId) return 'All';
    const category = categories.find(c => c.id === selectedCategoryId);
    return category?.name || 'All';
  }, [selectedCategoryId, categories]);

  return (
    <div className={`${styles.container} ${className}`}>
      {/* Header */}
      <div className={styles.header}>
        <svg className={styles.icon} viewBox="0 0 24 24" fill="currentColor">
          <path d="M16,11.78L20.24,4.45L21.97,5.45L16.74,14.5L10.23,10.75L5.46,19H22V21H2V3H4V17.54L9.5,8L16,11.78Z" />
        </svg>
        <h3 className={styles.title}>
          {selectedCategoryId ? `${selectedCategoryName} Trend` : 'Category Trend'}
        </h3>
      </div>

      {/* Category Filter Chips */}
      <div className={styles.categoryChips}>
        <button
          className={`${styles.chip} ${!selectedCategoryId ? styles.active : ''}`}
          onClick={() => handleChipClick(null)}
        >
          All
        </button>
        {categories.slice(0, 5).map((category) => (
          <button
            key={category.id}
            className={`${styles.chip} ${selectedCategoryId === category.id ? styles.active : ''}`}
            onClick={() => handleChipClick(category.id)}
          >
            {category.name.length > 12 ? `${category.name.slice(0, 12)}...` : category.name}
          </button>
        ))}
      </div>

      {/* Chart Area */}
      <div className={styles.chartArea}>
        {loading ? (
          <div className={styles.loadingState}>Loading...</div>
        ) : data.length === 0 ? (
          <div className={styles.emptyState}>
            <svg className={styles.emptyIcon} viewBox="0 0 24 24" fill="currentColor">
              <path d="M16,11.78L20.24,4.45L21.97,5.45L16.74,14.5L10.23,10.75L5.46,19H22V21H2V3H4V17.54L9.5,8L16,11.78Z" />
            </svg>
            <span>No trend data available</span>
          </div>
        ) : (
          <LineChart data={data} currencySymbol={currencySymbol} />
        )}
      </div>
    </div>
  );
};

export default CategoryTrendChart;
