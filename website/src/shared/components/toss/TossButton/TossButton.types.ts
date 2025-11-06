/**
 * TossButton Component Types
 * TypeScript type definitions for TossButton component
 */

import { ReactNode, MouseEvent } from 'react';

/**
 * Button variants based on Toss design system
 */
export type TossButtonVariant = 'primary' | 'secondary' | 'outline' | 'ghost' | 'text' | 'success' | 'error' | 'warning' | 'info';

/**
 * Button sizes
 */
export type TossButtonSize = 'sm' | 'md' | 'lg' | 'xl';

/**
 * TossButton component props
 */
export interface TossButtonProps {
  /**
   * Button text label
   */
  label?: string;

  /**
   * Button variant (design style)
   * @default 'primary'
   */
  variant?: TossButtonVariant;

  /**
   * Button size
   * @default 'md'
   */
  size?: TossButtonSize;

  /**
   * Click event handler
   */
  onClick?: (event: MouseEvent<HTMLButtonElement>) => void;

  /**
   * Disabled state
   * @default false
   */
  disabled?: boolean;

  /**
   * Full width button
   * @default false
   */
  fullWidth?: boolean;

  /**
   * Loading state
   * @default false
   */
  loading?: boolean;

  /**
   * Icon element (optional)
   */
  icon?: ReactNode;

  /**
   * Icon position
   * @default 'left'
   */
  iconPosition?: 'left' | 'right';

  /**
   * Button children (alternative to label)
   */
  children?: ReactNode;

  /**
   * Button type attribute
   * @default 'button'
   */
  type?: 'button' | 'submit' | 'reset';

  /**
   * Additional CSS class names
   */
  className?: string;

  /**
   * Button HTML attributes
   */
  [key: string]: any;
}
