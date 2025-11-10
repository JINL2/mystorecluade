/**
 * ErrorMessage Component Types
 * Toss-style error/notification message with flexible configuration
 */

export type ErrorMessageVariant = 'error' | 'warning' | 'info' | 'success';

export type ErrorMessagePosition =
  | 'top-center'
  | 'top-right'
  | 'top-left'
  | 'bottom-center'
  | 'bottom-right'
  | 'bottom-left'
  | 'center';

export interface ErrorMessageProps {
  /** Message variant/type */
  variant?: ErrorMessageVariant;

  /** Main title/heading */
  title?: string;

  /** Description text */
  message: string;

  /** Additional details (optional) */
  details?: string;

  /** Show/hide state */
  isOpen: boolean;

  /** Callback when message is closed */
  onClose: () => void;

  /** Auto-close after duration (ms), 0 = no auto-close */
  autoCloseDuration?: number;

  /** Position on screen */
  position?: ErrorMessagePosition;

  /** Custom icon component */
  icon?: React.ReactNode;

  /** Show close button */
  showCloseButton?: boolean;

  /** Action button text */
  actionText?: string;

  /** Action button callback */
  onAction?: () => void;

  /** Additional className */
  className?: string;

  /** z-index override */
  zIndex?: number;

  /** Enable/disable backdrop overlay */
  showBackdrop?: boolean;

  /** Close on backdrop click */
  closeOnBackdropClick?: boolean;
}
