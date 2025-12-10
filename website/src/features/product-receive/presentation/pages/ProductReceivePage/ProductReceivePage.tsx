/**
 * ProductReceivePage Component
 * Shows shipment list and receiving progress using inventory_get_shipment_list
 * Click on shipment to view detail with inventory_get_shipment_detail
 */

import React, { useRef, useEffect } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { LeftFilter } from '@/shared/components/common/LeftFilter';
import type { FilterSection } from '@/shared/components/common/LeftFilter';
import { SelectorModal } from '@/shared/components/common/SelectorModal';
import type { SelectorOption } from '@/shared/components/common/SelectorModal/SelectorModal.types';
import { useProductReceiveList } from '../../hooks/useProductReceiveList';
import { useReceiveSessionModal } from '../../hooks/useReceiveSessionModal';
import { SHIPMENT_STATUS_OPTIONS } from './ProductReceivePage.types';
import {
  CreateSessionModal,
  JoinSessionModal,
  DateFilterContent,
  CustomDatePickerModal,
  ShipmentsTable,
} from './components';
import styles from './ProductReceivePage.module.css';

export const ProductReceivePage: React.FC = () => {
  const datePickerRef = useRef<HTMLDivElement>(null);

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

  const {
    stores,
    showSessionModal,
    showCreateSessionModal,
    selectedStoreId,
    setSelectedStoreId,
    isCreatingSession,
    createSessionError,
    showJoinSessionModal,
    existingSessions,
    sessionsLoading,
    sessionsError,
    selectedSessionId,
    setSelectedSessionId,
    isJoiningSession,
    handleStartReceive,
    handleSessionSelect,
    handleJoinSession,
    handleCreateSession,
    handleCloseSessionModal,
    handleCloseCreateSessionModal,
    handleCloseJoinSessionModal,
  } = useReceiveSessionModal({ shipmentDetail, shipments });

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
        <DateFilterContent
          datePreset={datePreset}
          fromDate={fromDate}
          toDate={toDate}
          onPresetChange={handlePresetChange}
        />
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

              <ShipmentsTable
                shipments={shipments}
                shipmentsLoading={shipmentsLoading}
                selectedShipmentId={selectedShipmentId}
                shipmentDetail={shipmentDetail}
                detailLoading={detailLoading}
                currency={currency}
                searchQuery={searchQuery}
                onShipmentClick={handleShipmentClick}
                onStartReceive={handleStartReceive}
              />
            </div>
          </div>
        </div>
      </div>

      {/* Custom Date Picker Modal */}
      <CustomDatePickerModal
        isOpen={showDatePicker}
        tempFromDate={tempFromDate}
        tempToDate={tempToDate}
        datePickerRef={datePickerRef as React.RefObject<HTMLDivElement>}
        onFromDateChange={setTempFromDate}
        onToDateChange={setTempToDate}
        onSetToday={handleSetTodayDate}
        onCancel={handleCancelCustomDate}
        onApply={handleApplyCustomDate}
      />

      {/* Session Selection Modal */}
      <SelectorModal
        isOpen={showSessionModal}
        onClose={handleCloseSessionModal}
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
      <CreateSessionModal
        isOpen={showCreateSessionModal}
        stores={stores}
        selectedStoreId={selectedStoreId}
        isCreating={isCreatingSession}
        error={createSessionError}
        onSelectStore={setSelectedStoreId}
        onClose={handleCloseCreateSessionModal}
        onCreate={handleCreateSession}
      />

      {/* Join Session Modal */}
      <JoinSessionModal
        isOpen={showJoinSessionModal}
        sessions={existingSessions}
        selectedSessionId={selectedSessionId}
        isLoading={sessionsLoading}
        isJoining={isJoiningSession}
        error={sessionsError}
        onSelectSession={setSelectedSessionId}
        onClose={handleCloseJoinSessionModal}
        onJoin={handleJoinSession}
      />
    </>
  );
};

export default ProductReceivePage;
