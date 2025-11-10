/**
 * TossButton Component
 * Modern React implementation of Toss Design System button
 */

import React, { useState, useRef, MouseEvent as ReactMouseEvent } from 'react';
import { TossButtonProps } from './TossButton.types';
import styles from './TossButton.module.css';

export const TossButton: React.FC<TossButtonProps> = ({
  label,
  variant = 'primary',
  size = 'md',
  onClick,
  disabled = false,
  fullWidth = false,
  loading = false,
  icon,
  iconPosition = 'left',
  children,
  type = 'button',
  className = '',
  customStyles,
  ...rest
}) => {
  const [ripples, setRipples] = useState<Array<{ x: number; y: number; id: number }>>([]);
  const buttonRef = useRef<HTMLButtonElement>(null);
  const rippleIdRef = useRef(0);

  const handleClick = (event: ReactMouseEvent<HTMLButtonElement>) => {
    if (disabled || loading) return;

    // Create ripple effect
    if (buttonRef.current) {
      const rect = buttonRef.current.getBoundingClientRect();
      const x = event.clientX - rect.left;
      const y = event.clientY - rect.top;
      const id = rippleIdRef.current++;

      setRipples((prev) => [...prev, { x, y, id }]);

      // Remove ripple after animation
      setTimeout(() => {
        setRipples((prev) => prev.filter((ripple) => ripple.id !== id));
      }, 600);
    }

    // Call onClick handler
    if (onClick) {
      onClick(event);
    }
  };

  const buttonClasses = [
    styles.tossButton,
    styles[`variant-${variant}`],
    styles[`size-${size}`],
    fullWidth && styles.fullWidth,
    disabled && styles.disabled,
    loading && styles.loading,
    className,
  ]
    .filter(Boolean)
    .join(' ');

  const content = children || label;
  const showIcon = icon && !loading;

  // Build custom inline styles from customStyles prop
  const inlineStyles: React.CSSProperties = {
    ...(customStyles?.backgroundColor && { backgroundColor: customStyles.backgroundColor }),
    ...(customStyles?.color && { color: customStyles.color }),
    ...(customStyles?.borderColor && { borderColor: customStyles.borderColor }),
    ...(customStyles?.borderWidth && { borderWidth: customStyles.borderWidth }),
    ...(customStyles?.borderRadius && { borderRadius: customStyles.borderRadius }),
    ...(customStyles?.width && { width: customStyles.width }),
    ...(customStyles?.height && { height: customStyles.height }),
    ...(customStyles?.padding && { padding: customStyles.padding }),
    ...(customStyles?.fontSize && { fontSize: customStyles.fontSize }),
    ...(customStyles?.fontWeight && { fontWeight: customStyles.fontWeight }),
  };

  return (
    <button
      ref={buttonRef}
      type={type}
      className={buttonClasses}
      style={inlineStyles}
      onClick={handleClick}
      disabled={disabled || loading}
      {...rest}
    >
      {/* Ripple container */}
      <span className={styles.rippleContainer}>
        {ripples.map((ripple) => (
          <span
            key={ripple.id}
            className={styles.ripple}
            style={{
              left: ripple.x,
              top: ripple.y,
            }}
          />
        ))}
      </span>

      {/* Button content */}
      <span className={styles.content}>
        {loading && (
          <span className={styles.spinner}>
            <svg className={styles.spinnerSvg} viewBox="0 0 24 24">
              <circle
                className={styles.spinnerCircle}
                cx="12"
                cy="12"
                r="10"
                fill="none"
                strokeWidth="3"
              />
            </svg>
          </span>
        )}

        {showIcon && iconPosition === 'left' && (
          <span className={styles.iconLeft}>{icon}</span>
        )}

        {content && <span className={styles.label}>{content}</span>}

        {showIcon && iconPosition === 'right' && (
          <span className={styles.iconRight}>{icon}</span>
        )}
      </span>
    </button>
  );
};

export default TossButton;
