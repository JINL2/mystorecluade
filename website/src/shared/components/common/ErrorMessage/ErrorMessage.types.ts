/**
 * ErrorMessage Component Types (Toss Alert Dialog Style)
 * Center-positioned alert dialog with backdrop overlay
 */

export type ErrorMessageVariant = 'error' | 'warning' | 'info' | 'success';

export interface ErrorMessageProps {
  // Core props
  variant?: ErrorMessageVariant;
  title?: string;
  message: string;
  isOpen: boolean;
  onClose: () => void;

  // Button props
  confirmText?: string;
  cancelText?: string;
  showCancelButton?: boolean;
  onConfirm?: () => void;

  // Behavior props
  autoCloseDuration?: number;
  closeOnBackdropClick?: boolean;
  closeOnEscape?: boolean;
  className?: string;
  zIndex?: number;

  // Icon props
  icon?: React.ReactNode;
  showIcon?: boolean;

  // Style customization props - Dialog
  dialogWidth?: string;
  dialogMaxWidth?: string;
  dialogMinHeight?: string;
  dialogPadding?: string;
  dialogBackgroundColor?: string;
  dialogBorderRadius?: string;
  dialogBoxShadow?: string;

  // Style customization props - Backdrop
  backdropColor?: string;
  backdropOpacity?: number;

  // Style customization props - Title
  titleFontSize?: string;
  titleFontWeight?: string | number;
  titleColor?: string;
  titleMarginBottom?: string;

  // Style customization props - Message
  messageFontSize?: string;
  messageFontWeight?: string | number;
  messageColor?: string;
  messageLineHeight?: string | number;
  messageMarginBottom?: string;

  // Style customization props - Icon
  iconSize?: string;
  iconColor?: string;
  iconMarginBottom?: string;

  // Style customization props - Buttons
  buttonHeight?: string;
  buttonPadding?: string;
  buttonFontSize?: string;
  buttonFontWeight?: string | number;
  buttonBorderRadius?: string;
  buttonGap?: string;

  // Confirm button styles
  confirmButtonColor?: string;
  confirmButtonBackgroundColor?: string;
  confirmButtonHoverBackgroundColor?: string;

  // Cancel button styles
  cancelButtonColor?: string;
  cancelButtonBackgroundColor?: string;
  cancelButtonBorderColor?: string;
  cancelButtonHoverBackgroundColor?: string;

  // Animation
  animationDuration?: string;
}
