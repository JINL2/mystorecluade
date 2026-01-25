import React, { useState, useRef, useCallback } from 'react';
import styles from './ImageHoverPreview.module.css';

interface ImageHoverPreviewProps {
  src: string;
  alt: string;
  thumbnailClassName?: string;
  previewSize?: number;
  position?: 'right' | 'left';
}

export const ImageHoverPreview: React.FC<ImageHoverPreviewProps> = ({
  src,
  alt,
  thumbnailClassName,
  previewSize = 200,
  position = 'right',
}) => {
  const [isHovered, setIsHovered] = useState(false);
  const [previewPosition, setPreviewPosition] = useState({ top: 0, left: 0 });
  const containerRef = useRef<HTMLDivElement>(null);

  const handleMouseEnter = useCallback((e: React.MouseEvent) => {
    if (!containerRef.current) return;

    const rect = containerRef.current.getBoundingClientRect();
    const viewportWidth = window.innerWidth;
    const viewportHeight = window.innerHeight;

    let left: number;
    let top: number;

    // Calculate horizontal position
    if (position === 'right') {
      left = rect.right + 10;
      // If preview would overflow right edge, show on left instead
      if (left + previewSize > viewportWidth) {
        left = rect.left - previewSize - 10;
      }
    } else {
      left = rect.left - previewSize - 10;
      // If preview would overflow left edge, show on right instead
      if (left < 0) {
        left = rect.right + 10;
      }
    }

    // Calculate vertical position (center aligned with thumbnail)
    top = rect.top + rect.height / 2 - previewSize / 2;

    // Adjust if preview would overflow top
    if (top < 10) {
      top = 10;
    }

    // Adjust if preview would overflow bottom
    if (top + previewSize > viewportHeight - 10) {
      top = viewportHeight - previewSize - 10;
    }

    setPreviewPosition({ top, left });
    setIsHovered(true);
  }, [position, previewSize]);

  const handleMouseLeave = useCallback(() => {
    setIsHovered(false);
  }, []);

  return (
    <div
      ref={containerRef}
      className={styles.container}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
    >
      <img
        src={src}
        alt={alt}
        className={thumbnailClassName}
      />
      {isHovered && (
        <div
          className={styles.previewContainer}
          style={{
            top: previewPosition.top,
            left: previewPosition.left,
            width: previewSize,
            height: previewSize,
          }}
        >
          <img
            src={src}
            alt={`${alt} preview`}
            className={styles.previewImage}
          />
        </div>
      )}
    </div>
  );
};

export default ImageHoverPreview;
