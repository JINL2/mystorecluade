/**
 * useErrorMessage Hook
 * Easy-to-use hook for showing error messages
 *
 * Usage:
 * const { showError, showWarning, showInfo, showSuccess } = useErrorMessage();
 *
 * showError({
 *   title: 'Access Denied',
 *   message: 'You do not have permission to access this page.',
 *   details: 'Required permission: journal_input'
 * });
 */

import { useState, useCallback } from 'react';
import type { ErrorMessageProps, ErrorMessageVariant } from '@/shared/components/common/ErrorMessage';

interface ShowMessageOptions {
  title?: string;
  message: string;
  details?: string;
  autoCloseDuration?: number;
  confirmText?: string;
  actionText?: string;
  onAction?: () => void;
  onConfirm?: () => void;
  closeOnBackdropClick?: boolean;
}

interface ErrorMessageState extends ShowMessageOptions {
  variant: ErrorMessageVariant;
  isOpen: boolean;
}

export const useErrorMessage = () => {
  const [messageState, setMessageState] = useState<ErrorMessageState>({
    variant: 'error',
    message: '',
    isOpen: false,
  });

  const closeMessage = useCallback(() => {
    setMessageState((prev) => ({ ...prev, isOpen: false }));
  }, []);

  const showMessage = useCallback(
    (variant: ErrorMessageVariant, options: ShowMessageOptions) => {
      setMessageState({
        variant,
        ...options,
        isOpen: true,
      });
    },
    []
  );

  const showError = useCallback(
    (options: ShowMessageOptions) => {
      showMessage('error', options);
    },
    [showMessage]
  );

  const showWarning = useCallback(
    (options: ShowMessageOptions) => {
      showMessage('warning', options);
    },
    [showMessage]
  );

  const showInfo = useCallback(
    (options: ShowMessageOptions) => {
      showMessage('info', options);
    },
    [showMessage]
  );

  const showSuccess = useCallback(
    (options: ShowMessageOptions) => {
      showMessage('success', options);
    },
    [showMessage]
  );

  return {
    messageState,
    closeMessage,
    showError,
    showWarning,
    showInfo,
    showSuccess,
  };
};
