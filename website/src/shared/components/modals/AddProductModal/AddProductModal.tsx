/**
 * AddProductModal Component
 * Modal for creating new products
 */

import React, { useState, useEffect } from 'react';
import { TossButton } from '@/shared/components/toss/TossButton';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import { TossInput } from '@/shared/components/toss/TossInput';
import { AddBrandModal } from '@/shared/components/modals/AddBrandModal';
import { AddCategoryModal } from '@/shared/components/modals/AddCategoryModal';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { supabaseService } from '@/core/services/supabase_service';
import type { AddProductModalProps, ProductFormData } from './AddProductModal.types';
import styles from './AddProductModal.module.css';

export const AddProductModal: React.FC<AddProductModalProps> = ({
  isOpen,
  onClose,
  companyId,
  storeId,
  metadata,
  onProductAdded,
  onMetadataRefresh,
}) => {
  const [formData, setFormData] = useState<ProductFormData>({
    productName: '',
    sku: '',
    barcode: '',
    categoryId: '',
    brandId: '',
    unit: '',
    costPrice: '',
    sellingPrice: '',
    initialQuantity: '0',
    imageUrl: '',
    thumbnailUrl: '',
  });

  const [errors, setErrors] = useState<Partial<ProductFormData>>({});
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

  const [isAddBrandModalOpen, setIsAddBrandModalOpen] = useState(false);
  const [isAddCategoryModalOpen, setIsAddCategoryModalOpen] = useState(false);

  // Reset form when modal opens
  useEffect(() => {
    if (isOpen) {
      console.log('🔍 AddProductModal opened');
      console.log('  - Categories:', metadata?.categories?.length || 0);
      console.log('  - Brands:', metadata?.brands?.length || 0);
      console.log('  - Units:', metadata?.units?.length || 0);
      console.log('  - Units data:', JSON.stringify(metadata?.units, null, 2));
      setFormData({
        productName: '',
        sku: '',
        barcode: '',
        categoryId: '',
        brandId: '',
        unit: '',
        costPrice: '',
        sellingPrice: '',
        initialQuantity: '0',
        imageUrl: '',
        thumbnailUrl: '',
      });
      setErrors({});
      setIsSubmitting(false);
      setNotification({ isOpen: false, variant: 'success', message: '' });
    }
  }, [isOpen, metadata]);

  const handleInputChange = (field: keyof ProductFormData, value: string) => {
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
    const newErrors: Partial<ProductFormData> = {};

    if (!formData.productName.trim()) {
      newErrors.productName = 'Product name is required';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  // Check if form is valid for submit button state
  const isFormValid = formData.productName.trim().length > 0;

  const handleSubmit = async () => {
    if (!validateForm()) {
      return;
    }

    setIsSubmitting(true);

    try {
      // Build RPC parameters - RPC가 SKU/Barcode를 자동 생성
      const rpcParams: any = {
        p_company_id: companyId,
        p_product_name: formData.productName.trim(),
        p_store_id: storeId || null,
        p_sku: formData.sku.trim() || null, // null이면 RPC가 'SKU-001' 형식으로 자동 생성
        p_barcode: formData.barcode.trim() || null, // null이면 RPC가 '88xxxxxxxxxx' 형식으로 자동 생성
        p_category_id: formData.categoryId || null,
        p_brand_id: formData.brandId || null,
        p_unit: formData.unit || null,
        p_cost_price: formData.costPrice && parseFloat(formData.costPrice) > 0 ? parseFloat(formData.costPrice) : null,
        p_selling_price: formData.sellingPrice && parseFloat(formData.sellingPrice) > 0 ? parseFloat(formData.sellingPrice) : null,
        p_initial_quantity: formData.initialQuantity && parseFloat(formData.initialQuantity) > 0 ? parseFloat(formData.initialQuantity) : null,
        p_image_url: formData.imageUrl.trim() || null,
        p_thumbnail_url: formData.thumbnailUrl.trim() || null,
      }

      // Log RPC parameters for debugging
      console.log('Creating product with parameters:', rpcParams);
      console.log('  - p_sku type:', typeof rpcParams.p_sku, '| value:', rpcParams.p_sku, '| is null:', rpcParams.p_sku === null);
      console.log('  - p_barcode type:', typeof rpcParams.p_barcode, '| value:', rpcParams.p_barcode, '| is null:', rpcParams.p_barcode === null);
      console.log('  - categoryId type:', typeof rpcParams.p_category_id, '| value:', rpcParams.p_category_id);
      console.log('  - brandId type:', typeof rpcParams.p_brand_id, '| value:', rpcParams.p_brand_id);

      // Call RPC function to create product (Flutter 앱처럼 .single() 사용)
      const { data, error } = await supabaseService.getClient().rpc('inventory_create_product', rpcParams).single();

      console.log('🔍 RPC Response:', { data, error });
      console.log('🔍 Full data:', JSON.stringify(data, null, 2));

      if (error) {
        console.error('❌ Error creating product:', error);
        console.error('   Error details:', JSON.stringify(error, null, 2));

        // Handle specific error codes
        let errorMessage = 'Failed to create product';
        if (error.code === 'DUPLICATE_SKU' || error.message?.includes('DUPLICATE_SKU')) {
          errorMessage = 'This SKU already exists. Please use a different SKU.';
        } else if (error.code === 'DUPLICATE_BARCODE' || error.message?.includes('DUPLICATE_BARCODE')) {
          errorMessage = 'This barcode already exists. Please use a different barcode.';
        } else if (error.code === 'FOREIGN_KEY_ERROR' || error.message?.includes('FOREIGN_KEY')) {
          errorMessage = 'Invalid category or brand selected.';
        } else if (error.message) {
          errorMessage = error.message;
        }

        setNotification({
          isOpen: true,
          variant: 'error',
          message: errorMessage,
        });

        setIsSubmitting(false);
        return;
      }

      // Check if RPC actually succeeded
      if (!data) {
        console.error('❌ RPC returned no data');
        setNotification({
          isOpen: true,
          variant: 'error',
          message: 'Failed to create product: No data returned from server',
        });
        setIsSubmitting(false);
        return;
      }

      // Check for success wrapper (like Flutter app expects)
      if (data.success === false) {
        console.error('❌ RPC returned success: false', data);

        // Handle specific error codes from RPC response
        let errorMsg = 'Failed to create product';

        if (data.code === 'DUPLICATE_SKU' || data.details?.includes('inventory_products_company_id_sku_key')) {
          errorMsg = 'This SKU already exists. Please use a different SKU or leave it empty to auto-generate.';
        } else if (data.code === 'DUPLICATE_BARCODE' || data.details?.includes('barcode')) {
          errorMsg = 'This barcode already exists. Please use a different barcode.';
        } else if (data.code === 'FOREIGN_KEY_ERROR' || data.details?.includes('foreign key')) {
          errorMsg = 'Invalid category or brand selected.';
        } else {
          errorMsg = data.error || data.message || 'Failed to create product';
          if (data.details) {
            errorMsg += ` (${data.details})`;
          }
        }

        setNotification({
          isOpen: true,
          variant: 'error',
          message: errorMsg,
        });
        setIsSubmitting(false);
        return;
      }

      // Extract product data from response
      const productData = data?.data || data;
      console.log('✅ Product created successfully:', productData);
      console.log('✅ Product data type:', typeof productData);
      console.log('✅ Product data keys:', productData ? Object.keys(productData) : 'null');

      // Build success message with auto-generated info
      let successMessage = `Product "${formData.productName}" has been created successfully!`;
      const autoGenerated = [];

      // Show SKU if it was auto-generated (user didn't provide one)
      if (!formData.sku.trim() && productData?.sku) {
        autoGenerated.push(`SKU: ${productData.sku}`);
      }

      // Show Barcode if it was auto-generated
      if (!formData.barcode.trim() && productData?.barcode) {
        autoGenerated.push(`Barcode: ${productData.barcode}`);
      }

      if (autoGenerated.length > 0) {
        successMessage += ` (Auto-generated: ${autoGenerated.join(', ')})`;
      }

      // Success - show notification, call callback, and close modal
      setNotification({
        isOpen: true,
        variant: 'success',
        message: successMessage,
      });

      // Delay to show success message before closing
      setTimeout(() => {
        if (onProductAdded && productData) {
          onProductAdded(productData);
        }
        onClose();
      }, 1500);
    } catch (err) {
      console.error('Error creating product:', err);
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

  const currencySymbol = metadata?.currency?.symbol || '$';

  return (
    <div className={`${styles.modalOverlay} ${isOpen ? styles.show : ''}`} onClick={handleOverlayClick}>
      <div className={`${styles.modalContainer} ${styles.modalLg}`}>
        {/* Modal Header */}
        <div className={styles.modalHeader}>
          <div className={styles.modalTitleSection}>
            <h2 className={styles.modalTitle}>Add New Product</h2>
            <p className={styles.modalSubtitle}>Enter product details to add to your inventory</p>
          </div>
          <button className={styles.closeButton} onClick={onClose}>
            <svg width="20" height="20" fill="currentColor" viewBox="0 0 24 24">
              <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
            </svg>
          </button>
        </div>

        {/* Modal Body */}
        <div className={styles.modalBody}>
          <div className={styles.formGrid}>
            {/* Product Name (Required) */}
            <div className={`${styles.formGroup} ${styles.formGroupFull}`}>
              <label className={`${styles.label} ${styles.required}`}>Product Name</label>
              <input
                type="text"
                className={`${styles.input} ${errors.productName ? styles.error : ''}`}
                placeholder="Enter product name"
                value={formData.productName}
                onChange={(e) => handleInputChange('productName', e.target.value)}
                maxLength={200}
                autoFocus
              />
              {errors.productName && (
                <span className={styles.errorMessage}>{errors.productName}</span>
              )}
            </div>

            {/* SKU (Auto-generated if empty) */}
            <div className={styles.formGroup}>
              <label className={styles.label}>SKU</label>
              <input
                type="text"
                className={styles.input}
                placeholder="Leave empty to auto-generate"
                value={formData.sku}
                onChange={(e) => handleInputChange('sku', e.target.value)}
                maxLength={50}
              />
              <span className={styles.helperText}>Will be auto-generated if left empty</span>
            </div>

            {/* Barcode (Auto-generated if empty) */}
            <div className={styles.formGroup}>
              <label className={styles.label}>Barcode</label>
              <input
                type="text"
                className={styles.input}
                placeholder="Leave empty to auto-generate"
                value={formData.barcode}
                onChange={(e) => handleInputChange('barcode', e.target.value)}
                maxLength={50}
              />
              <span className={styles.helperText}>Will be auto-generated if left empty</span>
            </div>

            {/* Category Selection (Optional) */}
            <div className={styles.formGroup}>
              <TossSelector
                label="Category"
                placeholder="Select category"
                value={formData.categoryId}
                options={metadata?.categories.map((cat) => ({
                  value: cat.category_id,
                  label: cat.category_name,
                  description: cat.description,
                })) || []}
                onChange={(value) => handleInputChange('categoryId', value)}
                showAddButton={true}
                addButtonText="Add category"
                onAddClick={() => setIsAddCategoryModalOpen(true)}
                showDescriptions={true}
                fullWidth={true}
              />
            </div>

            {/* Brand Selection (Optional) */}
            <div className={styles.formGroup}>
              <TossSelector
                label="Brand"
                placeholder="Select brand"
                value={formData.brandId}
                options={metadata?.brands.map((brand) => ({
                  value: brand.brand_id,
                  label: brand.brand_name,
                  description: brand.description,
                })) || []}
                onChange={(value) => handleInputChange('brandId', value)}
                showAddButton={true}
                addButtonText="Add brand"
                onAddClick={() => setIsAddBrandModalOpen(true)}
                showDescriptions={true}
                fullWidth={true}
              />
            </div>

            {/* Cost Price (Optional) */}
            <div className={styles.formGroup}>
              <label className={styles.label}>Cost Price</label>
              <div className={styles.inputWrapper}>
                <span className={styles.inputPrefix}>{currencySymbol}</span>
                <input
                  type="number"
                  className={`${styles.input} ${styles.withPrefix}`}
                  placeholder="0"
                  value={formData.costPrice}
                  onChange={(e) => handleInputChange('costPrice', e.target.value)}
                  min="0"
                  step="0.01"
                  max="999999999"
                />
              </div>
            </div>

            {/* Selling Price (Optional) */}
            <div className={styles.formGroup}>
              <label className={styles.label}>Selling Price</label>
              <div className={styles.inputWrapper}>
                <span className={styles.inputPrefix}>{currencySymbol}</span>
                <input
                  type="number"
                  className={`${styles.input} ${styles.withPrefix}`}
                  placeholder="0"
                  value={formData.sellingPrice}
                  onChange={(e) => handleInputChange('sellingPrice', e.target.value)}
                  min="0"
                  step="0.01"
                  max="999999999"
                />
              </div>
            </div>

            {/* Unit (Optional) */}
            <div className={styles.formGroup}>
              <TossSelector
                label="Unit"
                placeholder="Select unit"
                value={formData.unit}
                options={[
                  { value: 'piece', label: 'Piece' },
                  { value: 'kg', label: 'Kilogram (kg)' },
                  { value: 'g', label: 'Gram (g)' },
                  { value: 'l', label: 'Liter (l)' },
                  { value: 'ml', label: 'Milliliter (ml)' },
                  { value: 'box', label: 'Box' },
                ]}
                onChange={(value) => handleInputChange('unit', value)}
                fullWidth={true}
              />
            </div>

            {/* Initial Quantity (Optional) */}
            <div className={styles.formGroup}>
              <label className={styles.label}>Initial Quantity</label>
              <input
                type="number"
                className={styles.input}
                placeholder="0"
                value={formData.initialQuantity}
                onChange={(e) => handleInputChange('initialQuantity', e.target.value)}
                min="0"
                max="999999999"
              />
            </div>
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
            disabled={isSubmitting || !isFormValid}
          >
            {isSubmitting ? 'Creating...' : 'Create Product'}
          </TossButton>
        </div>
      </div>

      {/* Add Brand Modal */}
      <AddBrandModal
        isOpen={isAddBrandModalOpen}
        onClose={() => setIsAddBrandModalOpen(false)}
        companyId={companyId}
        onBrandAdded={(brand) => {
          // Auto-select newly created brand
          handleInputChange('brandId', brand.brand_id);
          // Refresh metadata to update the list
          if (onMetadataRefresh) {
            onMetadataRefresh();
          }
        }}
      />

      {/* Add Category Modal */}
      <AddCategoryModal
        isOpen={isAddCategoryModalOpen}
        onClose={() => setIsAddCategoryModalOpen(false)}
        companyId={companyId}
        categories={metadata?.categories || []}
        onCategoryAdded={(category) => {
          // Auto-select newly created category
          handleInputChange('categoryId', category.category_id);
          // Refresh metadata to update the list
          if (onMetadataRefresh) {
            onMetadataRefresh();
          }
        }}
      />

      {/* Notification */}
      <ErrorMessage
        variant={notification.variant}
        message={notification.message}
        isOpen={notification.isOpen}
        onClose={() => setNotification({ ...notification, isOpen: false })}
        autoCloseDuration={notification.variant === 'success' ? 1500 : 0}
        position="top-center"
        showBackdrop={false}
        zIndex={10000}
      />
    </div>
  );
};

export default AddProductModal;
