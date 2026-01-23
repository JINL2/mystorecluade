/**
 * ScheduleEmptyState Component
 * Empty state display for schedule page
 */

import React from 'react';
import { TossButton } from '@/shared/components/toss/TossButton';
import type { ScheduleEmptyStateProps } from './ScheduleEmptyState.types';
import styles from './ScheduleEmptyState.module.css';

export const ScheduleEmptyState: React.FC<ScheduleEmptyStateProps> = ({
  variant,
  title,
  message,
  error,
  onAction,
  actionText,
}) => {
  const getDefaultContent = () => {
    switch (variant) {
      case 'no-store':
        return {
          title: 'Select a Store',
          message: 'Choose a store from the sidebar to view its schedule',
        };
      case 'no-schedule':
        return {
          title: 'No Schedule Available',
          message: 'No shifts configured for this store',
        };
      case 'error':
        return {
          title: 'Failed to Load Schedule',
          message: error || 'An error occurred while loading the schedule',
        };
      default:
        return { title: '', message: '' };
    }
  };

  const defaultContent = getDefaultContent();
  const displayTitle = title || defaultContent.title;
  const displayMessage = message || defaultContent.message;

  // Calendar Icon SVG
  const CalendarIcon = () => (
    <svg
      className={styles.emptyIcon}
      width="120"
      height="120"
      viewBox="0 0 120 120"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
    >
      {/* Background Circle */}
      <circle cx="60" cy="60" r="50" fill="#F0F6FF" />

      {/* Calendar Base */}
      <rect
        x="30"
        y="35"
        width="60"
        height="55"
        rx="6"
        fill="white"
        stroke="#0064FF"
        strokeWidth="2"
      />

      {/* Calendar Header */}
      <rect x="30" y="35" width="60" height="15" rx="6" fill="#0064FF" />
      <rect x="30" y="43" width="60" height="7" fill="#0064FF" />

      {/* Calendar Rings */}
      <circle cx="42" cy="35" r="3" fill="white" />
      <circle cx="60" cy="35" r="3" fill="white" />
      <circle cx="78" cy="35" r="3" fill="white" />

      {/* Calendar Grid - Week Days */}
      <line
        x1="37"
        y1="58"
        x2="47"
        y2="58"
        stroke="#E9ECEF"
        strokeWidth="2"
        strokeLinecap="round"
      />
      <line
        x1="52"
        y1="58"
        x2="62"
        y2="58"
        stroke="#E9ECEF"
        strokeWidth="2"
        strokeLinecap="round"
      />
      <line
        x1="67"
        y1="58"
        x2="77"
        y2="58"
        stroke="#E9ECEF"
        strokeWidth="2"
        strokeLinecap="round"
      />

      <line
        x1="37"
        y1="68"
        x2="47"
        y2="68"
        stroke="#E9ECEF"
        strokeWidth="2"
        strokeLinecap="round"
      />
      <line
        x1="52"
        y1="68"
        x2="62"
        y2="68"
        stroke="#E9ECEF"
        strokeWidth="2"
        strokeLinecap="round"
      />
      <line
        x1="67"
        y1="68"
        x2="77"
        y2="68"
        stroke="#E9ECEF"
        strokeWidth="2"
        strokeLinecap="round"
      />

      <line
        x1="37"
        y1="78"
        x2="47"
        y2="78"
        stroke="#E9ECEF"
        strokeWidth="2"
        strokeLinecap="round"
      />
      <line
        x1="52"
        y1="78"
        x2="62"
        y2="78"
        stroke="#0064FF"
        strokeWidth="3"
        strokeLinecap="round"
      />
      <line
        x1="67"
        y1="78"
        x2="77"
        y2="78"
        stroke="#E9ECEF"
        strokeWidth="2"
        strokeLinecap="round"
      />

      {variant === 'no-store' && (
        /* Arrow pointing left */
        <path d="M20 60 L30 55 L30 65 Z" fill="#0064FF" />
      )}

      {variant === 'no-schedule' && (
        /* Question Mark Circle */
        <>
          <circle cx="60" cy="95" r="14" fill="#0064FF" />
          <path
            d="M60 88 Q60 85 63 85 Q66 85 66 88 Q66 91 63 93 L60 95"
            stroke="white"
            strokeWidth="2.5"
            fill="none"
            strokeLinecap="round"
          />
          <circle cx="60" cy="99" r="1.5" fill="white" />
        </>
      )}
    </svg>
  );

  // Error Icon SVG
  const ErrorIcon = () => (
    <svg
      className={styles.errorIcon}
      width="120"
      height="120"
      viewBox="0 0 120 120"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
    >
      {/* Background Circle */}
      <circle cx="60" cy="60" r="50" fill="#FFEFED" />

      {/* Error Triangle */}
      <path d="M60 30 L90 80 L30 80 Z" fill="white" stroke="#FF5847" strokeWidth="2" />

      {/* Exclamation Mark */}
      <line x1="60" y1="50" x2="60" y2="65" stroke="#FF5847" strokeWidth="3" strokeLinecap="round" />
      <circle cx="60" cy="72" r="2" fill="#FF5847" />
    </svg>
  );

  return (
    <div className={`${styles.emptyState} ${variant === 'error' ? styles.errorState : ''}`}>
      {variant === 'error' ? <ErrorIcon /> : <CalendarIcon />}
      <h3 className={styles.emptyTitle}>{displayTitle}</h3>
      <p className={styles.emptyText}>{displayMessage}</p>
      {onAction && actionText && (
        <TossButton onClick={onAction} variant="primary">
          {actionText}
        </TossButton>
      )}
    </div>
  );
};

export default ScheduleEmptyState;
