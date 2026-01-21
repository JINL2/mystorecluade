/**
 * MembersTab Component
 * Shows list of session members
 */

import React from 'react';
import type { SessionHistoryMember } from '../../../../domain/entities';
import styles from '../SessionHistoryDetailPage.module.css';

interface MembersTabProps {
  members: SessionHistoryMember[];
}

// Format date for display (yyyy/MM/dd HH:mm)
const formatDateTime = (dateStr: string | null): string => {
  if (!dateStr) return '-';
  const parts = dateStr.split(' ');
  if (parts.length >= 2) {
    const datePart = parts[0].replace(/-/g, '/');
    const timePart = parts[1].substring(0, 5);
    return `${datePart} ${timePart}`;
  }
  return dateStr.replace(/-/g, '/');
};

// Get user display name from first and last name
const getUserDisplayName = (firstName: string, lastName: string): string => {
  return `${firstName} ${lastName}`.trim() || 'Unknown';
};

export const MembersTab: React.FC<MembersTabProps> = ({ members }) => {
  return (
    <div className={styles.membersSection}>
      <div className={styles.membersGrid}>
        {members && members.length > 0 ? (
          members.map((member) => (
            <div key={member.userId} className={styles.memberCard}>
              <div className={styles.memberAvatar}>
                {member.profileImage ? (
                  <img src={member.profileImage} alt="" />
                ) : (
                  member.firstName.charAt(0).toUpperCase()
                )}
              </div>
              <div className={styles.memberInfo}>
                <div className={styles.memberName}>
                  {getUserDisplayName(member.firstName, member.lastName)}
                </div>
                <div className={styles.memberStatus}>
                  {member.isActive ? 'Active' : 'Inactive'}
                </div>
              </div>
              <div className={styles.memberTimestamps}>
                <div className={styles.timestamp}>
                  <span className={styles.timestampLabel}>Joined:</span>
                  <span>{formatDateTime(member.joinedAt)}</span>
                </div>
              </div>
            </div>
          ))
        ) : (
          <div className={styles.emptyMembers}>
            <p>No member data available</p>
          </div>
        )}
      </div>
    </div>
  );
};

export default MembersTab;
