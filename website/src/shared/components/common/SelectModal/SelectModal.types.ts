/**
 * SelectModal Types
 * Selection modal for choosing between options
 */

export interface SelectOption {
  /**
   * Unique identifier for the option
   */
  value: string;

  /**
   * Display label for the option
   */
  label: string;

  /**
   * Optional description text below the label
   */
  description?: string;

  /**
   * Optional icon to display
   */
  icon?: React.ReactNode;

  /**
   * Whether this option is disabled
   */
  disabled?: boolean;
}

export type SelectModalVariant = 'info' | 'warning' | 'primary';

export interface SelectModalProps {
  /**
   * Whether the modal is open
   */
  isOpen: boolean;

  /**
   * Callback when modal is closed/cancelled
   */
  onClose: () => void;

  /**
   * Callback when an option is selected
   */
  onSelect: (value: string) => void;

  /**
   * Modal variant/style
   * @default 'primary'
   */
  variant?: SelectModalVariant;

  /**
   * Modal header title
   */
  title: string;

  /**
   * Optional header icon (overrides default variant icon)
   */
  headerIcon?: React.ReactNode;

  /**
   * Optional message/description below title
   */
  message?: string;

  /**
   * Selection options
   */
  options: SelectOption[];

  /**
   * Currently selected value (optional, for highlighting)
   */
  selectedValue?: string;

  /**
   * Cancel button text
   * @default 'Cancel'
   */
  cancelText?: string;

  /**
   * Modal width
   * @default '420px'
   */
  width?: string;

  /**
   * Header background color (overrides variant default)
   */
  headerBackground?: string;

  /**
   * Close on backdrop click
   * @default true
   */
  closeOnBackdropClick?: boolean;

  /**
   * Close on ESC key
   * @default true
   */
  closeOnEscape?: boolean;

  /**
   * z-index override
   * @default 1000
   */
  zIndex?: number;

  /**
   * Additional className
   */
  className?: string;

  /**
   * Loading state
   * @default false
   */
  isLoading?: boolean;
}
