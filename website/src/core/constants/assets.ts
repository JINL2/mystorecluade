/**
 * Asset Path Constants
 * Centralized asset path management for images, fonts, and icons
 *
 * @example
 * ```tsx
 * import { Images } from '@/core/constants/assets';
 *
 * <img src={Images.brandLogo} alt="Brand Logo" />
 * <img src={Images.appIcon} alt="App Icon" />
 * ```
 */

/**
 * Image asset paths
 * All images are located in /public/assets/images/
 * Accessed via absolute paths from public directory
 */
export const Images = {
  // App Icons
  appIcon: '/assets/images/app-icon.png',
  appIconTransparent: '/assets/images/app-icon-transparent.png',

  // Brand Logos
  brandLogo: '/assets/images/brand-logo.png',
  brandLogoTransparent: '/assets/images/brand-logo-transparent.png',
  storebaseLogo: '/assets/images/storebase-logo.png',

  // Splash
  splash: '/assets/images/splash.png',
} as const;

/**
 * Font asset paths
 * Custom fonts should be placed in /public/assets/fonts/
 */
export const Fonts = {
  // Add custom font paths here when needed
  // Example: customFont: '/assets/fonts/custom-font.woff2',
} as const;

/**
 * Icon asset paths
 * Custom icon files (SVG, PNG) should be placed in /public/assets/icons/
 * Note: For Font Awesome icons, use AppIcons from '@/core/constants/app-icons'
 */
export const Icons = {
  // Add custom icon paths here when needed
  // Example: customIcon: '/assets/icons/custom-icon.svg',
} as const;

/**
 * Asset helper utilities
 */
export const AssetUtils = {
  /**
   * Get full asset URL
   * Useful for dynamic asset loading or when base URL might change
   */
  getAssetUrl(path: string): string {
    return `${window.location.origin}${path}`;
  },

  /**
   * Preload image
   * Returns a promise that resolves when image is loaded
   */
  preloadImage(src: string): Promise<HTMLImageElement> {
    return new Promise((resolve, reject) => {
      const img = new Image();
      img.onload = () => resolve(img);
      img.onerror = reject;
      img.src = src;
    });
  },

  /**
   * Preload multiple images
   */
  async preloadImages(sources: string[]): Promise<HTMLImageElement[]> {
    return Promise.all(sources.map(src => this.preloadImage(src)));
  },

  /**
   * Check if image exists
   */
  async imageExists(src: string): Promise<boolean> {
    try {
      await this.preloadImage(src);
      return true;
    } catch {
      return false;
    }
  },
};

/**
 * Type-safe image names
 */
export type ImageName = keyof typeof Images;
export type FontName = keyof typeof Fonts;
export type IconName = keyof typeof Icons;

export default {
  Images,
  Fonts,
  Icons,
  AssetUtils,
};
