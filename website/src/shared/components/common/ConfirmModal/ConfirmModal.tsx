/**
 * ConfirmModal Component
 * Toss-style confirmation modal with flexible configuration and async action support
 *
 * Features:
 * - Multiple variants (info, warning, error, success)
 * - Async action handling with loading state
 * - Flexible content display
 * - Customizable header and buttons
 * - Warning section support
 * - Full Toss Design System compliance
 */

import React, { useEffect, useCallback } from 'react';
import styles from './ConfirmModal.module.css';
import type { ConfirmModalProps } from './ConfirmModal.types';
import { LoadingAnimation } from '../LoadingAnimation';

// Default header icons for each variant
const DefaultHeaderIcons = {
  info: (
    <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
      <path d="M12,2A7,7 0 0,1 19,9C19,11.38 17.81,13.47 16,14.74V17A1,1 0 0,1 15,18H9A1,1 0 0,1 8,17V14.74C6.19,13.47 5,11.38 5,9A7,7 0 0,1 12,2M9,21V20H15V21A1,1 0 0,1 14,22H10A1,1 0 0,1 9,21M12,4A5,5 0 0,0 7,9C7,11.05 8.23,12.81 10,13.58V16H14V13.58C15.77,12.81 17,11.05 17,9A5,5 0 0,0 12,4Z" />
    </svg>
  ),
  warning: (
    <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
      <path d="M12,2L1,21H23M12,6L19.53,19H4.47M11,10V14H13V10M11,16V18H13V16" />
    </svg>
  ),
  error: (
    <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
      <path d="M12,2L1,21H23M12,6L19.53,19H4.47M11,10V14H13V10M11,16V18H13V16" />
    </svg>
  ),
  success: (
    <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
      <path d="M12,2A10,10 0 0,1 22,12A10,10 0 0,1 12,22A10,10 0 0,1 2,12A10,10 0 0,1 12,2M12,4A8,8 0 0,0 4,12A8,8 0 0,0 12,20A8,8 0 0,0 20,12A8,8 0 0,0 12,4M11,16.5L6.5,12L7.91,10.59L11,13.67L16.59,8.09L18,9.5L11,16.5Z" />
    </svg>
  ),
};

// Default confirm button icon (checkmark)
const DefaultConfirmIcon = (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="white">
    <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z" />
  </svg>
);

// Default warning message icon
const DefaultWarningIcon = (
  <svg width="24" height="24" viewBox="0 0 24 24" fill="#F59E0B">
    <path d="M12,2L1,21H23M12,6L19.53,19H4.47M11,10V14H13V10M11,16V18H13V16" />
  </svg>
);

export const ConfirmModal: React.FC<ConfirmModalProps> = ({
  isOpen,
  onClose,
  onConfirm,
  variant = 'info',
  title,
  headerIcon,
  message,
  messageIcon,
  showWarningSection,
  warningSectionBackground = '#FFF9E6',
  warningSectionBorder = '#FFE5B4',
  children,
  isLoading = false,
  confirmText = 'OK',
  cancelText = 'Cancel',
  confirmButtonVariant = 'error',
  showConfirmIcon = true,
  confirmIcon,
  width = '500px',
  headerBackground,
  closeOnBackdropClick = false,
  closeOnEscape = true,
  zIndex = 1000,
  className = '',
}) => {
  // Close on ESC key
  useEffect(() => {
    if (!closeOnEscape || !isOpen || isLoading) return;

    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        onClose();
      }
    };

    document.addEventListener('keydown', handleKeyDown);
    return () => document.removeEventListener('keydown', handleKeyDown);
  }, [isOpen, closeOnEscape, isLoading, onClose]);

  // Handle backdrop click
  const handleBackdropClick = useCallback(
    (e: React.MouseEvent<HTMLDivElement>) => {
      if (closeOnBackdropClick && !isLoading && e.target === e.currentTarget) {
        onClose();
      }
    },
    [closeOnBackdropClick, isLoading, onClose]
  );

  // Handle confirm
  const handleConfirm = useCallback(async () => {
    if (isLoading) return;

    try {
      const result = onConfirm();

      // If it's a promise, wait for it
      if (result && typeof result === 'object' && 'then' in result) {
        await result;
      }
    } catch (error) {
      console.error('ConfirmModal: Error in onConfirm:', error);
    }
  }, [isLoading, onConfirm]);

  // Handle cancel
  const handleCancel = useCallback(() => {
    if (!isLoading) {
      onClose();
    }
  }, [isLoading, onClose]);

  if (!isOpen) return null;

  // Determine header background color based on variant
  // Default colors from Toss Design System
  const getHeaderBackground = () => {
    if (headerBackground) return headerBackground;

    switch (variant) {
      case 'info':
        return '#4169E1'; // Toss Blue-ish (default)
      case 'warning':
        return '#FF9500'; // Toss Orange
      case 'error':
        return '#FF5847'; // Toss Red
      case 'success':
        return '#00C896'; // Toss Green
      default:
        return '#4169E1';
    }
  };

  // Get confirm button class based on variant
  const getConfirmButtonClass = () => {
    switch (confirmButtonVariant) {
      case 'primary':
        return styles.confirmButtonPrimary;
      case 'error':
        return styles.confirmButtonError;
      case 'success':
        return styles.confirmButtonSuccess;
      case 'warning':
        return styles.confirmButtonWarning;
      default:
        return styles.confirmButtonError;
    }
  };

  // Determine if warning section should be shown
  const shouldShowWarning = showWarningSection ?? (message !== undefined && message !== '');

  // Get header icon
  const displayHeaderIcon = headerIcon !== undefined ? headerIcon : DefaultHeaderIcons[variant];

  // Get confirm icon
  const displayConfirmIcon = confirmIcon !== undefined ? confirmIcon : DefaultConfirmIcon;

  return (
    <div className={styles.modalOverlay} onClick={handleBackdropClick} style={{ zIndex }}>
      <div
        className={`${styles.modalContainer} ${className}`}
        style={{ maxWidth: width, zIndex: zIndex + 1 }}
      >
        {/* Modal Header */}
        <div
          className={styles.modalHeader}
          style={{ background: getHeaderBackground() }}
        >
          {displayHeaderIcon && (
            <div className={styles.headerIcon}>{displayHeaderIcon}</div>
          )}
          <div className={styles.headerContent}>
            <h2 className={styles.modalTitle}>{title}</h2>
          </div>
        </div>

        {/* Modal Body */}
        <div className={styles.modalBody}>
          {/* Warning Section */}
          {shouldShowWarning && (
            <div
              className={styles.warningSection}
              style={{
                background: warningSectionBackground,
                borderColor: warningSectionBorder,
              }}
            >
              <div className={styles.warningIcon}>
                {messageIcon !== undefined ? messageIcon : DefaultWarningIcon}
              </div>
              <div className={styles.warningContent}>
                <div className={styles.warningText}>{message}</div>
              </div>
            </div>
          )}

          {/* Custom Content */}
          {children && (
            <div className={styles.contentSection}>
              {children}
            </div>
          )}
        </div>

        {/* Modal Footer */}
        <div className={styles.modalFooter}>
          <button
            className={styles.cancelButton}
            onClick={handleCancel}
            disabled={isLoading}
            type="button"
          >
            {cancelText}
          </button>
          <button
            className={`${styles.confirmButton} ${getConfirmButtonClass()}`}
            onClick={handleConfirm}
            disabled={isLoading}
            type="button"
          >
            {isLoading ? (
              <LoadingAnimation size="small" />
            ) : (
              <>
                {showConfirmIcon && displayConfirmIcon}
                {confirmText}
              </>
            )}
          </button>
        </div>
      </div>
    </div>
  );
};

export default ConfirmModal;
