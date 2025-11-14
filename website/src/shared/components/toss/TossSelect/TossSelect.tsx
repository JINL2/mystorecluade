/**
 * TossSelect Component
 * Dropdown select component matching Toss design system
 */

import React from 'react';
import type { TossSelectProps } from './TossSelect.types';
import styles from './TossSelect.module.css';

export const TossSelect: React.FC<TossSelectProps> = ({
  value,
  onChange,
  options,
  placeholder,
  fullWidth = false,
  disabled = false,
  error,
  label,
}) => {
  return (
    <div className={`${styles.container} ${fullWidth ? styles.fullWidth : ''}`}>
      {label && <label className={styles.label}>{label}</label>}
      <div className={`${styles.selectWrapper} ${error ? styles.error : ''}`}>
        <select
          value={value}
          onChange={onChange}
          disabled={disabled}
          className={styles.select}
        >
          {placeholder && (
            <option value="" disabled>
              {placeholder}
            </option>
          )}
          {options.map((option) => (
            <option key={option.value} value={option.value}>
              {option.label}
            </option>
          ))}
        </select>
        <svg
          className={styles.icon}
          width="16"
          height="16"
          viewBox="0 0 16 16"
          fill="currentColor"
        >
          <path d="M4.427 5.927l3.396 3.396a.25.25 0 00.354 0l3.396-3.396A.25.25 0 0011.396 5.5H4.604a.25.25 0 00-.177.427z" />
        </svg>
      </div>
      {error && <div className={styles.errorText}>{error}</div>}
    </div>
  );
};

export default TossSelect;
