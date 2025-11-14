/**
 * MarketingPlanPage Component
 * Marketing campaign planning page (Coming Soon)
 */

import React from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import styles from './MarketingPlanPage.module.css';

export const MarketingPlanPage: React.FC = () => {
  return (
    <>
      <Navbar activeItem="marketing" />
      <div className={styles.container}>
      <div className={styles.header}>
        <h1 className={styles.title}>Marketing Plan</h1>
        <p className={styles.subtitle}>Plan and track marketing campaigns</p>
      </div>

      <div className={styles.comingSoonCard}>
        <div className={styles.comingSoon}>
          <div className={styles.icon}>
            <svg width="64" height="64" viewBox="0 0 24 24" fill="currentColor">
              <path d="M12,2L13.09,8.26L22,9L15.5,15.14L16.91,22L12,18.5L7.09,22L8.5,15.14L2,9L10.91,8.26L12,2Z" />
            </svg>
          </div>
          <h2 className={styles.comingSoonTitle}>Marketing Plan Coming Soon</h2>
          <p className={styles.comingSoonText}>
            The marketing plan feature is currently under development.
          </p>
          <div className={styles.features}>
            <h3>Planned Features:</h3>
            <ul>
              <li>📊 Campaign planning and tracking</li>
              <li>📈 Marketing analytics and insights</li>
              <li>🎯 Target audience management</li>
              <li>💰 Budget allocation and ROI tracking</li>
              <li>📅 Campaign calendar and scheduling</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    </>
  );
};
