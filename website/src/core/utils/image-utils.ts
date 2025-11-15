/**
 * Image Utilities
 * Image compression and processing utilities
 */

/**
 * Image compression options
 */
export interface ImageCompressionOptions {
  /** Quality percentage (0-100), default 80 */
  quality?: number;
  /** Maximum width in pixels */
  maxWidth?: number;
  /** Maximum height in pixels */
  maxHeight?: number;
  /** Output format, default preserves original */
  format?: 'image/jpeg' | 'image/png' | 'image/webp';
}

/**
 * Compressed image result
 */
export interface CompressedImageResult {
  /** Compressed image as base64 data URL */
  dataUrl: string;
  /** Original file size in bytes */
  originalSize: number;
  /** Compressed file size in bytes */
  compressedSize: number;
  /** Compression ratio (0-1) */
  compressionRatio: number;
  /** Image width */
  width: number;
  /** Image height */
  height: number;
  /** Image format */
  format: string;
}

/**
 * Compress an image file
 *
 * @param file - Image file to compress
 * @param options - Compression options
 * @returns Promise with compressed image result
 *
 * @example
 * ```typescript
 * const result = await compressImage(file, { quality: 80 });
 * console.log('Compressed:', result.compressedSize, 'bytes');
 * console.log('Ratio:', result.compressionRatio);
 * ```
 */
export async function compressImage(
  file: File,
  options: ImageCompressionOptions = {}
): Promise<CompressedImageResult> {
  const {
    quality = 80,
    maxWidth = 2000,
    maxHeight = 2000,
    format,
  } = options;

  return new Promise((resolve, reject) => {
    // Validate file type
    if (!file.type.startsWith('image/')) {
      reject(new Error('File must be an image'));
      return;
    }

    const originalSize = file.size;
    const reader = new FileReader();

    reader.onload = (e) => {
      const img = new Image();

      img.onload = () => {
        try {
          // Calculate new dimensions while maintaining aspect ratio
          let { width, height } = img;

          if (width > maxWidth || height > maxHeight) {
            const aspectRatio = width / height;

            if (width > height) {
              width = maxWidth;
              height = width / aspectRatio;
            } else {
              height = maxHeight;
              width = height * aspectRatio;
            }
          }

          // Create canvas for compression
          const canvas = document.createElement('canvas');
          canvas.width = width;
          canvas.height = height;

          const ctx = canvas.getContext('2d');
          if (!ctx) {
            reject(new Error('Failed to get canvas context'));
            return;
          }

          // Draw image on canvas with compression
          ctx.drawImage(img, 0, 0, width, height);

          // Determine output format
          const outputFormat = format || (file.type as any) || 'image/jpeg';

          // Convert to compressed data URL
          const dataUrl = canvas.toDataURL(outputFormat, quality / 100);

          // Calculate compressed size (base64 to bytes)
          const compressedSize = Math.round((dataUrl.length * 3) / 4);
          const compressionRatio = compressedSize / originalSize;

          resolve({
            dataUrl,
            originalSize,
            compressedSize,
            compressionRatio,
            width: Math.round(width),
            height: Math.round(height),
            format: outputFormat,
          });
        } catch (error) {
          reject(new Error('Failed to compress image: ' + (error as Error).message));
        }
      };

      img.onerror = () => {
        reject(new Error('Failed to load image'));
      };

      img.src = e.target?.result as string;
    };

    reader.onerror = () => {
      reject(new Error('Failed to read file'));
    };

    reader.readAsDataURL(file);
  });
}

/**
 * Convert data URL to File object
 *
 * @param dataUrl - Base64 data URL
 * @param filename - Output filename
 * @returns File object
 */
export function dataUrlToFile(dataUrl: string, filename: string): File {
  const arr = dataUrl.split(',');
  const mime = arr[0].match(/:(.*?);/)?.[1] || 'image/jpeg';
  const bstr = atob(arr[1]);
  let n = bstr.length;
  const u8arr = new Uint8Array(n);

  while (n--) {
    u8arr[n] = bstr.charCodeAt(n);
  }

  return new File([u8arr], filename, { type: mime });
}

/**
 * Validate image file
 *
 * @param file - File to validate
 * @param options - Validation options
 * @returns Validation result
 */
export function validateImageFile(
  file: File,
  options: {
    maxSize?: number; // in bytes
    allowedTypes?: string[];
  } = {}
): { valid: boolean; error?: string } {
  const {
    maxSize = 10 * 1024 * 1024, // 10MB default
    allowedTypes = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'],
  } = options;

  // Check file type
  if (!allowedTypes.includes(file.type)) {
    return {
      valid: false,
      error: `Invalid file type. Allowed types: ${allowedTypes.join(', ')}`,
    };
  }

  // Check file size
  if (file.size > maxSize) {
    return {
      valid: false,
      error: `File size exceeds ${Math.round(maxSize / 1024 / 1024)}MB limit`,
    };
  }

  return { valid: true };
}

/**
 * Format file size to human-readable string
 *
 * @param bytes - File size in bytes
 * @returns Formatted string (e.g., "2.5 MB")
 */
export function formatFileSize(bytes: number): string {
  if (bytes === 0) return '0 Bytes';

  const k = 1024;
  const sizes = ['Bytes', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));

  return Math.round((bytes / Math.pow(k, i)) * 100) / 100 + ' ' + sizes[i];
}
