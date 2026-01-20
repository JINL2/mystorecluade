/**
 * AddAttributeModal Component
 * Modal for creating new attributes with options
 */

import React, { useState, useEffect } from 'react';
import { TossButton } from '@/shared/components/toss/TossButton';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { supabaseService } from '@/core/services/supabase_service';
import type { AddAttributeModalProps, AttributeFormData, AttributeOption, AttributeResponse } from './AddAttributeModal.types';
import styles from './AddAttributeModal.module.css';

export const AddAttributeModal: React.FC<AddAttributeModalProps> = ({
  isOpen,
  onClose,
  companyId,
  onAttributeAdded,
}) => {
  const [formData, setFormData] = useState<AttributeFormData>({
    attributeName: '',
    options: [{ option_value: '', sort_order: 1 }],
  });
  const [errors, setErrors] = useState<{ attributeName?: string; options?: string }>({});
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
        attributeName: '',
        options: [{ option_value: '', sort_order: 1 }],
      });
      setErrors({});
      setIsSubmitting(false);
      setNotification({ isOpen: false, variant: 'success', message: '' });
    }
  }, [isOpen]);

  const handleAttributeNameChange = (value: string) => {
    setFormData((prev) => ({
      ...prev,
      attributeName: value,
    }));
    if (errors.attributeName) {
      setErrors((prev) => ({ ...prev, attributeName: '' }));
    }
  };

  const handleOptionChange = (index: number, value: string) => {
    setFormData((prev) => {
      const newOptions = [...prev.options];
      newOptions[index] = { ...newOptions[index], option_value: value };
      return { ...prev, options: newOptions };
    });
    if (errors.options) {
      setErrors((prev) => ({ ...prev, options: '' }));
    }
  };

  const addOption = () => {
    setFormData((prev) => ({
      ...prev,
      options: [...prev.options, { option_value: '', sort_order: prev.options.length + 1 }],
    }));
  };

  const removeOption = (index: number) => {
    if (formData.options.length <= 1) return;
    setFormData((prev) => {
      const newOptions = prev.options.filter((_, i) => i !== index);
      // Re-calculate sort_order
      return {
        ...prev,
        options: newOptions.map((opt, i) => ({ ...opt, sort_order: i + 1 })),
      };
    });
  };

  const validateForm = (): boolean => {
    const newErrors: { attributeName?: string; options?: string } = {};

    if (!formData.attributeName.trim()) {
      newErrors.attributeName = 'Attribute name is required';
    }

    // Check if at least one option has a value
    const validOptions = formData.options.filter((opt) => opt.option_value.trim());
    if (validOptions.length === 0) {
      newErrors.options = 'At least one option is required';
    }

    // Check for duplicate option values
    const optionValues = validOptions.map((opt) => opt.option_value.trim().toLowerCase());
    const hasDuplicates = optionValues.length !== new Set(optionValues).size;
    if (hasDuplicates) {
      newErrors.options = 'Option values must be unique';
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
      // Filter out empty options and prepare for RPC
      const validOptions = formData.options
        .filter((opt) => opt.option_value.trim())
        .map((opt, index) => ({
          option_value: opt.option_value.trim(),
          sort_order: index + 1,
        }));

      // Call RPC function to create attribute and options
      const { data, error } = await supabaseService.getClient().rpc('inventory_create_attribute_and_option', {
        p_company_id: companyId,
        p_attribute_name: formData.attributeName.trim(),
        p_options: validOptions.length > 0 ? validOptions : null,
      });

      if (error) {
        console.error('Error creating attribute:', error);
        setNotification({
          isOpen: true,
          variant: 'error',
          message: error.message || 'Failed to create attribute. Please try again.',
        });
        setIsSubmitting(false);
        return;
      }

      const response = data as AttributeResponse;

      if (!response.success) {
        // Handle specific errors from RPC
        let errorMessage = response.message || 'Failed to create attribute';
        if (response.error === 'DUPLICATE_ATTRIBUTE_NAME') {
          errorMessage = `Attribute "${formData.attributeName}" already exists`;
        } else if (response.error === 'DUPLICATE_OPTION_VALUE') {
          errorMessage = response.message || 'Duplicate option values found';
        }

        setNotification({
          isOpen: true,
          variant: 'error',
          message: errorMessage,
        });
        setIsSubmitting(false);
        return;
      }

      // Success
      setNotification({
        isOpen: true,
        variant: 'success',
        message: `Attribute "${formData.attributeName}" created with ${response.options_created || 0} option(s)!`,
      });

      // Delay to show success message before closing
      setTimeout(() => {
        if (onAttributeAdded) {
          onAttributeAdded();
        }
        onClose();
      }, 1500);
    } catch (err) {
      console.error('Error creating attribute:', err);
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
            <h2 className={styles.modalTitle}>Add New Attribute</h2>
            <p className={styles.modalSubtitle}>Create a new attribute with options (e.g., Size: S, M, L)</p>
          </div>
          <button className={styles.closeButton} onClick={onClose}>
            <svg width="20" height="20" fill="currentColor" viewBox="0 0 24 24">
              <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
            </svg>
          </button>
        </div>

        {/* Modal Body */}
        <div className={styles.modalBody}>
          {/* Attribute Name (Required) */}
          <div className={styles.formGroup}>
            <label className={`${styles.label} ${styles.required}`}>Attribute Name</label>
            <input
              type="text"
              className={`${styles.input} ${errors.attributeName ? styles.error : ''}`}
              placeholder="e.g., Size, Color, Material"
              value={formData.attributeName}
              onChange={(e) => handleAttributeNameChange(e.target.value)}
              maxLength={100}
              autoFocus
            />
            {errors.attributeName && (
              <span className={styles.errorMessage}>{errors.attributeName}</span>
            )}
          </div>

          {/* Options Section */}
          <div className={styles.optionsSection}>
            <div className={styles.optionsHeader}>
              <span className={styles.optionsLabel}>Options</span>
              <button
                type="button"
                className={styles.addOptionButton}
                onClick={addOption}
              >
                <svg width="14" height="14" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
                </svg>
                Add
              </button>
            </div>

            <div className={styles.optionsList}>
              {formData.options.map((option, index) => (
                <div key={index} className={styles.optionItem}>
                  <span className={styles.optionNumber}>{index + 1}</span>
                  <input
                    type="text"
                    className={styles.optionInput}
                    placeholder={`Option ${index + 1} (e.g., ${index === 0 ? 'S' : index === 1 ? 'M' : 'L'})`}
                    value={option.option_value}
                    onChange={(e) => handleOptionChange(index, e.target.value)}
                    maxLength={50}
                  />
                  {formData.options.length > 1 && (
                    <button
                      type="button"
                      className={styles.removeOptionButton}
                      onClick={() => removeOption(index)}
                    >
                      <svg width="14" height="14" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M19 13H5v-2h14v2z"/>
                      </svg>
                    </button>
                  )}
                </div>
              ))}
            </div>

            {errors.options && (
              <span className={styles.errorMessage}>{errors.options}</span>
            )}

            <span className={styles.helperText}>
              Add option values for this attribute. Options will be displayed in the order listed.
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
            {isSubmitting ? 'Creating...' : 'Create Attribute'}
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

export default AddAttributeModal;
