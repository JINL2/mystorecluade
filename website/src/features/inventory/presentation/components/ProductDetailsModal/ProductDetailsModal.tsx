/**
 * ProductDetailsModal Component
 * Orchestration component for product details editing modal
 *
 * Architecture: Orchestrates ProductImageUpload and ProductDetailsForm components
 */

import React, { useState, useEffect, useRef } from 'react';
import { TossButton } from '@/shared/components/toss/TossButton';
import { AddBrandModal } from '@/shared/components/modals/AddBrandModal';
import { AddCategoryModal } from '@/shared/components/modals/AddCategoryModal';
import { AddAttributeModal } from '@/shared/components/modals/AddAttributeModal';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { storageService } from '@/core/services/supabase_service';
import { compressImage, formatFileSize, validateImageFile } from '@/core/utils/image-utils';
import { useInventory } from '../../hooks/useInventory';
import { ProductImageUpload } from './ProductImageUpload';
import { ProductDetailsForm } from './ProductDetailsForm';
import type { ProductDetailsModalProps } from './ProductDetailsModal.types';
import type { ProductFormData } from './ProductDetailsForm.types';
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
  const { validateProductEdit } = useInventory();

  const [formData, setFormData] = useState<ProductFormData>({
    productName: '',
    category: '',
    brand: '',
    productType: 'Physical Product',
    barcode: '',
    sku: '',
    currentStock: '',
    unit: '',
    costPrice: '',
    sellingPrice: '',
    selectedAttributes: {},
  });

  const [isAddBrandModalOpen, setIsAddBrandModalOpen] = useState(false);
  const [isAddCategoryModalOpen, setIsAddCategoryModalOpen] = useState(false);
  const [isAddAttributeModalOpen, setIsAddAttributeModalOpen] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
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
      // Initialize selectedAttributes from variant info
      let initialAttributes: Record<string, string> = {};

      // If product has variant, find matching attribute option from metadata
      if (productData.variantId && productData.variantName && metadata?.attributes) {
        for (const attribute of metadata.attributes) {
          for (const option of attribute.options) {
            if (option.option_value === productData.variantName) {
              initialAttributes[attribute.attribute_id] = option.option_id;
              break;
            }
          }
          if (Object.keys(initialAttributes).length > 0) break;
        }
      }

      setFormData({
        productName: productData.productName || '',
        category: productData.categoryId || '',
        brand: productData.brandId || '',
        productType: productData.productType || 'commodity',
        barcode: productData.barcode || '',
        sku: productData.sku || productData.productCode || '',
        currentStock: productData.currentStock?.toString() || '',
        unit: productData.unit || '',
        costPrice: productData.costPrice?.toString() || '',
        sellingPrice: productData.unitPrice?.toString() || '',
        selectedAttributes: initialAttributes,
      });

      if (productData.imageUrls && Array.isArray(productData.imageUrls)) {
        setImagePreviews(productData.imageUrls);
      } else {
        setImagePreviews([]);
      }
      setCompressionInfos([]);
    }
  }, [productData, metadata]);

  const handleInputChange = (field: string, value: string | number) => {
    setFormData((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

  const handleAttributeChange = (attributeId: string, optionId: string) => {
    setFormData((prev) => {
      const newSelectedAttributes = { ...prev.selectedAttributes };

      if (optionId === '') {
        // Deselect - remove the attribute
        delete newSelectedAttributes[attributeId];
      } else if (optionId === '__selected__') {
        // Checkbox selection (no specific option yet) - clear others and select this one
        // Only keep this attribute selected
        Object.keys(newSelectedAttributes).forEach((key) => {
          if (key !== attributeId) {
            delete newSelectedAttributes[key];
          }
        });
        newSelectedAttributes[attributeId] = '__selected__';
      } else {
        // Specific option selected
        newSelectedAttributes[attributeId] = optionId;
      }

      return {
        ...prev,
        selectedAttributes: newSelectedAttributes,
      };
    });
  };

  const handleImageSelect = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (!file) return;

    const validation = validateImageFile(file);
    if (!validation.valid) {
      setNotification({
        isOpen: true,
        variant: 'error',
        message: validation.error || 'Invalid image file',
      });
      return;
    }

    setIsCompressing(true);

    try {
      const result = await compressImage(file, {
        quality: 80,
        maxWidth: 1920,
        maxHeight: 1920,
      });

      setImagePreviews((prev) => [...prev, result.dataUrl]);
      setCompressionInfos((prev) => [...prev, result]);
      setNotification({
        isOpen: true,
        variant: 'success',
        message: `Image compressed: ${formatFileSize(result.originalSize)} → ${formatFileSize(result.compressedSize)}`,
      });
    } catch (error) {
      setNotification({
        isOpen: true,
        variant: 'error',
        message: error instanceof Error ? error.message : 'Image compression failed',
      });
    } finally {
      setIsCompressing(false);
      if (fileInputRef.current) {
        fileInputRef.current.value = '';
      }
    }
  };

  const handleRemoveImage = (index: number) => {
    setImagePreviews((prev) => prev.filter((_, i) => i !== index));
    setCompressionInfos((prev) => prev.filter((_, i) => i !== index));
  };

  const handleImageClick = () => {
    if (!isCompressing && fileInputRef.current) {
      fileInputRef.current.click();
    }
  };

  const handleSave = async () => {
    if (!productData) return;

    setIsSubmitting(true);

    try {
      const validationResult = await validateProductEdit(productId, companyId);

      if (!validationResult.success) {
        setNotification({
          isOpen: true,
          variant: 'error',
          message: validationResult.error?.message || 'Cannot edit this product',
        });
        setIsSubmitting(false);
        return;
      }

      const updatedData: any = {
        productName: formData.productName,
        category: formData.category,
        brand: formData.brand,
        productType: formData.productType,
        barcode: formData.barcode,
        sku: formData.sku,
        unit: formData.unit,
        costPrice: parseFloat(formData.costPrice.toString()) || 0,
        sellingPrice: parseFloat(formData.sellingPrice.toString()) || 0,
        // v6 variant attributes
        selectedAttributes: formData.selectedAttributes,
        variantId: productData.variantId,
        // Pass metadata for variant creation (needed by datasource to get attribute options)
        metadata: metadata,
      };

      const imageUrls: string[] = [];

      for (let i = 0; i < imagePreviews.length; i++) {
        const preview = imagePreviews[i];
        const compressionInfo = compressionInfos[i];

        if (compressionInfo && compressionInfo.compressedFile) {
          const fileName = `product_${productId}_${Date.now()}_${i}.${compressionInfo.compressedFile.type.split('/')[1]}`;
          const uploadResult = await storageService.uploadFile(
            'product-images',
            fileName,
            compressionInfo.compressedFile
          );

          if (uploadResult.success && uploadResult.publicUrl) {
            imageUrls.push(uploadResult.publicUrl);
          }
        } else if (preview.startsWith('http')) {
          imageUrls.push(preview);
        } else if (preview.startsWith('{')) {
          // Handle JSON string format: {"url":"...","order":1,"caption":"..."}
          try {
            const parsed = JSON.parse(preview);
            if (parsed.url) {
              imageUrls.push(parsed.url);
            }
          } catch (e) {
            // Silently handle JSON parse errors
          }
        }
      }

      // Always set imageUrls (null if empty to indicate deletion)
      updatedData.imageUrls = imageUrls.length > 0 ? imageUrls : null;

      const originalData: any = {
        productName: productData.productName,
        categoryId: productData.categoryId,
        brandId: productData.brandId,
        productType: productData.productType,
        barcode: productData.barcode,
        sku: productData.sku || productData.productCode,
        unit: productData.unit,
        costPrice: productData.costPrice,
        unitPrice: productData.unitPrice,
        imageUrls: productData.imageUrls || [],
      };

      await onSave(updatedData, originalData);
      onClose();
    } catch (error) {
      setNotification({
        isOpen: true,
        variant: 'error',
        message: error instanceof Error ? error.message : 'Failed to save product',
      });
    } finally {
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
          <ProductImageUpload
            imagePreviews={imagePreviews}
            compressionInfos={compressionInfos}
            isCompressing={isCompressing}
            maxImages={MAX_IMAGES}
            onImageSelect={handleImageSelect}
            onRemoveImage={handleRemoveImage}
            onImageClick={handleImageClick}
            fileInputRef={fileInputRef}
          />

          <ProductDetailsForm
            formData={formData}
            metadata={metadata}
            onInputChange={handleInputChange}
            onAttributeChange={handleAttributeChange}
            onAddBrand={() => setIsAddBrandModalOpen(true)}
            onAddCategory={() => setIsAddCategoryModalOpen(true)}
            onAddAttribute={() => setIsAddAttributeModalOpen(true)}
            hasVariants={productData?.hasVariants}
            variantName={productData?.variantName}
          />
        </div>

        {/* Modal Footer */}
        <div className={styles.modalFooter}>
          <TossButton
            variant="outline"
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
            loading={isSubmitting}
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
        onBrandAdded={onMetadataRefresh}
      />

      {/* Add Category Modal */}
      <AddCategoryModal
        isOpen={isAddCategoryModalOpen}
        onClose={() => setIsAddCategoryModalOpen(false)}
        companyId={companyId}
        onCategoryAdded={onMetadataRefresh}
      />

      {/* Add Attribute Modal */}
      <AddAttributeModal
        isOpen={isAddAttributeModalOpen}
        onClose={() => setIsAddAttributeModalOpen(false)}
        companyId={companyId}
        onAttributeAdded={onMetadataRefresh}
      />

      {/* Notification */}
      <ErrorMessage
        isOpen={notification.isOpen}
        variant={notification.variant}
        message={notification.message}
        onClose={() => setNotification((prev) => ({ ...prev, isOpen: false }))}
        autoCloseDuration={3000}
        zIndex={10001}
      />
    </div>
  );
};
