/**
 * ProductDetailsModal Component
 * Modal for viewing and editing product information
 */

import React, { useState, useEffect, useRef } from 'react';
import { TossButton } from '@/shared/components/toss/TossButton';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import { AddBrandModal } from '@/shared/components/modals/AddBrandModal';
import { AddCategoryModal } from '@/shared/components/modals/AddCategoryModal';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { supabaseService, storageService } from '@/core/services/supabase_service';
import { compressImage, formatFileSize, validateImageFile } from '@/core/utils/image-utils';
import type { TossSelectorOption } from '@/shared/components/selectors/TossSelector';
import type { ProductDetailsModalProps } from './ProductDetailsModal.types';
import type { CompressedImageResult } from '@/core/utils/image-utils';
import styles from './ProductDetailsModal.module.css';

export const ProductDetailsModal: React.FC<ProductDetailsModalProps> = ({
  isOpen,
  onClose,
  productId,
  companyId,
  productData,
  metadata,
  onSave,
  onMetadataRefresh,
}) => {
  const [formData, setFormData] = useState({
    productName: '',
    category: '',
    brand: '',
    productType: 'Physical Product',
    barcode: '',
    sku: '',
    currentStock: '' as string | number,
    unit: '',
    costPrice: '' as string | number,
    sellingPrice: '' as string | number,
  });

  const [isAddBrandModalOpen, setIsAddBrandModalOpen] = useState(false);
  const [isAddCategoryModalOpen, setIsAddCategoryModalOpen] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Image upload state (최대 3개)
  const [imagePreviews, setImagePreviews] = useState<string[]>([]);
  const [compressionInfos, setCompressionInfos] = useState<CompressedImageResult[]>([]);
  const [isCompressing, setIsCompressing] = useState(false);
  const [notification, setNotification] = useState<{
    isOpen: boolean;
    variant: 'success' | 'error';
    message: string;
  }>({
    isOpen: false,
    variant: 'success',
    message: '',
  });
  const fileInputRef = useRef<HTMLInputElement>(null);
  const MAX_IMAGES = 3;

  useEffect(() => {
    if (productData) {
      setFormData({
        productName: productData.productName || '',
        category: productData.categoryId || '', // Use categoryId instead of category
        brand: productData.brandId || '',       // Use brandId instead of brand
        productType: productData.productType || 'commodity',
        barcode: productData.barcode || '',
        sku: productData.sku || productData.productCode || '', // Use sku or productCode
        currentStock: productData.currentStock?.toString() || '',
        unit: productData.unit || '',
        costPrice: productData.costPrice?.toString() || '',
        sellingPrice: productData.unitPrice?.toString() || '', // Use unitPrice as sellingPrice
      });

      // Load existing product images
      if (productData.imageUrls && Array.isArray(productData.imageUrls)) {
        setImagePreviews(productData.imageUrls);
      } else {
        setImagePreviews([]);
      }
      setCompressionInfos([]);
    }
  }, [productData]);

  const handleInputChange = (field: string, value: string | number) => {
    setFormData((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

  // Handle image file selection
  const handleImageSelect = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (!file) return;

    // Reset file input
    event.target.value = '';

    // Check max images limit
    if (imagePreviews.length >= MAX_IMAGES) {
      setNotification({
        isOpen: true,
        variant: 'error',
        message: `Maximum ${MAX_IMAGES} images allowed`,
      });
      return;
    }

    // Validate image file
    const validation = validateImageFile(file, {
      maxSize: 5 * 1024 * 1024, // 5MB
      allowedTypes: ['image/jpeg', 'image/png', 'image/webp'],
    });

    if (!validation.valid) {
      setNotification({
        isOpen: true,
        variant: 'error',
        message: validation.error || 'Invalid image file',
      });
      return;
    }

    try {
      setIsCompressing(true);

      // Compress image to 80% quality
      const result = await compressImage(file, {
        quality: 80,
        maxWidth: 2000,
        maxHeight: 2000,
      });

      // Add to previews and compression info arrays
      setImagePreviews(prev => [...prev, result.dataUrl]);
      setCompressionInfos(prev => [...prev, result]);

      console.log('✅ Image compressed:', {
        original: formatFileSize(result.originalSize),
        compressed: formatFileSize(result.compressedSize),
        ratio: `${Math.round(result.compressionRatio * 100)}%`,
      });
    } catch (error) {
      console.error('❌ Image compression error:', error);
      setNotification({
        isOpen: true,
        variant: 'error',
        message: error instanceof Error ? error.message : 'Failed to process image',
      });
    } finally {
      setIsCompressing(false);
    }
  };

  // Handle image removal by index
  const handleRemoveImage = (index: number) => {
    setImagePreviews(prev => prev.filter((_, i) => i !== index));
    setCompressionInfos(prev => prev.filter((_, i) => i !== index));
  };

  // Trigger file input click
  const handleImageClick = () => {
    fileInputRef.current?.click();
  };

  const handleSave = async () => {
    setIsSubmitting(true);

    try {
      console.log('🔍 Step 1: Validating product data...');

      // Step 1: Validate using inventory_check_edit RPC
      const validationParams: any = {
        p_product_id: productId,
        p_company_id: companyId,
        p_product_name: formData.productName.trim() || null,
        p_sku: formData.sku.trim() || null,
      };

      console.log('Validation params:', validationParams);

      const { data: validationData, error: validationError } = await supabaseService
        .getClient()
        .rpc('inventory_check_edit', validationParams)
        .single();

      console.log('🔍 Validation result:', { validationData, validationError });

      if (validationError) {
        console.error('❌ Validation RPC error:', validationError);
        setNotification({
          isOpen: true,
          variant: 'error',
          message: `Validation failed: ${validationError.message}`,
        });
        setIsSubmitting(false);
        return;
      }

      // Check validation result
      const validation = validationData as any;
      if (!validation.success) {
        console.error('❌ Validation failed:', validation);

        // Show error message using ErrorMessage component
        const errorMessages: { [key: string]: string } = {
          'PRODUCT_NOT_FOUND': 'Product not found or access denied',
          'PRODUCT_NAME_DUPLICATE': 'Product name already exists for another product in this company',
          'SKU_DUPLICATE': 'SKU already exists for another product',
          'VALIDATION_ERROR': `Validation error: ${validation.error?.details || validation.error?.message}`,
        };

        const errorMessage = errorMessages[validation.error?.code] || validation.error?.message || 'Validation failed';

        setNotification({
          isOpen: true,
          variant: 'error',
          message: errorMessage,
        });
        setIsSubmitting(false);
        return;
      }

      console.log('✅ Validation passed:', validation);

      // Step 2: Upload new images to Storage and keep existing URLs
      console.log('📤 Step 2: Processing images...');
      const imageUrls: string[] = [];

      // Keep track of which images are new (from compressionInfos) vs existing URLs
      for (let i = 0; i < imagePreviews.length; i++) {
        const imagePreview = imagePreviews[i];

        // Check if this is a new image (has compression info) or existing URL
        if (compressionInfos[i]) {
          // This is a new image - upload it
          const compressionInfo = compressionInfos[i];

          // Generate unique filename
          const timestamp = Date.now();
          const randomId = Math.random().toString(36).substring(2, 9);
          const extension = compressionInfo.format.split('/')[1]; // e.g., 'jpeg'
          const filename = `product_${timestamp}_${randomId}_${i}.${extension}`;
          const filePath = `${companyId}/${filename}`;

          // Upload to inventory_image bucket
          const uploadResult = await storageService.uploadImage(
            'inventory_image',
            filePath,
            imagePreview, // base64 data URL
            { upsert: false }
          );

          if (!uploadResult.success) {
            console.error(`❌ Image ${i + 1} upload failed:`, uploadResult.error);
            setNotification({
              isOpen: true,
              variant: 'error',
              message: `Failed to upload image ${i + 1}: ${uploadResult.error}`,
            });
            setIsSubmitting(false);
            return;
          }

          imageUrls.push(uploadResult.data!);
          console.log(`✅ Image ${i + 1} uploaded:`, uploadResult.data);
        } else {
          // This is an existing URL - keep it as is
          imageUrls.push(imagePreview);
          console.log(`✅ Image ${i + 1} kept (existing):`, imagePreview);
        }
      }

      console.log('✅ Final image URLs:', imageUrls);

      if (onSave) {
        // Convert string values to numbers before saving
        const dataToSave = {
          ...formData,
          currentStock: typeof formData.currentStock === 'string'
            ? parseInt(formData.currentStock) || 0
            : formData.currentStock,
          costPrice: typeof formData.costPrice === 'string'
            ? parseFloat(formData.costPrice) || 0
            : formData.costPrice,
          sellingPrice: typeof formData.sellingPrice === 'string'
            ? parseFloat(formData.sellingPrice) || 0
            : formData.sellingPrice,
          imageUrls: imageUrls, // Include uploaded image URLs (new + existing)
        };
        onSave(dataToSave);
      }

      setNotification({
        isOpen: true,
        variant: 'success',
        message: 'Product updated successfully!',
      });

      // Delay to show success message before closing
      setTimeout(() => {
        onClose();
      }, 1500);
    } catch (error) {
      console.error('Error updating product:', error);
      setNotification({
        isOpen: true,
        variant: 'error',
        message: error instanceof Error ? error.message : 'An error occurred. Please try again.',
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
    <div className={styles.modalOverlay} onClick={handleOverlayClick}>
      <div className={styles.modalContainer}>
        {/* Modal Header */}
        <div className={styles.modalHeader}>
          <div className={styles.modalTitleSection}>
            <h2 className={styles.modalTitle}>Product Details</h2>
            <p className={styles.modalSubtitle}>View and edit product information</p>
          </div>
          <button className={styles.closeButton} onClick={onClose}>
            <svg width="20" height="20" fill="currentColor" viewBox="0 0 24 24">
              <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
            </svg>
          </button>
        </div>

        {/* Modal Body */}
        <div className={styles.modalBody}>
          {/* Image Upload Section */}
          <div className={styles.section}>
            <h3 className={styles.sectionTitle}>Product Images</h3>
            <div className={styles.imageUploadContainer}>
              {/* Existing Images */}
              {imagePreviews.map((preview, index) => (
                <div key={index} className={styles.imagePreviewWrapper}>
                  <img
                    src={preview}
                    alt={`Product preview ${index + 1}`}
                    className={styles.imagePreview}
                  />
                  <button
                    className={styles.removeImageButton}
                    onClick={(e) => {
                      e.stopPropagation();
                      handleRemoveImage(index);
                    }}
                    type="button"
                  >
                    <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
                    </svg>
                  </button>
                </div>
              ))}

              {/* Add New Image Button (show only if less than MAX_IMAGES) */}
              {imagePreviews.length < MAX_IMAGES && (
                <div
                  className={styles.imagePreviewWrapper}
                  onClick={handleImageClick}
                  style={{ cursor: isCompressing ? 'wait' : 'pointer' }}
                >
                  <div className={styles.uploadPlaceholder}>
                    {isCompressing ? (
                      <>
                        <svg className={styles.uploadIcon} fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12" />
                        </svg>
                        <span className={styles.uploadText}>Compressing...</span>
                      </>
                    ) : (
                      <>
                        <svg className={styles.uploadIcon} fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                        </svg>
                        <span className={styles.uploadText}>Add Image</span>
                        <span className={styles.uploadHint}>{imagePreviews.length}/{MAX_IMAGES}</span>
                      </>
                    )}
                  </div>
                </div>
              )}
            </div>

            {/* Hidden File Input */}
            <input
              ref={fileInputRef}
              type="file"
              accept="image/jpeg,image/png,image/webp"
              onChange={handleImageSelect}
              className={styles.hiddenFileInput}
            />
          </div>

          {/* Product Information Section */}
          <div className={styles.section}>
            <h3 className={styles.sectionTitle}>Product Information</h3>
            <div className={styles.formGrid}>
              <div className={`${styles.formGroup} ${styles.formGroupFull}`}>
                <label className={styles.label}>Product Name</label>
                <input
                  type="text"
                  className={styles.input}
                  value={formData.productName}
                  onChange={(e) => handleInputChange('productName', e.target.value)}
                  placeholder="Enter product name"
                />
              </div>

              <div className={styles.formGroup}>
                <TossSelector
                  label="Category"
                  placeholder="Select category"
                  value={formData.category}
                  options={metadata?.categories.map((cat) => ({
                    value: cat.category_id,
                    label: cat.category_name,
                    description: cat.description,
                  })) || []}
                  onChange={(value) => handleInputChange('category', value)}
                  showAddButton={true}
                  addButtonText="Add category"
                  onAddClick={() => setIsAddCategoryModalOpen(true)}
                  showDescriptions={true}
                  fullWidth={true}
                />
              </div>

              <div className={styles.formGroup}>
                <TossSelector
                  label="Brand"
                  placeholder="Select brand"
                  value={formData.brand}
                  options={metadata?.brands.map((brand) => ({
                    value: brand.brand_id,
                    label: brand.brand_name,
                    description: brand.description,
                  })) || []}
                  onChange={(value) => handleInputChange('brand', value)}
                  showAddButton={true}
                  addButtonText="Add brand"
                  onAddClick={() => setIsAddBrandModalOpen(true)}
                  showDescriptions={true}
                  fullWidth={true}
                />
              </div>

              <div className={styles.formGroup}>
                <TossSelector
                  label="Product Type"
                  placeholder="Select product type"
                  value={formData.productType}
                  options={metadata?.product_types.map((type) => {
                    // Map Korean labels to English
                    let englishLabel = type.label;
                    if (type.value === 'commodity') englishLabel = 'Commodity';
                    if (type.value === 'bundle') englishLabel = 'Bundle/Set';
                    if (type.value === 'service') englishLabel = 'Service';

                    return {
                      value: type.value,
                      label: englishLabel,
                      description: type.description,
                    };
                  }) || []}
                  onChange={(value) => handleInputChange('productType', value)}
                  showDescriptions={true}
                  fullWidth={true}
                />
              </div>

              <div className={styles.formGroup}>
                <label className={styles.label}>Barcode</label>
                <input
                  type="text"
                  className={styles.input}
                  value={formData.barcode}
                  onChange={(e) => handleInputChange('barcode', e.target.value)}
                  placeholder="Enter barcode"
                />
              </div>

              <div className={styles.formGroup}>
                <label className={styles.label}>SKU</label>
                <input
                  type="text"
                  className={styles.input}
                  value={formData.sku}
                  onChange={(e) => handleInputChange('sku', e.target.value)}
                  placeholder="Enter SKU"
                />
              </div>
            </div>
          </div>

          {/* Stock Information Section */}
          <div className={styles.section}>
            <h3 className={styles.sectionTitle}>Stock Information</h3>
            <div className={styles.formGrid}>
              <div className={styles.formGroup}>
                <label className={styles.label}>Current Quantity</label>
                <input
                  type="number"
                  className={styles.input}
                  value={formData.currentStock}
                  onChange={(e) => handleInputChange('currentStock', e.target.value)}
                  placeholder="0"
                />
              </div>

              <div className={styles.formGroup}>
                <TossSelector
                  label="Unit"
                  placeholder="Select unit"
                  value={formData.unit}
                  options={metadata?.units.map((unit) => ({
                    value: unit.value,
                    label: `${unit.value} (${unit.symbol})`,
                    description: `${unit.value} - ${unit.symbol}`,
                  })) || []}
                  onChange={(value) => handleInputChange('unit', value)}
                  fullWidth={true}
                />
              </div>
            </div>
          </div>

          {/* Price Information Section */}
          <div className={styles.section}>
            <h3 className={styles.sectionTitle}>Price Information</h3>
            <div className={styles.formGrid}>
              <div className={styles.formGroup}>
                <label className={styles.label}>Cost Price</label>
                <input
                  type="number"
                  className={styles.input}
                  value={formData.costPrice}
                  onChange={(e) => handleInputChange('costPrice', e.target.value)}
                  placeholder="0"
                />
              </div>

              <div className={styles.formGroup}>
                <label className={styles.label}>Selling Price</label>
                <input
                  type="number"
                  className={styles.input}
                  value={formData.sellingPrice}
                  onChange={(e) => handleInputChange('sellingPrice', e.target.value)}
                  placeholder="0"
                />
              </div>
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
            onClick={handleSave}
            disabled={isSubmitting}
          >
            {isSubmitting ? 'Saving...' : 'Save Changes'}
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
          handleInputChange('brand', brand.brand_id);
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
          handleInputChange('category', category.category_id);
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
        zIndex={10000}
      />
    </div>
  );
};

export default ProductDetailsModal;
