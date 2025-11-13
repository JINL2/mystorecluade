import React from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { useAppState } from '@/app/providers/app_state_provider';
import { useStore } from '../../hooks/useStore';
import { useStoreStore } from '../../providers/store_provider';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { useErrorMessage } from '@/shared/hooks/useErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import styles from './StoreSettingPage.module.css';

export const StoreSettingPage: React.FC = () => {
  const { currentCompany } = useAppState();
  const { stores, loading, create, remove } = useStore(currentCompany?.company_id || '');
  const { messageState, closeMessage, showError, showSuccess } = useErrorMessage();

  // Zustand store for modal and form state (2025 Best Practice)
  const {
    showAddModal,
    setShowAddModal,
    showDeleteModal,
    setShowDeleteModal,
    deleteStoreId,
    setDeleteStoreId,
    newName,
    setNewName,
    newAddress,
    setNewAddress,
    newPhone,
    setNewPhone,
    resetForm,
  } = useStoreStore();

  const handleAdd = async () => {
    // 검증 로직은 useStore hook에서 처리됨 (StoreValidator 호출)
    const result = await create(newName, newAddress || null, newPhone || null);
    if (result.success) {
      setShowAddModal(false);
      resetForm(); // Zustand action to reset form state
      showSuccess({
        title: 'Store Created',
        message: `Store "${newName}" has been successfully created.`,
        autoCloseDuration: 3000,
      });
    } else {
      showError({
        title: 'Failed to Create Store',
        message: result.error || 'An unexpected error occurred while creating the store.',
      });
    }
  };

  const handleDeleteClick = (storeId: string) => {
    setDeleteStoreId(storeId);
    setShowDeleteModal(true);
  };

  const handleDeleteConfirm = async () => {
    if (deleteStoreId) {
      const result = await remove(deleteStoreId);
      if (result.success) {
        setShowDeleteModal(false);
        setDeleteStoreId('');
        showSuccess({
          title: 'Store Deleted',
          message: 'The store has been successfully deleted.',
          autoCloseDuration: 3000,
        });
      } else {
        showError({
          title: 'Failed to Delete Store',
          message: result.error || 'An unexpected error occurred while deleting the store.',
        });
      }
    }
  };

  if (loading) {
    return (
      <>
        <Navbar activeItem="setting" />
        <div className={styles.pageContent}>
          <LoadingAnimation size="large" fullscreen />
        </div>
      </>
    );
  }

  if (!currentCompany) {
    return (
      <>
        <Navbar activeItem="setting" />
        <div className={styles.pageContent}>
          <p>Select a company to manage stores</p>
        </div>
      </>
    );
  }

  return (
    <>
      <Navbar activeItem="setting" />
      <main className={styles.pageContent}>
        <div className={styles.pageHeader}>
          <div className={styles.pageHeaderContent}>
            <h1 className={styles.pageTitle}>Store Setting</h1>
            <p className={styles.pageSubtitle}>Manage your store configuration and settings</p>
          </div>
          <button className={styles.addStoreBtn} onClick={() => setShowAddModal(true)}>
            <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
              <path d="M19 13H13V19H11V13H5V11H11V5H13V11H19V13Z"/>
            </svg>
            Add Store
          </button>
        </div>

        <div className={styles.storesContainer}>
          {stores.length === 0 ? (
            <div className={styles.emptyState}>
              <svg className={styles.emptyStateIcon} width="120" height="120" viewBox="0 0 120 120" fill="none">
                {/* Background Circle */}
                <circle cx="60" cy="60" r="50" fill="#F0F6FF"/>

                {/* Store Building */}
                <rect x="35" y="45" width="50" height="45" rx="2" fill="white" stroke="#0064FF" strokeWidth="2"/>

                {/* Store Awning */}
                <path d="M30 45 L35 40 L85 40 L90 45 Z" fill="#0064FF"/>

                {/* Door */}
                <rect x="52" y="65" width="16" height="25" rx="1" fill="#E9ECEF"/>

                {/* Windows */}
                <rect x="40" y="52" width="10" height="8" rx="1" fill="#E9ECEF"/>
                <rect x="70" y="52" width="10" height="8" rx="1" fill="#E9ECEF"/>

                {/* Store Icon Circle */}
                <circle cx="60" cy="25" r="12" fill="#0064FF"/>
                <path d="M56 25 L58 27 L64 21" stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
              </svg>
              <h3 className={styles.emptyStateTitle}>No Stores Yet</h3>
              <p className={styles.emptyStateText}>Click "Add Store" to create your first store location.</p>
            </div>
          ) : (
            <div className={styles.storesGrid}>
              {stores.map((store) => (
                <div key={store.storeId} className={styles.storeCard}>
                  <div className={styles.storeActions}>
                    <button
                      className={`${styles.storeActionBtn} ${styles.delete}`}
                      onClick={() => handleDeleteClick(store.storeId)}
                      title="Delete"
                    >
                      <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
                      </svg>
                    </button>
                  </div>
                  <div className={styles.storeCardHeader}>
                    <h3 className={styles.storeName}>{store.storeName}</h3>
                    {store.address && (
                      <div className={styles.storeDetail}>Address: {store.address}</div>
                    )}
                    {store.phone && (
                      <div className={styles.storeDetail}>Phone: {store.phone}</div>
                    )}
                    {store.huddleTime && (
                      <div className={styles.storeDetail}>Huddle Time: {store.huddleTime} minutes</div>
                    )}
                    {store.paymentTime && (
                      <div className={styles.storeDetail}>Payment Time: {store.paymentTime} minutes</div>
                    )}
                    {store.allowedDistance && (
                      <div className={styles.storeDetail}>Allowed Distance: {store.allowedDistance} meters</div>
                    )}
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </main>

      {/* Add Store Modal */}
      {showAddModal && (
        <div className={styles.modalOverlay} onClick={() => setShowAddModal(false)}>
          <div className={styles.modalContent} onClick={(e) => e.stopPropagation()}>
            <div className={styles.modalHeader}>
              <h2 className={styles.modalTitle}>Add New Store</h2>
              <button className={styles.modalClose} onClick={() => setShowAddModal(false)}>
                <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M19 6.41L17.59 5L12 10.59L6.41 5L5 6.41L10.59 12L5 17.59L6.41 19L12 13.41L17.59 19L19 17.59L13.41 12L19 6.41Z"/>
                </svg>
              </button>
            </div>
            <div className={styles.modalBody}>
              <div className={styles.formGroup}>
                <label className={styles.formLabel}>Store Name <span className={styles.required}>*</span></label>
                <input
                  type="text"
                  className={styles.formInput}
                  placeholder="Enter store name"
                  value={newName}
                  onChange={(e) => setNewName(e.target.value)}
                />
              </div>
              <div className={styles.formGroup}>
                <label className={styles.formLabel}>Store Address <span className={styles.optional}>(Optional)</span></label>
                <input
                  type="text"
                  className={styles.formInput}
                  placeholder="Enter store address"
                  value={newAddress}
                  onChange={(e) => setNewAddress(e.target.value)}
                />
              </div>
              <div className={styles.formGroup}>
                <label className={styles.formLabel}>Store Phone <span className={styles.optional}>(Optional)</span></label>
                <input
                  type="tel"
                  className={styles.formInput}
                  placeholder="Enter phone number"
                  value={newPhone}
                  onChange={(e) => setNewPhone(e.target.value)}
                />
              </div>
            </div>
            <div className={styles.modalFooter}>
              <button className={styles.modalBtnCancel} onClick={() => setShowAddModal(false)}>
                Cancel
              </button>
              <button
                className={styles.modalBtnSave}
                onClick={handleAdd}
                disabled={!newName.trim()}
              >
                Create Store
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Delete Confirmation Modal */}
      {showDeleteModal && (
        <div className={styles.modalOverlay} onClick={() => setShowDeleteModal(false)}>
          <div className={`${styles.modalContent} ${styles.deleteModal}`} onClick={(e) => e.stopPropagation()}>
            <div className={styles.modalHeader}>
              <h2 className={styles.modalTitle}>Delete Store</h2>
              <button className={styles.modalClose} onClick={() => setShowDeleteModal(false)}>
                <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M19 6.41L17.59 5L12 10.59L6.41 5L5 6.41L10.59 12L5 17.59L6.41 19L12 13.41L17.59 19L19 17.59L13.41 12L19 6.41Z"/>
                </svg>
              </button>
            </div>
            <div className={styles.modalBody}>
              <div className={styles.deleteConfirmIcon}>
                <svg width="32" height="32" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
                </svg>
              </div>
              <p className={styles.deleteConfirmTitle}>Are you sure you want to delete this store?</p>
              <p className={styles.deleteConfirmText}>This action cannot be undone. The store will be permanently removed from your system.</p>
            </div>
            <div className={styles.modalFooter}>
              <button className={styles.modalBtnCancel} onClick={() => setShowDeleteModal(false)}>
                Cancel
              </button>
              <button className={styles.modalBtnDelete} onClick={handleDeleteConfirm}>
                Yes, Delete Store
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ErrorMessage Component */}
      <ErrorMessage
        variant={messageState.variant}
        title={messageState.title}
        message={messageState.message}
        isOpen={messageState.isOpen}
        onClose={closeMessage}
        confirmText={messageState.confirmText}
        autoCloseDuration={messageState.autoCloseDuration}
        closeOnBackdropClick={messageState.closeOnBackdropClick}
      />
    </>
  );
};
