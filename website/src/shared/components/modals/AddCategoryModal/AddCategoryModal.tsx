/**
 * AddCategoryModal Component
 * Modal for creating new categories
 */

import React, { useState, useEffect } from 'react';
import { TossButton } from '@/shared/components/toss/TossButton';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { supabaseService } from '@/core/services/supabase_service';
import type { AddCategoryModalProps, CategoryFormData } from './AddCategoryModal.types';
import styles from './AddCategoryModal.module.css';

export const AddCategoryModal: React.FC<AddCategoryModalProps> = ({
  isOpen,
  onClose,
  companyId,
  categories,
  onCategoryAdded,
}) => {
  const [formData, setFormData] = useState<CategoryFormData>({
    categoryName: '',
    parentCategoryId: '',
  });
  const [errors, setErrors] = useState<Partial<CategoryFormData>>({});
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
        categoryName: '',
        parentCategoryId: '',
      });
      setErrors({});
      setIsSubmitting(false);
      setNotification({ isOpen: false, variant: 'success', message: '' });
    }
  }, [isOpen]);

  const handleInputChange = (field: keyof CategoryFormData, value: string) => {
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
    const newErrors: Partial<CategoryFormData> = {};

    if (!formData.categoryName.trim()) {
      newErrors.categoryName = 'Category name is required';
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
      // Get user timezone
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

      // Call RPC function to create category (v2 with UTC time support)
      const { data, error } = await supabaseService.getClient().rpc('inventory_create_category_v2', {
        p_company_id: companyId,
        p_category_name: formData.categoryName.trim(),
        p_parent_category_id: formData.parentCategoryId || null,
        p_time: new Date().toISOString(),
        p_timezone: userTimezone,
      });

      if (error) {
        console.error('Error creating category:', error);
        setNotification({
          isOpen: true,
          variant: 'error',
          message: error.message || 'Failed to create category. Please try again.',
        });
        setIsSubmitting(false);
        return;
      }

      // Handle v2 response format: { success, data, error }
      const response = data as { success: boolean; data?: any; error?: { code: string; message: string; details?: any } };

      if (!response.success) {
        console.error('Error creating category:', response.error);

        // Check for specific error codes
        if (response.error?.code === 'DUPLICATE_CATEGORY') {
          setNotification({
            isOpen: true,
            variant: 'error',
            message: 'A category with this name already exists at this level',
          });
        } else if (response.error?.code === 'PARENT_NOT_FOUND') {
          setNotification({
            isOpen: true,
            variant: 'error',
            message: 'Parent category not found or inactive',
          });
        } else {
          setNotification({
            isOpen: true,
            variant: 'error',
            message: response.error?.message || 'Failed to create category. Please try again.',
          });
        }

        setIsSubmitting(false);
        return;
      }

      // Success - show notification, call callback, and close modal
      setNotification({
        isOpen: true,
        variant: 'success',
        message: `Category "${formData.categoryName}" has been created successfully!`,
      });

      // Delay to show success message before closing
      setTimeout(() => {
        if (onCategoryAdded && response.data) {
          // Map v2 response to CategoryData format
          const categoryData = {
            category_id: response.data.category_id,
            category_name: response.data.category_name,
            parent_category_id: response.data.parent_category_id || null,
            company_id: companyId,
            description: null,
            created_at: response.data.created_at,
            updated_at: response.data.created_at,
          };
          onCategoryAdded(categoryData);
        }
        onClose();
      }, 1500);
    } catch (err) {
      console.error('Error creating category:', err);
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
            <h2 className={styles.modalTitle}>Add New Category</h2>
            <p className={styles.modalSubtitle}>Create a new category for your inventory</p>
          </div>
          <button className={styles.closeButton} onClick={onClose}>
            <svg width="20" height="20" fill="currentColor" viewBox="0 0 24 24">
              <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
            </svg>
          </button>
        </div>

        {/* Modal Body */}
        <div className={styles.modalBody}>
          {/* Category Name (Required) */}
          <div className={styles.formGroup}>
            <label className={`${styles.label} ${styles.required}`}>Category Name</label>
            <input
              type="text"
              className={`${styles.input} ${errors.categoryName ? styles.error : ''}`}
              placeholder="Enter category name"
              value={formData.categoryName}
              onChange={(e) => handleInputChange('categoryName', e.target.value)}
              maxLength={100}
              autoFocus
            />
            {errors.categoryName && (
              <span className={styles.errorMessage}>{errors.categoryName}</span>
            )}
          </div>

          {/* Parent Category (Optional) */}
          <div className={styles.formGroup}>
            <TossSelector
              label="Parent Category"
              placeholder="Select parent category"
              value={formData.parentCategoryId}
              options={categories.map((cat) => ({
                value: cat.category_id,
                label: cat.category_name,
                description: cat.description,
              }))}
              onChange={(value) => handleInputChange('parentCategoryId', value)}
              fullWidth={true}
            />
            <span className={styles.helperText}>
              Leave empty for top-level category
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
            {isSubmitting ? 'Adding...' : 'Add Category'}
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

export default AddCategoryModal;
