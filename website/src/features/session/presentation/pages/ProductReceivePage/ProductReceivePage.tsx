/**
 * ProductReceivePage Component
 * Shows counting and receiving session lists with left sidebar filter
 * Uses inventory_get_session_list RPC for both tabs
 */

import React, { useState, useRef, useEffect } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { LeftFilter } from '@/shared/components/common/LeftFilter';
import type { FilterSection } from '@/shared/components/common/LeftFilter';
import { useCountingSessionList } from '../../hooks/useCountingSessionList';
import { useReceivingSessionList } from '../../hooks/useReceivingSessionList';
import { useProductReceiveList, formatDateDisplay } from '../../hooks/useProductReceiveList';
import { SHIPMENT_STATUS_OPTIONS } from './ProductReceivePage.types';
import {
  CreateSessionModal,
  CreateReceivingSessionModal,
  CountingSessionsTable,
  ReceivingSessionsTable,
  CustomDatePickerModal,
} from './components';
import styles from './ProductReceivePage.module.css';

type TabType = 'counting' | 'receiving';

export const ProductReceivePage: React.FC = () => {
  const [activeTab, setActiveTab] = useState<TabType>('counting');
  const datePickerRef = useRef<HTMLDivElement>(null);

  // Filter state from useProductReceiveList hook
  const {
    suppliers,
    datePreset,
    fromDate,
    toDate,
    showDatePicker,
    tempFromDate,
    tempToDate,
    shipmentStatusFilter,
    supplierFilter,
    supplierOptions,
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
  } = useProductReceiveList();

  // Counting sessions hook
  const {
    sessions: countingSessions,
    sessionsLoading: countingSessionsLoading,
    searchQuery: countingSearchQuery,
    handleSearchChange: handleCountingSearchChange,
    handleSessionClick: handleCountingSessionClick,
    // Create session modal state
    showCreateModal: showCountingCreateModal,
    stores: countingStores,
    selectedStoreId: countingSelectedStoreId,
    sessionName: countingSessionName,
    isCreating: isCreatingCountingSession,
    createError: countingCreateError,
    // Create session modal actions
    handleOpenCreateModal: handleOpenCountingCreateModal,
    handleCloseCreateModal: handleCloseCountingCreateModal,
    setSelectedStoreId: setCountingSelectedStoreId,
    setSessionName: setCountingSessionName,
    handleCreateSession: handleCreateCountingSession,
  } = useCountingSessionList();

  // Receiving sessions hook
  const {
    sessions: receivingSessions,
    sessionsLoading: receivingSessionsLoading,
    searchQuery: receivingSearchQuery,
    handleSearchChange: handleReceivingSearchChange,
    handleSessionClick: handleReceivingSessionClick,
    // Create session modal state
    showCreateModal: showReceivingCreateModal,
    stores: receivingStores,
    shipments: receivingShipments,
    selectedStoreId: receivingSelectedStoreId,
    selectedShipmentId: receivingSelectedShipmentId,
    sessionName: receivingSessionName,
    isCreating: isCreatingReceivingSession,
    createError: receivingCreateError,
    // Create session modal actions
    handleOpenCreateModal: handleOpenReceivingCreateModal,
    handleCloseCreateModal: handleCloseReceivingCreateModal,
    setSelectedStoreId: setReceivingSelectedStoreId,
    setSelectedShipmentId: setReceivingSelectedShipmentId,
    setSessionName: setReceivingSessionName,
    handleCreateSession: handleCreateReceivingSession,
  } = useReceivingSessionList();

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

  // LeftFilter sections configuration
  const filterSections: FilterSection[] = [
    {
      id: 'sessionDate',
      title: 'Session Date',
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
      id: 'sessionStatus',
      title: 'Status',
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
      type: 'multiselect',
      defaultExpanded: false,
      showCount: true,
      options: supplierOptions,
      selectedValues: supplierFilter ? new Set([supplierFilter]) : new Set<string>(),
      onToggle: selectSupplierFilter,
      onClear: clearSupplierFilter,
      emptyMessage: 'No suppliers found',
    },
  ];

  return (
    <>
      <Navbar activeItem="product" />
      <div className={styles.pageLayout}>
        {/* Left Sidebar Filter */}
        <div className={styles.sidebarWrapper}>
          <LeftFilter sections={filterSections} width={240} topOffset={64} />
        </div>

        <div className={styles.mainContent}>
          <div className={styles.container}>
            <div className={styles.header}>
              <h1 className={styles.title}>Sessions</h1>
              <p className={styles.subtitle}>Manage inventory counting and receiving sessions</p>
            </div>

            {/* Tab Navigation */}
            <div className={styles.tabContainer}>
              <button
                className={`${styles.tab} ${activeTab === 'counting' ? styles.active : ''}`}
                onClick={() => setActiveTab('counting')}
              >
                Counting
              </button>
              <button
                className={`${styles.tab} ${activeTab === 'receiving' ? styles.active : ''}`}
                onClick={() => setActiveTab('receiving')}
              >
                Receiving
              </button>
            </div>

            {/* Tab Content */}
            <div className={styles.tabContent}>
              {activeTab === 'counting' && (
                <div className={styles.contentCard}>
                  <div className={styles.receiveHeader}>
                    <div className={styles.receiveTitleSection}>
                      <h2 className={styles.receiveListTitle}>Counting Sessions</h2>
                      <div className={styles.receiveSearchWrapper}>
                        <svg className={styles.searchIcon} width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                          <circle cx="11" cy="11" r="8" />
                          <path d="m21 21-4.35-4.35" />
                        </svg>
                        <input
                          type="text"
                          className={styles.receiveSearch}
                          placeholder="Search counting sessions..."
                          value={countingSearchQuery}
                          onChange={(e) => handleCountingSearchChange(e.target.value)}
                        />
                      </div>
                    </div>
                    <button
                      className={styles.createSessionButton}
                      onClick={handleOpenCountingCreateModal}
                    >
                      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                        <circle cx="12" cy="12" r="10" />
                        <line x1="12" y1="8" x2="12" y2="16" />
                        <line x1="8" y1="12" x2="16" y2="12" />
                      </svg>
                      Create Session
                    </button>
                  </div>

                  <CountingSessionsTable
                    sessions={countingSessions}
                    sessionsLoading={countingSessionsLoading}
                    searchQuery={countingSearchQuery}
                    onSessionClick={handleCountingSessionClick}
                  />
                </div>
              )}

              {activeTab === 'receiving' && (
                <div className={styles.contentCard}>
                  <div className={styles.receiveHeader}>
                    <div className={styles.receiveTitleSection}>
                      <h2 className={styles.receiveListTitle}>Receiving Sessions</h2>
                      <div className={styles.receiveSearchWrapper}>
                        <svg className={styles.searchIcon} width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                          <circle cx="11" cy="11" r="8" />
                          <path d="m21 21-4.35-4.35" />
                        </svg>
                        <input
                          type="text"
                          className={styles.receiveSearch}
                          placeholder="Search receiving sessions..."
                          value={receivingSearchQuery}
                          onChange={(e) => handleReceivingSearchChange(e.target.value)}
                        />
                      </div>
                    </div>
                    <button
                      className={styles.createSessionButton}
                      onClick={handleOpenReceivingCreateModal}
                    >
                      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                        <circle cx="12" cy="12" r="10" />
                        <line x1="12" y1="8" x2="12" y2="16" />
                        <line x1="8" y1="12" x2="16" y2="12" />
                      </svg>
                      Create Session
                    </button>
                  </div>

                  <ReceivingSessionsTable
                    sessions={receivingSessions}
                    sessionsLoading={receivingSessionsLoading}
                    searchQuery={receivingSearchQuery}
                    onSessionClick={handleReceivingSessionClick}
                  />
                </div>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* Custom Date Picker Modal */}
      {showDatePicker && (
        <CustomDatePickerModal
          ref={datePickerRef}
          fromDate={tempFromDate}
          toDate={tempToDate}
          onFromDateChange={setTempFromDate}
          onToDateChange={setTempToDate}
          onToday={handleSetTodayDate}
          onCancel={handleCancelCustomDate}
          onApply={handleApplyCustomDate}
        />
      )}

      {/* Create Counting Session Modal */}
      <CreateSessionModal
        isOpen={showCountingCreateModal}
        stores={countingStores}
        selectedStoreId={countingSelectedStoreId}
        sessionName={countingSessionName}
        isCreating={isCreatingCountingSession}
        error={countingCreateError}
        onSelectStore={setCountingSelectedStoreId}
        onSessionNameChange={setCountingSessionName}
        onClose={handleCloseCountingCreateModal}
        onCreate={handleCreateCountingSession}
      />

      {/* Create Receiving Session Modal */}
      <CreateReceivingSessionModal
        isOpen={showReceivingCreateModal}
        stores={receivingStores}
        shipments={receivingShipments}
        selectedStoreId={receivingSelectedStoreId}
        selectedShipmentId={receivingSelectedShipmentId}
        sessionName={receivingSessionName}
        isCreating={isCreatingReceivingSession}
        error={receivingCreateError}
        onSelectStore={setReceivingSelectedStoreId}
        onSelectShipment={setReceivingSelectedShipmentId}
        onSessionNameChange={setReceivingSessionName}
        onClose={handleCloseReceivingCreateModal}
        onCreate={handleCreateReceivingSession}
      />
    </>
  );
};

export default ProductReceivePage;
