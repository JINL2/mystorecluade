/**
 * SelectModal Component
 * Toss-style selection modal for choosing between options
 *
 * Features:
 * - Multiple variants (info, warning, primary)
 * - Customizable options with icons and descriptions
 * - Full Toss Design System compliance
 * - Accessible keyboard navigation
 * - Loading state support
 */

import React, { useEffect, useCallback, useState } from 'react';
import styles from './SelectModal.module.css';
import type { SelectModalProps } from './SelectModal.types';
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
  primary: (
    <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
      <path d="M14,17H7V15H14M17,13H7V11H17M17,9H7V7H17M19,3H5C3.89,3 3,3.89 3,5V19A2,2 0 0,0 5,21H19A2,2 0 0,0 21,19V5C21,3.89 20.1,3 19,3Z" />
    </svg>
  ),
};

// Default arrow icon for options
const ArrowIcon = (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
    <path d="M8.59,16.58L13.17,12L8.59,7.41L10,6L16,12L10,18L8.59,16.58Z" />
  </svg>
);

export const SelectModal: React.FC<SelectModalProps> = ({
  isOpen,
  onClose,
  onSelect,
  variant = 'primary',
  title,
  headerIcon,
  message,
  options,
  selectedValue,
  cancelText = 'Cancel',
  width = '420px',
  headerBackground,
  closeOnBackdropClick = true,
  closeOnEscape = true,
  zIndex = 1000,
  className = '',
  isLoading = false,
}) => {
  const [isClosing, setIsClosing] = useState(false);

  // Close on ESC key
  useEffect(() => {
    if (!closeOnEscape || !isOpen || isLoading) return;

    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        handleClose();
      }
    };

    document.addEventListener('keydown', handleKeyDown);
    return () => document.removeEventListener('keydown', handleKeyDown);
  }, [isOpen, closeOnEscape, isLoading]);

  // Prevent body scroll when modal is open
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
    if (isLoading) return;
    setIsClosing(true);
    setTimeout(() => {
      onClose();
      setIsClosing(false);
    }, 200);
  }, [onClose, isLoading]);

  // Handle backdrop click
  const handleBackdropClick = useCallback(
    (e: React.MouseEvent<HTMLDivElement>) => {
      if (closeOnBackdropClick && !isLoading && e.target === e.currentTarget) {
        handleClose();
      }
    },
    [closeOnBackdropClick, isLoading, handleClose]
  );

  // Handle option selection
  const handleOptionSelect = useCallback(
    (value: string) => {
      if (isLoading) return;
      onSelect(value);
    },
    [isLoading, onSelect]
  );

  if (!isOpen && !isClosing) return null;

  // Determine header background color based on variant
  const getHeaderBackground = () => {
    if (headerBackground) return headerBackground;

    switch (variant) {
      case 'info':
        return '#4169E1'; // Toss Blue-ish
      case 'warning':
        return '#FF9500'; // Toss Orange
      case 'primary':
      default:
        return '#0064FF'; // Toss Blue
    }
  };

  // Get header icon
  const displayHeaderIcon =
    headerIcon !== undefined ? headerIcon : DefaultHeaderIcons[variant];

  return (
    <div
      className={`${styles.backdrop} ${isClosing ? styles.backdropClosing : ''}`}
      onClick={handleBackdropClick}
      style={{ zIndex }}
      role="presentation"
    >
      <div
        className={`${styles.modalContainer} ${isClosing ? styles.modalContainerClosing : ''} ${className}`}
        style={{ maxWidth: width, zIndex: zIndex + 1 }}
        role="dialog"
        aria-modal="true"
        aria-labelledby="select-modal-title"
      >
        {/* Loading Overlay */}
        {isLoading && (
          <div className={styles.loadingOverlay}>
            <LoadingAnimation size="medium" />
          </div>
        )}

        {/* Modal Header */}
        <div
          className={styles.modalHeader}
          style={{ background: getHeaderBackground() }}
        >
          {displayHeaderIcon && (
            <div className={styles.headerIcon}>{displayHeaderIcon}</div>
          )}
          <div className={styles.headerContent}>
            <h2 id="select-modal-title" className={styles.modalTitle}>
              {title}
            </h2>
          </div>
        </div>

        {/* Modal Body */}
        <div className={styles.modalBody}>
          {/* Message Section */}
          {message && (
            <div className={styles.messageSection}>
              <p className={styles.messageText}>{message}</p>
            </div>
          )}

          {/* Options List */}
          <div className={styles.optionsList} role="listbox">
            {options.map((option) => (
              <button
                key={option.value}
                type="button"
                className={`${styles.optionButton} ${selectedValue === option.value ? styles.optionButtonSelected : ''}`}
                onClick={() => handleOptionSelect(option.value)}
                disabled={option.disabled || isLoading}
                role="option"
                aria-selected={selectedValue === option.value}
              >
                {option.icon && (
                  <div className={styles.optionIcon}>{option.icon}</div>
                )}
                <div className={styles.optionContent}>
                  <p className={styles.optionLabel}>{option.label}</p>
                  {option.description && (
                    <p className={styles.optionDescription}>
                      {option.description}
                    </p>
                  )}
                </div>
                <div className={styles.optionArrow}>{ArrowIcon}</div>
              </button>
            ))}
          </div>
        </div>

        {/* Modal Footer */}
        <div className={styles.modalFooter}>
          <button
            className={styles.cancelButton}
            onClick={handleClose}
            disabled={isLoading}
            type="button"
          >
            {cancelText}
          </button>
        </div>
      </div>
    </div>
  );
};

export default SelectModal;
