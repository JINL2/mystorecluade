/**
 * ProductImageUpload Component Types
 */

import type { CompressedImageResult } from '@/core/utils/image-utils';

export interface ProductImageUploadProps {
  imagePreviews: string[];
  compressionInfos: CompressedImageResult[];
  isCompressing: boolean;
  maxImages?: number;
  onImageSelect: (event: React.ChangeEvent<HTMLInputElement>) => Promise<void>;
  onRemoveImage: (index: number) => void;
  onImageClick: () => void;
  fileInputRef: React.RefObject<HTMLInputElement>;
}
