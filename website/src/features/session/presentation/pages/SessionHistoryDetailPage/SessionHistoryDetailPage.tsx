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
import type { SessionHistoryEntry, SessionHistoryItem, SessionMergeInfo } from '../../../domain/entities';
import styles from './SessionHistoryDetailPage.module.css';

// Format date for display (yyyy/MM/dd HH:mm)
const formatDateTime = (dateStr: string | null): string => {
  if (!dateStr) return '-';
  const date = new Date(dateStr);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  return `${year}/${month}/${day} ${hours}:${minutes}`;
};

// Get user display name from first and last name
const getUserDisplayName = (firstName: string, lastName: string): string => {
  return `${firstName} ${lastName}`.trim() || 'Unknown';
};

// Get scanned by display string from array of scanners
const getScannedByDisplay = (scannedBy: SessionHistoryItem['scannedBy']): string => {
  if (!scannedBy || scannedBy.length === 0) return '-';
  return scannedBy.map(s => getUserDisplayName(s.firstName, s.lastName)).join(', ');
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

  // Filter items based on search
  const filteredItems = useMemo(() => {
    if (!session?.items) return [];
    if (!searchQuery.trim()) return session.items;

    const query = searchQuery.toLowerCase();
    return session.items.filter(
      (item) =>
        item.productName.toLowerCase().includes(query) ||
        item.sku?.toLowerCase().includes(query)
    );
  }, [session?.items, searchQuery]);

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
                  ? `${Math.floor(session.durationMinutes / 60)}h ${session.durationMinutes % 60}m`
                  : `${session.durationMinutes}m`}
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
          {/* Items Tab */}
          {activeTab === 'items' && (
            <div className={styles.itemsSection}>
              <div className={styles.searchWrapper}>
                <svg className={styles.searchIcon} width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <circle cx="11" cy="11" r="8" />
                  <path d="m21 21-4.35-4.35" />
                </svg>
                <input
                  type="text"
                  className={styles.searchInput}
                  placeholder="Search items..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                />
              </div>
              <div className={styles.tableContainer}>
                <table className={styles.dataTable}>
                  <thead>
                    <tr>
                      <th>Product</th>
                      <th>SKU</th>
                      <th>Scanned Qty</th>
                      {session.totalConfirmedQuantity != null && <th>Confirmed Qty</th>}
                      {isReceivingSession && <th>Expected</th>}
                      {isReceivingSession && <th>Difference</th>}
                      <th>Scanned By</th>
                    </tr>
                  </thead>
                  <tbody>
                    {filteredItems.length > 0 ? (
                      filteredItems.map((item, index) => (
                        <tr key={`${item.productId}-${index}`}>
                          <td className={styles.productName}>{item.productName}</td>
                          <td>{item.sku || '-'}</td>
                          <td className={styles.quantityCell}>{item.scannedQuantity}</td>
                          {session.totalConfirmedQuantity != null && (
                            <td className={styles.quantityCell}>{item.confirmedQuantity ?? '-'}</td>
                          )}
                          {isReceivingSession && (
                            <td className={styles.quantityCell}>{item.quantityExpected ?? '-'}</td>
                          )}
                          {isReceivingSession && (
                            <td className={`${styles.varianceCell} ${(item.quantityDifference ?? 0) < 0 ? styles.negative : (item.quantityDifference ?? 0) > 0 ? styles.positive : ''}`}>
                              {item.quantityDifference != null ? (item.quantityDifference > 0 ? `+${item.quantityDifference}` : item.quantityDifference) : '-'}
                            </td>
                          )}
                          <td>{getScannedByDisplay(item.scannedBy)}</td>
                        </tr>
                      ))
                    ) : (
                      <tr>
                        <td colSpan={isReceivingSession ? 7 : (session.totalConfirmedQuantity != null ? 5 : 4)} className={styles.emptyCell}>
                          {searchQuery ? 'No items match your search' : 'No items in this session'}
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* Members Tab */}
          {activeTab === 'members' && (
            <div className={styles.membersSection}>
              <div className={styles.membersGrid}>
                {session.members && session.members.length > 0 ? (
                  session.members.map((member) => (
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
          )}

          {/* New Products Tab (Receiving sessions) */}
          {activeTab === 'newProducts' && (
            <div className={styles.newProductsSection}>
              <div className={styles.sectionHeader}>
                <div className={styles.sectionIcon}>
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <path d="M12 5v14M5 12h14" />
                  </svg>
                </div>
                <div>
                  <h3 className={styles.sectionTitle}>New Products Added</h3>
                  <p className={styles.sectionSubtitle}>
                    These products were added to inventory for the first time
                  </p>
                </div>
              </div>
              <div className={styles.tableContainer}>
                <table className={styles.dataTable}>
                  <thead>
                    <tr>
                      <th>Product</th>
                      <th>SKU</th>
                      <th>Quantity Received</th>
                      <th>Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    {newProducts.map((product, index) => (
                      <tr key={`${product.productId}-${index}`} className={styles.newProductRow}>
                        <td className={styles.productName}>
                          <span className={styles.newBadge}>NEW</span>
                          {product.productName}
                        </td>
                        <td>{product.sku || '-'}</td>
                        <td className={`${styles.quantityCell} ${styles.positive}`}>
                          +{product.quantityReceived.toLocaleString()}
                        </td>
                        <td>
                          <span className={styles.stockStatus}>
                            Initial Stock: {product.quantityAfter.toLocaleString()}
                          </span>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* Restocked Products Tab (Receiving sessions) */}
          {activeTab === 'restocked' && (
            <div className={styles.stockChangesSection}>
              <div className={styles.sectionHeader}>
                <div className={styles.sectionIconBlue}>
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                  </svg>
                </div>
                <div>
                  <h3 className={styles.sectionTitle}>Restocked Products</h3>
                  <p className={styles.sectionSubtitle}>
                    Existing products that received additional stock
                  </p>
                </div>
              </div>
              <div className={styles.tableContainer}>
                <table className={styles.dataTable}>
                  <thead>
                    <tr>
                      <th>Product</th>
                      <th>SKU</th>
                      <th>Previous Qty</th>
                      <th>Received</th>
                      <th>New Qty</th>
                    </tr>
                  </thead>
                  <tbody>
                    {restockedProducts.map((stock, index) => (
                      <tr key={`${stock.productId}-${index}`}>
                        <td className={styles.productName}>{stock.productName}</td>
                        <td>{stock.sku || '-'}</td>
                        <td className={styles.quantityCell}>{stock.quantityBefore.toLocaleString()}</td>
                        <td className={`${styles.quantityCell} ${styles.positive}`}>+{stock.quantityReceived.toLocaleString()}</td>
                        <td className={styles.quantityCell}>{stock.quantityAfter.toLocaleString()}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* Merge Details Tab */}
          {activeTab === 'mergeDetails' && isMergedSession && (
            <div className={styles.mergeDetailsSection}>
              {/* Original Session */}
              <div className={styles.mergeSessionCard}>
                <div className={styles.mergeSessionHeader}>
                  <div className={styles.mergeSessionBadge}>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <circle cx="12" cy="12" r="10" />
                      <path d="M12 8v8M8 12h8" />
                    </svg>
                    Original Session
                  </div>
                  <div className={styles.mergeSessionStats}>
                    <span>{session.mergeInfo!.originalSession.itemsCount} items</span>
                    <span className={styles.divider}>•</span>
                    <span>{session.mergeInfo!.originalSession.totalQuantity.toLocaleString()} qty</span>
                  </div>
                </div>
                <div className={styles.mergeSessionContent}>
                  <table className={styles.dataTable}>
                    <thead>
                      <tr>
                        <th>Product</th>
                        <th>SKU</th>
                        <th>Quantity</th>
                        <th>Rejected</th>
                        <th>Scanned By</th>
                      </tr>
                    </thead>
                    <tbody>
                      {session.mergeInfo!.originalSession.items.map((item, idx) => (
                        <tr key={`original-${item.productId}-${idx}`}>
                          <td className={styles.productName}>{item.productName}</td>
                          <td>{item.sku || '-'}</td>
                          <td className={styles.quantityCell}>{item.quantity}</td>
                          <td className={item.quantityRejected > 0 ? styles.negative : ''}>
                            {item.quantityRejected > 0 ? item.quantityRejected : '-'}
                          </td>
                          <td>
                            {getUserDisplayName(item.scannedBy.firstName, item.scannedBy.lastName)}
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>

              {/* Merged Sessions */}
              {session.mergeInfo!.mergedSessions.map((mergedSession, sessionIdx) => (
                <div key={mergedSession.sourceSessionId} className={styles.mergeSessionCard}>
                  <div
                    className={styles.mergeSessionHeader}
                    onClick={() => toggleMergedSession(mergedSession.sourceSessionId)}
                    style={{ cursor: 'pointer' }}
                  >
                    <div className={styles.mergeSessionInfo}>
                      <div className={styles.mergeSessionBadge}>
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                          <path d="M16 3h5v5M8 3H3v5M3 16v5h5M21 16v5h-5" />
                        </svg>
                        Merged Session #{sessionIdx + 1}
                      </div>
                      <div className={styles.mergeSessionName}>{mergedSession.sourceSessionName}</div>
                    </div>
                    <div className={styles.mergeSessionMeta}>
                      <div className={styles.mergeSessionStats}>
                        <span>{mergedSession.itemsCount} items</span>
                        <span className={styles.divider}>•</span>
                        <span>{mergedSession.totalQuantity.toLocaleString()} qty</span>
                      </div>
                      <div className={styles.mergeSessionCreator}>
                        <span className={styles.creatorLabel}>Created by:</span>
                        <span className={styles.creatorName}>
                          {getUserDisplayName(mergedSession.sourceCreatedBy.firstName, mergedSession.sourceCreatedBy.lastName)}
                        </span>
                      </div>
                      <div className={styles.mergeSessionDate}>
                        {formatDateTime(mergedSession.sourceCreatedAt)}
                      </div>
                      <svg
                        className={`${styles.expandIcon} ${expandedMergedSession === mergedSession.sourceSessionId ? styles.expanded : ''}`}
                        width="20"
                        height="20"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        strokeWidth="2"
                      >
                        <path d="M6 9l6 6 6-6" />
                      </svg>
                    </div>
                  </div>

                  {expandedMergedSession === mergedSession.sourceSessionId && (
                    <div className={styles.mergeSessionContent}>
                      <table className={styles.dataTable}>
                        <thead>
                          <tr>
                            <th>Product</th>
                            <th>SKU</th>
                            <th>Quantity</th>
                            <th>Rejected</th>
                            <th>Scanned By</th>
                          </tr>
                        </thead>
                        <tbody>
                          {mergedSession.items.map((item, idx) => (
                            <tr key={`merged-${mergedSession.sourceSessionId}-${item.productId}-${idx}`}>
                              <td className={styles.productName}>{item.productName}</td>
                              <td>{item.sku || '-'}</td>
                              <td className={styles.quantityCell}>{item.quantity}</td>
                              <td className={item.quantityRejected > 0 ? styles.negative : ''}>
                                {item.quantityRejected > 0 ? item.quantityRejected : '-'}
                              </td>
                              <td>
                                {getUserDisplayName(item.scannedBy.firstName, item.scannedBy.lastName)}
                              </td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  )}
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </>
  );
};

export default SessionHistoryDetailPage;
