/**
 * ProductImageUpload Component
 * Handles product image upload, compression, preview, and removal
 */

import React from 'react';
import type { ProductImageUploadProps } from './ProductImageUpload.types';
import styles from './ProductDetailsModal.module.css';

export const ProductImageUpload: React.FC<ProductImageUploadProps> = ({
  imagePreviews,
  compressionInfos,
  isCompressing,
  maxImages = 3,
  onImageSelect,
  onRemoveImage,
  onImageClick,
  fileInputRef,
}) => {
  return (
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
                onRemoveImage(index);
              }}
              type="button"
            >
              <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
              </svg>
            </button>
          </div>
        ))}

        {/* Add New Image Button (show only if less than maxImages) */}
        {imagePreviews.length < maxImages && (
          <div
            className={styles.imagePreviewWrapper}
            onClick={onImageClick}
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
                  <span className={styles.uploadHint}>{imagePreviews.length}/{maxImages}</span>
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
        onChange={onImageSelect}
        className={styles.hiddenFileInput}
      />
    </div>
  );
};
