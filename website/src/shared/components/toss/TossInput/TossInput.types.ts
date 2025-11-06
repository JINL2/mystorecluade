/**
 * TossInput Component Types
 * TypeScript type definitions for TossInput component
 */

import { ReactNode, InputHTMLAttributes, ChangeEvent, FocusEvent } from 'react';

/**
 * Input variants based on Toss design system
 */
export type TossInputVariant = 'default' | 'error' | 'success' | 'warning';

/**
 * Input sizes
 */
export type TossInputSize = 'sm' | 'md' | 'lg';

/**
 * TossInput component props
 */
export interface TossInputProps extends Omit<InputHTMLAttributes<HTMLInputElement>, 'size'> {
  /**
   * Input label
   */
  label?: string;

  /**
   * Input variant (design style)
   * @default 'default'
   */
  variant?: TossInputVariant;

  /**
   * Input size
   * @default 'md'
   */
  size?: TossInputSize;

  /**
   * Error message
   */
  error?: string;

  /**
   * Success message
   */
  success?: string;

  /**
   * Helper text
   */
  helperText?: string;

  /**
   * Icon to display on the left
   */
  iconLeft?: ReactNode;

  /**
   * Icon to display on the right
   */
  iconRight?: ReactNode;

  /**
   * Show password toggle button (for password inputs)
   * @default true for type="password"
   */
  showPasswordToggle?: boolean;

  /**
   * Show character count
   * @default false
   */
  showCharCount?: boolean;

  /**
   * Required field indicator
   * @default false
   */
  required?: boolean;

  /**
   * Full width input
   * @default false
   */
  fullWidth?: boolean;

  /**
   * Change event handler
   */
  onChange?: (event: ChangeEvent<HTMLInputElement>) => void;

  /**
   * Focus event handler
   */
  onFocus?: (event: FocusEvent<HTMLInputElement>) => void;

  /**
   * Blur event handler
   */
  onBlur?: (event: FocusEvent<HTMLInputElement>) => void;

  /**
   * Additional CSS class names
   */
  className?: string;
}
