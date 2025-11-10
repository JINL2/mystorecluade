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
 * Custom style props for advanced customization
 */
export interface TossButtonCustomStyles {
  /**
   * Custom background color
   * Overrides variant background color
   */
  backgroundColor?: string;

  /**
   * Custom text color
   * Overrides variant text color
   */
  color?: string;

  /**
   * Custom border color
   */
  borderColor?: string;

  /**
   * Custom border width
   * @default '1px'
   */
  borderWidth?: string;

  /**
   * Custom border radius
   * @default '8px'
   */
  borderRadius?: string;

  /**
   * Custom width
   */
  width?: string;

  /**
   * Custom height
   */
  height?: string;

  /**
   * Custom padding
   */
  padding?: string;

  /**
   * Custom font size
   */
  fontSize?: string;

  /**
   * Custom font weight
   */
  fontWeight?: string | number;
}

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
   * Custom inline styles for advanced customization
   * Use this to override default styles with specific values
   */
  customStyles?: TossButtonCustomStyles;

  /**
   * Button HTML attributes
   */
  [key: string]: any;
}
