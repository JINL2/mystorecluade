/**
 * TossSelector Component Types
 * Generic selector component with optional Add functionality
 */

export interface TossSelectorOption {
  value: string;
  label: string;
  description?: string;
  disabled?: boolean;
  badge?: string;        // Badge text (e.g., categoryTag)
  badgeColor?: string;   // Optional badge color
}

export interface TossSelectorProps {
  /**
   * Unique identifier for the selector
   */
  id?: string;

  /**
   * Name attribute for form submission
   */
  name?: string;

  /**
   * Label text displayed above the selector
   */
  label?: string;

  /**
   * Placeholder text when no option is selected
   */
  placeholder?: string;

  /**
   * Currently selected value
   */
  value: string;

  /**
   * Array of options to display
   */
  options: TossSelectorOption[];

  /**
   * Callback when selection changes
   */
  onChange: (value: string, option?: TossSelectorOption) => void;

  /**
   * Show "Add new" button at bottom of dropdown
   * @default false
   */
  showAddButton?: boolean;

  /**
   * Text for the "Add new" button
   * @default "Add new"
   */
  addButtonText?: string;

  /**
   * Callback when "Add new" button is clicked
   */
  onAddClick?: () => void;

  /**
   * Disable the selector
   * @default false
   */
  disabled?: boolean;

  /**
   * Show error state
   * @default false
   */
  error?: boolean;

  /**
   * Error message to display
   */
  errorMessage?: string;

  /**
   * Helper text to display below selector
   */
  helperText?: string;

  /**
   * Make the field required
   * @default false
   */
  required?: boolean;

  /**
   * Full width mode
   * @default false
   */
  fullWidth?: boolean;

  /**
   * Loading state (shows loading indicator)
   * @default false
   */
  loading?: boolean;

  /**
   * Custom CSS class name
   */
  className?: string;

  /**
   * Show search input for filtering options
   * @default false
   */
  searchable?: boolean;

  /**
   * Maximum height for dropdown menu
   * @default '300px'
   */
  maxHeight?: string;

  /**
   * Show option descriptions
   * @default false
   */
  showDescriptions?: boolean;

  /**
   * Empty state message when no options available
   */
  emptyMessage?: string;

  /**
   * Show badges on options
   * @default false
   */
  showBadges?: boolean;
}
