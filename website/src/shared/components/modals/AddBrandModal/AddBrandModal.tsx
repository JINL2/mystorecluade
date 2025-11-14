/**
 * AddBrandModal Component
 * Modal for creating new brands
 */

import React, { useState, useEffect } from 'react';
import { TossButton } from '@/shared/components/toss/TossButton';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { supabaseService } from '@/core/services/supabase_service';
import type { AddBrandModalProps, BrandFormData } from './AddBrandModal.types';
import styles from './AddBrandModal.module.css';

export const AddBrandModal: React.FC<AddBrandModalProps> = ({
  isOpen,
  onClose,
  companyId,
  onBrandAdded,
}) => {
  const [formData, setFormData] = useState<BrandFormData>({
    brandName: '',
    brandCode: '',
  });
  const [errors, setErrors] = useState<Partial<BrandFormData>>({});
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [notification, setNotification] = useState<{
    isOpen: boolean;
    variant: 'success' | 'error';
    message: string;
  }>({
    isOpen: false,
    variant: 'success',
    message: '',
  });

  // Reset form when modal opens
  useEffect(() => {
    if (isOpen) {
      setFormData({
        brandName: '',
        brandCode: '',
      });
      setErrors({});
      setIsSubmitting(false);
      setNotification({ isOpen: false, variant: 'success', message: '' });
    }
  }, [isOpen]);

  const handleInputChange = (field: keyof BrandFormData, value: string) => {
    setFormData((prev) => ({
      ...prev,
      [field]: value,
    }));
    // Clear error when user starts typing
    if (errors[field]) {
      setErrors((prev) => ({
        ...prev,
        [field]: '',
      }));
    }
  };

  const validateForm = (): boolean => {
    const newErrors: Partial<BrandFormData> = {};

    if (!formData.brandName.trim()) {
      newErrors.brandName = 'Brand name is required';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async () => {
    if (!validateForm()) {
      return;
    }

    setIsSubmitting(true);

    try {
      // Call RPC function to create brand
      const { data, error } = await supabaseService.getClient().rpc('inventory_create_brand', {
        p_company_id: companyId,
        p_brand_name: formData.brandName.trim(),
        p_brand_code: formData.brandCode.trim() || null,
      });

      if (error) {
        console.error('Error creating brand:', error);

        // Check for duplicate brand error
        if (error.message && error.message.includes('DUPLICATE_BRAND')) {
          setNotification({
            isOpen: true,
            variant: 'error',
            message: 'A brand with this name already exists',
          });
        } else {
          setNotification({
            isOpen: true,
            variant: 'error',
            message: error.message || 'Failed to create brand. Please try again.',
          });
        }

        setIsSubmitting(false);
        return;
      }

      // Success - show notification, call callback, and close modal
      setNotification({
        isOpen: true,
        variant: 'success',
        message: `Brand "${formData.brandName}" has been created successfully!`,
      });

      // Delay to show success message before closing
      setTimeout(() => {
        if (onBrandAdded && data) {
          onBrandAdded(data);
        }
        onClose();
      }, 1500);
    } catch (err) {
      console.error('Error creating brand:', err);
      setNotification({
        isOpen: true,
        variant: 'error',
        message: err instanceof Error ? err.message : 'An error occurred. Please try again.',
      });
      setIsSubmitting(false);
    }
  };

  const handleOverlayClick = (e: React.MouseEvent<HTMLDivElement>) => {
    if (e.target === e.currentTarget) {
      onClose();
    }
  };

  if (!isOpen) return null;

  return (
    <div className={`${styles.modalOverlay} ${isOpen ? styles.show : ''}`} onClick={handleOverlayClick}>
      <div className={styles.modalContainer}>
        {/* Modal Header */}
        <div className={styles.modalHeader}>
          <div className={styles.modalTitleSection}>
            <h2 className={styles.modalTitle}>Add New Brand</h2>
            <p className={styles.modalSubtitle}>Create a new brand for your inventory</p>
          </div>
          <button className={styles.closeButton} onClick={onClose}>
            <svg width="20" height="20" fill="currentColor" viewBox="0 0 24 24">
              <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
            </svg>
          </button>
        </div>

        {/* Modal Body */}
        <div className={styles.modalBody}>
          {/* Brand Name (Required) */}
          <div className={styles.formGroup}>
            <label className={`${styles.label} ${styles.required}`}>Brand Name</label>
            <input
              type="text"
              className={`${styles.input} ${errors.brandName ? styles.error : ''}`}
              placeholder="Enter brand name"
              value={formData.brandName}
              onChange={(e) => handleInputChange('brandName', e.target.value)}
              maxLength={100}
              autoFocus
            />
            {errors.brandName && (
              <span className={styles.errorMessage}>{errors.brandName}</span>
            )}
          </div>

          {/* Brand Code (Optional) */}
          <div className={styles.formGroup}>
            <label className={styles.label}>Brand Code</label>
            <input
              type="text"
              className={styles.input}
              placeholder="Optional - auto-generated if empty"
              value={formData.brandCode}
              onChange={(e) => handleInputChange('brandCode', e.target.value)}
              maxLength={50}
            />
            <span className={styles.helperText}>
              Leave empty to auto-generate from brand name
            </span>
          </div>
        </div>

        {/* Modal Footer */}
        <div className={styles.modalFooter}>
          <TossButton
            variant="secondary"
            size="md"
            onClick={onClose}
            disabled={isSubmitting}
          >
            Cancel
          </TossButton>
          <TossButton
            variant="primary"
            size="md"
            onClick={handleSubmit}
            disabled={isSubmitting}
          >
            {isSubmitting ? 'Adding...' : 'Add Brand'}
          </TossButton>
        </div>
      </div>

      {/* Notification */}
      <ErrorMessage
        variant={notification.variant}
        message={notification.message}
        isOpen={notification.isOpen}
        onClose={() => setNotification({ ...notification, isOpen: false })}
        autoCloseDuration={notification.variant === 'success' ? 1500 : 0}
        zIndex={10000}
      />
    </div>
  );
};

export default AddBrandModal;
