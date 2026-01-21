/**
 * SessionHistoryDetailPage Component
 * Displays detailed information about a closed/completed session
 * Read-only view of session data including items, members, and metadata
 * - Receiving sessions: Shows new products and restocked products separately
 * - Merged sessions: Shows detailed breakdown of each merged session with items and scanners
 */

import React, { useState, useMemo } from 'react';
import { useLocation, useNavigate, useParams } from 'react-router-dom';
import { Navbar } from '@/shared/components/common/Navbar';
import type { SessionHistoryEntry } from '../../../domain/entities';
import {
  ItemsTab,
  MembersTab,
  NewProductsTab,
  RestockedTab,
  MergeDetailsTab,
} from './components';
import styles from './SessionHistoryDetailPage.module.css';

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

type DetailTab = 'items' | 'members' | 'newProducts' | 'restocked' | 'mergeDetails';

export const SessionHistoryDetailPage: React.FC = () => {
  const navigate = useNavigate();
  const location = useLocation();
  const { sessionId } = useParams<{ sessionId: string }>();

  // Get session data from navigation state
  const session = location.state?.session as SessionHistoryEntry | undefined;

  const [activeTab, setActiveTab] = useState<DetailTab>('items');
  const [searchQuery, setSearchQuery] = useState('');
  const [expandedMergedSession, setExpandedMergedSession] = useState<string | null>(null);

  // Separate new products and restocked products for receiving sessions
  const { newProducts, restockedProducts } = useMemo(() => {
    if (!session?.receivingInfo?.stockSnapshot) {
      return { newProducts: [], restockedProducts: [] };
    }

    const newProds = session.receivingInfo.stockSnapshot.filter(s => s.quantityBefore === 0);
    const restocked = session.receivingInfo.stockSnapshot.filter(s => s.quantityBefore > 0);

    return { newProducts: newProds, restockedProducts: restocked };
  }, [session?.receivingInfo?.stockSnapshot]);

  const handleBack = () => {
    navigate('/product/session');
  };

  const toggleMergedSession = (sessionId: string) => {
    setExpandedMergedSession(prev => prev === sessionId ? null : sessionId);
  };

  if (!session) {
    return (
      <>
        <Navbar activeItem="product" />
        <div className={styles.container}>
          <div className={styles.errorState}>
            <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF" strokeWidth="1.5">
              <circle cx="12" cy="12" r="10" />
              <path d="M12 8v4m0 4h.01" />
            </svg>
            <h2>Session Not Found</h2>
            <p>The session data could not be loaded.</p>
            <button className={styles.backButton} onClick={handleBack}>
              Back to Sessions
            </button>
          </div>
        </div>
      </>
    );
  }

  const isReceivingSession = session.sessionType === 'receiving';
  const isMergedSession = session.isMergedSession && session.mergeInfo;
  const totalItems = session.items?.length || 0;
  const totalQuantity = session.totalConfirmedQuantity ?? session.totalScannedQuantity ?? 0;

  // Determine status text and class
  const getStatusInfo = () => {
    if (session.isFinal) {
      return { text: 'Final', className: styles.completed };
    }
    if (session.isActive) {
      return { text: 'Active', className: styles.active };
    }
    if (session.completedAt) {
      return { text: 'Completed', className: styles.completed };
    }
    return { text: 'Closed', className: styles.closed };
  };
  const statusInfo = getStatusInfo();

  return (
    <>
      <Navbar activeItem="product" />
      <div className={styles.container}>
        {/* Header */}
        <div className={styles.header}>
          <button className={styles.backButton} onClick={handleBack}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M19 12H5M12 19l-7-7 7-7" />
            </svg>
            Back
          </button>
          <div className={styles.headerInfo}>
            <h1 className={styles.title}>{session.sessionName}</h1>
            <div className={styles.badges}>
              <span className={`${styles.typeBadge} ${styles[session.sessionType]}`}>
                {session.sessionType === 'counting' ? 'Counting' : 'Receiving'}
              </span>
              <span className={`${styles.statusBadge} ${statusInfo.className}`}>
                {statusInfo.text}
              </span>
              {session.isMergedSession && (
                <span className={styles.mergedBadge}>
                  <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <path d="M8 6v12M12 6v12M16 6v12" />
                  </svg>
                  Merged
                </span>
              )}
            </div>
          </div>
        </div>

        {/* Session Info Cards */}
        <div className={styles.infoGrid}>
          <div className={styles.infoCard}>
            <div className={styles.infoLabel}>Store</div>
            <div className={styles.infoValue}>{session.storeName}</div>
          </div>
          <div className={styles.infoCard}>
            <div className={styles.infoLabel}>Total Items</div>
            <div className={styles.infoValue}>{totalItems}</div>
          </div>
          <div className={styles.infoCard}>
            <div className={styles.infoLabel}>Total Quantity</div>
            <div className={styles.infoValue}>{totalQuantity.toLocaleString()}</div>
          </div>
          <div className={styles.infoCard}>
            <div className={styles.infoLabel}>Members</div>
            <div className={styles.infoValue}>{session.memberCount}</div>
          </div>
          <div className={styles.infoCard}>
            <div className={styles.infoLabel}>Created</div>
            <div className={styles.infoValue}>{formatDateTime(session.createdAt)}</div>
          </div>
          <div className={styles.infoCard}>
            <div className={styles.infoLabel}>Closed</div>
            <div className={styles.infoValue}>{formatDateTime(session.completedAt)}</div>
          </div>
          {session.durationMinutes != null && (
            <div className={styles.infoCard}>
              <div className={styles.infoLabel}>Duration</div>
              <div className={styles.infoValue}>
                {session.durationMinutes >= 60
                  ? `${Math.floor(session.durationMinutes / 60)}h ${Math.round(session.durationMinutes % 60)}m`
                  : `${Math.round(session.durationMinutes)}m`}
              </div>
            </div>
          )}
          <div className={styles.infoCard}>
            <div className={styles.infoLabel}>Created By</div>
            <div className={styles.infoValue}>
              {getUserDisplayName(session.createdBy.firstName, session.createdBy.lastName)}
            </div>
          </div>
        </div>

        {/* Shipment Info (for receiving sessions) */}
        {isReceivingSession && session.shipmentNumber && (
          <div className={styles.receivingInfoCard}>
            <div className={styles.receivingHeader}>
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
                <line x1="12" y1="22.08" x2="12" y2="12" />
              </svg>
              <span>Shipment Information</span>
            </div>
            <div className={styles.receivingDetails}>
              <div className={styles.receivingInfo}>
                <span className={styles.receivingLabel}>Shipment #:</span>
                <span className={styles.receivingValue}>{session.shipmentNumber}</span>
              </div>
              {session.receivingInfo && (
                <>
                  <div className={styles.receivingInfo}>
                    <span className={styles.receivingLabel}>Receiving #:</span>
                    <span className={styles.receivingValue}>{session.receivingInfo.receivingNumber}</span>
                  </div>
                  <div className={styles.receivingInfo}>
                    <span className={styles.receivingLabel}>Received at:</span>
                    <span className={styles.receivingValue}>{formatDateTime(session.receivingInfo.receivedAt)}</span>
                  </div>
                  <div className={styles.receivingInfo}>
                    <span className={styles.receivingLabel}>New Products:</span>
                    <span className={`${styles.receivingValue} ${styles.newProductCount}`}>
                      {session.receivingInfo.newProductsCount}
                    </span>
                  </div>
                  <div className={styles.receivingInfo}>
                    <span className={styles.receivingLabel}>Restocked:</span>
                    <span className={styles.receivingValue}>{session.receivingInfo.restockProductsCount}</span>
                  </div>
                </>
              )}
            </div>
          </div>
        )}

        {/* Merge Summary Info (if applicable) */}
        {isMergedSession && (
          <div className={styles.mergeInfoCard}>
            <div className={styles.mergeHeader}>
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <path d="M8 6v12M12 6v12M16 6v12" />
              </svg>
              <span>Merged Session Summary</span>
            </div>
            <div className={styles.mergeSummary}>
              <div className={styles.mergeSummaryItem}>
                <span className={styles.mergeSummaryLabel}>Sessions Merged</span>
                <span className={styles.mergeSummaryValue}>{session.mergeInfo!.totalMergedSessionsCount + 1}</span>
              </div>
              <div className={styles.mergeSummaryItem}>
                <span className={styles.mergeSummaryLabel}>Original Items</span>
                <span className={styles.mergeSummaryValue}>{session.mergeInfo!.originalSession.itemsCount}</span>
              </div>
              <div className={styles.mergeSummaryItem}>
                <span className={styles.mergeSummaryLabel}>Original Quantity</span>
                <span className={styles.mergeSummaryValue}>{session.mergeInfo!.originalSession.totalQuantity.toLocaleString()}</span>
              </div>
            </div>
          </div>
        )}

        {/* Tab Navigation */}
        <div className={styles.tabContainer}>
          <button
            className={`${styles.tab} ${activeTab === 'items' ? styles.active : ''}`}
            onClick={() => setActiveTab('items')}
          >
            Items ({totalItems})
          </button>
          <button
            className={`${styles.tab} ${activeTab === 'members' ? styles.active : ''}`}
            onClick={() => setActiveTab('members')}
          >
            Members ({session.memberCount})
          </button>

          {/* Receiving session specific tabs */}
          {isReceivingSession && newProducts.length > 0 && (
            <button
              className={`${styles.tab} ${styles.newProductTab} ${activeTab === 'newProducts' ? styles.active : ''}`}
              onClick={() => setActiveTab('newProducts')}
            >
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <path d="M12 5v14M5 12h14" />
              </svg>
              New Products ({newProducts.length})
            </button>
          )}
          {isReceivingSession && restockedProducts.length > 0 && (
            <button
              className={`${styles.tab} ${activeTab === 'restocked' ? styles.active : ''}`}
              onClick={() => setActiveTab('restocked')}
            >
              Restocked ({restockedProducts.length})
            </button>
          )}

          {/* Merge session specific tab */}
          {isMergedSession && (
            <button
              className={`${styles.tab} ${styles.mergeTab} ${activeTab === 'mergeDetails' ? styles.active : ''}`}
              onClick={() => setActiveTab('mergeDetails')}
            >
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <path d="M8 6v12M12 6v12M16 6v12" />
              </svg>
              Merge Details
            </button>
          )}
        </div>

        {/* Tab Content */}
        <div className={styles.tabContent}>
          {activeTab === 'items' && (
            <ItemsTab
              items={session.items || []}
              searchQuery={searchQuery}
              onSearchChange={setSearchQuery}
              hasConfirmedQuantity={session.totalConfirmedQuantity != null}
              isReceivingSession={isReceivingSession}
            />
          )}

          {activeTab === 'members' && (
            <MembersTab members={session.members || []} />
          )}

          {activeTab === 'newProducts' && (
            <NewProductsTab newProducts={newProducts} />
          )}

          {activeTab === 'restocked' && (
            <RestockedTab restockedProducts={restockedProducts} />
          )}

          {activeTab === 'mergeDetails' && isMergedSession && (
            <MergeDetailsTab
              mergeInfo={session.mergeInfo!}
              expandedMergedSession={expandedMergedSession}
              onToggleMergedSession={toggleMergedSession}
            />
          )}
        </div>
      </div>
    </>
  );
};

export default SessionHistoryDetailPage;
