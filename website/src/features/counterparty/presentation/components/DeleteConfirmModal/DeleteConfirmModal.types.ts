/**
 * DeleteConfirmModal Type Definitions
 */

export interface DeleteConfirmModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => Promise<void>;
}
