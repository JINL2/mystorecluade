/**
 * ProductReceivePage Component
 * Shows shipment list and receiving progress using inventory_get_shipment_list
 * Click on shipment to view detail with inventory_get_shipment_detail
 */

import React, { useRef, useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Navbar } from '@/shared/components/common/Navbar';
import { LeftFilter } from '@/shared/components/common/LeftFilter';
import type { FilterSection } from '@/shared/components/common/LeftFilter';
import { SelectorModal } from '@/shared/components/common/SelectorModal';
import type { SelectorOption } from '@/shared/components/common/SelectorModal/SelectorModal.types';
import { useAppState } from '@/app/providers/app_state_provider';
import { supabaseService } from '@/core/services/supabase_service';
import { useProductReceiveList, formatDateDisplay } from '../../hooks/useProductReceiveList';
import { SHIPMENT_STATUS_OPTIONS } from './ProductReceivePage.types';
import type { Session } from './ProductReceivePage.types';
import styles from './ProductReceivePage.module.css';

export const ProductReceivePage: React.FC = () => {
  const navigate = useNavigate();
  const datePickerRef = useRef<HTMLDivElement>(null);

  // App state
  const { currentCompany, currentUser } = useAppState();
  const stores = currentCompany?.stores || [];

  // Session modal state
  const [showSessionModal, setShowSessionModal] = useState(false);
  const [sessionShipmentId, setSessionShipmentId] = useState<string | null>(null);

  // Create session modal state
  const [showCreateSessionModal, setShowCreateSessionModal] = useState(false);
  const [selectedStoreId, setSelectedStoreId] = useState<string | null>(null);
  const [isCreatingSession, setIsCreatingSession] = useState(false);
  const [createSessionError, setCreateSessionError] = useState<string | null>(null);

  // Join session modal state
  const [showJoinSessionModal, setShowJoinSessionModal] = useState(false);
  const [existingSessions, setExistingSessions] = useState<Session[]>([]);
  const [sessionsLoading, setSessionsLoading] = useState(false);
  const [sessionsError, setSessionsError] = useState<string | null>(null);
  const [selectedSessionId, setSelectedSessionId] = useState<string | null>(null);

  const {
    currency,
    shipments,
    shipmentsLoading,
    selectedShipmentId,
    shipmentDetail,
    detailLoading,
    searchQuery,
    datePreset,
    fromDate,
    toDate,
    showDatePicker,
    tempFromDate,
    tempToDate,
    shipmentStatusFilter,
    supplierFilter,
    supplierOptions,
    handleSearchChange,
    selectShipmentStatus,
    clearShipmentStatusFilter,
    selectSupplierFilter,
    clearSupplierFilter,
    handlePresetChange,
    handleApplyCustomDate,
    handleCancelCustomDate,
    handleSetTodayDate,
    setTempFromDate,
    setTempToDate,
    loadShipmentDetail,
    clearSelectedShipment,
  } = useProductReceiveList();

  // Click outside to close date picker
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (datePickerRef.current && !datePickerRef.current.contains(event.target as Node)) {
        handleCancelCustomDate();
      }
    };

    if (showDatePicker) {
      document.addEventListener('mousedown', handleClickOutside);
    }
    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, [showDatePicker, handleCancelCustomDate]);

  // Handle Start Receive button click
  const handleStartReceive = (shipmentId: string) => {
    setSessionShipmentId(shipmentId);
    setShowSessionModal(true);
  };

  // Handle session option selection
  const handleSessionSelect = async (optionId: string) => {
    if (optionId === 'create_session') {
      // Show create session modal
      setShowSessionModal(false);
      setShowCreateSessionModal(true);
      setSelectedStoreId(null);
      setCreateSessionError(null);
    } else if (optionId === 'join_session') {
      // Load existing sessions and show join modal
      setShowSessionModal(false);
      setShowJoinSessionModal(true);
      setSelectedSessionId(null);
      setSessionsError(null);
      await loadExistingSessions();
    }
  };

  // Load existing active sessions for the shipment
  const loadExistingSessions = async () => {
    if (!currentCompany || !sessionShipmentId) return;

    setSessionsLoading(true);
    setSessionsError(null);

    try {
      const supabase = supabaseService.getClient();
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

      console.log('📦 Loading existing sessions for shipment:', sessionShipmentId);

      const { data, error } = await supabase.rpc('inventory_get_session_list', {
        p_company_id: currentCompany.company_id,
        p_shipment_id: sessionShipmentId,
        p_session_type: 'receiving',
        p_is_active: true,
        p_timezone: userTimezone,
      });

      console.log('📦 inventory_get_session_list response:', { data, error });

      if (error) {
        throw new Error(error.message);
      }

      if (data?.success && data?.data) {
        setExistingSessions(data.data);
      } else {
        setSessionsError(data?.error || 'Failed to load sessions');
        setExistingSessions([]);
      }
    } catch (err) {
      console.error('📦 Load sessions error:', err);
      setSessionsError(err instanceof Error ? err.message : 'Failed to load sessions');
      setExistingSessions([]);
    } finally {
      setSessionsLoading(false);
    }
  };

  // State for joining session
  const [isJoiningSession, setIsJoiningSession] = useState(false);

  // Handle join session
  const handleJoinSession = async () => {
    if (!selectedSessionId || !currentUser) {
      setSessionsError('Please select a session to join');
      return;
    }

    setIsJoiningSession(true);
    setSessionsError(null);

    try {
      const supabase = supabaseService.getClient();

      // Get user's local timezone
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

      // Get user's current local time
      const now = new Date();
      const localTime = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')} ${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}:${String(now.getSeconds()).padStart(2, '0')}`;

      console.log('📦 Joining session:', { selectedSessionId, localTime, userTimezone });

      // Call inventory_join_session RPC
      const { data, error } = await supabase.rpc('inventory_join_session', {
        p_session_id: selectedSessionId,
        p_user_id: currentUser.user_id,
        p_time: localTime,
        p_timezone: userTimezone,
      });

      console.log('📦 inventory_join_session response:', { data, error });

      if (error) {
        throw new Error(error.message);
      }

      if (data?.success) {
        // Success - navigate to receiving session page
        // Find selected session data
        const selectedSession = existingSessions.find(s => s.session_id === selectedSessionId);

        // Find shipment data
        const shipmentData = shipmentDetail || shipments.find(s => s.shipment_id === sessionShipmentId);

        // Store values before clearing state
        const shipmentIdForNav = sessionShipmentId;

        setShowJoinSessionModal(false);
        setSessionShipmentId(null);
        setSelectedSessionId(null);
        setExistingSessions([]);

        navigate(`/product/receive/session/${selectedSessionId}`, {
          state: {
            sessionData: {
              ...selectedSession,
              member_id: data.data?.member_id,
              created_by: data.data?.created_by,
              created_by_name: data.data?.created_by_name,
            },
            shipmentId: shipmentIdForNav,
            shipmentData: shipmentData,
            isNewSession: false,
            joinMessage: data.message, // "Joined session successfully" or "Already a member of this session"
          }
        });
      } else {
        // Handle RPC error
        setSessionsError(data?.error || 'Failed to join session');
      }
    } catch (err) {
      console.error('📦 Join session error:', err);
      setSessionsError(err instanceof Error ? err.message : 'Failed to join session');
    } finally {
      setIsJoiningSession(false);
    }
  };

  // Close join session modal
  const handleCloseJoinSessionModal = () => {
    setShowJoinSessionModal(false);
    setSessionShipmentId(null);
    setSelectedSessionId(null);
    setExistingSessions([]);
    setSessionsError(null);
  };

  // Handle create session
  const handleCreateSession = async () => {
    if (!selectedStoreId || !sessionShipmentId || !currentCompany || !currentUser) {
      setCreateSessionError('Please select a store');
      return;
    }

    setIsCreatingSession(true);
    setCreateSessionError(null);

    try {
      const supabase = supabaseService.getClient();

      // Get user's local timezone
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

      // Get user's current local time in ISO format (YYYY-MM-DD HH:MM:SS)
      const now = new Date();
      const localTime = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')} ${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}:${String(now.getSeconds()).padStart(2, '0')}`;

      console.log('📦 Creating session with local time:', { localTime, userTimezone });

      const { data, error } = await supabase.rpc('inventory_create_session', {
        p_company_id: currentCompany.company_id,
        p_store_id: selectedStoreId,
        p_user_id: currentUser.user_id,
        p_session_type: 'receiving',
        p_shipment_id: sessionShipmentId,
        p_time: localTime,
        p_timezone: userTimezone,
      });

      console.log('📦 inventory_create_session response:', { data, error });

      if (error) {
        throw new Error(error.message);
      }

      if (data?.success && data?.data) {
        // Success - navigate to receiving session page
        const sessionId = data.data.session_id;
        const sessionData = data.data;
        console.log('Session created:', sessionId);

        // Find store name
        const selectedStore = stores.find(s => s.store_id === selectedStoreId);

        // Find shipment data
        const shipmentData = shipmentDetail || shipments.find(s => s.shipment_id === sessionShipmentId);

        setShowCreateSessionModal(false);
        const shipmentIdForNav = sessionShipmentId;
        const storeIdForNav = selectedStoreId;
        setSessionShipmentId(null);
        setSelectedStoreId(null);

        navigate(`/product/receive/session/${sessionId}`, {
          state: {
            sessionData: {
              ...sessionData,
              store_name: selectedStore?.store_name || '',
              store_id: storeIdForNav,
            },
            shipmentId: shipmentIdForNav,
            shipmentData: shipmentData,
            isNewSession: true,
          }
        });
      } else {
        // Handle RPC error
        setCreateSessionError(data?.error || 'Failed to create session');
      }
    } catch (err) {
      console.error('📦 Create session error:', err);
      setCreateSessionError(err instanceof Error ? err.message : 'Failed to create session');
    } finally {
      setIsCreatingSession(false);
    }
  };

  // Close create session modal
  const handleCloseCreateSessionModal = () => {
    setShowCreateSessionModal(false);
    setSessionShipmentId(null);
    setSelectedStoreId(null);
    setCreateSessionError(null);
  };

  // Session modal options
  const sessionOptions: SelectorOption[] = [
    {
      id: 'create_session',
      label: 'Create New Session',
      variant: 'primary',
      icon: (
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
          <circle cx="12" cy="12" r="10" />
          <line x1="12" y1="8" x2="12" y2="16" />
          <line x1="8" y1="12" x2="16" y2="12" />
        </svg>
      ),
    },
    {
      id: 'join_session',
      label: 'Join Existing Session',
      variant: 'outline',
      icon: (
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
          <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
          <circle cx="9" cy="7" r="4" />
          <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
          <path d="M16 3.13a4 4 0 0 1 0 7.75" />
        </svg>
      ),
    },
  ];

  // LeftFilter sections configuration
  const filterSections: FilterSection[] = [
    {
      id: 'shipmentDate',
      title: 'Shipped Date',
      type: 'custom',
      defaultExpanded: true,
      customContent: (
        <div className={styles.dateFilterContent}>
          <label className={styles.datePresetOption}>
            <input
              type="radio"
              name="datePreset"
              checked={datePreset === 'this_month'}
              onChange={() => handlePresetChange('this_month')}
              className={styles.radioInput}
            />
            <span className={styles.radioLabel}>This Month</span>
          </label>

          <label className={styles.datePresetOption}>
            <input
              type="radio"
              name="datePreset"
              checked={datePreset === 'last_month'}
              onChange={() => handlePresetChange('last_month')}
              className={styles.radioInput}
            />
            <span className={styles.radioLabel}>Last Month</span>
          </label>

          <label className={styles.datePresetOption}>
            <input
              type="radio"
              name="datePreset"
              checked={datePreset === 'this_year'}
              onChange={() => handlePresetChange('this_year')}
              className={styles.radioInput}
            />
            <span className={styles.radioLabel}>This Year</span>
          </label>

          <label className={styles.datePresetOption}>
            <input
              type="radio"
              name="datePreset"
              checked={datePreset === 'custom'}
              onChange={() => handlePresetChange('custom')}
              className={styles.radioInput}
            />
            <div
              className={`${styles.customDateButton} ${datePreset === 'custom' ? styles.active : ''}`}
              onClick={(e) => {
                e.preventDefault();
                handlePresetChange('custom');
              }}
            >
              <span>Custom</span>
              <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                <path d="M19,19H5V8H19M16,1V3H8V1H6V3H5C3.89,3 3,3.89 3,5V19A2,2 0 0,0 5,21H19A2,2 0 0,0 21,19V5C21,3.89 20.1,3 19,3H18V1M17,12H12V17H17V12Z" />
              </svg>
            </div>
          </label>

          {(fromDate || toDate) && (
            <div className={styles.selectedDateRange}>
              <span className={styles.dateRangeText}>
                {formatDateDisplay(fromDate)} ~ {formatDateDisplay(toDate)}
              </span>
            </div>
          )}
        </div>
      ),
    },
    {
      id: 'shipmentStatus',
      title: 'Shipment Status',
      type: 'radio',
      defaultExpanded: true,
      options: SHIPMENT_STATUS_OPTIONS,
      selectedValues: shipmentStatusFilter || '',
      onSelect: selectShipmentStatus,
      onClear: clearShipmentStatusFilter,
    },
    {
      id: 'supplier',
      title: 'Supplier',
      type: 'radio',
      defaultExpanded: true,
      options: supplierOptions,
      selectedValues: supplierFilter || '',
      onSelect: selectSupplierFilter,
      onClear: clearSupplierFilter,
    },
  ];

  // Handle shipment row click
  const handleShipmentClick = (shipmentId: string) => {
    if (selectedShipmentId === shipmentId) {
      clearSelectedShipment();
    } else {
      loadShipmentDetail(shipmentId);
    }
  };

  // Render progress bar
  const renderProgressBar = (percentage: number) => {
    const getProgressColor = () => {
      if (percentage === 100) return '#2E7D32'; // Green
      if (percentage >= 50) return '#0064FF'; // Blue
      return '#FF8A00'; // Orange
    };

    return (
      <div className={styles.progressBarContainer}>
        <div className={styles.progressBarBackground}>
          <div
            className={styles.progressBarFill}
            style={{
              width: `${percentage}%`,
              backgroundColor: getProgressColor(),
            }}
          />
        </div>
        <span className={styles.progressPercentage}>{percentage.toFixed(0)}%</span>
      </div>
    );
  };

  return (
    <>
      <Navbar activeItem="product" />
      <div className={styles.pageLayout}>
        <div className={styles.sidebarWrapper}>
          <LeftFilter sections={filterSections} width={240} topOffset={64} />
        </div>

        <div className={styles.mainContent}>
          <div className={styles.container}>
            <div className={styles.header}>
              <h1 className={styles.title}>Product Receives</h1>
              <p className={styles.subtitle}>Track receiving progress for shipments</p>
            </div>

            <div className={styles.contentCard}>
              <div className={styles.receiveHeader}>
                <div className={styles.receiveTitleSection}>
                  <h2 className={styles.receiveListTitle}>Shipments</h2>
                  <div className={styles.receiveSearchWrapper}>
                    <svg className={styles.searchIcon} width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <circle cx="11" cy="11" r="8" />
                      <path d="m21 21-4.35-4.35" />
                    </svg>
                    <input
                      type="text"
                      className={styles.receiveSearch}
                      placeholder="Search shipments..."
                      value={searchQuery}
                      onChange={(e) => handleSearchChange(e.target.value)}
                    />
                  </div>
                </div>
              </div>

              <div className={styles.tableContainer}>
                <table className={styles.receivesTable}>
                  <thead>
                    <tr>
                      <th>Shipment #</th>
                      <th>Shipped Date</th>
                      <th>Supplier</th>
                      <th>Items</th>
                      <th>Total Amount</th>
                      <th>Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    {shipmentsLoading ? (
                      <tr>
                        <td colSpan={6}>
                          <div className={styles.loadingState}>
                            <div className={styles.spinner} />
                            <p>Loading shipments...</p>
                          </div>
                        </td>
                      </tr>
                    ) : shipments.length > 0 ? (
                      shipments.map((shipment) => (
                        <React.Fragment key={shipment.shipment_id}>
                          <tr
                            className={`${styles.shipmentRow} ${selectedShipmentId === shipment.shipment_id ? styles.selected : ''}`}
                            onClick={() => handleShipmentClick(shipment.shipment_id)}
                          >
                            <td>
                              <span className={styles.receiveNumber}>{shipment.shipment_number}</span>
                            </td>
                            <td>{formatDateDisplay(shipment.shipped_date?.split(' ')[0] || '')}</td>
                            <td>
                              <span className={styles.supplierName}>{shipment.supplier_name}</span>
                            </td>
                            <td>
                              <span className={styles.itemCount}>{shipment.item_count}</span>
                            </td>
                            <td>
                              <span className={styles.currencyAmount}>
                                {currency.symbol}{(shipment as { total_amount?: number }).total_amount?.toLocaleString() || '0'}
                              </span>
                            </td>
                            <td>
                              <span className={`${styles.statusBadge} ${styles[shipment.status]}`}>
                                {shipment.status}
                              </span>
                            </td>
                          </tr>

                          {/* Expanded Detail Row */}
                          {selectedShipmentId === shipment.shipment_id && (
                            <tr className={styles.detailRow}>
                              <td colSpan={6}>
                                {detailLoading ? (
                                  <div className={styles.detailLoading}>
                                    <div className={styles.spinnerSmall} />
                                    <span>Loading receiving details...</span>
                                  </div>
                                ) : shipmentDetail ? (
                                  <div className={styles.detailContent}>
                                    {/* Action Row with Start Receive Button */}
                                    <div className={styles.detailActionRow}>
                                      <div className={styles.detailActionLeft}>
                                        {/* Left side - can add info here if needed */}
                                      </div>
                                      <div className={styles.detailActionRight}>
                                        <button
                                          className={styles.startReceiveButton}
                                          onClick={(e) => {
                                            e.stopPropagation();
                                            handleStartReceive(shipment.shipment_id);
                                          }}
                                        >
                                          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                            <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                                            <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
                                            <line x1="12" y1="22.08" x2="12" y2="12" />
                                          </svg>
                                          Start Receive
                                        </button>
                                      </div>
                                    </div>

                                    {/* Receiving Summary */}
                                    <div className={styles.receivingSummary}>
                                      <h4 className={styles.detailSectionTitle}>Receiving Progress</h4>
                                      <div className={styles.summaryStats}>
                                        <div className={styles.statItem}>
                                          <span className={styles.statLabel}>Total Shipped</span>
                                          <span className={styles.statValue}>{shipmentDetail.receiving_summary.total_shipped}</span>
                                        </div>
                                        <div className={styles.statItem}>
                                          <span className={styles.statLabel}>Received</span>
                                          <span className={styles.statValue}>{shipmentDetail.receiving_summary.total_received}</span>
                                        </div>
                                        <div className={styles.statItem}>
                                          <span className={styles.statLabel}>Accepted</span>
                                          <span className={styles.statValueGreen}>{shipmentDetail.receiving_summary.total_accepted}</span>
                                        </div>
                                        <div className={styles.statItem}>
                                          <span className={styles.statLabel}>Rejected</span>
                                          <span className={styles.statValueRed}>{shipmentDetail.receiving_summary.total_rejected}</span>
                                        </div>
                                        <div className={styles.statItem}>
                                          <span className={styles.statLabel}>Remaining</span>
                                          <span className={styles.statValueOrange}>{shipmentDetail.receiving_summary.total_remaining}</span>
                                        </div>
                                        <div className={styles.statItemProgress}>
                                          <span className={styles.statLabel}>Progress</span>
                                          {renderProgressBar(shipmentDetail.receiving_summary.progress_percentage)}
                                        </div>
                                      </div>
                                    </div>

                                    {/* Items Detail */}
                                    <div className={styles.itemsDetail}>
                                      <h4 className={styles.detailSectionTitle}>Items Detail</h4>
                                      <table className={styles.itemsTable}>
                                        <thead>
                                          <tr>
                                            <th>Product</th>
                                            <th>SKU</th>
                                            <th>Shipped</th>
                                            <th>Received</th>
                                            <th>Accepted</th>
                                            <th>Rejected</th>
                                            <th>Remaining</th>
                                          </tr>
                                        </thead>
                                        <tbody>
                                          {shipmentDetail.items.map((item) => (
                                            <tr key={item.item_id}>
                                              <td className={styles.productName}>{item.product_name}</td>
                                              <td className={styles.sku}>{item.sku}</td>
                                              <td>{item.quantity_shipped}</td>
                                              <td>{item.quantity_received}</td>
                                              <td className={styles.acceptedQty}>{item.quantity_accepted}</td>
                                              <td className={styles.rejectedQty}>{item.quantity_rejected}</td>
                                              <td className={styles.remainingQty}>{item.quantity_remaining}</td>
                                            </tr>
                                          ))}
                                        </tbody>
                                      </table>
                                    </div>
                                  </div>
                                ) : (
                                  <div className={styles.detailError}>
                                    Failed to load shipment details
                                  </div>
                                )}
                              </td>
                            </tr>
                          )}
                        </React.Fragment>
                      ))
                    ) : (
                      <tr>
                        <td colSpan={6}>
                          <div className={styles.emptyState}>
                            <svg className={styles.emptyIcon} width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1">
                              <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                              <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
                              <line x1="12" y1="22.08" x2="12" y2="12" />
                            </svg>
                            <p className={styles.emptyTitle}>No shipments found</p>
                            <p className={styles.emptyDescription}>
                              {searchQuery ? 'Try adjusting your search or filters' : 'No shipments to receive yet'}
                            </p>
                          </div>
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>

      {showDatePicker && (
        <div className={styles.datePickerOverlay}>
          <div className={styles.datePickerModal} ref={datePickerRef}>
            <div className={styles.datePickerHeader}>
              <span>From date: <strong>{formatDateDisplay(tempFromDate) || 'Select'}</strong></span>
              <span> - </span>
              <span>To date: <strong>{formatDateDisplay(tempToDate) || 'Select'}</strong></span>
            </div>

            <div className={styles.datePickerBody}>
              <div className={styles.calendarContainer}>
                <div className={styles.calendarSection}>
                  <label className={styles.calendarLabel}>From Date</label>
                  <input
                    type="date"
                    className={styles.calendarInput}
                    value={tempFromDate}
                    onChange={(e) => setTempFromDate(e.target.value)}
                  />
                </div>
                <div className={styles.calendarSection}>
                  <label className={styles.calendarLabel}>To Date</label>
                  <input
                    type="date"
                    className={styles.calendarInput}
                    value={tempToDate}
                    onChange={(e) => setTempToDate(e.target.value)}
                  />
                </div>
              </div>
            </div>

            <div className={styles.datePickerFooter}>
              <button className={styles.todayButton} onClick={handleSetTodayDate}>
                Today
              </button>
              <div className={styles.datePickerActions}>
                <button className={styles.cancelButton} onClick={handleCancelCustomDate}>
                  Cancel
                </button>
                <button
                  className={styles.applyButton}
                  onClick={handleApplyCustomDate}
                  disabled={!tempFromDate || !tempToDate}
                >
                  Apply
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Session Selection Modal */}
      <SelectorModal
        isOpen={showSessionModal}
        onClose={() => {
          setShowSessionModal(false);
          setSessionShipmentId(null);
        }}
        onSelect={handleSessionSelect}
        variant="info"
        title="Start Receiving"
        message="Choose how you want to receive items for this shipment."
        options={sessionOptions}
        cancelText="Cancel"
        headerIcon={
          <svg width="48" height="48" viewBox="0 0 24 24" fill="#0064FF">
            <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
            <polyline points="3.27 6.96 12 12.01 20.73 6.96" fill="none" stroke="white" strokeWidth="1.5" />
            <line x1="12" y1="22.08" x2="12" y2="12" stroke="white" strokeWidth="1.5" />
          </svg>
        }
      />

      {/* Create Session Modal */}
      {showCreateSessionModal && (
        <div className={styles.modalOverlay} onClick={handleCloseCreateSessionModal}>
          <div className={styles.createSessionModal} onClick={(e) => e.stopPropagation()}>
            {/* Modal Header */}
            <div className={styles.createSessionHeader}>
              <div className={styles.createSessionIcon}>
                <svg width="32" height="32" viewBox="0 0 24 24" fill="#0064FF">
                  <circle cx="12" cy="12" r="10" />
                  <line x1="12" y1="8" x2="12" y2="16" stroke="white" strokeWidth="2" />
                  <line x1="8" y1="12" x2="16" y2="12" stroke="white" strokeWidth="2" />
                </svg>
              </div>
              <h2 className={styles.createSessionTitle}>Create New Session</h2>
              <p className={styles.createSessionSubtitle}>
                Select a store to start receiving items
              </p>
            </div>

            {/* Modal Body */}
            <div className={styles.createSessionBody}>
              {/* Store Selection */}
              <div className={styles.formGroup}>
                <label className={styles.formLabel}>Store Location</label>
                <div className={styles.storeList}>
                  {stores.length === 0 ? (
                    <div className={styles.noStores}>No stores available</div>
                  ) : (
                    stores.map((store) => (
                      <button
                        key={store.store_id}
                        type="button"
                        className={`${styles.storeOption} ${selectedStoreId === store.store_id ? styles.selected : ''}`}
                        onClick={() => setSelectedStoreId(store.store_id)}
                      >
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                          <path d="M10,20V14H14V20H19V12H22L12,3L2,12H5V20H10Z" />
                        </svg>
                        <span>{store.store_name}</span>
                        {selectedStoreId === store.store_id && (
                          <svg className={styles.checkIcon} width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z" />
                          </svg>
                        )}
                      </button>
                    ))
                  )}
                </div>
              </div>

              {/* Error Message */}
              {createSessionError && (
                <div className={styles.errorMessage}>
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12,2C17.53,2 22,6.47 22,12C22,17.53 17.53,22 12,22C6.47,22 2,17.53 2,12C2,6.47 6.47,2 12,2M15.59,7L12,10.59L8.41,7L7,8.41L10.59,12L7,15.59L8.41,17L12,13.41L15.59,17L17,15.59L13.41,12L17,8.41L15.59,7Z" />
                  </svg>
                  <span>{createSessionError}</span>
                </div>
              )}
            </div>

            {/* Modal Footer */}
            <div className={styles.createSessionFooter}>
              <button
                type="button"
                className={styles.cancelSessionButton}
                onClick={handleCloseCreateSessionModal}
                disabled={isCreatingSession}
              >
                Cancel
              </button>
              <button
                type="button"
                className={styles.createSessionButton}
                onClick={handleCreateSession}
                disabled={!selectedStoreId || isCreatingSession}
              >
                {isCreatingSession ? (
                  <>
                    <div className={styles.buttonSpinner} />
                    Creating...
                  </>
                ) : (
                  <>
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                      <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
                      <line x1="12" y1="22.08" x2="12" y2="12" />
                    </svg>
                    Create Session
                  </>
                )}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Join Session Modal */}
      {showJoinSessionModal && (
        <div className={styles.modalOverlay} onClick={handleCloseJoinSessionModal}>
          <div className={styles.createSessionModal} onClick={(e) => e.stopPropagation()}>
            {/* Modal Header */}
            <div className={styles.joinSessionHeader}>
              <div className={styles.createSessionIcon}>
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="2">
                  <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                  <circle cx="9" cy="7" r="4" />
                  <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
                  <path d="M16 3.13a4 4 0 0 1 0 7.75" />
                </svg>
              </div>
              <h2 className={styles.createSessionTitle}>Join Existing Session</h2>
              <p className={styles.createSessionSubtitle}>
                Select an active session to join
              </p>
            </div>

            {/* Modal Body */}
            <div className={styles.createSessionBody}>
              {sessionsLoading ? (
                <div className={styles.sessionsLoading}>
                  <div className={styles.spinnerSmall} />
                  <span>Loading sessions...</span>
                </div>
              ) : existingSessions.length === 0 ? (
                <div className={styles.noSessions}>
                  <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                    <circle cx="12" cy="12" r="10" />
                    <path d="M8 12h8" />
                  </svg>
                  <p>No active sessions found</p>
                  <span>Create a new session to start receiving</span>
                </div>
              ) : (
                <div className={styles.formGroup}>
                  <label className={styles.formLabel}>Active Sessions ({existingSessions.length})</label>
                  <div className={styles.sessionList}>
                    {existingSessions.map((session) => (
                      <button
                        key={session.session_id}
                        type="button"
                        className={`${styles.sessionOption} ${selectedSessionId === session.session_id ? styles.selected : ''}`}
                        onClick={() => setSelectedSessionId(session.session_id)}
                      >
                        <div className={styles.sessionInfo}>
                          <div className={styles.sessionHeader}>
                            <span className={styles.sessionStore}>{session.store_name}</span>
                            <span className={styles.sessionMembers}>
                              <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                                <path d="M12,4A4,4 0 0,1 16,8A4,4 0 0,1 12,12A4,4 0 0,1 8,8A4,4 0 0,1 12,4M12,14C16.42,14 20,15.79 20,18V20H4V18C4,15.79 7.58,14 12,14Z" />
                              </svg>
                              {session.member_count}
                            </span>
                          </div>
                          <div className={styles.sessionMeta}>
                            <span className={styles.sessionCreator}>
                              Created by {session.created_by_name}
                            </span>
                            <span className={styles.sessionTime}>
                              {session.created_at}
                            </span>
                          </div>
                        </div>
                        {selectedSessionId === session.session_id && (
                          <svg className={styles.checkIcon} width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z" />
                          </svg>
                        )}
                      </button>
                    ))}
                  </div>
                </div>
              )}

              {/* Error Message */}
              {sessionsError && (
                <div className={styles.errorMessage}>
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12,2C17.53,2 22,6.47 22,12C22,17.53 17.53,22 12,22C6.47,22 2,17.53 2,12C2,6.47 6.47,2 12,2M15.59,7L12,10.59L8.41,7L7,8.41L10.59,12L7,15.59L8.41,17L12,13.41L15.59,17L17,15.59L13.41,12L17,8.41L15.59,7Z" />
                  </svg>
                  <span>{sessionsError}</span>
                </div>
              )}
            </div>

            {/* Modal Footer */}
            <div className={styles.createSessionFooter}>
              <button
                type="button"
                className={styles.cancelSessionButton}
                onClick={handleCloseJoinSessionModal}
                disabled={isJoiningSession}
              >
                Cancel
              </button>
              <button
                type="button"
                className={styles.joinSessionButton}
                onClick={handleJoinSession}
                disabled={!selectedSessionId || existingSessions.length === 0 || isJoiningSession}
              >
                {isJoiningSession ? (
                  <>
                    <div className={styles.buttonSpinner} />
                    Joining...
                  </>
                ) : (
                  <>
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4" />
                      <polyline points="10 17 15 12 10 7" />
                      <line x1="15" y1="12" x2="3" y2="12" />
                    </svg>
                    Join Session
                  </>
                )}
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default ProductReceivePage;
