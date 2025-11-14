/**
 * ProductDetailsModal Component
 * Modal for viewing and editing product information
 */

import React, { useState, useEffect } from 'react';
import { TossButton } from '@/shared/components/toss/TossButton';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import { AddBrandModal } from '@/shared/components/modals/AddBrandModal';
import { AddCategoryModal } from '@/shared/components/modals/AddCategoryModal';
import type { TossSelectorOption } from '@/shared/components/selectors/TossSelector';
import type { ProductDetailsModalProps } from './ProductDetailsModal.types';
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
    }
  }, [productData]);

  const handleInputChange = (field: string, value: string | number) => {
    setFormData((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

  const handleSave = () => {
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
      };
      onSave(dataToSave);
    }
    onClose();
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
          >
            Cancel
          </TossButton>
          <TossButton
            variant="primary"
            size="md"
            onClick={handleSave}
          >
            Save Changes
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
    </div>
  );
};

export default ProductDetailsModal;
