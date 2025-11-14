/**
 * EmployeeCard Component
 * Displays employee information in a card format matching backup design
 */

import React from 'react';
import type { EmployeeCardProps } from './EmployeeCard.types';
import styles from './EmployeeCard.module.css';

export const EmployeeCard: React.FC<EmployeeCardProps> = ({
  userId,
  fullName,
  roleName,
  storeName,
  formattedSalary,
  salaryTypeLabel,
  initials,
  isActive,
  onEdit,
  onDelete,
}) => {
  return (
    <div className={styles.card}>
      {/* Header: Avatar + Info + Actions */}
      <div className={styles.header}>
        {/* Avatar */}
        <div className={styles.avatarContainer}>
          <div className={styles.avatar}>{initials}</div>
        </div>

        {/* Body with Info */}
        <div className={styles.body}>
          <div className={styles.info}>
            <h3 className={styles.name}>{fullName}</h3>
            <p className={styles.role}>{roleName}</p>
            <p className={styles.store}>
              <svg width="14" height="14" viewBox="0 0 14 14" fill="currentColor" style={{ opacity: 0.6 }}>
                <circle cx="7" cy="7" r="7" />
              </svg>
              {storeName}
            </p>
            {/* Active Status Badge - INSIDE info */}
            {isActive && (
              <div className={styles.statusBadge}>
                <span className={styles.statusDot}></span>
                Active
              </div>
            )}
          </div>
        </div>

        {/* Action Buttons - INSIDE header */}
        <div className={styles.actions}>
          {onEdit && (
            <button
              className={styles.actionButton}
              onClick={() => onEdit(userId)}
              title="Edit employee"
              aria-label="Edit employee"
            >
              <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
                <path d="M11.013 1.427a1.75 1.75 0 0 1 2.474 0l1.086 1.086a1.75 1.75 0 0 1 0 2.474l-8.61 8.61c-.21.21-.47.364-.756.445l-3.251.93a.75.75 0 0 1-.927-.928l.929-3.25a1.75 1.75 0 0 1 .445-.758l8.61-8.61Zm.176 4.823L9.75 4.81l-6.286 6.287a.253.253 0 0 0-.064.108l-.558 1.953 1.953-.558a.253.253 0 0 0 .108-.064Z" />
              </svg>
            </button>
          )}
          {onDelete && (
            <button
              className={styles.actionButton}
              onClick={() => onDelete(userId)}
              title="Delete employee"
              aria-label="Delete employee"
            >
              <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
                <path d="M11 1.75V3h2.25a.75.75 0 0 1 0 1.5H2.75a.75.75 0 0 1 0-1.5H5V1.75C5 .784 5.784 0 6.75 0h2.5C10.216 0 11 .784 11 1.75ZM4.496 6.675l.66 6.6a.25.25 0 0 0 .249.225h5.19a.25.25 0 0 0 .249-.225l.66-6.6a.75.75 0 0 1 1.492.149l-.66 6.6A1.748 1.748 0 0 1 10.595 15h-5.19a1.75 1.75 0 0 1-1.741-1.575l-.66-6.6a.75.75 0 1 1 1.492-.15ZM6.5 1.75V3h3V1.75a.25.25 0 0 0-.25-.25h-2.5a.25.25 0 0 0-.25.25Z" />
              </svg>
            </button>
          )}
        </div>
      </div>

      {/* Details: Salary Section - NO actions */}
      <div className={styles.details}>
        <div className={styles.salaryContainer}>
          <div className={styles.salaryLabel}>Salary</div>
          <div className={styles.salaryAmount}>{formattedSalary}</div>
          <div className={styles.salaryType}>{salaryTypeLabel}</div>
        </div>
      </div>
    </div>
  );
};

export default EmployeeCard;
