/**
 * ExpenseChart Component
 * Displays monthly expense breakdown as a donut chart
 */

import React from 'react';
import { Chart as ChartJS, ArcElement, Tooltip, Legend } from 'chart.js';
import { Doughnut } from 'react-chartjs-2';
import type { ExpenseChartProps } from './ExpenseChart.types';
import styles from './ExpenseChart.module.css';

// Register Chart.js components
ChartJS.register(ArcElement, Tooltip, Legend);

export const ExpenseChart: React.FC<ExpenseChartProps> = ({
  data,
  formatCurrency
}) => {
  // If no data, show empty state
  if (!data || data.length === 0) {
    return (
      <div className={styles.emptyChart}>
        <p>No expense data available for this month</p>
      </div>
    );
  }

  // Generate chart colors
  const generateChartColors = (count: number): string[] => {
    const baseColors = [
      '#0064FF', // Toss primary blue
      '#00C896', // Toss success green
      '#FF9500', // Toss warning orange
      '#FF5847', // Toss error red
      '#6C757D', // Gray 600
      '#8B4FC3', // Purple
      '#00D2FF', // Cyan
      '#FFD700', // Gold
      '#FF69B4', // Pink
      '#32CD32'  // Lime
    ];

    const colors: string[] = [];
    for (let i = 0; i < count; i++) {
      colors.push(baseColors[i % baseColors.length]);
    }
    return colors;
  };

  // Prepare chart data
  const chartData = {
    labels: data.map(item => item.category),
    datasets: [{
      data: data.map(item => item.amount),
      backgroundColor: generateChartColors(data.length),
      borderWidth: 0,
      hoverOffset: 4
    }]
  };

  // Chart options
  const options = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        position: 'right' as const,
        labels: {
          usePointStyle: true,
          font: {
            family: 'Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
            size: 14
          },
          color: '#495057',
          padding: 12,
          generateLabels: (chart: any) => {
            const datasets = chart.data.datasets;
            return chart.data.labels.map((label: string, i: number) => {
              const percentage = data[i]?.percentage || 0;
              return {
                text: `${label} (${percentage.toFixed(1)}%)`,
                fillStyle: datasets[0].backgroundColor[i],
                strokeStyle: datasets[0].backgroundColor[i],
                lineWidth: 0,
                hidden: false,
                index: i
              };
            });
          }
        }
      },
      tooltip: {
        callbacks: {
          label: function(context: any) {
            const label = context.label || '';
            const value = context.parsed || 0;
            const percentage = data[context.dataIndex]?.percentage || 0;
            return `${label}: ${formatCurrency(value)} (${percentage.toFixed(1)}%)`;
          }
        }
      }
    },
    cutout: '65%',
    animation: {
      animateRotate: true,
      duration: 1000
    }
  };

  return (
    <div className={styles.chartContainer}>
      <Doughnut data={chartData} options={options} />
    </div>
  );
};

export default ExpenseChart;
