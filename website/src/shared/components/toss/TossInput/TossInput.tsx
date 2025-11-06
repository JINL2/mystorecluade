/**
 * TossInput Component
 * Modern React implementation of Toss Design System input
 */

import React, { useState, useId, forwardRef } from 'react';
import { TossInputProps } from './TossInput.types';
import styles from './TossInput.module.css';

export const TossInput = forwardRef<HTMLInputElement, TossInputProps>(
  (
    {
      label,
      variant = 'default',
      size = 'md',
      error,
      success,
      helperText,
      iconLeft,
      iconRight,
      showPasswordToggle,
      showCharCount = false,
      required = false,
      fullWidth = false,
      type = 'text',
      className = '',
      maxLength,
      value,
      onChange,
      onFocus,
      onBlur,
      ...rest
    },
    ref
  ) => {
    const [focused, setFocused] = useState(false);
    const [showPassword, setShowPassword] = useState(false);
    const inputId = useId();

    // Determine actual variant based on error/success
    const actualVariant = error ? 'error' : success ? 'success' : variant;

    // Determine if password toggle should be shown
    const shouldShowPasswordToggle =
      type === 'password' && (showPasswordToggle === undefined || showPasswordToggle);

    // Determine input type (password toggle)
    const inputType = type === 'password' && showPassword ? 'text' : type;

    // Character count
    const currentLength = typeof value === 'string' ? value.length : 0;

    const inputClasses = [
      styles.input,
      styles[`size-${size}`],
      styles[`variant-${actualVariant}`],
      iconLeft && styles.withIconLeft,
      (iconRight || shouldShowPasswordToggle) && styles.withIconRight,
      fullWidth && styles.fullWidth,
      focused && styles.focused,
      className,
    ]
      .filter(Boolean)
      .join(' ');

    const handleFocus = (e: React.FocusEvent<HTMLInputElement>) => {
      setFocused(true);
      onFocus?.(e);
    };

    const handleBlur = (e: React.FocusEvent<HTMLInputElement>) => {
      setFocused(false);
      onBlur?.(e);
    };

    const togglePasswordVisibility = () => {
      setShowPassword((prev) => !prev);
    };

    return (
      <div className={`${styles.inputGroup} ${fullWidth ? styles.fullWidth : ''}`}>
        {/* Label */}
        {label && (
          <label htmlFor={inputId} className={styles.label}>
            {label}
            {required && <span className={styles.required}>*</span>}
          </label>
        )}

        {/* Input wrapper */}
        <div className={styles.inputWrapper}>
          {/* Left icon */}
          {iconLeft && <span className={styles.iconLeft}>{iconLeft}</span>}

          {/* Input field */}
          <input
            ref={ref}
            id={inputId}
            type={inputType}
            className={inputClasses}
            value={value}
            onChange={onChange}
            onFocus={handleFocus}
            onBlur={handleBlur}
            maxLength={maxLength}
            required={required}
            {...rest}
          />

          {/* Right icon or password toggle */}
          {shouldShowPasswordToggle ? (
            <button
              type="button"
              className={styles.iconRight}
              onClick={togglePasswordVisibility}
              tabIndex={-1}
            >
              {showPassword ? (
                <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
                  <path d="M2 2l16 16M6.71 6.71A9.78 9.78 0 0010 6c5 0 8.27 4.11 9 7a13.16 13.16 0 01-1.67 2.68" />
                  <path d="M12 12a3 3 0 11-4.24-4.24" />
                  <path d="M6.61 6.61A13.526 13.526 0 001 10s3.27 7 9 7a9.74 9.74 0 005.39-1.61" />
                </svg>
              ) : (
                <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
                  <path d="M10 3C5 3 1.73 7.11 1 10c.73 2.89 4 7 9 7s8.27-4.11 9-7c-.73-2.89-4-7-9-7z" />
                  <circle cx="10" cy="10" r="3" />
                </svg>
              )}
            </button>
          ) : (
            iconRight && <span className={styles.iconRight}>{iconRight}</span>
          )}
        </div>

        {/* Messages and character count */}
        <div className={styles.footer}>
          {/* Error/Success/Helper message */}
          {error && <span className={styles.errorMessage}>{error}</span>}
          {!error && success && <span className={styles.successMessage}>{success}</span>}
          {!error && !success && helperText && (
            <span className={styles.helperText}>{helperText}</span>
          )}

          {/* Character count */}
          {showCharCount && maxLength && (
            <span className={styles.charCount}>
              {currentLength}/{maxLength}
            </span>
          )}
        </div>
      </div>
    );
  }
);

TossInput.displayName = 'TossInput';

export default TossInput;
