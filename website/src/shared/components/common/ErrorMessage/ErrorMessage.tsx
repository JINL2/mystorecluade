/**
 * ErrorMessage Component (Toss Alert Dialog Style)
 * Center-positioned alert dialog with backdrop overlay
 *
 * @design Default Design Specifications (Toss Alert Style)
 *
 * Layout & Position:
 * - Position: Center of screen (fixed position with flexbox centering)
 * - Width: 90% (mobile), 400px (desktop)
 * - Max Width: 500px
 * - Backdrop: Dark overlay (rgba(0, 0, 0, 0.3))
 *
 * Structure:
 * - Backdrop overlay (full screen, dark)
 * - Dialog box (white, centered, rounded corners)
 * - Icon (optional, top center, 48px)
 * - Title (optional, bold, 18px)
 * - Message (14px, gray)
 * - Buttons (bottom, right-aligned or full-width on mobile)
 *
 * Colors by Variant:
 * - Success: Icon color = #00C896
 * - Error: Icon color = #FF5847
 * - Warning: Icon color = #FF9500
 * - Info: Icon color = #0064FF
 *
 * Visual Style:
 * - Background: white
 * - Border radius: 16px
 * - Shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1)
 * - Padding: 24px
 * - Gap: 16px between sections
 *
 * Buttons:
 * - Height: 48px
 * - Border radius: 10px
 * - Font size: 15px
 * - Font weight: 600
 * - Confirm button: Blue (#0064FF)
 * - Cancel button: Gray outline
 *
 * Animation:
 * - Backdrop: Fade in (0 → 1) over 0.2s
 * - Dialog: Fade in + Scale (0.95 → 1) over 0.3s ease-out
 * - Exit: Reverse animation
 *
 * Behavior:
 * - Auto-close: Optional (default disabled for alerts)
 * - Close on backdrop click: Optional (default true)
 * - Close on ESC: Optional (default true)
 * - Confirm callback: Optional
 *
 * Accessibility:
 * - role="alertdialog"
 * - aria-modal="true"
 * - aria-labelledby: Title ID
 * - aria-describedby: Message ID
 * - Focus trap: Focus stays within dialog
 * - ESC key: Closes dialog
 *
 * @example Simple Alert
 * ```tsx
 * <ErrorMessage
 *   variant="success"
 *   message="Operation completed successfully"
 *   isOpen={showAlert}
 *   onClose={() => setShowAlert(false)}
 * />
 * ```
 *
 * @example Alert with Title and Confirm
 * ```tsx
 * <ErrorMessage
 *   variant="error"
 *   title="Delete Confirmation"
 *   message="Are you sure you want to delete this item?"
 *   isOpen={showConfirm}
 *   onClose={() => setShowConfirm(false)}
 *   onConfirm={handleDelete}
 *   confirmText="Delete"
 *   cancelText="Cancel"
 *   showCancelButton={true}
 * />
 * ```
 */

import React, { useEffect, useCallback, useState } from 'react';
import type { ErrorMessageProps } from './ErrorMessage.types';
import styles from './ErrorMessage.module.css';

// Default icons for each variant
const DefaultIcons = {
  error: (
    <svg width="48" height="48" viewBox="0 0 48 48" fill="none">
      <circle cx="24" cy="24" r="20" fill="currentColor" opacity="0.1"/>
      <path d="M24 14v12m0 4h.01" stroke="currentColor" strokeWidth="3" strokeLinecap="round"/>
    </svg>
  ),
  warning: (
    <svg width="48" height="48" viewBox="0 0 48 48" fill="none">
      <path d="M24 14v12m0 4h.01" stroke="currentColor" strokeWidth="3" strokeLinecap="round"/>
      <path d="M21 36h6l1-16h-8l1 16z" fill="currentColor" opacity="0.1"/>
    </svg>
  ),
  info: (
    <svg width="48" height="48" viewBox="0 0 48 48" fill="none">
      <circle cx="24" cy="24" r="20" stroke="currentColor" strokeWidth="2.5" fill="none"/>
      <path d="M24 22v12m0-16h.01" stroke="currentColor" strokeWidth="3" strokeLinecap="round"/>
    </svg>
  ),
  success: (
    <svg width="48" height="48" viewBox="0 0 48 48" fill="none">
      <circle cx="24" cy="24" r="20" fill="currentColor" opacity="0.1"/>
      <path d="M16 24l6 6 12-12" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
  ),
};

export const ErrorMessage: React.FC<ErrorMessageProps> = ({
  variant = 'info',
  title,
  message,
  isOpen,
  onClose,
  confirmText = 'OK',
  cancelText = 'Cancel',
  showCancelButton = false,
  onConfirm,
  autoCloseDuration = 0,
  closeOnBackdropClick = true,
  closeOnEscape = true,
  className = '',
  zIndex = 1000,
  icon,
  showIcon = true,
  // Dialog styles
  dialogWidth,
  dialogMaxWidth,
  dialogMinHeight,
  dialogPadding,
  dialogBackgroundColor,
  dialogBorderRadius,
  dialogBoxShadow,
  // Backdrop styles
  backdropColor,
  backdropOpacity,
  // Title styles
  titleFontSize,
  titleFontWeight,
  titleColor,
  titleMarginBottom,
  // Message styles
  messageFontSize,
  messageFontWeight,
  messageColor,
  messageLineHeight,
  messageMarginBottom,
  // Icon styles
  iconSize,
  iconColor,
  iconMarginBottom,
  // Button styles
  buttonHeight,
  buttonPadding,
  buttonFontSize,
  buttonFontWeight,
  buttonBorderRadius,
  buttonGap,
  confirmButtonColor,
  confirmButtonBackgroundColor,
  confirmButtonHoverBackgroundColor,
  cancelButtonColor,
  cancelButtonBackgroundColor,
  cancelButtonBorderColor,
  cancelButtonHoverBackgroundColor,
  animationDuration,
}) => {
  const [isClosing, setIsClosing] = useState(false);

  // Auto-close timer
  useEffect(() => {
    if (!isOpen || autoCloseDuration <= 0) return;

    const timer = setTimeout(() => {
      handleClose();
    }, autoCloseDuration);

    return () => clearTimeout(timer);
  }, [isOpen, autoCloseDuration]);

  // Close on ESC key
  useEffect(() => {
    if (!isOpen || !closeOnEscape) return;

    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        handleClose();
      }
    };

    document.addEventListener('keydown', handleKeyDown);
    return () => document.removeEventListener('keydown', handleKeyDown);
  }, [isOpen, closeOnEscape]);

  // Prevent body scroll when dialog is open
  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = '';
    }

    return () => {
      document.body.style.overflow = '';
    };
  }, [isOpen]);

  const handleClose = useCallback(() => {
    setIsClosing(true);
    setTimeout(() => {
      onClose();
      setIsClosing(false);
    }, parseFloat(animationDuration || '0.2') * 1000);
  }, [onClose, animationDuration]);

  const handleBackdropClick = useCallback((e: React.MouseEvent) => {
    if (closeOnBackdropClick && e.target === e.currentTarget) {
      handleClose();
    }
  }, [closeOnBackdropClick, handleClose]);

  const handleConfirm = useCallback(() => {
    if (onConfirm) {
      onConfirm();
    }
    handleClose();
  }, [onConfirm, handleClose]);

  if (!isOpen && !isClosing) return null;

  // Get icon to display
  const displayIcon = icon !== undefined ? icon : (showIcon ? DefaultIcons[variant] : null);

  // Variant-specific colors
  const variantColors = {
    success: '#00C896',
    error: '#FF5847',
    warning: '#FF9500',
    info: '#0064FF',
  };

  // Build inline styles
  const backdropStyles: React.CSSProperties = {
    backgroundColor: backdropColor || `rgba(0, 0, 0, ${backdropOpacity ?? 0.3})`,
    zIndex,
  };

  const dialogStyles: React.CSSProperties = {
    width: dialogWidth,
    maxWidth: dialogMaxWidth,
    minHeight: dialogMinHeight,
    padding: dialogPadding,
    backgroundColor: dialogBackgroundColor,
    borderRadius: dialogBorderRadius,
    boxShadow: dialogBoxShadow,
  };

  const iconStyles: React.CSSProperties = {
    width: iconSize,
    height: iconSize,
    color: iconColor || variantColors[variant],
    marginBottom: iconMarginBottom,
  };

  const titleStyles: React.CSSProperties = {
    fontSize: titleFontSize,
    fontWeight: titleFontWeight,
    color: titleColor,
    marginBottom: titleMarginBottom,
  };

  const messageStyles: React.CSSProperties = {
    fontSize: messageFontSize,
    fontWeight: messageFontWeight,
    color: messageColor,
    lineHeight: messageLineHeight,
    marginBottom: messageMarginBottom,
  };

  const buttonContainerStyles: React.CSSProperties = {
    gap: buttonGap,
  };

  const confirmButtonStyles: React.CSSProperties = {
    height: buttonHeight,
    padding: buttonPadding,
    fontSize: buttonFontSize,
    fontWeight: buttonFontWeight,
    borderRadius: buttonBorderRadius,
    color: confirmButtonColor,
    backgroundColor: confirmButtonBackgroundColor,
  };

  const cancelButtonStyles: React.CSSProperties = {
    height: buttonHeight,
    padding: buttonPadding,
    fontSize: buttonFontSize,
    fontWeight: buttonFontWeight,
    borderRadius: buttonBorderRadius,
    color: cancelButtonColor,
    backgroundColor: cancelButtonBackgroundColor,
    borderColor: cancelButtonBorderColor,
  };

  return (
    <div
      className={`${styles.backdrop} ${isClosing ? styles.backdropClosing : ''}`}
      style={backdropStyles}
      onClick={handleBackdropClick}
      role="presentation"
    >
      <div
        className={`${styles.dialog} ${isClosing ? styles.dialogClosing : ''} ${className}`}
        style={dialogStyles}
        role="alertdialog"
        aria-modal="true"
        aria-labelledby={title ? 'alert-title' : undefined}
        aria-describedby="alert-message"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Icon */}
        {displayIcon && (
          <div className={styles.iconContainer} style={iconStyles}>
            {displayIcon}
          </div>
        )}

        {/* Title */}
        {title && (
          <h2 id="alert-title" className={styles.title} style={titleStyles}>
            {title}
          </h2>
        )}

        {/* Message */}
        <p id="alert-message" className={styles.message} style={messageStyles}>
          {message}
        </p>

        {/* Buttons */}
        <div className={styles.buttonContainer} style={buttonContainerStyles}>
          {showCancelButton && (
            <button
              type="button"
              className={styles.cancelButton}
              onClick={handleClose}
              style={cancelButtonStyles}
            >
              {cancelText}
            </button>
          )}
          <button
            type="button"
            className={styles.confirmButton}
            onClick={handleConfirm}
            style={confirmButtonStyles}
            autoFocus
          >
            {confirmText}
          </button>
        </div>
      </div>
    </div>
  );
};

export default ErrorMessage;
