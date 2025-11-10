/**
 * ErrorMessage Component
 * Toss-style error/notification message with flexible configuration
 *
 * Features:
 * - Multiple variants (error, warning, info, success)
 * - Flexible positioning
 * - Auto-close capability
 * - Optional backdrop
 * - Action buttons
 * - Fully customizable
 */

import React, { useEffect, useCallback } from 'react';
import type { ErrorMessageProps } from './ErrorMessage.types';
import styles from './ErrorMessage.module.css';

// Default icons for each variant
const DefaultIcons = {
  error: (
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
      <path
        d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
        stroke="currentColor"
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  ),
  warning: (
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
      <path
        d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
        stroke="currentColor"
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  ),
  info: (
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
      <path
        d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
        stroke="currentColor"
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  ),
  success: (
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
      <path
        d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
        stroke="currentColor"
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  ),
};

export const ErrorMessage: React.FC<ErrorMessageProps> = ({
  variant = 'error',
  title,
  message,
  details,
  isOpen,
  onClose,
  autoCloseDuration = 0,
  position = 'center',
  icon,
  showCloseButton = true,
  actionText,
  onAction,
  className = '',
  zIndex,
  showBackdrop = true,
  closeOnBackdropClick = true,
}) => {
  // Auto-close timer
  useEffect(() => {
    if (isOpen && autoCloseDuration > 0) {
      const timer = setTimeout(() => {
        onClose();
      }, autoCloseDuration);

      return () => clearTimeout(timer);
    }
  }, [isOpen, autoCloseDuration, onClose]);

  // Close on ESC key
  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape' && isOpen) {
        onClose();
      }
    };

    if (isOpen) {
      document.addEventListener('keydown', handleKeyDown);
      return () => document.removeEventListener('keydown', handleKeyDown);
    }
  }, [isOpen, onClose]);

  // Handle backdrop click
  const handleBackdropClick = useCallback(
    (e: React.MouseEvent<HTMLDivElement>) => {
      if (closeOnBackdropClick && e.target === e.currentTarget) {
        onClose();
      }
    },
    [closeOnBackdropClick, onClose]
  );

  // Handle action button click
  const handleAction = useCallback(() => {
    if (onAction) {
      onAction();
    }
    onClose();
  }, [onAction, onClose]);

  if (!isOpen) return null;

  // Determine container class
  const containerClass = [
    styles.container,
    styles[`position${position.split('-').map((s) => s.charAt(0).toUpperCase() + s.slice(1)).join('')}`],
    className,
  ]
    .filter(Boolean)
    .join(' ');

  // Determine variant class
  const variantClass = styles[`variant${variant.charAt(0).toUpperCase()}${variant.slice(1)}`];

  // Get icon
  const displayIcon = icon !== undefined ? icon : DefaultIcons[variant];

  return (
    <>
      {/* Backdrop */}
      {showBackdrop && (
        <div
          className={`${styles.backdrop} ${!closeOnBackdropClick ? styles.backdropHidden : ''}`}
          onClick={handleBackdropClick}
          style={zIndex ? { zIndex } : undefined}
        />
      )}

      {/* Message container */}
      <div
        className={containerClass}
        style={zIndex ? { zIndex: zIndex + 1 } : undefined}
        role="alert"
        aria-live="assertive"
      >
        <div className={`${styles.messageBox} ${variantClass}`}>
          {/* Close button */}
          {showCloseButton && (
            <button
              type="button"
              className={styles.closeButton}
              onClick={onClose}
              aria-label="Close message"
            >
              <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                <path
                  d="M12 4L4 12M4 4l8 8"
                  stroke="currentColor"
                  strokeWidth="2"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              </svg>
            </button>
          )}

          {/* Header */}
          <div className={styles.header}>
            {/* Icon */}
            {displayIcon && <div className={styles.iconContainer}>{displayIcon}</div>}

            {/* Content */}
            <div className={styles.content}>
              {title && <h3 className={styles.title}>{title}</h3>}
              <p className={styles.message}>{message}</p>
              {details && <pre className={styles.details}>{details}</pre>}
            </div>
          </div>

          {/* Actions */}
          {(actionText || onAction) && (
            <div className={styles.actions}>
              {actionText && (
                <button
                  type="button"
                  className={`${styles.actionButton} ${styles.actionButtonPrimary}`}
                  onClick={handleAction}
                >
                  {actionText}
                </button>
              )}
              <button
                type="button"
                className={`${styles.actionButton} ${styles.actionButtonSecondary}`}
                onClick={onClose}
              >
                닫기
              </button>
            </div>
          )}
        </div>
      </div>
    </>
  );
};

export default ErrorMessage;
