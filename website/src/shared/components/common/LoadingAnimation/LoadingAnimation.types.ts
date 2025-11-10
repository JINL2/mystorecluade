/**
 * LoadingAnimation Component Types
 */

export interface LoadingAnimationProps {
  /**
   * Size of the spinner
   * @default 'medium'
   */
  size?: 'small' | 'medium' | 'large';

  /**
   * Custom className for additional styling
   */
  className?: string;

  /**
   * Show in fullscreen mode (centered with min-height)
   * @default false
   */
  fullscreen?: boolean;
}
