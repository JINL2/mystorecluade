/**
 * SelectorModal Types
 * Toss-style clean selection modal
 */

export type SelectorModalVariant = 'info' | 'warning' | 'error' | 'success';

export interface SelectorOption {
  /** Unique identifier for the option */
  id: string;

  /** Display label for the option */
  label: string;

  /** Optional icon to display */
  icon?: React.ReactNode;

  /** Button style variant @default 'secondary' */
  variant?: 'primary' | 'secondary' | 'outline';

  /** Whether this option is disabled @default false */
  disabled?: boolean;
}

export interface SelectorModalProps {
  /** Whether the modal is open */
  isOpen: boolean;

  /** Callback when modal is closed */
  onClose: () => void;

  /** Callback when an option is selected */
  onSelect: (optionId: string) => void;

  /** Modal variant/style @default 'info' */
  variant?: SelectorModalVariant;

  /** Modal title */
  title: string;

  /** Optional icon (overrides default variant icon) */
  headerIcon?: React.ReactNode;

  /** Optional message below the title */
  message?: string;

  /** Array of options to display */
  options: SelectorOption[];

  /** Cancel button text @default 'Cancel' */
  cancelText?: string;

  /** Show cancel button @default true */
  showCancelButton?: boolean;

  /** Button layout - 'stacked' for vertical, 'row' for horizontal side-by-side @default 'stacked' */
  buttonLayout?: 'stacked' | 'row';

  /** Close on backdrop click @default true */
  closeOnBackdropClick?: boolean;

  /** Close on ESC key @default true */
  closeOnEscape?: boolean;

  /** Loading state @default false */
  isLoading?: boolean;

  /** z-index override @default 1000 */
  zIndex?: number;

  /** Additional className */
  className?: string;

  /** Custom content to render below options */
  children?: React.ReactNode;
}
