/**
 * ShipmentPage Component
 * Shipments management with left filter sidebar (matching OrderPage structure)
 */

import React, { useRef, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Navbar } from '@/shared/components/common/Navbar';
import { LeftFilter } from '@/shared/components/common/LeftFilter';
import type { FilterSection } from '@/shared/components/common/LeftFilter';
import { useShipmentList, formatDateDisplay } from '../../hooks/useShipmentList';
import { SHIPMENT_STATUS_OPTIONS } from './ShipmentPage.types';
import styles from './ShipmentPage.module.css';

export const ShipmentPage: React.FC = () => {
  const navigate = useNavigate();
  const datePickerRef = useRef<HTMLDivElement>(null);

  const {
    currency,
    suppliers,
    orders,
    shipments,
    shipmentsLoading,
    searchQuery,
    datePreset,
    fromDate,
    toDate,
    showDatePicker,
    tempFromDate,
    tempToDate,
    shipmentStatusFilter,
    supplierFilter,
    orderFilter,
    supplierOptions,
    orderOptions,
    handleSearchChange,
    selectShipmentStatus,
    clearShipmentStatusFilter,
    selectSupplierFilter,
    clearSupplierFilter,
    selectOrderFilter,
    clearOrderFilter,
    handlePresetChange,
    handleApplyCustomDate,
    handleCancelCustomDate,
    handleSetTodayDate,
    setTempFromDate,
    setTempToDate,
  } = useShipmentList();

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
      id: 'shipmentDate',
      title: 'Shipment Date',
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
    {
      id: 'order',
      title: 'Linked Order',
      type: 'radio',
      defaultExpanded: true,
      options: orderOptions,
      selectedValues: orderFilter || '',
      onSelect: selectOrderFilter,
      onClear: clearOrderFilter,
    },
  ];

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
              <h1 className={styles.title}>Shipments</h1>
              <p className={styles.subtitle}>Manage and track shipments</p>
            </div>

            <div className={styles.contentCard}>
              <div className={styles.shipmentHeader}>
                <div className={styles.shipmentTitleSection}>
                  <h2 className={styles.shipmentListTitle}>Shipments</h2>
                  <div className={styles.shipmentSearchWrapper}>
                    <svg className={styles.searchIcon} width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <circle cx="11" cy="11" r="8" />
                      <path d="m21 21-4.35-4.35" />
                    </svg>
                    <input
                      type="text"
                      className={styles.shipmentSearch}
                      placeholder="Search shipments..."
                      value={searchQuery}
                      onChange={(e) => handleSearchChange(e.target.value)}
                    />
                  </div>
                </div>
                <div className={styles.shipmentActions}>
                  <button
                    className={styles.primaryButton}
                    onClick={() => navigate('/product/shipment/create', { state: { currency, suppliers, orders } })}
                  >
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <line x1="12" y1="5" x2="12" y2="19" />
                      <line x1="5" y1="12" x2="19" y2="12" />
                    </svg>
                    New Shipment
                  </button>
                </div>
              </div>

              <div className={styles.tableContainer}>
                <table className={styles.shipmentsTable}>
                  <thead>
                    <tr>
                      <th>Shipment #</th>
                      <th>Shipped Date</th>
                      <th>Supplier</th>
                      <th>Items</th>
                      <th>Linked Orders</th>
                      <th>Status</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    {shipmentsLoading ? (
                      <tr>
                        <td colSpan={7}>
                          <div className={styles.loadingState}>
                            <div className={styles.spinner} />
                            <p>Loading shipments...</p>
                          </div>
                        </td>
                      </tr>
                    ) : shipments.length > 0 ? (
                      shipments.map((shipment) => (
                        <tr key={shipment.shipment_id}>
                          <td>
                            <span className={styles.shipmentNumber}>{shipment.shipment_number}</span>
                          </td>
                          <td>{formatDateDisplay(shipment.shipped_date?.split(' ')[0] || '')}</td>
                          <td>
                            <span className={styles.supplierName}>{shipment.supplier_name}</span>
                          </td>
                          <td>
                            <span className={styles.itemCount}>{shipment.item_count}</span>
                          </td>
                          <td>
                            {shipment.linked_order_count > 0 ? (
                              <span className={styles.linkedOrder}>{shipment.linked_order_count}</span>
                            ) : (
                              <span className={styles.noLink}>-</span>
                            )}
                          </td>
                          <td>
                            <span className={`${styles.statusBadge} ${styles[shipment.status]}`}>
                              {shipment.status}
                            </span>
                          </td>
                          <td>
                            <button
                              className={styles.viewButton}
                              onClick={() => navigate(`/product/shipment/${shipment.shipment_id}`)}
                            >
                              View
                            </button>
                          </td>
                        </tr>
                      ))
                    ) : (
                      <tr>
                        <td colSpan={7}>
                          <div className={styles.emptyState}>
                            <svg className={styles.emptyIcon} width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1">
                              <path d="M16 16h.01" />
                              <path d="M8 16h.01" />
                              <path d="M12 12h.01" />
                              <path d="M21 10V8a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-2" />
                              <path d="M14 7h7" />
                              <path d="M14 10h4" />
                            </svg>
                            <p className={styles.emptyTitle}>No shipments found</p>
                            <p className={styles.emptyDescription}>
                              {searchQuery ? 'Try adjusting your search or filters' : 'Create your first shipment'}
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
    </>
  );
};

export default ShipmentPage;
