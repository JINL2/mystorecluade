/**
 * CashEndingConfirmModal Types
 */

export interface CashEndingConfirmModalProps {
  /**
   * Whether the modal is open
   */
  isOpen: boolean;

  /**
   * Callback when modal is closed
   */
  onClose: () => void;

  /**
   * Callback when confirmation is clicked
   */
  onConfirm: () => void;

  /**
   * Modal title
   */
  title: string;

  /**
   * Location name to display
   */
  locationName: string;

  /**
   * Variance amount to display
   */
  variance: number;

  /**
   * Type of operation (error or exchange)
   */
  type: 'error' | 'exchange';

  /**
   * Loading state during RPC call
   */
  isLoading?: boolean;
}
