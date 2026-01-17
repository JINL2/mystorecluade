/**
 * CountingSessionHeader Component
 * Header and session banner for counting session page
 */

import React from 'react';
import type { CountingSessionInfo } from '../../../hooks/useCountingSessionDetail';
import styles from '../CountingSessionPage.module.css';

interface StatusInfo {
  text: string;
  className: string;
}

interface CountingSessionHeaderProps {
  sessionInfo: CountingSessionInfo | null;
  statusInfo: StatusInfo;
  onBack: () => void;
}

// Format date for display (yyyy/MM/dd)
const formatDateDisplay = (dateStr: string): string => {
  if (!dateStr) return '-';
  const date = new Date(dateStr);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}/${month}/${day}`;
};

export const CountingSessionHeader: React.FC<CountingSessionHeaderProps> = ({
  sessionInfo,
  statusInfo,
  onBack,
}) => {
  return (
    <>
      {/* Header */}
      <div className={styles.header}>
        <div className={styles.headerLeft}>
          <button className={styles.backButton} onClick={onBack}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M19 12H5M12 19l-7-7 7-7" />
            </svg>
            Back
          </button>
          <div className={styles.titleSection}>
            <h1 className={styles.title}>
              {sessionInfo?.sessionName || 'Counting Session'}
            </h1>
            <div className={styles.sessionBadge}>
              <span className={`${styles.badgeStatus} ${styles[statusInfo.className]}`}>
                {statusInfo.text}
              </span>
              {sessionInfo?.storeName && (
                <span className={styles.storeName}>{sessionInfo.storeName}</span>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* Session Info Banner */}
      {sessionInfo && (
        <div className={styles.sessionBanner}>
          <div className={styles.sessionBannerContent}>
            <div className={styles.sessionBannerLeft}>
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2" />
                <rect x="9" y="3" width="6" height="4" rx="1" />
                <path d="M9 12h6" />
                <path d="M9 16h6" />
              </svg>
              <div className={styles.sessionBannerInfo}>
                <span className={styles.sessionBannerLabel}>Counting Session</span>
                <span className={styles.sessionBannerName}>{sessionInfo.sessionName}</span>
              </div>
            </div>
            <div className={styles.sessionBannerDetails}>
              <div className={styles.sessionBannerItem}>
                <span className={styles.bannerItemLabel}>Created By</span>
                <span className={styles.bannerItemValue}>{sessionInfo.createdByName}</span>
              </div>
              <div className={styles.sessionBannerItem}>
                <span className={styles.bannerItemLabel}>Created At</span>
                <span className={styles.bannerItemValue}>
                  {formatDateDisplay(sessionInfo.createdAt?.split(' ')[0] || '')}
                </span>
              </div>
              <div className={styles.sessionBannerItem}>
                <span className={styles.bannerItemLabel}>Status</span>
                <span className={`${styles.bannerItemStatus} ${styles[statusInfo.className]}`}>
                  {statusInfo.text}
                </span>
              </div>
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default CountingSessionHeader;
