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
  });

  const [isAddBrandModalOpen, setIsAddBrandModalOpen] = useState(false);
  const [isAddCategoryModalOpen, setIsAddCategoryModalOpen] = useState(false);
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
      });

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

  const handleImageSelect = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (!file) return;

    const validation = validateImageFile(file);
    if (!validation.isValid) {
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
        maxSizeMB: 1,
        maxWidthOrHeight: 1920,
        useWebWorker: true,
      });

      setImagePreviews((prev) => [...prev, result.previewUrl]);
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

      if (!validationResult.can_edit) {
        setNotification({
          isOpen: true,
          variant: 'error',
          message: validationResult.message || 'Cannot edit this product',
        });
        setIsSubmitting(false);
        return;
      }

      const updatedData: any = {
        product_name: formData.productName,
        category_id: formData.category,
        brand_id: formData.brand,
        product_type: formData.productType,
        barcode: formData.barcode,
        sku: formData.sku,
        unit: formData.unit,
        cost_price: parseFloat(formData.costPrice.toString()) || 0,
        unit_price: parseFloat(formData.sellingPrice.toString()) || 0,
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
        }
      }

      if (imageUrls.length > 0) {
        updatedData.image_urls = imageUrls;
      }

      const originalData: any = {
        product_name: productData.productName,
        category_id: productData.categoryId,
        brand_id: productData.brandId,
        product_type: productData.productType,
        barcode: productData.barcode,
        sku: productData.sku || productData.productCode,
        unit: productData.unit,
        cost_price: productData.costPrice,
        unit_price: productData.unitPrice,
        image_urls: productData.imageUrls || [],
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
            onAddBrand={() => setIsAddBrandModalOpen(true)}
            onAddCategory={() => setIsAddCategoryModalOpen(true)}
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
