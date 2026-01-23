/**
 * BcgToggleButton Component
 * Animated toggle button matching Flutter app design
 */

import React from 'react';
import type { BcgToggleButtonProps } from './BcgScatterChart.types';
import styles from './BcgScatterChart.module.css';

export const BcgToggleButton: React.FC<BcgToggleButtonProps> = ({
  options,
  selectedValue,
  onChange,
  className = '',
}) => {
  return (
    <div className={`${styles.toggleContainer} ${className}`}>
      {options.map((option) => (
        <button
          key={option.value}
          className={`${styles.toggleButton} ${selectedValue === option.value ? styles.toggleActive : ''}`}
          onClick={() => onChange(option.value)}
        >
          {option.label}
        </button>
      ))}
    </div>
  );
};

export default BcgToggleButton;
