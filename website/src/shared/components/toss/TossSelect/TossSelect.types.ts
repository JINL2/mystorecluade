/**
 * TossSelect Component Types
 */

export interface TossSelectOption {
  value: string;
  label: string;
}

export interface TossSelectProps {
  value: string;
  onChange: (event: React.ChangeEvent<HTMLSelectElement>) => void;
  options: TossSelectOption[];
  placeholder?: string;
  fullWidth?: boolean;
  disabled?: boolean;
  error?: string;
  label?: string;
}
