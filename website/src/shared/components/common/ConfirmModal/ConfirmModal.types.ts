/**
 * ConfirmModal Types
 * Flexible confirmation modal with async action support
 */

export type ConfirmModalVariant = 'info' | 'warning' | 'error' | 'success';

export interface ConfirmModalProps {
  /**
   * Whether the modal is open
   */
  isOpen: boolean;

  /**
   * Callback when modal is closed/cancelled
   */
  onClose: () => void;

  /**
   * Async callback when confirmation is clicked
   * Return true for success, false for failure
   */
  onConfirm: () => void | Promise<void | boolean>;

  /**
   * Modal variant/style
   * @default 'info'
   */
  variant?: ConfirmModalVariant;

  /**
   * Modal header title
   */
  title: string;

  /**
   * Optional header icon (overrides default variant icon)
   */
  headerIcon?: React.ReactNode;

  /**
   * Main warning/info message
   */
  message?: string;

  /**
   * Optional warning icon (for message section)
   */
  messageIcon?: React.ReactNode;

  /**
   * Show warning section with message
   * @default true if message is provided
   */
  showWarningSection?: boolean;

  /**
   * Warning section background color
   * @default '#FFF9E6' (yellow tint)
   */
  warningSectionBackground?: string;

  /**
   * Warning section border color
   * @default '#FFE5B4'
   */
  warningSectionBorder?: string;

  /**
   * Custom content to display (flexible data display)
   */
  children?: React.ReactNode;

  /**
   * Loading state during async action
   */
  isLoading?: boolean;

  /**
   * Confirm button text
   * @default 'OK'
   */
  confirmText?: string;

  /**
   * Cancel button text
   * @default 'Cancel'
   */
  cancelText?: string;

  /**
   * Confirm button variant
   * @default 'error' (red button)
   */
  confirmButtonVariant?: 'primary' | 'error' | 'success' | 'warning';

  /**
   * Show confirm button icon
   * @default true
   */
  showConfirmIcon?: boolean;

  /**
   * Custom confirm button icon
   */
  confirmIcon?: React.ReactNode;

  /**
   * Modal width
   * @default '500px'
   */
  width?: string;

  /**
   * Header background color (overrides variant default)
   * @default varies by variant
   */
  headerBackground?: string;

  /**
   * Close on backdrop click
   * @default false (prevent accidental close)
   */
  closeOnBackdropClick?: boolean;

  /**
   * Close on ESC key
   * @default true
   */
  closeOnEscape?: boolean;

  /**
   * z-index override
   */
  zIndex?: number;

  /**
   * Additional className
   */
  className?: string;
}
