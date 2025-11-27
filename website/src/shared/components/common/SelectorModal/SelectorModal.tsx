/**
 * SelectorModal Component
 * Toss-style clean selection modal - center-aligned, minimal design
 * Based on ErrorMessage component design pattern
 */

import React, { useEffect, useCallback, useState } from 'react';
import styles from './SelectorModal.module.css';
import type { SelectorModalProps, SelectorOption } from './SelectorModal.types';
import { LoadingAnimation } from '../LoadingAnimation';

// Default icons for each variant - Toss style (simple, clean)
const DefaultIcons = {
  info: (
    <svg width="48" height="48" viewBox="0 0 24 24" fill="#0064FF">
      <path d="M12,2A10,10 0 0,0 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2M13,17H11V11H13V17M13,9H11V7H13V9Z" />
    </svg>
  ),
  warning: (
    <svg width="48" height="48" viewBox="0 0 24 24" fill="#FF9500">
      <path d="M12,2L1,21H23M12,6L19.53,19H4.47M11,10V14H13V10M11,16V18H13V16" />
    </svg>
  ),
  error: (
    <svg width="48" height="48" viewBox="0 0 24 24" fill="#FF5847">
      <path d="M12,2C17.53,2 22,6.47 22,12C22,17.53 17.53,22 12,22C6.47,22 2,17.53 2,12C2,6.47 6.47,2 12,2M15.59,7L12,10.59L8.41,7L7,8.41L10.59,12L7,15.59L8.41,17L12,13.41L15.59,17L17,15.59L13.41,12L17,8.41L15.59,7Z" />
    </svg>
  ),
  success: (
    <svg width="48" height="48" viewBox="0 0 24 24" fill="#00C896">
      <path d="M12,2A10,10 0 0,1 22,12A10,10 0 0,1 12,22A10,10 0 0,1 2,12A10,10 0 0,1 12,2M11,16.5L6.5,12L7.91,10.59L11,13.67L16.59,8.09L18,9.5L11,16.5Z" />
    </svg>
  ),
};

export const SelectorModal: React.FC<SelectorModalProps> = ({
  isOpen,
  onClose,
  onSelect,
  variant = 'info',
  title,
  headerIcon,
  message,
  options,
  cancelText = 'Cancel',
  showCancelButton = true,
  closeOnBackdropClick = true,
  closeOnEscape = true,
  isLoading = false,
  zIndex = 1000,
  className = '',
  children,
}) => {
  const [isClosing, setIsClosing] = useState(false);

  // Close with animation
  const handleClose = useCallback(() => {
    if (isLoading) return;
    setIsClosing(true);
    setTimeout(() => {
      setIsClosing(false);
      onClose();
    }, 200);
  }, [isLoading, onClose]);

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
  }, [isOpen, closeOnEscape, isLoading, handleClose]);

  // Handle backdrop click
  const handleBackdropClick = useCallback(
    (e: React.MouseEvent<HTMLDivElement>) => {
      if (closeOnBackdropClick && !isLoading && e.target === e.currentTarget) {
        handleClose();
      }
    },
    [closeOnBackdropClick, isLoading, handleClose]
  );

  // Handle option click
  const handleOptionClick = useCallback(
    (option: SelectorOption) => {
      if (isLoading || option.disabled) return;
      onSelect(option.id);
    },
    [isLoading, onSelect]
  );

  if (!isOpen) return null;

  // Get icon - use custom or default based on variant
  const displayIcon = headerIcon !== undefined ? headerIcon : DefaultIcons[variant];

  // Get option button class
  const getOptionClass = (optionVariant: SelectorOption['variant'] = 'secondary') => {
    switch (optionVariant) {
      case 'primary':
        return styles.optionPrimary;
      case 'outline':
        return styles.optionOutline;
      case 'secondary':
      default:
        return styles.optionSecondary;
    }
  };

  return (
    <div
      className={`${styles.backdrop} ${isClosing ? styles.backdropClosing : ''}`}
      onClick={handleBackdropClick}
      style={{ zIndex }}
    >
      <div className={`${styles.dialog} ${isClosing ? styles.dialogClosing : ''} ${className}`}>
        {/* Loading Overlay */}
        {isLoading && (
          <div className={styles.loadingOverlay}>
            <LoadingAnimation size="medium" />
          </div>
        )}

        {/* Icon */}
        {displayIcon && (
          <div className={styles.iconContainer}>
            {displayIcon}
          </div>
        )}

        {/* Title */}
        <h2 className={styles.title}>{title}</h2>

        {/* Message */}
        {message && (
          <p className={styles.message}>{message}</p>
        )}

        {/* Options */}
        <div className={styles.optionsSection}>
          {options.map((option) => (
            <button
              key={option.id}
              className={`${styles.optionButton} ${getOptionClass(option.variant)}`}
              onClick={() => handleOptionClick(option)}
              disabled={isLoading || option.disabled}
              type="button"
            >
              {option.icon && <span className={styles.optionIcon}>{option.icon}</span>}
              <span className={styles.optionLabel}>{option.label}</span>
            </button>
          ))}
        </div>

        {/* Custom Content */}
        {children && <div className={styles.customContent}>{children}</div>}

        {/* Cancel Button */}
        {showCancelButton && (
          <button
            className={styles.cancelButton}
            onClick={handleClose}
            disabled={isLoading}
            type="button"
          >
            {cancelText}
          </button>
        )}
      </div>
    </div>
  );
};

export default SelectorModal;
