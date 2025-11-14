/**
 * LoadingAnimation Component
 * Shared loading spinner for consistent loading states across the app
 */

import React from 'react';
import styles from './LoadingAnimation.module.css';
import type { LoadingAnimationProps } from './LoadingAnimation.types';

export const LoadingAnimation: React.FC<LoadingAnimationProps> = ({
  size = 'medium',
  className = '',
  fullscreen = false,
}) => {
  const spinnerClasses = `${styles.spinner} ${styles[size]} ${className}`;

  if (fullscreen) {
    return (
      <div className={styles.container}>
        <div className={spinnerClasses}></div>
      </div>
    );
  }

  return <div className={spinnerClasses}></div>;
};

export default LoadingAnimation;
