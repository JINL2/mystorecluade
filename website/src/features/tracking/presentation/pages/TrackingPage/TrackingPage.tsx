/**
 * TrackingPage Component
 * Coming Soon placeholder page
 */

import React from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import styles from './TrackingPage.module.css';

export const TrackingPage: React.FC = () => {
  return (
    <>
      <Navbar activeItem="product" />
      <div className={styles.container}>
        <div className={styles.comingSoonWrapper}>
          <div className={styles.starIcon}>
            <svg width="120" height="120" viewBox="0 0 24 24" fill="currentColor">
              <path d="M12,17.27L18.18,21L16.54,13.97L22,9.24L14.81,8.62L12,2L9.19,8.62L2,9.24L7.45,13.97L5.82,21L12,17.27Z" />
            </svg>
          </div>
          <h1 className={styles.title}>Tracking Coming Soon</h1>
          <p className={styles.description}>
            The tracking feature is currently under development.
          </p>
        </div>
      </div>
    </>
  );
};
